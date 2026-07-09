#ifndef LFC_TWEETNACL_H
#define LFC_TWEETNACL_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

int crypto_sign_open(unsigned char *m,
                     unsigned long long *mlen,
                     const unsigned char *sm,
                     unsigned long long n,
                     const unsigned char *pk);

#ifdef __cplusplus
}
#endif

#endif
