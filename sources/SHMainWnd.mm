//
//  SHMainWnd.mm
//  SystemHelper
//
//  Created by Lessica on 2024/1/24.
//

// MARK: 绘制图层（触摸等···）
#import "SHMainWnd.h"
#import "SHRootCtrl.h"
#import <objc/runtime.h>

@implementation SHMainWnd

+ (BOOL)_isSystemWindow { return YES; }
- (BOOL)_isWindowServerHostingManaged { return NO; }
- (BOOL)_ignoresHitTest { return [SHRootCtrl passthroughMode]; }
- (BOOL)_isSecure { return YES; }
- (BOOL)_shouldCreateContextAsSecure { return YES; }

// 确保窗口能跨应用显示的关键方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置为最高窗口层级，确保在所有应用之上
        self.windowLevel = UIWindowLevelStatusBar + 2000.0;
        
        // 允许用户交互
        self.userInteractionEnabled = YES;
        
        // 透明背景，避免遮挡其他应用
        self.backgroundColor = [UIColor clearColor];
        
        // 确保窗口可见
        self.hidden = NO;
        
        // 设置为关键窗口
        [self makeKeyAndVisible];
        
        NSLog(@"[SHMainWnd] 初始化系统窗口，层级: %f", self.windowLevel);
    }
    return self;
}

// 覆盖makeKeyAndVisible确保窗口总是可见
- (void)makeKeyAndVisible {
    [super makeKeyAndVisible];
    
    // 再次确保窗口层级
    if (self.windowLevel < UIWindowLevelStatusBar + 1000) {
        self.windowLevel = UIWindowLevelStatusBar + 2000.0;
    }
    
    NSLog(@"[SHMainWnd] 窗口已设为关键窗口，层级: %f", self.windowLevel);
}

// 添加额外方法确保系统窗口行为
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"[SHMainWnd] 类已加载，准备作为系统窗口使用");
    });
}

@end
