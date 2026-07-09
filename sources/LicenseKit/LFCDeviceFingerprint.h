#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCDeviceFingerprint : NSObject

/*
 Returns a privacy-preserving SHA-256 fingerprint. The implementation uses
 ECID/Wi-Fi MAC when MobileGestalt exposes them in the current TrollStore
 environment, then mixes an app-local Keychain UUID. Raw identifiers are never
 uploaded to the server.
 */
+ (NSString *)currentFingerprint;

@end

NS_ASSUME_NONNULL_END
