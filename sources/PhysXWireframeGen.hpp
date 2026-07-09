//
//  PhysXWireframeGen.hpp
//  PhysX 碰撞体可视化 - 线框生成器
//

#ifndef PhysXWireframeGen_hpp
#define PhysXWireframeGen_hpp

#include "PhysXColliderData.hpp"
#include <vector>
#include <cmath>

class PhysXWireframeGenerator {
public:
    // 从碰撞体生成线框
    static std::vector<LineSegment> Generate(const std::vector<ColliderData>& colliders);
    
private:
    // Box: 12 条线
    static std::vector<LineSegment> GenerateBoxWireframe(const ColliderData& data);
    
    // Capsule: 16 条线 (上下圆各8 + 4条竖线)
    static std::vector<LineSegment> GenerateCapsuleWireframe(const ColliderData& data);
    
    // Sphere: 16 条线 (3个圆环简化)
    static std::vector<LineSegment> GenerateSphereWireframe(const ColliderData& data);
    
    // StaticMesh: 简化立方体
    static std::vector<LineSegment> GenerateStaticMeshWireframe(const ColliderData& data);
    
    // 四元数旋转向量
    static Vector3 RotateByQuaternion(const Vector3& v, const float q[4]);
};

// 获取碰撞体颜色
inline uint32_t GetColliderColor(const ColliderData& data, bool enableOcclusionCheck) {
    uint32_t baseColor;
    switch (data.type) {
        case ColliderType::Capsule:
            baseColor = ColliderColors::Capsule;
            break;
        case ColliderType::Box:
            baseColor = ColliderColors::Box;
            break;
        case ColliderType::Sphere:
            baseColor = ColliderColors::Sphere;
            break;
        case ColliderType::StaticMesh:
            baseColor = ColliderColors::StaticMesh;
            break;
        default:
            baseColor = 0xFFFFFFFF;
    }
    
    // 掩体变色: 被遮挡显示灰色
    if (enableOcclusionCheck && !data.isVisible) {
        return ColliderColors::Occluded;
    }
    
    return baseColor;
}

inline std::vector<LineSegment> PhysXWireframeGenerator::Generate(const std::vector<ColliderData>& colliders) {
    std::vector<LineSegment> lines;
    lines.reserve(colliders.size() * 24); // 预分配
    
    for (const auto& collider : colliders) {
        std::vector<LineSegment> colliderLines;
        
        switch (collider.type) {
            case ColliderType::Capsule:
                colliderLines = GenerateCapsuleWireframe(collider);
                break;
            case ColliderType::Box:
                colliderLines = GenerateBoxWireframe(collider);
                break;
            case ColliderType::Sphere:
                colliderLines = GenerateSphereWireframe(collider);
                break;
            case ColliderType::StaticMesh:
                colliderLines = GenerateStaticMeshWireframe(collider);
                break;
            default:
                continue;
        }
        
        // 设置颜色
        uint32_t color = GetColliderColor(collider, true);
        for (auto& line : colliderLines) {
            line.color = color;
            lines.push_back(line);
        }
    }
    
    return lines;
}

inline std::vector<LineSegment> PhysXWireframeGenerator::GenerateBoxWireframe(const ColliderData& data) {
    std::vector<LineSegment> lines;
    lines.reserve(12);
    
    float hx = data.halfExtent.X;
    float hy = data.halfExtent.Y;
    float hz = data.halfExtent.Z;
    
    // 8个角点
    Vector3 corners[8] = {
        Vector3(-hx, -hy, -hz),
        Vector3( hx, -hy, -hz),
        Vector3( hx,  hy, -hz),
        Vector3(-hx,  hy, -hz),
        Vector3(-hx, -hy,  hz),
        Vector3( hx, -hy,  hz),
        Vector3( hx,  hy,  hz),
        Vector3(-hx,  hy,  hz)
    };
    
    // 旋转并平移
    for (int i = 0; i < 8; i++) {
        corners[i] = RotateByQuaternion(corners[i], data.rotation);
        corners[i].X += data.center.X;
        corners[i].Y += data.center.Y;
        corners[i].Z += data.center.Z;
    }
    
    // 12条边
    int edges[12][2] = {
        {0,1}, {1,2}, {2,3}, {3,0}, // 底面
        {4,5}, {5,6}, {6,7}, {7,4}, // 顶面
        {0,4}, {1,5}, {2,6}, {3,7}  // 侧面
    };
    
    for (int i = 0; i < 12; i++) {
        lines.emplace_back(corners[edges[i][0]], corners[edges[i][1]], 0);
    }
    
    return lines;
}

