
//
//  SHRootCtrl.m
//  SystemHelper
//
//  Created by 特特 on 2025/4/8.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import "SHRootCtrl.h"
#import <notify.h>
#import <objc/runtime.h>

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

// MARK: Menu
#import "SHMenuCtrl.h"
#import "SHMenuView.h"

#if !NO_TROLL
#import "FBSOrientationUpdate.h"
#import "FBSOrientationObserver.h"
#import "UIApplication+Private.h"
#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import "SpringBoardServices.h"

#define NOTIFY_UI_LOCKSTATE    "com.apple.springboard.lockstate"
#define NOTIFY_LS_APP_CHANGED  "com.apple.LaunchServices.ApplicationsChanged"
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
static void LaunchServicesApplicationStateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    BOOL isAppInstalled = NO;
    for (LSApplicationProxy *app in [[objc_getClass("LSApplicationWorkspace") defaultWorkspace] allApplications]) {
        if ([app.applicationIdentifier isEqualToString:@"com.apple.systemhelper"]) {
            isAppInstalled = YES;
            break;
        }
    }

    if (!isAppInstalled) {
        UIApplication *app = [UIApplication sharedApplication];
        [app terminateWithSuccess];
    }
}

static void SpringBoardLockStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    SHRootCtrl *rootViewController = (__bridge SHRootCtrl *)observer;
    NSString *lockState = (__bridge NSString *)name;
    if ([lockState isEqualToString:@NOTIFY_UI_LOCKSTATE]) {
        mach_port_t sbsPort = SBSSpringBoardServerPort();

        if (sbsPort == MACH_PORT_NULL)
            return;

        BOOL isLocked;
        BOOL isPasscodeSet;
        SBGetScreenLockStatus(sbsPort, &isLocked, &isPasscodeSet);

        if (!isLocked) {
            [rootViewController.view setHidden:NO];
        } else {
            [rootViewController.view setHidden:YES];
        }
    }
}
#endif

CGFloat is_Width = 0;
CGFloat is_Height = 0;

@interface SHRootCtrl (Troll)
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration;
@end

@implementation SHRootCtrl {
    SHMenuCtrl *MenuView;
    SHMenuView *Menuheid;
#if !NO_TROLL
    FBSOrientationObserver *_orientationObserver;// 方向观察者
#endif
    UIInterfaceOrientation _orientation;// 当前方向
}

- (void)registerNotifications {

#if !NO_TROLL
    CFNotificationCenterRef darwinCenter = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(
        darwinCenter,
        (__bridge const void *)self,
        LaunchServicesApplicationStateChanged,
        CFSTR(NOTIFY_LS_APP_CHANGED),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );
    CFNotificationCenterAddObserver(
        darwinCenter,
        (__bridge const void *)self,
        SpringBoardLockStatusChanged,
        CFSTR(NOTIFY_UI_LOCKSTATE),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce
    );
#endif
}

+ (BOOL)passthroughMode {
    return YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

- (BOOL)usesRotation {
    return YES;// 图层跟随旋转
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerNotifications];// 注册通知
#if !NO_TROLL
        // 初始化方向观察者
        _orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
        __weak SHRootCtrl *weakSelf = self;
        [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
            SHRootCtrl *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateOrientation:(UIInterfaceOrientation)orientationUpdate.orientation animateWithDuration:orientationUpdate.duration];
            });
        }];
#endif
    }
    return self;
}

- (void)dealloc {
#if !NO_TROLL
    [_orientationObserver invalidate];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = NO;
    MenuView = [SHMenuCtrl sharedInstance];
    Menuheid = [[SHMenuView alloc] initWithFrame:CGRectMake(0, 0, is_Width, is_Height)];
    [Menuheid addSubview:MenuView.view];
    [self.view addSubview:Menuheid];

    Menuheid.autoresizingMask = UIViewAutoresizingNone;
    MenuView.view.autoresizingMask = UIViewAutoresizingNone;
    Menuheid.translatesAutoresizingMaskIntoConstraints = NO;
    MenuView.view.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [Menuheid.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [Menuheid.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [Menuheid.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [Menuheid.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [MenuView.view.topAnchor constraintEqualToAnchor:Menuheid.topAnchor],
        [MenuView.view.bottomAnchor constraintEqualToAnchor:Menuheid.bottomAnchor],
        [MenuView.view.leadingAnchor constraintEqualToAnchor:Menuheid.leadingAnchor],
        [MenuView.view.trailingAnchor constraintEqualToAnchor:Menuheid.trailingAnchor]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    notify_post(NOTIFY_LAUNCHED_HUD);
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

@end

#if !NO_TROLL
@implementation SHRootCtrl (Troll)
// 方向更新
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    CGFloat safeWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
    CGFloat safeHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;

    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    is_Width = isLandscape ? MAX(safeWidth, safeHeight) : MIN(safeWidth, safeHeight);
    is_Height = isLandscape ? MIN(safeWidth, safeHeight) : MAX(safeWidth, safeHeight);

    CGAffineTransform transform;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }

    if (orientation == _orientation) {
        [self.view setNeedsUpdateConstraints];
        return;
    }

    _orientation = orientation;
    CGRect newBounds = CGRectMake(0, 0, is_Width, is_Height);
    Menuheid.frame = newBounds;
    MenuView.view.frame = newBounds;
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = transform;
        self.view.bounds = newBounds;
        self->Menuheid.transform = transform;
        self->Menuheid.bounds = newBounds;
        self->MenuView.view.transform = CGAffineTransformInvert(transform);
        self->MenuView.view.bounds = newBounds;
        [self.view layoutIfNeeded];
        [self->Menuheid layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view setNeedsUpdateConstraints];
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

#else
@implementation SHRootCtrl (NoTroll)
- (UIModalPresentationStyle)modalPresentationStyle { return UIModalPresentationOverFullScreen; }
- (UIModalTransitionStyle)modalTransitionStyle { return UIModalTransitionStyleCrossDissolve; }
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    __weak typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view setNeedsUpdateConstraints];
        [strongSelf.view setHidden:YES];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view setHidden:NO];
    }];
}
@end
#endif
