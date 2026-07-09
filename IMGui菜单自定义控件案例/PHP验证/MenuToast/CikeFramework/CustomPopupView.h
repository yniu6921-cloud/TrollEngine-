//
//  CustomPopupView.h
//  APP1
//
//  Created by Mr.Zho on 2023/8/25.
//

#import <UIKit/UIKit.h>

typedef void (^ConfirmationBlock)(NSString *inputText);
typedef void (^CancellationBlock)(void);

@interface CustomPopupView : UIView

@property (nonatomic, copy) ConfirmationBlock confirmationBlock;
@property (nonatomic, copy) CancellationBlock cancellationBlock;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

@end
