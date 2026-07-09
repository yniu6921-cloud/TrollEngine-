#ifndef RuntimeWorldResolver_hpp
#define RuntimeWorldResolver_hpp

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <string>
#include "OffsetsTool.hpp"
#include "KFD.hpp"

struct RuntimeWorldProbeResult {
    uint64_t resolvedUWorldOffset = 0;
    uint64_t gWorld = 0;
    uint64_t level = 0;
    uint64_t actorArray = 0;
    int actorCount = 0;
    const char *levelSource = "none";
    const char *actorArraySource = "none";
    const char *layoutName = "none";
    const char *worldSource = "none";
    uint64_t scannedFieldOffset = 0;
    bool usedAutoScan = false;
};

struct RuntimeWorldLayout {
    uint32_t persistentLevel;
    uint32_t currentLevel;
    uint32_t pendingVisibilityLevel;
    uint32_t activeLevelActors;
    uint32_t gameState;
    uint32_t levels;
    uint32_t levelActorList;
    uint32_t levelActorCluster;
    uint32_t levelActorContainerActors;
    const char *name;
};

static inline const RuntimeWorldLayout& CurrentRuntimeWorldLayout() {
    static const RuntimeWorldLayout layout = {
        (uint32_t)kPersistentLevel,
        (uint32_t)kCurrentLevel,
        (uint32_t)kCurrentLevelPendingVisibility,
        (uint32_t)kActiveLevelActors,
        (uint32_t)kGameState,
        (uint32_t)kLevels,
        (uint32_t)kActorList,
        (uint32_t)kActorCluster,
        (uint32_t)kLevelActorContainerActors,
        "Current"
    };
    return layout;
}

static inline const RuntimeWorldLayout* RuntimeWorldLayouts(size_t *outCount = nullptr) {
    static const RuntimeWorldLayout layouts[] = {
        { 0x0B8, 0x0B08, 0x148, 0x0AA8, 0x0AC8, 0x0AE0, 0x0A0, 0x0E0, 0x028, "SDK_2026" },
        { 0x0B0, 0x0B00, 0x140, 0x0AA0, 0x0AC0, 0x0AD8, 0x0A0, 0x0E0, 0x028, "LegacyMinus8" },
        { (uint32_t)kPersistentLevel,
          (uint32_t)kCurrentLevel,
          (uint32_t)kCurrentLevelPendingVisibility,
          (uint32_t)kActiveLevelActors,
          (uint32_t)kGameState,
          (uint32_t)kLevels,
          (uint32_t)kActorList,
          (uint32_t)kActorCluster,
          (uint32_t)kLevelActorContainerActors,
          "Macro" },
    };
    if (outCount) {
        *outCount = sizeof(layouts) / sizeof(layouts[0]);
    }
    return layouts;
}

static inline const RuntimeWorldLayout* FindRuntimeWorldLayoutByName(const char *name) {
    size_t layoutCount = 0;
    const RuntimeWorldLayout *layouts = RuntimeWorldLayouts(&layoutCount);
    if (!name || !name[0]) {
        return &layouts[0];
    }
    for (size_t i = 0; i < layoutCount; ++i) {
        if (layouts[i].name && strcmp(layouts[i].name, name) == 0) {
            return &layouts[i];
        }
    }
    return &layouts[0];
}

static inline std::string RuntimeWorldProbeSourceString(const RuntimeWorldProbeResult &probe) {
    const char *actor = (probe.actorArraySource && probe.actorArraySource[0]) ? probe.actorArraySource : "none";
    const char *layout = (probe.layoutName && probe.layoutName[0]) ? probe.layoutName : "none";
    const char *world = (probe.worldSource && probe.worldSource[0]) ? probe.worldSource : "none";
    char buffer[160];
    if (probe.scannedFieldOffset != 0) {
        snprintf(buffer, sizeof(buffer), "%s/%s/%s+0x%llx",
                 actor,
                 layout,
                 world,
                 (unsigned long long)probe.scannedFieldOffset);
    } else {
        snprintf(buffer, sizeof(buffer), "%s/%s/%s", actor, layout, world);
    }
    return std::string(buffer);
}

