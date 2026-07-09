//  QQ1587820860
//  Created by LAN on 2025/7/24.
//  Copyright 2025 LAN. All rights reserved.
#import "oc悬浮菜单.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "FontArmor3.h"
#import "HUDHelper.h"

#define 统一主题颜色 [UIColor colorWithRed:0.0f green:0.48f blue:1.0f alpha:1.0f]  // Apple 蓝
#define 开关轨道统一颜色 [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f]
#define 勾选和滑块统一颜色 [UIColor colorWithRed:0.0f green:0.48f blue:1.0f alpha:1.0f]
#define 科幻青 [UIColor colorWithRed:0.0f green:0.48f blue:1.0f alpha:1.0f]
#define 科幻青暗 [UIColor colorWithRed:0.0f green:0.48f blue:1.0f alpha:0.6f]
#define APPLE_ACCENT [UIColor colorWithRed:0.0f green:0.48f blue:1.0f alpha:1.0f]
#define APPLE_LABEL  [UIColor colorWithRed:0.05f green:0.08f blue:0.14f alpha:0.92f]
#define APPLE_SUB_LABEL [UIColor colorWithRed:0.10f green:0.12f blue:0.17f alpha:0.72f]
#define APPLE_SEP    [UIColor colorWithWhite:1.0f alpha:0.34f]
#define FAINT_BG     [UIColor colorWithWhite:1.0f alpha:0.56f]

#define 统一字体大小 14

static NSString * const kTSMenuCloseNotification = @"com.afei.HP.menu.close";
static NSString * const kTSMenuThemeModeKey = @"AAThemeMode";
static NSString * const kMapWidthKey = @"MapWidthKey";

typedef NS_ENUM(NSInteger, MenuThemeMode) {
    MenuThemeModeDark = 0,
    MenuThemeModeLight = 1,
    MenuThemeModeBlack = 2,
};

BOOL 显示人数 = NO;
BOOL 人物射线 = NO;
BOOL 人物血条 = NO;
BOOL 人物骨骼 = NO;
BOOL 人物信息 = NO;
BOOL 距离显示 = NO;
BOOL 背敌显示 = NO;
BOOL 绘制掩体 = NO;
BOOL 对局显示 = YES;
BOOL 手持开关 = NO;
BOOL 隐藏人机 = NO;
BOOL 手雷预警 = NO;
BOOL 绘制模型 = NO;
BOOL 掩体变色调试 = NO;
BOOL 直播模式 = NO;
BOOL 雷达开关 = NO;

BOOL 突击步枪 = NO;
BOOL 机枪武器 = NO;
BOOL 狙击枪械 = NO;
BOOL 冲锋枪械 = NO;
BOOL 散弹枪械 = NO;
BOOL 手枪武器 = NO;
BOOL 弓箭武器 = NO;
BOOL 近战武器 = NO;
BOOL 射手步枪 = NO;
BOOL 投掷物品 = NO;
BOOL 步枪弹夹 = NO;
BOOL 狙击弹夹 = NO;
BOOL 冲锋弹夹 = NO;
BOOL 握把配件 = NO;
BOOL 步枪补偿 = NO;
BOOL 狙击补偿 = NO;
BOOL 冲锋补偿 = NO;
BOOL 枪托配件 = NO;
BOOL 武器子弹 = NO;
BOOL 倍镜配件 = NO;

BOOL 显示载具 = NO;
BOOL 显示头甲 = NO;
BOOL 显示背包 = NO;
BOOL 空投显示 = NO;
BOOL 信号枪 = NO;
BOOL 紧急呼救器 = NO;
extern BOOL 盒内物资;
BOOL 显示药品 = NO;
BOOL 显示盒子 = NO;
BOOL 版本物资 = NO;
extern BOOL 地铁物资;
extern BOOL 地铁盒子;

int 当前帧率 = 120;

// === 与主界面共享的开关存储（iCloud KVS + UserDefaults） ===
// 说明：主界面通过 SHEntryCtrl.mm 里的 LFSetBool/LFGetBool
// 使用 NSUbiquitousKeyValueStore + NSUserDefaults 保存配置。
// 这里在悬浮菜单中实现一套等价的读写逻辑，保证：
// - 在主界面点开关 和 在悬浮窗点开关，都是操作同一份配置
// - SHRenderView 里通过 iCloudStore 读取到的值是最新的

static inline NSUbiquitousKeyValueStore *MenuCloudStore(void) {
    // 直接使用系统默认的 KVS；如果没有权限返回 nil 也没关系
    return [NSUbiquitousKeyValueStore defaultStore];
}

static inline BOOL MenuGetBool(NSString *key, BOOL defValue) {
    NSUbiquitousKeyValueStore *kv = MenuCloudStore();
    if (kv) {
        id obj = [kv objectForKey:key];
        if (obj) {
            return [kv boolForKey:key];
        }
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:key]) {
        return [ud boolForKey:key];
    }
    return defValue;
}

static inline void MenuSetBool(NSString *key, BOOL value) {
    NSUbiquitousKeyValueStore *kv = MenuCloudStore();
    if (kv) {
        [kv setBool:value forKey:key];
        [kv synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

BOOL 调试物资 = NO;
BOOL 调试盒内 = NO;
BOOL 调试手持 = NO;

extern float 绘制距离;
float 雷达位置X = 0.85f;
float 雷达位置Y = 0.15f;
float 雷达大小 = 50.0f;

@interface 加载自定义字体 : NSObject //使用自定义字体加载需要导入 CoreText.framework
@end
@implementation 加载自定义字体

+ (UIFont *)customFontWithSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

@end

@interface CustomPageButton : UIControl
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isSelected;
@end

@implementation CustomPageButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [加载自定义字体 customFontWithSize:14];
        self.titleLabel.userInteractionEnabled = NO;
        [self addSubview:self.titleLabel];
        [self updateStyle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self updateStyle];
}

- (void)updateStyle {
    if (self.isSelected) {
        self.backgroundColor = [APPLE_ACCENT colorWithAlphaComponent:0.22];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = APPLE_SUB_LABEL;
        self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!self.isSelected) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.04];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self updateStyle];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self updateStyle];
}

@end

@interface CustomSliderView : UIView
@property (nonatomic, assign) float value;
@property (nonatomic, assign) float minValue;
@property (nonatomic, assign) float maxValue;
@property (nonatomic, copy) void (^valueChanged)(float value);
@end

@implementation CustomSliderView {
    UIView *_trackView;
    UIView *_activeTrackView;
    UIView *_thumbView;
    BOOL _isDragging;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _minValue = 0;
        _maxValue = 1;
        _value = 0.5;
        CGFloat trackHeight = 26;
        _trackView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - trackHeight) / 2, frame.size.width, trackHeight)];
        _trackView.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
        _trackView.layer.cornerRadius = trackHeight / 2.0;
        _trackView.layer.masksToBounds = YES;
        [self addSubview:_trackView];
        
        _activeTrackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, trackHeight)];
        _activeTrackView.layer.cornerRadius = trackHeight / 2.0;
        _activeTrackView.layer.masksToBounds = YES;
        _activeTrackView.backgroundColor = APPLE_ACCENT;
        _activeTrackView.alpha = 1.0;
        [_trackView addSubview:_activeTrackView];
        
        _thumbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _thumbView.hidden = YES;
        [self addSubview:_thumbView];
        
        [self updateThumbPosition];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat trackHeight = 26;
    _trackView.frame = CGRectMake(0, (self.bounds.size.height - trackHeight) / 2, self.bounds.size.width, trackHeight);
    [self updateThumbPosition];
}

- (void)setValue:(float)value {
    _value = MIN(_maxValue, MAX(_minValue, value));
    [self updateThumbPosition];
}

- (void)updateThumbPosition {
    CGFloat denom = (_maxValue - _minValue);
    CGFloat percent = denom == 0 ? 0 : (_value - _minValue) / denom;
    CGFloat availableWidth = self.bounds.size.width;
    CGFloat xPos = percent * availableWidth;
    _thumbView.center = CGPointMake(xPos, _trackView.center.y);
    _activeTrackView.frame = CGRectMake(0, 0, percent * _trackView.bounds.size.width, _trackView.bounds.size.height);
}

- (void)handleTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:self];
    CGFloat percent = location.x / MAX(self.bounds.size.width, 1);
    percent = MIN(1, MAX(0, percent));
    self.value = _minValue + percent * (_maxValue - _minValue);
    if (self.valueChanged) self.valueChanged(self.value);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _isDragging = YES;
    [self handleTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isDragging) [self handleTouch:[touches anyObject]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isDragging) {
        [self handleTouch:[touches anyObject]];
        _isDragging = NO;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isDragging = NO;
}

@end

@interface CustomSwitchView : UIControl
@property (nonatomic, assign, getter=isOn) BOOL on;
@property (nonatomic, strong) UIColor *checkmarkColor;
@property (nonatomic, strong) UIColor *boxBorderColor;
@end

