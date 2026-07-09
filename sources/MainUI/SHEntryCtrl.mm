//  SHEntryCtrl.m (TabView HUD Panel, Dark Neon + Kernel Big Button + Expire Badge)
//  SystemHelper
//
//  Created by 特特 on 2025/7/7.
//  Updated by ChatGPT on 2025/8/21 — iCloud (NSUbiquitousKeyValueStore) 持久化 + 竖屏间距优化
//  Updated by ChatGPT on 2025/8/21 — TabView UI（可滑动，横竖屏适配）、“点按钮就执行”本地即时刷新、内核按钮加大加亮、到期拦截与徽章
//

#import "SHEntryCtrl.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "HUDHelper.h"                 // IsHUDEnabled()/SetHUDEnabled()
#import "SHIDCtrl.h"  // 内核选择页
#import "SHMainWnd.h"             // 系统级窗口
#import "SHWindowCtrl.h" // ImGui悬浮窗管理器
#import "主悬浮球ViewController.h"      // 悬浮球+悬浮菜单
#import "SHFloatWnd.h"       // 悬浮球专用窗口
#import "LSApplicationWorkspace.h"
#import "LSApplicationProxy.h"
#import <AVFoundation/AVFoundation.h> // 验证界面音乐
#import "LFCAuthManager.h"

// 日志写入 app.log / 共享日志（由 HUDHelper 提供实现）
extern void LFSNSLog(NSString *format, ...);

@class GuardianMenu;
@class SHEntryCtrl;

static NSString * const kTSLaunchTransitionShowNotification = @"com.afei.HP.launch.transition.show";

// 悬浮球窗口（全局持有，避免被释放）
static SHFloatWnd *gFloatingBallWindow = nil;

static void LFEnsureFloatingBallWindowShown(void) {
    if (gFloatingBallWindow) {
        gFloatingBallWindow.hidden = NO;
        [gFloatingBallWindow makeKeyAndVisible];
        return;
    }

    CGRect screenBounds = [UIScreen mainScreen].bounds;
    gFloatingBallWindow = [[SHFloatWnd alloc] initWithFrame:screenBounds];
    gFloatingBallWindow.windowLevel = UIWindowLevelAlert + 20;
    gFloatingBallWindow.backgroundColor = [UIColor clearColor];

    UIWindow *baseWindow = UIApplication.sharedApplication.keyWindow;
    if (!baseWindow && UIApplication.sharedApplication.windows.count > 0) {
        baseWindow = UIApplication.sharedApplication.windows.firstObject;
    }

    if (@available(iOS 13.0, *)) {
        if ([baseWindow respondsToSelector:@selector(windowScene)] && baseWindow.windowScene) {
            gFloatingBallWindow.windowScene = baseWindow.windowScene;
        } else {
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    gFloatingBallWindow.windowScene = (UIWindowScene *)scene;
                    break;
                }
            }
        }
    }

    主悬浮球ViewController *rootVC = [[主悬浮球ViewController alloc] init];
    gFloatingBallWindow.rootViewController = rootVC;
    [gFloatingBallWindow makeKeyAndVisible];
}

static void LFDismissFloatingBallWindow(void) {
    if (!gFloatingBallWindow) return;
    gFloatingBallWindow.hidden = YES;
    gFloatingBallWindow = nil;
}

#pragma mark - Keys (iCloud KVS)
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Security/Security.h>
#import <dlfcn.h>
#include <sys/syscall.h>
#include <sys/sysctl.h>
#include <sys/wait.h>
#include <spawn.h>
#import "SettingsSheetViewController.h"
#import <sys/stat.h>
#import <sys/utsname.h>
#import <mach/machine.h>

#pragma mark - 主题色（苹果极简风格）
static inline UIColor *LFHex(unsigned rgb, CGFloat a){
    return [UIColor colorWithRed:((rgb>>16)&0xff)/255.0
                           green:((rgb>>8)&0xff)/255.0
                            blue:(rgb&0xff)/255.0 alpha:a];
}
// 深色模式：优雅的深灰渐变（苹果风格）
#define LF_STAR_DEEP1  LFHex(0x000000,1.0)      // 纯黑背景
#define LF_STAR_DEEP2  LFHex(0x1C1C1E,1.0)      // 系统深灰
#define LF_STAR_DEEP3  LFHex(0x2C2C2E,1.0)      // 浅灰
// 渐变带：更柔和的蓝色调
#define LF_STAR_NEBU1  LFHex(0x007AFF,0.25)     // iOS系统蓝，低透明度
#define LF_STAR_NEBU2  LFHex(0x5856D6,0.20)     // iOS紫色，低透明度
// 强调色：iOS系统蓝
#define LF_ACCENT      LFHex(0x007AFF,1.0)      // iOS系统蓝
// 卡片：毛玻璃效果
#define LF_CARD        [[UIColor colorWithWhite:0.1 alpha:1.0] colorWithAlphaComponent:0.7]
#define LF_TEXT        [UIColor colorWithWhite:1.0 alpha:1.0]  // 纯白文字
#define LF_TEXT_SUB    [UIColor colorWithWhite:0.7 alpha:1.0]  // 灰色副文字
#define LF_BORDER      [[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor
#define LF_CORNER      20.0
#define LF_SCI_CYAN    [UIColor colorWithRed:0.2f green:0.75f blue:1.0f alpha:1.0f]
#define LF_SCI_CYAN_DIM [UIColor colorWithRed:0.2f green:0.75f blue:1.0f alpha:0.5f]

#pragma mark - 小工具
static inline UIView *LFMakeSpacer(CGFloat h){ UIView *v=[UIView new]; v.translatesAutoresizingMaskIntoConstraints=NO; [v.heightAnchor constraintEqualToConstant:h].active=YES; return v; }
static inline UILabel *LFMakeLabel(NSString *t, UIFont *f, UIColor *c){ UILabel *l=[UILabel new]; l.translatesAutoresizingMaskIntoConstraints=NO; l.text=t; l.font=f; l.textColor=c; l.numberOfLines=0; return l; }
static inline UIView *LFCardContainer(void){ UIView *c=[UIView new]; c.translatesAutoresizingMaskIntoConstraints=NO; c.backgroundColor=LF_CARD; c.layer.cornerRadius=LF_CORNER; c.layer.borderWidth=1; c.layer.borderColor=LF_BORDER; c.layer.shadowOpacity=0.26; c.layer.shadowRadius=12; c.layer.shadowOffset=(CGSize){0,6}; return c; }
static inline UIButton *LFMakeButton(NSString *title, UIImage *img){ UIButton *b=[UIButton buttonWithType:UIButtonTypeSystem]; b.translatesAutoresizingMaskIntoConstraints=NO; [b setTitle:title forState:UIControlStateNormal]; [b setImage:img forState:UIControlStateNormal]; b.titleLabel.font=[UIFont boldSystemFontOfSize:18]; b.tintColor=LF_TEXT; b.backgroundColor=[LFHex(0x1380A8,1) colorWithAlphaComponent:0.26]; b.layer.cornerRadius=16; b.layer.masksToBounds=YES; b.contentEdgeInsets=(UIEdgeInsets){14,16,14,16}; b.imageEdgeInsets=(UIEdgeInsets){0,-6,0,6}; return b; }
static inline UIVisualEffectView *LFGlassPanel(CGRect frame, CGFloat radius){
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialLight];
    UIVisualEffectView *panel = [[UIVisualEffectView alloc] initWithEffect:effect];
    panel.frame = frame;
    panel.layer.cornerRadius = radius;
    panel.layer.masksToBounds = YES;
    panel.layer.borderWidth = 1.0;
    panel.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.34].CGColor;
    return panel;
}
static inline void LFStyleGlassButton(UIButton *button, UIColor *tint, BOOL filled){
    button.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    button.tintColor = filled ? UIColor.whiteColor : LFHex(0x111827, 0.88);
    button.backgroundColor = filled ? tint : [[UIColor whiteColor] colorWithAlphaComponent:0.22];
    button.layer.cornerRadius = 12.0;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = filled ? 0.0 : 1.0;
    button.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.26].CGColor;
}
static inline UIImage *LFStarDot(CGFloat r, UIColor *c){ CGSize s=(CGSize){r*2+2,r*2+2}; UIGraphicsBeginImageContextWithOptions(s, NO, 0); CGContextRef ctx=UIGraphicsGetCurrentContext(); [c setFill]; CGContextAddEllipseInRect(ctx, CGRectMake(1,1,r*2,r*2)); CGContextFillPath(ctx); UIImage *img=UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext(); return img; }

static inline float LFClamp(float v, float lo, float hi){ return fminf(hi, fmaxf(lo, v)); }
static inline float LFSnap(float v, float minv, float step){
    if (step <= 0) return v;
    return minv + roundf((v - minv) / step) * step;
}

// MobileGestalt 相关函数（提前定义以便在激活函数中使用）
static CFStringRef (*MGCopyAnswerFunc)(CFStringRef) = NULL;
static void *gestaltHandle = NULL;
static void InitializeMobileGestaltIfNeeded(void) {
    if (!gestaltHandle) {
        gestaltHandle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY);
        if (gestaltHandle) {
            MGCopyAnswerFunc = (CFStringRef (*)(CFStringRef))dlsym(gestaltHandle, "MGCopyAnswer");
        }
    }
}
static inline NSString *LFFormatFloat(float v, NSInteger decimals){
    if (decimals <= 0) return [NSString stringWithFormat:@"%.0f", v];
    return [NSString stringWithFormat:[NSString stringWithFormat:@"%%.%ldf",(long)decimals], v];
}

#pragma mark - iCloud 封装（自动兜底）
static BOOL LFHasKVSEntitlement(void){
 
    return YES;
}
static NSUbiquitousKeyValueStore *LFCloudOrNil(void){
    static dispatch_once_t onceToken; static NSUbiquitousKeyValueStore *store; static BOOL ok;
    dispatch_once(&onceToken, ^{ ok = LFHasKVSEntitlement(); if (ok) store = [NSUbiquitousKeyValueStore defaultStore]; });
    return store; // 可能为 nil
}
static inline void LFSync(void){ NSUbiquitousKeyValueStore *kv = LFCloudOrNil(); if (kv) [kv synchronize]; }
static inline id   LFLocalObj(NSString *k){ return [[NSUserDefaults standardUserDefaults] objectForKey:k]; }
static inline BOOL LFGetBool(NSString *k, BOOL def){ NSUbiquitousKeyValueStore *kv = LFCloudOrNil(); if (kv){ id o=[kv objectForKey:k]; if(o) return [kv boolForKey:k]; } id l=LFLocalObj(k); if(l) return [[NSUserDefaults standardUserDefaults] boolForKey:k]; return def; }
static inline double LFGetDouble(NSString *k, double def){ NSUbiquitousKeyValueStore *kv = LFCloudOrNil(); if (kv){ id o=[kv objectForKey:k]; if(o) return [kv doubleForKey:k]; } id l=LFLocalObj(k); if(l) return [[NSUserDefaults standardUserDefaults] doubleForKey:k]; return def; }
static inline void LFSetBool(NSString *k, BOOL v){ if (LFCloudOrNil()){ [[NSUbiquitousKeyValueStore defaultStore] setBool:v forKey:k]; LFSync(); } [[NSUserDefaults standardUserDefaults] setBool:v forKey:k]; }
static inline void LFSetDouble(NSString *k, double v){ if (LFCloudOrNil()){ [[NSUbiquitousKeyValueStore defaultStore] setDouble:v forKey:k]; LFSync(); } [[NSUserDefaults standardUserDefaults] setDouble:v forKey:k]; }
static inline NSInteger LFGetInt(NSString *k, NSInteger def){
    NSUbiquitousKeyValueStore *kv = LFCloudOrNil();
    if (kv){ id o=[kv objectForKey:k]; if (o) return (NSInteger)[kv longLongForKey:k]; }
    id l = LFLocalObj(k); if (l) return [[NSUserDefaults standardUserDefaults] integerForKey:k];
    return def;
}
static inline void LFSetInt(NSString *k, NSInteger v){
    if (LFCloudOrNil()){ [[NSUbiquitousKeyValueStore defaultStore] setLongLong:v forKey:k]; LFSync(); }
    [[NSUserDefaults standardUserDefaults] setInteger:v forKey:k];
}
#pragma mark - 通用 Key（你也可以随时新增）
//绘制
static NSString *const 直播      = @"直播";
static NSString *const 血量      = @"显示血量";
static NSString *const 射线      = @"显示射线";
static NSString *const 信息       = @"显示信息";
static NSString *const 手持  = @"显示手持";
static NSString *const 距离       = @"显示距离";
static NSString *const 背敌      = @"显示背敌";
static NSString *const 背后射线      = @"背后射线";
static NSString *const 骨骼      = @"显示骨骼";
static NSString *const 人机      = @"地铁BOOS";
static NSString *const 方框      = @"显示方框";
static NSString *const 掩体判断  = @"掩体判断";
static NSString *const 人数      = @"显示人数";
static NSString *const 人机隐藏      = @"人机隐藏";



static NSString *const 地铁物资 = @"地铁物资";
static NSString *const 地铁盒子 =@"地铁盒子";
static NSString *const 盒内物资 = @"盒内物资";
static NSString *const 瞄具 = @"显示瞄具";
static NSString *const 防具 = @"显示防具";
static NSString *const 药品 = @"显示药品";
static NSString *const 盒子 = @"显示盒子";
static NSString *const 空投 = @"显示空投";
static NSString *const 载具 = @"显示载具";
static NSString *const 预警 = @"手雷预警";
static NSString *const 武器 = @"显示武器";
static NSString *const 子弹 = @"显示子弹";
static NSString *const 配件 = @"显示配件";
static NSString *const 投掷物 =@"显示投掷";


//FPS
static NSString *const kLF_FpsX      = @"lf.tune.fpsx";    // double
static NSString *const kLF_FpsY      = @"lf.tune.fpsy";    // double
//自瞄
static NSString *const 自瞄 = @"开启自瞄";
static NSString *const 自瞄连线 = @"自瞄连线";
static NSString *const 自瞄速度    = @"自瞄速度";      // double
static NSString *const 自瞄距离  = @"自瞄距离";    // double
static NSString *const 自瞄大小  = @"自瞄大小";    // double
static NSString *const 倒地自瞄  = @"倒地不瞄";    // double
static NSString *const 压枪力度  = @"压枪力度";    // double
static NSString *const 腰射距离  = @"腰射距离";    // double

//选择器
static NSString *const 自瞄圆圈模式 = @"自瞄圆圈模式";
static NSString *const 打击位置  = @"打击位置";  // 0=最近, 1=头部, 2=胸部

// 开发者功能占位 Key
static NSString *const 地调试日志   = @"地调试日志";
static NSString *const 链接deepseek = @"链接deepseek";
static NSString *const 开发中       = @"开发中";
// 兼容"调试日志"写法，指向同一键值
static NSString *const 调试日志     = @"地调试日志";
// ImGui悬浮窗开关
static NSString *const ImGui悬浮窗  = @"ImGui悬浮窗";

// GuardianMenu 内部：调试日志总开关（是否写入 app.log / 共享日志）
static NSString *const 调试日志开关 = @"lf.debuglog.enabled";


// 协议版本：每次改协议只需改这里，旧用户会重新弹窗
static inline NSString *LFTermsRevision(void) { return @"2025.09.02-5"; }

// 记录“已同意”的 key
static NSString *const kLF_TermsAcceptedVersion = @"lf.terms.accepted.version";

// 通用字符串读写（优先 iCloud KVS，兜底 UserDefaults）
static inline NSString *LFGetString(NSString *k, NSString *def){
    NSUbiquitousKeyValueStore *kv = LFCloudOrNil();
    if (kv){
        id o = [kv objectForKey:k];
        if ([o isKindOfClass:[NSString class]]) return (NSString *)o;
    }
    NSString *l = [[NSUserDefaults standardUserDefaults] stringForKey:k];
    return l ?: def;
}
static inline void LFSetString(NSString *k, NSString *v){
    if (!v) return;
    NSUbiquitousKeyValueStore *kv = LFCloudOrNil();
    if (kv){ [kv setString:v forKey:k]; LFSync(); }
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:k];
}

/// YES = 同一 Apple ID 下所有设备只同意一次；NO = 仅本机记录
#define LF_TERMS_CROSS_DEVICE  YES
#pragma mark - 折叠卡片（只动画内部，外部不跟随）
@interface LFAccordionCard : UIView
@property(nonatomic,strong) UIButton *headerBtn;
@property(nonatomic,strong) UILabel  *titleLab;
@property(nonatomic,strong) UIImageView *chev;
@property(nonatomic,strong) UIView *contentWrap;
@property(nonatomic,strong) UIStackView *contentStack;
@property(nonatomic,strong) NSLayoutConstraint *contentH;   // 0~内容高度
@property(nonatomic,assign) BOOL expanded;
@end

// === GuardianMenu：悬浮菜单（全局显示版本） ===
// 源码来自 /Users/niuyue/Desktop/GuardianMenu_悬浮菜单源码.mm，已修改：
// 1）增加左上角最小化按钮
// 2）最小化为左侧小圆形悬浮按钮，可再次点击恢复
// 3）配合 SHEntryCtrl 的 onToggleHUD: 一起显示/隐藏
// 4）修改为全局显示：使用 SHMainWnd 系统级窗口
// 5）新增：查找系统级窗口的辅助方法

// 功能状态存储
struct GuardianFeatures {
    // 绘制类
    bool bone        = true;   // 骨骼
    bool box         = false;  // 方框
    bool line        = true;   // 射线
    bool health      = true;   // 血条
    bool distance    = true;   // 距离
    bool name        = true;   // 名字
    
    // 自瞄类
    bool silentAim   = true;   // 静默自瞄
    bool noRecoil    = false;  // 内存防抖
    int  aimPos      = 0;      // 0: 头, 1: 胸, 2: 随机
    float fovSize    = 100.0f; // 自瞄范围
    
    // 物资类
    bool lootGuns    = true;   // 高级枪械
    bool lootArmor   = true;   // 防具等级
    bool lootItems   = true;   // 消耗品
    bool lootSpecial = true;   // 特殊物资
    
    const char* udid   = "8E1D-XXXX-XXXX-9A2C";
    const char* expire = "2026-02-15 05:03";
};
static GuardianFeatures g_feat;

@interface GuardianMenu : UIView
+ (instancetype)sharedInstance;
- (void)showInWindow:(UIWindow *)window;
- (void)hide;
// 新增：系统级窗口显示
- (void)showInSystemWindow;
+ (UIWindow *)findSystemWindow;
@end

#pragma mark - 验证界面（卡密 + TG/QQ + 音乐）

static NSString * const kLFVerifiedFlagKey = @"LFVerifiedFlag";
static NSString * const kLFLastCodeKey     = @"LFLastCode";
static NSString * const kLFLastRoleKey     = @"LFLastRole";

// 检查当前用户是否为作者
static BOOL LFIsAuthor(void) {
    NSString *role = [[NSUserDefaults standardUserDefaults] stringForKey:kLFLastRoleKey];
    return [role isEqualToString:@"author"];
}

@interface LFVerifyView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *codeField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *tgButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *musicToggle;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation LFVerifyView

