//  主悬浮球ViewController.mm
#import "主悬浮球ViewController.h"
#import "oc悬浮菜单.h"
#import "悬浮球样式.h"
#import "过直播容器.h"


#import "FBSOrientationUpdate.h"
#import "FBSOrientationObserver.h"

#import <notify.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <objc/runtime.h>
#import <mach/vm_param.h>

#import "UIApplication+Private.h"
#import "LSApplicationProxy.h"
#import "LSApplicationWorkspace.h"
#import "SpringBoardServices.h"



// 悬浮球宽度常量
static CGFloat const kFloatingBallWidth = 40.0f;
 static NSString * const kTSMenuCloseNotification = @"com.afei.HP.menu.close";
static NSString * const kTSLaunchTransitionShowNotification = @"com.afei.HP.launch.transition.show";
// 屏幕宽高变量
CGFloat isWidth = 0;
CGFloat isHeight = 0;

// 应用状态变化通知回调
static void LaunchServicesApplicationStateChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    BOOL isAppInstalled = NO;
    // 检查应用是否安装
    for (LSApplicationProxy *app in [[objc_getClass("LSApplicationWorkspace") defaultWorkspace] allApplications]) {
        if ([app.applicationIdentifier isEqualToString:appIdentifier]) {
            isAppInstalled = YES;
            break;
        }
    }
    // 如果应用被卸载则终止进程
    if (!isAppInstalled) {
        UIApplication *app = [UIApplication sharedApplication];
        [app terminateWithSuccess];
    }
}


// SpringBoard锁屏状态变化回调
static void SpringBoardLockStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    主悬浮球ViewController *rootViewController = (__bridge 主悬浮球ViewController *)observer;
    NSString *lockState = (__bridge NSString *)name;
    if ([lockState isEqualToString:[NSString stringWithUTF8String:NOTIFY_UI_LOCKSTATE]]) {
        mach_port_t sbsPort = SBSSpringBoardServerPort();
        if (sbsPort == MACH_PORT_NULL) return;
        BOOL isLocked;
        BOOL isPasscodeSet;
        // 获取锁屏状态
        SBGetScreenLockStatus(sbsPort, &isLocked, &isPasscodeSet);
        // 根据锁屏状态显示/隐藏视图
        if (!isLocked) [rootViewController.view setHidden:NO];
        else [rootViewController.view setHidden:YES];
    }
}


// 分类声明
@interface 主悬浮球ViewController (Troll)
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration;
- (void)adjustFloatingBallPos:(CGPoint)proposedCenter;
@end

@implementation 主悬浮球ViewController {
    UIImageView *floatingBall;      // 悬浮球视图
    自用oc悬浮菜单* MenuVC;              // 菜单视图控制器
    过直播容器* MenuHideVC;       // 菜单隐藏视图控制器
    bool isOpenMenu;                // 菜单是否打开标志
    FBSOrientationObserver *_orientationObserver; // 方向观察者
    UIInterfaceOrientation _orientation; // 当前方向
    NSTimer *floatingBallCheckTimer; // 悬浮球状态检查定时器

    UIImageView *launchTransitionImageView;
    BOOL launchTransitionPending;
    
    int _floatingBallFrameCount;
    CFTimeInterval _floatingBallLastTime;
    CFTimeInterval _lastVolumePressTime;
}



// 是否穿透触摸
+ (BOOL)passthroughMode { return NO; }
// 是否支持旋转
- (BOOL)usesRotation { return YES; }



// 初始化方法（注册旋转，保证在横屏 App / SpringBoard 中菜单方向正确）
- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerNotifications];  // 注册通知
        // 开启方向监听，根据系统方向旋转整个悬浮窗
        [self RotatingNotifications];
    }
    return self;
}

// MARK: 方向通知处理
- (void)RotatingNotifications {
    _orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
    __weak 主悬浮球ViewController *weakSelf = self;
    // 方向变化回调处理
    [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
        主悬浮球ViewController *strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf updateOrientation:(UIInterfaceOrientation)orientationUpdate.orientation animateWithDuration:orientationUpdate.duration];
        });
    }];
}

