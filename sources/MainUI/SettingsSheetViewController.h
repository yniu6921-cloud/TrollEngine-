#import <UIKit/UIKit.h>

@interface SettingsSheetViewController : UIViewController
- (instancetype)initWithKernels:(NSArray<NSString *> *)kernels
                        current:(NSString *)current
                       onSelect:(void(^)(NSString *choice))onSelect;
@end
