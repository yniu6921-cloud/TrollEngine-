//
//  MenuViewController.h
//  YuanBao
//
//  Created by 特特 on 2025/4/9.
//  Copyright © 2025 Mr_Laote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBSOrientationUpdate.h"
#import "FBSOrientationObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuViewController : UIViewController
+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIView *floatingBall;
@property (nonatomic, assign) BOOL isMenuVisible;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, assign) BOOL shouldHandleTouch;
@property (nonatomic, strong) FBSOrientationObserver *orientationObserver;

@end

NS_ASSUME_NONNULL_END

#define ImageTX @"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"




#import "MenuViewController.h"
#import "MenuRootView.h"
#import <objc/runtime.h>

@interface MenuViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isFirstLayout;
@end

@implementation MenuViewController {
    CGPoint _lastAbsoluteBallPosition;
    CGPoint _initialTouchPoint;
    BOOL _isDragging;
}

+ (instancetype)sharedInstance {
    static MenuViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstLayout = YES;
    self.view = [[MenuRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ((MenuRootView *)self.view).menuController = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.userInteractionEnabled = YES;
    self.view.multipleTouchEnabled = NO;
    self.view.exclusiveTouch = YES;
    
    [self setupOrientationObserver];
    [self setupEnhancedFloatingBall];
}

#pragma mark - Enhanced Floating Ball
- (void)setupEnhancedFloatingBall {
    CGFloat ballSize = 100.0;
    CGRect initialFrame = CGRectMake([self screenWidth] - ballSize - 20, 100, ballSize, ballSize);
    self.floatingBall = [[UIView alloc] initWithFrame:initialFrame];
    self.floatingBall.backgroundColor = [UIColor colorWithRed:1.00 green:0.82 blue:0.00 alpha:0.9];
    self.floatingBall.layer.cornerRadius = ballSize / 2;
    self.floatingBall.userInteractionEnabled = YES;
    self.floatingBall.multipleTouchEnabled = NO;
    self.floatingBall.exclusiveTouch = YES;
    
    // 文本标签
    UILabel *ballLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ballSize, ballSize)];
    ballLabel.text = @"菜单";
    ballLabel.textColor = [UIColor whiteColor];
    ballLabel.font = [UIFont boldSystemFontOfSize:18];
    ballLabel.textAlignment = NSTextAlignmentCenter;
    ballLabel.userInteractionEnabled = NO;
    [self.floatingBall addSubview:ballLabel];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEnhancedPan:)];
    pan.delegate = self;
    [self.floatingBall addGestureRecognizer:pan];
    
    [self.view addSubview:self.floatingBall];
}

#pragma mark - Improved Gesture Handling
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ||
            [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]);
}

- (void)handleEnhancedPan:(UIPanGestureRecognizer *)gesture {
    UIView *ball = gesture.view;
    CGFloat halfWidth = ball.bounds.size.width / 2;
    CGFloat halfHeight = ball.bounds.size.height / 2;
    CGFloat screenWidth = [self screenWidth];
    CGFloat screenHeight = [self screenHeight];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            _isDragging = YES;
            _initialTouchPoint = [gesture locationInView:ball];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            if (!_isDragging) return;
            
            CGPoint touchInView = [gesture locationInView:self.view];
            CGPoint newCenter = CGPointMake(touchInView.x + (halfWidth - _initialTouchPoint.x),
                                           touchInView.y + (halfHeight - _initialTouchPoint.y));
            newCenter.x = MAX(halfWidth, MIN(screenWidth - halfWidth, newCenter.x));
            newCenter.y = MAX(halfHeight, MIN(screenHeight - halfHeight, newCenter.y));
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                ball.center = newCenter;
            } completion:nil];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            _isDragging = NO;
            _lastAbsoluteBallPosition = ball.center;
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            _isDragging = NO;
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Orientation Handling Improvements
- (void)setupOrientationObserver {
    self.orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf handleInterfaceOrientationChange:(UIInterfaceOrientation)orientationUpdate.orientation duration:orientationUpdate.duration];
        });
    }];
}

- (void)handleInterfaceOrientationChange:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    if (_isDragging) return;
    
    [UIView animateWithDuration:duration animations:^{
        CGRect newBounds = self.view.bounds;
        CGFloat newWidth = newBounds.size.width;
        CGFloat newHeight = newBounds.size.height;
        
        CGFloat halfWidth = self.floatingBall.bounds.size.width / 2;
        CGFloat halfHeight = self.floatingBall.bounds.size.height / 2;
        CGPoint newCenter = self->_lastAbsoluteBallPosition;
        newCenter.x = MIN(MAX(halfWidth, newCenter.x), newWidth - halfWidth);
        newCenter.y = MIN(MAX(halfHeight, newCenter.y), newHeight - halfHeight);
        
        self.floatingBall.center = newCenter;
    }];
    
    if (self.isMenuVisible) {
        self.menuView.center = CGPointMake([self screenWidth] / 2, [self screenHeight] / 2);
    }
}

