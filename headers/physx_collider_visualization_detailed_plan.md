# PhysX 碰撞体可视化调试工具 - 详细实现计划

## 项目目标
构建轻量级 PhysX 碰撞体可视化工具，用于开发调试和 AI 场景理解。

## 核心理念
**必须使用 KFD 内核读取接口**来保证安全，防止被检测。

与现有"绘制掩体"原理一致：
- 使用 `KFD::Read<T>(address)` 读取数据
- 使用 `KFD::地址泄露(address)` 检查地址有效性
- 这是最稳定、版本兼容最好的方案

## 一、现有代码分析

### 已有的"绘制掩体"功能
- 位置：`sources/SHRenderView.mm` + `sources/FloatingExtras/oc悬浮菜单.mm`
- 原理：从 Actor 读取 CapsuleComponent → 绘制矩形框
- 现有开关：`绘制掩体`、`掩体变色调试`

### 关键 SDK 偏移（和平精英 1.35.12）
| 组件 | 偏移 | 字段 |
|------|------|------|
| Character | 0x660 | CapsuleComponent |
| CapsuleComponent | 0x7C8 | CapsuleHalfHeight |
| CapsuleComponent | 0x7CC | CapsuleRadius |
| SphereComponent | 0x7C8 | SphereRadius |
| BoxComponent | 0x7C8 | BoxExtent |
| PrimitiveComponent | 0x1F0 | ComponentToWorld |
| PrimitiveComponent | 0x468 | BodyInstance |

---

## 二、系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                    PhysX Collision Visualizer                │
├─────────────────────────────────────────────────────────────┤
│  Physics Layer (UE4 Components)                             │
│  ├── Actor 遍历 (PersistentLevel)                           │
│  ├── Component 遍历 (OwnedComponents)                        │
│  └── 几何读取 (Capsule/Box/Sphere/StaticMesh)               │
├─────────────────────────────────────────────────────────────┤
│  Collider Extraction Layer                                  │
│  ├── ColliderData 结构体                                    │
│  ├── 10Hz 更新节流                                          │
│  └── 40m 距离裁剪                                          │
├─────────────────────────────────────────────────────────────┤
│  Wireframe Generation Layer                                 │
│  ├── Box → 12 条线                                          │
│  ├── Capsule → 16 条线                                      │
│  ├── Sphere → 16 条线 (简化圆环)                           │
│  └── StaticMesh → 三角形线框                                │
├─────────────────────────────────────────────────────────────┤
│  AI Analysis Layer (预留接口)                               │
│  ├── 碰撞结构分析                                           │
│  ├── 场景理解                                               │
│  └── 路径可达性                                             │
├─────────────────────────────────────────────────────────────┤
│  Debug Visualization Layer                                  │
│  ├── ImGui::AddLine 渲染                                    │
│  ├── 颜色编码 (类型/可见性)                                 │
│  └── 单一 VertexBuffer 合批                                 │
├─────────────────────────────────────────────────────────────┤
│  Metal Rendering (现有 SHRenderView)                        │
│  └── 60fps 渲染                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 三、模块设计

### 1. ColliderData 结构体
```cpp
// sources/PhysXColliderData.hpp

enum class ColliderType : uint8_t {
    Capsule = 0,
    Box = 1,
    Sphere = 2,
    StaticMesh = 3,
    Unknown = 255
};

struct ColliderData {
    ColliderType   type;
    Vector3        center;        // 世界坐标
    Vector3        halfExtent;    // Box: 半长; Capsule: (radius, radius, halfHeight)
    float          rotation[4];    // Quaternion
    uint64_t       componentAddr; // 原始组件地址
    uint64_t       actor_addr;    // 所属 Actor
    uint32_t       lastUpdate;    // 更新时间戳
};
```

### 2. ColliderExtractor 提取器
```cpp
// sources/PhysXColliderExtractor.hpp

class PhysXColliderExtractor {
public:
    // 10Hz 节流更新
    static void ExtractIfNeeded();
    
    // 获取缓存的碰撞体数据
    static const std::vector<ColliderData>& GetColliders();
    
    // 清除缓存
    static void Clear();
    
private:
    static uint64_t s_lastExtractTime;
    static std::vector<ColliderData> s_cachedColliders;
    
    // 内部提取逻辑
    static void ExtractInternal();
    
    // 从 Actor 提取碰撞体
    static void ExtractFromActor(uint64_t actor);
    
    // 距离裁剪 (40m)
    static bool IsWithinDrawDistance(const Vector3& pos);
};
```

### 3. WireframeGenerator 线框生成器
```cpp
// sources/PhysXWireframeGen.hpp

struct LineSegment {
    Vector3 from;
    Vector3 to;
    uint32_t color;
};

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
    
    // StaticMesh: 简化三角形
    static std::vector<LineSegment> GenerateMeshWireframe(const ColliderData& data);
};
```