@implementation CustomSwitchView {
    UIView *_boxView;
    UIView *_checkmarkView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkmarkColor = 勾选和滑块统一颜色;
        _boxBorderColor = 开关轨道统一颜色;
        _on = NO;
        
        _boxView = [[UIView alloc] initWithFrame:self.bounds];
        _boxView.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
        _boxView.layer.cornerRadius = 6.0;
        _boxView.layer.borderWidth = 0.5;
        _boxView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.12].CGColor;
        [self addSubview:_boxView];
        
        _checkmarkView = [[UIView alloc] initWithFrame:_boxView.bounds];
        _checkmarkView.backgroundColor = [UIColor clearColor];
        _checkmarkView.userInteractionEnabled = NO;
        [_boxView addSubview:_checkmarkView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSwitch)];
        [self addGestureRecognizer:tap];
        
        [self updateUIAnimated:NO];
    }
    return self;
}

- (void)setOn:(BOOL)on {
    _on = on;
    [self updateUIAnimated:YES];
}

- (void)toggleSwitch {
    self.on = !self.isOn;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawCheckmark {
    [_checkmarkView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    if (!_on) return;
    CAShapeLayer *checkmarkLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat size = _boxView.bounds.size.width;
    [path moveToPoint:CGPointMake(size * 0.2, size * 0.5)];
    [path addLineToPoint:CGPointMake(size * 0.45, size * 0.75)];
    [path addLineToPoint:CGPointMake(size * 0.8, size * 0.3)];
    checkmarkLayer.path = path.CGPath;
    checkmarkLayer.fillColor = [UIColor clearColor].CGColor;
    checkmarkLayer.strokeColor = _on ? [UIColor whiteColor].CGColor : _checkmarkColor.CGColor;
    checkmarkLayer.lineWidth = 3;
    checkmarkLayer.lineCap = kCALineCapRound;
    checkmarkLayer.lineJoin = kCALineJoinRound;
    [_checkmarkView.layer addSublayer:checkmarkLayer];
}

- (void)updateUIAnimated:(BOOL)animated {
    _boxView.backgroundColor = _on ? [APPLE_ACCENT colorWithAlphaComponent:1.0] : [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
    [self drawCheckmark];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _boxView.frame = self.bounds;
    _checkmarkView.frame = _boxView.bounds;
    [self updateUIAnimated:NO];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect expandedBounds = CGRectInset(self.bounds, -10, -10);
    return CGRectContainsPoint(expandedBounds, point);
}

@end

@interface CustomSwitchView2 : UIControl
@property (nonatomic, assign, getter=isOn) BOOL on;
@property (nonatomic, strong) UIColor *checkmarkColor;
@property (nonatomic, strong) UIColor *boxBorderColor;
@end

@implementation CustomSwitchView2 {
    UIView *_boxView;
    UIView *_checkmarkView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkmarkColor = 勾选和滑块统一颜色;
        _boxBorderColor = 开关轨道统一颜色;
        _on = NO;
        
        CGFloat boxSize = 24;
        _boxView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - boxSize) / 2, boxSize, boxSize)];
        _boxView.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.8 alpha:1.0];
        _boxView.layer.cornerRadius = boxSize / 2;
        _boxView.layer.masksToBounds = YES;
        [self addSubview:_boxView];
        
        CGFloat fillSize = boxSize * 0.6;
        CGFloat fillX = (boxSize - fillSize) / 2;
        CGFloat fillY = (boxSize - fillSize) / 2;
        _checkmarkView = [[UIView alloc] initWithFrame:CGRectMake(fillX, fillY, fillSize, fillSize)];
        _checkmarkView.layer.cornerRadius = fillSize / 2;
        _checkmarkView.layer.masksToBounds = YES;
        [_boxView addSubview:_checkmarkView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleSwitch)];
        [self addGestureRecognizer:tap];
        
        [self updateUIAnimated:NO];
    }
    return self;
}

- (void)setOn:(BOOL)on {
    _on = on;
    [self updateUIAnimated:YES];
}

- (void)toggleSwitch {
    self.on = !self.isOn;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)drawCheckmark {
    if (_on) {
        _checkmarkView.backgroundColor = _checkmarkColor;
    } else {
        _checkmarkView.backgroundColor = [UIColor clearColor];
    }
}

- (void)updateUIAnimated:(BOOL)animated {
    [self drawCheckmark];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect expandedBounds = CGRectInset(self.bounds, -10, -10);
    return CGRectContainsPoint(expandedBounds, point);
}

@end

// 标题栏高度（白色透明风格）
static const CGFloat kTitleBarHeight = 44.0f;

#pragma mark - ImGuiMenu主界面实现
@interface 自用oc悬浮菜单 ()
// 菜单容器视图
@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UIVisualEffectView *menuBlurView;
@property (nonatomic, strong) UIView *glassWhiteOverlayView;
@property (nonatomic, strong) CAGradientLayer *glassHighlightLayer;
@property (nonatomic, strong) CAGradientLayer *marqueeBorderLayer;
@property (nonatomic, strong) CAShapeLayer *marqueeBorderMask;
// 标题标签
@property (nonatomic, strong) UILabel *titleLabel;
// 当前Y轴偏移量（用于布局）
@property (nonatomic, assign) CGFloat currentYOffset;

// 是否正在移动窗口标志
@property (nonatomic, assign) bool isMoveWindow;
// 触摸起始点
@property (nonatomic, assign) CGPoint startTouchPoint;

// 跟踪当前活动触摸（只处理单点触控）
@property (nonatomic, weak) UITouch *activeTouch;

// 到期时间标签
@property (nonatomic, strong) UILabel *expiryLabel;

@property (nonatomic, strong) UIView *titleBackgroundView;
@property (nonatomic, strong) UIView *separatorLineView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *themeRowView;
@property (nonatomic, strong) NSArray<CustomSwitchView2 *> *themeSwitches;
@property (nonatomic, assign) MenuThemeMode themeMode;

@property (nonatomic, strong) UIView *tabContainerView;
@property (nonatomic, strong) UIView *bottomSeparatorView;
@property (nonatomic, strong) UIView *contentSeparatorView;
@property (nonatomic, assign) CGFloat contentStartYOffset;
@property (nonatomic, assign) CGFloat contentStartXOffset;

@property (nonatomic, strong) UIView *resizeHandleView;
@property (nonatomic, assign) CGSize resizeStartSize;
@property (nonatomic, assign) CFTimeInterval lastResizeContentUpdateTime;
@property (nonatomic, strong) UIImageView *cornerAvatarView;

//切换页面按钮相关
@property (nonatomic, assign) MenuPageType currentPage;
@property (nonatomic, strong) NSArray<UIButton *> *pageButtons;
@property (nonatomic, strong) UITextView *logTextView;
//切换页面按钮相关
@end

@implementation 自用oc悬浮菜单

// 单例实现
+ (instancetype)sharedInstance {
    // 静态变量保存单例对象
    static 自用oc悬浮菜单 *sharedInstance = nil;
    // 保证线程安全的初始化
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 使用屏幕bounds创建实例
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    // 调用父类初始化
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;//应用扩大 开关按钮点击区域
        
        // 初始化菜单UI
        [self setupMenuUI];
    }
    return self;
}