// 注册系统通知
- (void)registerNotifications {
    int token;
    notify_register_dispatch(NOTIFY_RELOAD_HUD, &token, dispatch_get_main_queue(), ^(int token) {
    });
    // 注册Darwin通知
    CFNotificationCenterRef darwinCenter = CFNotificationCenterGetDarwinNotifyCenter();
    // 应用状态变化通知
    CFNotificationCenterAddObserver(
                                    darwinCenter,
                                    (__bridge const void *)self,
                                    LaunchServicesApplicationStateChanged,
                                    CFSTR(NOTIFY_LS_APP_CHANGED),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce
                                    );
    // 锁屏状态变化通知
    CFNotificationCenterAddObserver(
                                    darwinCenter,
                                    (__bridge const void *)self,
                                    SpringBoardLockStatusChanged,
                                    CFSTR(NOTIFY_UI_LOCKSTATE),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce
                                    );
}




// 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK: 执行顺序决定了视图层级
    [self setupMenu];        // 设置菜单
    [self setupFloatingBall]; // 设置悬浮球

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuCloseNotification:) name:kTSMenuCloseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLaunchTransitionNotification:) name:kTSLaunchTransitionShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onSystemVolumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
 }

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

 
// 视图出现后通知
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    notify_post(NOTIFY_LAUNCHED_HUD);
}

// 视图布局变化
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

// 安全区域变化
- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self adjustFloatingBallPos:floatingBall.center];
}



#pragma mark - 设置菜单
- (void)setupMenu {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect menuBounds = self.view.bounds;
    if (CGRectIsEmpty(menuBounds)) {
        menuBounds = screenBounds;
    }
    // 1. 初始化菜单，直接使用当前窗口方向，避免横屏游戏中菜单被转 90 度。
    MenuVC = [[自用oc悬浮菜单 alloc] initWithFrame:menuBounds];
    // 2. 初始化隐藏容器（过直播容器），与菜单同尺寸
    MenuHideVC = [[过直播容器 alloc] initWithFrame:menuBounds];
    
    [MenuHideVC addSubview:MenuVC];
    [self.view addSubview:MenuHideVC];
    [self setupLaunchTransitionImage];
    [self isOnOpenMenu:NO]; // MARK: 悬浮球初始状态为关闭菜单
}

#pragma mark - 设置悬浮球
- (void)setupFloatingBall {
    // 初始位置(屏幕70%位置)
    float kw = self.view.frame.size.width * 0.7;
    float kh = self.view.frame.size.height * 0.7;
    
    floatingBall = [[UIImageView alloc] initWithFrame:CGRectMake(kw, kh, kFloatingBallWidth, kFloatingBallWidth)];
    floatingBall.layer.cornerRadius = kFloatingBallWidth / 2; // 圆形
    floatingBall.layer.masksToBounds = YES;
    floatingBall.userInteractionEnabled = YES; // 启用用户交互
    floatingBall.alpha = 1.0f; // 固定透明度1.0
    floatingBall.hidden = NO; // 初始显示
    
    [[悬浮球样式 sharedInstance] createFloatingBallLayers:floatingBall]; // 设置悬浮球样式
    
    // 添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [floatingBall addGestureRecognizer:pan];
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(floatingBallClicked:)];
    [floatingBall addGestureRecognizer:tap];
    
    [self->MenuHideVC addSubview:floatingBall];
    [self->MenuHideVC bringSubviewToFront:floatingBall];
   // [self.view addSubview:floatingBall];
}



- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    // 悬浮球拖动帧率监控
    CFTimeInterval currentTime = CACurrentMediaTime();
    if (currentTime - _floatingBallLastTime >= 1.0) {

        _floatingBallFrameCount = 0;
        _floatingBallLastTime = currentTime;
    }
    _floatingBallFrameCount++;
    
    // 计算新位置
    CGPoint translation = [sender translationInView:self.view];
    CGPoint newCenter = CGPointMake(floatingBall.center.x + translation.x, floatingBall.center.y + translation.y);
    
    // 确保悬浮球不会移出屏幕
    CGFloat ballRadius = kFloatingBallWidth / 2;
    CGRect bounds = self.view.bounds;
    newCenter.x = MAX(ballRadius, MIN(newCenter.x, bounds.size.width - ballRadius));
    newCenter.y = MAX(ballRadius, MIN(newCenter.y, bounds.size.height - ballRadius));
    
    floatingBall.center = newCenter;
    [sender setTranslation:CGPointZero inView:self.view];
}


#pragma mark - 菜单显示/隐藏控制
- (void)isOnOpenMenu:(BOOL)isOn {
    [self setMenuOpen:isOn animated:NO];
}


