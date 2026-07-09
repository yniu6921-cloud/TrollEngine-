//
//  UIButton+actionBlock.m
//  PHP验证
//
//  Created by Raxiny on 2023/2/23.
//

#import <Foundation/Foundation.h>
#import "UIButton+actionBlock.h"

@implementation UIButton (actionBlock)

static char overviewKey;

- (void)addAcionBlock:(VoidBlock)action

{

    objc_setAssociatedObject(self, &overviewKey, action,OBJC_ASSOCIATION_COPY_NONATOMIC);

    [self addTarget:self action:@selector(callActionBlock:)forControlEvents:UIControlEventTouchUpInside];

}

- (void)callActionBlock:(id)sender {

    VoidBlock block = (VoidBlock)objc_getAssociatedObject(self, &overviewKey);

    if (block) {

        block();

    }

}
@end
