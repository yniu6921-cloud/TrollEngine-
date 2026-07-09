//
//  PhysXColliderExtractor.hpp
//  PhysX 碰撞体可视化 - 碰撞体提取器
//
//  使用 KFD 内核读取接口保证安全
//

#ifndef PhysXColliderExtractor_hpp
#define PhysXColliderExtractor_hpp

#include "PhysXColliderData.hpp"
#include "PhysXRaycast.hpp"
#include "OffsetsTool.hpp"
#include "RuntimeWorldResolver.hpp"
#include <vector>
#include <string>
#include <cmath>

// 前向声明
class PhysXColliderExtractor {
public:
    // 10Hz 节流更新 (每6帧调用一次)
    static void ExtractIfNeeded();
    
    // 获取缓存的碰撞体数据
    static const std::vector<ColliderData>& GetColliders();

    // 获取调试信息字符串
    static std::string GetDebugInfo();
    
    // 清除缓存
    static void Clear();
    
    // 设置本地玩家位置 (用于距离裁剪)
    static void SetLocalPlayerPos(const Vector3& pos);
    
private:
    static uint64_t s_lastExtractTime;
    static std::vector<ColliderData> s_cachedColliders;
    static Vector3 s_localPlayerPos;
    static bool s_initialized;
    
    // 内部提取逻辑
    static void ExtractInternal();
    
    // 从 Actor 提取碰撞体
    static void ExtractFromActor(uint64_t actor, uint64_t actorArray, int actorCount);
    
    // 距离裁剪 (40m)
    static bool IsWithinDrawDistance(const Vector3& pos);
    
    // 提取 Capsule 碰撞体
    static bool ExtractCapsule(uint64_t actor, uint64_t capsuleComp, ColliderData& out);
    
    // 提取 Box 碰撞体
    static bool ExtractBox(uint64_t actor, uint64_t boxComp, ColliderData& out);
    
    // 提取 Sphere 碰撞体
    static bool ExtractSphere(uint64_t actor, uint64_t sphereComp, ColliderData& out);

    // 提取 StaticMesh 碰撞体（从 UStaticMesh asset 读取 bounds）
    static bool ExtractStaticMesh(uint64_t actor, uint64_t staticMeshComp, ColliderData& out);

    // 获取组件世界坐标变换
    static bool GetComponentTransform(uint64_t component, Vector3& center, float rotation[4]);
    
    // 从组件提取碰撞体（递归处理子组件）
    static void ExtractFromComponent(uint64_t component, uint64_t actor);
};

// 调试信息
inline static std::string s_physxDebugInfo = "等待提取...";

// 静态变量定义
inline uint64_t PhysXColliderExtractor::s_lastExtractTime = 0;
inline std::vector<ColliderData> PhysXColliderExtractor::s_cachedColliders;
inline Vector3 PhysXColliderExtractor::s_localPlayerPos;
inline bool PhysXColliderExtractor::s_initialized = false;

inline std::string PhysXColliderExtractor::GetDebugInfo() {
    return s_physxDebugInfo;
}

inline void PhysXColliderExtractor::SetLocalPlayerPos(const Vector3& pos) {
    s_localPlayerPos = pos;
}

inline const std::vector<ColliderData>& PhysXColliderExtractor::GetColliders() {
    return s_cachedColliders;
}

inline void PhysXColliderExtractor::Clear() {
    s_cachedColliders.clear();
    s_lastExtractTime = 0;
    s_physxDebugInfo = "已清除";
}

inline bool PhysXColliderExtractor::IsWithinDrawDistance(const Vector3& pos) {
    float dx = pos.X - s_localPlayerPos.X;
    float dy = pos.Y - s_localPlayerPos.Y;
    float dz = pos.Z - s_localPlayerPos.Z;
    float distSq = dx*dx + dy*dy + dz*dz;
    return distSq <= (ColliderConfig::MaxDrawDistance * ColliderConfig::MaxDrawDistance);
}

inline static bool ResolveLevelActorArray(uint64_t level,
                                          uint64_t& actorArray,
                                          int& actorCount,
                                          const RuntimeWorldLayout *layout = nullptr) {
    actorArray = 0;
    actorCount = 0;
    return ResolveActorArrayFromLevelCandidate(level, &actorArray, &actorCount, nullptr, layout);
}

