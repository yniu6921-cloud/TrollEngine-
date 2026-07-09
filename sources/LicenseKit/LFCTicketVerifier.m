#import "LFCTicketVerifier.h"
#import "LFCAuthConfig.h"
#import "LFCBase64URL.h"
#import "LFCMiniCrypto.h"

@implementation LFCVerifiedTicket
@end

@implementation LFCTicketVerifier

+ (LFCVerifiedTicket *)verifyTicket:(NSString *)ticket
                 deviceFingerprint:(NSString *)deviceFingerprint {
    LFCVerifiedTicket *result = [LFCVerifiedTicket new];
    result.valid = NO;
    result.message = @"授权票据无效";

    NSArray<NSString *> *parts = [ticket componentsSeparatedByString:@"."];
    if (parts.count != 2) return result;

    NSData *payloadData = [LFCBase64URL decodeString:parts[0]];
    NSData *signature = [LFCBase64URL decodeString:parts[1]];
    NSData *publicKey = [[NSData alloc] initWithBase64EncodedString:LFC_AUTH_ED25519_PUBLIC_KEY_B64 options:0];
    if (payloadData.length == 0 || signature.length != 64 || publicKey.length != 32) return result;

    if (![self verifyPayload:payloadData signature:signature publicKey:publicKey]) {
        result.message = @"授权签名校验失败";
        return result;
    }

    NSError *jsonError = nil;
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:payloadData options:0 error:&jsonError];
    if (jsonError || ![payload isKindOfClass:NSDictionary.class]) return result;

    NSString *appID = [payload[@"app_id"] description];
    NSString *boundDevice = [payload[@"device_fingerprint"] description];
    NSTimeInterval now = NSDate.date.timeIntervalSince1970;
    NSTimeInterval notBefore = [payload[@"not_before"] doubleValue];
    NSTimeInterval expiresAt = [payload[@"expires_at"] doubleValue];
    NSTimeInterval offlineUntil = [payload[@"offline_until"] doubleValue];

    if (![appID isEqualToString:LFC_AUTH_APP_ID]) {
        result.message = @"授权应用不匹配";
        return result;
    }
    if (![boundDevice isEqualToString:deviceFingerprint]) {
        result.message = @"授权设备不匹配";
        return result;
    }
    if (notBefore > 0 && now + 300 < notBefore) {
        result.message = @"授权尚未生效";
        return result;
    }
    if (expiresAt > 0 && now > expiresAt) {
        result.message = @"授权已到期";
        return result;
    }
    if (offlineUntil > 0 && now > offlineUntil) {
        result.message = @"离线授权已过期，请联网续签";
        return result;
    }

    result.valid = YES;
    result.message = @"授权有效";
    result.role = [payload[@"role"] description] ?: @"user";
    result.payload = payload;
    if (expiresAt > 0) {
        result.expiresAt = [NSDate dateWithTimeIntervalSince1970:expiresAt];
    }
    return result;
}

+ (BOOL)verifyPayload:(NSData *)payload signature:(NSData *)signature publicKey:(NSData *)publicKey {
    return [LFCMiniCrypto verifyEd25519Payload:payload signature:signature publicKey:publicKey];
}

@end
