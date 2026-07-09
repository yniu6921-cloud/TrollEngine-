//
//  PhysXRaycast.hpp
//  PhysX 碰撞体可视化 - 射线检测模块
//
//  手动实现射线-OBB包围盒检测，支持旋转碰撞体，用于判断遮挡
//

#ifndef PhysXRaycast_hpp
#define PhysXRaycast_hpp

#include "PhysXColliderData.hpp"
#include <vector>
#include <cmath>
#include <algorithm>

// 射线结构
struct Ray {
    Vector3 origin;      // 射线起点
    Vector3 direction;   // 射线方向（归一化）
    float maxDistance;   // 射线最大距离

    Ray() : origin(), direction(), maxDistance(10000.0f) {}

    Ray(const Vector3& o, const Vector3& d, float dist = 10000.0f)
        : origin(o), direction(d), maxDistance(dist) {
        // 归一化方向
        float len = std::sqrt(direction.X * direction.X + direction.Y * direction.Y + direction.Z * direction.Z);
        if (len > 0.0001f) {
            direction.X /= len;
            direction.Y /= len;
            direction.Z /= len;
        }
    }
};

// 射线检测结果
struct RaycastHit {
    bool hit;                    // 是否击中
    float distance;              // 击中距离
    Vector3 hitPoint;           // 击中点
    const ColliderData* collider; // 击中的碰撞体

    RaycastHit() : hit(false), distance(0), hitPoint(), collider(nullptr) {}
};

class PhysXRaycast {
public:
    // 射线检测：检测从起点到终点之间是否有遮挡物
    // 返回第一个击中的碰撞体
    static RaycastHit LineOfSight(const Vector3& from, const Vector3& to,
                                   const std::vector<ColliderData>& colliders);

    // 快速遮挡检测：只检测Box类型（建筑物）
    static bool IsOccluded(const Vector3& from, const Vector3& to,
                           const std::vector<ColliderData>& colliders);

    // 四元数旋转向量 (q = [x, y, z, w]) — 公开供 PhysXColliderExtractor 使用
    static Vector3 QuatRotate(const float q[4], const Vector3& v) {
        // t = 2 * cross(q.xyz, v)
        float tx = 2.0f * (q[1] * v.Z - q[2] * v.Y);
        float ty = 2.0f * (q[2] * v.X - q[0] * v.Z);
        float tz = 2.0f * (q[0] * v.Y - q[1] * v.X);
        // v' = v + q.w * t + cross(q.xyz, t)
        Vector3 result;
        result.X = v.X + q[3] * tx + (q[1] * tz - q[2] * ty);
        result.Y = v.Y + q[3] * ty + (q[2] * tx - q[0] * tz);
        result.Z = v.Z + q[3] * tz + (q[0] * ty - q[1] * tx);
        return result;
    }

    // 四元数旋转（逆）- 使用共轭四元数
    static Vector3 QuatRotateInverse(const float q[4], const Vector3& v) {
        float inv_q[4] = {-q[0], -q[1], -q[2], q[3]};
        return QuatRotate(inv_q, v);
    }

    // 射线与OBB相交检测 (真正的有向包围盒，支持旋转)
    static bool RayOBBIntersection(const Ray& ray, const ColliderData& collider, float& outDistance);
};

