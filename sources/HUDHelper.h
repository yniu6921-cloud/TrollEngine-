//
//  HUDHelper.h
//  SystemHelper
//
//  Created by Lessica on 2024/1/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

OBJC_EXTERN BOOL IsHUDEnabled(void);
OBJC_EXTERN void SetHUDEnabled(BOOL isEnabled);
OBJC_EXTERN void fasongxuni(void);

// 文件日志输出（写入 app.log / 共享日志）
OBJC_EXTERN void LFSNSLog(NSString *format, ...);

// 调试日志总开关（控制 LFSNSLog 是否写入文件 / 共享日志）
OBJC_EXTERN void LFSetDebugLogEnabled(BOOL enabled);

// 读取 app.log 末尾一段内容，用于 UI 中展示（maxBytes 为最多读取字节数）
OBJC_EXTERN NSString *LFReadAppLogSnippet(NSUInteger maxBytes);
NS_ASSUME_NONNULL_END
