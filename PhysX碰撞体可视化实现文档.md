# PhysX 碰撞体可视化调试工具 - 实现文档

## 概述

本文档记录了 PhysX 碰撞体可视化调试工具的实现细节，用于开发调试和 AI 场景理解。

## 核心模块

### 1. PhysXColliderData.hpp
碰撞体数据结构定义，存储从游戏内存中提取的碰撞体信息。

### 2. PhysXColliderExtractor.hpp  
碰撞体数据提取器，负责从游戏进程中读取 PhysX 碰撞体数据。

### 3. PhysXWireframeGen.hpp
线框生成器，将碰撞体数据转换为可渲染的线框几何。

## 渲染集成

### 入口点
文件：`sources/SHRenderView.mm`

### 开关控制
- 主开关：`绘制模型` (BOOL 绘制模型)
- 调试开关：`掩体变色调试` (BOOL 掩体变色调试)

### 渲染逻辑
位于 `读取数据()` 函数中，当 `绘制模型 && distance <= 500.0f` 时执行：

1. **Capsule 投影掩体框**
   - 从 Actor 的 CapsuleComponent (+0x660) 读取几何信息
   - 计算缩放后的半径和半高
   - 投影到屏幕坐标绘制矩形

2. **掩体变色**
   - 读取 MeshComponent 的 LastRenderTimeOnScreen (+0x414)
   - 与当前游戏时间比较：差值 < 1秒 = 可见(绿色)
   - 否则 = 被遮挡(红色)

3. **地板投影**
   - 脚底水平面 50x50 单位投影到屏幕
   - 绘制四边形地面参考

4. **线框人形**
   - 使用骨骼系统绘制线框
   - 按 BoneTree 父子关系连线
   - 颜色与掩体框一致（可见=绿，遮挡=红）

## 调试方法

### 1. 开启掩体变色调试
在 iCloud 设置中开启 `掩体变色调试`，会在掩体框上方显示调试信息：
- `gw` - GameState 地址
- `t` - 当前世界时间
- `r` - 敌人渲染时间
- `d` - 时间差
- `可见/遮挡` - 可见性判定结果

### 2. 距离控制
- 默认渲染距离：<= 500米
- 可通过代码中的 `distance <= 500.0f` 调整

### 3. 常见问题排查

**Q: 掩体框不显示**
- 检查 `绘制模型` 开关是否开启
- 确认距离在 500 米以内
- 检查内核状态是否在线

**Q: 掩体变色不准确**
- 调试：开启 `掩体变色调试` 查看时间差
- 可调整 `1.0f` 阈值（单位：秒）

**Q: 线框人形乱线**
- 检查 BoneTree 数据是否有效
- 降级模式使用固定 20 骨骼连接表

## 相关偏移量

| 偏移 | 用途 |
|------|------|
| +0x660 | CapsuleComponent |
| +0x414 | LastRenderTimeOnScreen |
| +0x7F0 | SkeletalMesh |
| +0x48 | Skeleton |
| +0x30 | BoneTree (TArray) |

## 文件结构

```
sources/
├── PhysXColliderData.hpp      # 数据结构
├── PhysXColliderExtractor.hpp  # 数据提取
├── PhysXWireframeGen.hpp      # 线框生成
└── SHRenderView.mm            # 渲染入口
```

## 版本信息

- 创建日期：2026/3/7
- 目标游戏：和平精英 (PUBG Mobile)
- SDK版本：1.35.12