### 4. 渲染集成
```cpp
// 在 SHRenderView.mm 中添加

// 渲染入口
void RenderPhysXColliders(ImDrawList* drawList) {
    if (!g_PhysXColliderEnabled) return;
    
    // 1. 提取碰撞体 (10Hz)
    PhysXColliderExtractor::ExtractIfNeeded();
    
    // 2. 生成线框
    auto lines = PhysXWireframeGenerator::Generate(
        PhysXColliderExtractor::GetColliders()
    );
    
    // 3. 渲染每条线
    for (const auto& line : lines) {
        Vector2 screenFrom, screenTo;
        if (WorldToScreen(line.from, screenFrom) && 
            WorldToScreen(line.to, screenTo)) {
            drawList->AddLine(
                ImVec2(screenFrom.x, screenFrom.y),
                ImVec2(screenTo.x, screenTo.y),
                line.color, 0.5f);
        }
    }
}
```

---

## 四、实现步骤

### 步骤 1: 创建核心数据结构
- [ ] 创建 `sources/PhysXColliderData.hpp`
- [ ] 定义 ColliderType 枚举
- [ ] 定义 ColliderData 结构体

### 步骤 2: 实现碰撞体提取器
- [ ] 创建 `sources/PhysXColliderExtractor.hpp`
- [ ] 实现 10Hz 节流逻辑
- [ ] 实现 Actor 遍历
- [ ] 实现 Component 遍历
- [ ] 实现距离裁剪 (40m = 4000cm)

### 步骤 3: 实现线框生成器
- [ ] 创建 `sources/PhysXWireframeGen.hpp`
- [ ] 实现 Box 线框 (12线)
- [ ] 实现 Capsule 线框 (16线)
- [ ] 实现 Sphere 线框 (16线)
- [ ] 实现 StaticMesh 线框 (简化三角)

### 步骤 4: 渲染集成
- [ ] 在 `SHRenderView.mm` 添加渲染调用
- [ ] 添加 `extern BOOL 绘制PhysX碰撞体;`
- [ ] 实现颜色编码

### 步骤 5: 菜单开关
- [ ] 在 `oc悬浮菜单.mm` 添加开关
- [ ] 添加 key: `@"AAphysxcollider"`
- [ ] 同步 iCloud/UserDefaults

---

## 五、性能优化规则

1. **提取频率**: Debug Draw ≤ 10Hz (每100ms更新一次)
2. **渲染频率**: 60fps (使用缓存的线框数据)
3. **距离裁剪**: 40米内 (4000cm)
4. **合批渲染**: 单一 VertexBuffer
5. **Draw Call**: ≤ 1 次
6. **禁止**: 复杂 Shader、实时 Mesh 生成

---

## 六、颜色编码方案

| 类型 | 颜色 | 说明 |
|------|------|------|
| Capsule | 0xFF00FFFF (青色) | 角色碰撞体 |
| Box | 0xFF00FF00 (绿色) | 建筑/障碍物 |
| Sphere | 0xFFFF0000 (红色) | 触发器 |
| StaticMesh | 0xFFFFFF00 (黄色) | 静态物体 |
| 被遮挡 | 0xFF808080 (灰色) | 掩体变色功能 |

---

## 七、AI 分析层接口 (预留)

```cpp
// 后续扩展用，当前为空实现
struct CollisionAnalysisResult {
    bool pathReachable;
    bool hasOcclusion;
    float coveragePercent;
};

CollisionAnalysisResult AnalyzeCollisionStructure(
    const std::vector<ColliderData>& colliders,
    Vector3 from, 
    Vector3 to
);
```

---

## 八、文件清单

| 步骤 | 文件路径 | 内容 |
|------|----------|------|
| 1 | `sources/PhysXColliderData.hpp` | 核心数据结构 |
| 2 | `sources/PhysXColliderExtractor.hpp` | 碰撞体提取器 |
| 3 | `sources/PhysXWireframeGen.hpp` | 线框生成器 |
| 4 | 修改 `sources/SHRenderView.mm` | 渲染集成 |
| 5 | 修改 `sources/FloatingExtras/oc悬浮菜单.mm` | 菜单开关 |

---

## 九、风险与降级方案

| 风险 | 降级方案 |
|------|----------|
| Component 遍历失败 | 仅绘制角色 Capsule (0x660) |
| 性能不足 | 降低更新频率至 5Hz |
| 内存不足 | 减小裁剪距离至 30m |
| 复杂 Mesh | 跳过，仅支持 Box/Capsule/Sphere |

---

## 十、与现有"绘制掩体"的关系

本项目**继承并扩展**现有"绘制掩体"功能：

| 现有功能 | 扩展后 |
|----------|--------|
| 矩形框 (2D) | 线框 (3D) |
| 仅 Capsule | Capsule + Box + Sphere + Mesh |
| 单一颜色 | 类型颜色编码 |
| 无 AI 接口 | 预留 AI 分析接口 |

**核心差异**：
- 现有：绘制 2D 矩形框（世界坐标 → 屏幕坐标 → 矩形）
- 扩展：绘制 3D 线框（保留深度信息，更精确表示碰撞体）

---

## 十一、下一步行动

请确认以下选项：

1. **从哪个模块开始？** (推荐：步骤1 数据结构)
2. **是否需要先验证偏移量？** (可通过现有"绘制掩体"代码测试)
3. **需要支持哪些碰撞体类型？** (当前计划：Box/Capsule/Sphere)
4. **是否需要 AI 分析层？** (当前为空实现预留)

---

*生成时间: 2026/3/7*
*版本: 1.0*
