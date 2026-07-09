#import "LFCAuthManager.h"
#import "LFCAuthConfig.h"
#import "LFCDeviceFingerprint.h"
#import "LFCRequestSigner.h"
#import "LFCTicketStore.h"
#import "LFCTicketVerifier.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@interface LFCAuthURLSessionDelegate : NSObject <NSURLSessionDelegate>
+ (instancetype)sharedDelegate;
@end

@implementation LFCAuthURLSessionDelegate

+ (instancetype)sharedDelegate {
    static LFCAuthURLSessionDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [LFCAuthURLSessionDelegate new];
    });
    return delegate;
}

- (void)URLSession:(NSURLSession *)session
              didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSString *pin = LFC_AUTH_PINNED_CERT_SHA256_B64;
    if (![challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] || pin.length == 0) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
        return;
    }

    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    if (!trust || SecTrustGetCertificateCount(trust) == 0) {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }

    SecCertificateRef leaf = SecTrustGetCertificateAtIndex(trust, 0);
    NSData *der = CFBridgingRelease(SecCertificateCopyData(leaf));
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(der.bytes, (CC_LONG)der.length, digest);
    NSString *actual = [[NSData dataWithBytes:digest length:sizeof(digest)] base64EncodedStringWithOptions:0];

    if ([actual isEqualToString:pin]) {
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:trust]);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end

@implementation LFCLicenseResult
@end

@implementation LFCAuthManager

+ (instancetype)sharedManager {
    static LFCAuthManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [LFCAuthManager new];
    });
    return manager;
}

- (NSString *)deviceFingerprint {
    return [LFCDeviceFingerprint currentFingerprint];
}

- (void)activateWithCardKey:(NSString *)cardKey completion:(LFCAuthCompletion)completion {
    NSString *fingerprint = [self deviceFingerprint];
    NSDictionary *body = @{
        @"app_id": LFC_AUTH_APP_ID,
        @"card_key": cardKey ?: @"",
        @"device_fingerprint": fingerprint ?: @"",
        @"client_version": NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"] ?: @"unknown",
        @"ticket_version": @1
    };

    NSError *jsonError = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:body
                                                   options:NSJSONWritingSortedKeys
                                                     error:&jsonError];
    if (!json) {
        completion([self result:NO offline:NO message:@"本地请求构造失败" role:nil expiresAt:nil]);
        return;
    }

    NSURL *url = [NSURL URLWithString:[LFC_AUTH_BASE_URL stringByAppendingString:LFC_AUTH_ACTIVATE_PATH]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = json;
    request.timeoutInterval = 10;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSDictionary *headers = [LFCRequestSigner signedHeadersForBody:json
                                                              path:LFC_AUTH_ACTIVATE_PATH
                                                            method:@"POST"];
    [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [request setValue:value forHTTPHeaderField:key];
    }];

    NSURLSessionConfiguration *configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:[LFCAuthURLSessionDelegate sharedDelegate]
                                                     delegateQueue:nil];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            LFCLicenseResult *offline = [self validateLocalTicket];
            if (offline.authorized) {
                completion(offline);
            } else {
                completion([self result:NO offline:NO message:@"网络不可用，且本地离线授权无效" role:nil expiresAt:nil]);
            }
            return;
        }

        NSInteger statusCode = 0;
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            statusCode = ((NSHTTPURLResponse *)response).statusCode;
        }
        if (statusCode < 200 || statusCode >= 300 || data.length == 0) {
            completion([self result:NO offline:NO message:@"授权服务器返回异常" role:nil expiresAt:nil]);
            return;
        }

        NSError *parseError = nil;
        NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (![jsonBody isKindOfClass:NSDictionary.class]) {
            completion([self result:NO offline:NO message:@"授权服务器响应格式异常" role:nil expiresAt:nil]);
            return;
        }

        if (![jsonBody[@"ok"] boolValue]) {
            NSString *message = [jsonBody[@"message"] description] ?: @"卡密无效或已过期";
            completion([self result:NO offline:NO message:message role:nil expiresAt:nil]);
            return;
        }

        NSString *ticket = [jsonBody[@"ticket"] description];
        LFCVerifiedTicket *verified = [LFCTicketVerifier verifyTicket:ticket deviceFingerprint:fingerprint];
        if (!verified.valid) {
            completion([self result:NO offline:NO message:verified.message role:nil expiresAt:nil]);
            return;
        }

        NSError *storeError = nil;
        [LFCTicketStore saveTicket:ticket deviceFingerprint:fingerprint error:&storeError];
        completion([self result:YES
                         offline:NO
                         message:@"授权成功"
                            role:verified.role
                       expiresAt:verified.expiresAt]);
    }];
    [task resume];
}

- (LFCLicenseResult *)validateLocalTicket {
    NSString *fingerprint = [self deviceFingerprint];
    NSError *loadError = nil;
    NSString *ticket = [LFCTicketStore loadTicketForDeviceFingerprint:fingerprint error:&loadError];
    if (ticket.length == 0) {
        return [self result:NO offline:YES message:@"未找到本地离线授权" role:nil expiresAt:nil];
    }
    LFCVerifiedTicket *verified = [LFCTicketVerifier verifyTicket:ticket deviceFingerprint:fingerprint];
    return [self result:verified.valid
                offline:YES
                message:verified.valid ? @"离线授权有效" : verified.message
                   role:verified.role
              expiresAt:verified.expiresAt];
}

- (LFCLicenseResult *)result:(BOOL)authorized
                     offline:(BOOL)offline
                     message:(NSString *)message
                        role:(NSString *)role
                   expiresAt:(NSDate *)expiresAt {
    LFCLicenseResult *result = [LFCLicenseResult new];
    result.authorized = authorized;
    result.offline = offline;
    result.message = message ?: @"";
    result.role = role;
    result.expiresAt = expiresAt;
    return result;
}

@end