- (void)setupMenuUI {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat shortSide = MIN(screenBounds.size.width, screenBounds.size.height);
    CGFloat longSide = MAX(screenBounds.size.width, screenBounds.size.height);

    CGFloat menuWidth = MIN(680.0, shortSide - 20.0);
    if (shortSide < 430.0) {
        menuWidth = shortSide - 16.0;
    }
    menuWidth = MAX(340.0, menuWidth);

    CGFloat menuHeight = MIN(520.0, longSide - 110.0);
    menuHeight = MAX(320.0, menuHeight);
    
    self.menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, menuHeight)];
    self.menuContainer.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height/2);
    self.menuContainer.backgroundColor = [UIColor clearColor];
    self.menuContainer.layer.cornerRadius = 18.0f;
    self.menuContainer.layer.masksToBounds = NO;
    self.menuContainer.layer.borderWidth = 1.0f;
    self.menuContainer.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.22].CGColor;
    self.menuContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuContainer.layer.shadowOffset = CGSizeMake(0, 12);
    self.menuContainer.layer.shadowRadius = 28;
    self.menuContainer.layer.shadowOpacity = 0.10;
    self.menuContainer.userInteractionEnabled = YES;
    self.menuContainer.clipsToBounds = NO;
    [self addSubview:self.menuContainer];

    UIBlurEffect *blurEffect;
    if (@available(iOS 13.0, *)) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterialLight];
    } else {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.menuContainer.bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.layer.cornerRadius = 18.0f;
    blurView.layer.masksToBounds = YES;
    [self.menuContainer addSubview:blurView];
    self.menuBlurView = blurView;

    UIView *whiteOverlay = [[UIView alloc] initWithFrame:blurView.bounds];
    whiteOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    whiteOverlay.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.10];
    whiteOverlay.userInteractionEnabled = NO;
    [blurView.contentView addSubview:whiteOverlay];
    self.glassWhiteOverlayView = whiteOverlay;

    CAGradientLayer *highlightLayer = [CAGradientLayer layer];
    highlightLayer.frame = blurView.bounds;
    highlightLayer.colors = @[
        (id)[UIColor colorWithWhite:1.0 alpha:0.26].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.10].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.02].CGColor
    ];
    highlightLayer.locations = @[@0.0, @0.32, @1.0];
    highlightLayer.startPoint = CGPointMake(0.1, 0.0);
    highlightLayer.endPoint = CGPointMake(0.9, 1.0);
    [blurView.contentView.layer addSublayer:highlightLayer];
    self.glassHighlightLayer = highlightLayer;

    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, kTitleBarHeight)];
    titleBackground.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
    titleBackground.layer.cornerRadius = 18.0f;
    titleBackground.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    titleBackground.layer.masksToBounds = YES;
    [self.menuContainer addSubview:titleBackground];
    self.titleBackgroundView = titleBackground;

    UIPanGestureRecognizer *dragPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTitleDragPan:)];
    [titleBackground addGestureRecognizer:dragPan];

    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleBarHeight, menuWidth, 1.0)];
    separatorLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.20];
    [self.menuContainer addSubview:separatorLine];
    self.separatorLineView = separatorLine;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, menuWidth - 56, kTitleBarHeight)];
    self.titleLabel.text = @"Troll Engine";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = APPLE_LABEL;
    self.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    [self.menuContainer addSubview:self.titleLabel];

    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(menuWidth - 44, 0, 44, kTitleBarHeight);
    [self.closeButton setTitle:@"✕" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:APPLE_LABEL forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:self.closeButton];
    
    self.expiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, menuWidth - 110, kTitleBarHeight)];
    NSString *dateString = @"xxxx";
    if (dateString) {
        self.expiryLabel.text = [NSString stringWithFormat:@"到期时间:%@", dateString];
    } else {
        [self startSystemTimeUpdate];
    }
    self.expiryLabel.textAlignment = NSTextAlignmentRight;
    self.expiryLabel.textColor = APPLE_SUB_LABEL;
    self.expiryLabel.font = [UIFont systemFontOfSize:统一字体大小 weight:UIFontWeightRegular];
    [self.menuContainer addSubview:self.expiryLabel];
    self.expiryLabel.hidden = YES;

    self.themeMode = MenuThemeModeLight;
    
    // 添加页面切换按钮（在分隔线之前）
    [self addPageSwitchButtons];
    
    [self setupThemeRow];
    [self applyThemeMode:self.themeMode];
    
    // 创建分隔线 - 调整位置到主题行下方
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(20, 100, menuWidth - 40, 1)];
    separator.backgroundColor = APPLE_SEP;
    [self.menuContainer addSubview:separator];
    self.contentSeparatorView = separator;
    
    
    self.contentStartYOffset = 105;
    self.currentYOffset = self.contentStartYOffset;//创建功能开关在 页面切换按钮下方
    self.contentStartXOffset = CGRectGetMaxX(self.tabContainerView.frame) + 10;
    
    // 设置默认页面
    self.currentPage = MenuPageTypeCharacter;

    [self setupCornerAvatarView];
    [self setupMarqueeBorder];
    
    [self updateMenuLayoutFrames];
    [self updateMenuContent];
}

- (void)setupMarqueeBorder {
    [self.marqueeBorderLayer removeFromSuperlayer];
    self.marqueeBorderLayer = nil;
    self.marqueeBorderMask = nil;

    CAGradientLayer *borderLayer = [CAGradientLayer layer];
    borderLayer.frame = self.menuContainer.bounds;
    borderLayer.colors = @[
        (id)[UIColor colorWithRed:0.20 green:0.86 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.42 green:0.43 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.97 green:0.36 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.46 blue:0.46 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.20 green:0.86 blue:1.0 alpha:1.0].CGColor
    ];
    borderLayer.locations = @[@0.0, @0.25, @0.50, @0.75, @1.0];
    borderLayer.startPoint = CGPointMake(0.0, 0.5);
    borderLayer.endPoint = CGPointMake(1.0, 0.5);
    borderLayer.cornerRadius = 18.0;
    borderLayer.zPosition = 20;

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = borderLayer.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(borderLayer.bounds, 1.2, 1.2)
                                                    cornerRadius:16.8];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth = 2.2;
    borderLayer.mask = maskLayer;

    CABasicAnimation *glow = [CABasicAnimation animationWithKeyPath:@"opacity"];
    glow.fromValue = @(0.85);
    glow.toValue = @(1.0);
    glow.autoreverses = YES;
    glow.duration = 1.1;
    glow.repeatCount = HUGE_VALF;
    [borderLayer addAnimation:glow forKey:@"lf.menu.marquee.glow"];

    [self.menuContainer.layer addSublayer:borderLayer];
    self.marqueeBorderLayer = borderLayer;
    self.marqueeBorderMask = maskLayer;
}

// 添加页面切换按钮
- (void)addPageSwitchButtons {
    CGFloat tabX = 0.0;
    CGFloat tabY = kTitleBarHeight + 1.0;
    CGFloat tabW = floor(self.menuContainer.bounds.size.width / 3.0);
    CGFloat tabH = self.menuContainer.bounds.size.height - tabY;

    NSArray *buttonTitles = @[@"绘制", @"雷达", @"日志"];
    NSMutableArray *buttons = [NSMutableArray array];

    UIView *tabContainer = [[UIView alloc] initWithFrame:CGRectMake(tabX, tabY, tabW, tabH)];
    tabContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
    tabContainer.layer.cornerRadius = 12.0f;
    tabContainer.layer.maskedCorners = kCALayerMinXMaxYCorner;
    tabContainer.layer.borderWidth = 0;
    tabContainer.layer.masksToBounds = YES;
    [self.menuContainer addSubview:tabContainer];
    self.tabContainerView = tabContainer;

    CGFloat buttonHeight = 44.0;
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        CGFloat y = i * buttonHeight;
        CustomPageButton *pageButton = [[CustomPageButton alloc] initWithFrame:CGRectMake(0, y, tabW, buttonHeight)];
        pageButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        pageButton.titleLabel.text = buttonTitles[i];
        pageButton.tag = i;
        pageButton.isSelected = (i == 0);
        [pageButton addTarget:self action:@selector(pageButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        [tabContainer addSubview:pageButton];
        [buttons addObject:pageButton];

        if (i + 1 < buttonTitles.count) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(pageButton.frame), tabW - 20, 1)];
            separator.backgroundColor = APPLE_SEP;
            separator.tag = 9000 + i;
            [tabContainer addSubview:separator];
        }
    }
    self.pageButtons = [buttons copy];

    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(tabW, tabY, 1.0, tabH)];
    bottomSeparator.backgroundColor = APPLE_SEP;
    [self.menuContainer addSubview:bottomSeparator];
    self.bottomSeparatorView = bottomSeparator;
}

- (void)setupResizeHandle {
    if (self.resizeHandleView) {
        [self.resizeHandleView removeFromSuperview];
        self.resizeHandleView = nil;
    }
    
    CGFloat size = 22;
    UIView *handle = [[UIView alloc] initWithFrame:CGRectMake(self.menuContainer.bounds.size.width - size, self.menuContainer.bounds.size.height - size, size, size)];
    handle.backgroundColor = [UIColor clearColor];
    handle.userInteractionEnabled = YES;
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(2, size - 2)];
    [path addLineToPoint:CGPointMake(size - 2, size - 2)];
    [path addLineToPoint:CGPointMake(size - 2, 2)];
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.lineWidth = 2.0;
    [handle.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [handle.layer addSublayer:shape];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleResizePan:)];
    [handle addGestureRecognizer:pan];
    
    [self.menuContainer addSubview:handle];
    [self.menuContainer bringSubviewToFront:handle];
    self.resizeHandleView = handle;
}

- (void)handleResizePan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.resizeStartSize = self.menuContainer.bounds.size;
        self.lastResizeContentUpdateTime = 0;
        return;
    }
    
    CGPoint translation = [pan translationInView:self];
    CGSize currentSize = self.menuContainer.bounds.size;
    CGFloat newWidth = currentSize.width + translation.x;
    CGFloat newHeight = currentSize.height + translation.y;
    [pan setTranslation:CGPointZero inView:self];
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat maxWidth = MIN(900, screenBounds.size.width - 10);
    CGFloat maxHeight = MIN(900, screenBounds.size.height - 10);
    CGFloat minWidth = 520;
    CGFloat minHeight = 260;
    
    newWidth = MIN(maxWidth, MAX(minWidth, newWidth));
    newHeight = MIN(maxHeight, MAX(minHeight, newHeight));
    
    self.menuContainer.bounds = CGRectMake(0, 0, newWidth, newHeight);
    [self updateMenuLayoutFrames];
    
    CFTimeInterval now = CACurrentMediaTime();
    if (self.lastResizeContentUpdateTime == 0 || (now - self.lastResizeContentUpdateTime) >= (1.0 / 30.0)) {
        self.lastResizeContentUpdateTime = now;
        [self updateMenuContent];
    }
    
    if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled ||
        pan.state == UIGestureRecognizerStateFailed) {
        [self updateMenuContent];
    }
}

