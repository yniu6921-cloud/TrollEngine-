
#import <UIKit/UIKit.h>

@interface CustomTableView : UITableView


- (void)addSectionWithTitle:(NSString *)title andSubfunctions:(void (^)(void))subfunctions;


- (void)addButtonWithTitle:(NSString *)title andActionBlock:(void (^)(void))actionBlock;


- (void)addSwitchWithTitle:(NSString *)title andActionBlock:(void (^)(BOOL isOn))actionBlock;


@end
