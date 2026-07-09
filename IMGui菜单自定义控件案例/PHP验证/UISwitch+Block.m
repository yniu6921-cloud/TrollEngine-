//
//  UIButton+actionBlock.m
//  PHP验证
//
//  Created by Raxiny on 2023/2/23.
//

#import "UISwitch+Block.h"
#import <objc/runtime.h>

@implementation UISwitch (Block)

- (void)setSwitchBlock:(SwitchChangeBlock)switchBlock {
    objc_setAssociatedObject(self, @selector(switchBlock), switchBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (SwitchChangeBlock)switchBlock {
    return objc_getAssociatedObject(self, @selector(switchBlock));
}

- (void)switchDidChange:(UISwitch *)sender {
    if (self.switchBlock) {
        self.switchBlock(sender.isOn);
    }
}

@end
