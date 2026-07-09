//
//  SHEntryCtrl.h
//  SystemHelper
//
//  Created by 特特 on 2025/7/7.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHGameType) {
    SHGameTypePUBG = 0,   // 和平精英
    SHGameTypeSMoba = 1,  // 王者荣耀
};

OBJC_EXTERN void SHSetSelectedGameType(SHGameType type);
OBJC_EXTERN SHGameType SHGetSelectedGameType(void);
OBJC_EXTERN NSString * SHGameTypeDisplayName(SHGameType type);

@interface SHEntryCtrl : UIViewController
+ (void)setShouldToggleHUDAfterLaunch:(BOOL)flag;
- (void)reloadMainButtonState;


@end

NS_ASSUME_NONNULL_END
FOUNDATION_EXPORT void LFExpireWriteText(NSString *expText);
FOUNDATION_EXPORT NSString *LFExpireReadText(void);