inline static bool ResolveWorldActorArray(uint64_t gWorld,
                                          uint64_t& actorArray,
                                          int& actorCount,
                                          const RuntimeWorldLayout *layout = nullptr) {
    actorArray = 0;
    actorCount = 0;
    return ResolveActorArrayFromWorld(gWorld, &actorArray, &actorCount, layout);
}

inline static Vector3 ReadActorRelativeLocation(uint64_t actor) {
    actor = StripRuntimePAC(actor);
    if (!LooksLikeUserVA(actor)) {
        return Vector3();
    }

    uint64_t rootComponent = StripRuntimePAC(KFD::Read<uint64_t>(actor + kRootComponent));
    if (!LooksLikeUserVA(rootComponent)) {
        return Vector3();
    }

    return KFD::Read<Vector3>(rootComponent + kLocation);
}

inline static uint64_t ResolveReadableLevelForCollider(uint64_t gWorld,
                                                       const RuntimeWorldLayout *layout = nullptr) {
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return 0;
    }

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    const uint64_t levelCandidates[] = {
        StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.persistentLevel)),
        StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.currentLevel)),
        StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.pendingVisibilityLevel)),
    };

    uint64_t firstReadableLevel = 0;
    for (uint64_t level : levelCandidates) {
        if (!LooksLikeUserVA(level)) {
            continue;
        }
        if (!firstReadableLevel) {
            firstReadableLevel = level;
        }

        uint64_t actorArray = 0;
        int actorCount = 0;
        if (ResolveLevelActorArray(level, actorArray, actorCount, &activeLayout)) {
            return level;
        }
    }

    return firstReadableLevel;
}

// 10Hz 节流更新
inline void PhysXColliderExtractor::ExtractIfNeeded() {
    // 检查是否需要更新 (每6帧 = 10Hz)
    static int frameCount = 0;
    frameCount++;
    
    if (frameCount % ColliderConfig::UpdateInterval != 0) {
        return;
    }
    
    // 获取 gWorld 和基地址
    uint64_t baseAddr = KFD::S().base;
    if (baseAddr == 0) return;
    
    RuntimeWorldProbeResult worldProbe;
    uint64_t resolvedUWorldOffset = ResolveRuntimeUWorldOffset(baseAddr, kUWorld, &worldProbe);
    if (resolvedUWorldOffset == 0) return;
    const RuntimeWorldLayout *resolvedWorldLayout = FindRuntimeWorldLayoutByName(worldProbe.layoutName);

    uint64_t gWorldVA = ResolveRuntimeHintVA(baseAddr, resolvedUWorldOffset);
    uint64_t gWorld = worldProbe.gWorld ? worldProbe.gWorld : StripRuntimePAC(KFD::Read<uint64_t>(gWorldVA));
    if (!LooksLikeUserVA(gWorld)) return;
    
    // 读取 Level（兼容部分版本 CurrentLevel / PendingVisibility 取代 PersistentLevel）
    uint64_t PersistentLevel = LooksLikeUserVA(worldProbe.level)
        ? worldProbe.level
        : ResolveReadableLevelForCollider(gWorld, resolvedWorldLayout);
    
    // 读取 Actor 数组
    uint64_t ActorArray = LooksLikeUserVA(worldProbe.actorArray) ? worldProbe.actorArray : 0;
    int ActorCount = worldProbe.actorCount;
    if ((!LooksLikeUserVA(ActorArray) || ActorCount <= 0) && LooksLikeUserVA(PersistentLevel)) {
        ResolveLevelActorArray(PersistentLevel, ActorArray, ActorCount, resolvedWorldLayout);
    }
    if (!LooksLikeUserVA(ActorArray) || ActorCount <= 0) {
        ResolveWorldActorArray(gWorld, ActorArray, ActorCount, resolvedWorldLayout);
    }
    
    if (!KFD::地址泄露(ActorArray) || ActorCount <= 0 || ActorCount > 10000) {
        return;
    }
    
    // 更新本地玩家位置
    uint64_t NetDriver = KFD::Read<long>(gWorld + kNetDriver);
    if (KFD::地址泄露(NetDriver)) {
        uint64_t ServerConnection = KFD::Read<long>(NetDriver + kServerConnection);
        if (KFD::地址泄露(ServerConnection)) {
            uint64_t PlayerController = KFD::Read<long>(ServerConnection + klocalPlayerController);
            if (KFD::地址泄露(PlayerController)) {
                uint64_t Character = KFD::Read<long>(PlayerController + kPawn);
                if (KFD::地址泄露(Character)) {
                    s_localPlayerPos = ReadActorRelativeLocation(Character);
                }
            }
        }
    }
    
    // 清除旧数据并提取新数据
    s_cachedColliders.clear();
    s_cachedColliders.reserve(512); // 预分配
    
    // 遍历所有Actor（增加限制以避免性能问题）
    int maxActorsToProcess = std::min(ActorCount, 5000); // 最多处理5000个Actor
    for (int i = 0; i < maxActorsToProcess; i++) {
        uint64_t actor = KFD::Read<uint64_t>(ActorArray + i * 0x8);
        if (KFD::地址泄露(actor)) {
            ExtractFromActor(actor, ActorArray, ActorCount);
            // 如果已经提取了足够多的碰撞体，可以提前退出
            if (s_cachedColliders.size() >= 500) {
                break;
            }
        }
    }
    
    // 更新调试信息：总碰撞体数量
    {
        char tmp[64];
        snprintf(tmp, sizeof(tmp), " | 总计 %zu 个碰撞体", s_cachedColliders.size());
        if (s_physxDebugInfo.find("等待提取") != std::string::npos ||
            s_physxDebugInfo.find("总计") == std::string::npos) {
            s_physxDebugInfo = std::string(tmp);
        } else {
            // 追加到已有信息后
            auto pos = s_physxDebugInfo.find(" | 总计");
            if (pos != std::string::npos) {
                s_physxDebugInfo = s_physxDebugInfo.substr(0, pos) + tmp;
            } else {
                s_physxDebugInfo += tmp;
            }
        }
    }

    s_lastExtractTime = frameCount;
}