- (void)updateMenuLayoutFrames {
    CGFloat menuWidth = self.menuContainer.bounds.size.width;
    CGFloat menuHeight = self.menuContainer.bounds.size.height;
    
    self.titleBackgroundView.frame = CGRectMake(0, 0, menuWidth, kTitleBarHeight);
    self.separatorLineView.frame = CGRectMake(0, kTitleBarHeight, menuWidth, 1.0);
    self.titleLabel.frame = CGRectMake(16, 0, menuWidth - 60, kTitleBarHeight);
    self.closeButton.frame = CGRectMake(menuWidth - 44, 0, 44, kTitleBarHeight);
    self.expiryLabel.frame = CGRectMake(100, 0, menuWidth - 110, kTitleBarHeight);

    CGFloat tabX = 0.0;
    CGFloat tabY = kTitleBarHeight + 1.0;
    CGFloat tabW = floor(menuWidth / 3.0);
    CGFloat tabH = menuHeight - tabY;
    self.tabContainerView.frame = CGRectMake(tabX, tabY, tabW, tabH);

    CGFloat tabButtonH = 44.0;
    for (NSInteger i = 0; i < self.pageButtons.count; i++) {
        UIView *v = self.pageButtons[i];
        v.frame = CGRectMake(0, i * tabButtonH, tabW, tabButtonH);
    }
    for (NSInteger i = 0; i + 1 < self.pageButtons.count; i++) {
        UIView *separator = [self.tabContainerView viewWithTag:9000 + i];
        if (separator) {
            separator.frame = CGRectMake(10, (i + 1) * tabButtonH, tabW - 20, 1);
        }
    }

    self.bottomSeparatorView.frame = CGRectMake(tabW, tabY, 1.0, tabH);

    CGFloat contentX = tabW + 12.0;
    self.contentStartXOffset = contentX;

    CGFloat themeY = kTitleBarHeight + 8.0;
    CGFloat themeH = 0;
    self.themeRowView.frame = CGRectMake(contentX, themeY, menuWidth - contentX - 10.0, themeH);

    self.contentSeparatorView.frame = CGRectMake(contentX, themeY + themeH + 2, menuWidth - contentX - 10.0, 1);
    self.contentStartYOffset = themeY + themeH + 16;
    self.currentYOffset = self.contentStartYOffset;

    if (self.cornerAvatarView) {
        CGFloat size = self.cornerAvatarView.bounds.size.width;
        self.cornerAvatarView.frame = CGRectMake(12.0, menuHeight - size - 14.0, size, size);
        [self.menuContainer bringSubviewToFront:self.cornerAvatarView];
    }
    
    CGFloat handleSize = self.resizeHandleView.bounds.size.width;
    self.resizeHandleView.frame = CGRectMake(menuWidth - handleSize, menuHeight - handleSize, handleSize, handleSize);
    [self.menuContainer bringSubviewToFront:self.resizeHandleView];

    self.glassHighlightLayer.frame = self.menuBlurView.bounds;
    self.marqueeBorderLayer.frame = self.menuContainer.bounds;
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.menuContainer.bounds, 1.2, 1.2)
                                                         cornerRadius:16.8];
    self.marqueeBorderMask.frame = self.menuContainer.bounds;
    self.marqueeBorderMask.path = ringPath.CGPath;
}

// 页面按钮值变化处理
- (void)pageButtonValueChanged:(CustomPageButton *)sender {
    // 更新当前页面
    if (sender.tag == 0) self.currentPage = MenuPageTypeCharacter;
    else if (sender.tag == 1) self.currentPage = MenuPageTypeRadar;
    else self.currentPage = MenuPageTypeAdvanced;
    
    // 更新所有按钮的选中状态
    for (CustomPageButton *button in self.pageButtons) {
        button.isSelected = (button.tag == sender.tag);
    }
    
    // 更新菜单内容
    [self updateMenuContent];
}

// 更新菜单内容根据当前页面
- (void)updateMenuContent {
    // 移除旧的控件（除了标题、分隔线和页面按钮）
    for (UIView *view in self.menuContainer.subviews) {
        if ([view isEqual:self.titleLabel] ||
            [view isEqual:self.expiryLabel] ||
            [view isEqual:self.titleBackgroundView] ||
            [view isEqual:self.separatorLineView] ||
            [view isEqual:self.closeButton] ||
            [view isEqual:self.themeRowView] ||
            [view isEqual:self.tabContainerView] ||
            [view isEqual:self.bottomSeparatorView] ||
            [view isEqual:self.contentSeparatorView] ||
            [view isEqual:self.cornerAvatarView] ||
            [view isEqual:self.resizeHandleView] ||
            [view isEqual:self.menuBlurView]) {
            continue;
        }
        if (view.frame.origin.y >= self.contentStartYOffset) {
            [view removeFromSuperview];
        }
    }
    
    // 重置Y轴偏移量
    self.currentYOffset = self.contentStartYOffset;
    
    // 根据当前页面添加对应的控件（保留所有枚举值，未使用的页面分支留空以满足 -Wswitch）
    switch (self.currentPage) {
        case MenuPageTypeCharacter:
            [self addFunctionSwitches];
            break;
        case MenuPageTypeItems:
            // 已移除“枪械物资”界面，这里保留空分支仅为枚举完整性
            break;
        case MenuPageTypeAimbot:
            // 已移除“其他物资/自瞄”界面，这里保留空分支仅为枚举完整性
            break;
        case MenuPageTypeAdvanced:
            [self addLogPageControls];
            break;
        case MenuPageTypeRadar:
            [self addRadarPageControls];
            break;
    }
    
    if (self.resizeHandleView) {
        [self.menuContainer bringSubviewToFront:self.resizeHandleView];
    }
    if (self.cornerAvatarView) {
        [self.menuContainer bringSubviewToFront:self.cornerAvatarView];
    }
}

- (void)refreshLogTextView {
    NSString *text = LFReadAppLogSnippet(96 * 1024);
    if (text.length == 0) {
        text = @"暂无日志。请先点击内核方案开始引导，或打开/关闭绘制后再刷新。";
    }
    self.logTextView.text = text;
    if (text.length > 0) {
        NSRange bottom = NSMakeRange(MAX((NSInteger)text.length - 1, 0), 1);
        [self.logTextView scrollRangeToVisible:bottom];
    }
}

- (void)refreshLogButtonTapped:(UIButton *)sender {
    (void)sender;
    [self refreshLogTextView];
}

- (void)clearLogButtonTapped:(UIButton *)sender {
    (void)sender;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"app.log"];
    [@"" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    LFSNSLog(@"[MenuLog] 日志已清空");
    [self refreshLogTextView];
}

- (void)addLogPageControls {
    CGFloat x = self.contentStartXOffset;
    CGFloat width = self.menuContainer.bounds.size.width - x - 12.0;
    CGFloat top = self.currentYOffset;
    CGFloat buttonH = 32.0;
    CGFloat gap = 8.0;

    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    refresh.frame = CGRectMake(x, top, 78, buttonH);
    [refresh setTitle:@"刷新" forState:UIControlStateNormal];
    refresh.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    refresh.tintColor = APPLE_ACCENT;
    refresh.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.22];
    refresh.layer.cornerRadius = 8.0;
    [refresh addTarget:self action:@selector(refreshLogButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:refresh];

    UIButton *clear = [UIButton buttonWithType:UIButtonTypeSystem];
    clear.frame = CGRectMake(CGRectGetMaxX(refresh.frame) + gap, top, 78, buttonH);
    [clear setTitle:@"清空" forState:UIControlStateNormal];
    clear.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    clear.tintColor = APPLE_SUB_LABEL;
    clear.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.16];
    clear.layer.cornerRadius = 8.0;
    [clear addTarget:self action:@selector(clearLogButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:clear];

    CGFloat logY = top + buttonH + gap;
    CGFloat logH = self.menuContainer.bounds.size.height - logY - 18.0;
    UITextView *logView = [[UITextView alloc] initWithFrame:CGRectMake(x, logY, width, MAX(120.0, logH))];
    logView.editable = NO;
    logView.selectable = YES;
    logView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.72];
    logView.textColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    logView.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightRegular];
    logView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    logView.layer.cornerRadius = 10.0;
    logView.layer.masksToBounds = YES;
    [self.menuContainer addSubview:logView];
    self.logTextView = logView;
    [self refreshLogTextView];
}

- (void)setupCornerAvatarView {
    CGFloat imageSize = 86.0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, self.menuContainer.bounds.size.height - imageSize - 14.0, imageSize, imageSize)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = imageSize * 0.5f;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.45].CGColor;

    UIImage *avatar = [UIImage imageNamed:@"图二.JPG"];
    if (!avatar) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"图二" ofType:@"JPG"];
        if (path.length > 0) {
            avatar = [UIImage imageWithContentsOfFile:path];
        }
    }
    imageView.image = avatar;
    imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];

    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spin.fromValue = @(0.0);
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 60.0;
    spin.repeatCount = HUGE_VALF;
    spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spin.removedOnCompletion = NO;
    [imageView.layer addAnimation:spin forKey:@"lf.cornerAvatar.spin"];

    [self.menuContainer addSubview:imageView];
    self.cornerAvatarView = imageView;
}

