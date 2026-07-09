//  QQ1587820860
//  Created by LAN on 2025/7/24.
//  Copyright 2025 LAN. All rights reserved.
#import "oc悬浮菜单.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "三级铠甲体.h"

#define 统一主题颜色 [UIColor colorWithRed:0.15f green:0.75f blue:0.95f alpha:1.0f]//降低饱和度的蓝青色 不刺眼

#define 开关轨道统一颜色 [UIColor colorWithRed:0.16f green:0.29f blue:0.48f alpha:0.54f] //暗蓝色

#define 勾选和滑块统一颜色 [UIColor colorWithRed:0.26f green:0.59f blue:0.98f alpha:1.0f] //亮蓝色

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
BOOL 手持开关 = NO;
BOOL 隐藏人机 = NO;
BOOL 手雷预警 = NO;
BOOL 显示帧率 = NO;
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
BOOL 盒内物资 = NO;
BOOL 显示药品 = NO;
BOOL 显示盒子 = NO;
BOOL 版本物资 = NO;
BOOL 地铁物资 = NO;
BOOL 地铁盒子 = NO;

int 当前帧率 = 120;

BOOL 调试物资 = NO;
BOOL 调试盒内 = NO;
BOOL 调试手持 = NO;

float 绘制距离 = 300.0f;
float 雷达位置X = 0.85f;
float 雷达位置Y = 0.15f;
float 雷达大小 = 50.0f;

@interface 加载自定义字体 : NSObject //使用自定义字体加载需要导入 CoreText.framework
@end
@implementation 加载自定义字体

+ (UIFont *)customFontWithSize:(CGFloat)size {
    static NSString *fontName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *fontData = [NSData dataWithBytes:三级铠甲体 length:三级铠甲体_len];
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
        
        CTFontManagerRegisterGraphicsFont(fontRef, NULL);
        fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
        
        CGFontRelease(fontRef);
        CGDataProviderRelease(provider);
    });
    
    return [UIFont fontWithName:fontName size:size];
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
        self.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.35 alpha:0.8];
        self.titleLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (!self.isSelected) {
        self.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.3 alpha:0.6];
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
        _trackView.backgroundColor = [UIColor colorWithWhite:0.18 alpha:1.0];
        _trackView.layer.cornerRadius = trackHeight / 2.0;
        _trackView.layer.masksToBounds = YES;
        [self addSubview:_trackView];
        
        _activeTrackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, trackHeight)];
        _activeTrackView.layer.cornerRadius = trackHeight / 2.0;
        _activeTrackView.layer.masksToBounds = YES;
        _activeTrackView.backgroundColor = 勾选和滑块统一颜色;
        _activeTrackView.alpha = 0.18;
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
        _boxView.backgroundColor = [UIColor colorWithWhite:0.16 alpha:1.0];
        _boxView.layer.cornerRadius = 6.0;
        _boxView.layer.borderWidth = 1.0;
        _boxView.layer.borderColor = [UIColor colorWithWhite:0.28 alpha:1.0].CGColor;
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
    checkmarkLayer.strokeColor = _checkmarkColor.CGColor;
    checkmarkLayer.lineWidth = 3;
    checkmarkLayer.lineCap = kCALineCapRound;
    checkmarkLayer.lineJoin = kCALineJoinRound;
    [_checkmarkView.layer addSublayer:checkmarkLayer];
}

- (void)updateUIAnimated:(BOOL)animated {
    _boxView.backgroundColor = [UIColor colorWithWhite:0.16 alpha:1.0];
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
        _boxView.backgroundColor = 开关轨道统一颜色;
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

#pragma mark - ImGuiMenu主界面实现
@interface 自用oc悬浮菜单 ()
// 菜单容器视图
@property (nonatomic, strong) UIView *menuContainer;
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

//切换页面按钮相关
@property (nonatomic, assign) MenuPageType currentPage;
@property (nonatomic, strong) NSArray<UIButton *> *pageButtons;
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
        
        // 设置透明背景
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;//应用扩大 开关按钮点击区域
        
        // 初始化菜单UI
        [self setupMenuUI];
    }
    return self;
}

