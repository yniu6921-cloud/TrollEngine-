#import "LFCTicketStore.h"
#import "LFCAuthConfig.h"
#import "LFCMiniCrypto.h"
#import <Security/Security.h>

static NSString * const kLFCTicketStoreService = @"com.systemhelper.licensekit";
static NSString * const kLFCAESKeyAccount = @"ticket-aes-gcm-key";

@implementation LFCTicketStore

+ (BOOL)saveTicket:(NSString *)ticket
 deviceFingerprint:(NSString *)deviceFingerprint
             error:(NSError **)error {
    NSData *key = [self aesKey];
    NSData *plain = [ticket dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aad = [[NSString stringWithFormat:@"%@|%@", LFC_AUTH_APP_ID, deviceFingerprint]
                   dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *sealed = [self encryptPlaintext:plain key:key aad:aad];
    if (!sealed) {
        [self fillError:error message:@"AES-GCM encryption is unavailable"];
        return NO;
    }

    NSDictionary *envelope = @{
        @"version": @1,
        @"nonce": [sealed[@"nonce"] base64EncodedStringWithOptions:0],
        @"ciphertext": [sealed[@"ciphertext"] base64EncodedStringWithOptions:0],
        @"tag": [sealed[@"tag"] base64EncodedStringWithOptions:0],
        @"saved_at": @((NSInteger)NSDate.date.timeIntervalSince1970)
    };
    NSData *json = [NSJSONSerialization dataWithJSONObject:envelope options:0 error:error];
    if (!json) return NO;

    NSString *path = [self ticketPath];
    [[NSFileManager defaultManager] createDirectoryAtPath:path.stringByDeletingLastPathComponent
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    return [json writeToFile:path options:NSDataWritingAtomic error:error];
}

+ (NSString *)loadTicketForDeviceFingerprint:(NSString *)deviceFingerprint
                                       error:(NSError **)error {
    NSData *json = [NSData dataWithContentsOfFile:[self ticketPath] options:0 error:error];
    if (!json) return nil;

    NSDictionary *envelope = [NSJSONSerialization JSONObjectWithData:json options:0 error:error];
    if (![envelope isKindOfClass:NSDictionary.class]) return nil;

    NSData *nonce = [[NSData alloc] initWithBase64EncodedString:[envelope[@"nonce"] description] options:0];
    NSData *ciphertext = [[NSData alloc] initWithBase64EncodedString:[envelope[@"ciphertext"] description] options:0];
    NSData *tag = [[NSData alloc] initWithBase64EncodedString:[envelope[@"tag"] description] options:0];
    NSData *aad = [[NSString stringWithFormat:@"%@|%@", LFC_AUTH_APP_ID, deviceFingerprint]
                   dataUsingEncoding:NSUTF8StringEncoding];
    NSData *plain = [self decryptCiphertext:ciphertext nonce:nonce tag:tag key:[self aesKey] aad:aad];
    if (!plain) {
        [self fillError:error message:@"Local ticket decrypt failed"];
        return nil;
    }
    return [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
}

+ (NSString *)ticketPath {
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,
                                                                     NSUserDomainMask,
                                                                     YES);
    NSString *base = paths.firstObject ?: NSTemporaryDirectory();
    return [[base stringByAppendingPathComponent:@"LicenseKit"] stringByAppendingPathComponent:@"ticket.json"];
}

+ (NSData *)aesKey {
    NSData *existing = [self keychainDataForAccount:kLFCAESKeyAccount];
    if (existing.length == 32) return existing;

    uint8_t key[32] = {0};
    if (SecRandomCopyBytes(kSecRandomDefault, sizeof(key), key) != errSecSuccess) {
        return nil;
    }
    NSData *data = [NSData dataWithBytes:key length:sizeof(key)];
    [self saveKeychainData:data account:kLFCAESKeyAccount];
    return data;
}

+ (NSData *)keychainDataForAccount:(NSString *)account {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kLFCTicketStoreService,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess || !result) return nil;
    return CFBridgingRelease(result);
}

+ (BOOL)saveKeychainData:(NSData *)data account:(NSString *)account {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kLFCTicketStoreService,
        (__bridge id)kSecAttrAccount: account
    };
    SecItemDelete((__bridge CFDictionaryRef)query);
    NSMutableDictionary *item = [query mutableCopy];
    item[(__bridge id)kSecValueData] = data;
    item[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    return SecItemAdd((__bridge CFDictionaryRef)item, NULL) == errSecSuccess;
}

+ (NSDictionary *)encryptPlaintext:(NSData *)plain key:(NSData *)key aad:(NSData *)aad {
    return [LFCMiniCrypto aesGCMEncryptPlaintext:plain key:key aad:aad];
}

+ (NSData *)decryptCiphertext:(NSData *)ciphertext nonce:(NSData *)nonce tag:(NSData *)tag key:(NSData *)key aad:(NSData *)aad {
    return [LFCMiniCrypto aesGCMDecryptCiphertext:ciphertext nonce:nonce tag:tag key:key aad:aad];
}

+ (void)fillError:(NSError **)error message:(NSString *)message {
    if (!error) return;
    *error = [NSError errorWithDomain:@"LicenseKit"
                                 code:-1
                             userInfo:@{NSLocalizedDescriptionKey: message ?: @"LicenseKit error"}];
}

@end
