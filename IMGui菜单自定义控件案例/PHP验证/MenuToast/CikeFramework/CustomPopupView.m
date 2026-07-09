//
//  CustomPopupView.m
//  APP1
//
//  Created by Mr.Zho on 2023/8/25.
//
//.______          ___      ___   ___  __  .__   __. ____    ____
//|   _  \        /   \     \  \ /  / |  | |  \ |  | \   \  /   /
//|  |_)  |      /  ^  \     \  V  /  |  | |   \|  |  \   \/   /
//|      /      /  /_\  \     >   <   |  | |  . `  |   \_    _/
//|  |\  \----./  _____  \   /  .  \  |  | |  |\   |     |  |
//| _| `._____/__/     \__\ /__/ \__\ |__| |__| \__|     |__|
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ConfirmationBlock)(NSString *inputText);
typedef void (^CancellationBlock)(void);

@interface CustomPopupView : UIView

@property (nonatomic, copy) ConfirmationBlock confirmationBlock;
@property (nonatomic, copy) CancellationBlock cancellationBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@end

@implementation CustomPopupView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // 添加黑色遮罩
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height+300)];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.5;
        [self addSubview:maskView];
        
        // 添加提示弹窗
        CGFloat popupWidth = 300.0;
        CGFloat popupHeight = 220.0;
        CGFloat popupX = (self.bounds.size.width - popupWidth) / 2;
        CGFloat popupY = (self.bounds.size.height - popupHeight) / 2;
        UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(popupX, popupY, popupWidth, popupHeight)];
        popupView.backgroundColor = [UIColor whiteColor];
        popupView.layer.cornerRadius = 10.0;
        [self addSubview:popupView];
        
        // 添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, popupWidth - 40, 30)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        titleLabel.textColor = [UIColor blackColor];
        [popupView addSubview:titleLabel];

        // 添加信息
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 10, popupWidth - 40, 60)];
        messageLabel.text = message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont systemFontOfSize:14.0];
        messageLabel.textColor = [UIColor grayColor];
        [popupView addSubview:messageLabel];

        
        // 添加输入框
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(messageLabel.frame) + 10, popupWidth - 40, 30)];
        inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        [popupView addSubview:inputTextField];
        
        // 添加确定按钮
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.frame = CGRectMake(20, CGRectGetMaxY(inputTextField.frame) + 5, (popupWidth - 60) / 2, 40);
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [popupView addSubview:confirmButton];
        
        // 添加取消按钮
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.frame = CGRectMake(CGRectGetMaxX(confirmButton.frame) + 20, CGRectGetMaxY(inputTextField.frame) + 5, (popupWidth - 60) / 2, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [popupView addSubview:cancelButton];
    }
    return self;
}

- (void)confirmButtonTapped:(UIButton *)sender {
    // 获取输入框的文本
    UITextField *inputTextField = [self viewWithTag:100];
    NSString *inputText = inputTextField.text;
    
    // 根据不同场景进行事件处理
    if (self.confirmationBlock) {
        self.confirmationBlock(inputText);
    }
    // 隐藏弹窗
       [self hidePopup];
}

- (void)cancelButtonTapped:(UIButton *)sender {
    // 取消按钮点击事件处理
    if (self.cancellationBlock) {
        self.cancellationBlock();
    }
    // 隐藏弹窗
       [self hidePopup];
}

- (void)hidePopup {
    [self removeFromSuperview];
}
@end
