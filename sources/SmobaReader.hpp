#pragma once
#include <stdint.h>
#include <string>
#include <vector>
#include <cstring>
#include <cmath>
#include "KFD.hpp"

// 王者荣耀 Unity IL2CPP 内存读取
// 通过 KFD 内核读取找到 ActorManager 单例 → TinyValueList → PoolObjHandle[] → ActorLinker 坐标
//
// 流程:
// 1. 找到 UnityFramework 模块基址
// 2. 解析 Mach-O export trie 找到 il2cpp_class_get_name / get_parent / get_static_field_data
// 3. 读取 LDR 指令立即数 → 得到 Il2CppClass struct 字段偏移(name/parent/static_fields)
// 4. 找到 "ActorManager\0" 字符串在二进制中的地址
// 5. 扫描 __DATA 段寻找指向该字符串的 Il2CppClass (name field)
// 6. 验证 parent 字段 → 另一个 Il2CppClass
// 7. 读取 parent 的 static_fields → 缓冲区 → 第1个 qword = ActorManager*
// 8. 读取 TinyValueList(@+24) → PoolObjHandle[] → ActorLinker 坐标

struct SmobaActorData {
    int objID = 0;
    int camp = 0;        // 阵营: 1=蓝方, 2=红方 (0=未知)
    std::string name;
    float x = 0, y = 0, z = 0;
};

// 相机数据 (Unity 坐标系: X=右, Y=上, Z=前)
struct SmobaCameraData {
    uint64_t cameraAddr = 0;           // Camera 组件地址 (0=未找到)
    float posX = 0, posY = 0, posZ = 0; // 相机世界坐标
    float lookX = 0, lookY = 0, lookZ = 0; // 注视点
    float fov = 60.0f;                 // 视野角度
    bool valid = false;
    bool estimated = false;            // true=估算而非真实读取
};

struct SmobaReadResult {
    std::vector<SmobaActorData> actors;
    uint64_t unityFrameworkBase = 0;
    uint64_t actorManagerAddr = 0;
    int heroCount = 0;
    int localPlayerCamp = 0;   // 本地玩家阵营
    SmobaCameraData camera;
    bool valid = false;
};

// ============================================================
// ULEB128 解码 (export trie 格式)
// ============================================================
static inline uint64_t Smoba_ReadULEB128(uint64_t addr, int *bytes_read = nullptr) {
    uint64_t result = 0;
    int shift = 0, cnt = 0;
    while (true) {
        uint8_t byte = KFD::Read<uint8_t>(addr + cnt);
        cnt++;
        result |= (uint64_t)(byte & 0x7F) << shift;
        shift += 7;
        if (!(byte & 0x80)) break;
    }
    if (bytes_read) *bytes_read = cnt;
    return result;
}

// ============================================================
// 从 Mach-O 解析 segment 信息 (fileoff <-> runtime 转换)
// ============================================================
struct Smoba_SegInfo {
    char name[17];
    uint64_t vmaddr;
    uint64_t vmsize;
    uint64_t fileoff;
    uint64_t filesize;
};

static inline int Smoba_ParseSegments(uint64_t ufBase, Smoba_SegInfo *segs, int max_segs,
                                       uint64_t *out_text_vmaddr) {
    uint32_t magic = KFD::Read<uint32_t>(ufBase);
    if (magic != 0xFEEDFACF) return 0;

    uint32_t ncmds = KFD::Read<uint32_t>(ufBase + 0x10);
    uint64_t cursor = ufBase + 0x20;
    int seg_cnt = 0;

    for (uint32_t i = 0; i < ncmds && seg_cnt < max_segs; i++) {
        uint32_t cmd = KFD::Read<uint32_t>(cursor);
        uint32_t cmdsize = KFD::Read<uint32_t>(cursor + 4);

        if (cmd == 0x19) { // LC_SEGMENT_64
            auto &seg = segs[seg_cnt];
            for (int j = 0; j < 16; j++)
                seg.name[j] = (char)KFD::Read<uint8_t>(cursor + 8 + j);
            seg.name[16] = 0;
            seg.vmaddr  = KFD::Read<uint64_t>(cursor + 0x18);
            seg.vmsize  = KFD::Read<uint64_t>(cursor + 0x20);
            seg.fileoff = KFD::Read<uint64_t>(cursor + 0x28);
            seg.filesize = KFD::Read<uint64_t>(cursor + 0x30);
            if (strcmp(seg.name, "__TEXT") == 0 && out_text_vmaddr)
                *out_text_vmaddr = seg.vmaddr;
            seg_cnt++;
        }
        cursor += cmdsize;
    }
    return seg_cnt;
}

