//
//  SHMenuView.m
//  SystemHelper
//
//  Created by 特特 on 2025/4/9.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import "SHMenuView.h"

@interface SHMenuView () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SHMenuView

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
    if (!self.userInteractionEnabled) {
        return nil;
    }
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
        _textField.secureTextEntry = YES;// YES = 过直播
        _textField.delegate = self;
        _textField.userInteractionEnabled = NO; // 关键：禁用交互
    }
    
    return _textField;
}

- (UIView *)clearView {
    if (!_clearView) _clearView = [[UIView alloc] init];
    return _clearView;
}

@end
