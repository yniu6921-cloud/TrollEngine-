//
//  SHRenderView.h
//  SystemHelper
//
//  Created by 特特 on 2025/4/15.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHRenderView : UITextField <UITextFieldDelegate>
#define Colour_红色 0xFF0000FF
#define Colour_绿色 0xFF00FF00
#define Colour_粉红 0xFFCBC0FF
#define Colour_蓝色 0xFFFF0000
#define Colour_浅蓝 0xFFFACE87
#define Colour_青色 0xFFFFFF00
#define Colour_碧绿 0xFFAAFF7F
#define Colour_草绿 0xFF00FC7C
#define Colour_橙黄 0xFF00A5FF
#define Colour_橙色 0xFF0066FF
#define Colour_桃红 0xFFB9DAFF
#define Colour_珊瑚红 0xFF507FFF
#define Colour_紫色 0xFFEE677A
#define Colour_石板灰 0xFF908070
#define Colour_白色 0xFFFFFFFF
#define Colour_黑色 0xFF000000
#define Colour_绿黄 0xFFADFF2F
#define Colour_纯黄 0xFF00FFFF
#define Colour_透明红色 0x800000FF
#define Colour_透明橙黄 0x8000A5FF
#define Colour_透明绿黄 0x80ADFF2F
#define Colour_透明绿色 0x8000FF00
#define Colour_透明石板灰 0x80908070
+ (SHRenderView *)sharedInstance;

static inline void LFLogError(NSString *format, ...);
static inline void LFLogDebug(NSString *format, ...);
static inline void LFLogInfo(NSString *format, ...);
static inline void LFLogWarn(NSString *format, ...);

@end
#ifdef __cplusplus
extern "C" {
#endif
typedef void (^HHHBBBSSSCallback)(NSString *resultText);
void intKFDExter();
void intKFDExterIOS14();
#ifdef __cplusplus
}
#endif


NS_ASSUME_NONNULL_END