static inline uint64_t Smoba_FileOffToRuntime(uint64_t ufBase, uint64_t fileoff,
                                               Smoba_SegInfo *segs, int seg_cnt,
                                               uint64_t text_vmaddr) {
    uint64_t slide = ufBase - text_vmaddr;
    for (int i = 0; i < seg_cnt; i++) {
        if (fileoff >= segs[i].fileoff &&
            fileoff < segs[i].fileoff + segs[i].filesize) {
            return segs[i].vmaddr + slide + (fileoff - segs[i].fileoff);
        }
    }
    return 0;
}

// 查找某个 segment 的 vmaddr+fileoff
static inline uint64_t Smoba_GetSegVMAddr(Smoba_SegInfo *segs, int seg_cnt, const char *name) {
    for (int i = 0; i < seg_cnt; i++)
        if (strcmp(segs[i].name, name) == 0) return segs[i].vmaddr;
    return 0;
}

// ============================================================
// 在 Mach-O export trie 中查找导出符号地址
// ============================================================
static inline uint64_t Smoba_FindExport(uint64_t ufBase, const char *sym_name) {
    uint32_t magic = KFD::Read<uint32_t>(ufBase);
    if (magic != 0xFEEDFACF) return 0;

    uint32_t ncmds = KFD::Read<uint32_t>(ufBase + 0x10);
    uint64_t cursor = ufBase + 0x20;

    uint64_t export_off = 0;
    uint32_t export_size = 0;
    uint64_t text_vmaddr = 0;
    Smoba_SegInfo segs[8];
    int seg_cnt = 0;

    for (uint32_t i = 0; i < ncmds; i++) {
        uint32_t cmd = KFD::Read<uint32_t>(cursor);
        uint32_t cmdsize = KFD::Read<uint32_t>(cursor + 4);

        if (cmd == 0x19) { // LC_SEGMENT_64
            if (seg_cnt < 8) {
                auto &seg = segs[seg_cnt];
                for (int j = 0; j < 16; j++)
                    seg.name[j] = (char)KFD::Read<uint8_t>(cursor + 8 + j);
                seg.name[16] = 0;
                seg.vmaddr   = KFD::Read<uint64_t>(cursor + 0x18);
                seg.vmsize   = KFD::Read<uint64_t>(cursor + 0x20);
                seg.fileoff  = KFD::Read<uint64_t>(cursor + 0x28);
                seg.filesize = KFD::Read<uint64_t>(cursor + 0x30);
                if (strcmp(seg.name, "__TEXT") == 0) text_vmaddr = seg.vmaddr;
                seg_cnt++;
            }
        } else if (cmd == 0x22 || cmd == 0x8000001D) {
            // LC_DYLD_INFO or LC_DYLD_INFO_ONLY
            // dyld_info_command layout (offsets from cursor):
            // cmd+0, cmdsize+4, rebase_off+8, rebase_size+12,
            // bind_off+16, bind_size+20, weak_bind_off+24, weak_bind_size+28,
            // lazy_bind_off+32, lazy_bind_size+36, export_off+40, export_size+44
            export_off  = KFD::Read<uint32_t>(cursor + 40);
            export_size = KFD::Read<uint32_t>(cursor + 44);
        }
        cursor += cmdsize;
    }

    if (!export_off || !export_size || !seg_cnt) return 0;

    // 转换 export trie 文件偏移为运行时地址
    uint64_t trie_runtime = Smoba_FileOffToRuntime(ufBase, export_off, segs, seg_cnt, text_vmaddr);
    if (!trie_runtime) return 0;

    // 遍历 export trie 匹配符号名
    uint64_t node_off = 0; // 相对 trie_runtime 的偏移
    const char *p = sym_name;

    while (node_off < export_size) {
        uint64_t node_addr = trie_runtime + node_off;
        int term_bytes;
        uint64_t term_size = Smoba_ReadULEB128(node_addr, &term_bytes);
        uint64_t cur = term_bytes;

        // 如果是终端节点 且 已完全匹配符号名 = 找到!
        if (term_size > 0 && *p == '\0') {
            int fb;
            uint64_t flags = Smoba_ReadULEB128(node_addr + cur, &fb); cur += fb;
            uint64_t sym_off = Smoba_ReadULEB128(node_addr + cur, &fb);
            return ufBase + sym_off; // 符号运行时地址 = 基址 + 偏移
        }

        // 遍历 edges, 找到匹配剩余名称的子节点
        bool matched = false;
        while (cur + node_off < export_size) {
            int eb;
            uint64_t edge_len = Smoba_ReadULEB128(node_addr + cur, &eb);
            cur += eb;
            if (edge_len == 0) break; // end of edges

            // 读取 edge 字符串
            char edge_buf[256];
            uint64_t read_len = (edge_len < 255) ? edge_len : 255;
            for (uint64_t j = 0; j < read_len; j++)
                edge_buf[j] = (char)KFD::Read<uint8_t>(node_addr + cur + j);
            edge_buf[read_len] = '\0';
            cur += edge_len;

            // 子节点偏移
            int cob;
            uint64_t child_off = Smoba_ReadULEB128(node_addr + cur, &cob);
            cur += cob;

            // 检查是否匹配
            if (strncmp(p, edge_buf, edge_len) == 0) {
                p += edge_len;
                node_off = child_off;
                matched = true;
                break;
            }
        }

        if (!matched) return 0; // 未找到
    }
    return 0;
}