inline void PhysXColliderExtractor::ExtractFromActor(uint64_t actor, uint64_t actorArray, int actorCount) {
    if (!KFD::地址泄露(actor)) return;
    
    // 读取 FName 判断类型（仅用于排除玩家和载具）
    int32_t FNameID = KFD::Read<int32_t>(actor + 0x18);
    if (FNameID <= 0 || FNameID >= 2000000) return;
    
    // 读取 GNames
    uint64_t gNamesOffset = kGNames;
    uint64_t gNamesVA = ResolveRuntimeHintVA(KFD::S().base, gNamesOffset);
    uint64_t UName = KFD::Read<uint64_t>(gNamesVA);
    if (!UName) return;
    
    uint64_t pageAddr = KFD::Read<uint64_t>(UName + ((FNameID / 0x4000) * 8));
    if (!pageAddr) return;
    
    uint64_t nameAddr = KFD::Read<uint64_t>(pageAddr + ((FNameID % 0x4000) * 8));
    if (!nameAddr) return;
    
    char buf[64] = {0};
    if (!KFD::KextRW_readMemory(&KFD::S().handle, nameAddr + 0xE, buf, sizeof(buf), KFD::S().vm_map_pmap)) {
        return;
    }
    
    std::string FName(buf);
    
    // 只排除玩家和载具，其他所有 Actor 都尝试提取碰撞体（因为子弹能射中的地方都有碰撞体）
    bool isPlayer = KFD::isContain(FName, "PlayerPawn") ||
                    KFD::isContain(FName, "PlayerCharacter") ||
                    KFD::isContain(FName, "CharacterModelTaget");
    
    bool isVehicle = KFD::isContain(FName, "VH_") || KFD::isContain(FName, "BP_VH_");
    
    // 提取 Capsule (角色/载具) - 仅用于角色和载具
    if (isPlayer || isVehicle) {
        uint64_t CapsuleComponent = KFD::Read<uint64_t>(actor + kCapsuleComponent);
        if (KFD::地址泄露(CapsuleComponent)) {
            ColliderData collider;
            if (ExtractCapsule(actor, CapsuleComponent, collider)) {
                if (IsWithinDrawDistance(collider.center)) {
                    s_cachedColliders.push_back(collider);
                }
            }
        }
        return; // 玩家和载具只提取Capsule，不提取其他碰撞体
    }
    
    // 对于所有其他 Actor，提取所有可能的碰撞体（因为子弹能射中的地方都有碰撞体）
    // 策略：从RootComponent开始，递归提取所有子组件的碰撞体
    
    // 1. 从 RootComponent 开始提取
    uint64_t RootComponent = KFD::Read<uint64_t>(actor + kRootComponent);
    if (KFD::地址泄露(RootComponent)) {
        ExtractFromComponent(RootComponent, actor);
    }
    
    // 2. 也尝试直接提取常见组件（作为备选方案）
    // 尝试提取 Box 碰撞体
    uint64_t BoxComponent = KFD::Read<uint64_t>(actor + 0x618);
    if (!KFD::地址泄露(BoxComponent)) {
        BoxComponent = KFD::Read<uint64_t>(actor + kCapsuleComponent);
    }
    if (KFD::地址泄露(BoxComponent)) {
        ColliderData collider;
        if (ExtractBox(actor, BoxComponent, collider)) {
            if (IsWithinDrawDistance(collider.center)) {
                s_cachedColliders.push_back(collider);
            }
        }
    }
    
    // 3. 尝试从 RootComponent 提取 StaticMesh 碰撞体（建筑物等）
    // 如果 ExtractFromComponent 因 BodyInstance 不可用而跳过，这里再试一次
    if (KFD::地址泄露(RootComponent)) {
        uint64_t rootSM = StripRuntimePAC(KFD::Read<uint64_t>(RootComponent + kStaticMesh));
        if (LooksLikeUserVA(rootSM)) {
            ColliderData sc;
            if (ExtractStaticMesh(actor, RootComponent, sc)) {
                bool dup = false;
                for (auto& e : s_cachedColliders)
                    if (e.componentAddr == sc.componentAddr) { dup = true; break; }
                if (!dup && IsWithinDrawDistance(sc.center)) s_cachedColliders.push_back(sc);
            }
        }
    }
}

