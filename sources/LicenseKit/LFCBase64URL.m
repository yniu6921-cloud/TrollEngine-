#import "LFCBase64URL.h"

@implementation LFCBase64URL

+ (NSString *)encodeData:(NSData *)data {
    NSString *b64 = [data base64EncodedStringWithOptions:0];
    b64 = [b64 stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    b64 = [b64 stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    b64 = [b64 stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return b64;
}

+ (NSData *)decodeString:(NSString *)string {
    if (string.length == 0) return nil;
    NSString *b64 = [string stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
    b64 = [b64 stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSUInteger padding = (4 - (b64.length % 4)) % 4;
    if (padding > 0) {
        b64 = [b64 stringByPaddingToLength:b64.length + padding withString:@"=" startingAtIndex:0];
    }
    return [[NSData alloc] initWithBase64EncodedString:b64 options:0];
}

@end