// 从底层绘制模块获取“自己在游戏里的角色名”
extern "C" const char* TEGetLocalPlayerName(void);

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = LFHex(0xEEF2F5, 1.0);
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);

    CAGradientLayer *bg = [CAGradientLayer layer];
    bg.frame = self.bounds;
    bg.colors = @[
        (id)LFHex(0xF7FAFC, 1.0).CGColor,
        (id)LFHex(0xE9F2F6, 1.0).CGColor,
        (id)LFHex(0xF8FBFD, 1.0).CGColor
    ];
    bg.startPoint = CGPointMake(0.0, 0.0);
    bg.endPoint = CGPointMake(1.0, 1.0);
    [self.layer addSublayer:bg];

    CGFloat cardW = MIN(w - 42.0, 430.0);
    CGFloat cardH = MIN(h - 120.0, 480.0);
    CGFloat cardX = (w - cardW) * 0.5;
    CGFloat cardY = (h - cardH) * 0.5;
    UIVisualEffectView *card = LFGlassPanel(CGRectMake(cardX, cardY, cardW, cardH), 18.0);
    card.layer.shadowColor = UIColor.blackColor.CGColor;
    card.layer.shadowOpacity = 0.10;
    card.layer.shadowRadius = 28.0;
    card.layer.shadowOffset = CGSizeMake(0, 12);
    [self addSubview:card];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 22.0, cardW - 48.0, 34.0)];
    title.text = @"Troll Engine";
    title.textColor = LFHex(0x0B1220, 0.92);
    title.font = [UIFont systemFontOfSize:28 weight:UIFontWeightSemibold];
    title.textAlignment = NSTextAlignmentCenter;
    [card.contentView addSubview:title];

    UILabel *sub = [[UILabel alloc] initWithFrame:CGRectMake(24.0, 58.0, cardW - 48.0, 22.0)];
    sub.text = @"登录后进入控制台";
    sub.textColor = LFHex(0x334155, 0.64);
    sub.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    sub.textAlignment = NSTextAlignmentCenter;
    [card.contentView addSubview:sub];

    UIImage *logoImg = [UIImage imageNamed:@"图三"] ?: [UIImage imageNamed:@"图三.png"];
    if (logoImg) {
        CGFloat logoSize = 92.0;
        UIImageView *logo = [[UIImageView alloc] initWithImage:logoImg];
        logo.frame = CGRectMake((cardW - logoSize) * 0.5, 98.0, logoSize, logoSize);
        logo.contentMode = UIViewContentModeScaleAspectFill;
        logo.layer.cornerRadius = logoSize / 2.0;
        logo.layer.masksToBounds = YES;
        logo.layer.borderWidth = 1.0;
        logo.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.55].CGColor;
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        spin.fromValue = @(0);
        spin.toValue = @(M_PI * 2.0);
        spin.duration = 60.0;
        spin.repeatCount = HUGE_VALF;
        spin.removedOnCompletion = NO;
        [logo.layer addAnimation:spin forKey:@"slowSpin"];
        [card.contentView addSubview:logo];
    }

    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(28.0, 214.0, cardW - 56.0, 48.0)];
    field.placeholder = @"请输入授权卡密";
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeDefault;
    field.returnKeyType = UIReturnKeyDone;
    field.borderStyle = UITextBorderStyleNone;
    field.textAlignment = NSTextAlignmentCenter;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.42];
    field.layer.cornerRadius = 12.0;
    field.layer.masksToBounds = YES;
    field.layer.borderWidth = 1.0;
    field.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.38].CGColor;
    field.textColor = LFHex(0x111827, 0.92);
    field.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.codeField = field;
    NSString *lastCode = [[NSUserDefaults standardUserDefaults] stringForKey:kLFLastCodeKey];
    if (lastCode.length > 0) field.text = lastCode;
    field.secureTextEntry = YES;
    [card.contentView addSubview:field];

    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    confirm.frame = CGRectMake(28.0, 278.0, cardW - 56.0, 48.0);
    [confirm setTitle:@"进入控制台" forState:UIControlStateNormal];
    LFStyleGlassButton(confirm, LFHex(0x1E88E5, 1.0), YES);
    [confirm addTarget:self action:@selector(onConfirmTap) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton = confirm;
    [card.contentView addSubview:confirm];

    UIButton *tg = [UIButton buttonWithType:UIButtonTypeSystem];
    tg.frame = CGRectMake(28.0, 346.0, (cardW - 64.0) * 0.5, 38.0);
    [tg setTitle:@"TG频道" forState:UIControlStateNormal];
    LFStyleGlassButton(tg, LFHex(0x1E88E5, 1.0), NO);
    [tg addTarget:self action:@selector(onTGTap) forControlEvents:UIControlEventTouchUpInside];
    self.tgButton = tg;
    [card.contentView addSubview:tg];

    UIButton *qq = [UIButton buttonWithType:UIButtonTypeSystem];
    qq.frame = CGRectMake(CGRectGetMaxX(tg.frame) + 8.0, 346.0, (cardW - 64.0) * 0.5, 38.0);
    [qq setTitle:@"QQ群" forState:UIControlStateNormal];
    LFStyleGlassButton(qq, LFHex(0x1E88E5, 1.0), NO);
    [qq addTarget:self action:@selector(onQQTap) forControlEvents:UIControlEventTouchUpInside];
    self.qqButton = qq;
    [card.contentView addSubview:qq];

    CGFloat toggleW = 56.0, toggleH = 28.0;
    CGFloat toggleX = (cardW - toggleW) * 0.5;
    CGFloat toggleY = cardH - toggleH - 22.0;
    UIButton *music = [UIButton buttonWithType:UIButtonTypeCustom];
    music.frame = CGRectMake(toggleX, toggleY, toggleW, toggleH);
    music.layer.cornerRadius = toggleH / 2.0;
    music.layer.masksToBounds = YES;
    music.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    music.tag = 0; // 0 = off, 1 = on

    UIView *knob = [[UIView alloc] initWithFrame:CGRectMake(2.0, 2.0, toggleH - 4.0, toggleH - 4.0)];
    knob.backgroundColor = [UIColor whiteColor];
    knob.layer.cornerRadius = (toggleH - 4.0) / 2.0;
    knob.userInteractionEnabled = NO;
    knob.tag = 1001;
    [music addSubview:knob];

    [music addTarget:self action:@selector(onMusicToggle:) forControlEvents:UIControlEventTouchUpInside];
    self.musicToggle = music;
    [card.contentView addSubview:music];

    [self startMusicIfNeeded:YES];
    [self updateMusicToggleAppearance:YES];
}

#pragma mark - 音乐控制

- (void)startMusicIfNeeded:(BOOL)forceOn {
    if (!forceOn) return;
    if (self.player && self.player.playing) return;

    // 兼容多种资源命名方式，确保能正确找到 mp3
    NSString *path = [[NSBundle mainBundle] pathForResource:@"验证界面音乐" ofType:@"mp3"];
    if (!path) {
        // 有些工程可能带扩展名写在资源名里
        path = [[NSBundle mainBundle] pathForResource:@"验证界面音乐.mp3" ofType:nil];
    }
    if (!path) return;

    // 确保音频会话处于可播放状态
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionErr = nil;
    [session setCategory:AVAudioSessionCategoryAmbient
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:&sessionErr];
    [session setActive:YES error:&sessionErr];

    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *err = nil;
    AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if (err || !p) return;

    self.player = p;
    self.player.numberOfLoops = -1;
    [self.player prepareToPlay];
    [self.player play];
}

- (void)stopMusic {
    [self.player stop];
    self.player = nil;
}

- (void)updateMusicToggleAppearance:(BOOL)on {
    self.musicToggle.tag = on ? 1 : 0;
    UIView *knob = [self.musicToggle viewWithTag:1001];
    CGFloat toggleH = self.musicToggle.bounds.size.height;
    [UIView animateWithDuration:0.20 animations:^{
        self.musicToggle.backgroundColor = on
            ? [UIColor colorWithRed:0.95 green:0.25 blue:0.35 alpha:1.0]
            : [UIColor colorWithWhite:0.25 alpha:1.0];
        if (knob) {
            if (on) {
                knob.frame = CGRectMake(self.musicToggle.bounds.size.width - toggleH + 2.0,
                                        2.0,
                                        toggleH - 4.0,
                                        toggleH - 4.0);
            } else {
                knob.frame = CGRectMake(2.0, 2.0, toggleH - 4.0, toggleH - 4.0);
            }
        }
    }];
}

- (void)onMusicToggle:(UIButton *)sender {
    BOOL on = (sender.tag == 0); // 之前关 -> 开
    [self updateMusicToggleAppearance:on];
    if (on) {
        [self startMusicIfNeeded:YES];
    } else {
        [self stopMusic];
    }
}

#pragma mark - 按钮动作

- (void)onTGTap {
    NSURL *url = [NSURL URLWithString:@"https://t.me/ songshu1221"];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)onQQTap {
    NSString *qqURL = @"https://qun.qq.com/universal-share/share?ac=1&authKey=QHkIuLcOpqqeM%2BYplZi63VrqVONEpwBQP7Jy8N4K99LjzXzQvQ%2BJ8VdB5LXxDRbk&busi_data=eyJncm91cENvZGUiOiIzNzM1NjMzOTgiLCJ0b2tlbiI6IjJ0aGlTMnErTUpMNnI2VnZYRmNyWGJaU01pMi9KV0NzaWJaMEgvWWdCTDJrMFJWYVE3cStLeVM4RVJRdlpMa0UiLCJ1aW4iOiIyMDk4NTU0NDI5In0%3D&data=rAYU5yTT__Bqzzpx4Mth5XkfTc0EkGc02ED6VxiwJAu4cAN9VwAgwvbpKaf9LNDj0w57sGZKaCKgMLYPYLYRKg&svctype=4&tempid=h5_group_info";
    NSURL *url = [NSURL URLWithString:qqURL];
    if (!url) return;
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)onConfirmTap {
    NSString *code = [self.codeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (code.length == 0) {
        [self shakeView:self.codeField];
        return;
    }

    self.confirmButton.enabled = NO;

    [[LFCAuthManager sharedManager] activateWithCardKey:code completion:^(LFCLicenseResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.confirmButton.enabled = YES;
            if (!result.authorized) {
                LFSNSLog(@"[Verify] 授权失败: %@", result.message);
                [self shakeView:self.codeField];
                [self showSimpleAlert:@"验证失败" message:result.message ?: @"授权失效"];
                return;
            }

            NSString *role = result.role ?: @"user";
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLFVerifiedFlagKey];
            [[NSUserDefaults standardUserDefaults] setObject:code forKey:kLFLastCodeKey];
            [[NSUserDefaults standardUserDefaults] setObject:role forKey:kLFLastRoleKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            if (result.expiresAt) {
                NSDateFormatter *formatter = [NSDateFormatter new];
                formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm";
                LFExpireWriteText([formatter stringFromDate:result.expiresAt]);
            } else {
                LFExpireWriteText(@"永久授权");
            }

            LFSNSLog(@"[Verify] 授权通过, role=%@, offline=%@", role, result.offline ? @"YES" : @"NO");
            [self stopMusic];
            [UIView animateWithDuration:0.25 animations:^{
                self.alpha = 0.0;
                self.transform = CGAffineTransformMakeScale(0.92, 0.92);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }];
}

- (void)showSimpleAlert:(NSString *)title message:(NSString *)msg {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title
                                                                message:msg
                                                         preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    UIWindow *win = UIApplication.sharedApplication.keyWindow;
    [win.rootViewController presentViewController:ac animated:YES completion:nil];
}

- (void)shakeView:(UIView *)v {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.values = @[ @0, @-8, @8, @-6, @6, @-3, @3, @0 ];
    shake.duration = 0.25;
    [v.layer addAnimation:shake forKey:@"shake"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self onConfirmTap];
    return YES;
}

// 聚焦时暂时显示真实内容，方便用户检查输入
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.codeField) {
        textField.secureTextEntry = NO;
    }
}

// 失焦时重新隐藏内容：仅在用户点进输入框时可见
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.codeField) {
        textField.secureTextEntry = YES;
    }
}

@end

@interface GuardianMenu () {
    UIView       *_sidebar;
    UIScrollView *_contentArea;
    BOOL _drawExpanded;
    BOOL _aimExpanded;
    BOOL _lootExpanded;
    BOOL _devExpanded;
    
    // 新增：最小化/还原
    UIButton *_minimizeButton;
    UIButton *_floatingButton;
    UILabel  *_idLabel;
    
    // 左下角主功能按钮
    UIButton *_kernelButton;   // 自瞄标识符
    UIButton *_hudButton;      // 加载绘制

    // 侧边栏图片
    UIImageView *_avatarView;  // 图二（左下角头像）
}
@end

@implementation GuardianMenu

// 前向声明SHWindowCtrl（在GuardianMenu中使用）
@class SHWindowCtrl;

// 关联对象 key（用于子项开关）
static char kGF_FlagKey;