inline bool PhysXColliderExtractor::ExtractCapsule(uint64_t actor, uint64_t capsuleComp, ColliderData& out) {
    if (!KFD::地址泄露(capsuleComp)) return false;
    
    float CapsuleHalfHeight = KFD::Read<float>(capsuleComp + 0x7C8);
    float CapsuleRadius = KFD::Read<float>(capsuleComp + 0x7CC);
    
    if (CapsuleHalfHeight <= 0 || CapsuleRadius <= 0) return false;
    
    // 获取变换
    Vector3 center;
    float rotation[4];
    if (!GetComponentTransform(capsuleComp, center, rotation)) return false;
    
    out.type = ColliderType::Capsule;
    out.center = center;
    out.halfExtent = Vector3(CapsuleRadius, CapsuleRadius, CapsuleHalfHeight);
    out.rotation[0] = rotation[0];
    out.rotation[1] = rotation[1];
    out.rotation[2] = rotation[2];
    out.rotation[3] = rotation[3];
    out.componentAddr = capsuleComp;
    out.actorAddr = actor;
    out.lastUpdate = 0;
    
    // 检查可见性
    uint64_t MeshComp = KFD::Read<uint64_t>(actor + kMesh);
    if (LooksLikeUserVA(MeshComp)) {
        float renderTime = KFD::Read<float>(MeshComp + 0x414);
        uint64_t baseAddr = KFD::S().base;
        RuntimeWorldProbeResult worldProbe;
        uint64_t resolvedUWorldOffset = ResolveRuntimeUWorldOffset(baseAddr, kUWorld, &worldProbe);
        uint64_t gWorldVA = ResolveRuntimeHintVA(baseAddr, resolvedUWorldOffset);
        uint64_t gWorld = resolvedUWorldOffset == 0 ? 0 : (worldProbe.gWorld ? worldProbe.gWorld : StripRuntimePAC(KFD::Read<uint64_t>(gWorldVA)));
        uint64_t gameState = LooksLikeUserVA(gWorld) ? StripRuntimePAC(KFD::Read<long>(gWorld + kGameState)) : 0;
        float currentTime = LooksLikeUserVA(gameState) ? KFD::Read<float>(gameState + kReplicatedWorldTimeSeconds) : 0.f;
        out.isVisible = (currentTime - renderTime) < 1.0f;
    } else {
        out.isVisible = true;
    }
    
    return true;
}

