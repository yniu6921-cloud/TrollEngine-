#import "LFCRequestSigner.h"
#import "LFCAuthConfig.h"
#import "LFCBase64URL.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/Security.h>

@implementation LFCRequestSigner

+ (NSDictionary<NSString *,NSString *> *)signedHeadersForBody:(NSData *)body
                                                          path:(NSString *)path
                                                        method:(NSString *)method {
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    NSString *nonce = [self randomNonce];
    NSString *bodyHash = [self sha256Hex:body ?: NSData.data];
    NSString *canonical = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
                           method.uppercaseString, path, timestamp, nonce, bodyHash];
    NSData *secret = [LFC_AUTH_CLIENT_HMAC_SECRET dataUsingEncoding:NSUTF8StringEncoding];
    NSString *signature = [self hmacSHA256HexForData:[canonical dataUsingEncoding:NSUTF8StringEncoding]
                                                key:secret];
    return @{
        @"X-Client-Timestamp": timestamp,
        @"X-Client-Nonce": nonce,
        @"X-Client-Body-SHA256": bodyHash,
        @"X-Client-Signature": signature
    };
}

+ (NSString *)randomNonce {
    uint8_t bytes[16] = {0};
    if (SecRandomCopyBytes(kSecRandomDefault, sizeof(bytes), bytes) != errSecSuccess) {
        return NSUUID.UUID.UUIDString;
    }
    return [LFCBase64URL encodeData:[NSData dataWithBytes:bytes length:sizeof(bytes)]];
}

+ (NSString *)sha256Hex:(NSData *)data {
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *hex = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hex appendFormat:@"%02x", digest[i]];
    }
    return hex;
}

+ (NSString *)hmacSHA256HexForData:(NSData *)data key:(NSData *)key {
    unsigned char mac[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, key.bytes, key.length, data.bytes, data.length, mac);
    NSMutableString *hex = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hex appendFormat:@"%02x", mac[i]];
    }
    return hex;
}

@end