// 修改悬浮球点击事件，移除动画
- (void)floatingBallClicked:(UIButton *)button {
    (void)button;

    if (launchTransitionPending && !launchTransitionImageView.hidden) {
        launchTransitionPending = NO;
        [self hideLaunchTransitionImageAnimated:YES completion:^{
            [self setMenuOpen:YES animated:YES];
        }];
        return;
    }

    bool isOpen = isOpenMenu;
    [self setMenuOpen:!isOpen animated:YES];
}

- (void)handleMenuCloseNotification:(NSNotification *)notification {
    (void)notification;
    [self setMenuOpen:NO animated:YES];
}

- (void)handleLaunchTransitionNotification:(NSNotification *)notification {
    (void)notification;
    [self showLaunchTransitionImage];
}

- (void)onSystemVolumeChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *reason = userInfo[@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"];
    if (reason.length && ![reason isEqualToString:@"ExplicitVolumeChange"]) {
        return;
    }

    CFTimeInterval now = CACurrentMediaTime();
    if (_lastVolumePressTime > 0 && (now - _lastVolumePressTime) <= 0.40) {
        _lastVolumePressTime = 0;
        [self setMenuOpen:!isOpenMenu animated:YES];
    } else {
        _lastVolumePressTime = now;
    }
}

- (void)setupLaunchTransitionImage {
    UIImage *transitionImage = [UIImage imageNamed:@"悬浮过度图片"];
    if (!transitionImage) {
        transitionImage = [UIImage imageNamed:@"悬浮过度图片.png"];
    }
    if (!transitionImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"悬浮过度图片" ofType:@"png"];
        if (path.length > 0) {
            transitionImage = [UIImage imageWithContentsOfFile:path];
        }
    }

    launchTransitionImageView = [[UIImageView alloc] initWithFrame:MenuHideVC.bounds];
    launchTransitionImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    launchTransitionImageView.contentMode = UIViewContentModeScaleAspectFill;
    launchTransitionImageView.userInteractionEnabled = NO;
    launchTransitionImageView.image = transitionImage;
    launchTransitionImageView.alpha = 0.0;
    launchTransitionImageView.hidden = YES;
    [MenuHideVC addSubview:launchTransitionImageView];
}

- (void)showLaunchTransitionImage {
    launchTransitionPending = YES;
    [self setMenuOpen:NO animated:NO];

    if (!launchTransitionImageView.image) {
        return;
    }

    launchTransitionImageView.hidden = NO;
    launchTransitionImageView.alpha = 0.0;
    [MenuHideVC bringSubviewToFront:launchTransitionImageView];
    [MenuHideVC bringSubviewToFront:floatingBall];

    [UIView animateWithDuration:0.26
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self->launchTransitionImageView.alpha = 1.0;
    } completion:nil];
}

- (void)hideLaunchTransitionImageAnimated:(BOOL)animated completion:(dispatch_block_t)completion {
    if (launchTransitionImageView.hidden || launchTransitionImageView.alpha <= 0.01) {
        launchTransitionImageView.hidden = YES;
        launchTransitionImageView.alpha = 0.0;
        if (completion) completion();
        return;
    }

    void (^finishBlock)(void) = ^{
        self->launchTransitionImageView.hidden = YES;
        self->launchTransitionImageView.alpha = 0.0;
        [self->MenuHideVC bringSubviewToFront:self->floatingBall];
        if (completion) completion();
    };

    if (!animated) {
        finishBlock();
        return;
    }

    [UIView animateWithDuration:0.22
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self->launchTransitionImageView.alpha = 0.0;
    } completion:^(__unused BOOL finished) {
        finishBlock();
    }];
}