// 射线与OBB相交检测（Slab method，在局部空间进行）
inline bool PhysXRaycast::RayOBBIntersection(const Ray& ray, const ColliderData& collider, float& outDistance) {
    // 将射线变换到 OBB 局部空间
    // 1. 平移：射线起点相对于 OBB 中心
    Vector3 relOrigin;
    relOrigin.X = ray.origin.X - collider.center.X;
    relOrigin.Y = ray.origin.Y - collider.center.Y;
    relOrigin.Z = ray.origin.Z - collider.center.Z;

    // 2. 旋转：用逆四元数将射线变换到局部空间
    Vector3 localOrigin = QuatRotateInverse(collider.rotation, relOrigin);
    Vector3 localDir = QuatRotateInverse(collider.rotation, ray.direction);

    // 避免除以零
    const float epsilon = 1e-8f;

    // 3. 在局部空间进行 AABB Slab 检测（盒子范围：[-halfExtent, halfExtent]）
    float tmin = -FLT_MAX;
    float tmax = FLT_MAX;

    // X slab
    if (std::fabs(localDir.X) > epsilon) {
        float t1 = (-collider.halfExtent.X - localOrigin.X) / localDir.X;
        float t2 = (collider.halfExtent.X - localOrigin.X) / localDir.X;
        if (t1 > t2) std::swap(t1, t2);
        if (t1 > tmin) tmin = t1;
        if (t2 < tmax) tmax = t2;
    } else if (localOrigin.X < -collider.halfExtent.X || localOrigin.X > collider.halfExtent.X) {
        return false; // 射线平行于X轴且不在盒子范围内
    }

    // Y slab
    if (std::fabs(localDir.Y) > epsilon) {
        float t1 = (-collider.halfExtent.Y - localOrigin.Y) / localDir.Y;
        float t2 = (collider.halfExtent.Y - localOrigin.Y) / localDir.Y;
        if (t1 > t2) std::swap(t1, t2);
        if (t1 > tmin) tmin = t1;
        if (t2 < tmax) tmax = t2;
    } else if (localOrigin.Y < -collider.halfExtent.Y || localOrigin.Y > collider.halfExtent.Y) {
        return false;
    }

    // Z slab
    if (std::fabs(localDir.Z) > epsilon) {
        float t1 = (-collider.halfExtent.Z - localOrigin.Z) / localDir.Z;
        float t2 = (collider.halfExtent.Z - localOrigin.Z) / localDir.Z;
        if (t1 > t2) std::swap(t1, t2);
        if (t1 > tmin) tmin = t1;
        if (t2 < tmax) tmax = t2;
    } else if (localOrigin.Z < -collider.halfExtent.Z || localOrigin.Z > collider.halfExtent.Z) {
        return false;
    }

    if (tmax < tmin) return false;

    // 取第一个有效交点（正方向上最近的）
    float t = (tmin > 0) ? tmin : tmax;

    if (t < 0 || t > ray.maxDistance) return false;

    outDistance = t;
    return true;
}

// 快速遮挡检测：只检测Box类型（建筑物），使用真正的OBB相交
inline bool PhysXRaycast::IsOccluded(const Vector3& from, const Vector3& to,
                                       const std::vector<ColliderData>& colliders) {
    // 计算方向和距离
    float dx = to.X - from.X;
    float dy = to.Y - from.Y;
    float dz = to.Z - from.Z;
    float totalDist = std::sqrt(dx*dx + dy*dy + dz*dz);

    if (totalDist < 1.0f) {
        return false; // 距离太近，认为无遮挡
    }

    // 创建射线
    Ray ray(from, Vector3(dx, dy, dz), totalDist);

    // 遍历所有静态碰撞体（建筑物）
    for (const auto& collider : colliders) {
        // 只检测静态物体
        if (collider.type != ColliderType::Box && collider.type != ColliderType::StaticMesh) {
            continue;
        }

        // OBB检测（正确处理旋转）
        float hitDist = 0;
        if (RayOBBIntersection(ray, collider, hitDist)) {
            // 击中！检查是否在到达敌人之前被遮挡
            if (hitDist < totalDist - 10.0f) { // 留10cm余量
                return true; // 被遮挡
            }
        }
    }

    return false; // 无遮挡
}

// 射线检测：检测从起点到终点之间是否有遮挡物，使用真正的OBB相交
inline RaycastHit PhysXRaycast::LineOfSight(const Vector3& from, const Vector3& to,
                                             const std::vector<ColliderData>& colliders) {
    RaycastHit result;
    result.hit = false;
    result.distance = 0;

    // 计算方向和距离
    float dx = to.X - from.X;
    float dy = to.Y - from.Y;
    float dz = to.Z - from.Z;
    float totalDist = std::sqrt(dx*dx + dy*dy + dz*dz);

    if (totalDist < 1.0f) {
        // 距离太近，认为无遮挡
        return result;
    }

    // 创建射线
    Ray ray(from, Vector3(dx, dy, dz), totalDist);

    float closestDist = totalDist;
    const ColliderData* closestCollider = nullptr;

    // 遍历所有碰撞体
    for (const auto& collider : colliders) {
        // 只检测静态物体（建筑物/障碍物）
        if (collider.type != ColliderType::Box && collider.type != ColliderType::StaticMesh) {
            continue;
        }

        // OBB检测（正确处理旋转）
        float hitDist = 0;
        if (RayOBBIntersection(ray, collider, hitDist)) {
            if (hitDist < closestDist) {
                closestDist = hitDist;
                closestCollider = &collider;
            }
        }
    }

    if (closestCollider) {
        result.hit = true;
        result.distance = closestDist;
        result.hitPoint.X = from.X + ray.direction.X * closestDist;
        result.hitPoint.Y = from.Y + ray.direction.Y * closestDist;
        result.hitPoint.Z = from.Z + ray.direction.Z * closestDist;
        result.collider = closestCollider;
    }

    return result;
}

#endif /* PhysXRaycast_hpp */