inline std::vector<LineSegment> PhysXWireframeGenerator::GenerateCapsuleWireframe(const ColliderData& data) {
    std::vector<LineSegment> lines;
    lines.reserve(20);
    
    float radius = data.halfExtent.X;
    float halfHeight = data.halfExtent.Z;
    
    // 胶囊上下中心点
    Vector3 topCenter(0, 0, halfHeight);
    Vector3 bottomCenter(0, 0, -halfHeight);
    
    // 旋转
    topCenter = RotateByQuaternion(topCenter, data.rotation);
    bottomCenter = RotateByQuaternion(bottomCenter, data.rotation);
    
    // 平移
    topCenter.X += data.center.X;
    topCenter.Y += data.center.Y;
    topCenter.Z += data.center.Z;
    bottomCenter.X += data.center.X;
    bottomCenter.Y += data.center.Y;
    bottomCenter.Z += data.center.Z;
    
    // 上下圆各8条线 + 4条竖线 = 20条
    int segments = 8;
    for (int i = 0; i < segments; i++) {
        float angle1 = (float)i / segments * 2.0f * M_PI;
        float angle2 = (float)(i + 1) / segments * 2.0f * M_PI;
        
        // 上圆
        Vector3 p1_top(cosf(angle1) * radius, sinf(angle1) * radius, halfHeight);
        Vector3 p2_top(cosf(angle2) * radius, sinf(angle2) * radius, halfHeight);
        p1_top = RotateByQuaternion(p1_top, data.rotation);
        p2_top = RotateByQuaternion(p2_top, data.rotation);
        p1_top.X += data.center.X; p1_top.Y += data.center.Y; p1_top.Z += data.center.Z;
        p2_top.X += data.center.X; p2_top.Y += data.center.Y; p2_top.Z += data.center.Z;
        
        // 下圆
        Vector3 p1_bot(cosf(angle1) * radius, sinf(angle1) * radius, -halfHeight);
        Vector3 p2_bot(cosf(angle2) * radius, sinf(angle2) * radius, -halfHeight);
        p1_bot = RotateByQuaternion(p1_bot, data.rotation);
        p2_bot = RotateByQuaternion(p2_bot, data.rotation);
        p1_bot.X += data.center.X; p1_bot.Y += data.center.Y; p1_bot.Z += data.center.Z;
        p2_bot.X += data.center.X; p2_bot.Y += data.center.Y; p2_bot.Z += data.center.Z;
        
        lines.emplace_back(p1_top, p2_top, 0);
        lines.emplace_back(p1_bot, p2_bot, 0);
    }
    
    // 4条竖线 (每隔90度)
    for (int i = 0; i < 4; i++) {
        float angle = (float)i / 4.0f * 2.0f * M_PI;
        Vector3 p(cosf(angle) * radius, sinf(angle) * radius, 0);
        p = RotateByQuaternion(p, data.rotation);
        
        Vector3 top = Vector3(p.X, p.Y, halfHeight);
        Vector3 bot = Vector3(p.X, p.Y, -halfHeight);
        top = RotateByQuaternion(top, data.rotation);
        bot = RotateByQuaternion(bot, data.rotation);
        
        top.X += data.center.X; top.Y += data.center.Y; top.Z += data.center.Z;
        bot.X += data.center.X; bot.Y += data.center.Y; bot.Z += data.center.Z;
        
        lines.emplace_back(top, bot, 0);
    }
    
    return lines;
}