- (void)setupMenuUI {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    // 增加菜单高度以容纳页面切换按钮
    CGFloat menuWidth = 520;
    CGFloat menuHeight = 320;
    
    self.menuContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, menuHeight)];
    self.menuContainer.center = CGPointMake(screenBounds.size.width/2, screenBounds.size.height/2 + 20);
    
    //高仿imgui菜单的深色背景
    self.menuContainer.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.06 alpha:0.85];
    self.menuContainer.layer.borderWidth = 0.5;  // 稍微细一点更精致
    self.menuContainer.layer.borderColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.45f alpha:0.7f].CGColor;//和分割线颜色一致
    
    // 设置圆角
    self.menuContainer.layer.cornerRadius = 2;
    // 裁剪超出圆角部分
    self.menuContainer.layer.masksToBounds = YES;
    
    
    self.menuContainer.userInteractionEnabled = YES; // 关键：确保菜单容器可以接收子视图的触摸
    self.menuContainer.clipsToBounds = NO;// 重要：允许子视图超出边界响应触摸
    
    [self addSubview:self.menuContainer];
    
    
    
    // === 先添加标题背景色区域 ===
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuWidth, 25)];
    
    //高仿imgui菜单的标题蓝
    titleBackground.backgroundColor = [UIColor colorWithRed:0.10f green:0.10f blue:0.12f alpha:1.00f];
    self.menuContainer.alpha = 0.95f;//如果模仿半透明的那个必须设置 这个透明度
    titleBackground.layer.cornerRadius = 2.0f; // 圆角大小，和容器一致
    titleBackground.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner; // 只设置左上和右上圆角
    titleBackground.layer.masksToBounds = YES; // 必须设置为YES才能显示圆角效果
    [self.menuContainer addSubview:titleBackground];
    self.titleBackgroundView = titleBackground;
    
    // === 添加分割线 ===
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 25, menuWidth, 1.0)];
    separatorLine.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.45f alpha:0.7f];
    [self.menuContainer addSubview:separatorLine];
    self.separatorLineView = separatorLine;
    
    // 创建标题标签
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -2, menuWidth - 52, 30)]; // 右侧给关闭按钮预留空间
    self.titleLabel.text = @"心悦青春版";
    //self.titleLabel.textAlignment = NSTextAlignmentCenter;//居中显示
    self.titleLabel.textAlignment = NSTextAlignmentLeft;// 改为左对齐显示
    self.titleLabel.textColor = [UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0];
    self.titleLabel.font = [加载自定义字体 customFontWithSize:16];
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.titleLabel.layer.shadowOpacity = 0.7;
    self.titleLabel.layer.shadowRadius = 1;
    [self.menuContainer addSubview:self.titleLabel];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(menuWidth - 32, 0, 32, 25);
    [self.closeButton setTitle:@"X" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:self.closeButton];
    
    // 创建到期时间标签 - 在标题右边
    self.expiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, -2, menuWidth - 110, 30)]; // 从100开始，右边留10边距
    NSString *dateString = @"xxxx";
    if (dateString) {
        
        self.expiryLabel.text = [NSString stringWithFormat:@"到期时间:%@", dateString];
    } else {
        //以防特殊情况出错
        
        [self startSystemTimeUpdate];
        //   NSLog(@"无法获取到期时间");
        //pid_t mainAppPid = getppid();
        // kill(mainAppPid, SIGKILL); // 先杀死主程序应用
    }
    //expiryLabel.text = @"到期时间:2025-12-04 23:16";
    self.expiryLabel.textAlignment = NSTextAlignmentRight; // 右对齐
    self.expiryLabel.textColor = [UIColor colorWithRed:235/255.0f green:160/255.0f blue:45/255.0f alpha:1.0f];
    self.expiryLabel.font = [加载自定义字体 customFontWithSize:统一字体大小];
    self.expiryLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.expiryLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.expiryLabel.layer.shadowOpacity = 0.7;
    self.expiryLabel.layer.shadowRadius = 1;
    [self.menuContainer addSubview:self.expiryLabel];
    self.expiryLabel.hidden = YES;
    
    self.themeMode = (MenuThemeMode)[[NSUserDefaults standardUserDefaults] integerForKey:kTSMenuThemeModeKey];
    
    // 添加页面切换按钮（在分隔线之前）
    [self addPageSwitchButtons];
    
    [self setupThemeRow];
    [self applyThemeMode:self.themeMode];
    
    // 创建分隔线 - 调整位置到主题行下方
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(20, 100, menuWidth - 40, 1)];
    separator.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.menuContainer addSubview:separator];
    self.contentSeparatorView = separator;
    
    
    self.contentStartYOffset = 105;
    self.currentYOffset = self.contentStartYOffset;//创建功能开关在 页面切换按钮下方
    self.contentStartXOffset = CGRectGetMaxX(self.tabContainerView.frame) + 10;
    
    // 设置默认页面
    self.currentPage = MenuPageTypeCharacter;
    
    [self setupResizeHandle];
    [self updateMenuLayoutFrames];
    [self updateMenuContent];
}

