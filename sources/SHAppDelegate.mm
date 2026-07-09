//
//  SHAppDelegate.m
//  SystemHelper
//
//  Created by 特特 on 2025/7/7.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHEntryCtrl.h"
#import "SHApplication.h"
#import <notify.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <CommonCrypto/CommonDigest.h>
@implementation SHAppDelegate {
    SHEntryCtrl *_rootViewController;
}
#define CHANGED_NAME "SpeedNotification"

#pragma mark - Harden helpers (no global injection scan)


#pragma mark - UIApplicationDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    // 第一个执行：立即开始UDID验证流程
    extern void 判断是否验证(void);
    extern bool 验证成功;
    // 通过+load方法已经启动验证，这里确保验证优先执行
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];

    UIViewController *transparentVC = [UIViewController new];
    transparentVC.view.backgroundColor = [UIColor clearColor];
    transparentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;

    // ✅ 背景图
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppBG"]];
    bgView.contentMode = UIViewContentModeScaleAspectFill;  // 铺满裁切
    bgView.userInteractionEnabled = NO;
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    [transparentVC.view addSubview:bgView];
    [transparentVC.view sendSubviewToBack:bgView];
    [NSLayoutConstraint activateConstraints:@[
        [bgView.topAnchor constraintEqualToAnchor:transparentVC.view.topAnchor],
        [bgView.bottomAnchor constraintEqualToAnchor:transparentVC.view.bottomAnchor],
        [bgView.leadingAnchor constraintEqualToAnchor:transparentVC.view.leadingAnchor],
        [bgView.trailingAnchor constraintEqualToAnchor:transparentVC.view.trailingAnchor],
    ]];

    self.window.rootViewController = transparentVC;
    [self.window makeKeyAndVisible];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
     

        [self triggerMainInterface];
    });
    return YES;
}



- (void)triggerMainInterface {
    if (_rootViewController) return;      // 已经切过就直接返回
    _rootViewController = [SHEntryCtrl new];
    self.window.rootViewController = _rootViewController;
}
@end
