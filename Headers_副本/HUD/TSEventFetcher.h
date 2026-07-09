//
//  TSEventFetcher.h
//  Dopamine
//
//  Created by 特特 on 2025/7/7.
//  Copyright © 2025 Laote. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TSEventFetcher : NSObject

+ (NSInteger)receiveAXEventID:(NSInteger)pointId atGlobalCoordinate:(CGPoint)point withTouchPhase:(UITouchPhase)phase inWindow:(UIWindow *)window onView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