// 添加页面切换按钮
- (void)addPageSwitchButtons {
    CGFloat buttonWidth = 90;
    CGFloat buttonHeight = 32;
    
    NSArray *buttonTitles = @[@"人物绘制", @"枪械物资", @"其他物资", @"高级设置", @"雷达配置"];
    NSMutableArray *buttons = [NSMutableArray array];
    
    // 创建选项卡容器背景 - 位置调整到标题区域下方
    CGFloat tabY = 30;
    CGFloat tabH = self.menuContainer.bounds.size.height - tabY;
    UIView *tabContainer = [[UIView alloc] initWithFrame:CGRectMake(0, tabY, buttonWidth, tabH)];
    tabContainer.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.18 alpha:0.8];
    tabContainer.layer.cornerRadius = 0; // 直角
    tabContainer.layer.borderWidth = 0; // 去掉边框
    [self.menuContainer addSubview:tabContainer];
    self.tabContainerView = tabContainer;
    
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        // 使用自定义按钮类 - 紧密排列，不留空隙
        CustomPageButton *pageButton = [[CustomPageButton alloc] initWithFrame:CGRectMake(0, i * buttonHeight, buttonWidth, buttonHeight)];
        
        // 使用自定义字体
        pageButton.titleLabel.font = [加载自定义字体 customFontWithSize:14]; // 使用14号字体，20可能太大
        
        pageButton.titleLabel.text = buttonTitles[i];
        
        // 设置标签以便识别
        pageButton.tag = i;
        pageButton.isSelected = (i == 0);
        
        // 添加分隔线（除了最后一个）
        if (i + 1 < buttonTitles.count) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(8, (i + 1) * buttonHeight, buttonWidth - 16, 1)];
            separator.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
            separator.tag = 9000 + i;
            [tabContainer addSubview:separator];
        }
        
        // 添加值变化事件处理
        [pageButton addTarget:self
                       action:@selector(pageButtonValueChanged:)
             forControlEvents:UIControlEventValueChanged];
        
        [tabContainer addSubview:pageButton];
        [buttons addObject:pageButton];
    }
    self.pageButtons = [buttons copy];
    
    // === 纵向分割线：选项卡与内容区之间 ===
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth, tabY, 1.0, tabH)];
    bottomSeparator.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.45f alpha:0.7f];
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
    shape.strokeColor = [UIColor colorWithWhite:0.9 alpha:0.65].CGColor;
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
    
    self.titleBackgroundView.frame = CGRectMake(0, 0, menuWidth, 25);
    self.separatorLineView.frame = CGRectMake(0, 25, menuWidth, 1.0);
    self.titleLabel.frame = CGRectMake(10, -2, menuWidth - 52, 30);
    self.closeButton.frame = CGRectMake(menuWidth - 32, 0, 32, 25);
    self.expiryLabel.frame = CGRectMake(100, -2, menuWidth - 110, 30);
    
    CGFloat tabY = 30;
    CGFloat tabW = 90;
    CGFloat tabH = menuHeight - tabY;
    self.tabContainerView.frame = CGRectMake(0, tabY, tabW, tabH);
    
    CGFloat tabButtonH = 32;
    for (NSInteger i = 0; i < self.pageButtons.count; i++) {
        UIView *v = self.pageButtons[i];
        v.frame = CGRectMake(0, i * tabButtonH, tabW, tabButtonH);
    }
    for (NSInteger i = 0; i + 1 < self.pageButtons.count; i++) {
        UIView *separator = [self.tabContainerView viewWithTag:9000 + i];
        if (separator) {
            separator.frame = CGRectMake(8, (i + 1) * tabButtonH, tabW - 16, 1);
        }
    }
    
    self.bottomSeparatorView.frame = CGRectMake(tabW, tabY, 1.0, tabH);
    
    CGFloat contentX = tabW + 10;
    self.contentStartXOffset = contentX;
    
    CGFloat themeY = 65;
    CGFloat themeH = 30;
    self.themeRowView.frame = CGRectMake(contentX, themeY, menuWidth - contentX, themeH);
    
    CGFloat segmentW = self.themeRowView.bounds.size.width / 3.0;
    for (NSInteger i = 0; i < 3; i++) {
        CustomSwitchView2 *sw = (CustomSwitchView2 *)[self.themeRowView viewWithTag:9100 + i];
        UILabel *lb = (UILabel *)[self.themeRowView viewWithTag:9200 + i];
        if (!sw || !lb) continue;
        CGFloat x = i * segmentW + 10;
        sw.frame = CGRectMake(x, 3, 44, 24);
        lb.frame = CGRectMake(x + 40, 0, segmentW - 50, themeH);
    }
    
    self.contentSeparatorView.frame = CGRectMake(contentX, 100, menuWidth - contentX - 10, 1);
    self.contentStartYOffset = 105;
    self.currentYOffset = self.contentStartYOffset;
    
    CGFloat handleSize = self.resizeHandleView.bounds.size.width;
    self.resizeHandleView.frame = CGRectMake(menuWidth - handleSize, menuHeight - handleSize, handleSize, handleSize);
    [self.menuContainer bringSubviewToFront:self.resizeHandleView];
}