inline bool PhysXColliderExtractor::ExtractBox(uint64_t actor, uint64_t boxComp, ColliderData& out) {
    if (!KFD::地址泄露(boxComp)) return false;
    
    Vector3 BoxExtent = KFD::Read<Vector3>(boxComp + 0x7C8);
    if (BoxExtent.X <= 0 && BoxExtent.Y <= 0 && BoxExtent.Z <= 0) return false;
    
    Vector3 center;
    float rotation[4];
    if (!GetComponentTransform(boxComp, center, rotation)) return false;
    
    out.type = ColliderType::Box;
    out.center = center;
    out.halfExtent = BoxExtent;
    out.rotation[0] = rotation[0];
    out.rotation[1] = rotation[1];
    out.rotation[2] = rotation[2];
    out.rotation[3] = rotation[3];
    out.componentAddr = boxComp;
    out.actorAddr = actor;
    out.lastUpdate = 0;
    out.isVisible = true;
    
    return true;
}

inline bool PhysXColliderExtractor::ExtractSphere(uint64_t actor, uint64_t sphereComp, ColliderData& out) {
    if (!KFD::地址泄露(sphereComp)) return false;
    
    float SphereRadius = KFD::Read<float>(sphereComp + 0x7C8);
    if (SphereRadius <= 0) return false;
    
    Vector3 center;
    float rotation[4];
    if (!GetComponentTransform(sphereComp, center, rotation)) return false;
    
    out.type = ColliderType::Sphere;
    out.center = center;
    out.halfExtent = Vector3(SphereRadius, 0, 0);
    out.rotation[0] = rotation[0];
    out.rotation[1] = rotation[1];
    out.rotation[2] = rotation[2];
    out.rotation[3] = rotation[3];
    out.componentAddr = sphereComp;
    out.actorAddr = actor;
    out.lastUpdate = 0;
    out.isVisible = true;
    
    return true;
}

