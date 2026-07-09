//
//  TomiePhysXWrapper.hpp
//  TomiePhysX库的KFD接口包装
//

#ifndef TomiePhysXWrapper_hpp
#define TomiePhysXWrapper_hpp

#include "KFD.hpp"
#include <cstdint>
#include <cstddef>

// KFD读取接口包装函数（适配TomiePhysX需要的接口格式）
// 函数签名：bool (*kernel_readv)(uint64_t addr, void* buffer, size_t size)
inline bool KernelReadWrapper(uint64_t addr, void* buffer, size_t size) {
    if (!buffer || size == 0) return false;
    if (!KFD::地址泄露(addr)) return false;
    
    // 使用KFD的读取接口
    return KFD::KextRW_readMemory(&KFD::S().handle, addr, buffer, size, KFD::S().vm_map_pmap);
}

#endif /* TomiePhysXWrapper_hpp */
