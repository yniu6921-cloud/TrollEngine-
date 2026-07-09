
//  过直播防录屏.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define 过直播容器 ff177164a78ba0d9215d1404e6916

@interface 过直播容器 : UIView
- (void)enableLiveStreamProtection:(BOOL)enable;
- (BOOL)isLiveStreamProtectionEnabled;
@end

NS_ASSUME_NONNULL_END