// 从 UStaticMeshComponent 提取碰撞体
// 关键：UStaticMesh* 指针在 component + 0x808 (kStaticMesh)
// 从 UStaticMesh asset 中读取导入的 bounds 作为碰撞体尺寸
inline bool PhysXColliderExtractor::ExtractStaticMesh(uint64_t actor, uint64_t staticMeshComp, ColliderData& out) {
    if (!KFD::地址泄露(staticMeshComp)) return false;

    // 读取 UStaticMesh* 指针 (component + 0x818)
    uint64_t staticMesh = StripRuntimePAC(KFD::Read<uint64_t>(staticMeshComp + kStaticMesh));
    if (!LooksLikeUserVA(staticMesh)) {
        // 没有 UStaticMesh asset，可能不是 StaticMeshComponent
        return false;
    }

    // 获取组件变换
    Vector3 center;
    float rotation[4];
    if (!GetComponentTransform(staticMeshComp, center, rotation)) return false;

    // 读取组件缩放（从 ComponentToWorld 的 Scale3D）
    // FTransform layout: Rotation(16B) + Translation(16B) + Scale3D(16B)
    uint64_t transformAddr = staticMeshComp + kComponentToWorld;
    Vector3 scale3D;
    scale3D.X = KFD::Read<float>(transformAddr + 0x20);
    scale3D.Y = KFD::Read<float>(transformAddr + 0x24);
    scale3D.Z = KFD::Read<float>(transformAddr + 0x28);

    // UStaticMesh 内存布局（UE4.18, 64-bit）:
    //   0x00-0x28: UObject 基类
    //   ... 其他字段 ...
    //   常见偏移: FBoxSphereBounds ImportedBounds ~0x40-0x50
    //             FBoxSphereBounds CalculatedBounds ~0x58-0x68
    //             UBodySetup* BodySetup ~0x70-0x80

    // FBoxSphereBounds: Origin(Vector3=12B) + BoxExtent(Vector3=12B) + SphereRadius(float=4B) = 28B
    // 尝试多个可能的偏移
    struct { uint64_t offset; const char* name; } boundOffsets[] = {
        {0x6C, "+0x6C"},  // ImportedBounds (confirmed)
        {0x88, "+0x88"},  // CalculatedBounds (confirmed)
        {0x30, "+0x30"},
        {0x38, "+0x38"},
        {0x40, "+0x40"},
        {0x44, "+0x44"},
        {0x50, "+0x50"},
        {0x58, "+0x58"},
        {0x60, "+0x60"},
        {0x70, "+0x70"},
    };

    Vector3 localOrigin = {0,0,0};
    Vector3 boxExtent = {0,0,0};
    std::string debugInfo;
    size_t checkedOffsetCount = 0;

    for (const auto& bo : boundOffsets) {
        // 读取 Origin
        Vector3 tryOrigin = KFD::Read<Vector3>(staticMesh + bo.offset);
        // 读取 BoxExtent (Origin + 12 bytes)
        Vector3 tryExtent = KFD::Read<Vector3>(staticMesh + bo.offset + 12);
        // 读取 SphereRadius
        float sphereRadius = KFD::Read<float>(staticMesh + bo.offset + 24);
        checkedOffsetCount++;

        // 记录每个偏移读到的值（只记录前几个非零的作为参考）
        bool valid = tryExtent.X >= 5.0f && tryExtent.X <= 10000.0f &&
                     tryExtent.Y >= 5.0f && tryExtent.Y <= 10000.0f &&
                     tryExtent.Z >= 5.0f && tryExtent.Z <= 10000.0f &&
                     std::isfinite(tryOrigin.X) && std::isfinite(tryOrigin.Y) && std::isfinite(tryOrigin.Z) &&
                     tryOrigin.X > -10000.0f && tryOrigin.X < 10000.0f &&
                     tryOrigin.Y > -10000.0f && tryOrigin.Y < 10000.0f &&
                     tryOrigin.Z > -10000.0f && tryOrigin.Z < 10000.0f &&
                     sphereRadius > 0 && sphereRadius < 20000.0f;

        // 构建设调试字符串
        char tmp[128];
        snprintf(tmp, sizeof(tmp), "%s: O(%.0f,%.0f,%.0f) E(%.0f,%.0f,%.0f) R=%.0f%s | ",
                 bo.name,
                 (double)tryOrigin.X, (double)tryOrigin.Y, (double)tryOrigin.Z,
                 (double)tryExtent.X, (double)tryExtent.Y, (double)tryExtent.Z,
                 (double)sphereRadius, valid ? " ✓" : "");
        debugInfo += tmp;

        if (valid) {
            localOrigin = tryOrigin;
            boxExtent = tryExtent;
            break;
        }
    }

    if (boxExtent.X < 5.0f || boxExtent.Y < 5.0f || boxExtent.Z < 5.0f) {
        // 所有偏移都无效，尝试从 BodyInstance 读取 aggregate geometry
        debugInfo += "BodyInstance: ";
        uint64_t bodyInstance = KFD::Read<uint64_t>(staticMeshComp + 0x468);
        if (LooksLikeUserVA(bodyInstance)) {
            // Try FKBoxElem at BodyInstance + 0x38
            Vector3 boxElem = KFD::Read<Vector3>(bodyInstance + 0x38);
            char tmp[96];
            snprintf(tmp, sizeof(tmp), "+0x38(%.0f,%.0f,%.0f) ",
                     (double)boxElem.X, (double)boxElem.Y, (double)boxElem.Z);
            debugInfo += tmp;
            if (boxElem.X > 5.0f && boxElem.X < 10000.0f &&
                boxElem.Y > 5.0f && boxElem.Y < 10000.0f &&
                boxElem.Z > 5.0f && boxElem.Z < 10000.0f) {
                boxExtent = boxElem;
            }

            // Try FKBoxElem at BodyInstance + 0x28
            if (boxExtent.X < 5.0f) {
                Vector3 boxElem2 = KFD::Read<Vector3>(bodyInstance + 0x28);
                char tmp2[96];
                snprintf(tmp2, sizeof(tmp2), "+0x28(%.0f,%.0f,%.0f) ",
                         (double)boxElem2.X, (double)boxElem2.Y, (double)boxElem2.Z);
                debugInfo += tmp2;
                if (boxElem2.X > 5.0f && boxElem2.X < 10000.0f &&
                    boxElem2.Y > 5.0f && boxElem2.Y < 10000.0f &&
                    boxElem2.Z > 5.0f && boxElem2.Z < 10000.0f) {
                    boxExtent = boxElem2;
                }
            }
        } else {
            debugInfo += "invalid; ";
        }
    }

    // 仍然没有有效的 BoxExtent
    if (boxExtent.X < 5.0f || boxExtent.Y < 5.0f || boxExtent.Z < 5.0f) {
        debugInfo += "❌ 无有效bounds";
        s_physxDebugInfo = debugInfo;
        return false;
    }

    // 应用缩放
    boxExtent.X *= (scale3D.X > 0.01f) ? scale3D.X : 1.0f;
    boxExtent.Y *= (scale3D.Y > 0.01f) ? scale3D.Y : 1.0f;
    boxExtent.Z *= (scale3D.Z > 0.01f) ? scale3D.Z : 1.0f;

    // 填充输出
    out.type = ColliderType::StaticMesh;
    Vector3 worldOffset = PhysXRaycast::QuatRotate(rotation, localOrigin);
    out.center.X = center.X + worldOffset.X;
    out.center.Y = center.Y + worldOffset.Y;
    out.center.Z = center.Z + worldOffset.Z;
    out.halfExtent = boxExtent;
    out.rotation[0] = rotation[0];
    out.rotation[1] = rotation[1];
    out.rotation[2] = rotation[2];
    out.rotation[3] = rotation[3];
    out.componentAddr = staticMeshComp;
    out.actorAddr = actor;
    out.lastUpdate = 0;
    out.isVisible = true;

    // 记录成功调试信息
    char final[384];
    snprintf(final, sizeof(final),
             "StaticMesh OK | Ext(%.0f,%.0f,%.0f) Off(%.0f,%.0f,%.0f) | %s",
             (double)boxExtent.X, (double)boxExtent.Y, (double)boxExtent.Z,
             (double)worldOffset.X, (double)worldOffset.Y, (double)worldOffset.Z,
             debugInfo.c_str());
    s_physxDebugInfo = final;

    return true;
}