- (void)setMenuOpen:(BOOL)isOn animated:(BOOL)animated {
    if (isOn && !launchTransitionImageView.hidden) {
        launchTransitionPending = NO;
        [self hideLaunchTransitionImageAnimated:NO completion:nil];
    }

    if (isOpenMenu == isOn && ((isOn && !MenuVC.hidden) || (!isOn && MenuVC.hidden))) {
        return;
    }

    isOpenMenu = isOn;

    if (isOn) {
        MenuVC.hidden = NO;
        [MenuHideVC bringSubviewToFront:MenuVC];
        [MenuHideVC bringSubviewToFront:floatingBall];

        if (!animated) {
            MenuVC.alpha = 1.0;
            MenuVC.transform = CGAffineTransformIdentity;
            return;
        }

        MenuVC.alpha = 0.0;
        MenuVC.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.92, 0.92),
                                                   CGAffineTransformMakeTranslation(0, 18.0));
        [UIView animateWithDuration:0.28
                              delay:0
             usingSpringWithDamping:0.88
              initialSpringVelocity:0.68
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self->MenuVC.alpha = 1.0;
            self->MenuVC.transform = CGAffineTransformIdentity;
        } completion:nil];
        return;
    }

    if (!animated) {
        MenuVC.hidden = YES;
        MenuVC.alpha = 1.0;
        MenuVC.transform = CGAffineTransformIdentity;
        return;
    }

    [UIView animateWithDuration:0.20
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self->MenuVC.alpha = 0.0;
        self->MenuVC.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.94, 0.94),
                                                         CGAffineTransformMakeTranslation(0, 10.0));
    } completion:^(__unused BOOL finished) {
        self->MenuVC.hidden = YES;
        self->MenuVC.alpha = 1.0;
        self->MenuVC.transform = CGAffineTransformIdentity;
    }];
}


// 对外控制：显示 / 隐藏悬浮球
- (void)showFloatingBall {
    floatingBall.hidden = NO;
}

- (void)hideFloatingBall {
    floatingBall.hidden = YES;
}

@end

// 方向处理分类实现
@implementation 主悬浮球ViewController (Troll)

// 更新方向
- (void)updateOrientation:(UIInterfaceOrientation)orientation animateWithDuration:(NSTimeInterval)duration {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    CGFloat safeWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right;
    CGFloat safeHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom;
    
    // 计算横竖屏尺寸
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    isWidth = isLandscape ? MAX(safeWidth, safeHeight) : MIN(safeWidth, safeHeight);
    isHeight = isLandscape ? MIN(safeWidth, safeHeight) : MAX(safeWidth, safeHeight);
    
    // 根据方向设置变换矩阵
    CGAffineTransform transform;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown: transform = CGAffineTransformMakeRotation(M_PI); break;
        case UIInterfaceOrientationLandscapeLeft: transform = CGAffineTransformMakeRotation(-M_PI_2); break;
        case UIInterfaceOrientationLandscapeRight: transform = CGAffineTransformMakeRotation(M_PI_2); break;
        default: transform = CGAffineTransformIdentity; break;
    }
    
    if (orientation == _orientation) {
        [self.view setNeedsUpdateConstraints];
        return;
    }
    
    // 获取悬浮球在窗口中的位置
    CGPoint currentBallCenterInWindow = [self.view convertPoint:floatingBall.center toView:nil];
    _orientation = orientation;
    CGRect newBounds = CGRectMake(0, 0, isWidth, isHeight);
    
    // 执行旋转动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = transform;
        self.view.bounds = newBounds;
        
        // 重置悬浮球变换并调整位置
        self->floatingBall.transform = CGAffineTransformIdentity;
        CGPoint newBallCenter = [self.view convertPoint:currentBallCenterInWindow fromView:nil];
        [self adjustFloatingBallPos:newBallCenter];
        
        // 重置菜单视图，保持与当前窗口方向一致。
        self->MenuVC.transform = CGAffineTransformIdentity;
        self->MenuVC.frame = self.view.bounds;
        self->MenuHideVC.transform = CGAffineTransformIdentity;
        self->MenuHideVC.frame = self.view.bounds;
        
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view setNeedsUpdateConstraints];
    }];
}

// 调整悬浮球位置
- (void)adjustFloatingBallPos:(CGPoint)proposedCenter {
    CGFloat ballRadius = kFloatingBallWidth / 2;
    CGRect bounds = self.view.bounds;
    CGPoint adjustedCenter = proposedCenter;
    // 确保悬浮球不会超出屏幕边界
    adjustedCenter.x = MAX(ballRadius, MIN(adjustedCenter.x, bounds.size.width - ballRadius));
    adjustedCenter.y = MAX(ballRadius, MIN(adjustedCenter.y, bounds.size.height - ballRadius));
    
    // 如果需要调整位置，则执行动画
    if (!CGPointEqualToPoint(adjustedCenter, floatingBall.center)) {
        [UIView animateWithDuration:0.3 animations:^{
            self->floatingBall.center = adjustedCenter;
        }];
    }
}

// 支持的界面方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // 悬浮窗需要适配横竖屏，这里放开为全部方向
    return UIInterfaceOrientationMaskAll;
}

@end