static inline int ComputeWorldProbeScore(const RuntimeWorldProbeResult &probe) {
    int score = probe.actorCount;
    if (probe.level != 0) {
        score += 20000;
    }
    if (probe.actorArraySource && strcmp(probe.actorArraySource, "ActiveLevelActors") == 0) {
        score += 5000;
    }
    if (probe.actorCount >= 128) {
        score += 4000;
    } else if (probe.actorCount >= 64) {
        score += 1500;
    } else if (probe.actorCount > 0) {
        score += 250;
    }
    if (probe.layoutName && strcmp(probe.layoutName, "SDK_2026") == 0) {
        score += 800;
    }
    if (probe.worldSource && strcmp(probe.worldSource, "Direct") == 0) {
        score += 500;
    } else if (probe.worldSource && strstr(probe.worldSource, "Field") != nullptr) {
        score += 250;
    }
    return score;
}

static inline uint64_t StripRuntimePAC(uint64_t value) {
    return value & 0x0000FFFFFFFFFFFFULL;
}

static inline bool LooksLikeUserVA(uint64_t value) {
    value = StripRuntimePAC(value);
    return value >= 0x100000000ULL && value < 0x4000000000ULL && (value & 0x7ULL) == 0;
}

static inline bool LooksLikeTArray(uint64_t arrayPtr, int count, int maxCount) {
    return LooksLikeUserVA(arrayPtr) && count > 0 && count <= maxCount;
}

static inline bool TryReadPointer(uint64_t address, uint64_t *outValue = nullptr) {
    if (outValue) *outValue = 0;
    address = StripRuntimePAC(address);
    if (!LooksLikeUserVA(address)) {
        return false;
    }
    uint64_t value = StripRuntimePAC(KFD::Read<uint64_t>(address));
    if (outValue) *outValue = value;
    return LooksLikeUserVA(value);
}

static inline uint64_t ResolveRuntimeHintVA(uint64_t baseAddr, uint64_t hint) {
    hint = StripRuntimePAC(hint);
    if (hint == 0) {
        return 0;
    }

    if (LooksLikeUserVA(baseAddr)) {
        // IDA / Mach-O image VAs are commonly recorded against the unslid
        // 0x100000000 image base. Convert them to the current slid runtime VA.
        if (hint >= 0x100000000ULL && hint < 0x200000000ULL) {
            uint64_t imageOffset = hint - 0x100000000ULL;
            uint64_t slidVA = StripRuntimePAC(baseAddr + imageOffset);
            if (LooksLikeUserVA(slidVA)) {
                return slidVA;
            }
        }

        if (hint < 0x100000000ULL) {
            uint64_t relativeVA = StripRuntimePAC(baseAddr + hint);
            if (LooksLikeUserVA(relativeVA)) {
                return relativeVA;
            }
        }
    }

    if (LooksLikeUserVA(hint)) {
        return hint;
    }

    return 0;
}

