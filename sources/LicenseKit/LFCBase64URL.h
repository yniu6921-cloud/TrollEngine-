#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCBase64URL : NSObject
+ (NSString *)encodeData:(NSData *)data;
+ (nullable NSData *)decodeString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