// 页面按钮值变化处理
- (void)pageButtonValueChanged:(CustomPageButton *)sender {
    // 更新当前页面
    if (sender.tag == 0) self.currentPage = MenuPageTypeCharacter;
    else if (sender.tag == 1) self.currentPage = MenuPageTypeItems;
    else if (sender.tag == 2) self.currentPage = MenuPageTypeAimbot;
    else if (sender.tag == 3) self.currentPage = MenuPageTypeAdvanced;
    else self.currentPage = MenuPageTypeRadar;
    
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
            [view isEqual:self.resizeHandleView]) {
            continue;
        }
        if (view.frame.origin.y >= self.contentStartYOffset) {
            [view removeFromSuperview];
        }
    }
    
    // 重置Y轴偏移量
    self.currentYOffset = self.contentStartYOffset;
    
    // 根据当前页面添加对应的控件
    switch (self.currentPage) {
        case MenuPageTypeCharacter:
            [self addFunctionSwitches];
            break;
        case MenuPageTypeItems:
            [self addItemsPageControls];
            break;
        case MenuPageTypeAimbot:
            [self addAimbotPageControls];
            break;
        case MenuPageTypeAdvanced:
            [self addAdvancedPageControls];
            break;
        case MenuPageTypeRadar:
            [self addRadarPageControls];
            break;
    }
    
    if (self.resizeHandleView) {
        [self.menuContainer bringSubviewToFront:self.resizeHandleView];
    }
}