static inline bool ResolveActorArrayFromLevelCandidate(uint64_t level,
                                                       uint64_t *outActorArray = nullptr,
                                                       int *outActorCount = nullptr,
                                                       uint64_t *outActorCluster = nullptr,
                                                       const RuntimeWorldLayout *layout = nullptr) {
    if (outActorArray) *outActorArray = 0;
    if (outActorCount) *outActorCount = 0;
    if (outActorCluster) *outActorCluster = 0;

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    level = StripRuntimePAC(level);
    if (!LooksLikeUserVA(level)) {
        return false;
    }

    uint64_t bestActorArray = 0;
    int bestActorCount = 0;

    uint64_t directActorArray = StripRuntimePAC(KFD::Read<uint64_t>(level + activeLayout.levelActorList));
    int directActorCount = KFD::Read<int>(level + activeLayout.levelActorList + 0x8);
    if (LooksLikeTArray(directActorArray, directActorCount, 10000)) {
        bestActorArray = directActorArray;
        bestActorCount = directActorCount;
    }

    uint64_t actorCluster = StripRuntimePAC(KFD::Read<uint64_t>(level + activeLayout.levelActorCluster));
    if (outActorCluster) *outActorCluster = actorCluster;
    if (LooksLikeUserVA(actorCluster)) {
        uint64_t clusterActorArray = StripRuntimePAC(KFD::Read<uint64_t>(actorCluster + activeLayout.levelActorContainerActors));
        int clusterActorCount = KFD::Read<int>(actorCluster + activeLayout.levelActorContainerActors + 0x8);
        if (LooksLikeTArray(clusterActorArray, clusterActorCount, 10000) &&
            clusterActorCount > bestActorCount) {
            bestActorArray = clusterActorArray;
            bestActorCount = clusterActorCount;
        }
    }

    const uint32_t extraTArrayOffsets[] = { 0xA0, 0x98, 0x90, 0x88, 0x80, 0x78, 0x70, 0x68 };
    for (uint32_t actorsOffset : extraTArrayOffsets) {
        if (actorsOffset == activeLayout.levelActorList) {
            continue;
        }
        uint64_t candidateArray = StripRuntimePAC(KFD::Read<uint64_t>(level + actorsOffset));
        int candidateCount = KFD::Read<int>(level + actorsOffset + 0x8);
        if (LooksLikeTArray(candidateArray, candidateCount, 10000) && candidateCount > bestActorCount) {
            bestActorArray = candidateArray;
            bestActorCount = candidateCount;
        }
    }

    if (outActorArray) *outActorArray = bestActorArray;
    if (outActorCount) *outActorCount = bestActorCount;
    return LooksLikeTArray(bestActorArray, bestActorCount, 10000);
}

static inline bool ResolveActorArrayFromWorld(uint64_t gWorld,
                                              uint64_t *outActorArray = nullptr,
                                              int *outActorCount = nullptr,
                                              const RuntimeWorldLayout *layout = nullptr) {
    if (outActorArray) *outActorArray = 0;
    if (outActorCount) *outActorCount = 0;

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return false;
    }

    uint64_t actorArray = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.activeLevelActors));
    int actorCount = KFD::Read<int>(gWorld + activeLayout.activeLevelActors + 0x8);
    if (outActorArray) *outActorArray = actorArray;
    if (outActorCount) *outActorCount = actorCount;

    return LooksLikeTArray(actorArray, actorCount, 10000);
}

static inline bool ResolveLevelsArrayFromWorld(uint64_t gWorld,
                                               uint64_t *outLevelsArray = nullptr,
                                               int *outLevelsCount = nullptr,
                                               const RuntimeWorldLayout *layout = nullptr) {
    if (outLevelsArray) *outLevelsArray = 0;
    if (outLevelsCount) *outLevelsCount = 0;

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return false;
    }

    uint64_t levelsArray = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.levels));
    int levelsCount = KFD::Read<int>(gWorld + activeLayout.levels + 0x8);
    if (outLevelsArray) *outLevelsArray = levelsArray;
    if (outLevelsCount) *outLevelsCount = levelsCount;

    return LooksLikeTArray(levelsArray, levelsCount, 256);
}

