#!/usr/bin/env python3
"""
Frida script: scan building actors for valid FBoxSphereBounds.
Finds which offset contains the bounds object.
"""
import frida
import sys

script_src = r"""
'use strict';

const kRootComponent = 0x260;
const kComponentToWorld = 0x1F0;
const kStaticMesh = 0x818;

function stripPAC(addr) {
    return ptr(addr).and(ptr("0xffffffffffff"));
}

function looksLikeVA(addr) {
    addr = ptr(addr);
    return addr.compare(ptr("0x100000000")) >= 0 &&
           addr.compare(ptr("0x4000000000")) < 0 &&
           (addr.toInt32() & 7) === 0;
}

function readVector3(p) {
    return {
        x: p.readFloat(),
        y: p.add(4).readFloat(),
        z: p.add(8).readFloat()
    };
}

function printVec(v) {
    return "(" + v.x.toFixed(1) + ", " + v.y.toFixed(1) + ", " + v.z.toFixed(1) + ")";
}

function className(obj) {
    try {
        var namePtr = obj.add(0x10).readPointer();
        if (looksLikeVA(namePtr)) {
            return namePtr.add(0xE).readCString();
        }
    } catch(e) {}
    return "???";
}

function checkBoundsAt(obj, baseOff, label) {
    try {
        var origin = readVector3(obj.add(baseOff));
        var extent = readVector3(obj.add(baseOff + 12));
        var sphereR = obj.add(baseOff + 24).readFloat();

        var valid = (
            extent.x >= 5.0 && extent.x <= 10000.0 &&
            extent.y >= 5.0 && extent.y <= 10000.0 &&
            extent.z >= 5.0 && extent.z <= 10000.0 &&
            isFinite(origin.x) && isFinite(origin.y) && isFinite(origin.z) &&
            origin.x > -10000.0 && origin.x < 10000.0 &&
            origin.y > -10000.0 && origin.y < 10000.0 &&
            origin.z > -10000.0 && origin.z < 10000.0 &&
            sphereR > 0 && sphereR < 20000.0
        );

        return {
            label: label,
            origin: origin,
            extent: extent,
            sphereR: sphereR,
            valid: valid
        };
    } catch(e) {
        return null;
    }
}

function scanAllOffsetsForBounds(comp, boundsOffset, maxOff) {
    var results = [];
    for (var o = 0; o <= maxOff; o += 8) {
        try {
            var ptrVal = stripPAC(comp.add(o).readPointer());
            if (!looksLikeVA(ptrVal)) continue;

            var b = checkBoundsAt(ptrVal, boundsOffset, "comp+" + o.toString(16) + " -> bounds@+" + boundsOffset.toString(16));
            if (b && b.valid) {
                results.push({
                    compOffset: o,
                    boundsOffset: boundsOffset,
                    ptrAddr: ptrVal.toString(),
                    origin: b.origin,
                    extent: b.extent,
                    sphereR: b.sphereR
                });
            }
        } catch(e) {}
    }
    return results;
}

function checkAllBoundsOffsets(obj, baseName) {
    var checkOffs = [0x30, 0x38, 0x40, 0x44, 0x50, 0x58, 0x60, 0x6C, 0x70];
    var results = [];
    for (var c = 0; c < checkOffs.length; c++) {
        var b = checkBoundsAt(obj, checkOffs[c], baseName + "+" + checkOffs[c].toString(16));
        if (b && b.valid) {
            results.push(b);
        }
    }
    return results;
}

function scanBuildingBounds() {
    var baseAddr = ptr(0x1009a4000);

    var gWorldPtr = stripPAC(baseAddr.add(0x10fd2fc78 - 0x100000000).readPointer());
    if (!looksLikeVA(gWorldPtr)) {
        console.log("ERROR: Cannot read gWorld");
        return;
    }
    var gWorld = gWorldPtr;
    console.log("gWorld: " + gWorld);

    var levelPtr = stripPAC(gWorld.add(0xB0).readPointer());
    if (!looksLikeVA(levelPtr)) {
        console.log("ERROR: Cannot read PersistentLevel");
        return;
    }
    console.log("Level: " + levelPtr);

    var actorArrayPtr = stripPAC(levelPtr.add(0xA0).readPointer());
    var actorCount = levelPtr.add(0xA0 + 8).readS32();
    if (!looksLikeVA(actorArrayPtr) || actorCount <= 0 || actorCount > 10000) {
        actorArrayPtr = stripPAC(levelPtr.add(0xD0).readPointer());
        actorCount = levelPtr.add(0xD0 + 8).readS32();
    }
    if (!looksLikeVA(actorArrayPtr) || actorCount <= 0 || actorCount > 10000) {
        console.log("ERROR: Cannot read actor array");
        return;
    }
    console.log("Actors: " + actorCount + " at " + actorArrayPtr);

    var buildingScanned = 0;
    var boundsFound = 0;

    for (var i = 0; i < actorCount && i < 315; i++) {
        try {
            var actor = stripPAC(actorArrayPtr.add(i * 8).readPointer());
            if (!looksLikeVA(actor)) continue;

            var name = className(actor);
            if (name.indexOf("PlayerPawn") >= 0 || name.indexOf("PlayerCharacter") >= 0 ||
                name.indexOf("VH_") >= 0 || name.indexOf("BP_VH_") >= 0) continue;

            var rootComp = stripPAC(actor.add(kRootComponent).readPointer());
            if (!looksLikeVA(rootComp)) continue;

            buildingScanned++;
            if (buildingScanned > 50) break;

            var txAddr = rootComp.add(kComponentToWorld);
            var pos = readVector3(txAddr.add(0x10));

            var staticMeshPtr = stripPAC(rootComp.add(kStaticMesh).readPointer());
            var hasSM = looksLikeVA(staticMeshPtr);

            console.log("\n--- Actor[" + i + "]: " + name + " ---");
            console.log("  RootComp: " + rootComp + " (" + className(rootComp) + ")");
            console.log("  Pos: " + printVec(pos));
            console.log("  SM@+0x818: " + staticMeshPtr + (hasSM ? " VALID" : " NULL"));

            if (hasSM) {
                var smBounds = checkAllBoundsOffsets(staticMeshPtr, "SM@" + staticMeshPtr);
                console.log("  SM bounds on mesh:");
                for (var si = 0; si < smBounds.length; si++) {
                    console.log("    " + smBounds[si].label + ": O=" + printVec(smBounds[si].origin) + " E=" + printVec(smBounds[si].extent) + " R=" + smBounds[si].sphereR.toFixed(1));
                }
                if (smBounds.length === 0) {
                    console.log("    (no valid bounds at any offset)");
                    console.log("    Dump first 160 bytes:");
                    var dump = "";
                    for (var d = 0; d < 160; d += 4) {
                        var f = staticMeshPtr.add(d).readFloat();
                        dump += "[" + d.toString(16) + "]" + f.toFixed(1) + " ";
                    }
                    console.log("    " + dump);
                }
            }

            var offsetHits = scanAllOffsetsForBounds(rootComp, 0x50, 0x1000);
            if (offsetHits.length > 0) {
                console.log("  BOUNDS POINTERS ON COMP (at +0x50 of target):");
                for (var hi = 0; hi < offsetHits.length; hi++) {
                    var h = offsetHits[hi];
                    console.log("    comp+" + h.compOffset.toString(16) + " -> " + h.ptrAddr + " O=" + printVec(h.origin) + " E=" + printVec(h.extent) + " R=" + h.sphereR.toFixed(1));
                }
                boundsFound++;
            }

            var actorHits = scanAllOffsetsForBounds(actor, 0x50, 0x400);
            if (actorHits.length > 0) {
                console.log("  BOUNDS POINTERS ON ACTOR:");
                for (var hi = 0; hi < actorHits.length; hi++) {
                    var h = actorHits[hi];
                    console.log("    actor+" + h.compOffset.toString(16) + " -> " + h.ptrAddr);
                }
            }

        } catch(e) {
            console.log("  Error at actor " + i + ": " + e);
        }
    }

    console.log("\n========== SUMMARY ==========");
    console.log("Buildings scanned: " + buildingScanned);
    console.log("Components with bounds refs: " + boundsFound);
}

scanBuildingBounds();
"""

try:
    dev = frida.get_usb_device()
    print("USB device found!")
    session = dev.attach("ShadowTrackerExtra")
    print("Attached to ShadowTrackerExtra!")
    script = session.create_script(script_src)
    script.load()
    input("Press Enter to exit...")
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