+ (instancetype)sharedInstance {
    static GuardianMenu *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 全屏菜单：以屏幕大小作为初始 frame
        CGRect screen = UIScreen.mainScreen.bounds;
        instance = [[self alloc] initWithFrame:screen];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = YES;

    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];

    UIBlurEffect *blurEffect;
    if (@available(iOS 13.0, *)) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight];
    } else {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    UIVisualEffectView *backdrop = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    backdrop.frame = self.bounds;
    backdrop.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:backdrop];

    CGFloat sidebarWidth = 160.0;
    _sidebar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sidebarWidth, CGRectGetHeight(self.bounds))];
    _sidebar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
    _sidebar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _sidebar.layer.borderWidth = 1.0;
    _sidebar.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;
    [self addSubview:_sidebar];

    UIView *sidebarEdge = [[UIView alloc] initWithFrame:CGRectMake(sidebarWidth - 1, 0, 1, CGRectGetHeight(self.bounds))];
    sidebarEdge.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    sidebarEdge.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [_sidebar addSubview:sidebarEdge];

    // 右侧内容区域
    _contentArea = [[UIScrollView alloc] initWithFrame:CGRectMake(sidebarWidth, 0, CGRectGetWidth(self.bounds)-sidebarWidth, CGRectGetHeight(self.bounds))];
    _contentArea.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentArea.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.08];
    _contentArea.showsHorizontalScrollIndicator = NO;
    [self addSubview:_contentArea];
    
    // 默认展开绘制功能，其他收起
    _drawExpanded = YES;
    _aimExpanded  = NO;
    _lootExpanded = NO;
    _devExpanded  = NO;
    
    // 根据持久化开关初始化调试日志输出状态
    LFSetDebugLogEnabled(LFGetBool(调试日志开关, YES));

    [self rebuildContent];
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(sidebarWidth + 24, CGRectGetHeight(self.bounds)-26, CGRectGetWidth(self.bounds) - sidebarWidth - 40, 18)];
    NSString *realID = [UIDevice currentDevice].identifierForVendor.UUIDString ?: @"UNKNOWN";
    _idLabel.text = [NSString stringWithFormat:@"ID: %@", realID];
    _idLabel.font = [UIFont monospacedSystemFontOfSize:10 weight:UIFontWeightRegular];
    _idLabel.textColor = [UIColor colorWithWhite:0.15 alpha:0.75];
    [self addSubview:_idLabel];

    void (^styleSideButton)(UIButton *, UIColor *) = ^(UIButton *button, UIColor *textColor) {
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
        button.tintColor = textColor;
        button.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.32];
        button.layer.cornerRadius = 10.0;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;
    };

    CGFloat padding = 8.0;
    CGFloat btnWidth = 150.0;
    CGFloat btnHeight = 40.0;
    CGFloat bottomY = CGRectGetHeight(self.bounds) - padding - btnHeight;

    _hudButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _hudButton.frame = CGRectMake(padding, bottomY, btnWidth, btnHeight);
    [_hudButton setTitle:@"加载绘制" forState:UIControlStateNormal];
    styleSideButton(_hudButton, accentColor);
    [_hudButton addTarget:self action:@selector(onHudButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_hudButton];

    _kernelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _kernelButton.frame = CGRectMake(padding, bottomY - btnHeight - 10.0, btnWidth, btnHeight);
    [_kernelButton setTitle:@"自瞄标识符" forState:UIControlStateNormal];
    styleSideButton(_kernelButton, [UIColor colorWithWhite:0.12 alpha:0.95]);
    [_kernelButton addTarget:self action:@selector(onKernelButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_kernelButton];

    _floatingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _floatingButton.frame = CGRectMake(padding,
                                       CGRectGetMinY(_kernelButton.frame) - btnHeight - 10.0,
                                       btnWidth,
                                       btnHeight);
    [_floatingButton setTitle:@"悬浮菜单" forState:UIControlStateNormal];
    styleSideButton(_floatingButton, accentColor);
    [_floatingButton addTarget:self action:@selector(onFloatingMenuButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_floatingButton];

    // 侧边栏头像（图二）：放在左下角按钮上方的大空白区域
    UIImage *avatarImg = [UIImage imageNamed:@"图二"];
    if (!avatarImg) {
        avatarImg = [UIImage imageNamed:@"图二.JPG"];
    }
    if (avatarImg) {
        // 放大 1.5 倍
        CGFloat avatarSize = 135.0;
        CGFloat avatarX = (sidebarWidth - avatarSize) * 0.5;
        // 调整：头像放在“悬浮菜单”按钮上方
        CGFloat avatarY = CGRectGetMinY(_floatingButton.frame) - avatarSize - 18.0;
        _avatarView = [[UIImageView alloc] initWithImage:avatarImg];
        _avatarView.frame = CGRectMake(avatarX, avatarY, avatarSize, avatarSize);
        _avatarView.layer.cornerRadius = avatarSize / 2.0;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.borderWidth = 2.0;
        _avatarView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.75].CGColor;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [_sidebar addSubview:_avatarView];

        // 缓慢 360° 自转
        CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        spin.fromValue = @(0);
        spin.toValue = @(M_PI * 2.0);
        spin.duration = 30.0;              // 完整一圈 30 秒，比较缓慢
        spin.repeatCount = HUGE_VALF;      // 无限循环
        spin.removedOnCompletion = NO;
        spin.fillMode = kCAFillModeForwards;
        [_avatarView.layer addAnimation:spin forKey:@"slowSpin"];
    }
}

#pragma mark - 内容构建

- (void)rebuildContent {
    // 清空旧内容
    for (UIView *v in _contentArea.subviews) {
        [v removeFromSuperview];
    }
    
    CGFloat y = 24.0;

    y = [self addSection:@"绘制功能" atY:y expanded:_drawExpanded section:0];
    y += 12.0;
    y = [self addSection:@"自瞄功能" atY:y expanded:_aimExpanded section:1];
    y += 12.0;
    y = [self addSection:@"物资透视" atY:y expanded:_lootExpanded section:2];
    y += 12.0;
    // 只有作者才显示开发者选项
    if (LFIsAuthor()) {
        y = [self addSection:@"开发者" atY:y expanded:_devExpanded section:3];
    }
    
    _contentArea.contentSize = CGSizeMake(CGRectGetWidth(_contentArea.bounds), y + 40.0);
}

#pragma mark - 与主界面联动的按钮

// 新增：“悬浮菜单”按钮点击，创建 / 关闭悬浮球窗口
- (void)onFloatingMenuButtonTap {
    // 如果已经存在，则关闭并释放
    if (gFloatingBallWindow) {
        LFDismissFloatingBallWindow();
        return;
    }

    LFEnsureFloatingBallWindowShown();
}

// 左下角“自瞄标识符”按钮：复用 SHEntryCtrl 的 showSettings:
- (void)onKernelButtonTap {
    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    if (!keyWindow) return;

    UIViewController *vc = keyWindow.rootViewController;
    // 找到当前最上层的 VC
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).topViewController;
    }
    if ([vc isKindOfClass:[SHEntryCtrl class]]) {
        SHEntryCtrl *main = (SHEntryCtrl *)vc;
        if ([main respondsToSelector:@selector(showSettings:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [main performSelector:@selector(showSettings:) withObject:_kernelButton];
#pragma clang diagnostic pop
        }
    }
}

// 左下角“加载绘制”按钮：复用 SHEntryCtrl 的 onToggleHUD:
- (void)onHudButtonTap {
    LFSNSLog(@"[GuardianMenu] HUD button tapped, will forward to SHEntryCtrl.onToggleHUD:");

    UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow;
    if (!keyWindow) return;

    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        vc = ((UINavigationController *)vc).topViewController;
    }
    if ([vc isKindOfClass:[SHEntryCtrl class]]) {
        SHEntryCtrl *main = (SHEntryCtrl *)vc;
        if ([main respondsToSelector:@selector(onToggleHUD:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [main performSelector:@selector(onToggleHUD:) withObject:_hudButton];
#pragma clang diagnostic pop
        }
    }
}

- (CGFloat)addSection:(NSString *)title atY:(CGFloat)y expanded:(BOOL)expanded section:(NSInteger)section {
    // 大菜单行：> / V + 标题（较大字体），整体靠左（与原主界面风格一致）
    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];
    CGFloat leftMargin = 32.0;
    CGFloat sectionWidth = CGRectGetWidth(_contentArea.bounds) - leftMargin * 2;
    CGFloat startX = leftMargin;

    UILabel *arrow = [[UILabel alloc] initWithFrame:CGRectMake(startX, y, 20, 20)];
    arrow.text = expanded ? @"∨" : @">";
    arrow.textColor = accentColor;
    arrow.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [_contentArea addSubview:arrow];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(startX + 25, y, 200, 20)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.08 alpha:0.95];
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [_contentArea addSubview:label];
    
    // 点击整行切换展开状态
    UIButton *tap = [UIButton buttonWithType:UIButtonTypeCustom];
    tap.frame = CGRectMake(startX - 10, y, sectionWidth + 20, 24);
    tap.backgroundColor = [UIColor clearColor];
    tap.tag = 100 + section;
    [tap addTarget:self action:@selector(onSectionTap:) forControlEvents:UIControlEventTouchUpInside];
    [_contentArea addSubview:tap];
    
    // 大标题与第一个小项的间距（避免“贴在一起”）
    y += 18.0;
    
    if (expanded) {
        // 小菜单（真正的功能项），对接原主界面的配置存储
        if (section == 0) {
            // 绘制功能（对应原“绘制功能”折叠里的所有开关）
            y = [self addSwitchRow:@"直播功能"   key:直播     def:YES  atY:y];
            y = [self addSwitchRow:@"开启血量"   key:血量     def:NO   atY:y];
            y = [self addSwitchRow:@"开启方框"   key:方框     def:NO   atY:y];
            y = [self addSwitchRow:@"开启人数"   key:人数     def:NO   atY:y];
            y = [self addSwitchRow:@"开启射线"   key:射线     def:NO   atY:y];
            y = [self addSwitchRow:@"开启骨骼"   key:骨骼     def:NO   atY:y];
            y = [self addSwitchRow:@"开启信息"   key:信息     def:NO   atY:y];
            y = [self addSwitchRow:@"开启手持"   key:手持     def:NO   atY:y];
            y = [self addSwitchRow:@"开启距离"   key:距离     def:NO   atY:y];
            y = [self addSwitchRow:@"开启背敌"   key:背敌     def:NO   atY:y];
            y = [self addSwitchRow:@"背后射线"   key:背后射线 def:NO   atY:y];
            y = [self addSwitchRow:@"人机隐藏"   key:人机隐藏 def:NO   atY:y];
            y = [self addSwitchRow:@"地铁人机"   key:人机     def:NO   atY:y];
        } else if (section == 1) {
            // 自瞄功能（对应原“自瞄功能”折叠）
            y = [self addSwitchRow:@"自瞄开关"   key:自瞄     def:NO   atY:y];
            y = [self addSwitchRow:@"自瞄连线"   key:自瞄连线 def:NO   atY:y];
            y = [self addSwitchRow:@"倒地自瞄"   key:倒地自瞄 def:NO   atY:y];

            y = [self addSegmentRow:@"自瞄位置"
                                  key:打击位置
                                items:@[@"头部", @"胸部", @"腰部"]
                            defaultIdx:0
                                   atY:y];

            y = [self addSegmentRow:@"自瞄圆圈"
                                  key:自瞄圆圈模式
                                items:@[@"动态", @"静态", @"关闭"]
                            defaultIdx:0
                                   atY:y];

            y = [self addSliderRow:@"自瞄大小" key:自瞄大小   min:10 max:250 def:60 atY:y];
            y = [self addSliderRow:@"自瞄速度(数值越小速度越快)" key:自瞄速度   min:20 max:100 def:26 atY:y];
            y = [self addSliderRow:@"压枪力度" key:压枪力度   min:0.0f max:2.0f def:0.9f atY:y];
            y = [self addSliderRow:@"自瞄距离" key:自瞄距离   min:0 max:200 def:100 atY:y];
            y = [self addSliderRow:@"腰射距离" key:腰射距离   min:0 max:50  def:60 atY:y];
        } else if (section == 2) {
            // 物资透视（对应原“物资功能”折叠）
            y = [self addSwitchRow:@"地铁物资"   key:地铁物资 def:NO atY:y];
            y = [self addSwitchRow:@"地铁盒子"   key:地铁盒子 def:NO atY:y];
            y = [self addSwitchRow:@"盒内物资"   key:盒内物资 def:NO atY:y];
            y = [self addSwitchRow:@"显示瞄具"   key:瞄具   def:NO atY:y];
            y = [self addSwitchRow:@"显示防具"   key:防具   def:NO atY:y];
            y = [self addSwitchRow:@"显示药品"   key:药品   def:NO atY:y];
            y = [self addSwitchRow:@"显示盒子"   key:盒子   def:NO atY:y];
            y = [self addSwitchRow:@"显示空投"   key:空投   def:NO atY:y];
            y = [self addSwitchRow:@"显示载具"   key:载具   def:NO atY:y];
            y = [self addSwitchRow:@"手雷预警"   key:预警   def:NO atY:y];
            y = [self addSwitchRow:@"显示武器"   key:武器   def:NO atY:y];
            y = [self addSwitchRow:@"显示子弹"   key:子弹   def:NO atY:y];
            y = [self addSwitchRow:@"显示配件"   key:配件   def:NO atY:y];
            y = [self addSwitchRow:@"显示投掷"   key:投掷物 def:NO atY:y];
        } else if (section == 3 && LFIsAuthor()) {  // 只有作者才能看到开发者选项内容
            // 开发者：ImGui悬浮窗开关 + 调试日志开关 + 日志窗口 + 复制按钮
            // [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究
            /*
            y = [self addSwitchRow:@"ImGui悬浮窗"
                                 key:ImGui悬浮窗
                                 def:NO
                                 atY:y];
            */
            
            y = [self addSwitchRow:@"启用调试日志（写入 app.log / 共享日志）"
                                 key:调试日志开关
                                 def:YES
                                 atY:y];

            // 日志窗口
            CGFloat contentW = CGRectGetWidth(_contentArea.bounds);
            CGFloat boxX = 56.0;
            CGFloat boxW = contentW - boxX - 60.0;
            CGFloat boxH = 160.0;
            CGFloat boxY = y + 4.0;

            UITextView *logView = [[UITextView alloc] initWithFrame:CGRectMake(boxX, boxY, boxW, boxH)];
            logView.editable = NO;
            logView.backgroundColor = [UIColor colorWithWhite:0.10 alpha:1.0];
            logView.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
            logView.font = [UIFont systemFontOfSize:11];
            logView.layer.cornerRadius = 8.0;
            logView.layer.masksToBounds = YES;
            logView.text = LFReadAppLogSnippet(16 * 1024); // 读取末尾 16KB 日志
            [_contentArea addSubview:logView];

            // 复制日志按钮
            UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            copyBtn.frame = CGRectMake(boxX,
                                       CGRectGetMaxY(logView.frame) + 8.0,
                                       96.0,
                                       30.0);
            [copyBtn setTitle:@"复制日志" forState:UIControlStateNormal];
            copyBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
            copyBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.40 blue:0.90 alpha:1.0];
            [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            copyBtn.layer.cornerRadius = 6.0;
            copyBtn.layer.masksToBounds = YES;
            [copyBtn addTarget:self action:@selector(onCopyLogTap:) forControlEvents:UIControlEventTouchUpInside];
            [_contentArea addSubview:copyBtn];

            // QQ群和频道信息（低调显示）
            y = CGRectGetMaxY(copyBtn.frame) + 12.0;
            
            // QQ群
            UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxX, y, boxW, 16.0)];
            qqLabel.text = @"q群:373563398";
            qqLabel.textColor = [UIColor colorWithWhite:0.6 alpha:0.9];
            qqLabel.font = [UIFont systemFontOfSize:11];
            qqLabel.textAlignment = NSTextAlignmentCenter;
            [_contentArea addSubview:qqLabel];
            
            // 频道
            y = CGRectGetMaxY(qqLabel.frame) + 4.0;
            UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxX, y, boxW, 16.0)];
            channelLabel.text = @"频道songshu1221";
            channelLabel.textColor = [UIColor colorWithWhite:0.6 alpha:0.9];
            channelLabel.font = [UIFont systemFontOfSize:11];
            channelLabel.textAlignment = NSTextAlignmentCenter;
            [_contentArea addSubview:channelLabel];

            y = CGRectGetMaxY(channelLabel.frame) + 16.0;
        }
    }
    
    return y;
}

- (void)onCopyLogTap:(UIButton *)sender {
    NSString *text = LFReadAppLogSnippet(64 * 1024);
    if (text.length == 0) return;
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = text;
}

- (CGFloat)addSwitchRow:(NSString *)title key:(NSString *)key def:(BOOL)def atY:(CGFloat)y {
    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];
    BOOL on = LFGetBool(key, def);

    CGFloat contentW = CGRectGetWidth(_contentArea.bounds);
    CGFloat labelX = 56.0;
    CGFloat labelW = 240.0;
    // 右侧控件整体往左挪到“画圈”的空白区域：控制列起始位置
    CGFloat controlX = fmin(360.0, contentW * 0.45);
    CGFloat controlW = fmin(520.0, contentW - controlX - 60.0);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, y, labelW, 18)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    label.font = [UIFont systemFontOfSize:12];
    [_contentArea addSubview:label];

    // 使用旧样式的方块按钮：✓ / X
    CGFloat btnW = 40.0, btnH = 20.0;
    CGFloat btnX = controlX + controlW - btnW;
    UIButton *status = [UIButton buttonWithType:UIButtonTypeCustom];
    status.frame = CGRectMake(btnX, y - 2.0, btnW, btnH);
    status.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.42];
    [status setTitle:on ? @"✓" : @"X" forState:UIControlStateNormal];
    [status setTitleColor:(on ? accentColor : [UIColor colorWithWhite:0.45 alpha:1.0]) forState:UIControlStateNormal];
    status.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    status.layer.cornerRadius = 6.0;
    status.layer.borderWidth = 1.0;
    status.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.62].CGColor;
    objc_setAssociatedObject(status, &kGF_FlagKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [status addTarget:self action:@selector(onBoolToggle:) forControlEvents:UIControlEventTouchUpInside];
    [_contentArea addSubview:status];

    return y + 24.0;
}

- (CGFloat)addSliderRow:(NSString *)title key:(NSString *)key min:(float)min max:(float)max def:(float)def atY:(CGFloat)y {
    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];
    float value = (float)LFGetDouble(key, def);

    CGFloat contentW = CGRectGetWidth(_contentArea.bounds);
    CGFloat labelX = 56.0;
    CGFloat labelW = 240.0;
    CGFloat controlX = fmin(360.0, contentW * 0.45);
    CGFloat controlW = fmin(520.0, contentW - controlX - 60.0);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, y, labelW, 18)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    label.font = [UIFont systemFontOfSize:12];
    [_contentArea addSubview:label];

    y += 20.0;

    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(controlX, y, controlW, 20)];
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = value;
    slider.minimumTrackTintColor = accentColor;
    slider.maximumTrackTintColor = [UIColor colorWithWhite:0.7 alpha:0.6];
    slider.thumbTintColor = [UIColor colorWithWhite:1.0 alpha:0.95];
    [slider addTarget:self action:@selector(onSliderChanged:) forControlEvents:UIControlEventValueChanged];
    objc_setAssociatedObject(slider, &kGF_FlagKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_contentArea addSubview:slider];

    return y + 28.0;
}

- (CGFloat)addSegmentRow:(NSString *)title key:(NSString *)key items:(NSArray<NSString*> *)items defaultIdx:(NSInteger)def atY:(CGFloat)y {
    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];
    NSInteger idx = LFGetInt(key, (int)def);

    CGFloat contentW = CGRectGetWidth(_contentArea.bounds);
    CGFloat labelX = 56.0;
    CGFloat labelW = 240.0;
    CGFloat controlX = fmin(360.0, contentW * 0.45);
    CGFloat controlW = fmin(520.0, contentW - controlX - 60.0);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, y, labelW, 18)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.1 alpha:0.95];
    label.font = [UIFont systemFontOfSize:12];
    [_contentArea addSubview:label];

    y += 20.0;

    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:items];
    seg.frame = CGRectMake(controlX, y, controlW, 24);
    if (@available(iOS 13.0, *)) {
        seg.selectedSegmentTintColor = [accentColor colorWithAlphaComponent:0.9];
        [seg setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:0.15 alpha:0.95] } forState:UIControlStateNormal];
        [seg setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateSelected];
        seg.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.35];
    }
    seg.selectedSegmentIndex = idx;
    [seg addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    objc_setAssociatedObject(seg, &kGF_FlagKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_contentArea addSubview:seg];

    return y + 32.0;
}

- (void)onSectionTap:(UIButton *)sender {
    NSInteger idx = sender.tag - 100;
    if (idx == 0)      _drawExpanded = !_drawExpanded;
    else if (idx == 1) _aimExpanded  = !_aimExpanded;
    else if (idx == 2) _lootExpanded = !_lootExpanded;
    else if (idx == 3 && LFIsAuthor()) _devExpanded  = !_devExpanded;  // 只有作者才能展开开发者选项
    LFSNSLog(@"[GuardianMenu] Section tap idx=%ld -> draw=%d aim=%d loot=%d dev=%d",
             (long)idx, _drawExpanded, _aimExpanded, _lootExpanded, _devExpanded);
    [self rebuildContent];
}

- (void)onBoolToggle:(UIButton *)sender {
    UIColor *accentColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.88 alpha:1.0];
    NSString *key = objc_getAssociatedObject(sender, &kGF_FlagKey);
    if (![key isKindOfClass:[NSString class]]) return;

    BOOL current = LFGetBool(key, NO);
    BOOL next = !current;
    LFSetBool(key, next);

    // 如果是调试日志总开关，同步更新文件日志状态
    if ([key isEqualToString:调试日志开关]) {
        LFSetDebugLogEnabled(next);
        LFSNSLog(@"[GuardianMenu] 调试日志开关 -> %d", next);
    }
    
    // [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究
    /*
    // 如果是ImGui悬浮窗开关，直接调用管理器
    if ([key isEqualToString:ImGui悬浮窗]) {
        LFSNSLog(@"[GuardianMenu] ========== ImGui悬浮窗开关切换 ==========");
        LFSNSLog(@"[GuardianMenu] 目标状态: %@", next ? @"显示" : @"隐藏");
        
        // 直接使用已导入的SHWindowCtrl
        SHWindowCtrl *manager = [SHWindowCtrl sharedManager];
        if (!manager) {
            LFSNSLog(@"[GuardianMenu] [ERROR] 无法获取SHWindowCtrl单例");
            return;
        }
        
        BOOL currentState = [manager isFloatingWindowVisible];
        LFSNSLog(@"[GuardianMenu] 当前状态: %@", currentState ? @"显示" : @"隐藏");
        
        if (next && !currentState) {
            LFSNSLog(@"[GuardianMenu] 执行显示操作...");
            BOOL success = [manager showFloatingWindow];
            if (success) {
                LFSNSLog(@"[GuardianMenu] ✓✓✓ ImGui悬浮窗显示成功");
            } else {
                LFSNSLog(@"[GuardianMenu] ✗✗✗ ImGui悬浮窗显示失败");
            }
        } else if (!next && currentState) {
            LFSNSLog(@"[GuardianMenu] 执行隐藏操作...");
            BOOL success = [manager hideFloatingWindow];
            if (success) {
                LFSNSLog(@"[GuardianMenu] ✓✓✓ ImGui悬浮窗隐藏成功");
            } else {
                LFSNSLog(@"[GuardianMenu] ✗✗✗ ImGui悬浮窗隐藏失败");
            }
        } else {
            LFSNSLog(@"[GuardianMenu] 状态无需改变，跳过操作");
        }
        
        LFSNSLog(@"[GuardianMenu] ========== ImGui悬浮窗切换处理完成 ==========");
    }
    */

    // 记录所有功能开关的状态变化，方便排错
    LFSNSLog(@"[GuardianMenu] Toggle key=%@ value=%d", key, next);

    [sender setTitle:next ? @"✓" : @"X" forState:UIControlStateNormal];
    [sender setTitleColor:(next ? accentColor : [UIColor colorWithWhite:0.45 alpha:1.0]) forState:UIControlStateNormal];
}

- (void)onSliderChanged:(UISlider *)slider {
    NSString *key = objc_getAssociatedObject(slider, &kGF_FlagKey);
    if (![key isKindOfClass:[NSString class]]) return;
    LFSetDouble(key, slider.value);
    LFSNSLog(@"[GuardianMenu] Slider key=%@ value=%.3f", key, slider.value);
}

- (void)onSegmentChanged:(UISegmentedControl *)seg {
    NSString *key = objc_getAssociatedObject(seg, &kGF_FlagKey);
    if (![key isKindOfClass:[NSString class]]) return;
    LFSetInt(key, (int)seg.selectedSegmentIndex);
    LFSNSLog(@"[GuardianMenu] Segment key=%@ index=%ld", key, (long)seg.selectedSegmentIndex);
}

- (void)onTargetPartTap:(UIButton *)sender {
    NSInteger idx = sender.tag - 300;
    if (idx < 0 || idx > 2) return;
    g_feat.aimPos = (int)idx;
    // 重绘以刷新按钮高亮
    [self rebuildContent];
}

- (void)onFovChanged:(UISlider *)slider {
    g_feat.fovSize = slider.value;
}