static inline bool ProbeWorldCandidateWithLayout(uint64_t gWorld,
                                                 const RuntimeWorldLayout &layout,
                                                 RuntimeWorldProbeResult *out = nullptr) {
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return false;
    }

    uint64_t gameState = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.gameState));
    if (!LooksLikeUserVA(gameState)) {
        uint64_t worldActorArray = 0;
        int worldActorCount = 0;
        if (!ResolveActorArrayFromWorld(gWorld, &worldActorArray, &worldActorCount, &layout) || worldActorCount < 16) {
            return false;
        }
    }

    const struct {
        uint64_t level;
        const char *source;
    } levelCandidates[] = {
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.persistentLevel)), "Persistent" },
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.currentLevel)), "Current" },
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.pendingVisibilityLevel)), "Pending" },
    };

    RuntimeWorldProbeResult bestResult = {};
    int bestScore = -1;

    for (const auto &candidate : levelCandidates) {
        uint64_t actorArray = 0;
        uint64_t actorCluster = 0;
        int actorCount = 0;
        if (!ResolveActorArrayFromLevelCandidate(candidate.level, &actorArray, &actorCount, &actorCluster, &layout)) {
            continue;
        }

        RuntimeWorldProbeResult candidateResult;
        candidateResult.gWorld = gWorld;
        candidateResult.level = StripRuntimePAC(candidate.level);
        candidateResult.actorArray = actorArray;
        candidateResult.actorCount = actorCount;
        candidateResult.levelSource = candidate.source;
        candidateResult.actorArraySource = "LevelActorContainer";
        candidateResult.layoutName = layout.name;
        int score = ComputeWorldProbeScore(candidateResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = candidateResult;
        }
    }

    uint64_t levelsArray = 0;
    int levelsCount = 0;
    if (ResolveLevelsArrayFromWorld(gWorld, &levelsArray, &levelsCount, &layout)) {
        int scanLevels = levelsCount > 128 ? 128 : levelsCount;
        for (int i = 0; i < scanLevels; ++i) {
            uint64_t level = StripRuntimePAC(KFD::Read<uint64_t>(levelsArray + (uint64_t)i * 0x8));
            uint64_t actorArray = 0;
            uint64_t actorCluster = 0;
            int actorCount = 0;
            if (!ResolveActorArrayFromLevelCandidate(level, &actorArray, &actorCount, &actorCluster, &layout)) {
                continue;
            }

            RuntimeWorldProbeResult candidateResult;
            candidateResult.gWorld = gWorld;
            candidateResult.level = level;
            candidateResult.actorArray = actorArray;
            candidateResult.actorCount = actorCount;
            candidateResult.levelSource = "LevelsArray";
            candidateResult.actorArraySource = "LevelActorContainer";
            candidateResult.layoutName = layout.name;
            int score = ComputeWorldProbeScore(candidateResult);
            if (score > bestScore) {
                bestScore = score;
                bestResult = candidateResult;
            }
        }
    }

    uint64_t worldActorArray = 0;
    int worldActorCount = 0;
    if (ResolveActorArrayFromWorld(gWorld, &worldActorArray, &worldActorCount, &layout) && worldActorCount >= 16) {
        RuntimeWorldProbeResult candidateResult;
        candidateResult.gWorld = gWorld;
        candidateResult.level = bestResult.level;
        candidateResult.actorArray = worldActorArray;
        candidateResult.actorCount = worldActorCount;
        candidateResult.levelSource = bestResult.levelSource ? bestResult.levelSource : "WorldActive";
        candidateResult.actorArraySource = "ActiveLevelActors";
        candidateResult.layoutName = layout.name;
        int score = ComputeWorldProbeScore(candidateResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = candidateResult;
        }
    }

    if (bestScore < 0) {
        return false;
    }

    if (out) {
        *out = bestResult;
    }
    return true;
}

static inline bool ProbeWorldCandidate(uint64_t gWorld, RuntimeWorldProbeResult *out = nullptr) {
    size_t layoutCount = 0;
    const RuntimeWorldLayout *layouts = RuntimeWorldLayouts(&layoutCount);
    RuntimeWorldProbeResult bestResult = {};
    int bestScore = -1;

    for (size_t i = 0; i < layoutCount; ++i) {
        RuntimeWorldProbeResult candidateResult;
        if (!ProbeWorldCandidateWithLayout(gWorld, layouts[i], &candidateResult)) {
            continue;
        }
        int score = ComputeWorldProbeScore(candidateResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = candidateResult;
        }
    }

    if (bestScore < 0) {
        return false;
    }
    if (out) {
        *out = bestResult;
    }
    return true;
}