// ============================================================
// 读取 LDR 指令的立即数偏移
// il2cpp_class_get_name / get_parent / get_static_field_data 都是
//   ldr x0, [x0, #offset]   // 0xF9400000 | (imm/8)<<10
//   ret                      // 0xD65F03C0
// ============================================================
static inline int Smoba_ReadLdrOffset(uint64_t func_addr) {
    if (!func_addr) return -1;
    uint32_t insn = KFD::Read<uint32_t>(func_addr);
    // ARM64 LDR (immediate, unsigned offset): 1opc 111101 0 imm12 Rn Rt
    // opc=01 (32-bit) or 10 (64-bit), imm12 = offset/8
    // 64-bit ldr: bit pattern = 0xF9400000 | (imm12 << 10) | (Rn << 5) | Rt
    if ((insn & 0xFFC00000) != 0xF9400000) return -2; // not LDR x?, [x?, #imm]
    uint32_t imm12 = (insn >> 10) & 0xFFF;
    return (int)(imm12 * 8);
}

// ============================================================
// 在 UnityFramework 中查找某个 C 字符串 (分块读取, 避免逐字节 KFD)
// ============================================================
static inline uint64_t Smoba_FindString(uint64_t ufBase, const char *target) {
    uint64_t text_vmaddr = 0;
    Smoba_SegInfo segs[8];
    int seg_cnt = Smoba_ParseSegments(ufBase, segs, 8, &text_vmaddr);
    if (!seg_cnt) return 0;

    uint64_t slide = ufBase - text_vmaddr;
    size_t tlen = strlen(target);
    if (tlen == 0 || tlen > 256) return 0;

    // 查找 __TEXT 段
    uint64_t text_start = 0, text_end = 0;
    for (int i = 0; i < seg_cnt; i++) {
        if (strcmp(segs[i].name, "__TEXT") == 0) {
            text_start = segs[i].vmaddr + slide;
            text_end = text_start + segs[i].vmsize;
            break;
        }
    }
    if (!text_start) return 0;

    // 分块读取搜索 (每块 4KB)
    const size_t kChunkSize = 4096;
    uint64_t buf[kChunkSize / sizeof(uint64_t)]; // 4KB 缓冲区
    size_t buf_valid = 0;

    for (uint64_t addr = text_start; addr + tlen < text_end; addr += kChunkSize - tlen) {
        uint64_t read_end = addr + kChunkSize;
        if (read_end > text_end) read_end = text_end;
        size_t to_read = (size_t)(read_end - addr);

        if (!KFD::read_buf_paged(&KFD::S().handle, addr, buf, to_read, KFD::S().vm_map_pmap))
            continue;

        const char *chunk = (const char *)buf;
        for (size_t i = 0; i + tlen <= to_read; i++) {
            if (chunk[i] == target[0]) {
                bool match = true;
                for (size_t j = 0; j < tlen; j++) {
                    if (chunk[i + j] != target[j]) { match = false; break; }
                }
                if (match && chunk[i + tlen] == '\0')
                    return addr + i;
            }
        }
    }
    return 0;
}

