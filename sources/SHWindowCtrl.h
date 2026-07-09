//
//  SHWindowCtrl.h
//  SystemHelper
//
//  Created by Auto on 2025/1/27.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// ImGui悬浮窗管理器
/// 负责管理SHRenderView在SHMainWnd中的显示和隐藏
@interface SHWindowCtrl : NSObject

/// 单例
+ (instancetype)sharedManager;

/// 显示ImGui悬浮窗
/// @return 是否成功显示
- (BOOL)showFloatingWindow;

/// 隐藏ImGui悬浮窗
/// @return 是否成功隐藏
- (BOOL)hideFloatingWindow;

/// 切换显示状态
/// @return 切换后的状态（YES=显示，NO=隐藏）
- (BOOL)toggleFloatingWindow;

/// 当前是否显示
- (BOOL)isFloatingWindowVisible;

@end

NS_ASSUME_NONNULL_END