inline bool PhysXColliderExtractor::GetComponentTransform(uint64_t component, Vector3& center, float rotation[4]) {
    if (!KFD::地址泄露(component)) return false;
    
    uint64_t TransformAddr = component + kComponentToWorld;
    
    // 读取四元数旋转
    rotation[0] = KFD::Read<float>(TransformAddr + 0x00); // x
    rotation[1] = KFD::Read<float>(TransformAddr + 0x04); // y
    rotation[2] = KFD::Read<float>(TransformAddr + 0x08); // z
    rotation[3] = KFD::Read<float>(TransformAddr + 0x0C); // w
    
    // 读取平移 (世界坐标)
    center.X = KFD::Read<float>(TransformAddr + 0x10);
    center.Y = KFD::Read<float>(TransformAddr + 0x14);
    center.Z = KFD::Read<float>(TransformAddr + 0x18);
    
    return true;
}

// 从组件提取碰撞体（递归处理子组件）
inline void PhysXColliderExtractor::ExtractFromComponent(uint64_t component, uint64_t actor) {
    if (!KFD::地址泄露(component)) return;
    
    // 检查是否是PrimitiveComponent（有BodyInstance）
    uint64_t BodyInstance = KFD::Read<uint64_t>(component + 0x468);
    if (KFD::地址泄露(BodyInstance)) {
        // 尝试提取各种类型的碰撞体
        Vector3 center;
        float rotation[4];
        if (GetComponentTransform(component, center, rotation)) {
            if (IsWithinDrawDistance(center)) {
                // 尝试提取Box碰撞体
                Vector3 BoxExtent = KFD::Read<Vector3>(component + 0x7C8);
                if (BoxExtent.X > 10.0f && BoxExtent.Y > 10.0f && BoxExtent.Z > 10.0f &&
                    BoxExtent.X < 10000.0f && BoxExtent.Y < 10000.0f && BoxExtent.Z < 10000.0f) {
                    ColliderData collider;
                    collider.type = ColliderType::Box;
                    collider.center = center;
                    collider.halfExtent = BoxExtent;
                    collider.rotation[0] = rotation[0];
                    collider.rotation[1] = rotation[1];
                    collider.rotation[2] = rotation[2];
                    collider.rotation[3] = rotation[3];
                    collider.componentAddr = component;
                    collider.actorAddr = actor;
                    collider.lastUpdate = 0;
                    collider.isVisible = true;
                    s_cachedColliders.push_back(collider);
                    return;
                }
                
                // 尝试提取Capsule碰撞体
                float CapsuleHalfHeight = KFD::Read<float>(component + 0x7C8);
                float CapsuleRadius = KFD::Read<float>(component + 0x7CC);
                if (CapsuleHalfHeight > 10.0f && CapsuleRadius > 10.0f &&
                    CapsuleHalfHeight < 10000.0f && CapsuleRadius < 10000.0f) {
                    ColliderData collider;
                    collider.type = ColliderType::Capsule;
                    collider.center = center;
                    collider.halfExtent = Vector3(CapsuleRadius, CapsuleRadius, CapsuleHalfHeight);
                    collider.rotation[0] = rotation[0];
                    collider.rotation[1] = rotation[1];
                    collider.rotation[2] = rotation[2];
                    collider.rotation[3] = rotation[3];
                    collider.componentAddr = component;
                    collider.actorAddr = actor;
                    collider.lastUpdate = 0;
                    collider.isVisible = true;
                    s_cachedColliders.push_back(collider);
                    return;
                }
                
                // 尝试提取Sphere碰撞体
                float SphereRadius = KFD::Read<float>(component + 0x7C8);
                if (SphereRadius > 10.0f && SphereRadius < 10000.0f) {
                    ColliderData collider;
                    collider.type = ColliderType::Sphere;
                    collider.center = center;
                    collider.halfExtent = Vector3(SphereRadius, 0, 0);
                    collider.rotation[0] = rotation[0];
                    collider.rotation[1] = rotation[1];
                    collider.rotation[2] = rotation[2];
                    collider.rotation[3] = rotation[3];
                    collider.componentAddr = component;
                    collider.actorAddr = actor;
                    collider.lastUpdate = 0;
                    collider.isVisible = true;
                    s_cachedColliders.push_back(collider);
                    return;
                }
                
                // 尝试从 UStaticMesh asset 读取实际 bounds
                ColliderData staticMeshCollider;
                if (ExtractStaticMesh(actor, component, staticMeshCollider)) {
                    s_cachedColliders.push_back(staticMeshCollider);
                } else {
                    // 如果没有找到特定类型，作为StaticMesh处理
                    Vector3 bounds = KFD::Read<Vector3>(BodyInstance + 0x38);
                    if (bounds.X > 10.0f && bounds.Y > 10.0f && bounds.Z > 10.0f &&
                        bounds.X < 10000.0f && bounds.Y < 10000.0f && bounds.Z < 10000.0f) {
                        ColliderData collider;
                        collider.type = ColliderType::StaticMesh;
                        collider.center = center;
                        collider.halfExtent = bounds;
                        collider.rotation[0] = rotation[0];
                        collider.rotation[1] = rotation[1];
                        collider.rotation[2] = rotation[2];
                        collider.rotation[3] = rotation[3];
                        collider.componentAddr = component;
                        collider.actorAddr = actor;
                        collider.lastUpdate = 0;
                        collider.isVisible = true;
                        s_cachedColliders.push_back(collider);
                    }
                    // 不再使用默认尺寸 - 如果无法读取有效 bounds 则跳过
                }
            }
        }
    }

    // BodyInstance 不可用时，仍然尝试从 UStaticMesh asset 读取 bounds
    // （BodyInstance 和 StaticMesh* 在不同的偏移，前者失败不代表后者也失败）
    if (!KFD::地址泄露(BodyInstance)) {
        ColliderData smc;
        if (ExtractStaticMesh(actor, component, smc)) {
            bool dup = false;
            for (auto& e : s_cachedColliders)
                if (e.componentAddr == smc.componentAddr) { dup = true; break; }
            if (!dup) s_cachedColliders.push_back(smc);
        }
    }

    // 递归处理子组件（根据SDK，AttachChildren在0x168）
    uint64_t AttachChildrenArray = KFD::Read<uint64_t>(component + 0x168);
    int AttachChildrenCount = KFD::Read<int>(component + 0x168 + 0x8);
    if (KFD::地址泄露(AttachChildrenArray) && AttachChildrenCount > 0 && AttachChildrenCount < 100) {
        for (int i = 0; i < AttachChildrenCount; i++) {
            uint64_t childComponent = KFD::Read<uint64_t>(AttachChildrenArray + i * 0x8);
            if (KFD::地址泄露(childComponent)) {
                ExtractFromComponent(childComponent, actor);
                // 限制递归深度，避免性能问题
                if (s_cachedColliders.size() >= 500) {
                    break;
                }
            }
        }
    }
}

#endif /* PhysXColliderExtractor_hpp */
