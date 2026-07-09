//
//  SHMainAppDelegate.mm
//  SystemHelper
//
//  Created by Lessica on 2024/1/24.
//

#import <objc/runtime.h>
#import "SHMainAppDelegate.h"
#import "SBSAccessibilityWindowHostingController.h"
#import "UIWindow+Private.h"
#import "SHMainWnd.h"
#import "SHRootCtrl.h"

#import "SHDrawCtrl.h"
#import "主悬浮球ViewController.h"
#import "SHFloatWnd.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <os/log.h>
#import "rootless.h"
#import "NSUserDefaults+Private.h"
#if DEBUG
    #define log_debug os_log_debug
    #define log_info os_log_info
    #define log_error os_log_error
#else
    #define log_debug(...)
    #define log_info(...)
    #define log_error(...)
#endif
// USER_DEFAULTS_PATH 已在 supports/hudapp-prefix.pch 中定义

// HUD -> APP: Notify APP that the HUD's view is appeared.
#define NOTIFY_LAUNCHED_HUD "com.SysAdmin.notification.hud.launched"

// APP -> HUD: Notify HUD to dismiss itself.
#define NOTIFY_DISMISSAL_HUD "com.SysAdmin.notification.hud.dismissal"

// APP -> HUD: Notify HUD that the user defaults has been changed by APP.
#define NOTIFY_RELOAD_HUD "com.SysAdmin.notification.hud.reload"

// HUD -> APP: Notify APP that the user defaults has been changed by HUD.
#define NOTIFY_RELOAD_APP "com.SysAdmin.notification.app.reload"
@implementation SHMainAppDelegate {
    SHDrawCtrl *_rootViewController;
    
    SBSAccessibilityWindowHostingController *_windowHostingController;
    SHFloatWnd *_floatingBallWindow;  // 系统级悬浮球（随 HUD 一起显示）
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary <UIApplicationLaunchOptionsKey, id> *)launchOptions {
    log_debug(OS_LOG_DEFAULT, "- [SHMainAppDelegate application:%{public}@ didFinishLaunchingWithOptions:%{public}@]", application, launchOptions);
    
  
    
    // MARK: 绘制图层
    _rootViewController = [[SHDrawCtrl alloc] init];
    self.window = [[SHMainWnd alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:_rootViewController];
    [self.window setWindowLevel:UIWindowLevelStatusBar + 1];
    [self.window setUserInteractionEnabled:NO];
    [self.window setHidden:NO];
    
    [self.window makeKeyAndVisible];

    _windowHostingController = [[objc_getClass("SBSAccessibilityWindowHostingController") alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    // 1. 注册主 HUD 绘制窗口（系统级显示的关键）
    unsigned int mainContextId = [self.window _contextId];
    double mainWindowLevel = [self.window windowLevel];
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:Id"];
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:_windowHostingController];
    [inv setSelector:NSSelectorFromString(@"registerWindowWithContextID:atLevel:")];
    [inv setArgument:&mainContextId atIndex:2];
    [inv setArgument:&mainWindowLevel atIndex:3];
    [inv invoke];

    // 2. 系统级悬浮球：必须同样注册到 SBSAccessibilityWindowHostingController 才能跨应用显示
    _floatingBallWindow = [[SHFloatWnd alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _floatingBallWindow.windowLevel = UIWindowLevelStatusBar + 2010.0;  // 略高于绘制层，可点击
    _floatingBallWindow.backgroundColor = [UIColor clearColor];
    _floatingBallWindow.userInteractionEnabled = YES;
    _floatingBallWindow.rootViewController = [[主悬浮球ViewController alloc] init];
    [_floatingBallWindow setHidden:NO];
    [_floatingBallWindow makeKeyAndVisible];

    unsigned int ballContextId = [_floatingBallWindow _contextId];
    double ballWindowLevel = [_floatingBallWindow windowLevel];
    NSInvocation *invBall = [NSInvocation invocationWithMethodSignature:sig];
    [invBall setTarget:_windowHostingController];
    [invBall setSelector:NSSelectorFromString(@"registerWindowWithContextID:atLevel:")];
    [invBall setArgument:&ballContextId atIndex:2];
    [invBall setArgument:&ballWindowLevel atIndex:3];
    [invBall invoke];

#pragma clang diagnostic pop

    return YES;
}

@end