- (void)setupThemeRow {
    CGFloat rowY = 65;
    CGFloat rowHeight = 30;
    CGFloat contentX = CGRectGetMaxX(self.tabContainerView.frame) + 10;
    self.contentStartXOffset = contentX;
    self.themeRowView = [[UIView alloc] initWithFrame:CGRectMake(contentX, rowY, self.menuContainer.bounds.size.width - contentX, rowHeight)];
    [self.menuContainer addSubview:self.themeRowView];
    
    NSArray<NSString *> *titles = @[@"深色模式", @"浅色模式", @"黑色模式"];
    NSMutableArray<CustomSwitchView2 *> *switches = [NSMutableArray array];
    CGFloat segmentW = self.themeRowView.bounds.size.width / 3.0;
    for (NSInteger i = 0; i < titles.count; i++) {
        CGFloat x = i * segmentW + 10;
        CustomSwitchView2 *sw = [[CustomSwitchView2 alloc] initWithFrame:CGRectMake(x, 3, 44, 24)];
        sw.tag = 9100 + i;
        sw.on = (self.themeMode == (MenuThemeMode)i);
        [sw addTarget:self action:@selector(themeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(sw, @selector(themeSwitchValueChanged:), @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.themeRowView addSubview:sw];
        [switches addObject:sw];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x + 40, 0, segmentW - 50, rowHeight)];
        label.tag = 9200 + i;
        label.text = titles[i];
        label.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        label.font = [加载自定义字体 customFontWithSize:统一字体大小];
        [self.themeRowView addSubview:label];
    }
    self.themeSwitches = [switches copy];
}

- (void)applyThemeMode:(MenuThemeMode)mode {
    UIColor *containerColor = nil;
    UIColor *titleColor = nil;
    UIColor *tabColor = nil;
    UIColor *textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    if (mode == MenuThemeModeLight) {
        containerColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.20 alpha:0.92];
        titleColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.25 alpha:1.0];
        tabColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.23 alpha:0.9];
    } else if (mode == MenuThemeModeBlack) {
        containerColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.02 alpha:0.92];
        titleColor = [UIColor colorWithRed:0.06 green:0.06 blue:0.06 alpha:1.0];
        tabColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:0.9];
    } else {
        containerColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.06 alpha:0.88];
        titleColor = [UIColor colorWithRed:0.10f green:0.10f blue:0.12f alpha:1.00f];
        tabColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.18 alpha:0.85];
    }
    self.menuContainer.backgroundColor = containerColor;
    self.titleBackgroundView.backgroundColor = titleColor;
    self.tabContainerView.backgroundColor = tabColor;
    self.titleLabel.textColor = textColor;
}