// ============================================================
// 获取 __DATA 段运行时范围
// ============================================================
static inline bool Smoba_GetDataRange(uint64_t ufBase, uint64_t *out_start, uint64_t *out_end) {
    uint64_t text_vmaddr = 0;
    Smoba_SegInfo segs[8];
    int seg_cnt = Smoba_ParseSegments(ufBase, segs, 8, &text_vmaddr);
    if (!seg_cnt) return false;

    uint64_t slide = ufBase - text_vmaddr;
    *out_start = UINT64_MAX;
    *out_end = 0;
    for (int i = 0; i < seg_cnt; i++) {
        // IL2CPP 的 Il2CppClass 可能在 __DATA, __DATA_CONST, __AUTH_CONST 等段
        if (strcmp(segs[i].name, "__DATA") == 0 ||
            strcmp(segs[i].name, "__DATA_CONST") == 0 ||
            strcmp(segs[i].name, "__AUTH_CONST") == 0) {
            uint64_t seg_start = segs[i].vmaddr + slide;
            uint64_t seg_end   = seg_start + segs[i].vmsize;
            if (seg_start < *out_start) *out_start = seg_start;
            if (seg_end > *out_end) *out_end = seg_end;
        }
    }
    return *out_start < *out_end;
}

// ============================================================
// 查找 ActorManager Il2CppClass 并获取 singleton 地址
// ============================================================
struct Il2CppOffsets {
    int name_off;     // offset of `const char* name` in Il2CppClass
    int parent_off;   // offset of `Il2CppClass* parent`
    int sf_off;       // offset of `void* static_fields`
};

// 通过读取导出的 il2cpp_class_* 函数确定 Il2CppClass 字段偏移
static inline bool Smoba_GetIl2CppOffsets(uint64_t ufBase, Il2CppOffsets *out) {
    // 查找导出函数地址
    uint64_t fn_get_name  = Smoba_FindExport(ufBase, "il2cpp_class_get_name");
    uint64_t fn_get_parent = Smoba_FindExport(ufBase, "il2cpp_class_get_parent");
    uint64_t fn_get_sf    = Smoba_FindExport(ufBase, "il2cpp_class_get_static_field_data");

    if (!fn_get_name) {
        // 可能没有 export trie (开发版本), 尝试 nlist symbol table
        // 这里简化处理: 如果 export 找不到, 用默认偏移猜
        return false;
    }

    int name_off   = Smoba_ReadLdrOffset(fn_get_name);
    int parent_off = Smoba_ReadLdrOffset(fn_get_parent);
    int sf_off     = Smoba_ReadLdrOffset(fn_get_sf);

    if (name_off < 0 || parent_off < 0 || sf_off < 0) return false;

    out->name_off     = name_off;
    out->parent_off   = parent_off;
    out->sf_off       = sf_off;
    return true;
}

// 在 __DATA 段中扫描所有 Il2CppClass, 找到 name 指向目标字符串的类
// 返回 Il2CppClass* 地址
static inline uint64_t Smoba_FindIl2CppClass(uint64_t ufBase, const char *class_name,
                                              const Il2CppOffsets &off) {
    uint64_t data_start = 0, data_end = 0;
    if (!Smoba_GetDataRange(ufBase, &data_start, &data_end)) return 0;

    // 先找到目标字符串的运行时地址
    uint64_t name_str_addr = Smoba_FindString(ufBase, class_name);
    if (!name_str_addr) return 0;

    // 扫描 __DATA 段 (8 字节对齐)
    for (uint64_t addr = data_start; addr + 256 < data_end; addr += 8) {
        uint64_t name_ptr = KFD::Read<uint64_t>(addr + off.name_off);
        if (name_ptr != name_str_addr) continue;

        // 候选: 验证 parent 字段是否指向 __DATA 段内的另一个地址
        uint64_t parent = KFD::Read<uint64_t>(addr + off.parent_off);
        if (parent >= data_start && parent < data_end) {
            // parent 有效, 进一步验证 parent 的 name 是合理的
            uint64_t parent_name = KFD::Read<uint64_t>(parent + off.name_off);
            // parent 的 name 应该指向一个非空字符串
            if (parent_name > 0x100000000) {
                return addr; // 找到 ActorManager 的 Il2CppClass
            }
        }
    }
    return 0;
}

