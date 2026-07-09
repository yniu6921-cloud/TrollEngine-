# KFD.hpp 内存读取方式分析

## 概述
这是一个用于 iOS 越狱环境下的内核和用户空间内存读取库，通过动态加载外部 jailbreak 库（如 libjailbreak）来实现内存访问能力。

## 读取方式架构

### 1. 内核空间读取（Kernel Space Reading）

#### 1.1 基础内核读取函数

**`KextRW_kread64`** (行 168-177)
```cpp
static uint64_t KextRW_kread64(void **handle, uint64_t kaddr)
```
- **功能**: 从内核地址空间读取 64 位值
- **实现**: 通过 `dlsym` 动态解析外部库中的 `kread64` 符号并调用
- **用途**: 直接读取内核数据结构

**`KextRW_kread_ptr`** (行 157-167)
```cpp
static uint64_t KextRW_kread_ptr(void **handle, uint64_t kaddr)
```
- **功能**: 读取内核指针值
- **实现**: 调用外部库的 `kread_ptr` 函数
- **用途**: 读取内核中的指针字段

**`kread64` / `kread32`** (行 441-446)
```cpp
static inline uint64_t kread64(uint64_t a)
static inline uint32_t kread32(uint64_t a)
```
- **功能**: 便捷的内核读取函数，使用全局状态
- **特点**: 
  - `kread64`: 直接调用 `KextRW_kread64`
  - `kread32`: 通过读取对齐的 64 位值然后提取 32 位（处理非对齐地址）

---

### 2. 用户空间虚拟内存读取（User Virtual Address Reading）

#### 2.1 底层虚拟内存读取

**`KextRW_vreadbuf`** (行 190-198)
```cpp
static int KextRW_vreadbuf(void **handle, uint64_t tte_p, 
                           const void *virt_addr, void *outdata, size_t datalen)
```
- **功能**: 底层虚拟内存读取函数
- **参数**:
  - `tte_p`: 页表根（Translation Table Entry）
  - `virt_addr`: 目标进程的虚拟地址
  - `outdata`: 输出缓冲区
  - `datalen`: 读取长度
- **实现**: 通过 `dlsym` 调用外部库的 `vreadbuf` 函数
- **特点**: 使用静态变量缓存函数指针，提高性能

**`KextRW_readMemory`** (行 201-211)
```cpp
static bool KextRW_readMemory(void **handle, uint64_t vm_addr,
                              void *userBuf, uint64_t size, uint64_t vm_map_pmap)
```
- **功能**: 通用用户空间内存读取函数
- **实现**: 
  1. 验证地址有效性（`KextRW_isValidAddress`）
  2. 调用 `KextRW_vreadbuf` 执行实际读取
- **特点**: 封装了地址验证逻辑

#### 2.2 分页读取（处理跨页边界）

**`read_buf_paged`** (行 212-225)
```cpp
static bool read_buf_paged(void **handle, uint64_t uva, 
                           void *out, uint64_t len, uint64_t pmap)
```
- **功能**: 分页读取，自动处理跨页边界情况
- **实现逻辑**:
  1. 计算当前地址的页内偏移 (`page_off = uva & (PAGE_SIZE - 1)`)
  2. 计算当前页剩余空间 (`chunk = PAGE_SIZE - page_off`)
  3. 每次读取不超过页边界的数据块
  4. 循环直到读取完所有数据
- **优势**: 避免跨页读取失败，提高可靠性

**`read_u64`** (行 228-230)
```cpp
static inline bool read_u64(void **handle, uint64_t uva, 
                            uint64_t *val, uint64_t pmap)
```
- **功能**: 便捷的 64 位值读取函数
- **实现**: 调用 `read_buf_paged` 读取 8 字节

**`read_cstring`** (行 233-244)
```cpp
static bool read_cstring(void **handle, uint64_t str_uva, 
                         char *buf, size_t maxlen, uint64_t pmap)
```
- **功能**: 安全读取 C 字符串
- **特点**:
  - 逐字节读取直到遇到 `\0`
  - 保证缓冲区以 `\0` 结尾
  - 防止缓冲区溢出（最多读取 `maxlen-1` 字节）

