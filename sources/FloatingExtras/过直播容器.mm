
//  过直播容器.m

#import "过直播容器.h"

@interface 过直播容器 () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation 过直播容器

- (instancetype)init {
    self = [super init];
    if (self) [self setupUI];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) [self setupUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) [self setupUI];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.bounds;
    self.clearView.frame = self.bounds;
}

- (void)setupUI {
    [self addSubview:self.textField];
    self.textField.subviews.firstObject.userInteractionEnabled = YES;
    [self.textField.subviews.firstObject addSubview:self.clearView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled) return nil;
    return [super hitTest:point withEvent:event];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return NO;
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    if (self.textField != view) [self.clearView addSubview:view];
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.secureTextEntry = NO; // MARK: 初始化时设置 YES=过直播 NO=非直播
        _textField.delegate = self;
    }
    
    return _textField;
}

- (UIView *)clearView {
    if (!_clearView) _clearView = [[UIView alloc] init];
    return _clearView;
}

//运行时控制过直播容器
- (void)enableLiveStreamProtection:(BOOL)enable {
    self.textField.secureTextEntry = enable; // MARK: 运行时设置 YES=过直播 NO=非直播
}

- (BOOL)isLiveStreamProtectionEnabled {
    return self.textField.secureTextEntry;
}

/*直接使用hook调用  在你的开关调用 [self enableLiveStreamProtection:YES];

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
                 [self makeToast:enable ? @"过直播保护已启用" : @"过直播保护已禁用"];
                 break;
             }
         }
         responder = responder.nextResponder;
     }
 }

 // 4. 辅助方法：在视图层次中查找过直播容器
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
 
 */

//运行时控制过直播容器



@end
