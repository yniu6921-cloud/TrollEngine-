
//  SHFloatWnd.m

// MARK: 悬浮球根图层

#import "SHFloatWnd.h"


@implementation SHFloatWnd

// 标记为系统窗口（可以获得更高优先级）
+ (BOOL)_isSystemWindow { return YES; }
// 不由WindowServer管理
- (BOOL)_isWindowServerHostingManaged { return NO; }
// 不忽略点击测试
- (BOOL)_ignoresHitTest { return NO; }
// 安全窗口
- (BOOL)_isSecure { return YES; }
// 创建安全上下文
- (BOOL)_shouldCreateContextAsSecure { return YES; }

@end