---

### 3. 模板化读取函数

#### 3.1 `ReadMemoryValue` (行 656-664)
```cpp
template<typename T>
inline T ReadMemoryValue(void **handle, uint64_t vmAddr, 
                         uint64_t vm_map_pmap, const char* name = nullptr)
```
- **功能**: 模板函数，可以读取任意类型的数据
- **特点**:
  - 类型安全：自动推断类型大小
  - 失败时返回零初始化值
  - 需要显式传入 `handle` 和 `vm_map_pmap`

**使用示例**:
```cpp
uint64_t value = ReadMemoryValue<uint64_t>(handle, addr, pmap);
struct SomeStruct s = ReadMemoryValue<SomeStruct>(handle, addr, pmap);
```

#### 3.2 `Read` (行 670-678)
```cpp
template<typename T>
inline T Read(uint64_t vmAddr, const char* name = nullptr)
```
- **功能**: 使用全局状态的模板读取函数
- **特点**:
  - 自动使用 `S().handle` 和 `S().vm_map_pmap`
  - 更简洁的 API，适合频繁读取场景
- **依赖**: 需要先初始化全局状态（`State`）

**使用示例**:
```cpp
uint64_t value = Read<uint64_t>(addr);
```

---

### 4. 特殊用途读取

#### 4.1 dyld 信息读取

**`read_dyld_header`** (行 341-365)
```cpp
bool read_dyld_header(void **handle, uint64_t task_addr,
                     size_t off_all_image_info_addr, uint64_t pmap,
                     dyld_all_image_infos_64 *out, bool verbose)
```
- **功能**: 读取 dyld 的 `all_image_infos` 结构
- **流程**:
  1. 从 `task` 结构读取 `all_image_infos` 地址（使用内核读取）
  2. 使用用户空间读取获取 `dyld_all_image_infos_64` 结构
  3. 验证数据有效性

**`find_image_base_by_name`** (行 263-297)
```cpp
static bool find_image_base_by_name(void **handle, uint64_t entryCount,
                                   uint64_t listAddr, uint64_t pmap,
                                   const char *needle, uint64_t *outBase, bool verbose)
```
- **功能**: 通过库名查找库的基址
- **实现**:
  1. 遍历 dyld 镜像列表
  2. 读取每个镜像的路径字符串
  3. 使用大小写不敏感匹配查找目标库

#### 4.2 vm_map 结构读取

**`probe_off_vm_map__hdr`** (行 449-490)
```cpp
static size_t probe_off_vm_map__hdr(uint64_t vm_map)
```
- **功能**: 探测 `vm_map` 结构中 `hdr` 字段的偏移
- **方法**: 暴力搜索（0x0~0x200，步进 0x8）
- **验证**:
  - 检查 `nentries` 是否合理
  - 验证链表结构（`next`/`prev`）
  - 检查地址范围（`start` < `end`）

**`find_main_exe_base_from_vm_map`** (行 493-535)
```cpp
static uint64_t find_main_exe_base_from_vm_map(uint64_t vm_map, size_t off_vm_map__hdr)
```
- **功能**: 从 `vm_map` 中找到主可执行文件的基址
- **方法**: 遍历 `vm_map_entry` 链表，查找地址范围在 `0x100000000~0x200000000` 的条目

#### 4.3 Mach-O 文件验证

**`LFIsMachOExec`** (行 319-330)
```cpp
static inline BOOL LFIsMachOExec(void **handle, uint64_t base, uint64_t vm_map_pmap)
```
- **功能**: 验证地址是否为有效的 Mach-O 可执行文件
- **检查**:
  - 读取文件头（8 个 uint32_t）
  - 验证魔数（`MH_MAGIC_64` 或 `MH_CIGAM_64`）
  - 检查文件类型是否为 `MH_EXECUTE` (2)

**`LFLooksLikeCString`** (行 309-318)
```cpp
static inline BOOL LFLooksLikeCString(void **handle, uint64_t ptr, uint64_t vm_map_pmap)
```
- **功能**: 判断地址是否指向有效的 C 字符串
- **方法**:
  1. 读取 32 字节数据
  2. 统计可打印字符比例
  3. 如果可打印字符 >= 75%，认为是字符串