- (void)showDeviceInfo {
    NSString *msg = [NSString stringWithFormat:@"UDID: %s\n到期: %s", g_feat.udid, g_feat.expire];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设备信息"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    UIWindow *win = UIApplication.sharedApplication.keyWindow;
    [win.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showInWindow:(UIWindow *)window {
    if (!window) { return; }
    
    if (self.superview != window) {
        // 初次添加到 window
        CGRect bounds = window.bounds;
        CGFloat w = CGRectGetWidth(self.bounds);
        CGFloat h = CGRectGetHeight(self.bounds);
        CGFloat margin = 16.0;
        CGPoint finalCenter = CGPointMake(CGRectGetWidth(bounds) - w/2.0 - margin,
                                          margin + h/2.0 + 40.0);
        self.center = finalCenter;
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [window addSubview:self];
        
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.alpha = 0.9;
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        // 已在 window 上，只是隐藏 -> 显示
        self.hidden = NO;
        self.alpha = 0.9;
    }
}

+ (UIWindow *)findSystemWindow {
    NSLog(@"[GuardianMenu] findSystemWindow called");
    
    // 首先尝试直接使用 SHMainWnd 类
    Class SHMainWndClass = NSClassFromString(@"SHMainWnd");
    if (!SHMainWndClass) {
        // 尝试动态加载类（如果已链接但未加载）
        const char *imageName = "/usr/lib/libobjc.A.dylib";
        void *handle = dlopen(imageName, RTLD_LAZY);
        if (handle) {
            // 尝试直接调用 SHMainWnd 类加载
            SHMainWndClass = NSClassFromString(@"SHMainWnd");
            dlclose(handle);
        }
    }
    
    if (!SHMainWndClass) {
        NSLog(@"[GuardianMenu] ERROR: SHMainWnd class not found after dynamic loading attempt");
        return nil;
    }
    
    NSLog(@"[GuardianMenu] SHMainWndClass: %@", SHMainWndClass);
    
    // 查找已存在的 SHMainWnd 实例
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSLog(@"[GuardianMenu] Total windows count: %lu", (unsigned long)windows.count);
    
    for (UIWindow *window in windows) {
        NSLog(@"[GuardianMenu] Checking window: %@, level: %f, hidden: %d, class: %@", 
              window, window.windowLevel, window.hidden, [window class]);
        if ([window isKindOfClass:SHMainWndClass]) {
            NSLog(@"[GuardianMenu] Found existing SHMainWnd: %@", window);
            
            // 确保窗口是可见的
            if (window.hidden) {
                NSLog(@"[GuardianMenu] Window was hidden, making visible");
                window.hidden = NO;
            }
            // 确保窗口在最顶层
            if (window.windowLevel < UIWindowLevelStatusBar + 1000) {
                NSLog(@"[GuardianMenu] Adjusting window level from %f to %f", 
                      window.windowLevel, UIWindowLevelStatusBar + 2000);
                window.windowLevel = UIWindowLevelStatusBar + 2000;
            }
            
            [window makeKeyAndVisible];
            NSLog(@"[GuardianMenu] Returning existing window");
            return window;
        }
    }
    
    NSLog(@"[GuardianMenu] No existing SHMainWnd found, creating new one");
    
    // 如果没有找到，创建一个新的 SHMainWnd
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIWindow *systemWindow = [[SHMainWndClass alloc] initWithFrame:screenBounds];
    
    // 设置窗口层级为最高
    systemWindow.windowLevel = UIWindowLevelStatusBar + 2000.0;
    
    // 配置窗口属性
    systemWindow.hidden = NO;
    systemWindow.userInteractionEnabled = YES;
    systemWindow.backgroundColor = [UIColor clearColor];
    
    // 创建根视图控制器
    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor clearColor];
    rootVC.view.userInteractionEnabled = NO; // 允许触摸穿透
    systemWindow.rootViewController = rootVC;
    
    // 确保窗口可见
    [systemWindow makeKeyAndVisible];
    
    // 强制窗口更新
    [systemWindow setNeedsLayout];
    [systemWindow layoutIfNeeded];
    
    NSLog(@"[GuardianMenu] Created new system window with level: %f, frame: %@, hidden: %d", 
          systemWindow.windowLevel, NSStringFromCGRect(systemWindow.frame), systemWindow.hidden);
    NSLog(@"[GuardianMenu] New window rootViewController: %@", systemWindow.rootViewController);
    
    return systemWindow;
}

- (void)showInSystemWindow {
    UIWindow *systemWindow = [[self class] findSystemWindow];
    if (!systemWindow) {
        NSLog(@"无法创建系统级窗口");
        return;
    }
    
    if (self.superview != systemWindow) {
        // 初次添加到系统窗口
        CGRect bounds = systemWindow.bounds;
        CGFloat w = CGRectGetWidth(self.bounds);
        CGFloat h = CGRectGetHeight(self.bounds);
        CGFloat margin = 16.0;
        CGPoint finalCenter = CGPointMake(CGRectGetWidth(bounds) - w/2.0 - margin,
                                          margin + h/2.0 + 40.0);
        self.center = finalCenter;
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [systemWindow addSubview:self];
        
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.alpha = 0.9;
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        // 已在系统窗口上，只是隐藏 -> 显示
        self.hidden = NO;
        self.alpha = 0.9;
    }
    
    // 确保窗口在最前面
    [systemWindow makeKeyAndVisible];
}

- (void)hide {
    if (!self.superview) return;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        self.hidden = YES;
    }];
}

@end


@implementation LFAccordionCard

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super initWithFrame:CGRectZero]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = LF_CORNER;
        self.layer.borderWidth  = 1;
        self.layer.borderColor  = LF_BORDER;
        self.backgroundColor    = LF_CARD;
        self.layer.shadowOpacity = 0.22;
        self.layer.shadowRadius  = 12;
        self.layer.shadowOffset  = (CGSize){0,6};

        // 头部
        _headerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _headerBtn.translatesAutoresizingMaskIntoConstraints = NO;
        _headerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _headerBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.02];
        _headerBtn.layer.cornerRadius = LF_CORNER;
        _headerBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [_headerBtn setTitleColor:LF_TEXT forState:UIControlStateNormal];

        _titleLab = LFMakeLabel(title, [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold], LF_TEXT);
        _chev = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.down"]];
        _chev.translatesAutoresizingMaskIntoConstraints = NO;
        _chev.tintColor = LF_TEXT_SUB;

        [_headerBtn addSubview:_titleLab];
        [_headerBtn addSubview:_chev];
        [self addSubview:_headerBtn];

        // 内容容器（裁剪，初始收起）
        _contentWrap = [UIView new];
        _contentWrap.translatesAutoresizingMaskIntoConstraints = NO;
        _contentWrap.clipsToBounds = YES;
        _contentWrap.alpha = 0.0;
        _contentWrap.transform = CGAffineTransformMakeTranslation(0, -8); // 轻微上移，展开时向下露出

        _contentStack = [UIStackView new];
        _contentStack.translatesAutoresizingMaskIntoConstraints = NO;
        _contentStack.axis = UILayoutConstraintAxisVertical;
        _contentStack.spacing = 10;

        [_contentWrap addSubview:_contentStack];
        [self addSubview:_contentWrap];

        // 约束
        [NSLayoutConstraint activateConstraints:@[
            // Header
            [_headerBtn.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_headerBtn.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_headerBtn.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_headerBtn.heightAnchor constraintEqualToConstant:52],

            [_titleLab.leadingAnchor constraintEqualToAnchor:_headerBtn.leadingAnchor constant:14],
            [_titleLab.centerYAnchor constraintEqualToAnchor:_headerBtn.centerYAnchor],
            [_chev.trailingAnchor constraintEqualToAnchor:_headerBtn.trailingAnchor constant:-12],
            [_chev.centerYAnchor constraintEqualToAnchor:_headerBtn.centerYAnchor],

            // Content wrap
            [_contentWrap.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
            [_contentWrap.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
            [_contentWrap.topAnchor constraintEqualToAnchor:_headerBtn.bottomAnchor],
            [_contentWrap.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10],

            // Content stack in wrap
            [_contentStack.leadingAnchor constraintEqualToAnchor:_contentWrap.leadingAnchor],
            [_contentStack.trailingAnchor constraintEqualToAnchor:_contentWrap.trailingAnchor],
            [_contentStack.topAnchor constraintEqualToAnchor:_contentWrap.topAnchor constant:6],
            [_contentStack.bottomAnchor constraintEqualToAnchor:_contentWrap.bottomAnchor constant:-6],
        ]];

        // 高度约束控制展开
        _contentH = [_contentWrap.heightAnchor constraintEqualToConstant:0];
        _contentH.active = YES;

        self.expanded = NO;

        [_headerBtn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)toggle {
    [self toggleAnimated:YES];
}

- (void)toggleAnimated:(BOOL)animated {
    BOOL willExpand = !self.expanded;
    self.expanded = willExpand;

    // 先测量目标高度
    [self.superview layoutIfNeeded];
    [self layoutIfNeeded];
    CGFloat targetH = willExpand ? [self lf_measuredContentHeight] : self.contentH.constant;

    if (willExpand) {
        // 1) 外部布局：高度瞬时到位（不动画），避免其它 UI 跟着动
        [UIView performWithoutAnimation:^{
            self.contentH.constant = targetH;
            [self.superview layoutIfNeeded];
        }];

        // 2) 内部轻量展开动画（只动自己）
        self.contentWrap.alpha = 0.0;
        self.contentWrap.transform = CGAffineTransformMakeTranslation(0, -8);
        NSTimeInterval dur = animated ? 0.20 : 0.0;

        [UIView animateWithDuration:dur
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.contentWrap.alpha = 1.0;
            self.contentWrap.transform = CGAffineTransformIdentity;
            self.chev.transform = CGAffineTransformMakeRotation((CGFloat)M_PI);
        } completion:nil];

    } else {
        // 收起：先只做内部隐藏动画，不动外部高度
        NSTimeInterval dur = animated ? 0.16 : 0.0;
        [UIView animateWithDuration:dur
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.contentWrap.alpha = 0.0;
            self.contentWrap.transform = CGAffineTransformMakeTranslation(0, -8);
            self.chev.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 动画完再瞬时把高度设为 0（不动画），其它 UI 仍不跟随动画
            [UIView performWithoutAnimation:^{
                self.contentH.constant = 0;
                [self.superview layoutIfNeeded];
            }];
        }];
    }
}

- (CGFloat)lf_measuredContentHeight {
    CGFloat availableW = self.bounds.size.width - 20.0;
    if (availableW <= 0 && self.superview) {
        [self.superview layoutIfNeeded];
        availableW = self.bounds.size.width - 20.0;
    }
    if (availableW <= 0) availableW = UIScreen.mainScreen.bounds.size.width - 20.0;

    CGSize fit = [_contentStack systemLayoutSizeFittingSize:CGSizeMake(availableW, CGFLOAT_MAX)
                             withHorizontalFittingPriority:UILayoutPriorityRequired
                                   verticalFittingPriority:UILayoutPriorityFittingSizeLevel];

    return MIN(fit.height + 12.0, 9000.0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:LF_CORNER].CGPath;
}
@end
#pragma mark - 数据驱动行配置
typedef NS_ENUM(NSInteger, LFRowType){ LFRowTypeSwitch, LFRowTypeSlider, LFRowTypeSegment };

@interface LFRowConfig : NSObject
@property(nonatomic,assign) LFRowType type;
@property(nonatomic,copy)   NSString *title;
@property(nonatomic,copy)   NSString *key;
@property(nonatomic,assign) float minv, maxv, defFloat;
@property(nonatomic,assign) BOOL defBool;
@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,assign) float step;          // 步进（默认 1.0）
@property(nonatomic,assign) NSInteger decimals;  // 小数位（默认 0）
// ✅ 新增：Segment 用
@property(nonatomic,strong) NSArray<NSString*> *segmentItems;
@property(nonatomic,assign) NSInteger defIndex;
// 运行时绑定
@property(nonatomic,weak) UILabel  *valueLabel;
@property(nonatomic,weak) UISlider *slider;
@property(nonatomic,weak) UISwitch *sw;
@property(nonatomic,weak) UISegmentedControl *segment;

@end
@implementation LFRowConfig @end

static NSInteger LFTagSeed = 100;
static inline LFRowConfig *LFSwitchRow(NSString *title, NSString *key, BOOL defOn){
    LFRowConfig *c=[LFRowConfig new]; c.type=LFRowTypeSwitch; c.title=title; c.key=key; c.defBool=defOn; c.tag=++LFTagSeed; return c;
}
// 原有 LFSliderRow 结尾加上默认配置
static inline LFRowConfig *LFSliderRow(NSString *title, NSString *key, float minv, float maxv, float defv){
    LFRowConfig *c=[LFRowConfig new]; c.type=LFRowTypeSlider; c.title=title; c.key=key;
    c.minv=minv; c.maxv=maxv; c.defFloat=defv; c.tag=++LFTagSeed;
    c.step = 1.0f;       // 默认整数步进
    c.decimals = 0;      // 默认不显示小数
    return c;
}

// 新增：带步进与小数位的构造
static inline LFRowConfig *LFSliderRowD(NSString *title, NSString *key,
                                        float minv, float maxv, float defv,
                                        float step, NSInteger decimals){
    LFRowConfig *c = LFSliderRow(title, key, minv, maxv, defv);
    c.step = step;
    c.decimals = decimals;
    return c;
}
static inline LFRowConfig *LFSegmentRow(NSString *title, NSString *key, NSArray<NSString*> *items, NSInteger defIndex){
    LFRowConfig *c=[LFRowConfig new];
    c.type=LFRowTypeSegment; c.title=title; c.key=key;
    c.segmentItems=items; c.defIndex=defIndex; c.tag=++LFTagSeed;
    return c;
}

#pragma mark - 使用说明
static NSString *LFUserGuideText(void) {
    return
    @"【快速上手】\n"
    "1) 点击「启动游戏」后会跳转到游戏，页面应显示 FPS；\n"
    "2) 若未显示 FPS：返回当前应用点击「关闭游戏」，再重新「启动游戏」；\n"
    "3) 若尝试 2 次仍无效：点击旁边的「重启设备」；\n"
    "4) 若重启 2 次仍无效：请手动重启设备；若会强制重启，优先使用强制重启；\n"
    "5) 看到页面出现 FPS 即表示漏洞已成功载入。\n"
    "\n"
    "【无效果时的操作】\n"
    "• 每次「启动游戏」之前，展开「基础功能」页面，随机开/关任意一个开关，再启动游戏；\n"
    "  （原因：底层未载入数据，需要手动触发写入。）\n"
    "• 下号操作：打开本应用直接点击「关闭游戏」即可。\n"
    "\n"
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 常见问题
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    "【常见问题】\n"
    "Q：按下「启动游戏」后紫屏重启怎么办？\n"
    "A：属于漏洞触发系统保护的正常现象，约 15 秒后设备会自动重启。\n"
    "\n"
    "Q：「启动游戏」没有反应怎么办？\n"
    "A：先等待约 0.5 秒再点击；仍不行则返回主页「关闭游戏」后再启动。\n"
    "\n"
    "Q：为什么显示了 FPS 还是没效果？\n"
    "A：进入应用 →「基础功能」→ 随机开/关一个开关 → 返回游戏检查；仍无效则重启后重试。\n"
    "\n"
    "Q：游戏过程中出现重启？\n"
    "A：属正常现象，建议每次启动后先在训练营尝试十几分钟。多由系统安全机制触发。\n"
    "\n"
    "Q：如何恢复默认设置？\n"
    "A：使用右上角「重置」按钮。\n"
    "\n"
    "Q：绘制很卡怎么办？\n"
    "A：与开启的功能数量相关。功能越多，底层读写压力与 CPU 负载越高，建议按需开启。\n"
    "\n"
    "Q：适配什么设备？\n"
    "A：推荐 A12 及以上机型；2020 年前机型可能较卡顿。\n"
    "\n"
    "Q：直播模式为何没效果？\n"
    "A：需在点击「启动游戏」之前开启直播模式；启动后切换无效。\n"
    "\n"
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 注意事项 / 安全提示
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    "【注意事项】\n"
    "• 修改设置后会自动保存，如需恢复默认可使用右上角重置按钮；\n"
    "• 关于游戏安全：我们采用物理层读写，基于 iOS 内核级实现。理论上不易被触发检测，\n"
    "  但部分游戏存在 AI 行为检测；若你的数据与历史表现差异过大，或被多次举报，可能受惩罚。\n";
}

