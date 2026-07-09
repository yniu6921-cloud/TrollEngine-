#ifndef StringObf_h
#define StringObf_h

#include <cstddef>
#include <cstdint>

namespace obf {

constexpr uint8_t KEY[] = { 0x5A, 0xC3, 0x91, 0xF7, 0x2E, 0x6B, 0xD4, 0x18, 0xA5, 0x73, 0x0F, 0xE2, 0x89, 0x4D, 0xB6, 0x3C };
constexpr size_t KEY_LEN = sizeof(KEY);

template<size_t N>
struct encrypted_string {
    char data[N];
    constexpr encrypted_string(const char (&str)[N]) : data{} {
        for (size_t i = 0; i < N; ++i)
            data[i] = str[i] ^ KEY[i % KEY_LEN];
    }
};

template<size_t N>
class decrypted_string {
    char buf[N];
public:
    decrypted_string(const char (&enc)[N]) {
        for (size_t i = 0; i < N; ++i)
            buf[i] = enc[i] ^ KEY[i % KEY_LEN];
    }
    const char* c_str() const { return buf; }
    operator const char*() const { return buf; }
};

} // namespace obf

#define OBF_STR(s) \
    []() -> const char* { \
        static constexpr auto e = obf::encrypted_string(s); \
        static auto d = obf::decrypted_string(e.data); \
        return d.c_str(); \
    }()

#endif