// ============================================================
// 在 Unity 中查找 Camera 组件
// ============================================================
static inline SmobaCameraData Smoba_FindUnityCamera(uint64_t ufBase,
    const Il2CppOffsets &off,
    const SmobaActorData &localPlayer) {
    SmobaCameraData result;

    // === 方法 1: 通过 Il2CppClass 扫描 Camera 实例 ===
    uint64_t dataStart = 0, dataEnd = 0;
    if (Smoba_GetDataRange(ufBase, &dataStart, &dataEnd)) {
        // 查找 "Camera" 字符串
        uint64_t cameraStrAddr = Smoba_FindString(ufBase, "Camera");
        if (cameraStrAddr) {
            uint64_t cameraClass = 0;
            // 扫描 Il2CppClass
            for (uint64_t addr = dataStart; addr + 256 < dataEnd; addr += 8) {
                uint64_t namePtr = KFD::Read<uint64_t>(addr + off.name_off);
                if (namePtr == cameraStrAddr) {
                    uint64_t parent = KFD::Read<uint64_t>(addr + off.parent_off);
                    if (parent >= dataStart && parent < dataEnd) {
                        cameraClass = addr;
                        break;
                    }
                }
            }

            // 如果找到 Camera Il2CppClass, 扫描实例
            if (cameraClass) {
                for (uint64_t addr = dataStart; addr + 128 < dataEnd; addr += 16) {
                    uint64_t klass = KFD::Read<uint64_t>(addr);
                    if (klass != cameraClass) continue;

                    // 验证: Component 有 gameObject 指针
                    uint64_t gameObj = KFD::Read<uint64_t>(addr + 0x10);
                    if (!gameObj || gameObj < 0x100000000) continue;

                    result.cameraAddr = addr;

                    // 尝试读取 FOV (Unity Camera.fieldOfView 常见偏移)
                    for (int fovOff = 0x34; fovOff < 0x54; fovOff += 4) {
                        float fov = KFD::Read<float>(addr + fovOff);
                        if (fov > 20.0f && fov < 160.0f) {
                            result.fov = fov;
                            break;
                        }
                    }

                    // 尝试从 GameObject 找到 Transform 读取位置
                    // GameObject+0x10 通常是 Transform 组件的指针 (Unity 2020+)
                    uint64_t transformComp = KFD::Read<uint64_t>(gameObj + 0x10);
                    if (transformComp && transformComp > 0x100000000) {
                        // Transform+0x18 是 CachedTransform (native)
                        uint64_t cachedTransform = KFD::Read<uint64_t>(transformComp + 0x18);
                        if (cachedTransform && cachedTransform > 0x100000000) {
                            // 尝试常见偏移读取 position (Unity 2020-2022)
                            // CachedTransform 的结构: 0x00 vtable, 0x08 parent, 0x10 localPosition
                            // 或: 0x00 vtable, 0x08 refcount, 0x10 parent, 0x20 localPosition
                            for (int posOff = 0x10; posOff <= 0x30; posOff += 4) {
                                float px = KFD::Read<float>(cachedTransform + posOff);
                                float py = KFD::Read<float>(cachedTransform + posOff + 4);
                                float pz = KFD::Read<float>(cachedTransform + posOff + 8);
                                if (std::isfinite(px) && std::isfinite(py) && std::isfinite(pz)) {
                                    // 验证: 相机离玩家不会太远 (通常 < 3000 单位)
                                    float dx = px - localPlayer.x;
                                    float dy = py - localPlayer.y;
                                    float dz = pz - localPlayer.z;
                                    float dist = sqrt(dx*dx + dy*dy + dz*dz);
                                    if (dist > 100.0f && dist < 5000.0f) {
                                        result.posX = px;
                                        result.posY = py;
                                        result.posZ = pz;
                                        result.lookX = localPlayer.x;
                                        result.lookY = localPlayer.y;
                                        result.lookZ = localPlayer.z;
                                        result.valid = true;
                                        result.estimated = false;
                                        return result;
                                    }
                                }
                            }
                        }
                    }
                    break; // 只尝试第一个 Camera
                }
            }
        }
    }

    // === 方法 2: 估算相机 (MOBA 固定视角) ===
    // 王者荣耀使用固定俯视角: 相机在玩家上方偏一个固定方向
    if (localPlayer.x != 0 || localPlayer.y != 0 || localPlayer.z != 0) {
        // 估算偏移 (Unity 坐标系: Y 向上)
        // 相机在玩家上方 800 单位, 后方(Z负) 500 单位, 偏右 300 单位
        float camOffX = 300.0f;   // 偏右
        float camOffY = 800.0f;   // 上方
        float camOffZ = -500.0f;  // 后方

        result.posX = localPlayer.x + camOffX;
        result.posY = localPlayer.y + camOffY;
        result.posZ = localPlayer.z + camOffZ;
        result.lookX = localPlayer.x;
        result.lookY = localPlayer.y;
        result.lookZ = localPlayer.z;
        result.valid = true;
        result.estimated = true;
    }

    return result;
}

