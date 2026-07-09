//  悬浮球样式.h

#import <Foundation/Foundation.h>
#import "YuanBao_v1-Prefix.h"
NS_ASSUME_NONNULL_BEGIN

#define 悬浮球样式 d26ca76a4117d3f177b37899827a

@interface 悬浮球样式 : NSObject

// 单例访问方法
+ (instancetype)sharedInstance;

/**
 * 创建悬浮球视觉层次
 * @param floatingBall 目标UIImageView实例
 */
- (void)createFloatingBallLayers:(UIImageView*)floatingBall;



@end

NS_ASSUME_NONNULL_END