@interface LFUserGuideSheet : UIView
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,strong) UITextView *textView;
@end
@implementation LFUserGuideSheet
- (instancetype)init{
    if (self=[super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.35];
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _panel=LFCardContainer(); _panel.backgroundColor=[[UIColor colorWithWhite:0.05 alpha:1] colorWithAlphaComponent:0.96];
        UILabel *title=LFMakeLabel(@"使用说明",[UIFont boldSystemFontOfSize:18],LF_TEXT);
        _textView=[UITextView new]; _textView.translatesAutoresizingMaskIntoConstraints=NO; _textView.text=LFUserGuideText(); _textView.editable=NO; _textView.backgroundColor=[UIColor clearColor]; _textView.textColor=LF_TEXT; _textView.font=[UIFont systemFontOfSize:14];
        UIButton *copy=[UIButton buttonWithType:UIButtonTypeSystem]; copy.translatesAutoresizingMaskIntoConstraints=NO; [copy setTitle:@"复制说明" forState:UIControlStateNormal]; copy.tintColor=LF_TEXT; copy.backgroundColor=[LF_ACCENT colorWithAlphaComponent:0.22]; copy.layer.cornerRadius=12; copy.contentEdgeInsets=(UIEdgeInsets){10,14,10,14}; [copy addTarget:self action:@selector(onCopy) forControlEvents:UIControlEventTouchUpInside];
        UIButton *close=[UIButton buttonWithType:UIButtonTypeSystem]; close.translatesAutoresizingMaskIntoConstraints=NO; [close setTitle:@"我知道了" forState:UIControlStateNormal]; close.tintColor=LF_TEXT; close.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.12]; close.layer.cornerRadius=12; close.contentEdgeInsets=(UIEdgeInsets){10,14,10,14}; [close addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];

        UIStackView *btns=[UIStackView new]; btns.translatesAutoresizingMaskIntoConstraints=NO; btns.axis=UILayoutConstraintAxisHorizontal; btns.spacing=12; btns.distribution=UIStackViewDistributionFillEqually; [btns addArrangedSubview:copy]; [btns addArrangedSubview:close];

        [_panel addSubview:title]; [_panel addSubview:_textView]; [_panel addSubview:btns]; [self addSubview:_panel];
        _panel.transform=CGAffineTransformMakeTranslation(0, 420);

        [NSLayoutConstraint activateConstraints:@[
            [_panel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18],
            [_panel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18],
            [_panel.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-12],

            [title.leadingAnchor constraintEqualToAnchor:_panel.leadingAnchor constant:16],
            [title.topAnchor constraintEqualToAnchor:_panel.topAnchor constant:14],

            [_textView.leadingAnchor constraintEqualToAnchor:_panel.leadingAnchor constant:12],
            [_textView.trailingAnchor constraintEqualToAnchor:_panel.trailingAnchor constant:-12],
            [_textView.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:8],
            [_textView.heightAnchor constraintGreaterThanOrEqualToConstant:260],

            [btns.leadingAnchor constraintEqualToAnchor:_panel.leadingAnchor constant:12],
            [btns.trailingAnchor constraintEqualToAnchor:_panel.trailingAnchor constant:-12],
            [btns.topAnchor constraintEqualToAnchor:_textView.bottomAnchor constant:12],
            [btns.bottomAnchor constraintEqualToAnchor:_panel.bottomAnchor constant:-12],
            [btns.heightAnchor constraintEqualToConstant:44],
        ]];

        [UIView animateWithDuration:0.28 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.6 options:0 animations:^{ self.panel.transform=CGAffineTransformIdentity; } completion:nil];
    } return self;
}
- (void)onCopy{ [UIPasteboard generalPasteboard].string=self.textView.text; if (@available(iOS 10.0, *)) { UIImpactFeedbackGenerator *g=[[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight]; [g impactOccurred]; } }
- (void)onClose{ [UIView animateWithDuration:0.25 animations:^{ self.backgroundColor=[UIColor clearColor]; self.panel.transform=CGAffineTransformMakeTranslation(0, 420);} completion:^(BOOL f){ [self removeFromSuperview]; }]; }
@end

#pragma mark - 协议弹窗（不变）
@interface LFAgreementView : UIView
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,copy)   void (^onResult)(BOOL agree);
@end
@implementation LFAgreementView
- (instancetype)init{
    if (self=[super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.35];
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

        _panel=LFCardContainer();
        _panel.backgroundColor=[[UIColor colorWithWhite:0.06 alpha:1] colorWithAlphaComponent:0.92];

        UILabel *title = LFMakeLabel(@"《骷髅头 使用协议》",
                                     [UIFont boldSystemFontOfSize:18],
                                     LF_TEXT);

        UILabel *t1 = LFMakeLabel(
            @"一、重要提示与风险声明\n"
            @"本软件可能涉及对网络游戏等产品/服务的公平性、完整性与稳定性产生影响的目的。"
            @"您应在充分了解相关风险后，自行决定是否使用，并对由此产生的一切后果自行承担。",
            [UIFont systemFontOfSize:14],
            LF_TEXT_SUB
        );

        UILabel *t2 = LFMakeLabel(
            @"二、禁止逆向与安全保护\n"
            @"禁止对本软件进行逆向工程、反编译、反汇编、抓包分析或绕过授权等行为。"
            @"开发者有权采取合理的技术措施进行保护，并在必要时依法对您的设备执行系统恢复（俗称“白苹果”）"
            @"及/或限制 DFU 模式入口。",
            [UIFont systemFontOfSize:14],
            LF_TEXT_SUB
        );

        UILabel *t3 = LFMakeLabel(
            @"三、设备与隐私\n"
            @"为实现功能，本软件可能在本地读取必要的设备信息（如设备型号、系统版本、序列号），"
            @"用于配置与设备绑定。本软件不采集可单独识别您个人身份的信息。",
            [UIFont systemFontOfSize:14],
            LF_TEXT_SUB
        );

        UIButton *deny=[UIButton buttonWithType:UIButtonTypeSystem]; [deny setTitle:@"不同意" forState:UIControlStateNormal];
        deny.translatesAutoresizingMaskIntoConstraints=NO; deny.tintColor=LF_TEXT; deny.backgroundColor=[LFHex(0xC21B1B,1) colorWithAlphaComponent:0.30]; deny.layer.cornerRadius=16; deny.contentEdgeInsets=(UIEdgeInsets){12,16,12,16};
        UIButton *agree=[UIButton buttonWithType:UIButtonTypeSystem]; [agree setTitle:@"同意并继续" forState:UIControlStateNormal];
        agree.translatesAutoresizingMaskIntoConstraints=NO; agree.tintColor=LF_TEXT; agree.backgroundColor=[LFHex(0x1AA0FF,1) colorWithAlphaComponent:0.30]; agree.layer.cornerRadius=16; agree.contentEdgeInsets=(UIEdgeInsets){12,16,12,16};

        UIStackView *v=[UIStackView new]; v.axis=UILayoutConstraintAxisVertical; v.spacing=12; v.translatesAutoresizingMaskIntoConstraints=NO;
        [v addArrangedSubview:title]; [v addArrangedSubview:t1]; [v addArrangedSubview:t2]; [v addArrangedSubview:t3];
        UIStackView *h=[UIStackView new]; h.axis=UILayoutConstraintAxisHorizontal; h.spacing=12; h.distribution=UIStackViewDistributionFillEqually; h.translatesAutoresizingMaskIntoConstraints=NO;
        [h addArrangedSubview:deny]; [h addArrangedSubview:agree];
        [v addArrangedSubview:LFMakeSpacer(6)]; [v addArrangedSubview:h];

        [_panel addSubview:v]; [self addSubview:_panel];
        _panel.transform=CGAffineTransformMakeTranslation(0, 420);

        [NSLayoutConstraint activateConstraints:@[
            [_panel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:18],
            [_panel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-18],
            [_panel.bottomAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.bottomAnchor constant:-12],
            [v.leadingAnchor constraintEqualToAnchor:_panel.leadingAnchor constant:16],
            [v.trailingAnchor constraintEqualToAnchor:_panel.trailingAnchor constant:-16],
            [v.topAnchor constraintEqualToAnchor:_panel.topAnchor constant:16],
            [v.bottomAnchor constraintEqualToAnchor:_panel.bottomAnchor constant:-16],
        ]];

        [deny addTarget:self action:@selector(onDeny) forControlEvents:UIControlEventTouchUpInside];
        [agree addTarget:self action:@selector(onAgree) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.30 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.6 options:0 animations:^{ self.panel.transform=CGAffineTransformIdentity; } completion:nil];
    } return self;
}
- (void)onDeny{ if(self.onResult) self.onResult(NO); [self dismiss]; }
- (void)onAgree{ if(self.onResult) self.onResult(YES); [self dismiss]; }
- (void)dismiss{ [UIView animateWithDuration:0.25 animations:^{ self.backgroundColor=[UIColor clearColor]; self.panel.transform=CGAffineTransformMakeTranslation(0, 420);} completion:^(BOOL f){ [self removeFromSuperview]; }]; }
@end

#pragma mark - SHEntryCtrl
@interface SHEntryCtrl ()
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) UIStackView  *stack;
// 行配置索引：tag -> config
@property(nonatomic,strong) NSMutableDictionary<NSNumber*, LFRowConfig*> *cfgMap;
// 所有配置的 key（用于重置、刷新）
@property(nonatomic,strong) NSMutableOrderedSet<NSString*> *allKeys;
// 诊断角标：用于排查”更新后仍像老版本”
@property(nonatomic,strong) UILabel *lfDiagBadge;
@property(nonatomic,strong) NSTimer *lfDiagTimer;
@property(nonatomic,strong) UIButton *apiConnectButton;
@property(nonatomic,strong) UISegmentedControl *gameTypeSelector;
@property(nonatomic,strong) UIButton *openGameButton;
@property(nonatomic,strong) UIButton *logButton;
@property(nonatomic,assign) BOOL apiConnected;

// 协议弹窗 & Toast 接口声明，避免编译器报未声明的选择器
- (void)showAgreementIfNeeded;
- (void)showToast:(NSString *)msg;
- (void)buildSimpleMainUI;
- (void)onConnectApiTap:(UIButton *)sender;
- (void)onGameTypeChanged:(UISegmentedControl *)sender;
- (void)onOpenGameTap:(UIButton *)sender;
- (void)onShowLogTap:(UIButton *)sender;
- (void)updateKernelButtonTitle;
- (void)showKernelModePicker;
- (void)startTrekRuntimeWithModeIdentifier:(NSString *)identifier displayName:(NSString *)displayName;
- (BOOL)launchPUBGGame;
- (BOOL)launchSMobaGame;
@end

// ---- 全局游戏类型状态 ----
static SHGameType s_selectedGameType = SHGameTypePUBG;
void SHSetSelectedGameType(SHGameType type) { s_selectedGameType = type; }
SHGameType SHGetSelectedGameType(void) { return s_selectedGameType; }
NSString * SHGameTypeDisplayName(SHGameType type) {
    switch (type) {
        case SHGameTypePUBG:  return @"和平精英";
        case SHGameTypeSMoba: return @"王者荣耀";
    }
    return @"?";
}

@implementation SHEntryCtrl
UIButton *bHUD;

static NSString *const kLFLastAppVersionKey = @"lf.last.app.version";
extern NSString *LFLoadedKernelDylibPath(void);

- (NSString *)_currentAppVersionString {
    NSString *v = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"?";
    NSString *b = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ?: @"?";
    return [NSString stringWithFormat:@"%@(%@)", v, b];
}

- (void)_setupDiagBadgeIfNeeded {
    if (self.lfDiagBadge) return;

    UILabel *lab = [UILabel new];
    lab.translatesAutoresizingMaskIntoConstraints = NO;
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightSemibold];
    lab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.92];
    lab.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    lab.layer.cornerRadius = 10.0;
    lab.layer.masksToBounds = YES;
    lab.layer.borderWidth = 1.0;
    lab.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.10].CGColor;
    lab.alpha = 0.92;

    // 内边距：用一个容器包裹实现（UILabel 本身不支持 padding）
    UIView *container = [UIView new];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    container.backgroundColor = UIColor.clearColor;
    [container addSubview:lab];
    [self.view addSubview:container];

    [NSLayoutConstraint activateConstraints:@[
        // 角标位置：左下角，避开安全区
        [container.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:12],
        [container.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-12],

        [lab.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:10],
        [lab.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-10],
        [lab.topAnchor constraintEqualToAnchor:container.topAnchor constant:8],
        [lab.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-8],

        // 最大宽度限制，避免遮挡 UI
        [container.widthAnchor constraintLessThanOrEqualToConstant:340],
    ]];

    self.lfDiagBadge = lab;

    // 定时刷新内容（dylib 可能在稍后才加载成功）
    __weak __typeof(self) w = self;
    self.lfDiagTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(__unused NSTimer * _Nonnull t) {
        [w _refreshDiagBadge];
    }];
    [self _refreshDiagBadge];
}

- (void)_refreshDiagBadge {
    NSString *ver = [self _currentAppVersionString];
    NSString *dylib = LFLoadedKernelDylibPath();
    if (dylib.length == 0) dylib = @"(未加载/未找到)";
    // 为了截图排查，一行关键信息够用
    self.lfDiagBadge.text = [NSString stringWithFormat:@"ver: %@\ndylib: %@", ver, dylib];
}

- (void)dealloc {
    [self.lfDiagTimer invalidate];
    self.lfDiagTimer = nil;
}

- (void)_checkVersionAndPromptIfNeeded {
    NSString *cur = [self _currentAppVersionString];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *last = [ud stringForKey:kLFLastAppVersionKey];
    if (!last) {
        [ud setObject:cur forKey:kLFLastAppVersionKey];
        [ud synchronize];
        return;
    }
    if ([last isEqualToString:cur]) return;

    // 记录新版本（避免反复弹窗）
    [ud setObject:cur forKey:kLFLastAppVersionKey];
    [ud synchronize];

    // 说明：绘制/开关读取走 iCloud KVS，本地更新不等于配置更新；用户会误以为“还是老样式”
    NSString *msg =
    [NSString stringWithFormat:
     @"检测到你已升级到 %@。\n\n"
     @"有些绘制样式/开关配置会从 iCloud 同步（跨设备共享），升级后可能仍沿用旧配置，看起来像“更新了还是老样式”。\n\n"
     @"如需让新版本样式生效，建议点击「重置配置」（会清空 iCloud 与本地配置并恢复默认）。",
     cur];

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"版本升级提示"
                                                                message:msg
                                                         preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) w = self;
    [ac addAction:[UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"重置配置" style:UIAlertActionStyleDestructive handler:^(__unused UIAlertAction * _Nonnull action) {
        [w resetAllSettings];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:ac animated:YES completion:nil];
    });
}

- (void)buildSimpleMainUI {
    self.view.backgroundColor = LFHex(0xEEF2F5, 1.0);
    CAGradientLayer *bg = [CAGradientLayer layer];
    bg.frame = self.view.bounds;
    bg.colors = @[
        (id)LFHex(0xF8FBFD, 1.0).CGColor,
        (id)LFHex(0xEAF3F7, 1.0).CGColor,
        (id)LFHex(0xF7FAFC, 1.0).CGColor
    ];
    bg.startPoint = CGPointMake(0.0, 0.0);
    bg.endPoint = CGPointMake(1.0, 1.0);
    [self.view.layer addSublayer:bg];

    UIVisualEffectView *panel = LFGlassPanel(CGRectZero, 18.0);
    panel.translatesAutoresizingMaskIntoConstraints = NO;
    panel.layer.shadowColor = UIColor.blackColor.CGColor;
    panel.layer.shadowOpacity = 0.10;
    panel.layer.shadowRadius = 28.0;
    panel.layer.shadowOffset = CGSizeMake(0, 12);
    [self.view addSubview:panel];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"Troll Engine";
    titleLabel.textColor = LFHex(0x0B1220, 0.92);
    titleLabel.font = [UIFont systemFontOfSize:38 weight:UIFontWeightSemibold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [panel.contentView addSubview:titleLabel];

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.translatesAutoresizingMaskIntoConstraints = NO;
    subLabel.text = @"内核初始化 · 游戏入口 · 实时日志";
    subLabel.textColor = LFHex(0x334155, 0.66);
    subLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    subLabel.textAlignment = NSTextAlignmentCenter;
    [panel.contentView addSubview:subLabel];

    self.apiConnectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.apiConnectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.apiConnectButton setTitle:@"内核方案" forState:UIControlStateNormal];
    self.apiConnectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.apiConnectButton.titleLabel.minimumScaleFactor = 0.72;
    LFStyleGlassButton(self.apiConnectButton, LFHex(0x1E88E5, 1.0), YES);
    [self.apiConnectButton addTarget:self action:@selector(onConnectApiTap:) forControlEvents:UIControlEventTouchUpInside];
    [panel.contentView addSubview:self.apiConnectButton];

    // 游戏类型选择器
    self.gameTypeSelector = [[UISegmentedControl alloc] initWithItems:@[@"和平精英", @"王者荣耀"]];
    self.gameTypeSelector.translatesAutoresizingMaskIntoConstraints = NO;
    self.gameTypeSelector.selectedSegmentIndex = (SHGetSelectedGameType() == SHGameTypeSMoba) ? 1 : 0;
    [self.gameTypeSelector addTarget:self action:@selector(onGameTypeChanged:) forControlEvents:UIControlEventValueChanged];
    [panel.contentView addSubview:self.gameTypeSelector];

    self.openGameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.openGameButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.openGameButton setTitle:@"打开游戏" forState:UIControlStateNormal];
    LFStyleGlassButton(self.openGameButton, LFHex(0x20A66A, 1.0), YES);
    [self.openGameButton addTarget:self action:@selector(onOpenGameTap:) forControlEvents:UIControlEventTouchUpInside];
    [panel.contentView addSubview:self.openGameButton];

    self.logButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.logButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logButton setTitle:@"查看日志" forState:UIControlStateNormal];
    LFStyleGlassButton(self.logButton, LFHex(0x1E88E5, 1.0), NO);
    [self.logButton addTarget:self action:@selector(onShowLogTap:) forControlEvents:UIControlEventTouchUpInside];
    [panel.contentView addSubview:self.logButton];

    NSLayoutConstraint *panelWidth = [panel.widthAnchor constraintEqualToConstant:430.0];
    panelWidth.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [panel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [panel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        panelWidth,
        [panel.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor constant:-42.0],
        [panel.heightAnchor constraintEqualToConstant:410.0],

        [titleLabel.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [titleLabel.topAnchor constraintEqualToAnchor:panel.contentView.topAnchor constant:34.0],
        [titleLabel.leadingAnchor constraintEqualToAnchor:panel.contentView.leadingAnchor constant:24.0],
        [titleLabel.trailingAnchor constraintEqualToAnchor:panel.contentView.trailingAnchor constant:-24.0],

        [subLabel.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [subLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6.0],
        [subLabel.leadingAnchor constraintEqualToAnchor:panel.contentView.leadingAnchor constant:24.0],
        [subLabel.trailingAnchor constraintEqualToAnchor:panel.contentView.trailingAnchor constant:-24.0],

        [self.apiConnectButton.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [self.apiConnectButton.topAnchor constraintEqualToAnchor:subLabel.bottomAnchor constant:34.0],
        [self.apiConnectButton.widthAnchor constraintEqualToAnchor:panel.contentView.widthAnchor constant:-56.0],
        [self.apiConnectButton.heightAnchor constraintEqualToConstant:52.0],

        [self.gameTypeSelector.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [self.gameTypeSelector.topAnchor constraintEqualToAnchor:self.apiConnectButton.bottomAnchor constant:16.0],
        [self.gameTypeSelector.widthAnchor constraintEqualToAnchor:self.apiConnectButton.widthAnchor],
        [self.gameTypeSelector.heightAnchor constraintEqualToConstant:34.0],

        [self.openGameButton.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [self.openGameButton.topAnchor constraintEqualToAnchor:self.gameTypeSelector.bottomAnchor constant:12.0],
        [self.openGameButton.widthAnchor constraintEqualToAnchor:self.apiConnectButton.widthAnchor],
        [self.openGameButton.heightAnchor constraintEqualToConstant:52.0],

        [self.logButton.centerXAnchor constraintEqualToAnchor:panel.contentView.centerXAnchor],
        [self.logButton.topAnchor constraintEqualToAnchor:self.openGameButton.bottomAnchor constant:16.0],
        [self.logButton.widthAnchor constraintEqualToAnchor:self.apiConnectButton.widthAnchor],
        [self.logButton.heightAnchor constraintEqualToConstant:48.0],
    ]];
    [self updateKernelButtonTitle];
}

- (void)onShowLogTap:(UIButton *)sender {
    (void)sender;
    NSString *text = LFReadAppLogSnippet(128 * 1024);
    if (text.length == 0) {
        text = @"暂无日志。点击“内核方案”开始初始化后，再回到这里查看。";
    }

    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor colorWithWhite:0.06 alpha:1.0];
    vc.title = @"日志";

    UITextView *logView = [[UITextView alloc] initWithFrame:vc.view.bounds];
    logView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    logView.editable = NO;
    logView.selectable = YES;
    logView.backgroundColor = [UIColor colorWithWhite:0.06 alpha:1.0];
    logView.textColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    logView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    logView.textContainerInset = UIEdgeInsetsMake(14, 14, 14, 14);
    logView.text = text;
    [vc.view addSubview:logView];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                         target:self
                                                                                         action:@selector(dismissPresentedLogController:)];
    [self presentViewController:nav animated:YES completion:^{
        if (logView.text.length > 0) {
            [logView scrollRangeToVisible:NSMakeRange(MAX((NSInteger)logView.text.length - 1, 0), 1)];
        }
    }];
}

- (void)dismissPresentedLogController:(id)sender {
    (void)sender;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onConnectApiTap:(UIButton *)sender {
    (void)sender;
    [self showKernelModePicker];
}

- (NSString *)currentMachineIdentifier {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithUTF8String:systemInfo.machine ?: "unknown"];
}

- (BOOL)isCurrentDeviceArm64e {
    cpu_subtype_t cpusubtype = 0;
    size_t len = sizeof(cpusubtype);
    if (sysctlbyname("hw.cpusubtype", &cpusubtype, &len, NULL, 0) != 0) return NO;
    return (cpusubtype & ~CPU_SUBTYPE_MASK) == CPU_SUBTYPE_ARM64E;
}

- (NSComparisonResult)compareSystemVersionTo:(NSString *)version {
    return [UIDevice.currentDevice.systemVersion compare:version options:NSNumericSearch];
}

- (BOOL)systemVersionAtLeast:(NSString *)start atMost:(NSString *)end {
    return ([self compareSystemVersionTo:start] != NSOrderedAscending &&
            [self compareSystemVersionTo:end] != NSOrderedDescending);
}

- (NSDictionary<NSString *, NSString *> *)recommendedKernelMode {
    BOOL arm64e = [self isCurrentDeviceArm64e];
    if (!arm64e) {
        return @{@"id": @"com.roothide.palera1n.roothide",
                 @"name": @"palera1n roothide",
                 @"reason": @"A11/更早 arm64 设备优先使用 palera1n roothide"};
    }
    if ([self systemVersionAtLeast:@"16.4" atMost:@"16.6.1"]) {
        return @{@"id": @"com.opa334.kfd.landa",
                 @"name": @"kfd landa",
                 @"reason": @"iOS 16.4-16.6.1 推荐 landa"};
    }
    if ([self systemVersionAtLeast:@"16.0" atMost:@"16.3.1"]) {
        return @{@"id": @"com.opa334.kfd.physpuppet",
                 @"name": @"kfd physpuppet",
                 @"reason": @"iOS 16.0-16.3.1 推荐 physpuppet"};
    }
    if ([self systemVersionAtLeast:@"15.2" atMost:@"15.5"]) {
        return @{@"id": @"com.opa334.weightBufs",
                 @"name": @"weightBufs",
                 @"reason": @"iOS 15.2-15.5 arm64e 可尝试 weightBufs"};
    }
    if ([self systemVersionAtLeast:@"15.0" atMost:@"15.1.1"]) {
        return @{@"id": @"com.opa334.multicast-bytecopy",
                 @"name": @"multicast_bytecopy",
                 @"reason": @"iOS 15.0-15.1.1 可尝试 multicast_bytecopy"};
    }
    return @{@"id": @"",
             @"name": @"自动推荐",
             @"reason": @"交给 Trek 按内部优先级自动选择"};
}

- (NSString *)trekPreferencePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.trekqix.trek-roothid.plist"];
}

- (NSString *)selectedKernelModeName {
    NSString *path = [self trekPreferencePath];
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *identifier = prefs[@"selectedKernelExploit"];
    if (identifier.length == 0) return @"自动推荐";
    NSDictionary *names = @{
        @"com.opa334.kfd.physpuppet": @"kfd physpuppet",
        @"com.opa334.kfd.landa": @"kfd landa",
        @"com.opa334.kfd.smith": @"kfd smith",
        @"com.opa334.multicast-bytecopy": @"multicast_bytecopy",
        @"com.opa334.weightBufs": @"weightBufs",
        @"com.roothide.palera1n.roothide": @"palera1n roothide",
    };
    return names[identifier] ?: identifier;
}

- (void)saveKernelModeIdentifier:(NSString *)identifier {
    NSString *path = [self trekPreferencePath];
    NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:path] ?: [NSMutableDictionary dictionary];
    if (identifier.length > 0) {
        prefs[@"selectedKernelExploit"] = identifier;
    } else {
        [prefs removeObjectForKey:@"selectedKernelExploit"];
    }
    [prefs writeToFile:path atomically:YES];
    LFSNSLog(@"[TrekRuntime] selectedKernelExploit=%@", identifier.length ? identifier : @"auto");
}

