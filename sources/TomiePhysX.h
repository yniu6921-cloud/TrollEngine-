#ifndef PHYSX_TOMIE_H
#define PHYSX_TOMIE_H

#include <cstdint>
#include <iostream>
#include <cmath>
#include <functional>
#include <string>
#include <cstring>
#include <vector>
#include <array>
#include "VectorTool.h"

// 初始化模型库 需要传入驱动读取方法
// license_key 您的卡密
// libUE4 你源码中获取到的UE4基址
// kernel_readv 读取包装类
// game 游戏选择 0=和平精英 1=PUBGM 2=无畏契约 3=三角洲行动

void Init_TomieModel(std::string license_key, uintptr_t libUE4, bool (*kernel_readv)(uint64_t addr, void* buffer, size_t size), int game);

// 初始化模型库重载函数 不需要传入驱动读取方法直接使用纯C 这个方法需要传入pid
// license_key 您的卡密
// pid 你源码中获取到的游戏pid
// libUE4 你源码中获取到的UE4基址
// game 游戏选择 0=和平精英 1=PUBGM 2=无畏契约 3=三角洲行动

void Init_TomieModel(std::string license_key, pid_t pid, uintptr_t libUE4, int game);

// 射线检测方法
// location 你源码中获取的POV视角
// coord 你源码中的骨骼坐标

bool RayTracing(const D3DVector& location, const D3DVector& coord);

// 模型绘制调用
// cameraPos 你源码中获取的POV视角
// cameraRot 你源码中基于POV视角 + 0x18 偏移出的视角旋转
// fov 你的游戏fov数据
// screenWidth 你源码中获取到的屏幕X宽度
// screenHeight 你源码中获取到的屏幕Y宽度

std::vector<std::array<Vec3, 3>> ModelMesh(const Vec3& cameraPos, const Rotator& cameraRot, float fov, int screenWidth, int screenHeight);

// 初始化陀螺仪控制

bool Init_gyro();

// 注入陀螺仪坐标
// x 注入的陀螺仪X坐标
// y 注入的陀螺仪y坐标

void Infuse_gyro(float x, float y);

// 停止注入陀螺仪

void stop_gyro();

#endif