static inline bool ProbeWorldOrWrapperCandidate(uint64_t candidate,
                                                RuntimeWorldProbeResult *out = nullptr,
                                                const char *source = "Direct",
                                                uint64_t scannedFieldOffset = 0) {
    candidate = StripRuntimePAC(candidate);
    if (!LooksLikeUserVA(candidate)) {
        return false;
    }

    RuntimeWorldProbeResult bestResult = {};
    int bestScore = -1;

    RuntimeWorldProbeResult directResult;
    if (ProbeWorldCandidate(candidate, &directResult)) {
        directResult.worldSource = source ? source : "Direct";
        directResult.scannedFieldOffset = scannedFieldOffset;
        int score = ComputeWorldProbeScore(directResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = directResult;
        }
    }

    const uint32_t preferredOffsets[] = {
        0x0, 0x8, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38,
        0x40, 0x48, 0x50, 0x58, 0x60, 0x68, 0x70, 0x78,
        0x80, 0x88, 0x90, 0x98, 0xA0, 0xA8, 0xB0, 0xB8,
        0xC0, 0xC8, 0xD0, 0xD8, 0xE0, 0xE8, 0xF0, 0xF8,
        0x100, 0x108, 0x110, 0x118, 0x120, 0x128, 0x130, 0x138,
        0x140, 0x148, 0x150, 0x158, 0x160, 0x168, 0x170, 0x178,
        0x180, 0x188, 0x190, 0x198, 0x1A0, 0x1A8, 0x1B0, 0x1B8,
        0x1C0, 0x1C8, 0x1D0, 0x1D8, 0x1E0, 0x1E8, 0x1F0, 0x1F8,
        0x200, 0x208, 0x210, 0x218, 0x220, 0x228, 0x230, 0x238,
        0x240, 0x248, 0x250, 0x258, 0x260, 0x268, 0x270, 0x278,
        0x280, 0x288, 0x290, 0x298, 0x2A0, 0x2A8, 0x2B0, 0x2B8,
        0x2C0, 0x2C8, 0x2D0, 0x2D8, 0x2E0, 0x2E8, 0x2F0, 0x2F8,
        0x300, 0x308, 0x310, 0x318, 0x320, 0x328, 0x330, 0x338,
        0x340, 0x348, 0x350, 0x358, 0x360, 0x368, 0x370, 0x378,
        0x380, 0x388, 0x390, 0x398, 0x3A0, 0x3A8, 0x3B0, 0x3B8,
        0x3C0, 0x3C8, 0x3D0, 0x3D8, 0x3E0, 0x3E8, 0x3F0, 0x3F8,
        0x400
    };

    for (uint32_t fieldOffset : preferredOffsets) {
        uint64_t nestedWorld = 0;
        if (!TryReadPointer(candidate + fieldOffset, &nestedWorld) || nestedWorld == candidate) {
            continue;
        }

        RuntimeWorldProbeResult nestedResult;
        if (!ProbeWorldCandidate(nestedWorld, &nestedResult)) {
            continue;
        }
        nestedResult.worldSource = (fieldOffset == 0) ? "Field0" : "FieldScan";
        nestedResult.scannedFieldOffset = fieldOffset;
        int score = ComputeWorldProbeScore(nestedResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = nestedResult;
        }
    }

    if (bestScore < 0) {
        return false;
    }
    if (out) {
        *out = bestResult;
        if (source && strcmp(source, "Direct") != 0) {
            out->usedAutoScan = true;
            out->worldSource = source;
            out->scannedFieldOffset = scannedFieldOffset;
        }
    }
    return true;
}

