#!/usr/bin/env python3
"""
Frida script v2: Find FBoxSphereBounds on components and actors directly.
Scan for valid bounds patterns in memory, independent of offsets.
"""
import frida
import sys

script_src = r"""
'use strict';

function stripPAC(addr) {
    return ptr(addr).and(ptr("0xffffffffffff"));
}

function looksLikeVA(addr) {
    addr = ptr(addr);
    return addr.compare(ptr("0x100000000")) >= 0 &&
           addr.compare(ptr("0x4000000000")) < 0 &&
           (addr.toInt32() & 7) === 0;
}

function readVec3(p) {
    return {x: p.readFloat(), y: p.add(4).readFloat(), z: p.add(8).readFloat()};
}

function pv(v) {
    return "(" + v.x.toFixed(1) + ", " + v.y.toFixed(1) + ", " + v.z.toFixed(1) + ")";
}

function isFiniteNum(n) {
    return isFinite(n) && !isNaN(n);
}

function isValidBoxExtent(e) {
    return e.x >= 5.0 && e.x <= 10000.0 &&
           e.y >= 5.0 && e.y <= 10000.0 &&
           e.z >= 5.0 && e.z <= 10000.0;
}

function isValidOrigin(o) {
    return isFiniteNum(o.x) && isFiniteNum(o.y) && isFiniteNum(o.z) &&
           o.x > -10000.0 && o.x < 10000.0 &&
           o.y > -10000.0 && o.y < 10000.0 &&
           o.z > -10000.0 && o.z < 10000.0;
}

function isValidBounds(o, e, s) {
    return isValidOrigin(o) && isValidBoxExtent(e) && s > 0 && s < 20000.0;
}

function checkFBox(obj, off) {
    try {
        var o = readVec3(obj.add(off));
        var e = readVec3(obj.add(off + 12));
        var s = obj.add(off + 24).readFloat();
        return {origin: o, extent: e, sphereR: s, valid: isValidBounds(o, e, s)};
    } catch(ex) { return null; }
}

// ========== MAIN ==========
var base = ptr(0x1009a4000);
var gWorld = stripPAC(base.add(0x10fd2fc78 - 0x100000000).readPointer());
if (!looksLikeVA(gWorld)) { console.log("FAIL: gWorld"); }

var level = stripPAC(gWorld.add(0xB0).readPointer());
if (!looksLikeVA(level)) { console.log("FAIL: level"); }

var actors = stripPAC(level.add(0xA0).readPointer());
var nActors = level.add(0xA0 + 8).readS32();
if (!looksLikeVA(actors) || nActors <= 0) {
    actors = stripPAC(level.add(0xD0).readPointer());
    nActors = level.add(0xD0 + 8).readS32();
}
console.log("gWorld=" + gWorld + " Level=" + level + " Actors=" + nActors);

// Bounds offsets to check everywhere
var boundsCheckOffsets = [0x30, 0x38, 0x40, 0x44, 0x50, 0x58, 0x60, 0x68, 0x6C, 0x70, 0x78, 0x80, 0x88, 0x90];

// For each non-player actor, scan:
// 1. The actor itself for embedded FBoxSphereBounds at various offsets
// 2. The RootComponent itself for embedded FBoxSphereBounds
// 3. The RootComponent's pointer fields for objects containing FBoxSphereBounds
// 4. Different offsets for UStaticMesh* (try 0x800-0x880 range)

var compBoundsCount = 0;
var ptrChainCount = 0;

for (var i = 0; i < nActors && i < 315; i++) {
    try {
        var actor = stripPAC(actors.add(i * 8).readPointer());
        if (!looksLikeVA(actor)) continue;

        // Try reading FName with a different offset (0x18 may be wrong, try 0x20 and nearby)
        var nameReadable = false;
        for (var fnOff = 0x10; fnOff <= 0x28; fnOff += 4) {
            try {
                var nameIdx = actor.add(fnOff).readS32();
                if (nameIdx > 0 && nameIdx < 2000000) { nameReadable = true; break; }
            } catch(e) {}
        }

        var rootComp = stripPAC(actor.add(0x260).readPointer());
        if (!looksLikeVA(rootComp)) continue;

        // Get component position
        var pos = readVec3(rootComp.add(0x1F0 + 0x10));

        // Skip things at origin (not real buildings)
        if (Math.abs(pos.x) < 100 && Math.abs(pos.y) < 100) continue;

        // ===== STRATEGY 1: Check bounds directly on RootComponent =====
        var compBounds = [];
        for (var b = 0; b < boundsCheckOffsets.length; b++) {
            var off = boundsCheckOffsets[b];
            var chk = checkFBox(rootComp, off);
            if (chk && chk.valid) {
                compBounds.push({off: off, origin: chk.origin, extent: chk.extent, sphereR: chk.sphereR});
            }
        }

        // ===== STRATEGY 2: Check ROOTCOMP + large offsets for embedded bounds =====
        // In UE4, component bounds could be anywhere from +0x100 to +0x800
        for (var bigOff = 0x100; bigOff <= 0x900; bigOff += 4) {
            var chk = checkFBox(rootComp, bigOff);
            if (chk && chk.valid) {
                compBounds.push({off: bigOff, origin: chk.origin, extent: chk.extent, sphereR: chk.sphereR});
            }
        }

        // ===== STRATEGY 3: Scan rootComp pointers for objects with bounds =====
        var ptrHits = [];
        for (var po = 0; po <= 0x1000; po += 8) {
            try {
                var ptrVal = stripPAC(rootComp.add(po).readPointer());
                if (!looksLikeVA(ptrVal)) continue;
                // Skip things that point near the component itself
                if (ptrVal.compare(rootComp) >= 0 && ptrVal.compare(rootComp.add(0x2000)) < 0) continue;
                // Skip too-high addresses
                if (ptrVal.compare(ptr("0x2000000000")) >= 0) continue;

                for (var b = 0; b < boundsCheckOffsets.length; b++) {
                    var off = boundsCheckOffsets[b];
                    var chk = checkFBox(ptrVal, off);
                    if (chk && chk.valid) {
                        // Verify: extent should be proportional to what we expect for a building
                        var maxE = Math.max(chk.extent.x, chk.extent.y, chk.extent.z);
                        var minE = Math.min(chk.extent.x, chk.extent.y, chk.extent.z);
                        if (maxE > 20 && minE > 5 && maxE / minE < 20) { // reasonable aspect ratio
                            ptrHits.push({
                                compOff: po,
                                targetOff: off,
                                ptrAddr: ptrVal.toString(),
                                origin: chk.origin,
                                extent: chk.extent,
                                sphereR: chk.sphereR
                            });
                        }
                    }
                }
            } catch(e) {}
        }

        if (compBounds.length > 0 || ptrHits.length > 0) {
            console.log("\n=== Actor[" + i + "] Pos=" + pv(pos) + " ===");
            console.log("  RootComp=" + rootComp);

            if (compBounds.length > 0) {
                console.log("  EMBEDDED BOUNDS ON COMPONENT:");
                for (var c = 0; c < compBounds.length; c++) {
                    var h = compBounds[c];
                    console.log("    +" + h.off.toString(16) + ": O=" + pv(h.origin) + " E=" + pv(h.extent) + " R=" + h.sphereR.toFixed(1));
                }
            }
            if (ptrHits.length > 0) {
                console.log("  POINTER CHAIN BOUNDS:");
                for (var c = 0; c < ptrHits.length; c++) {
                    var h = ptrHits[c];
                    console.log("    comp+" + h.compOff.toString(16) + " -> " + h.ptrAddr + " +" + h.targetOff.toString(16) + ": O=" + pv(h.origin) + " E=" + pv(h.extent) + " R=" + h.sphereR.toFixed(1));
                }
                ptrChainCount++;
            }
            compBoundsCount += compBounds.length;
        }
    } catch(e) {
        // skip
    }
}

console.log("\n========== SUMMARY ==========");
console.log("Components with embedded bounds: reported above");
console.log("Pointer chain hits: " + ptrChainCount);
"""

try:
    dev = frida.get_usb_device()
    print("USB device found!")
    session = dev.attach("ShadowTrackerExtra")
    print("Attached. Running scan...")
    script = session.create_script(script_src)
    script.load()
    input("Press Enter to exit...")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
