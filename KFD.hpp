//巨魔内核精简版本 开发人员纽约
//by 纽约
//  KFD.h
//  YuanBao
//
//  Created by  on 2025/8/12.
//  Copyright © 2025 Mr_Laote. All rights reserved.
//

#pragma once
#include <cstdint>
#include <cstddef>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <vector>
#include <string.h>
#include <mach/vm_param.h>
namespace KFD {
// 仍保留你原来的 App 本地日志路径

typedef int (*jbdInitPPLRW_t)(void);
typedef uint64_t (*proc_find_t)(uint32_t pid);
typedef uint64_t (*proc_task_t)(uint64_t proc);


// ====== 全局状态（单例）======
struct State {
    void*    handle        = nullptr; // 你的 dlopen 句柄等
    uint64_t base          = 0;       // 目标基址（由你填）
    uint64_t vm_map        = 0;
    uint64_t pmap          = 0;
    uint64_t vm_map_pmap   = 0;
    uint64_t task_addr     = 0;
    uint64_t proc_addr     = 0;
    int      pid           = 0;       // 目标进程 pid
    bool     kernelReady   = false;   // 内核能力就绪标志（由你设）
};
inline State& S() {
    static State s;           // C++ 静态局部：单例
    return s;
}

inline void Reset() { S() = State{}; }
inline void  SetHandle(void* h)     { S().handle = h; }
inline void* Handle()               { return S().handle; }
inline void  SetPid(int p)          { S().pid = p; }
inline int   Pid()                  { return S().pid; }
inline void  SetBase(uint64_t b)    { S().base = b; }
inline uint64_t Base()              { return S().base; }
inline void  SetKernelReady(bool r) { S().kernelReady = r; }
inline bool  KernelReady()          { return S().kernelReady; }


#define KFD_VM_MAP_PMAP (KFD::S().vm_map_pmap)
#define 基地址      (KFD::S().base)
#define 内核        (KFD::S().kernelReady)
#define KFD_VM_MAP_PMAP (KFD::S().vm_map_pmap)



static uint64_t call_proc_task(void *handle, uint64_t proc) {
    if (!handle) return 0;
    
    proc_task_t proc_task_fn = (proc_task_t)dlsym(handle, "proc_task");
    if (!proc_task_fn) {
     
        return 0;
    }
    
    uint64_t task_addr = proc_task_fn(proc);
 
    return task_addr;
}
static int jbdInitPPLRW_call(void *thisHandle) {
  

    if (!thisHandle) {
        return -1;
    }

    typedef int (*jbdInitPPLRW_t)(void);

    // 先清 dlsym 错误状态
    dlerror();
    void *sym = dlsym(thisHandle, "jbdInitPPLRW");
    const char *err = dlerror();
    if (err) {
        return -1;
    }

    jbdInitPPLRW_t jbdInitPPLRW = (jbdInitPPLRW_t)sym;


    int ret = jbdInitPPLRW();
    if(ret==0){
       
    }else{
        
    }
   
    return ret;
}

static uint64_t call_proc_find(void *handle, uint32_t pid) {
    if (!handle) return 0;
    
    // 从 libjailbreak 动态库里解析 proc_find
    proc_find_t proc_find_fn = (proc_find_t)dlsym(handle, "proc_find");
    if (!proc_find_fn) {
     
        return 0;
    }
    
    uint64_t proc_addr = proc_find_fn(pid);
   
    return proc_addr;
}


// 获取进程PID
static pid_t findProcessByName(const char* targetName) {
    if (!targetName || !*targetName) {
        return -1;
    }

    size_t length = 0;
    constexpr int mib[] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    constexpr size_t mibLen = (sizeof(mib) / sizeof(mib[0])) - 1;

    // 先获取需要的 buffer 大小
    if (sysctl((int*)mib, (u_int)mibLen, nullptr, &length, nullptr, 0) != 0) {
        return -1;
    }

    // 用 vector 托管内存，避免手动 free
    std::vector<struct kinfo_proc> procBuffer(length / sizeof(struct kinfo_proc));

    if (sysctl((int*)mib, (u_int)mibLen, procBuffer.data(), &length, nullptr, 0) != 0) {
        return -1;
    }

    int count = static_cast<int>(length / sizeof(struct kinfo_proc));
    for (int i = 0; i < count; ++i) {
        const char* name = procBuffer[i].kp_proc.p_comm;
        if (strncmp(name, targetName, MAXCOMLEN) == 0) {
            return procBuffer[i].kp_proc.p_pid;
        }
    }

    return -1;
}

static uint64_t KextRW_kread_ptr(void **handle, uint64_t kaddr) {
    // dlsym 获取符号地址
    uint64_t (*kread_ptr_sym)(uint64_t) = (uint64_t (*)(uint64_t))dlsym(*handle, "kread_ptr");
    if (!kread_ptr_sym) {
    
        return 0;
    }
    uint64_t val = kread_ptr_sym(kaddr);
   
    return val;
}
static uint64_t KextRW_kread64(void **handle, uint64_t kaddr) {
    uint64_t (*kread64_sym)(uint64_t) = (uint64_t (*)(uint64_t))dlsym(*handle, "kread64");
    if (!kread64_sym) {
       
        return 0;
    }
    uint64_t val = kread64_sym(kaddr);
   
    return val;
}




static bool KextRW_isValidAddress(uint64_t addr) {
    if (addr == 0 || addr == UINT64_MAX) {
        return false;
    }
    return true;
}


static int KextRW_vreadbuf(void **handle, uint64_t tte_p, const void *virt_addr, void *outdata, size_t datalen) {
    typedef int (*vreadbuf_t)(uint64_t, const void*, void*, size_t);
    static vreadbuf_t fn = nullptr;
    if (!fn) {
        fn = (vreadbuf_t)dlsym(*handle, "vreadbuf");
        if (!fn) return -1;
    }
    return fn(tte_p, virt_addr, outdata, datalen);
}


static bool KextRW_readMemory(void **handle,
                            uint64_t vm_addr,
                            void *userBuf,
                            uint64_t size,
                            uint64_t vm_map_pmap)  // vm_map_pmap 即页表根 tte_p
{
    if (!KextRW_isValidAddress(vm_addr) || size == 0) return false;

  
    return KextRW_vreadbuf(handle, vm_map_pmap, (const void*)vm_addr, userBuf, size) == 0;
}
static bool read_buf_paged(void **handle, uint64_t uva, void *out, uint64_t len, uint64_t pmap) {
    uint8_t *dst = (uint8_t *)out;
    uint64_t remaining = len;
    while (remaining) {
        uint64_t page_off = uva & (PAGE_SIZE - 1);
        uint64_t chunk = PAGE_SIZE - page_off;
        if (chunk > remaining) chunk = remaining;
        if (!KextRW_readMemory(handle, uva, dst, chunk, pmap)) return false;
        uva += chunk;
        dst += chunk;
        remaining -= chunk;
    }
    return true;
}

// 2) 便捷读 64-bit
static inline bool read_u64(void **handle, uint64_t uva, uint64_t *val, uint64_t pmap) {
    return read_buf_paged(handle, uva, val, sizeof(*val), pmap);
}

// 3) 安全读字符串（最多读 maxlen-1，保证结尾 0）
static bool read_cstring(void **handle, uint64_t str_uva, char *buf, size_t maxlen, uint64_t pmap) {
    if (maxlen == 0) return false;
    size_t filled = 0;
    while (filled + 1 < maxlen) {
        char c = 0;
        if (!KextRW_readMemory(handle, str_uva + filled, &c, 1, pmap)) return false;
        buf[filled++] = c;
        if (c == '\0') { return true; }
    }
    buf[maxlen - 1] = '\0';
    return true;
}
struct dyld_image_info_64 {
    uint64_t imageLoadAddress; // 基址
    uint64_t imageFilePath;    // char*
    uint64_t imageFileModDate; // 时间戳
};

// 5) 用 entryCount + listAddr 找目标库 base
// 可选：大小写不敏感匹配
static inline bool str_contains_ci(const char* hay, const char* needle) {
    if (!hay || !needle) return false;
    for (const char *h = hay; *h; ++h) {
        const char *p = h, *q = needle;
        while (*p && *q && (tolower(*p) == tolower(*q))) { ++p; ++q; }
        if (*q == '\0') return true;
    }
    return false;
}

static bool find_image_base_by_name(void **handle,
                             uint64_t entryCount,
                             uint64_t listAddr,
                             uint64_t pmap,
                             const char *needle,
                             uint64_t *outBase,
                             bool verbose /* 新增：是否逐项打印 */)
{
    if (!needle || !outBase) return false;

    for (uint32_t i = 0; i < entryCount; i++) {
        uint64_t entry_uva = listAddr + (uint64_t)i * sizeof(struct dyld_image_info_64);

        struct dyld_image_info_64 info = {0};
        if (!read_buf_paged(handle, entry_uva, &info, sizeof(info), pmap)) return false;

        char path[1024] = {0};
        if (!read_cstring(handle, info.imageFilePath, path, sizeof(path), pmap)) {
           
            continue;
        }

        if (verbose) {
           
        }

        // 命中只打印一次并返回
        if (str_contains_ci(path, needle)) {
            *outBase = info.imageLoadAddress;
           
            return true;
        }
    }
    return false;
}
#include <string>
#include <cstring>
#include <vector>

static inline uint64_t LFStripPAC(uint64_t x) {
    // 保险起见，压到 48-bit VA（iOS 常见用户空间地址 0x0000_ffff_ffff 范围）
    return x & 0x0000FFFFFFFFFFFFULL;
}
static inline uint32_t LF_bswap32(uint32_t v) {
    return (v>>24) | ((v>>8)&0x0000FF00) | ((v<<8)&0x00FF0000) | (v<<24);
}
static inline BOOL LFLooksLikeCString(void **handle, uint64_t ptr, uint64_t vm_map_pmap) {
    if (!ptr) return NO;
    ptr = LFStripPAC(ptr);
    char buf[32] = {0};
    if (!KextRW_readMemory(handle, ptr, buf, sizeof(buf), vm_map_pmap)) return NO;
    // 要求首字节可见字符，且整体大多数字符可见
    int printable = 0, total = 0;
    for (int i=0;i< (int)sizeof(buf) && buf[i];++i){ total++; if ((unsigned char)buf[i] >= 32 && (unsigned char)buf[i] < 127) printable++; }
    return total>0 && printable*100 >= total*75;
}
static inline BOOL LFIsMachOExec(void **handle, uint64_t base, uint64_t vm_map_pmap) {
    base = LFStripPAC(base);
    uint32_t hdr[8] = {0};
    if (!KextRW_readMemory(handle, base, hdr, sizeof(hdr), vm_map_pmap)) return NO;
    uint32_t magic = hdr[0];
    if (magic == 0xFEEDFACF) {             // MH_MAGIC_64 (LE)
        return hdr[3] == 2;                // MH_EXECUTE
    } else if (magic == 0xCFFAEDFE) {      // MH_CIGAM_64 (BE)
        return LF_bswap32(hdr[3]) == 2;
    }
    return NO;
}



struct dyld_all_image_infos_64 {
    uint32_t version;        // +0x00
    uint32_t infoArrayCount; // +0x04
    uint64_t infoArray;      // +0x08 (dyld_image_info_64* in target UVA)
    // 后面字段省略
};

bool read_dyld_header(void **handle,
                      uint64_t task_addr,
                      size_t off_all_image_info_addr,
                      uint64_t pmap,
                      dyld_all_image_infos_64 *out,
                      bool verbose)
{
    if (!out) return false;

    uint64_t ai_uva = KFD::KextRW_kread64(handle, task_addr + off_all_image_info_addr);
    if (!ai_uva) return false;

    // 读出头部（前 0x10 字节就够拿 count/array 了，这里直接读整个结构体）
    if (!read_buf_paged(handle, ai_uva, out, sizeof(*out), pmap)) return false;

    if (verbose) {
    
    }

    // 简单校验
    if (out->infoArrayCount == 0 || out->infoArray == 0) return false;
    if (out->version > 0x100) return false; // 过大基本不合理

    return true;
}
struct vm_map_store {
    struct {
        uint64_t rbe_left;
        uint64_t rbe_right;
        uint64_t rbe_parent;
    } entry;
};

struct vm_map_links {
    uint64_t prev;
    uint64_t next;
    uint64_t start;
    uint64_t end;
};
struct vm_map_header {
    struct vm_map_links links;
    int32_t nentries;
    uint16_t page_shift;
    uint16_t
        entries_pageable:1,
        __padding:15;
    struct {
        uint64_t rbh_root;
    } rb_head_store;
};


struct vm_map_entry {
    struct vm_map_links links;
    struct vm_map_store store;
    union {
        uint64_t vme_object_value;
        struct {
            uint64_t vme_atomic:1;
            uint64_t is_sub_map:1;
            uint64_t vme_submap:60;
        };
        struct {
            int32_t vme_ctx_atomic:1;
            int32_t vme_ctx_is_sub_map:1;
            int32_t vme_context:30;
            int32_t vme_object;
        };
    };
    uint64_t
        vme_alias:12,
        vme_offset:52,
        is_shared:1,
        __unused1:1,
        in_transition:1,
        needs_wakeup:1,
        behavior:2,
        needs_copy:1,
        protection:3,
        used_for_tpro:1,
        max_protection:4,
        inheritance:2,
        use_pmap:1,
        no_cache:1,
        vme_permanent:1,
        superpage_size:1,
        map_aligned:1,
        zero_wired_pages:1,
        used_for_jit:1,
        pmap_cs_associated:1,
        iokit_acct:1,
        vme_resilient_codesign:1,
        vme_resilient_media:1,
        __unused2:1,
        vme_no_copy_on_read:1,
        translated_allow_execute:1,
        vme_kernel_object:1;
    uint16_t wired_count;
    uint16_t user_wired_count;
};
static inline uint64_t kread64(uint64_t a){ return KFD::KextRW_kread64(&S().handle, a); }
static inline uint32_t kread32(uint64_t a){
    uint64_t q = kread64(a & ~0x7ULL);
    unsigned sh = (unsigned)((a & 0x7ULL) * 8);
    return (uint32_t)((q >> sh) & 0xFFFFFFFFu);
}

// 试探 vm_map->hdr 的偏移；成功则返回 off_vm_map__hdr，否则返回 0
static size_t probe_off_vm_map__hdr(uint64_t vm_map) {
    // 一般来说 hdr 离开头不远，试 0x0~0x200 步进 0x8 足够
    for (size_t off = 0; off <= 0x200; off += 0x8) {
        uint64_t cand_hdr = vm_map + off;

        // 读 nentries（必须是一个合理的值）
        uint32_t nentries = kread32(cand_hdr + offsetof(struct vm_map_header, nentries));
        if (nentries == 0 || nentries > 100000) {
            continue; // 太离谱，跳过
        }

        // 读 links.next / prev / start / end
        uint64_t links_base = cand_hdr + offsetof(struct vm_map_header, links);
        uint64_t next = kread64(links_base + offsetof(struct vm_map_links, next));
        uint64_t prev = kread64(links_base + offsetof(struct vm_map_links, prev));
        uint64_t start = kread64(links_base + offsetof(struct vm_map_links, start));
        uint64_t end   = kread64(links_base + offsetof(struct vm_map_links, end));

        // 粗校验：start < end
        if (!(end > start)) continue;

        // 必须非空
        if (next == 0 || prev == 0) continue;

        // 再做一个链路校验：读 next 指向的 entry->links.prev，看看是否可能回指向我们这个 links（哨兵）
        uint64_t entry0 = next;
        uint64_t entry0_prev = kread64(entry0 + offsetof(struct vm_map_entry, links)
                                                + offsetof(struct vm_map_links, prev));
        // entry0_prev 有相当大概率等于 links_base（或者最终链表尾会回到 links_base）
        if (entry0_prev != 0 && (entry0_prev == links_base)) {
         
            return off;
        }

        // 即使第一条不是，也有可能是循环链表的后续才回到哨兵，这里放宽：只要 nentries 合理、区间合理，就接受
        if (start < end && nentries > 1) {
          
            return off;
        }
    }
    return 0;
}


static uint64_t find_main_exe_base_from_vm_map(uint64_t vm_map, size_t off_vm_map__hdr) {
    // 1) 转换到 hdr 基址
   
    uint64_t vm_map_hdr = vm_map + off_vm_map__hdr;
    uint64_t links_sentinel = vm_map_hdr + offsetof(struct vm_map_header, links);
    // 2) 读第一个 entry 指针（不要掩码）
    uint64_t entry = kread64(vm_map_hdr
        + offsetof(struct vm_map_header, links)
        + offsetof(struct vm_map_links, next));

    // 3) 读 nentries 作上限
    uint32_t nentries = kread32(vm_map_hdr + offsetof(struct vm_map_header, nentries));
    if (!entry || !nentries) {
    
        return 0;
    }

    // 4) 如果 entry 指回哨兵，说明空表
    if (entry == links_sentinel) {
       
        return 0;
    }

    uint64_t fallback = 0;

    for (uint32_t i = 0; i < nentries && entry && entry != links_sentinel; i++) {
        uint64_t start = kread64(entry + offsetof(struct vm_map_entry, links) + offsetof(struct vm_map_links, start));
        uint64_t end   = kread64(entry + offsetof(struct vm_map_entry, links) + offsetof(struct vm_map_links, end));
        // next
        entry = kread64(entry + offsetof(struct vm_map_entry, links) + offsetof(struct vm_map_links, next));
        
        if (end > start) {
           
            if (!fallback && start >= 0x100000000ULL && start < 0x200000000ULL) {
                fallback = start;
         
                return fallback;
            }

        }
    }
    return 0;
}




uint64_t KextRW_getBaseAddress(void **handle,
                               NSString *moduleName,
                               uint64_t listAddr,
                               uint32_t entryCount,
                               uint64_t vm_map_pmap)
{
    if (!handle || !*handle || listAddr == 0 || entryCount == 0) {
      
        return 0;
    }

    // 1) 探测 entry 布局：步长 & 起点偏移
    static const size_t entrySizes[] = {
        0x10,0x18,0x20,0x28,0x30,0x38,0x40,0x48,0x50,0x58,0x60,0x68,0x70,0x78,0x80,
        0x88,0x90,0x98,0xA0,0xA8,0xB0,0xB8,0xC0,0xC8,0xD0,0xD8,0xE0,0xE8,0xF0,0xF8,0x100
    };
    static const uint64_t listShifts[] = {
        0x0,0x8,0x10,0x18,0x20,0x28,0x30,0x38,0x40,0x48,0x50,0x58,0x60,0x68,0x70,0x78,0x80,
        0x88,0x90,0x98,0xA0,0xA8,0xB0,0xB8,0xC0,0xC8,0xD0,0xD8,0xE0,0xE8,0xF0,0xF8,0x100
    };
    size_t entrySize = 0;
    uint64_t listBase = 0;
    BOOL layoutOK = NO;

   
    for (size_t si = 0; si < sizeof(entrySizes)/sizeof(entrySizes[0]) && !layoutOK; ++si) {
        for (size_t shi = 0; shi < sizeof(listShifts)/sizeof(listShifts[0]) && !layoutOK; ++shi) {

            uint64_t testAddr = listAddr + listShifts[shi];

            // 关键：确保 <a,b> 两个 8B 指针(共 16B)不会越过当前 entry 边界
            if (listShifts[shi] + 0x10 > entrySizes[si]) {
                continue;
            }

            uint64_t e[4] = {0};
            size_t want = MIN(sizeof(e), entrySizes[si]);   // 如仍失败，可改成 MIN(0x10, entrySizes[si])
            if (!KextRW_readMemory(handle, testAddr, e, want, vm_map_pmap)) {
             
                continue;
            }

            uint64_t a = e[0], b = e[1];
            uint64_t base = 0, namePtr = 0;
            if (LFLooksLikeCString(handle, b, vm_map_pmap)) { base = a; namePtr = b; }
            else if (LFLooksLikeCString(handle, a, vm_map_pmap)) { base = b; namePtr = a; }
            else continue;

            if (LFIsMachOExec(handle, base, vm_map_pmap)) {
                entrySize = entrySizes[si];
                listBase  = testAddr;
                layoutOK  = YES;
            }
        }
    }

    if (!layoutOK) {
       
        return 0;
    }

    // 2) 遍历
  

    for (uint32_t i = 0; i < entryCount; i++) {
        uint64_t entryAddr = listBase + (uint64_t)i * entrySize;

        uint64_t e[3] = {0};
        size_t readLen = MIN(sizeof(e), entrySize);
        if (!KextRW_readMemory(handle, entryAddr, e, readLen, vm_map_pmap)) {

            continue;
        }

        uint64_t cand0 = LFStripPAC(e[0]);
        uint64_t cand1 = LFStripPAC(e[1]);
        uint64_t moduleBase = 0, moduleNamePtr = 0;

        if (LFLooksLikeCString(handle, cand1, vm_map_pmap)) { moduleBase = cand0; moduleNamePtr = cand1; }
        else if (LFLooksLikeCString(handle, cand0, vm_map_pmap)) { moduleBase = cand1; moduleNamePtr = cand0; }
        else {
            continue;
        }

        char nameBuf[256] = {0};
        if (!KextRW_readMemory(handle, moduleNamePtr, nameBuf, sizeof(nameBuf), vm_map_pmap)) {
   
            continue;
        }
        NSString *curName = [NSString stringWithUTF8String:nameBuf];
        if (curName.length == 0) {
          
            continue;
        }

     
        if (![curName containsString:moduleName]) continue;

        if (!LFIsMachOExec(handle, moduleBase, vm_map_pmap)) {
            continue;
        }
        ;
     
        return moduleBase;
    }

   
    return 0;
}







template<typename T>
inline T ReadMemoryValue(void **handle, uint64_t vmAddr, uint64_t vm_map_pmap, const char* name = nullptr) noexcept {
    (void)name; // 避免未使用警告
    T data{};   // 失败时按语义返回 0 值
    if (handle && vmAddr) {
        (void)KextRW_readMemory(handle, vmAddr, &data, sizeof(T), vm_map_pmap);
    }
    return data;
}





template<typename T>
inline T Read(uint64_t vmAddr, const char* name = nullptr) noexcept {
    (void)name;    // 避免未使用警告
    T data{};      // 失败时返回零初始化
    if (S().handle && vmAddr) {
        (void)KextRW_readMemory(&S().handle, vmAddr, &data, sizeof(T), S().vm_map_pmap);
    }
    return data;
}





static uint64_t I64(std::string address) {
    return (uint64_t)strtoul(address.c_str(), nullptr, 16);
}

static bool 地址泄露(uint64_t addr) {
    return true;
}
static bool isContain(std::string str, const char* check) {
    size_t found = str.find(check);
    return (found != std::string::npos);
}

} // namespace KFD