- (void)closeButtonTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTSMenuCloseNotification object:nil];
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
    // 计算每列宽度（4列布局）
    CGFloat contentWidth = self.menuContainer.bounds.size.width - self.contentStartXOffset - 10;
    CGFloat columnWidth = contentWidth / 4;
    
    
    // 第一行开关
    [self addSwitchWithTitle:@"显示人数" key:@"AAshexian" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"人物射线" key:@"AAguge" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"人物血条" key:@"AArenshu" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"人物骨骼" key:@"AAxueliang" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    // 增加行间距
    self.currentYOffset += 40;
    
    // 第二行开关
    [self addSwitchWithTitle:@"人物信息" key:@"AAjuli" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"距离显示" key:@"AAmingzi" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"背敌显示" key:@"AAbeidi" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"手持开关" key:@"AAzhibo" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    // 增加行间距
    self.currentYOffset += 40;
    
    // 第三行开关
    [self addSwitchWithTitle:@"隐藏人机" key:@"AAduibiao" yOffset:&_currentYOffset column:0 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"手雷预警" key:@"AAshouleiyujing" yOffset:&_currentYOffset column:1 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"显示帧率" key:@"AAxianshizhenlv" yOffset:&_currentYOffset column:2 columnWidth:columnWidth];
    [self addSwitchWithTitle:@"直播模式" key:@"AAzhibomoshi" yOffset:&_currentYOffset column:3 columnWidth:columnWidth];
    // 增加行间距
    self.currentYOffset += 40;
    
    
    // === 添加一条分割线 ===
    CGFloat separatorX = self.contentStartXOffset;
    UIView *separator1 = [[UIView alloc] initWithFrame:CGRectMake(separatorX, _currentYOffset, self.menuContainer.bounds.size.width - separatorX - 10, 0.8)];
    separator1.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.45f alpha:0.6f];
    [self.menuContainer addSubview:separator1];
    // === 添加一条分割线 ===
    self.currentYOffset += 5;
    
    //单个滑动条为一排
    [self addCustomSliderWithTitle:@"绘制距离" key:@"AAdrawDistance" yOffset:&_currentYOffset minValue:1 maxValue:500 defaultValue:300];
    self.currentYOffset += 50;
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
    separator1.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.45f alpha:0.6f];
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
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.font = [加载自定义字体 customFontWithSize:统一字体大小];
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
        fpsValueLabel.textColor = [UIColor whiteColor];
        fpsValueLabel.font = [加载自定义字体 customFontWithSize:统一字体大小];
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
    CGFloat switchSize = 32;
    CGFloat rowHeight = 34;
    
    // 创建容器视图（包含标签和开关）
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(xPosition, *yOffset, columnWidth, rowHeight)];
    
    CustomSwitchView *customSwitch = [[CustomSwitchView alloc] initWithFrame:CGRectMake(0, (rowHeight - switchSize) / 2.0, switchSize, switchSize)];
    
    UIFont *font = [加载自定义字体 customFontWithSize:统一字体大小];
    CGFloat labelX = switchSize + 8;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, columnWidth - labelX, rowHeight)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    label.font = font;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.7;
    label.lineBreakMode = NSLineBreakByClipping;
    
    
    BOOL initialValue = NO;
    if ([key isEqualToString:@"AAshexian"]) {
        initialValue = 显示人数;
    } else if ([key isEqualToString:@"AAguge"]) {
        initialValue = 人物射线;
    } else if ([key isEqualToString:@"AArenshu"]) {
        initialValue = 人物血条;
    } else if ([key isEqualToString:@"AAxueliang"]) {
        initialValue = 人物骨骼;
    } else if ([key isEqualToString:@"AAjuli"]) {
        initialValue = 人物信息;
    } else if ([key isEqualToString:@"AAmingzi"]) {
        initialValue = 距离显示;
    } else if ([key isEqualToString:@"AAbeidi"]) {
        initialValue = 背敌显示;
    } else if ([key isEqualToString:@"AAzhibo"]) {
        initialValue = 手持开关;
    } else if ([key isEqualToString:@"AAduibiao"]) {
        initialValue = 隐藏人机;
    } else if ([key isEqualToString:@"AAshouleiyujing"]) {
        initialValue = 手雷预警;
    } else if ([key isEqualToString:@"AAxianshizhenlv"]) {
        initialValue = 显示帧率;
    } else if ([key isEqualToString:@"AAzhibomoshi"]) {
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
        initialValue = 盒内物资;
    } else if ([key isEqualToString:@"AAwzxsyp"]) {
        initialValue = 显示药品;
    } else if ([key isEqualToString:@"AAwzxshz"]) {
        initialValue = 显示盒子;
    }else if ([key isEqualToString:@"AAwzbbwz"]) {
        initialValue = 版本物资;
    } else if ([key isEqualToString:@"AAwzdtwz"]) {
        initialValue = 地铁物资;
    } else if ([key isEqualToString:@"AAwzdthz"]) {
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
    
    // 右侧标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(container.bounds.size.width - rightLabelWidth, 0, rightLabelWidth, 34)];
    label.text = title;
    label.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    label.font = [加载自定义字体 customFontWithSize:统一字体大小];
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
    valueLabel.textColor = 勾选和滑块统一颜色;
    valueLabel.font = [加载自定义字体 customFontWithSize:16];
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
    
    __weak typeof(self) weakSelf = self;
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
    
    
    
    
    // 根据key设置对应的全局变量
    if ([key isEqualToString:@"AAshexian"]) {
        显示人数 = sender.isOn;
    } else if ([key isEqualToString:@"AAguge"]) {
        人物射线 = sender.isOn;
    } else if ([key isEqualToString:@"AArenshu"]) {
        人物血条 = sender.isOn;
    } else if ([key isEqualToString:@"AAxueliang"]) {
        人物骨骼 = sender.isOn;
    } else if ([key isEqualToString:@"AAjuli"]) {
        人物信息 = sender.isOn;
    } else if ([key isEqualToString:@"AAmingzi"]) {
        距离显示 = sender.isOn;
    } else if ([key isEqualToString:@"AAbeidi"]) {
        背敌显示 = sender.isOn;
    } else if ([key isEqualToString:@"AAzhibo"]) {
        手持开关 = sender.isOn;
    } else if ([key isEqualToString:@"AAduibiao"]) {
        隐藏人机 = sender.isOn;
    } else if ([key isEqualToString:@"AAshouleiyujing"]) {
        手雷预警 = sender.isOn;
    } else if ([key isEqualToString:@"AAxianshizhenlv"]) {
        显示帧率 = sender.isOn;
    } else if ([key isEqualToString:@"AAzhibomoshi"]) {
        直播模式 = sender.isOn;
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
    } else if ([key isEqualToString:@"AAwzxhq"]) {
        信号枪 = sender.isOn;
    }else if ([key isEqualToString:@"AAwzjjhjq"]) {
        紧急呼救器 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzhnwz"]) {
        盒内物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzxsyp"]) {
        显示药品 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzxshz"]) {
        显示盒子 = sender.isOn;
    }else if ([key isEqualToString:@"AAwzbbwz"]) {
        版本物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzdtwz"]) {
        地铁物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAwzdthz"]) {
        地铁盒子 = sender.isOn;
    } else if ([key isEqualToString:@"AAtswzlei"]) {//调试
        调试物资 = sender.isOn;
    } else if ([key isEqualToString:@"AAtshnid"]) {//调试
        调试盒内 = sender.isOn;
    } else if ([key isEqualToString:@"AAtswzsc"]) {//调试
        调试手持 = sender.isOn;
    }
    
    
    
    // NSLog(@"%@ changed to %@", key, sender.isOn ? @"ON" : @"OFF");
}



