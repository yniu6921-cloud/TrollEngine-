//
//  biaoshifuView.h
//  SystemHelper
//
//  Created by 冷风 on 2025/8/12.
//  Copyright © 2025 SysAdmin. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHIDCtrl : UIViewController
/// 选中后是否自动返回上一个页面（默认 YES）
@property (nonatomic, assign) BOOL dismissOnSelect;
@end

NS_ASSUME_NONNULL_END