- (void)setupThemeRow {
    CGFloat rowY = kTitleBarHeight + 12;
    CGFloat rowHeight = 0;
    CGFloat contentX = CGRectGetMaxX(self.tabContainerView.frame) + 18;
    self.contentStartXOffset = contentX;
    self.themeRowView = [[UIView alloc] initWithFrame:CGRectMake(contentX, rowY, self.menuContainer.bounds.size.width - contentX, rowHeight)];
    [self.menuContainer addSubview:self.themeRowView];
    self.themeSwitches = @[];
}

- (void)applyThemeMode:(MenuThemeMode)mode {
    (void)mode;
    self.titleBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.18];
    self.tabContainerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
    self.titleLabel.textColor = APPLE_LABEL;
}

- (void)closeButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTSMenuCloseNotification object:nil];
}

- (void)handleTitleDragPan:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    CGPoint targetCenter = CGPointMake(self.menuContainer.center.x + translation.x,
                                       self.menuContainer.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:self];

    CGFloat halfW = CGRectGetWidth(self.menuContainer.bounds) * 0.5;
    CGFloat halfH = CGRectGetHeight(self.menuContainer.bounds) * 0.5;
    CGFloat minX = halfW + 8.0;
    CGFloat maxX = CGRectGetWidth(self.bounds) - halfW - 8.0;
    CGFloat minY = halfH + 8.0;
    CGFloat maxY = CGRectGetHeight(self.bounds) - halfH - 8.0;

    if (maxX < minX) {
        targetCenter.x = CGRectGetMidX(self.bounds);
    } else {
        targetCenter.x = fmax(minX, fmin(maxX, targetCenter.x));
    }

    if (maxY < minY) {
        targetCenter.y = CGRectGetMidY(self.bounds);
    } else {
        targetCenter.y = fmax(minY, fmin(maxY, targetCenter.y));
    }

    self.menuContainer.center = targetCenter;
}

- (void)themeSwitchValueChanged:(CustomSwitchView2 *)sender {
    NSNumber *modeNum = objc_getAssociatedObject(sender, @selector(themeSwitchValueChanged:));
    if (!modeNum) return;
    MenuThemeMode mode = (MenuThemeMode)modeNum.integerValue;
    if (!sender.isOn) {
        sender.on = YES;
        return;
    }
    for (CustomSwitchView2 *sw in self.themeSwitches) {
        NSNumber *other = objc_getAssociatedObject(sw, @selector(themeSwitchValueChanged:));
        if (other && other.integerValue != mode) {
            sw.on = NO;
        }
    }
    self.themeMode = mode;
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kTSMenuThemeModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self applyThemeMode:mode];
}

//新增

#pragma mark - 添加功能控件
// 添加功能开关方法
- (void)addFunctionSwitches {
    // 4列布局（每项占功能区四分之一宽度）
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10.0;
    CGFloat columnWidth = contentWidth / 4.0;

    NSArray<NSDictionary<NSString *, NSString *> *> *switchItems = @[
        @{@"title": @"显示人数", @"key": @"AAshexian"},
        @{@"title": @"人物射线", @"key": @"AAguge"},
        @{@"title": @"人物血条", @"key": @"AArenshu"},
        @{@"title": @"人物骨骼", @"key": @"AAxueliang"},
        @{@"title": @"人物信息", @"key": @"AAjuli"},
        @{@"title": @"距离显示", @"key": @"AAmingzi"},
        @{@"title": @"背敌显示", @"key": @"AAbeidi"},
        @{@"title": @"雷达图", @"key": @"AAleida"},
        @{@"title": @"隐藏人机", @"key": @"AAduibiao"},
        @{@"title": @"手雷预警", @"key": @"AAshouleiyujing"},
        @{@"title": @"绘制模型", @"key": @"AAxianshizhenlv"},
        @{@"title": @"直播模式", @"key": @"AAzhibomoshi"},
        @{@"title": @"掩体变色调试", @"key": @"AAyantibiaose"},
        @{@"title": @"绘制掩体", @"key": @"AAhuizhiyan"},
        @{@"title": @"对局显示", @"key": @"AAduijuxianshi"}
    ];

    for (NSInteger index = 0; index < switchItems.count; index++) {
        NSDictionary<NSString *, NSString *> *item = switchItems[index];
        NSInteger column = index % 4;
        [self addSwitchWithTitle:item[@"title"] key:item[@"key"] yOffset:&_currentYOffset column:column columnWidth:columnWidth];
        BOOL isRowEnd = (column == 3) || (index == switchItems.count - 1);
        if (isRowEnd) {
            self.currentYOffset += 46;
        }
    }

    self.currentYOffset += 6;
}