inline std::vector<LineSegment> PhysXWireframeGenerator::GenerateSphereWireframe(const ColliderData& data) {
    std::vector<LineSegment> lines;
    lines.reserve(24);
    
    float radius = data.halfExtent.X;
    
    // 3个圆环: XY, YZ, XZ 各8条线 = 24条
    int segments = 8;
    
    // XY 平面圆环
    for (int i = 0; i < segments; i++) {
        float angle1 = (float)i / segments * 2.0f * M_PI;
        float angle2 = (float)(i + 1) / segments * 2.0f * M_PI;
        
        Vector3 p1(cosf(angle1) * radius, sinf(angle1) * radius, 0);
        Vector3 p2(cosf(angle2) * radius, sinf(angle2) * radius, 0);
        
        p1 = RotateByQuaternion(p1, data.rotation);
        p2 = RotateByQuaternion(p2, data.rotation);
        
        p1.X += data.center.X; p1.Y += data.center.Y; p1.Z += data.center.Z;
        p2.X += data.center.X; p2.Y += data.center.Y; p2.Z += data.center.Z;
        
        lines.emplace_back(p1, p2, 0);
    }
    
    // YZ 平面圆环
    for (int i = 0; i < segments; i++) {
        float angle1 = (float)i / segments * 2.0f * M_PI;
        float angle2 = (float)(i + 1) / segments * 2.0f * M_PI;
        
        Vector3 p1(0, cosf(angle1) * radius, sinf(angle1) * radius);
        Vector3 p2(0, cosf(angle2) * radius, sinf(angle2) * radius);
        
        p1 = RotateByQuaternion(p1, data.rotation);
        p2 = RotateByQuaternion(p2, data.rotation);
        
        p1.X += data.center.X; p1.Y += data.center.Y; p1.Z += data.center.Z;
        p2.X += data.center.X; p2.Y += data.center.Y; p2.Z += data.center.Z;
        
        lines.emplace_back(p1, p2, 0);
    }
    
    // XZ 平面圆环
    for (int i = 0; i < segments; i++) {
        float angle1 = (float)i / segments * 2.0f * M_PI;
        float angle2 = (float)(i + 1) / segments * 2.0f * M_PI;
        
        Vector3 p1(cosf(angle1) * radius, 0, sinf(angle1) * radius);
        Vector3 p2(cosf(angle2) * radius, 0, sinf(angle2) * radius);
        
        p1 = RotateByQuaternion(p1, data.rotation);
        p2 = RotateByQuaternion(p2, data.rotation);
        
        p1.X += data.center.X; p1.Y += data.center.Y; p1.Z += data.center.Z;
        p2.X += data.center.X; p2.Y += data.center.Y; p2.Z += data.center.Z;
        
        lines.emplace_back(p1, p2, 0);
    }
    
    return lines;
}

inline std::vector<LineSegment> PhysXWireframeGenerator::GenerateStaticMeshWireframe(const ColliderData& data) {
    // 静态网格也用 Box 线框表示
    return GenerateBoxWireframe(data);
}

// 四元数旋转向量
inline Vector3 PhysXWireframeGenerator::RotateByQuaternion(const Vector3& v, const float q[4]) {
    // q = (x, y, z, w)
    float qx = q[0], qy = q[1], qz = q[2], qw = q[3];
    
    // 旋转公式: v' = v + 2 * cross(q.xyz, q.w * v + cross(q.xyz, v))
    float cx = qy * v.Z - qz * v.Y;
    float cy = qz * v.X - qx * v.Z;
    float cz = qx * v.Y - qy * v.X;
    
    float rx = v.X + 2.0f * (qw * cx + cy * qz - cz * qy);
    float ry = v.Y + 2.0f * (qw * cy + cz * qx - cx * qz);
    float rz = v.Z + 2.0f * (qw * cz + cx * qy - cy * qx);
    
    return Vector3(rx, ry, rz);
}

#endif /* PhysXWireframeGen_hpp */