static inline bool ProbeUWorldOffsetCandidate(uint64_t baseAddr,
                                              uint64_t worldOffset,
                                              RuntimeWorldProbeResult *out = nullptr) {
    if (!LooksLikeUserVA(baseAddr) || worldOffset == 0) {
        return false;
    }

    uint64_t worldPtrVA = ResolveRuntimeHintVA(baseAddr, worldOffset);
    if (!LooksLikeUserVA(worldPtrVA)) {
        return false;
    }

    uint64_t gWorld = StripRuntimePAC(KFD::Read<uint64_t>(worldPtrVA));
    RuntimeWorldProbeResult localResult;
    localResult.resolvedUWorldOffset = worldOffset;
    localResult.gWorld = gWorld;
    if (!ProbeWorldOrWrapperCandidate(gWorld, &localResult, "Direct")) {
        return false;
    }

    localResult.resolvedUWorldOffset = worldOffset;
    if (out) {
        *out = localResult;
    }
    return true;
}

static inline bool WeakProbeWorldCandidateWithLayout(uint64_t gWorld,
                                                     const RuntimeWorldLayout &layout,
                                                     RuntimeWorldProbeResult *out = nullptr) {
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return false;
    }

    RuntimeWorldProbeResult result = {};
    result.gWorld = gWorld;

    uint64_t actorArray = 0;
    int actorCount = 0;
    if (ResolveActorArrayFromWorld(gWorld, &actorArray, &actorCount, &layout)) {
        result.level = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.persistentLevel));
        result.actorArray = actorArray;
        result.actorCount = actorCount;
        result.levelSource = "WorldActive";
        result.actorArraySource = "ActiveLevelActors";
        result.layoutName = layout.name;
        if (out) {
            *out = result;
        }
        return true;
    }

    const struct {
        uint64_t level;
        const char *source;
    } levelCandidates[] = {
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.persistentLevel)), "Persistent" },
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.currentLevel)), "Current" },
        { StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.pendingVisibilityLevel)), "Pending" },
    };

    for (const auto &candidate : levelCandidates) {
        uint64_t actorArray = 0;
        uint64_t actorCluster = 0;
        int actorCount = 0;
        if (!ResolveActorArrayFromLevelCandidate(candidate.level, &actorArray, &actorCount, &actorCluster, &layout)) {
            continue;
        }
        result.level = StripRuntimePAC(candidate.level);
        result.actorArray = actorArray;
        result.actorCount = actorCount;
        result.levelSource = candidate.source;
        result.actorArraySource = "LevelActorContainer";
        result.layoutName = layout.name;
        if (out) {
            *out = result;
        }
        return true;
    }

    uint64_t anyLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.persistentLevel));
    if (!LooksLikeUserVA(anyLevel)) {
        anyLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.currentLevel));
    }
    if (!LooksLikeUserVA(anyLevel)) {
        anyLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + layout.pendingVisibilityLevel));
    }
    if (LooksLikeUserVA(anyLevel)) {
        result.level = anyLevel;
        result.levelSource = "WeakLevel";
        result.layoutName = layout.name;
        if (out) {
            *out = result;
        }
        return true;
    }

    return false;
}

static inline bool WeakProbeWorldCandidate(uint64_t gWorld, RuntimeWorldProbeResult *out = nullptr) {
    size_t layoutCount = 0;
    const RuntimeWorldLayout *layouts = RuntimeWorldLayouts(&layoutCount);
    RuntimeWorldProbeResult bestResult = {};
    int bestScore = -1;

    for (size_t i = 0; i < layoutCount; ++i) {
        RuntimeWorldProbeResult candidateResult;
        if (!WeakProbeWorldCandidateWithLayout(gWorld, layouts[i], &candidateResult)) {
            continue;
        }
        int score = ComputeWorldProbeScore(candidateResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = candidateResult;
        }
    }

    if (bestScore < 0) {
        return false;
    }
    if (out) {
        *out = bestResult;
    }
    return true;
}

