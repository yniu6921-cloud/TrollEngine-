//  悬浮球样式.m
// MARK: 悬浮球样式
#import "悬浮球样式.h"
#import "YuanBao_v1-Prefix.h"
// 完全重写悬浮球样式类，移除所有动画
@implementation 悬浮球样式

// 单例模式实现
+ (instancetype)sharedInstance {
    static 悬浮球样式 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * 创建悬浮球的视觉层次图层
 */
- (void)createFloatingBallLayers:(UIImageView*)floatingBall {
    // ... 原有的4个图层代码保持不变 ...
    
    // 4. 创建最内层的纯白色圆形图层
    CALayer *lightLayer3 = [CALayer layer];
    lightLayer3.frame = CGRectInset(floatingBall.bounds, 13, 13);
    lightLayer3.cornerRadius = 12;
    lightLayer3.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    [floatingBall.layer addSublayer:lightLayer3];
    
    // ========== 新增：图标图层 ==========
    // 使用Assets.xcassets中的图片
    UIImage *iconImage = [UIImage imageNamed:@"123"];
    
   
    
    if (iconImage) {
        CALayer *iconLayer = [CALayer layer];
        // 关键修改1：让图标图层frame和悬浮球bounds完全一致
        iconLayer.frame = floatingBall.bounds;
        // 关键修改2：设置圆角和悬浮球匹配（如果悬浮球是圆形）
        iconLayer.cornerRadius = CGRectGetWidth(floatingBall.bounds) / 2.0;
        // 关键修改3：裁剪超出圆角的内容
        iconLayer.masksToBounds = YES;
        // 设置图标内容
        iconLayer.contents = (__bridge id)iconImage.CGImage;
        // 关键修改4：让图标完全填充图层
        iconLayer.contentsGravity = kCAGravityResizeAspectFill;
        [floatingBall.layer addSublayer:iconLayer];
    }
}
@end

