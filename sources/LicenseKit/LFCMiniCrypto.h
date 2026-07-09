#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCMiniCrypto : NSObject
+ (BOOL)verifyEd25519Payload:(NSData *)payload
                   signature:(NSData *)signature
                   publicKey:(NSData *)publicKey;
+ (nullable NSDictionary<NSString *, NSData *> *)aesGCMEncryptPlaintext:(NSData *)plaintext
                                                                     key:(NSData *)key
                                                                     aad:(nullable NSData *)aad;
+ (nullable NSData *)aesGCMDecryptCiphertext:(NSData *)ciphertext
                                       nonce:(NSData *)nonce
                                         tag:(NSData *)tag
                                         key:(NSData *)key
                                         aad:(nullable NSData *)aad;
@end

NS_ASSUME_NONNULL_END