- (void)updateKernelButtonTitle {
    NSDictionary *rec = [self recommendedKernelMode];
    NSString *selected = [self selectedKernelModeName];
    NSString *title = [NSString stringWithFormat:@"内核方案：%@%@", selected, [selected isEqualToString:rec[@"name"]] ? @" ✓" : @""];
    [self.apiConnectButton setTitle:title forState:UIControlStateNormal];
}

- (void)confirmAndStartKernelMode:(NSString *)identifier displayName:(NSString *)displayName {
    NSString *message = [NSString stringWithFormat:
                         @"当前设备：%@\niOS：%@\n架构：%@\n\n选择：%@\n\n运行时初始化可能需要 1-3 分钟，过程中可能重启桌面。请先关闭后台游戏，成功后再打开游戏。",
                         [self currentMachineIdentifier],
                         UIDevice.currentDevice.systemVersion,
                         [self isCurrentDeviceArm64e] ? @"arm64e" : @"arm64",
                         displayName];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确认内核方案"
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) w = self;
    [ac addAction:[UIAlertAction actionWithTitle:@"开始初始化" style:UIAlertActionStyleDestructive handler:^(__unused UIAlertAction *action) {
        [w saveKernelModeIdentifier:identifier];
        [w updateKernelButtonTitle];
        [w startTrekRuntimeWithModeIdentifier:identifier displayName:displayName];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showKernelModePicker {
    NSDictionary *rec = [self recommendedKernelMode];
    NSString *message = [NSString stringWithFormat:@"当前设备：%@\niOS：%@\n架构：%@\n推荐：%@\n%@",
                         [self currentMachineIdentifier],
                         UIDevice.currentDevice.systemVersion,
                         [self isCurrentDeviceArm64e] ? @"arm64e" : @"arm64",
                         rec[@"name"],
                         rec[@"reason"]];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"内核利用方案"
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    __weak __typeof(self) w = self;
    void (^addMode)(NSString *, NSString *) = ^(NSString *title, NSString *identifier) {
        [ac addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [w confirmAndStartKernelMode:identifier displayName:title];
        }]];
    };

    addMode([NSString stringWithFormat:@"推荐：%@", rec[@"name"]], rec[@"id"]);
    addMode(@"自动推荐（Trek 默认）", @"");
    addMode(@"kfd physpuppet", @"com.opa334.kfd.physpuppet");
    addMode(@"kfd landa", @"com.opa334.kfd.landa");
    addMode(@"kfd smith（备用）", @"com.opa334.kfd.smith");
    addMode(@"weightBufs", @"com.opa334.weightBufs");
    addMode(@"multicast_bytecopy", @"com.opa334.multicast-bytecopy");
    addMode(@"palera1n roothide", @"com.roothide.palera1n.roothide");
    [ac addAction:[UIAlertAction actionWithTitle:@"只保存推荐，不初始化" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
        [w saveKernelModeIdentifier:rec[@"id"]];
        [w updateKernelButtonTitle];
        [w showToast:@"已保存推荐内核方案"];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    UIPopoverPresentationController *pop = ac.popoverPresentationController;
    if (pop) {
        pop.sourceView = self.apiConnectButton;
        pop.sourceRect = self.apiConnectButton.bounds;
    }
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)startTrekRuntimeWithModeIdentifier:(NSString *)identifier displayName:(NSString *)displayName {
    (void)identifier;
    SetHUDEnabled(NO);
    self.apiConnectButton.enabled = NO;
    [self.apiConnectButton setTitle:@"正在初始化内核..." forState:UIControlStateNormal];
    [self showToast:@"开始内核初始化，请不要切换游戏"];
    LFSNSLog(@"[TrekRuntime] manual start mode=%@", displayName);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *helperPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"TrekRuntime"];
        if (![[NSFileManager defaultManager] isExecutableFileAtPath:helperPath]) {
            LFSNSLog(@"[TrekRuntime] helper missing: %@", helperPath);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.apiConnectButton.enabled = YES;
                [self updateKernelButtonTitle];
                [self showToast:@"缺少 TrekRuntime，请重新安装"];
            });
            return;
        }

        const char *path = helperPath.fileSystemRepresentation;
        char *argv[] = {(char *)path, (char *)"trollengine-init", NULL};
        extern char **environ;
        pid_t pid = 0;
        int spawnErr = posix_spawn(&pid, path, NULL, NULL, argv, environ);
        if (spawnErr != 0) {
            LFSNSLog(@"[TrekRuntime] posix_spawn failed=%d", spawnErr);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.apiConnectButton.enabled = YES;
                [self updateKernelButtonTitle];
                [self showToast:[NSString stringWithFormat:@"初始化启动失败：%d", spawnErr]];
            });
            return;
        }

        int status = 0;
        int waitRet = waitpid(pid, &status, 0);
        LFSNSLog(@"[TrekRuntime] finished waitRet=%d status=%d", waitRet, status);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.apiConnectButton.enabled = YES;
            [self updateKernelButtonTitle];
            if (waitRet < 0) {
                [self showToast:@"初始化等待失败，请查看日志"];
            } else if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
                self.apiConnected = YES;
                [self showToast:@"内核初始化完成，请重新打开游戏"];
            } else {
                self.apiConnected = YES;
                LFSNSLog(@"[TrekRuntime] non-zero status treated as runtime handoff: %d", status);
                [self showToast:@"内核初始化已提交，请打开游戏确认 AOI"];
            }
        });
    });
}

- (BOOL)launchPUBGGame {
    NSArray<NSString *> *bundleIDs = @[
        @"com.tencent.tmgp.pubgmhd",
        @"com.tencent.tmgp.pubgm",
        @"com.tencent.ig",
        @"com.rekoo.pubgm"
    ];

    LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
    for (NSString *bundleID in bundleIDs) {
        if ([workspace openApplicationWithBundleID:bundleID]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)launchSMobaGame {
    // 王者荣耀主流版本 bundle ID
    NSArray<NSString *> *bundleIDs = @[
        @"com.tencent.tmgp.smoba",
        @"com.tencent.tmgp.smoba.qq",
        @"com.tencent.tmgp.smoba.wx"
    ];

    LSApplicationWorkspace *workspace = [LSApplicationWorkspace defaultWorkspace];
    for (NSString *bundleID in bundleIDs) {
        if ([workspace openApplicationWithBundleID:bundleID]) {
            return YES;
        }
    }
    return NO;
}

- (void)onGameTypeChanged:(UISegmentedControl *)sender {
    SHGameType type = (sender.selectedSegmentIndex == 0) ? SHGameTypePUBG : SHGameTypeSMoba;
    SHSetSelectedGameType(type);
    [self showToast:[NSString stringWithFormat:@"已选择: %@", SHGameTypeDisplayName(type)]];
}

- (void)onOpenGameTap:(UIButton *)sender {
    (void)sender;
    SetHUDEnabled(YES);
    BOOL launched = NO;
    SHGameType gameType = SHGetSelectedGameType();
    if (gameType == SHGameTypePUBG) {
        launched = [self launchPUBGGame];
    } else {
        launched = [self launchSMobaGame];
    }
    if (launched) {
        LFEnsureFloatingBallWindowShown();
        [[NSNotificationCenter defaultCenter] postNotificationName:kTSLaunchTransitionShowNotification object:nil];
        [self showToast:[NSString stringWithFormat:@"正在打开%@并开启绘制", SHGameTypeDisplayName(gameType)]];
    } else {
        [self showToast:[NSString stringWithFormat:@"未找到%@，请确认已安装", SHGameTypeDisplayName(gameType)]];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.apiConnected = NO;
    [self buildSimpleMainUI];

    // 恢复卡密登录界面：启动时始终展示
    LFVerifyView *verify = [[LFVerifyView alloc] initWithFrame:self.view.bounds];
    verify.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:verify];
}

#pragma mark - 背景（极简渐变）
- (void)buildGalaxyBackground{
  
    CAGradientLayer *g=[CAGradientLayer layer];
    g.frame=self.view.bounds;
    g.colors=@[(id)LF_STAR_DEEP1.CGColor,(id)LF_STAR_DEEP2.CGColor,(id)LF_STAR_DEEP3.CGColor];
    g.locations=@[@0.0,@0.55,@1.0]; g.startPoint=CGPointMake(0.1,0.0); g.endPoint=CGPointMake(0.9,1.0);
    [self.view.layer addSublayer:g];

    CAGradientLayer *band=[CAGradientLayer layer];
    band.colors=@[(id)[LF_STAR_NEBU1 colorWithAlphaComponent:0.0].CGColor,(id)LF_STAR_NEBU1.CGColor,(id)LF_STAR_NEBU2.CGColor,(id)[LF_STAR_NEBU2 colorWithAlphaComponent:0.0].CGColor];
    band.locations=@[@0.0,@0.35,@0.65,@1.0];
    CGFloat w=self.view.bounds.size.width, h=self.view.bounds.size.height;
    band.frame=CGRectMake(-w*0.2, h*0.15, w*1.4, h*0.45);
    band.cornerRadius=band.frame.size.height/2.0;
    band.transform=CATransform3DMakeRotation(-12.0/180.0*M_PI, 0, 0, 1);
    band.opacity=0.55;
    [self.view.layer addSublayer:band];

    // 移除粒子效果，采用更简洁的设计
}

#pragma mark - 顶部栏（容器 + 毛玻璃，防祖先冲突）
- (void)buildTopBar{
    UIView *bar=[UIView new]; bar.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:bar];
    UILayoutGuide *safe=self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [bar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bar.topAnchor constraintEqualToAnchor:safe.topAnchor],
        [bar.heightAnchor constraintEqualToConstant:56],
    ]];

    UIVisualEffectView *blur=[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blur.translatesAutoresizingMaskIntoConstraints=NO; [bar addSubview:blur];
    [NSLayoutConstraint activateConstraints:@[
        [blur.leadingAnchor constraintEqualToAnchor:bar.leadingAnchor],
        [blur.trailingAnchor constraintEqualToAnchor:bar.trailingAnchor],
        [blur.topAnchor constraintEqualToAnchor:bar.topAnchor],
        [blur.bottomAnchor constraintEqualToAnchor:bar.bottomAnchor],
    ]];
    blur.alpha=0.9; blur.layer.shadowOpacity=0.25; blur.layer.shadowRadius=8; blur.layer.shadowOffset=(CGSize){0,4};

    UILabel *title=LFMakeLabel(@"Troll Engine",[UIFont systemFontOfSize:28 weight:UIFontWeightLight],LF_TEXT);
    UILabel *sub=LFMakeLabel(@"强大 · 简洁 · 优雅",[UIFont systemFontOfSize:13 weight:UIFontWeightRegular],[LF_TEXT colorWithAlphaComponent:0.6]);

    UIStackView *titleBox=[UIStackView new]; titleBox.axis=UILayoutConstraintAxisVertical; titleBox.translatesAutoresizingMaskIntoConstraints=NO; titleBox.spacing=2;
    [titleBox addArrangedSubview:title]; [titleBox addArrangedSubview:sub];

    UIButton *help=[UIButton buttonWithType:UIButtonTypeSystem]; help.translatesAutoresizingMaskIntoConstraints=NO;
    [help setImage:[UIImage systemImageNamed:@"questionmark.circle"] forState:UIControlStateNormal]; help.tintColor=LF_TEXT;
    help.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.08]; help.layer.cornerRadius=10;
    [help.widthAnchor constraintEqualToConstant:34].active=YES; [help.heightAnchor constraintEqualToConstant:34].active=YES;

    [bar addSubview:titleBox]; [bar addSubview:help];
    [NSLayoutConstraint activateConstraints:@[
        [titleBox.leadingAnchor constraintEqualToAnchor:bar.leadingAnchor constant:16],
        [titleBox.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
        [help.trailingAnchor constraintEqualToAnchor:bar.trailingAnchor constant:-12],
        [help.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
    ]];

    [help addTarget:self action:@selector(showUserGuide) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *lp=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onHelpLongPress:)]; [help addGestureRecognizer:lp];
    UIButton *settings = [UIButton buttonWithType:UIButtonTypeSystem];
    settings.translatesAutoresizingMaskIntoConstraints = NO;
    [settings setImage:[UIImage systemImageNamed:@"gearshape"] forState:UIControlStateNormal];
    settings.tintColor = LF_TEXT;
    settings.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.08];
    settings.layer.cornerRadius = 10;
    [settings.widthAnchor constraintEqualToConstant:34].active = YES;
    [settings.heightAnchor constraintEqualToConstant:34].active = YES;

    [bar addSubview:settings];
    [NSLayoutConstraint activateConstraints:@[
        [settings.trailingAnchor constraintEqualToAnchor:help.leadingAnchor constant:-8],
        [settings.centerYAnchor constraintEqualToAnchor:bar.centerYAnchor],
    ]];
    [settings addTarget:self action:@selector(onToastBtn:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)onToastBtn:(UIButton *)b{
    SHIDCtrl *vc = [SHIDCtrl new];
       UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
       nav.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:nav animated:YES completion:nil];
    
    
    NSString *msg=[b.currentTitle containsString:@"重启"]?@"模拟重启：已发送指令":@"模拟启动：拉起游戏中";
    [self showToast:msg];
}
- (NSString *)currentKernelChoice {
    NSUbiquitousKeyValueStore *icloud = [NSUbiquitousKeyValueStore defaultStore];
    NSString *kernel = [icloud stringForKey:@"SelectedKernel"];
    if (!kernel) {
        kernel = @"physpuppet"; // 默认值
        [icloud setString:kernel forKey:@"SelectedKernel"];
        [icloud synchronize];
    }
    return kernel;
}

#pragma mark - 构建内容（数据驱动）
- (UIView *)buildRowFromConfig:(LFRowConfig *)c{
    if (c.type==LFRowTypeSwitch){
        UIView *row=[UIView new]; row.translatesAutoresizingMaskIntoConstraints=NO;
        UILabel *lab=LFMakeLabel(c.title,[UIFont systemFontOfSize:16 weight:UIFontWeightMedium],LF_TEXT);
        UISwitch *sw=[UISwitch new]; sw.translatesAutoresizingMaskIntoConstraints=NO; sw.on=LFGetBool(c.key, c.defBool); sw.onTintColor=[LF_ACCENT colorWithAlphaComponent:0.7]; sw.tag=(int)c.tag;
        [row addSubview:lab]; [row addSubview:sw];
        [NSLayoutConstraint activateConstraints:@[
            [lab.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12],
            [lab.centerYAnchor constraintEqualToAnchor:sw.centerYAnchor],
            [sw.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-12],
            [sw.topAnchor constraintEqualToAnchor:row.topAnchor constant:8],
            [sw.bottomAnchor constraintEqualToAnchor:row.bottomAnchor constant:-8],
        ]];
        [sw addTarget:self action:@selector(onAnySwitch:) forControlEvents:UIControlEventValueChanged];
        c.sw = sw;
        return row;
    }else if (c.type==LFRowTypeSlider){
        UIView *row=[UIView new]; row.translatesAutoresizingMaskIntoConstraints=NO;

        // 读取并规范化初值（夹取 + 按步进对齐）
        float initv = (float)LFGetDouble(c.key, c.defFloat);
        float clamped = LFClamp(initv, c.minv, c.maxv);
        float snapped = LFSnap(clamped, c.minv, c.step);
        if (fabsf(snapped - initv) > 1e-4f) {  // 修正存储里的越界/非对齐值
            LFSetDouble(c.key, snapped);
        }

        UILabel *lab=LFMakeLabel(c.title,[UIFont systemFontOfSize:16 weight:UIFontWeightMedium],LF_TEXT);
        UILabel *val=LFMakeLabel(LFFormatFloat(snapped, c.decimals),
                                 [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightSemibold],
                                 [LF_TEXT colorWithAlphaComponent:0.9]);

        UISlider *s=[UISlider new]; s.translatesAutoresizingMaskIntoConstraints=NO;
        s.minimumValue=c.minv; s.maximumValue=c.maxv; s.value=snapped; s.continuous=YES;
        s.minimumTrackTintColor=LF_ACCENT; s.maximumTrackTintColor=[[UIColor whiteColor] colorWithAlphaComponent:0.15];
        s.tag=(int)c.tag;

        [row addSubview:lab]; [row addSubview:val]; [row addSubview:s];
        [NSLayoutConstraint activateConstraints:@[
            [lab.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12],
            [lab.centerYAnchor constraintEqualToAnchor:val.centerYAnchor],
            [val.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-12],
            [val.topAnchor constraintEqualToAnchor:row.topAnchor constant:10],
            [s.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12],
            [s.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-12],
            [s.topAnchor constraintEqualToAnchor:val.bottomAnchor constant:8],
            [s.bottomAnchor constraintEqualToAnchor:row.bottomAnchor constant:-10],
        ]];

        [s addTarget:self action:@selector(onAnySlider:) forControlEvents:UIControlEventValueChanged];
        c.valueLabel=val; c.slider=s;
        return row;
    } else { // ✅ 分段选择器
        UIView *row=[UIView new]; row.translatesAutoresizingMaskIntoConstraints=NO;

        UILabel *lab=LFMakeLabel(c.title, [UIFont systemFontOfSize:16 weight:UIFontWeightMedium], LF_TEXT);
        UISegmentedControl *seg=[[UISegmentedControl alloc] initWithItems:c.segmentItems ?: @[]];
        seg.translatesAutoresizingMaskIntoConstraints=NO;
        seg.selectedSegmentIndex = (int)LFGetInt(c.key, c.defIndex);
        seg.tag=(int)c.tag;

        [row addSubview:lab];
        [row addSubview:seg];

        [NSLayoutConstraint activateConstraints:@[
            [lab.leadingAnchor constraintEqualToAnchor:row.leadingAnchor constant:12],
            [lab.centerYAnchor constraintEqualToAnchor:seg.centerYAnchor],

            [seg.trailingAnchor constraintEqualToAnchor:row.trailingAnchor constant:-12],
            [seg.topAnchor constraintEqualToAnchor:row.topAnchor constant:8],
            [seg.bottomAnchor constraintEqualToAnchor:row.bottomAnchor constant:-8],
            [seg.leadingAnchor constraintGreaterThanOrEqualToAnchor:lab.trailingAnchor constant:8],
        ]];

        [seg addTarget:self action:@selector(onAnySegment:) forControlEvents:UIControlEventValueChanged];
        c.segment = seg;
        return row;
    }
}

