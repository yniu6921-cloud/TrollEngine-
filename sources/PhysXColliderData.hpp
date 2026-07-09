//
//  PhysXColliderData.hpp
//  PhysX 碰撞体可视化 - 核心数据结构
//
//  使用 KFD 内核读取接口保证安全
//

#ifndef PhysXColliderData_hpp
#define PhysXColliderData_hpp

#include <cstdint>
#include <vector>

// 碰撞体类型枚举
enum class ColliderType : uint8_t {
    Capsule = 0,      // 胶囊体 (角色)
    Box = 1,          // 盒体 (建筑/障碍物)
    Sphere = 2,       // 球体 (触发器)
    StaticMesh = 3,   // 静态网格
    Unknown = 255     // 未知类型
};

// 碰撞体数据结构 (与 KFD 读取兼容)
struct ColliderData {
    ColliderType   type;           // 碰撞体类型
    Vector3        center;         // 世界坐标中心点
    Vector3        halfExtent;     // 半尺寸: Box=(x,y,z), Capsule=(r,r,h), Sphere=(r,0,0)
    float          rotation[4];    // 四元数旋转 (x,y,z,w)
    uint64_t       componentAddr; // 原始组件地址 (用于 KFD::地址泄露 检查)
    uint64_t       actorAddr;     // 所属 Actor 地址
    uint32_t       lastUpdate;    // 更新时间戳 (帧号)
    bool            isVisible;     // 是否可见 (用于掩体变色)
};

// 线段结构 (用于渲染)
struct LineSegment {
    Vector3 from;
    Vector3 to;
    uint32_t color;    // ImGui 颜色格式: 0xAABBGGRR
    
    LineSegment() : from(), to(), color(0xFFFFFFFF) {}
    LineSegment(const Vector3& f, const Vector3& t, uint32_t c) 
        : from(f), to(t), color(c) {}
};

// 颜色定义 (ImGui 格式: 0xAABBGGRR)
namespace ColliderColors {
    constexpr uint32_t Capsule      = 0xFFFF00FF; // 青色 (角色)
    constexpr uint32_t Box          = 0xFF00FF00; // 绿色 (建筑)
    constexpr uint32_t Sphere       = 0xFF0000FF; // 红色 (触发器)
    constexpr uint32_t StaticMesh   = 0xFF00FFFF; // 黄色 (静态物体)
    constexpr uint32_t Occluded    = 0xFF808080; // 灰色 (被遮挡)
    constexpr uint32_t LocalPlayer  = 0xFF00A0FF; // 橙色 (本地玩家)
}

// 距离裁剪阈值 (单位: cm)
namespace ColliderConfig {
    constexpr float MaxDrawDistance = 8000.0f;  // 80米（覆盖自瞄中远距离）
    constexpr float MinDrawDistance = 0.0f;    // 0米
    constexpr uint32_t UpdateInterval = 6;      // 10Hz (60fps / 6 = 10Hz)
}

#endif /* PhysXColliderData_hpp */
