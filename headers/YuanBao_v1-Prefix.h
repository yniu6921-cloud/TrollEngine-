// Stub prefix header for floating ball module
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 简化版配置：给主悬浮球控制器用的标识和通知名
// 这里只是为了能正常编译运行，不追求和原项目完全一致。

// 目标应用的 bundle id（用于卸载检测），这里直接用当前应用的
#ifndef appIdentifier
#define appIdentifier @"com.apple.systemhelper"
#endif

// Darwin 通知名称（字符串常量，供 CFSTR 使用）
#ifndef NOTIFY_UI_LOCKSTATE
#define NOTIFY_UI_LOCKSTATE "com.apple.springboard.lockstate"
#endif

#ifndef NOTIFY_LS_APP_CHANGED
#define NOTIFY_LS_APP_CHANGED "com.apple.LaunchServices.ApplicationsChanged"
#endif

#ifndef NOTIFY_RELOAD_HUD
#define NOTIFY_RELOAD_HUD "com.niuyue.hud.reload"
#endif

#ifndef NOTIFY_LAUNCHED_HUD
#define NOTIFY_LAUNCHED_HUD "com.niuyue.hud.launched"
#endif