- (LFAccordionCard *)buildSection:(NSString *)title rows:(NSArray<LFRowConfig*>*)rows{
    LFAccordionCard *acc=[[LFAccordionCard alloc] initWithTitle:title];
    for (LFRowConfig *c in rows){
        UIView *row=[self buildRowFromConfig:c];
        [acc.contentStack addArrangedSubview:row];
        self.cfgMap[@(c.tag)] = c;
        if (c.key) [self.allKeys addObject:c.key];
    }
    return acc;
}
// ====== Key ======
static NSString *const kLF_ExpireText = @"lf.expire.text";

// ====== 写入 ======
void LFExpireWriteText(NSString *expText) {
    if (!expText) return;
    // 仅用本地，不依赖 iCloud 权限，安全不崩
    [[NSUserDefaults standardUserDefaults] setObject:expText forKey:kLF_ExpireText];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

NSString *LFExpireReadText(void) {
    NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:kLF_ExpireText];
    return s ?: @""; // 没写过就返回空串
}

// ====== 解析到期时间（格式：yyyy-MM-dd HH:mm）======
static NSDate *LFParseExpireDate(NSString *text) {
    if (text.length == 0) return nil;
    static NSDateFormatter *fmt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        fmt.timeZone = [NSTimeZone localTimeZone];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    });
    return [fmt dateFromString:text];
}
// MobileGestalt 函数定义已移到文件前面（第77-88行），此处不再重复定义
__attribute__((always_inline)) void CleanupMobileGestalt(void) {
    if (gestaltHandle) {
        dlclose(gestaltHandle);
        gestaltHandle = NULL;
        MGCopyAnswerFunc = NULL;
    }
}


static NSDictionary<NSString*, NSString*> *LFBaseMap(void) {
    static NSDictionary<NSString*, NSString*> *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
            // ==== iPhone (1st -> 16 series) ====
            @"iPhone1,1": @"iPhone (1st gen)",
            @"iPhone1,2": @"iPhone 3G",
            @"iPhone2,1": @"iPhone 3GS",
            @"iPhone3,1": @"iPhone 4", @"iPhone3,2": @"iPhone 4", @"iPhone3,3": @"iPhone 4 (CDMA)",
            @"iPhone4,1": @"iPhone 4S",
            @"iPhone5,1": @"iPhone 5 (GSM)", @"iPhone5,2": @"iPhone 5 (Global)",
            @"iPhone5,3": @"iPhone 5c (GSM)", @"iPhone5,4": @"iPhone 5c (Global)",
            @"iPhone6,1": @"iPhone 5s (GSM)", @"iPhone6,2": @"iPhone 5s (Global)",
            @"iPhone7,1": @"iPhone 6 Plus", @"iPhone7,2": @"iPhone 6",
            @"iPhone8,1": @"iPhone 6s", @"iPhone8,2": @"iPhone 6s Plus", @"iPhone8,4": @"iPhone SE (1st gen)",
            @"iPhone9,1": @"iPhone 7", @"iPhone9,3": @"iPhone 7",
            @"iPhone9,2": @"iPhone 7 Plus", @"iPhone9,4": @"iPhone 7 Plus",
            @"iPhone10,1": @"iPhone 8", @"iPhone10,4": @"iPhone 8",
            @"iPhone10,2": @"iPhone 8 Plus", @"iPhone10,5": @"iPhone 8 Plus",
            @"iPhone10,3": @"iPhone X", @"iPhone10,6": @"iPhone X",
            @"iPhone11,2": @"iPhone XS", @"iPhone11,4": @"iPhone XS Max", @"iPhone11,6": @"iPhone XS Max", @"iPhone11,8": @"iPhone XR",
            @"iPhone12,1": @"iPhone 11", @"iPhone12,3": @"iPhone 11 Pro", @"iPhone12,5": @"iPhone 11 Pro Max",
            @"iPhone12,8": @"iPhone SE (2nd gen)",
            @"iPhone13,1": @"iPhone 12 mini", @"iPhone13,2": @"iPhone 12", @"iPhone13,3": @"iPhone 12 Pro", @"iPhone13,4": @"iPhone 12 Pro Max",
            // iPhone 13 series
            @"iPhone14,4": @"iPhone 13 mini",
            @"iPhone14,5": @"iPhone 13",
            @"iPhone14,2": @"iPhone 13 Pro",
            @"iPhone14,3": @"iPhone 13 Pro Max",
            // iPhone SE (3rd)
            @"iPhone14,6": @"iPhone SE (3rd gen)",
            // iPhone 14 series
            @"iPhone14,7": @"iPhone 14",
            @"iPhone14,8": @"iPhone 14 Plus",
            @"iPhone15,2": @"iPhone 14 Pro",
            @"iPhone15,3": @"iPhone 14 Pro Max",
            // iPhone 15 series
            @"iPhone15,4": @"iPhone 15",
            @"iPhone15,5": @"iPhone 15 Plus",
            @"iPhone16,2": @"iPhone 15 Pro",
            @"iPhone16,1": @"iPhone 15 Pro Max",
            // iPhone 16 series (A18/Pro)
            @"iPhone17,3": @"iPhone 16",
            @"iPhone17,4": @"iPhone 16 Plus",
            @"iPhone17,1": @"iPhone 16 Pro",
            @"iPhone17,2": @"iPhone 16 Pro Max",

            // ==== iPad (含 mini / Air / Pro，主流机型) ====
            @"iPad1,1": @"iPad (1st gen)",
            @"iPad2,1": @"iPad 2 (Wi-Fi)", @"iPad2,2": @"iPad 2 (GSM)", @"iPad2,3": @"iPad 2 (CDMA)", @"iPad2,4": @"iPad 2 (rev)",
            @"iPad3,1": @"iPad (3rd gen) Wi-Fi", @"iPad3,2": @"iPad (3rd gen) 4G", @"iPad3,3": @"iPad (3rd gen) 4G",
            @"iPad3,4": @"iPad (4th gen) Wi-Fi", @"iPad3,5": @"iPad (4th gen) 4G", @"iPad3,6": @"iPad (4th gen) 4G",
            // iPad mini
            @"iPad2,5": @"iPad mini (1st gen) Wi-Fi", @"iPad2,6": @"iPad mini (1st gen) GSM", @"iPad2,7": @"iPad mini (1st gen) Global",
            @"iPad4,4": @"iPad mini 2 Wi-Fi", @"iPad4,5": @"iPad mini 2 Cellular", @"iPad4,6": @"iPad mini 2 (China)",
            @"iPad4,7": @"iPad mini 3 Wi-Fi", @"iPad4,8": @"iPad mini 3 Cellular", @"iPad4,9": @"iPad mini 3 (China)",
            @"iPad5,1": @"iPad mini 4 Wi-Fi", @"iPad5,2": @"iPad mini 4 Cellular",
            @"iPad11,1": @"iPad mini (5th gen) Wi-Fi", @"iPad11,2": @"iPad mini (5th gen) Cellular",
            @"iPad14,1": @"iPad mini (6th gen) Wi-Fi", @"iPad14,2": @"iPad mini (6th gen) Cellular",
            // iPad Air
            @"iPad4,1": @"iPad Air (1st gen) Wi-Fi", @"iPad4,2": @"iPad Air (1st gen) Cellular", @"iPad4,3": @"iPad Air (1st gen, China)",
            @"iPad5,3": @"iPad Air 2 Wi-Fi", @"iPad5,4": @"iPad Air 2 Cellular",
            @"iPad11,3": @"iPad Air (3rd gen) Wi-Fi", @"iPad11,4": @"iPad Air (3rd gen) Cellular",
            @"iPad13,1": @"iPad Air (4th gen) Wi-Fi", @"iPad13,2": @"iPad Air (4th gen) Cellular",
            @"iPad13,16": @"iPad Air (5th gen) Wi-Fi", @"iPad13,17": @"iPad Air (5th gen) Cellular",
            @"iPad14,8": @"iPad Air 11-inch (M2) Wi-Fi", @"iPad14,9": @"iPad Air 11-inch (M2) Cellular",
            @"iPad14,10": @"iPad Air 13-inch (M2) Wi-Fi", @"iPad14,11": @"iPad Air 13-inch (M2) Cellular",
            // iPad（无后缀）
            @"iPad6,11": @"iPad (5th gen) Wi-Fi", @"iPad6,12": @"iPad (5th gen) Cellular",
            @"iPad7,5": @"iPad (6th gen) Wi-Fi", @"iPad7,6": @"iPad (6th gen) Cellular",
            @"iPad7,11": @"iPad (7th gen) Wi-Fi", @"iPad7,12": @"iPad (7th gen) Cellular",
            @"iPad11,6": @"iPad (8th gen) Wi-Fi", @"iPad11,7": @"iPad (8th gen) Cellular",
            @"iPad12,1": @"iPad (9th gen) Wi-Fi", @"iPad12,2": @"iPad (9th gen) Cellular",
            @"iPad13,18": @"iPad (10th gen) Wi-Fi", @"iPad13,19": @"iPad (10th gen) Cellular",
            // iPad Pro 9.7/10.5/11/12.9 & M1/M2/M4
            @"iPad6,3": @"iPad Pro 9.7-inch Wi-Fi", @"iPad6,4": @"iPad Pro 9.7-inch Cellular",
            @"iPad7,3": @"iPad Pro 10.5-inch Wi-Fi", @"iPad7,4": @"iPad Pro 10.5-inch Cellular",
            @"iPad8,1": @"iPad Pro 11-inch (1st) Wi-Fi", @"iPad8,2": @"iPad Pro 11-inch (1st) Wi-Fi (TB)",
            @"iPad8,3": @"iPad Pro 11-inch (1st) Cellular", @"iPad8,4": @"iPad Pro 11-inch (1st) Cellular (TB)",
            @"iPad8,5": @"iPad Pro 12.9-inch (3rd) Wi-Fi", @"iPad8,6": @"iPad Pro 12.9-inch (3rd) Wi-Fi (TB)",
            @"iPad8,7": @"iPad Pro 12.9-inch (3rd) Cellular", @"iPad8,8": @"iPad Pro 12.9-inch (3rd) Cellular (TB)",
            @"iPad8,9": @"iPad Pro 11-inch (2nd) Wi-Fi", @"iPad8,10": @"iPad Pro 11-inch (2nd) Cellular",
            @"iPad8,11": @"iPad Pro 12.9-inch (4th) Wi-Fi", @"iPad8,12": @"iPad Pro 12.9-inch (4th) Cellular",
            @"iPad13,4": @"iPad Pro 11-inch (3rd) Wi-Fi", @"iPad13,5": @"iPad Pro 11-inch (3rd) Wi-Fi (TB)",
            @"iPad13,6": @"iPad Pro 11-inch (3rd) Cellular", @"iPad13,7": @"iPad Pro 11-inch (3rd) Cellular (TB)",
            @"iPad13,8": @"iPad Pro 12.9-inch (5th) Wi-Fi", @"iPad13,9": @"iPad Pro 12.9-inch (5th) Wi-Fi (TB)",
            @"iPad13,10": @"iPad Pro 12.9-inch (5th) Cellular", @"iPad13,11": @"iPad Pro 12.9-inch (5th) Cellular (TB)",
            @"iPad14,3": @"iPad Pro 11-inch (4th) Wi-Fi", @"iPad14,4": @"iPad Pro 11-inch (4th) Cellular",
            @"iPad14,5": @"iPad Pro 12.9-inch (6th) Wi-Fi", @"iPad14,6": @"iPad Pro 12.9-inch (6th) Cellular",
            // M4（2024）
            @"iPad16,3": @"iPad Pro 11-inch (M4) Wi-Fi", @"iPad16,4": @"iPad Pro 11-inch (M4) Cellular",
            @"iPad16,5": @"iPad Pro 13-inch (M4) Wi-Fi", @"iPad16,6": @"iPad Pro 13-inch (M4) Cellular",

            // ==== iPod touch ====
            @"iPod1,1": @"iPod touch (1st gen)",
            @"iPod2,1": @"iPod touch (2nd gen)",
            @"iPod3,1": @"iPod touch (3rd gen)",
            @"iPod4,1": @"iPod touch (4th gen)",
            @"iPod5,1": @"iPod touch (5th gen)",
            @"iPod7,1": @"iPod touch (6th gen)",
            @"iPod9,1": @"iPod touch (7th gen)",

            // ==== Apple Watch ====
            @"Watch1,1": @"Apple Watch (1st gen) 38mm", @"Watch1,2": @"Apple Watch (1st gen) 42mm",
            @"Watch2,6": @"Apple Watch Series 1 38mm", @"Watch2,7": @"Apple Watch Series 1 42mm",
            @"Watch2,3": @"Apple Watch Series 2 42mm", @"Watch2,4": @"Apple Watch Series 2 38mm",
            @"Watch3,1": @"Apple Watch Series 3 (Cellular) 38mm", @"Watch3,2": @"Apple Watch Series 3 (Cellular) 42mm",
            @"Watch3,3": @"Apple Watch Series 3 (GPS) 38mm", @"Watch3,4": @"Apple Watch Series 3 (GPS) 42mm",
            @"Watch4,1": @"Apple Watch Series 4 (GPS) 40mm", @"Watch4,2": @"Apple Watch Series 4 (GPS) 44mm",
            @"Watch4,3": @"Apple Watch Series 4 (Cellular) 40mm", @"Watch4,4": @"Apple Watch Series 4 (Cellular) 44mm",
            @"Watch5,1": @"Apple Watch Series 5 (GPS) 40mm", @"Watch5,2": @"Apple Watch Series 5 (GPS) 44mm",
            @"Watch5,3": @"Apple Watch Series 5 (Cellular) 40mm", @"Watch5,4": @"Apple Watch Series 5 (Cellular) 44mm",
            @"Watch5,9": @"Apple Watch SE (1st) 40mm (GPS)", @"Watch5,10": @"Apple Watch SE (1st) 44mm (GPS)",
            @"Watch5,11": @"Apple Watch SE (1st) 40mm (Cellular)", @"Watch5,12": @"Apple Watch SE (1st) 44mm (Cellular)",
            @"Watch6,1": @"Apple Watch Series 6 (GPS) 40mm", @"Watch6,2": @"Apple Watch Series 6 (GPS) 44mm",
            @"Watch6,3": @"Apple Watch Series 6 (Cellular) 40mm", @"Watch6,4": @"Apple Watch Series 6 (Cellular) 44mm",
            @"Watch6,6": @"Apple Watch Series 7 (GPS) 41mm", @"Watch6,7": @"Apple Watch Series 7 (GPS) 45mm",
            @"Watch6,8": @"Apple Watch Series 7 (Cellular) 41mm", @"Watch6,9": @"Apple Watch Series 7 (Cellular) 45mm",
            @"Watch6,10": @"Apple Watch SE (2nd) 40mm (GPS)", @"Watch6,11": @"Apple Watch SE (2nd) 44mm (GPS)",
            @"Watch6,12": @"Apple Watch SE (2nd) 40mm (Cellular)", @"Watch6,13": @"Apple Watch SE (2nd) 44mm (Cellular)",
            @"Watch6,14": @"Apple Watch Series 8 (GPS) 41mm", @"Watch6,15": @"Apple Watch Series 8 (GPS) 45mm",
            @"Watch6,16": @"Apple Watch Series 8 (Cellular) 41mm", @"Watch6,17": @"Apple Watch Series 8 (Cellular) 45mm",
            @"Watch6,18": @"Apple Watch Ultra (49mm)",
            @"Watch6,20": @"Apple Watch Series 9 (GPS) 41mm", @"Watch6,21": @"Apple Watch Series 9 (GPS) 45mm",
            @"Watch6,22": @"Apple Watch Series 9 (Cellular) 41mm", @"Watch6,23": @"Apple Watch Series 9 (Cellular) 45mm",
            @"Watch6,24": @"Apple Watch Ultra 2 (49mm)",

            // ==== Apple TV ====
            @"AppleTV2,1": @"Apple TV (2nd gen)",
            @"AppleTV3,1": @"Apple TV (3rd gen)", @"AppleTV3,2": @"Apple TV (3rd gen, rev)",
            @"AppleTV5,3": @"Apple TV (4th gen / HD)",
            @"AppleTV6,2": @"Apple TV 4K (1st gen)",
            @"AppleTV11,1": @"Apple TV 4K (3rd gen)", // 2022 & 2024 refresh 都归到 11,1

            // ==== HomePod ====
            @"AudioAccessory1,1": @"HomePod (1st gen)", @"AudioAccessory1,2": @"HomePod (1st gen, China)",
            @"AudioAccessory5,1": @"HomePod (2nd gen)",
            @"AudioAccessory6,1": @"HomePod mini",

            // ==== Vision ====
            @"RealityDevice1,1": @"Apple Vision Pro",

            // ==== Simulator / 其他 ====
            @"x86_64": @"Simulator",
            @"i386": @"Simulator",
            @"arm64": @"Simulator (Apple Silicon)",
        };
    });
    return map;
}
static NSMutableDictionary<NSString*, NSString*> *LFOverrides(void) {
    static NSMutableDictionary<NSString*, NSString*> *ovr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ovr = [NSMutableDictionary new];
    });
    return ovr;
}

NSString *LFMarketNameFromProductType(NSString *pt) {
    if (pt.length == 0) return @"Unknown";
    NSString *name = nil;

    // 1) 先看覆盖
    @synchronized (LFOverrides()) {
        name = LFOverrides()[pt];
    }
    if (name.length) return name;

    // 2) 基础表
    name = LFBaseMap()[pt];
    if (name.length) return name;

    // 3) 简单前缀回退（类别名）
    if ([pt hasPrefix:@"iPhone"]) return pt;          // 未知新机，先回代号
    if ([pt hasPrefix:@"iPad"]) return pt;
    if ([pt hasPrefix:@"iPod"]) return @"iPod touch";
    if ([pt hasPrefix:@"Watch"]) return @"Apple Watch";
    if ([pt hasPrefix:@"AppleTV"]) return @"Apple TV";
    if ([pt hasPrefix:@"AudioAccessory"]) return @"HomePod";
    if ([pt hasPrefix:@"Reality"]) return @"Apple Vision";

    // 4) 实在不认识就返回原代号
    return pt;
}


