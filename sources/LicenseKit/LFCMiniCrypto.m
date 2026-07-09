#import "LFCMiniCrypto.h"
#import "tweetnacl.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

/*
 CommonCrypto exports GCM symbols from libSystem on iOS 16.4, but the Theos SDK
 does not ship the SPI header. The signature matches Apple's CommonCryptorSPI.h.
 */
extern CCCryptorStatus CCCryptorGCM(CCOperation op,
                                    CCAlgorithm alg,
                                    const void *key,
                                    size_t keyLength,
                                    const void *iv,
                                    size_t ivLen,
                                    const void *aData,
                                    size_t aDataLen,
                                    const void *dataIn,
                                    size_t dataInLength,
                                    void *dataOut,
                                    void *tagOut,
                                    size_t *tagLength);

void randombytes(unsigned char *buffer, unsigned long long length) {
    if (!buffer || length == 0) return;
    if (SecRandomCopyBytes(kSecRandomDefault, (size_t)length, buffer) != errSecSuccess) {
        memset(buffer, 0, (size_t)length);
    }
}

@implementation LFCMiniCrypto

+ (BOOL)verifyEd25519Payload:(NSData *)payload
                   signature:(NSData *)signature
                   publicKey:(NSData *)publicKey {
    if (payload.length == 0 || signature.length != 64 || publicKey.length != 32) return NO;

    NSMutableData *signedMessage = [NSMutableData dataWithCapacity:signature.length + payload.length];
    [signedMessage appendData:signature];
    [signedMessage appendData:payload];

    NSMutableData *opened = [NSMutableData dataWithLength:signedMessage.length];
    unsigned long long openedLen = 0;
    int rc = crypto_sign_open(opened.mutableBytes,
                              &openedLen,
                              signedMessage.bytes,
                              (unsigned long long)signedMessage.length,
                              publicKey.bytes);
    if (rc != 0 || openedLen != payload.length) return NO;

    const uint8_t *a = opened.bytes;
    const uint8_t *b = payload.bytes;
    uint8_t diff = 0;
    for (NSUInteger i = 0; i < payload.length; i++) {
        diff |= a[i] ^ b[i];
    }
    return diff == 0;
}

+ (NSDictionary<NSString *,NSData *> *)aesGCMEncryptPlaintext:(NSData *)plaintext
                                                          key:(NSData *)key
                                                          aad:(NSData *)aad {
    if (key.length != kCCKeySizeAES256) return nil;

    uint8_t nonce[12] = {0};
    if (SecRandomCopyBytes(kSecRandomDefault, sizeof(nonce), nonce) != errSecSuccess) return nil;

    NSMutableData *ciphertext = [NSMutableData dataWithLength:plaintext.length];
    uint8_t tag[16] = {0};
    size_t tagLength = sizeof(tag);
    NSData *safeAAD = aad ?: NSData.data;

    CCCryptorStatus status = CCCryptorGCM(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          key.bytes,
                                          key.length,
                                          nonce,
                                          sizeof(nonce),
                                          safeAAD.bytes,
                                          safeAAD.length,
                                          plaintext.bytes,
                                          plaintext.length,
                                          ciphertext.mutableBytes,
                                          tag,
                                          &tagLength);
    if (status != kCCSuccess || tagLength != sizeof(tag)) return nil;

    return @{
        @"nonce": [NSData dataWithBytes:nonce length:sizeof(nonce)],
        @"ciphertext": ciphertext,
        @"tag": [NSData dataWithBytes:tag length:sizeof(tag)]
    };
}

+ (NSData *)aesGCMDecryptCiphertext:(NSData *)ciphertext
                               nonce:(NSData *)nonce
                                 tag:(NSData *)tag
                                 key:(NSData *)key
                                 aad:(NSData *)aad {
    if (key.length != kCCKeySizeAES256 || nonce.length == 0 || tag.length != 16) return nil;

    NSMutableData *plaintext = [NSMutableData dataWithLength:ciphertext.length];
    uint8_t computedTag[16] = {0};
    size_t computedTagLength = sizeof(computedTag);
    NSData *safeAAD = aad ?: NSData.data;

    CCCryptorStatus status = CCCryptorGCM(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          key.bytes,
                                          key.length,
                                          nonce.bytes,
                                          nonce.length,
                                          safeAAD.bytes,
                                          safeAAD.length,
                                          ciphertext.bytes,
                                          ciphertext.length,
                                          plaintext.mutableBytes,
                                          computedTag,
                                          &computedTagLength);
    if (status != kCCSuccess || computedTagLength != tag.length) return nil;

    const uint8_t *expected = tag.bytes;
    uint8_t diff = 0;
    for (NSUInteger i = 0; i < tag.length; i++) {
        diff |= computedTag[i] ^ expected[i];
    }
    return diff == 0 ? plaintext : nil;
}

@end
