//
//  SHBlurView.m
//  SystemHelper
//
//  Created by Lessica on 2024/1/25.
//

#import "SHBlurView.h"

@implementation SHBlurView

+ (Class)layerClass {
    return [NSClassFromString(@"CABackdropLayer") class];
}

@end