// 自用oc悬浮菜单.mm - 修改 hitTest 方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 1. 首先检查是否点击了菜单容器或其子视图
    CGPoint menuContainerPoint = [self convertPoint:point toView:self.menuContainer];
    
    // 关键修改：检查点是否在菜单容器的实际内容区域内，而不是bounds
    // 遍历菜单容器的所有子视图，检查是否点击了任何控件
    for (UIView *subview in self.menuContainer.subviews) {
        CGPoint subviewPoint = [self.menuContainer convertPoint:menuContainerPoint toView:subview];
        if ([subview pointInside:subviewPoint withEvent:event]) {
            UIView *hitView = [subview hitTest:subviewPoint withEvent:event];
            if (hitView) {
                return hitView;
            }
        }
    }
    
    // 2. 如果点击了菜单容器空白区域，处理拖动
    if (CGRectContainsPoint(self.menuContainer.frame, point)) {
        return self;
    }
    
    // 3. 其他区域不处理触摸
    return nil;
}

// 简化触摸事件处理 - 只处理拖动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    // 只处理菜单容器的拖动
    if (CGRectContainsPoint(self.menuContainer.frame, touchLocation)) {
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
        
        CGRect newFrame = self.frame;
        newFrame.origin.x += dx;
        newFrame.origin.y += dy;
        self.frame = newFrame;
        
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