static inline bool WeakProbeWorldOrWrapperCandidate(uint64_t candidate,
                                                    RuntimeWorldProbeResult *out = nullptr,
                                                    const char *source = "WeakDirect",
                                                    uint64_t scannedFieldOffset = 0) {
    candidate = StripRuntimePAC(candidate);
    if (!LooksLikeUserVA(candidate)) {
        return false;
    }

    RuntimeWorldProbeResult directResult;
    if (WeakProbeWorldCandidate(candidate, &directResult)) {
        directResult.worldSource = source ? source : "WeakDirect";
        directResult.scannedFieldOffset = scannedFieldOffset;
        if (out) *out = directResult;
        return true;
    }

    for (uint32_t fieldOffset = 0; fieldOffset <= 0x400; fieldOffset += 0x8) {
        uint64_t nestedWorld = 0;
        if (!TryReadPointer(candidate + fieldOffset, &nestedWorld) || nestedWorld == candidate) {
            continue;
        }
        RuntimeWorldProbeResult nestedResult;
        if (!WeakProbeWorldCandidate(nestedWorld, &nestedResult)) {
            continue;
        }
        nestedResult.worldSource = "WeakFieldScan";
        nestedResult.scannedFieldOffset = fieldOffset;
        nestedResult.usedAutoScan = true;
        if (out) *out = nestedResult;
        return true;
    }

    return false;
}

static inline bool WeakProbeUWorldOffsetCandidate(uint64_t baseAddr,
                                                  uint64_t worldOffset,
                                                  RuntimeWorldProbeResult *out = nullptr) {
    if (!LooksLikeUserVA(baseAddr) || worldOffset == 0) {
        return false;
    }

    uint64_t worldPtrVA = ResolveRuntimeHintVA(baseAddr, worldOffset);
    if (!LooksLikeUserVA(worldPtrVA)) {
        return false;
    }

    uint64_t gWorld = StripRuntimePAC(KFD::Read<uint64_t>(worldPtrVA));
    RuntimeWorldProbeResult localResult;
    localResult.resolvedUWorldOffset = worldOffset;
    localResult.gWorld = gWorld;
    if (!WeakProbeWorldOrWrapperCandidate(gWorld, &localResult, "WeakDirect")) {
        return false;
    }

    localResult.resolvedUWorldOffset = worldOffset;
    if (out) {
        *out = localResult;
    }
    return true;
}

static inline bool ProbeUWorldDirectCandidate(uint64_t worldValue,
                                              RuntimeWorldProbeResult *out = nullptr,
                                              const char *source = "DirectValue") {
    RuntimeWorldProbeResult localResult;
    if (!ProbeWorldOrWrapperCandidate(worldValue, &localResult, source) &&
        !WeakProbeWorldOrWrapperCandidate(worldValue, &localResult, source)) {
        return false;
    }
    localResult.resolvedUWorldOffset = 0;
    localResult.usedAutoScan = true;
    if (out) {
        *out = localResult;
    }
    return true;
}

static inline bool ProbeNearbyUWorldPointers(uint64_t seed,
                                             RuntimeWorldProbeResult *out = nullptr) {
    seed = StripRuntimePAC(seed);
    if (!LooksLikeUserVA(seed)) {
        return false;
    }

    RuntimeWorldProbeResult bestResult = {};
    int bestScore = -1;
    for (uint32_t offset = 0; offset <= 0x600; offset += 0x8) {
        uint64_t value = 0;
        if (!TryReadPointer(seed + offset, &value)) {
            continue;
        }
        RuntimeWorldProbeResult candidateResult;
        if (!ProbeWorldOrWrapperCandidate(value, &candidateResult, "SeedField", offset) &&
            !WeakProbeWorldOrWrapperCandidate(value, &candidateResult, "SeedField", offset)) {
            continue;
        }
        candidateResult.usedAutoScan = true;
        candidateResult.scannedFieldOffset = offset;
        int score = ComputeWorldProbeScore(candidateResult);
        if (score > bestScore) {
            bestScore = score;
            bestResult = candidateResult;
        }
    }

    if (bestScore < 0) {
        return false;
    }
    if (out) {
        *out = bestResult;
    }
    return true;
}