#pragma mark - Helper Methods
- (CGFloat)screenWidth {
    return self.view.bounds.size.width;
}

- (CGFloat)screenHeight {
    return self.view.bounds.size.height;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.isFirstLayout) {
        self.isFirstLayout = NO;
        _lastAbsoluteBallPosition = self.floatingBall.center;
    }
    
    [self.view bringSubviewToFront:self.floatingBall];
}

@end



////
////  HUDMenuRootViewController.m
////  YuanBao
////
////  Created by 特特 on 2025/4/8.
////  Copyright © 2025 Mr_Laote. All rights reserved.
////
//
//#import "HUDMenuRootViewController.h"
//#import <notify.h>
//#import <objc/runtime.h>
//
//// MARK: info
//#import "YuanBao-Swift.h"
//
//// MARK: Menu
//#import "MenuViewController.h"
//#import "MenuHeidView.h"
//
//#if !NO_TROLL
//#import "FBSOrientationUpdate.h"
//#import "FBSOrientationObserver.h"
//#import "UIApplication+Private.h"
//#import "LSApplicationProxy.h"
//#import "LSApplicationWorkspace.h"
//#import "SpringBoardServices.h"
//
//#define NOTIFY_UI_LOCKSTATE    "com.apple.springboard.lockstate"
//#define NOTIFY_LS_APP_CHANGED  "com.apple.LaunchServices.ApplicationsChanged"
//
//static void LaunchServicesApplicationStateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
//    BOOL isAppInstalled = NO;
//    for (LSApplicationProxy *app in [[objc_getClass("LSApplicationWorkspace") defaultWorkspace] allApplications]) {
//        if ([app.applicationIdentifier isEqualToString:@"com.Laote.YuanBao"]) {
//            isAppInstalled = YES;
//            break;
//        }
//    }
//
//    if (!isAppInstalled) {
//        UIApplication *app = [UIApplication sharedApplication];
//        [app terminateWithSuccess];
//    }
//}
//
//static void SpringBoardLockStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
//    HUDMenuRootViewController *rootViewController = (__bridge HUDMenuRootViewController *)observer;
//    NSString *lockState = (__bridge NSString *)name;
//    if ([lockState isEqualToString:@NOTIFY_UI_LOCKSTATE]) {
//        mach_port_t sbsPort = SBSSpringBoardServerPort();
//
//        if (sbsPort == MACH_PORT_NULL)
//            return;
//
//        BOOL isLocked;
//        BOOL isPasscodeSet;
//        SBGetScreenLockStatus(sbsPort, &isLocked, &isPasscodeSet);
//
//        if (!isLocked) {
//            [rootViewController.view setHidden:NO];
//        } else {
//            [rootViewController.view setHidden:YES];
//        }
//    }
//}
//#endif
//
//CGFloat isWidth = 0;
//CGFloat isHeight = 0;
//
//@interface HUDMenuRootViewController (Troll)
//- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration;
//@end
//
//@implementation HUDMenuRootViewController {
//    MenuViewController *MenuView;
//    MenuHeidView *Menuheid;
//#if !NO_TROLL
//    FBSOrientationObserver *_orientationObserver;// 方向观察者
//#endif
//    UIInterfaceOrientation _orientation;// 当前方向
//}
//
//- (void)registerNotifications {
//
//#if !NO_TROLL
//    CFNotificationCenterRef darwinCenter = CFNotificationCenterGetDarwinNotifyCenter();
//    CFNotificationCenterAddObserver(
//        darwinCenter,
//        (__bridge const void *)self,
//        LaunchServicesApplicationStateChanged,
//        CFSTR(NOTIFY_LS_APP_CHANGED),
//        NULL,
//        CFNotificationSuspensionBehaviorCoalesce
//    );
//    CFNotificationCenterAddObserver(
//        darwinCenter,
//        (__bridge const void *)self,
//        SpringBoardLockStatusChanged,
//        CFSTR(NOTIFY_UI_LOCKSTATE),
//        NULL,
//        CFNotificationSuspensionBehaviorCoalesce
//    );
//#endif
//}
//
//- (BOOL)usesRotation {
//    return YES;// 图层跟随旋转
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self registerNotifications];// 注册通知
//#if !NO_TROLL
//        // 初始化方向观察者
//        _orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
//        __weak HUDMenuRootViewController *weakSelf = self;
//        [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
//            HUDMenuRootViewController *strongSelf = weakSelf;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf updateOrientation:(UIInterfaceOrientation)orientationUpdate.orientation animateWithDuration:orientationUpdate.duration];
//            });
//        }];
//#endif
//    }
//    return self;
//}
//
//- (void)dealloc {
//#if !NO_TROLL
//    [_orientationObserver invalidate];
//#endif
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    MenuView = [MenuViewController sharedInstance];
//    Menuheid = [[MenuHeidView alloc] initWithFrame:CGRectMake(0, 0, isWidth, isHeight)];
//    [Menuheid addSubview:MenuView.view];
//    [self.view addSubview:Menuheid];
//
//    Menuheid.autoresizingMask = UIViewAutoresizingNone;
//    MenuView.view.autoresizingMask = UIViewAutoresizingNone;
//    Menuheid.translatesAutoresizingMaskIntoConstraints = NO;
//    MenuView.view.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [NSLayoutConstraint activateConstraints:@[
//        [Menuheid.topAnchor constraintEqualToAnchor:self.view.topAnchor],
//        [Menuheid.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
//        [Menuheid.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
//        [Menuheid.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
//        [MenuView.view.topAnchor constraintEqualToAnchor:Menuheid.topAnchor],
//        [MenuView.view.bottomAnchor constraintEqualToAnchor:Menuheid.bottomAnchor],
//        [MenuView.view.leadingAnchor constraintEqualToAnchor:Menuheid.leadingAnchor],
//        [MenuView.view.trailingAnchor constraintEqualToAnchor:Menuheid.trailingAnchor]
//    ]];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    notify_post(NOTIFY_LAUNCHED_HUD);
//}
//
//- (void)viewSafeAreaInsetsDidChange {
//    [super viewSafeAreaInsetsDidChange];
//    [self updateViewConstraints];
//}
//
//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//}
//
//@end
//
//#if !NO_TROLL
//@implementation HUDMenuRootViewController (Troll)
//// 方向更新
//- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration {
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
//    CGFloat safeWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
//    CGFloat safeHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;
//
//    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
//    isWidth = isLandscape ? MAX(safeWidth, safeHeight) : MIN(safeWidth, safeHeight);
//    isHeight = isLandscape ? MIN(safeWidth, safeHeight) : MAX(safeWidth, safeHeight);
//
//    CGAffineTransform transform;
//    switch (orientation) {
//        case UIInterfaceOrientationPortraitUpsideDown:
//            transform = CGAffineTransformMakeRotation(M_PI);
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//            transform = CGAffineTransformMakeRotation(-M_PI_2);
//            break;
//        case UIInterfaceOrientationLandscapeRight:
//            transform = CGAffineTransformMakeRotation(M_PI_2);
//            break;
//        default:
//            transform = CGAffineTransformIdentity;
//            break;
//    }
//
//    if (orientation == _orientation) {
//        [self.view setNeedsUpdateConstraints];
//        return;
//    }
//
//    _orientation = orientation;
//    CGRect newBounds = CGRectMake(0, 0, isWidth, isHeight);
//    Menuheid.frame = newBounds;
//    MenuView.view.frame = newBounds;
//    [UIView animateWithDuration:duration animations:^{
//        self.view.transform = transform;
//        self.view.bounds = newBounds;
//        self->Menuheid.transform = transform;
//        self->Menuheid.bounds = newBounds;
//        self->MenuView.view.transform = CGAffineTransformInvert(transform);
//        self->MenuView.view.bounds = newBounds;
//        [self.view layoutIfNeeded];
//        [self->Menuheid layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [self.view setNeedsUpdateConstraints];
//    }];
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//@end
//
//#else
//@implementation HUDMenuRootViewController (NoTroll)
//- (UIModalPresentationStyle)modalPresentationStyle { return UIModalPresentationOverFullScreen; }
//- (UIModalTransitionStyle)modalTransitionStyle { return UIModalTransitionStyleCrossDissolve; }
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    __weak typeof(self) weakSelf = self;
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.view setNeedsUpdateConstraints];
//        [strongSelf.view setHidden:YES];
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.view setHidden:NO];
//    }];
//}
//@end
//#endif



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!self.ballView.isDragging) return;
//
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self.superview];
//    CGPoint previousLocation = [touch previousLocationInView:self.superview];
//
//    CGFloat deltaX = location.x - previousLocation.x;
//    CGFloat deltaY = location.y - previousLocation.y;
//    [self setCenterWithDeltaX:deltaX deltaY:deltaY];
}

