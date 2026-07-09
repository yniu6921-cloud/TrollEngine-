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
    
    int _floatingBallFrameCount;
    CFTimeInterval _floatingBallLastTime;
}



// 是否穿透触摸
+ (BOOL)passthroughMode { return NO; }
// 是否支持旋转
- (BOOL)usesRotation { return YES; }



// 初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerNotifications];  // 注册通知
        [self RotatingNotifications];  // 注册旋转通知
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
    // 1. 初始化菜单，传入全屏范围
    MenuVC = [[自用oc悬浮菜单 alloc] initWithFrame:screenBounds];
    // 2. 初始化隐藏容器（过直播容器），也传入全屏范围
    MenuHideVC = [[过直播容器 alloc] initWithFrame:screenBounds];
    
    [MenuHideVC addSubview:MenuVC];
    [self.view addSubview:MenuHideVC];
    
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
    isOpenMenu = isOn;
    MenuVC.hidden = !isOpenMenu;
   // MenuHideVC.hidden = !isOpenMenu;
}


// 修改悬浮球点击事件，移除动画
- (void)floatingBallClicked:(UIButton *)button {
    bool isOpen = isOpenMenu;
    [self isOnOpenMenu:!isOpen]; // 切换菜单状态
}

- (void)handleMenuCloseNotification:(NSNotification *)notification {
    [self isOnOpenMenu:NO];
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
        
        // 重置菜单视图
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
    return UIInterfaceOrientationMaskPortrait;
}

@end