---

## 读取方式对比表

| 函数名 | 读取空间 | 地址类型 | 是否需要 pmap | 特点 |
|--------|---------|---------|--------------|------|
| `KextRW_kread64` | 内核 | 内核地址 | ❌ | 直接内核读取 |
| `KextRW_readMemory` | 用户 | 虚拟地址 | ✅ | 通用内存读取 |
| `read_buf_paged` | 用户 | 虚拟地址 | ✅ | 自动处理跨页 |
| `read_cstring` | 用户 | 虚拟地址 | ✅ | 安全字符串读取 |
| `Read<T>` | 用户 | 虚拟地址 | ❌* | 模板化，使用全局状态 |
| `ReadMemoryValue<T>` | 用户 | 虚拟地址 | ✅ | 模板化，显式参数 |

*`Read<T>` 使用全局状态中的 `vm_map_pmap`，不需要显式传入

---

## 地址处理

### PAC 地址处理
**`LFStripPAC`** (行 302-305)
```cpp
static inline uint64_t LFStripPAC(uint64_t x)
```
- **功能**: 去除 ARM64e 的 PAC（Pointer Authentication Code）
- **实现**: 掩码到 48 位虚拟地址空间
- **用途**: iOS 15+ 使用 PAC，需要去除才能访问实际地址

---

## 读取流程示例

### 示例 1: 读取用户空间 64 位值
```cpp
void* handle = ...;  // 已初始化的句柄
uint64_t pmap = ...; // 目标进程的页表
uint64_t addr = 0x1234567890; // 目标地址

// 方式 1: 使用 read_u64
uint64_t value = 0;
if (read_u64(&handle, addr, &value, pmap)) {
    // 读取成功
}

// 方式 2: 使用模板函数
uint64_t value = ReadMemoryValue<uint64_t>(&handle, addr, pmap);
```

### 示例 2: 读取内核结构
```cpp
uint64_t proc_addr = ...; // 进程结构地址
uint64_t task_addr = kread64(proc_addr + offsetof(proc, task));
```

### 示例 3: 读取字符串
```cpp
uint64_t str_addr = ...;
char buf[256];
if (read_cstring(&handle, str_addr, buf, sizeof(buf), pmap)) {
    printf("String: %s\n", buf);
}
```

---

## 关键设计特点

1. **分层架构**: 
   - 底层：`KextRW_vreadbuf`（直接调用外部库）
   - 中层：`KextRW_readMemory`（添加验证）
   - 高层：`read_buf_paged`（处理分页）、模板函数（类型安全）

2. **错误处理**: 
   - 大部分函数返回 `bool` 或 0 值表示失败
   - 地址验证防止无效访问

3. **性能优化**:
   - `KextRW_vreadbuf` 使用静态变量缓存函数指针
   - 分页读取避免重复调用

4. **安全性**:
   - 地址有效性检查
   - PAC 地址处理
   - 字符串读取防止溢出

5. **灵活性**:
   - 支持显式参数和全局状态两种模式
   - 模板函数支持任意类型
   - 多种读取粒度（字节、64位、缓冲区）

---

## 依赖关系

```
外部 jailbreak 库 (libjailbreak)
    ↓ (dlsym)
KextRW_vreadbuf / KextRW_kread64
    ↓
KextRW_readMemory
    ↓
read_buf_paged / read_cstring
    ↓
Read<T> / ReadMemoryValue<T>
```

---

## 注意事项

1. **初始化顺序**: 使用 `Read<T>` 前必须初始化全局状态（`S().handle` 和 `S().vm_map_pmap`）
2. **地址空间**: 内核读取和用户空间读取使用不同的函数，不能混用
3. **页表参数**: 用户空间读取需要正确的 `pmap`（页表根），否则会失败
4. **PAC 处理**: iOS 15+ 需要去除 PAC 才能访问实际地址
5. **错误处理**: 读取失败时返回 0 或 false，调用者需要检查返回值