- (void)buildContent{
    
    self.cfgMap = [NSMutableDictionary dictionary];
    self.allKeys = [NSMutableOrderedSet orderedSet];

    _scroll=[UIScrollView new]; _scroll.translatesAutoresizingMaskIntoConstraints=NO;
    _stack=[UIStackView new]; _stack.axis=UILayoutConstraintAxisVertical; _stack.spacing=12; _stack.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addSubview:_scroll]; [_scroll addSubview:_stack];
    NSString* (^GetMobileGestalt)(CFStringRef) = ^NSString* (CFStringRef key) {
        InitializeMobileGestaltIfNeeded();
        if (!MGCopyAnswerFunc) {
            CleanupMobileGestalt();
            return @"";
        }
        return CFBridgingRelease(MGCopyAnswerFunc(key));
    };
    UILayoutGuide *g=self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [_scroll.topAnchor constraintEqualToAnchor:g.topAnchor constant:56],
        [_scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [_scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [_stack.topAnchor constraintEqualToAnchor:_scroll.topAnchor constant:12],
        [_stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:12],
        [_stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-12],
        [_stack.bottomAnchor constraintEqualToAnchor:_scroll.bottomAnchor constant:-20],
        [_stack.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-24],
    ]];

    // 设备信息（静态卡）
    {
        UIView *card=LFCardContainer();
        UIStackView *v=[UIStackView new]; v.axis=UILayoutConstraintAxisVertical; v.spacing=8; v.translatesAutoresizingMaskIntoConstraints=NO;
        UILabel *t=LFMakeLabel(@"TG@songshu1221",[UIFont systemFontOfSize:18 weight:UIFontWeightSemibold],LF_TEXT);
        UILabel *l1=LFMakeLabel([NSString stringWithFormat:@"到期时间：%@", LFExpireReadText()],[UIFont systemFontOfSize:14],LF_TEXT_SUB);
        UILabel *l2=LFMakeLabel([NSString stringWithFormat:@"系统：iOS %@",UIDevice.currentDevice.systemVersion],[UIFont systemFontOfSize:14],LF_TEXT_SUB);
        UILabel *l3=LFMakeLabel([NSString stringWithFormat:@"序列号：%@", GetMobileGestalt(CFSTR("SerialNumber"))],[UIFont systemFontOfSize:14],LF_TEXT_SUB);
        UILabel *l4=LFMakeLabel([NSString stringWithFormat:@"UDID：%@", GetMobileGestalt(CFSTR("UniqueDeviceID"))],[UIFont systemFontOfSize:14],LF_TEXT_SUB);
        UILabel *l5=LFMakeLabel([NSString stringWithFormat:@"设备型号：%@", LFMarketNameFromProductType(GetMobileGestalt(CFSTR("ProductType")))],[UIFont systemFontOfSize:14],LF_TEXT_SUB);
//
        UIStackView *btns=[UIStackView new]; btns.axis=UILayoutConstraintAxisHorizontal; btns.spacing=12; btns.distribution=UIStackViewDistributionFillEqually; btns.translatesAutoresizingMaskIntoConstraints=NO;
        UIButton *bReboot=LFMakeButton(@"自瞄标识符",[UIImage systemImageNamed:@"gearshape.fill"]);
       bHUD   =LFMakeButton(@"加载绘制",[UIImage systemImageNamed:@"wand.and.stars"]);
        [bReboot addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
        // 点击即切换 HUD：未开启->开启，已开启->关闭
        [bHUD addTarget:self action:@selector(onToggleHUD:) forControlEvents:UIControlEventTouchUpInside];

        [btns addArrangedSubview:bReboot];
        [btns addArrangedSubview:bHUD];
        
        [v addArrangedSubview:t]; [v addArrangedSubview:l1]; [v addArrangedSubview:l2]; [v addArrangedSubview:l3]; [v addArrangedSubview:l4]; [v addArrangedSubview:l5];
        
        [v addArrangedSubview:LFMakeSpacer(6)]; [v addArrangedSubview:btns];

        [card addSubview:v];
        [NSLayoutConstraint activateConstraints:@[
            [v.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:14],
            [v.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-14],
            [v.topAnchor constraintEqualToAnchor:card.topAnchor constant:14],
            [v.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-14],
        ]];
        [_stack addArrangedSubview:card];
    }

    // 基础功能（折叠）
    {
        NSArray *rows=@[
            
            LFSwitchRow(@" 防录屏",  直播,     NO),
            LFSwitchRow(@" 血量",      血量,     NO),
            LFSwitchRow(@" 方框",      方框,     NO),
            LFSwitchRow(@" 掩体判断",  掩体判断, NO),
            LFSwitchRow(@" 人数",      人数,     NO),
            LFSwitchRow(@" 射线",      射线,      NO),
            LFSwitchRow(@" 骨骼",      骨骼, NO),
            LFSwitchRow(@" 信息",      信息,      NO),
            LFSwitchRow(@" 手持",  手持,     NO),
            LFSwitchRow(@" 距离",  距离,     NO),
            LFSwitchRow(@" 背敌",  背敌,     NO),
            LFSwitchRow(@" 射线",  背后射线,     NO),
            LFSwitchRow(@" 隐藏",  人机隐藏,     NO),
            LFSwitchRow(@" 人机",  人机,     NO),
            
            
        ];
        [_stack addArrangedSubview:[self buildSection:@"绘制" rows:rows]];
    }

    // 功能调节（折叠）
    {
        NSArray *rows=@[
            LFSwitchRow(@" 地铁物资",   地铁物资, NO),
            LFSwitchRow(@" 地铁盒子",   地铁盒子, NO),
            LFSwitchRow(@" 盒内物资",   盒内物资, NO),
            LFSwitchRow(@" 显示瞄具",   瞄具, NO),
            LFSwitchRow(@" 显示防具",   防具, NO),
            LFSwitchRow(@" 显示药品",   药品, NO),
            LFSwitchRow(@" 显示盒子",   盒子, NO),
            LFSwitchRow(@" 显示空投",   空投, NO),
            LFSwitchRow(@" 显示载具",   载具, NO),
            LFSwitchRow(@" 手雷预警",   预警, NO),
            LFSwitchRow(@" 显示武器",   武器, NO),
            LFSwitchRow(@" 显示子弹",   子弹, NO),
            LFSwitchRow(@" 显示配件",   配件, NO),
            LFSwitchRow(@" 显示投掷",   投掷物, NO),
        ];
        [_stack addArrangedSubview:[self buildSection:@"物资" rows:rows]];
    }

    // 自瞄配置（折叠）
    {
        NSArray *rows=@[
            LFSwitchRow(@" 自瞄开关",   自瞄, NO),
            LFSwitchRow(@" 自瞄连线",   自瞄连线, NO),
            LFSwitchRow(@" 倒地自瞄",   倒地自瞄, NO),
            LFSegmentRow(@" 自瞄位置",   打击位置, (@[@"头部", @"胸部",@"腰部"]), 0),
            LFSegmentRow(@" 自瞄圆圈",   自瞄圆圈模式, (@[@"动态", @"静态",@"关闭"]), 0),
            
            LFSliderRow(@" 自瞄大小", 自瞄大小,   10, 250, 60),
            LFSliderRow(@" 自瞄速度(数值越小速度越快)",      自瞄速度, 20, 100, 26),
            LFSliderRowD(@" 压枪力度",      压枪力度, 0.0f, 2.0f, 0.9f, 0.05f, 2),  // 0.05 步进，保留两位小数
            LFSliderRow(@" 自瞄距离",      自瞄距离, 0, 200, 100),
            LFSliderRow(@" 腰射距离",      腰射距离, 0, 50, 60),
            
          
        ];
        [_stack addArrangedSubview:[self buildSection:@"自瞄功能（开发中）" rows:rows]];
    }

    //开发者功能 - 只有作者才显示
    if (LFIsAuthor()) {
        NSArray *rows=@[
            // [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究
            // LFSwitchRow(@" ImGui悬浮窗",   ImGui悬浮窗, NO),
            LFSwitchRow(@" 调试日志（开发中）",   调试日志, YES),
            LFSwitchRow(@" 链接deepseek（开发中）",   链接deepseek, NO),
            LFSwitchRow(@" pak美化（开发中）",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
            LFSwitchRow(@" 开发中",   开发中, NO),
        ];
        [_stack addArrangedSubview:[self buildSection:@"无敌开发者（制作中）" rows:rows]];
    }
    // About（静态）
    {
        UIView *card = LFCardContainer();
        UIStackView *v = [UIStackView new]; v.axis = UILayoutConstraintAxisVertical; v.spacing = 6; v.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *t   = LFMakeLabel(@"关于", [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold], LF_TEXT);
        UILabel *ack = LFMakeLabel(@"致谢：c22dev · opa334 · i_82 · Lessica · felix-pb", [UIFont systemFontOfSize:13], LF_TEXT_SUB);
        UILabel *vul = LFMakeLabel(@"涉及漏洞：CVE-2023-23536 / CVE-2023-32434 / CVE-2023-41974", [UIFont systemFontOfSize:13], LF_TEXT_SUB);
        UILabel *cp  = LFMakeLabel(@"版权：© 2025 Troll Engine · 保留所有权利。", [UIFont systemFontOfSize:13], LF_TEXT_SUB);

        [v addArrangedSubview:t];
        [v addArrangedSubview:ack];
        [v addArrangedSubview:vul];
        [v addArrangedSubview:cp];

        [card addSubview:v]; [_stack addArrangedSubview:card];
        [NSLayoutConstraint activateConstraints:@[
            [v.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:12],
            [v.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-12],
            [v.topAnchor constraintEqualToAnchor:card.topAnchor constant:12],
            [v.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-12],
        ]];
    }
}

#pragma mark - 交互
- (void)onAnySegment:(UISegmentedControl *)seg{
    LFRowConfig *c = self.cfgMap[@(seg.tag)];
    if (!c) return;
    LFSetInt(c.key, seg.selectedSegmentIndex);
    // 可选：提示或联动
     [self showToast:[NSString stringWithFormat:@"%@：%@", c.title, [c.segmentItems objectAtIndex:seg.selectedSegmentIndex]]];
}
- (void)onAnySwitch:(UISwitch *)sw{
    LFRowConfig *c = self.cfgMap[@(sw.tag)];
    if (!c) return;
    LFSetBool(c.key, sw.on);
    
    // [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究
    /*
    // 处理ImGui悬浮窗开关
    if ([c.key isEqualToString:ImGui悬浮窗]) {
        LFSNSLog(@"[SHEntryCtrl] ImGui悬浮窗开关切换: %@", sw.on ? @"开启" : @"关闭");
        [self handleImGuiFloatingWindowToggle:sw.on];
    }
    */
}
- (void)onAnySlider:(UISlider *)s{
    LFRowConfig *c = self.cfgMap[@(s.tag)];
    if (!c) return;

    float snapped = LFSnap(s.value, c.minv, c.step);
    snapped = LFClamp(snapped, c.minv, c.maxv);
    if (fabsf(snapped - s.value) > 1e-4f) s.value = snapped;  // 对齐可见值

    LFSetDouble(c.key, snapped);
    if (c.valueLabel) c.valueLabel.text = LFFormatFloat(snapped, c.decimals);
}

- (void)showSettings:(UIButton *)sender {
    SHIDCtrl *vc = [SHIDCtrl new];
       UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
       nav.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)saveKernelChoice:(NSString *)kernel {
    NSUbiquitousKeyValueStore *icloud = [NSUbiquitousKeyValueStore defaultStore];
    [icloud setString:kernel forKey:@"SelectedKernel"];
    [icloud synchronize]; // 立即同步

    NSLog(@"已保存内核选择: %@", kernel);
}



//- (void)onToggleHUD:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    BOOL on = sender.selected;
//    SetHUDEnabled(on);
//
//    NSString *title = on ? @"关闭绘制" : @"加载绘制";
//    [sender setTitle:title forState:UIControlStateNormal];
//    [sender setTitleColor:LF_TEXT forState:UIControlStateNormal]; // 固定文字颜色
//    [sender setBackgroundColor:[LFHex(0x1380A8,1) colorWithAlphaComponent:0.26]];
//    // 不改图片/背景
//    
//    [self showToast:(on ? @"已加载绘制（HUD 开启）" : @"已卸载绘制（HUD 关闭）")];
//}

- (void)onToggleHUD:(UIButton *)sender {
    sender.selected = !sender.selected;     // 切换 UI 状态
    BOOL on = sender.selected;
   
    SetHUDEnabled(on);           // 切换 HUD 覆盖

    // 跟随状态改字（可选也改图标）
    NSString *title = (on ? @"关闭绘制" : @"加载绘制");
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setImage:[UIImage systemImageNamed:(on ? @"xmark.circle" : @"wand.and.stars")]
             forState:UIControlStateNormal];

    NSString *toastMsg = (on ? @"开启成功）" : @"关闭");
    [self showToast:toastMsg];
}

#pragma mark - 云端变化刷新
- (void)onCloudChanged:(NSNotification *)n{
    for (NSNumber *k in self.cfgMap){
        LFRowConfig *c = self.cfgMap[k];
        if (c.type==LFRowTypeSwitch){
            BOOL v = LFGetBool(c.key, c.defBool);
            if (c.sw) c.sw.on = v;
            
            // [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究
            /*
            // 如果ImGui悬浮窗开关从云端同步，同步更新显示状态
            if ([c.key isEqualToString:ImGui悬浮窗]) {
                LFSNSLog(@"[SHEntryCtrl] ImGui悬浮窗从云端同步: %@", v ? @"开启" : @"关闭");
                [self handleImGuiFloatingWindowToggle:v];
            }
            */
        } else if (c.type==LFRowTypeSlider){
            float v = (float)LFGetDouble(c.key, c.defFloat);
            if (c.slider) c.slider.value = v;
            if (c.valueLabel) c.valueLabel.text = [NSString stringWithFormat:@"%.0f", v];
        } else if (c.type==LFRowTypeSegment){   // ✅ 新增
            NSInteger idx = LFGetInt(c.key, c.defIndex);
            if (c.segment) c.segment.selectedSegmentIndex = (int)idx;
        }
    }
}

#pragma mark - 使用说明/重置
- (void)showUserGuide{
    LFUserGuideSheet *sheet=[LFUserGuideSheet new];
    [self.view addSubview:sheet];
}
- (void)onHelpLongPress:(UILongPressGestureRecognizer *)gr{
    if (gr.state != UIGestureRecognizerStateBegan) return;
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:@"重置确认" message:@"将清除所有 iCloud & 本地配置并恢复默认。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak __typeof(self) w=self;
    [ac addAction:[UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [w resetAllSettings];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}
- (void)resetAllSettings{
    // 把当前已注册的 key 全部清掉
    for (NSString *k in self.allKeys){
        if (LFCloudOrNil()) [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:k];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:k];
    }
    LFSync();
    [self onCloudChanged:nil];
    [self showToast:@"已恢复默认配置"];
}

#pragma mark - 协议弹窗 & Toast
static inline BOOL LFTermsIsAccepted(void){
    // 如果你要“仅本机一次”，也没关系：LFGetString 会优先云端、无云走本地
    NSString *v = LFGetString(kLF_TermsAcceptedVersion, nil);
    return [v isEqualToString:LFTermsRevision()];
}
static inline void LFTermsMarkAccepted(void){
    if (LF_TERMS_CROSS_DEVICE){
        // 账号级：写入 iCloud + 本地（函数内部已做兜底）
        LFSetString(kLF_TermsAcceptedVersion, LFTermsRevision());
    }else{
        // 本机级：只写本地
        [[NSUserDefaults standardUserDefaults] setObject:LFTermsRevision()
                                                  forKey:kLF_TermsAcceptedVersion];
    }
}
static inline void LFTermsClearAccepted(void){
    // 重置用：把本地和云端都清掉
    if (LFCloudOrNil())
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:kLF_TermsAcceptedVersion];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLF_TermsAcceptedVersion];
    LFSync();
}

- (void)showAgreementIfNeeded{
    if (LFTermsIsAccepted()) return;   // 已同意：不再弹
    LFAgreementView *ag = [LFAgreementView new];
    __weak __typeof(self) w = self;
    ag.onResult = ^(BOOL agree){
        if (agree){
            LFTermsMarkAccepted();      // 标记为已同意（本机或账号级）
            [w showToast:@"已同意，欢迎使用"];
        }else{
            syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
          
            // 这里你也可以 disable UI 或直接退出
        }
    };
    [self.view addSubview:ag];
}
- (void)showToast:(NSString *)msg{
    UILabel *toast=LFMakeLabel(msg,[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold],LF_TEXT);
    toast.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.7];
    toast.textAlignment=NSTextAlignmentCenter; toast.layer.cornerRadius=12; toast.layer.masksToBounds=YES;
    toast.translatesAutoresizingMaskIntoConstraints=NO; [self.view addSubview:toast];
    [NSLayoutConstraint activateConstraints:@[
        [toast.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [toast.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-24],
        [toast.widthAnchor constraintGreaterThanOrEqualToConstant:160],
        [toast.heightAnchor constraintEqualToConstant:36],
    ]];
    [UIView animateWithDuration:0.25 delay:1.2 options:0 animations:^{ toast.alpha=0; } completion:^(BOOL f){ [toast removeFromSuperview]; }];
}

+ (void)setShouldToggleHUDAfterLaunch:(BOOL)flag {
    // 实现方法
}

- (void)reloadMainButtonState {
    // 实现方法
}

#pragma mark - ImGui悬浮窗管理
// [已禁用] ImGui悬浮窗功能暂时弃用，保留代码以便后续研究

/*
- (void)handleImGuiFloatingWindowToggle:(BOOL)enabled {
    LFSNSLog(@"[SHEntryCtrl] ========== 处理ImGui悬浮窗切换 ==========");
    LFSNSLog(@"[SHEntryCtrl] 目标状态: %@", enabled ? @"显示" : @"隐藏");
    
    SHWindowCtrl *manager = [SHWindowCtrl sharedManager];
    if (!manager) {
        LFSNSLog(@"[SHEntryCtrl] [ERROR] 无法获取SHWindowCtrl单例");
        return;
    }
    
    BOOL currentState = [manager isFloatingWindowVisible];
    LFSNSLog(@"[SHEntryCtrl] 当前状态: %@", currentState ? @"显示" : @"隐藏");
    
    if (enabled && !currentState) {
        LFSNSLog(@"[SHEntryCtrl] 执行显示操作...");
        BOOL success = [manager showFloatingWindow];
        if (success) {
            LFSNSLog(@"[SHEntryCtrl] ✓✓✓ ImGui悬浮窗显示成功");
            [self showToast:@"ImGui悬浮窗已显示"];
        } else {
            LFSNSLog(@"[SHEntryCtrl] ✗✗✗ ImGui悬浮窗显示失败");
            [self showToast:@"ImGui悬浮窗显示失败，请查看日志"];
        }
    } else if (!enabled && currentState) {
        LFSNSLog(@"[SHEntryCtrl] 执行隐藏操作...");
        BOOL success = [manager hideFloatingWindow];
        if (success) {
            LFSNSLog(@"[SHEntryCtrl] ✓✓✓ ImGui悬浮窗隐藏成功");
            [self showToast:@"ImGui悬浮窗已隐藏"];
        } else {
            LFSNSLog(@"[SHEntryCtrl] ✗✗✗ ImGui悬浮窗隐藏失败");
            [self showToast:@"ImGui悬浮窗隐藏失败，请查看日志"];
        }
    } else {
        LFSNSLog(@"[SHEntryCtrl] 状态无需改变，跳过操作");
    }
    
    LFSNSLog(@"[SHEntryCtrl] ========== ImGui悬浮窗切换处理完成 ==========");
}
*/

@end
