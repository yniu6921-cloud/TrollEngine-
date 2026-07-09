#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCRequestSigner : NSObject

+ (NSDictionary<NSString *, NSString *> *)signedHeadersForBody:(NSData *)body
                                                          path:(NSString *)path
                                                        method:(NSString *)method;
+ (NSString *)sha256Hex:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