// ============================================================
// Unity WorldToScreen (Y-up 坐标系)
// ============================================================
static inline Vector2 Smoba_WorldToScreen(float wX, float wY, float wZ,
                                           const SmobaCameraData &cam,
                                           float screenW, float screenH) {
    if (!cam.valid) return {-1, -1};

    // 相机前方向 (相机→注视点)
    float fX = cam.lookX - cam.posX;
    float fY = cam.lookY - cam.posY;
    float fZ = cam.lookZ - cam.posZ;
    float fLen = sqrt(fX*fX + fY*fY + fZ*fZ);
    if (fLen < 0.0001f) return {-1, -1};
    fX /= fLen; fY /= fLen; fZ /= fLen;

    // 相机右方向 = cross(forward, worldUp) worldUp=(0,1,0)
    float rX = fY * 1.0f - fZ * 0.0f;
    float rY = fZ * 0.0f - fX * 1.0f;
    float rZ = fX * 0.0f - fY * 0.0f;
    float rLen = sqrt(rX*rX + rY*rY + rZ*rZ);
    if (rLen < 0.0001f) return {-1, -1};
    rX /= rLen; rY /= rLen; rZ /= rLen;

    // 相机上方向 = cross(right, forward)
    float uX = rY*fZ - rZ*fY;
    float uY = rZ*fX - rX*fZ;
    float uZ = rX*fY - rY*fX;

    // 世界点→相机空间
    float dX = wX - cam.posX;
    float dY = wY - cam.posY;
    float dZ = wZ - cam.posZ;

    float vX = dX*rX + dY*rY + dZ*rZ;  // 右方向分量
    float vY = dX*uX + dY*uY + dZ*uZ;  // 上方向分量
    float vZ = dX*fX + dY*fY + dZ*fZ;  // 前方向分量

    if (vZ < 0.01f) return {-1, -1}; // 在相机后方

    // 透视投影
    float tanHalfFov = tanf(cam.fov * (float)M_PI / 360.0f);
    float aspect = screenW / screenH;

    float sX = (vX / vZ / tanHalfFov / aspect) * screenW/2 + screenW/2;
    float sY = -(vY / vZ / tanHalfFov) * screenH/2 + screenH/2;

    return Vector2(sX, sY);
}

