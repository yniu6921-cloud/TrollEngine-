//
//  SHDrawCtrl.m
//  SystemHelper
//
//  Created by 特特 on 2025/4/15.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import "SHDrawCtrl.h"
#import <notify.h>
#import <objc/runtime.h>


#import "SHRenderView.h"

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

// HUD -> APP: Notify APP that the HUD's view is appeared.
#define NOTIFY_LAUNCHED_HUD "com.SysAdmin.notification.hud.launched"

// APP -> HUD: Notify HUD to dismiss itself.
#define NOTIFY_DISMISSAL_HUD "com.SysAdmin.notification.hud.dismissal"

// APP -> HUD: Notify HUD that the user defaults has been changed by APP.
#define NOTIFY_RELOAD_HUD "com.SysAdmin.notification.hud.reload"

// HUD -> APP: Notify APP that the user defaults has been changed by HUD.
#define NOTIFY_RELOAD_APP "com.SysAdmin.notification.app.reload"
#define FADE_OUT_DURATION 0.25
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
    SHDrawCtrl *rootViewController = (__bridge SHDrawCtrl *)observer;
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

@interface SHDrawCtrl (Troll)
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration;
@property (nonatomic, strong) NSTimer *prefsssddTimer;      // 轮询 iCloud KVS（可替换为通知）
@end

@interface SHDrawCtrl ()

@end

CGFloat DrawWidth = 0;
CGFloat DrawHeight = 0;

@implementation SHDrawCtrl {
    SHRenderView *DrawView;
    
    UITextField* CoverView;
    UITextField* CoverView1;
    
    
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

+ (BOOL)passthroughMode { return YES; }

- (BOOL)usesRotation { return YES; }

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerNotifications];// 注册通知
#if !NO_TROLL
        _orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
        __weak SHDrawCtrl *weakSelf = self;
        [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
            SHDrawCtrl *strongSelf = weakSelf;
            UIInterfaceOrientation orientation = (UIInterfaceOrientation)orientationUpdate.orientation;
            if (UIInterfaceOrientationIsPortrait(orientation)) orientation = UIInterfaceOrientationLandscapeRight;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf updateOrientation:orientation animateWithDuration:orientationUpdate.duration];
            });
        }];
#endif
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !NO_TROLL
    [_orientationObserver invalidate];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    self.view.userInteractionEnabled = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
       [store synchronize]; // 先拉取一次 iCloud KVS

       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                      dispatch_get_main_queue(), ^{
           BOOL live = [store boolForKey:@"直播"];
           self->CoverView.secureTextEntry  = live;
           self->CoverView1.secureTextEntry = live;

           // 若切换不生效，可以强刷一次文本（可选）
           // NSString *t0 = CoverView.text;  CoverView.text = @"";  CoverView.text = t0;
           // NSString *t1 = CoverView1.text; CoverView1.text = @""; CoverView1.text = t1;
       });
    // 可选：监听后续云端变更，变化时自动更新
       [[NSNotificationCenter defaultCenter] addObserverForName:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                         object:store queue:[NSOperationQueue mainQueue]
                                                     usingBlock:^(NSNotification * _Nonnull note) {
           NSArray *changed = note.userInfo[NSUbiquitousKeyValueStoreChangedKeysKey];
           if (!changed || [changed containsObject:@"直播"]) {
               BOOL live = [store boolForKey:@"直播"];
               self->CoverView.secureTextEntry  = live;
               self->CoverView1.secureTextEntry = live;
           }
       }];
    
    DrawView = [SHRenderView sharedInstance];
    
    CoverView1 = [[UITextField alloc] init];
    
    
    
    CoverView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, DrawWidth, DrawWidth)];

    
    CoverView.frame = self.view.bounds;
    CoverView.subviews.firstObject.userInteractionEnabled = YES;
    CoverView.userInteractionEnabled = YES;
    CoverView.backgroundColor = [UIColor clearColor];
    [CoverView addSubview:CoverView1];
    [self.view addSubview:CoverView];
    CoverView.autoresizingMask = UIViewAutoresizingNone;
    CoverView1.autoresizingMask = UIViewAutoresizingNone;
    CoverView.translatesAutoresizingMaskIntoConstraints = NO;
    CoverView1.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    DrawView.autoresizingMask = UIViewAutoresizingNone;
    DrawView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [CoverView1.subviews.firstObject addSubview:DrawView];
    
    [NSLayoutConstraint activateConstraints:@[
        [CoverView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [CoverView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [CoverView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [CoverView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [CoverView1.topAnchor constraintEqualToAnchor:CoverView.topAnchor],
        [CoverView1.bottomAnchor constraintEqualToAnchor:CoverView.bottomAnchor],
        [CoverView1.leadingAnchor constraintEqualToAnchor:CoverView.leadingAnchor],
        [CoverView1.trailingAnchor constraintEqualToAnchor:CoverView.trailingAnchor],
        [DrawView.topAnchor constraintEqualToAnchor:CoverView1.topAnchor],
        [DrawView.bottomAnchor constraintEqualToAnchor:CoverView1.bottomAnchor],
        [DrawView.leadingAnchor constraintEqualToAnchor:CoverView1.leadingAnchor],
        [DrawView.trailingAnchor constraintEqualToAnchor:CoverView1.trailingAnchor]
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
@implementation SHDrawCtrl (Troll)

// 使用关联对象实现 prefsssddTimer 属性
static char prefsssddTimerKey;

- (NSTimer *)prefsssddTimer {
    return objc_getAssociatedObject(self, &prefsssddTimerKey);
}

- (void)setPrefsssddTimer:(NSTimer *)prefsssddTimer {
    objc_setAssociatedObject(self, &prefsssddTimerKey, prefsssddTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 方向更新
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    DrawWidth = isLandscape ? MAX(screenSize.width, screenSize.height) : MIN(screenSize.width, screenSize.height);
    DrawHeight =isLandscape ? MIN(screenSize.width, screenSize.height) : MAX(screenSize.width, screenSize.height);

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
    CGRect bounds = CGRectMake(0, 0, DrawWidth, DrawHeight);
    CoverView.frame = bounds;
    CoverView1.frame = bounds;
    [UIView animateWithDuration:duration animations:^{
        
        self.view.transform = transform;
        self.view.bounds = bounds;
        
        self->CoverView.bounds = bounds;
        self->CoverView.transform = transform;
        
        self->CoverView1.bounds = bounds;
        self->CoverView1.transform = CGAffineTransformInvert(transform);
      
        
        [self.view layoutIfNeeded];
        [self->CoverView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        // [weakSelf.view setHidden:NO];
        [self.view setNeedsUpdateConstraints];
    }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end

#else
@implementation SHDrawCtrl (NoTroll)
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
