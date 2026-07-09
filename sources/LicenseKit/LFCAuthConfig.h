#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 Replace these values before production deployment.

 The public key below is the RFC 8032 Ed25519 test public key and is kept only
 so local development has a deterministic default. Generate your own key pair
 with the Go server command documented in license-platform/docs/DEPLOYMENT.md,
 put the public key here, and keep the private seed only on the server.
 */
#define LFC_AUTH_BASE_URL @"https://42.194.159.78"
#define LFC_AUTH_APP_ID @"com.apple.systemhelper"
#define LFC_AUTH_ACTIVATE_PATH @"/api/v1/license/activate"
#define LFC_AUTH_ED25519_PUBLIC_KEY_B64 @"YXpV5N8m3uk+8LuWvlB30BFklMF8gNjdy7ZjRGAyjsA="
#define LFC_AUTH_PINNED_CERT_SHA256_B64 @"abp0t/dI5ZeMOfcMsbm+yEaucvBjlSNS9Y9rFSCGgsQ="

/*
 This secret signs client requests to give the server a stable envelope for
 timestamp/nonce replay checks. It is not a DRM secret because it ships in the
 client. The real anti-tamper boundary is the server Ed25519 ticket signature.
 */
#define LFC_AUTH_CLIENT_HMAC_SECRET @"b8a710bf3a39c4657c859b356d14233a20ceecda75c8fa50581a0d6b11087a1f"

NS_ASSUME_NONNULL_END
