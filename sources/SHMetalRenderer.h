#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMetalRenderer : UIView

+ (SHMetalRenderer *)sharedInstance;
- (void)setMenuVisible:(BOOL)visible;

@end

NS_ASSUME_NONNULL_END
