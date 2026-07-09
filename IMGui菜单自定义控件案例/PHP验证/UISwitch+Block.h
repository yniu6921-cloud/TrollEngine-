//
//  UIButton+actionBlock.h
//  PHP验证
//
//  Created by Raxiny on 2023/2/23.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

typedef void(^SwitchChangeBlock)(BOOL isOn);

@interface UISwitch (Block)

@property (nonatomic, copy) SwitchChangeBlock switchBlock;

@end
