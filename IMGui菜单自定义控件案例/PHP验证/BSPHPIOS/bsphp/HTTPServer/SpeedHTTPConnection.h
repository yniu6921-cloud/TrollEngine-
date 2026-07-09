#import <Foundation/Foundation.h>
#import "HTTPConnection.h"

NS_ASSUME_NONNULL_BEGIN
@interface SpeedHTTPConnection : HTTPConnection
@property (nonatomic, copy) NSString *currentPath;
@property (nonatomic, copy) NSString *currentMethod;
@end

NS_ASSUME_NONNULL_END
