#import "LFCDeviceFingerprint.h"
#import "LFCAuthConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>

static NSString * const kLFCKeychainService = @"com.systemhelper.licensekit";
static NSString * const kLFCKeychainDeviceUUID = @"device-uuid";

@implementation LFCDeviceFingerprint

+ (NSString *)currentFingerprint {
    NSMutableArray<NSString *> *parts = [NSMutableArray array];
    [parts addObject:LFC_AUTH_APP_ID];

    NSString *ecid = [self mobileGestaltStringForKey:@"UniqueChipID"];
    if (ecid.length > 0) [parts addObject:ecid];

    NSString *wifi = [self mobileGestaltStringForKey:@"WifiAddress"];
    if (wifi.length > 0) [parts addObject:wifi.lowercaseString];

    NSString *vendor = UIDevice.currentDevice.identifierForVendor.UUIDString;
    if (vendor.length > 0) [parts addObject:vendor];

    NSString *localUUID = [self keychainDeviceUUID];
    if (localUUID.length > 0) [parts addObject:localUUID];

    NSString *joined = [parts componentsJoinedByString:@"|"];
    return [self sha256Hex:[joined dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)mobileGestaltStringForKey:(NSString *)key {
    static void *handle = NULL;
    static CFTypeRef (*copyAnswer)(CFStringRef) = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY | RTLD_LOCAL);
        if (handle) {
            copyAnswer = (CFTypeRef (*)(CFStringRef))dlsym(handle, "MGCopyAnswer");
        }
    });
    if (!copyAnswer) return nil;

    CFTypeRef value = copyAnswer((__bridge CFStringRef)key);
    if (!value) return nil;
    id bridged = CFBridgingRelease(value);
    if ([bridged isKindOfClass:NSString.class]) return (NSString *)bridged;
    if ([bridged isKindOfClass:NSNumber.class]) return [(NSNumber *)bridged stringValue];
    return nil;
}

+ (NSString *)keychainDeviceUUID {
    NSData *existing = [self keychainDataForAccount:kLFCKeychainDeviceUUID];
    if (existing.length > 0) {
        return [[NSString alloc] initWithData:existing encoding:NSUTF8StringEncoding];
    }

    NSString *uuid = NSUUID.UUID.UUIDString;
    NSData *data = [uuid dataUsingEncoding:NSUTF8StringEncoding];
    [self saveKeychainData:data account:kLFCKeychainDeviceUUID];
    return uuid;
}

+ (NSData *)keychainDataForAccount:(NSString *)account {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kLFCKeychainService,
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
        (__bridge id)kSecAttrService: kLFCKeychainService,
        (__bridge id)kSecAttrAccount: account
    };
    SecItemDelete((__bridge CFDictionaryRef)query);

    NSMutableDictionary *item = [query mutableCopy];
    item[(__bridge id)kSecValueData] = data;
    item[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    return SecItemAdd((__bridge CFDictionaryRef)item, NULL) == errSecSuccess;
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

@end