// ============================================================
// 主读取函数
// ============================================================
static inline SmobaReadResult Smoba_ReadActorManager(void) {
    SmobaReadResult result;

    // 1. 获取内核句柄
    auto &kfd = KFD::S();
    uint64_t task = kfd.task_addr;
    if (!task) return result;

    // 2. 找到 UnityFramework 模块基址
    uint64_t all_image_info_addr = KFD::KextRW_kread64(&kfd.handle, task + 0x3A0);
    if (!all_image_info_addr) return result;

    KFD::dyld_all_image_infos_64 ai;
    if (!KFD::read_buf_paged(&kfd.handle, all_image_info_addr, &ai, sizeof(ai), kfd.vm_map_pmap))
        return result;

    uint64_t ufBase = 0;
    KFD::find_image_base_by_name(&kfd.handle, ai.infoArrayCount, ai.infoArray,
                                  kfd.vm_map_pmap, "UnityFramework", &ufBase, false);
    if (!ufBase) return result;
    result.unityFrameworkBase = ufBase;

    // 3. 获取 Il2CppClass 字段偏移
    Il2CppOffsets off;
    if (!Smoba_GetIl2CppOffsets(ufBase, &off)) {
        // 如果 export trie 找不到, 尝试常用偏移 (Unity 2020-2022)
        off.name_off   = 0x30;
        off.parent_off = 0x18;
        off.sf_off     = 0xA8;
    }

    // 4. 找到 ActorManager 的 Il2CppClass
    uint64_t actorManagerClass = Smoba_FindIl2CppClass(ufBase, "ActorManager", off);
    if (!actorManagerClass) return result;

    // 5. 读取 parent class
    uint64_t parentClass = KFD::Read<uint64_t>(actorManagerClass + off.parent_off);
    if (!parentClass || parentClass < 0x100000000) return result;

    // 6. 读取 static_fields 地址
    uint64_t staticFields = KFD::Read<uint64_t>(parentClass + off.sf_off);
    if (!staticFields || staticFields < 0x100000000) return result;

    // 7. 第一个 qword 就是 ActorManager* 单例
    uint64_t actorManager = KFD::Read<uint64_t>(staticFields);
    if (!actorManager || actorManager < 0x100000000) return result;
    result.actorManagerAddr = actorManager;

    // 8. 验证: ActorManager+24 应该是一个 TinyValueList
    // TinyValueList = {void* cap@+0, void* end@+8, void* begin@+16}
    uint64_t tvl_begin = KFD::Read<uint64_t>(actorManager + 24 + 16);
    uint64_t tvl_end   = KFD::Read<uint64_t>(actorManager + 24 + 8);
    if (!tvl_begin || !tvl_end || tvl_end < tvl_begin) return result;

    // 9. begin+8 是 PoolObjHandle[] 数组引用
    uint64_t arrayRef = KFD::Read<uint64_t>(tvl_begin + 8);
    if (!arrayRef || arrayRef < 0x100000000) return result;

    // 10. 读取数组长度 (managed array: klass@0, monitor@8, bounds@16, length@24)
    int arrLen = KFD::Read<int32_t>(arrayRef + 24);
    if (arrLen <= 0 || arrLen > 500) return result;

    result.heroCount = arrLen;

    // 11. 读取每个 PoolObjHandle (16 bytes), +0 = ActorLinker*
    uint64_t elemBase = arrayRef + 32; // elements start after header

    for (int i = 0; i < arrLen; i++) {
        uint64_t poh_addr = elemBase + (uint64_t)i * 16;
        uint64_t actorPtr = KFD::Read<uint64_t>(poh_addr); // +0 = ActorLinker*

        if (!actorPtr || actorPtr < 0x100000000) continue;

        // 验证: ActorLinker 应该以 class ptr 开头 (vtable-like)
        // 粗略验证: actorPtr[0] 指向可读内存
        uint64_t vtable = KFD::Read<uint64_t>(actorPtr);
        if (!vtable || vtable < 0x100000000) continue;

        // 读取 ActorLinker 字段
        int32_t objID = KFD::Read<int32_t>(actorPtr + 1196); // ObjID
        uint64_t namePtr = KFD::Read<uint64_t>(actorPtr + 1200); // name string
        int32_t campVal = KFD::Read<int32_t>(actorPtr + 1208); // 尝试读取阵营

        float x = KFD::Read<float>(actorPtr + 1220);
        float y = KFD::Read<float>(actorPtr + 1224);
        float z = KFD::Read<float>(actorPtr + 1228);

        // 过滤无效坐标
        if (!std::isfinite(x) || !std::isfinite(y) || !std::isfinite(z)) continue;
        if (x == 0 && y == 0 && z == 0) continue;

        SmobaActorData data;
        data.objID = objID;
        data.camp = campVal; // 保存阵营值
        data.x = x;
        data.y = y;
        data.z = z;

        // 读取名字
        if (namePtr && namePtr > 0x100000000) {
            char name_buf[64] = {};
            KFD::read_cstring(&kfd.handle, namePtr, name_buf, sizeof(name_buf), kfd.vm_map_pmap);
            data.name = name_buf;
        }

        result.actors.push_back(data);
    }

    // 设置本地玩家阵营 (第一个 actor 通常是本地玩家)
    if (!result.actors.empty()) {
        result.localPlayerCamp = result.actors[0].camp;
    }

    // 查找或估算相机
    if (!result.actors.empty()) {
        result.camera = Smoba_FindUnityCamera(ufBase, off, result.actors[0]);
    }

    result.valid = !result.actors.empty();
    return result;
}