static inline uint64_t ResolveRuntimeUWorldOffset(uint64_t baseAddr,
                                                  uint64_t hintOffset,
                                                  RuntimeWorldProbeResult *out = nullptr) {
    static uint64_t s_cachedBaseAddr = 0;
    static uint64_t s_cachedResolvedOffset = 0;

    RuntimeWorldProbeResult localResult;
    if (s_cachedBaseAddr == baseAddr &&
        s_cachedResolvedOffset != 0 &&
        ProbeUWorldOffsetCandidate(baseAddr, s_cachedResolvedOffset, &localResult)) {
        if (out) {
            *out = localResult;
        }
        return s_cachedResolvedOffset;
    }

    if (s_cachedBaseAddr == baseAddr &&
        s_cachedResolvedOffset != 0 &&
        WeakProbeUWorldOffsetCandidate(baseAddr, s_cachedResolvedOffset, &localResult)) {
        if (out) {
            *out = localResult;
        }
        return s_cachedResolvedOffset;
    }

    if (ProbeUWorldOffsetCandidate(baseAddr, hintOffset, &localResult)) {
        s_cachedBaseAddr = baseAddr;
        s_cachedResolvedOffset = hintOffset;
        if (out) {
            *out = localResult;
        }
        return hintOffset;
    }

    if (WeakProbeUWorldOffsetCandidate(baseAddr, hintOffset, &localResult)) {
        s_cachedBaseAddr = baseAddr;
        s_cachedResolvedOffset = hintOffset;
        if (out) {
            *out = localResult;
        }
        return hintOffset;
    }

    uint64_t hintedWorldVA = ResolveRuntimeHintVA(baseAddr, hintOffset);
    uint64_t hintedRawWorld = LooksLikeUserVA(hintedWorldVA) ? StripRuntimePAC(KFD::Read<uint64_t>(hintedWorldVA)) : 0;
    if (ProbeUWorldDirectCandidate(hintedRawWorld, &localResult, "RawDirect") ||
        ProbeNearbyUWorldPointers(hintedRawWorld, &localResult)) {
        s_cachedBaseAddr = baseAddr;
        s_cachedResolvedOffset = hintOffset;
        localResult.resolvedUWorldOffset = hintOffset;
        if (out) {
            *out = localResult;
            out->usedAutoScan = true;
        }
        return hintOffset;
    }

    const uint64_t fallbackWorldOffsets[] = {
        0x10FD2FC78ULL,  // iOS dump hint
        0x16B24CC8ULL,   // Android SDK UEPointers::World, secondary fallback
    };
    for (uint64_t candidateOffset : fallbackWorldOffsets) {
        if (candidateOffset == 0 || candidateOffset == hintOffset) {
            continue;
        }
        if (ProbeUWorldOffsetCandidate(baseAddr, candidateOffset, &localResult) ||
            WeakProbeUWorldOffsetCandidate(baseAddr, candidateOffset, &localResult)) {
            s_cachedBaseAddr = baseAddr;
            s_cachedResolvedOffset = candidateOffset;
            if (out) {
                *out = localResult;
                out->usedAutoScan = true;
            }
            return candidateOffset;
        }
    }

    for (uint64_t candidateOffset : fallbackWorldOffsets) {
        if (candidateOffset == 0 || candidateOffset == hintOffset) {
            continue;
        }
        uint64_t candidateVA = ResolveRuntimeHintVA(baseAddr, candidateOffset);
        uint64_t candidateRaw = LooksLikeUserVA(candidateVA) ? StripRuntimePAC(KFD::Read<uint64_t>(candidateVA)) : 0;
        if (ProbeUWorldDirectCandidate(candidateRaw, &localResult, "FallbackRaw") ||
            ProbeNearbyUWorldPointers(candidateRaw, &localResult)) {
            s_cachedBaseAddr = baseAddr;
            s_cachedResolvedOffset = candidateOffset;
            localResult.resolvedUWorldOffset = candidateOffset;
            if (out) {
                *out = localResult;
                out->usedAutoScan = true;
            }
            return candidateOffset;
        }
    }

    return 0;
}

#endif