// 枪械物资页面控件
- (void)addItemsPageControls {
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10;
    CGFloat columnWidth = contentWidth / 4;//4列开关
    
    // 第一行开关
    [self addSwitchWithTitle:@"突击步枪" key:@"AAwzpqwq" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"机枪武器" key:@"AAwzjqwq" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"狙击枪械" key:@"AAwzjjqx" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"冲锋枪械" key:@"AAwzcfqx" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    
    self.currentYOffset += 35;
    
    // 第二行开关
    [self addSwitchWithTitle:@"散弹枪械" key:@"AAwzsdqx" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"手枪武器" key:@"AAwzsqwq" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"弓箭武器" key:@"AAwzgjwq" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"近战武器" key:@"AAwzjzwq" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    self.currentYOffset += 35;
    
    // 第三行开关
    [self addSwitchWithTitle:@"射手步枪" key:@"AAwzssbq" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"投掷物品" key:@"AAwzptwp" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"步枪弹夹" key:@"AAwzpqdj" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"狙击弹夹" key:@"AAwzjjdj" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    self.currentYOffset += 35;
    
    // 第四行开关
    [self addSwitchWithTitle:@"冲锋弹夹" key:@"AAwzcfqdj" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"握把配件" key:@"AAwzwbpj" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"步枪补偿" key:@"AAwzbqbcq" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"狙击补偿" key:@"AAwzjjqbcq" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    self.currentYOffset += 35;
    
    // 第五行开关
    [self addSwitchWithTitle:@"冲锋补偿" key:@"AAwzcfqbcq" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"枪托配件" key:@"AAwzwqqtpj" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"武器子弹" key:@"AAwzwqqtpj" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"倍镜配件" key:@"AAwzwqbjpj" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
}



// 其他物资页面控件
- (void)addAimbotPageControls {
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10;
    CGFloat columnWidth = contentWidth / 3;
    
    // 第一行开关
    [self addSwitchWithTitle:@"显示载具" key:@"AAwzxszj" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"显示头甲" key:@"AAwzxstj" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"显示背包" key:@"AAwzxsbp" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    self.currentYOffset += 45;
    
    // 第二行开关
    [self addSwitchWithTitle:@"空投显示" key:@"AAwzktxs" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"信号枪" key:@"AAwzxhq" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"紧急呼救器" key:@"AAwzjjhjq" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    self.currentYOffset += 45;
    
    //第三行开关
    [self addSwitchWithTitle:@"盒内物资" key:@"AAwzhnwz" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"显示药品" key:@"AAwzxsyp" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"显示盒子" key:@"AAwzxshz" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    self.currentYOffset += 45;
    //第四行开关
    [self addSwitchWithTitle:@"版本物资" key:@"AAwzbbwz" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"地铁物资" key:@"AAwzdtwz" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"地铁盒子" key:@"AAwzdthz" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
}

// 雷达配置页面控件
- (void)addRadarPageControls {
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10;
    CGFloat columnWidth = contentWidth / 3;

    [self addSwitchWithTitle:@"雷达开关" key:@"AAleida" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    self.currentYOffset += 40;

    [self addCustomSliderWithTitle:@"雷达X" key:@"AAradarX" yOffset:&_currentYOffset minValue:0.1 maxValue:0.9 defaultValue:0.85];
    self.currentYOffset += 50;
    [self addCustomSliderWithTitle:@"雷达Y" key:@"AAradarY" yOffset:&_currentYOffset minValue:0.1 maxValue:0.9 defaultValue:0.15];
    self.currentYOffset += 50;
    [self addCustomSliderWithTitle:@"雷达大小" key:@"AAradarSize" yOffset:&_currentYOffset minValue:50 maxValue:300 defaultValue:50];
    self.currentYOffset += 50;
}

// 新增高级设置页面控件
- (void)addAdvancedPageControls {
    // 4列布局
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10;
    CGFloat columnWidth = contentWidth / 3;
    
    [self 帧率设置:&_currentYOffset columnWidth:columnWidth];//添加帧率按钮
    
    self.currentYOffset += 40;
    
    // === 添加一条分割线 ===
    CGFloat separatorX = self.contentStartXOffset;
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(separatorX, _currentYOffset, self.menuContainer.bounds.size.width - separatorX - 10, 0.8)];
    separator1.backgroundColor = APPLE_SEP;
    [self.menuContainer addSubview:separator1];
    // === 添加一条分割线 ===
    self.currentYOffset += 5;
    
    // 添加你的高级设置开关
    [self addSwitchWithTitle:@"调试未知盒内" key:@"AAtshnid" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"调试未知物资" key:@"AAtswzlei" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"调试未知手持" key:@"AAtswzsc" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    self.currentYOffset += 40;
    
    // 可以继续添加更多控件...
}

- (void)帧率设置:(CGFloat *)yOffset columnWidth:(CGFloat)columnWidth {
    // 直接创建"绘制帧率"标签，不使用容器
    CGFloat baseX = self.contentStartXOffset;
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(baseX, *yOffset, 80, 30)];
    fpsLabel.text = @"绘制帧率:";
    fpsLabel.textColor = APPLE_LABEL;
    fpsLabel.font = [UIFont systemFontOfSize:统一字体大小 weight:UIFontWeightRegular];
    [self.menuContainer addSubview:fpsLabel];
    
    // 确保初始化时有默认值
    if (当前帧率 <= 0) {
        当前帧率 = 120;
    }
    
    // 帧率选项按钮
    NSArray *fpsOptions = @[@"60FPS", @"90FPS", @"120FPS"];
    
    CGFloat contentRight = self.menuContainer.bounds.size.width - 10;
    CGFloat optionsStartX = baseX + 80;
    CGFloat availableWidth = MAX(0, contentRight - optionsStartX);
    CGFloat segmentW = (fpsOptions.count > 0) ? (availableWidth / fpsOptions.count) : 0;
    CGFloat switchW = 44;
    
    for (int i = 0; i < fpsOptions.count; i++) {
        CGFloat segmentX = optionsStartX + i * segmentW;
        CGFloat labelW = MAX(40, segmentW - switchW);
        CGFloat xPos = segmentX;
        
        // 创建帧率值标签 - 增加宽度确保显示完整
        UILabel *fpsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPos, *yOffset, labelW, 30)];
        fpsValueLabel.textAlignment = NSTextAlignmentLeft;
        fpsValueLabel.text = fpsOptions[i];
        fpsValueLabel.textColor = APPLE_LABEL;
        fpsValueLabel.font = [UIFont systemFontOfSize:统一字体大小 weight:UIFontWeightRegular];
        // 强制显示完整文本
        fpsValueLabel.adjustsFontSizeToFitWidth = NO;
        fpsValueLabel.lineBreakMode = NSLineBreakByClipping;
        [self.menuContainer addSubview:fpsValueLabel];
        
        // 创建开关按钮 - 保持原来的位置关系
        CGFloat switchX = xPos + labelW;
        CustomSwitchView2 *fpsSwitch = [[CustomSwitchView2 alloc] initWithFrame:CGRectMake(switchX, *yOffset + 8, 44, 24)];
        
        // 设置初始状态
        fpsSwitch.on = ([fpsOptions[i] intValue] == 当前帧率);
        [fpsSwitch addTarget:self action:@selector(fpsSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(fpsSwitch, @selector(fpsSwitchValueChanged:), fpsOptions[i], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.menuContainer addSubview:fpsSwitch];
    }
}

- (void)addSwitchWithTitle:(NSString *)title
                       key:(NSString *)key
                   yOffset:(CGFloat *)yOffset
                    column:(NSInteger)column
               columnWidth:(CGFloat)columnWidth {
    
    // 限制列数在0-3范围内
    column = MAX(0, MIN(3, column));
    // 计算x坐标（20pt边距+列宽*列数）
    CGFloat xPosition = self.contentStartXOffset + column * columnWidth;
    CGFloat switchSize = 34;
    CGFloat rowHeight = 42;
    
    // 创建容器视图（包含标签和开关）
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(xPosition, *yOffset, columnWidth, rowHeight)];
    
    CustomSwitchView *customSwitch = [[CustomSwitchView alloc] initWithFrame:CGRectMake(0, (rowHeight - switchSize) / 2.0, switchSize, switchSize)];
    
    UIFont *font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    CGFloat labelX = switchSize + 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, columnWidth - labelX, rowHeight)];
    label.text = title;
    label.textColor = APPLE_SUB_LABEL;
    label.font = font;
    label.adjustsFontSizeToFitWidth = NO;
    label.minimumScaleFactor = 0.9;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    BOOL initialValue = NO;
    // 人物绘制页：与主界面开关共用同一套 Key
    if ([key isEqualToString:@"AAshexian"]) {
        // 显示人数 -> @"显示人数"
        显示人数 = MenuGetBool(@"显示人数", 显示人数);
        initialValue = 显示人数;
    } else if ([key isEqualToString:@"AAguge"]) {
        // 人物射线 -> @"显示射线"
        人物射线 = MenuGetBool(@"显示射线", 人物射线);
        initialValue = 人物射线;
    } else if ([key isEqualToString:@"AArenshu"]) {
        // 人物血条 -> @"显示血量"
        人物血条 = MenuGetBool(@"显示血量", 人物血条);
        initialValue = 人物血条;
    } else if ([key isEqualToString:@"AAxueliang"]) {
        // 人物骨骼 -> @"显示骨骼"
        人物骨骼 = MenuGetBool(@"显示骨骼", 人物骨骼);
        initialValue = 人物骨骼;
    } else if ([key isEqualToString:@"AAjuli"]) {
        // 人物信息 -> @"显示信息"
        人物信息 = MenuGetBool(@"显示信息", 人物信息);
        initialValue = 人物信息;
    } else if ([key isEqualToString:@"AAmingzi"]) {
        // 距离显示 -> @"显示距离"
        距离显示 = MenuGetBool(@"显示距离", 距离显示);
        initialValue = 距离显示;
    } else if ([key isEqualToString:@"AAbeidi"]) {
        // 背敌显示 -> @"显示背敌"
        背敌显示 = MenuGetBool(@"显示背敌", 背敌显示);
        initialValue = 背敌显示;
    } else if ([key isEqualToString:@"AAleida"]) {
        // 雷达图 -> 雷达开关（与雷达配置页共用）
        initialValue = 雷达开关;
    } else if ([key isEqualToString:@"AAduibiao"]) {
        // 隐藏人机 -> @"人机隐藏"
        隐藏人机 = MenuGetBool(@"人机隐藏", 隐藏人机);
        initialValue = 隐藏人机;
    } else if ([key isEqualToString:@"AAshouleiyujing"]) {
        // 手雷预警 -> @"手雷预警"
        手雷预警 = MenuGetBool(@"手雷预警", 手雷预警);
        initialValue = 手雷预警;
    } else if ([key isEqualToString:@"AAxianshizhenlv"]) {
        // 绘制模型 -> @"绘制模型"
        绘制模型 = MenuGetBool(@"绘制模型", 绘制模型);
        initialValue = 绘制模型;
    } else if ([key isEqualToString:@"AAhuizhiyan"]) {
        // 绘制掩体 -> @"绘制掩体"
        绘制掩体 = MenuGetBool(@"绘制掩体", 绘制掩体);
        initialValue = 绘制掩体;
    } else if ([key isEqualToString:@"AAduijuxianshi"]) {
        对局显示 = MenuGetBool(@"对局显示", 对局显示);
        initialValue = 对局显示;
    } else if ([key isEqualToString:@"AAyantibiaose"]) {
        掩体变色调试 = MenuGetBool(@"掩体变色调试", 掩体变色调试);
        initialValue = 掩体变色调试;
    } else if ([key isEqualToString:@"AAzhibomoshi"]) {
        // 直播模式 -> 主界面里的 @"直播"（防录屏）
        直播模式 = MenuGetBool(@"直播", 直播模式);
        initialValue = 直播模式;
    } else if ([key isEqualToString:@"AAleida"]) {
        initialValue = 雷达开关;
    } else if ([key isEqualToString:@"AAwzpqwq"]) {
        initialValue = 突击步枪;
    } else if ([key isEqualToString:@"AAwzjqwq"]) {
        initialValue = 机枪武器;
    } else if ([key isEqualToString:@"AAwzjjqx"]) {
        initialValue = 狙击枪械;
    } else if ([key isEqualToString:@"AAwzcfqx"]) {
        initialValue = 冲锋枪械;
    } else if ([key isEqualToString:@"AAwzsdqx"]) {
        initialValue = 散弹枪械;
    } else if ([key isEqualToString:@"AAwzsqwq"]) {
        initialValue = 手枪武器;
    } else if ([key isEqualToString:@"AAwzgjwq"]) {
        initialValue = 弓箭武器;
    } else if ([key isEqualToString:@"AAwzjzwq"]) {
        initialValue = 近战武器;
    }else if ([key isEqualToString:@"AAwzssbq"]) {
        initialValue = 射手步枪;
    } else if ([key isEqualToString:@"AAwzptwp"]) {
        initialValue = 投掷物品;
    } else if ([key isEqualToString:@"AAwzpqdj"]) {
        initialValue = 步枪弹夹;
    } else if ([key isEqualToString:@"AAwzjjdj"]) {
        initialValue = 狙击弹夹;
    } else if ([key isEqualToString:@"AAwzcfqdj"]) {
        initialValue = 冲锋弹夹;
    } else if ([key isEqualToString:@"AAwzwbpj"]) {
        initialValue = 握把配件;
    } else if ([key isEqualToString:@"AAwzbqbcq"]) {
        initialValue = 步枪补偿;
    } else if ([key isEqualToString:@"AAwzjjqbcq"]) {
        initialValue = 狙击补偿;
    }else if ([key isEqualToString:@"AAwzcfqbcq"]) {
        initialValue = 冲锋补偿;
    } else if ([key isEqualToString:@"AAwzwqqtpj"]) {
        initialValue = 枪托配件;
    } else if ([key isEqualToString:@"AAwzwqqtpj"]) {
        initialValue = 武器子弹;
    } else if ([key isEqualToString:@"AAwzwqbjpj"]) {
        initialValue = 倍镜配件;
    } else if ([key isEqualToString:@"AAwzxszj"]) {
        initialValue = 显示载具;
    } else if ([key isEqualToString:@"AAwzxstj"]) {
        initialValue = 显示头甲;
    } else if ([key isEqualToString:@"AAwzxsbp"]) {
        initialValue = 显示背包;
    } else if ([key isEqualToString:@"AAwzktxs"]) {
        initialValue = 空投显示;
    } else if ([key isEqualToString:@"AAwzxhq"]) {
        initialValue = 信号枪;
    }else if ([key isEqualToString:@"AAwzjjhjq"]) {
        initialValue = 紧急呼救器;
    } else if ([key isEqualToString:@"AAwzhnwz"]) {
        // 盒内物资 -> @"盒内物资"
        盒内物资 = MenuGetBool(@"盒内物资", 盒内物资);
        initialValue = 盒内物资;
    } else if ([key isEqualToString:@"AAwzxsyp"]) {
        // 显示药品 -> @"显示药品"
        显示药品 = MenuGetBool(@"显示药品", 显示药品);
        initialValue = 显示药品;
    } else if ([key isEqualToString:@"AAwzxshz"]) {
        // 显示盒子 -> @"显示盒子"
        显示盒子 = MenuGetBool(@"显示盒子", 显示盒子);
        initialValue = 显示盒子;
    }else if ([key isEqualToString:@"AAwzbbwz"]) {
        initialValue = 版本物资;
    } else if ([key isEqualToString:@"AAwzdtwz"]) {
        // 地铁物资 -> @"地铁物资"
        地铁物资 = MenuGetBool(@"地铁物资", 地铁物资);
        initialValue = 地铁物资;
    } else if ([key isEqualToString:@"AAwzdthz"]) {
        // 地铁盒子 -> @"地铁盒子"
        地铁盒子 = MenuGetBool(@"地铁盒子", 地铁盒子);
        initialValue = 地铁盒子;
    } else if ([key isEqualToString:@"AAtswzlei"]) {//调试
        initialValue = 调试物资;
    } else if ([key isEqualToString:@"AAtshnid"]) {//调试
        initialValue = 调试盒内;
    } else if ([key isEqualToString:@"AAtswzsc"]) {//调试
        initialValue = 调试手持;
    }
    
    
    
    customSwitch.on = initialValue;
    
    // 添加值变化事件处理
    [customSwitch addTarget:self
                     action:@selector(customSwitchValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    
    //使用 @selector 作为 key它是编译期确定的，不受字符串加密影响
    objc_setAssociatedObject(customSwitch, @selector(customSwitchValueChanged:), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 将标签和开关添加到容器
    [container addSubview:label];
    [container addSubview:customSwitch];
    
    // 将容器添加到菜单
    [self.menuContainer addSubview:container];
}



// 添加滑动条控件方法
- (void)addCustomSliderWithTitle:(NSString *)title
                             key:(NSString *)key
                         yOffset:(CGFloat *)yOffset
                        minValue:(float)minValue
                        maxValue:(float)maxValue
                    defaultValue:(float)defaultValue {
    
    
    /*单个滑动条为一排*/
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(self.contentStartXOffset, *yOffset, self.menuContainer.bounds.size.width - self.contentStartXOffset - 10, 34)];
    
    CGFloat rightLabelWidth = 90;
    CGFloat sliderWidth = container.bounds.size.width - rightLabelWidth - 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(container.bounds.size.width - rightLabelWidth, 0, rightLabelWidth, 34)];
    label.text = title;
    label.textColor = APPLE_LABEL;
    label.font = [UIFont systemFontOfSize:统一字体大小 weight:UIFontWeightRegular];
    label.textAlignment = NSTextAlignmentRight;
    [container addSubview:label];
    
    // 左侧滑动条（胶囊）
    CustomSliderView *slider = [[CustomSliderView alloc] initWithFrame:CGRectMake(0, 2, sliderWidth, 30)];
    slider.minValue = minValue;
    slider.maxValue = maxValue;
    
    float initialValue = defaultValue;
    if ([key isEqualToString:@"AAdrawDistance"]) {
        initialValue = 绘制距离;
    } else if ([key isEqualToString:@"AAradarX"]) {
        initialValue = 雷达位置X;
    } else if ([key isEqualToString:@"AAradarY"]) {
        initialValue = 雷达位置Y;
    } else if ([key isEqualToString:@"AAradarSize"]) {
        initialValue = 雷达大小;
    }
    
    slider.value = initialValue;
    
    // 将滑动条添加到容器
    [container addSubview:slider];
    
    // 中间蓝色数值（覆盖在滑条上）
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:slider.frame];
    valueLabel.textColor = APPLE_ACCENT;
    valueLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    // 添加发光效果让文字更亮
    // valueLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    // valueLabel.layer.shadowOffset = CGSizeMake(0, 0);
    // valueLabel.layer.shadowRadius = 2.0;
    // valueLabel.layer.shadowOpacity = 0.8;
    
    NSString *valueFormat = @"%.0f";
    if ([key isEqualToString:@"AAradarX"] || [key isEqualToString:@"AAradarY"]) {
        valueFormat = @"%.2f";
    }
    valueLabel.text = [NSString stringWithFormat:valueFormat, slider.value];
    
    // 关键：将值标签添加到容器，并确保在最上层
    [container addSubview:valueLabel];
    [container bringSubviewToFront:valueLabel];
    
    __weak id weakSelf = self;
    slider.valueChanged = ^(float value) {
        valueLabel.text = [NSString stringWithFormat:valueFormat, value];
        [weakSelf sliderValueChanged:value forKey:key];
    };
    
    [self.menuContainer addSubview:container];
}




//存储版本
- (void)sliderValueChanged:(float)value forKey:(NSString *)key {
    if ([key isEqualToString:@"AAdrawDistance"]) {
        绘制距离 = value;
        [[NSUserDefaults standardUserDefaults] setFloat:value forKey:kMapWidthKey];
    } else if ([key isEqualToString:@"AAradarX"]) {
        雷达位置X = value;
    } else if ([key isEqualToString:@"AAradarY"]) {
        雷达位置Y = value;
    } else if ([key isEqualToString:@"AAradarSize"]) {
        雷达大小 = value;
    }
    
    // 立即同步到磁盘
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 修改开关值变化处理方法
- (void)customSwitchValueChanged:(CustomSwitchView *)sender {
    
    // 获取关联的key
    //使用 @selector 作为 key它是编译期确定的，不受字符串加密影响
    NSString *key = objc_getAssociatedObject(sender, @selector(customSwitchValueChanged:));
    
    
    
    
    // 根据key设置对应的全局变量，并同步到主界面共用的配置存储
    if ([key isEqualToString:@"AAshexian"]) {
        显示人数 = sender.isOn;
        MenuSetBool(@"显示人数", 显示人数);
    } else if ([key isEqualToString:@"AAguge"]) {
        人物射线 = sender.isOn;
        MenuSetBool(@"显示射线", 人物射线);
    } else if ([key isEqualToString:@"AArenshu"]) {
        人物血条 = sender.isOn;
        MenuSetBool(@"显示血量", 人物血条);
    } else if ([key isEqualToString:@"AAxueliang"]) {
        人物骨骼 = sender.isOn;
        MenuSetBool(@"显示骨骼", 人物骨骼);
    } else if ([key isEqualToString:@"AAjuli"]) {
        人物信息 = sender.isOn;
        MenuSetBool(@"显示信息", 人物信息);
    } else if ([key isEqualToString:@"AAmingzi"]) {
        距离显示 = sender.isOn;
        MenuSetBool(@"显示距离", 距离显示);
    } else if ([key isEqualToString:@"AAbeidi"]) {
        背敌显示 = sender.isOn;
        MenuSetBool(@"显示背敌", 背敌显示);
    } else if ([key isEqualToString:@"AAleida"]) {
        雷达开关 = sender.isOn;
    } else if ([key isEqualToString:@"AAduibiao"]) {
        隐藏人机 = sender.isOn;
        MenuSetBool(@"人机隐藏", 隐藏人机);
    } else if ([key isEqualToString:@"AAshouleiyujing"]) {
        手雷预警 = sender.isOn;
        MenuSetBool(@"手雷预警", 手雷预警);
    } else if ([key isEqualToString:@"AAxianshizhenlv"]) {
        绘制模型 = sender.isOn;
        MenuSetBool(@"绘制模型", 绘制模型);
    } else if ([key isEqualToString:@"AAhuizhiyan"]) {
        绘制掩体 = sender.isOn;
        MenuSetBool(@"绘制掩体", 绘制掩体);
    } else if ([key isEqualToString:@"AAduijuxianshi"]) {
        对局显示 = sender.isOn;
        MenuSetBool(@"对局显示", 对局显示);
    } else if ([key isEqualToString:@"AAyantibiaose"]) {
        掩体变色调试 = sender.isOn;
        MenuSetBool(@"掩体变色调试", 掩体变色调试);
    } else if ([key isEqualToString:@"AAzhibomoshi"]) {
        直播模式 = sender.isOn;
        MenuSetBool(@"直播", 直播模式);
        [self enableLiveStreamProtection:sender.isOn];
    } else if ([key isEqualToString:@"AAleida"]) {
        雷达开关 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzpqwq"]) {
        突击步枪 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzjqwq"]) {
        机枪武器 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzjjqx"]) {
        狙击枪械 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzcfqx"]) {
        冲锋枪械 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzsdqx"]) {
        散弹枪械 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzsqwq"]) {
        手枪武器 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzgjwq"]) {
        弓箭武器 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzjzwq"]) {
        近战武器 = sender.isOn;
    }else if ([key isEqualToString:@"AAwzssbq"]) {
        射手步枪 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzptwp"]) {
        投掷物品 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzpqdj"]) {
        步枪弹夹 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzjjdj"]) {
        狙击弹夹 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzcfqdj"]) {
        冲锋弹夹 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzwbpj"]) {
        握把配件 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzbqbcq"]) {
        步枪补偿 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzjjqbcq"]) {
        狙击补偿 = sender.isOn;
    }else if ([key isEqualToString:@"AAwzcfqbcq"]) {
        冲锋补偿 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzwqqtpj"]) {
        枪托配件 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzwqqtpj"]) {
        武器子弹 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzwqbjpj"]) {
        倍镜配件 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzxszj"]) {
        显示载具 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzxstj"]) {
        显示头甲 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzxsbp"]) {
        显示背包 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzktxs"]) {
        空投显示 = sender.isOn;
        MenuSetBool(@"显示空投", 空投显示);
    } else if ([key isEqualToString:@"AAwzxhq"]) {
        信号枪 = sender.isOn;
    }else if ([key isEqualToString:@"AAwzjjhjq"]) {
        紧急呼救器 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzhnwz"]) {
        盒内物资 = sender.isOn;
        MenuSetBool(@"盒内物资", 盒内物资);
    } else if ([key isEqualToString:@"AAwzxsyp"]) {
        显示药品 = sender.isOn;
        MenuSetBool(@"显示药品", 显示药品);
    } else if ([key isEqualToString:@"AAwzxshz"]) {
        显示盒子 = sender.isOn;
        MenuSetBool(@"显示盒子", 显示盒子);
    }else if ([key isEqualToString:@"AAwzbbwz"]) {
        版本物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzdtwz"]) {
        地铁物资 = sender.isOn;
        MenuSetBool(@"地铁物资", 地铁物资);
    } else if ([key isEqualToString:@"AAwzdthz"]) {
        地铁盒子 = sender.isOn;
        MenuSetBool(@"地铁盒子", 地铁盒子);
    } else if ([key isEqualToString:@"AAtswzlei"]) {//调试
        调试物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAtshnid"]) {//调试
        调试盒内 = sender.isOn;
    } else if ([key isEqualToString:@"AAtswzsc"]) {//调试
        调试手持 = sender.isOn;
    }
    
    
    
    // NSLog(@"%@ changed to %@", key, sender.isOn ? @"ON" : @"OFF");
}



// 从后往前遍历子视图，使顶层控件（按钮、开关等）先于毛玻璃被命中，避免无法点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || self.alpha <= 0.01 || !self.userInteractionEnabled) {
        return nil;
    }

    CGPoint menuPoint = [self convertPoint:point toView:self.menuContainer];
    if (!CGRectContainsPoint(self.menuContainer.bounds, menuPoint)) {
        return nil;
    }

    UIView *hitView = [self.menuContainer hitTest:menuPoint withEvent:event];
    return hitView ?: self.menuContainer;
}

// 简化触摸事件处理 - 只处理拖动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    // 只处理菜单容器的拖动
    if (CGRectContainsPoint(self.titleBackgroundView.frame, touchLocation)) {
        self.isMoveWindow = YES;
        self.startTouchPoint = [touch locationInView:self.superview];
        self.activeTouch = touch;
    }
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isMoveWindow && self.activeTouch && [touches containsObject:self.activeTouch]) {
        CGPoint currentPoint = [self.activeTouch locationInView:self.superview];
        CGFloat dx = currentPoint.x - self.startTouchPoint.x;
        CGFloat dy = currentPoint.y - self.startTouchPoint.y;

        CGPoint targetCenter = CGPointMake(self.menuContainer.center.x + dx,
                                           self.menuContainer.center.y + dy);
        CGFloat halfW = CGRectGetWidth(self.menuContainer.bounds) * 0.5;
        CGFloat halfH = CGRectGetHeight(self.menuContainer.bounds) * 0.5;
        CGFloat minX = halfW + 8.0;
        CGFloat maxX = CGRectGetWidth(self.bounds) - halfW - 8.0;
        CGFloat minY = halfH + 8.0;
        CGFloat maxY = CGRectGetHeight(self.bounds) - halfH - 8.0;

        if (maxX >= minX) targetCenter.x = fmax(minX, fmin(maxX, targetCenter.x));
        if (maxY >= minY) targetCenter.y = fmax(minY, fmin(maxY, targetCenter.y));
        self.menuContainer.center = targetCenter;
        
        self.startTouchPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.activeTouch && [touches containsObject:self.activeTouch]) {
        [self resetTouchState];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.activeTouch && [touches containsObject:self.activeTouch]) {
        [self resetTouchState];
    }
}
// 重置触摸状态
- (void)resetTouchState {
    self.isMoveWindow = NO;
    self.activeTouch = nil;
    self.startTouchPoint = CGPointZero;
}

// 修改帧率开关值变化方法，实现单选功能
- (void)fpsSwitchValueChanged:(CustomSwitchView2 *)sender {
    NSString *fpsValue = objc_getAssociatedObject(sender, @selector(fpsSwitchValueChanged:));
    int selectedFPS = [fpsValue intValue];
    
    // 如果点击的是已经选中的开关，不允许取消选择（保持选中状态）
    if (!sender.isOn) {
        sender.on = YES;
        return;
    }
    
    // 更新当前帧率
    当前帧率 = selectedFPS;
    
    // 查找同一容器内的所有帧率开关，关闭其他的
    UIView *container = sender.superview;
    for (UIView *subview in container.subviews) {
        if ([subview isKindOfClass:[CustomSwitchView2 class]] && subview != sender) {
            CustomSwitchView2 *otherSwitch = (CustomSwitchView2 *)subview;
            NSString *otherFPSValue = objc_getAssociatedObject(otherSwitch, @selector(fpsSwitchValueChanged:));
            
            // 如果是帧率选项开关（通过关联对象判断），则关闭
            if (otherFPSValue) {
                otherSwitch.on = NO;
            }
        }
    }
}

#pragma mark - 系统时间实时更新
- (void)startSystemTimeUpdate {
    // 立即更新一次
    [self updateSystemTimeDisplay];
    
    // 创建定时器，每秒更新一次
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateSystemTimeDisplay)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateSystemTimeDisplay {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    self.expiryLabel.text = [NSString stringWithFormat:@"系统时间:%@", currentTime];
}

//hook调用过直播容器开关
- (void)enableLiveStreamProtection:(BOOL)enable {
    // 通过响应者链找到主悬浮球ViewController
    UIResponder *responder = self.nextResponder;
    
    while (responder != nil) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)responder;
            
            // 查找过直播容器
            UIView *过直播容器 = [self findLiveStreamContainerInView:vc.view];
            
            if (过直播容器 && [过直播容器 respondsToSelector:@selector(enableLiveStreamProtection:)]) {
                [(id)过直播容器 enableLiveStreamProtection:enable];
                // [self makeToast:enable ? @"过直播保护已启用" : @"过直播保护已禁用"];
                break;
            }
        }
        responder = responder.nextResponder;
    }
}

//在视图层次中查找过直播容器
- (UIView *)findLiveStreamContainerInView:(UIView *)view {
    // 通过视图的类名查找
    if ([NSStringFromClass([view class]) containsString:@"ff177164a78ba0d9215d1404e6916"] ||
        [view isKindOfClass:NSClassFromString(@"ff177164a78ba0d9215d1404e6916")]) {
        return view;
    }
    
    // 递归查找子视图
    for (UIView *subview in view.subviews) {
        UIView *result = [self findLiveStreamContainerInView:subview];
        if (result) {
            return result;
        }
    }
    
    return nil;
}
//hook调用过直播容器开关

@end
