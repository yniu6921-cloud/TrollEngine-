#import "SHMenuCtrl.h"
//#import <objc/runtime.h>

@interface SHMenuCtrl ()

//@property (strong, nonatomic) UIButton *floatingButton;
//@property (assign, nonatomic) CGPoint touchOffset;
@end

@implementation SHMenuCtrl

+ (instancetype)sharedInstance {
    static SHMenuCtrl *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
//    overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.5];
//    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:overlayView];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, overlayView.bounds.size.width, 50)];
//    label.text = @"123";
//    label.textColor = [UIColor whiteColor];
//    label.font = [UIFont systemFontOfSize:24];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.center = overlayView.center;
//    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    [overlayView addSubview:label];
    
//    self.floatingButton.translatesAutoresizingMaskIntoConstraints = YES;
//
//    // Initialize orientation observer
//    self.orientationObserver = [[objc_getClass("FBSOrientationObserver") alloc] init];
//    __weak typeof(self) weakSelf = self;
//    [self.orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf handleInterfaceOrientationChange:(UIInterfaceOrientation)orientationUpdate.orientation duration:orientationUpdate.duration];
//        });
//    }];
//
//    // Create floating button
//    self.floatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.floatingButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 200, 60, 60);
//    self.floatingButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
//    self.floatingButton.layer.cornerRadius = 30;
//    self.floatingButton.layer.masksToBounds = YES;
//
//    // Create floating button
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:ImageTX options:NSDataBase64DecodingIgnoreUnknownCharacters];
//        UIImage *decodedImage = [UIImage imageWithData:imageData];
//        CGSize targetSize = CGSizeMake(60, 60);
//        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
//        CGRect imageRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
//        [decodedImage drawInRect:imageRect];
//        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.floatingButton setImage:scaledImage forState:UIControlStateNormal];
//            self.floatingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            self.floatingButton.imageView.layer.cornerRadius = 30;
//            self.floatingButton.imageView.layer.masksToBounds = YES;
//        });
//    });
//
//    // Add tap gesture
//    [self.floatingButton addTarget:self action:@selector(floatingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//
//    // Add pan gesture
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [self.floatingButton addGestureRecognizer:pan];
//
//    [self.view addSubview:self.floatingButton];
}

//- (void)floatingButtonTapped {
//    NSLog(@"悬浮球被点击");
//}
//
//- (void)dealloc {
//#if !NO_TROLL
//    [_orientationObserver invalidate];
//#endif
//}
//
//- (void)handleInterfaceOrientationChange:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
//    CGFloat halfWidth = CGRectGetWidth(self.floatingButton.frame) / 2;
//    CGFloat halfHeight = CGRectGetHeight(self.floatingButton.frame) / 2;
//
//    CGPoint newCenter = self.floatingButton.center;
//    newCenter.x = MAX(halfWidth, MIN(newCenter.x, self.view.bounds.size.width - halfWidth));
//    newCenter.y = MAX(halfHeight, MIN(newCenter.y, self.view.bounds.size.height - halfHeight));
//
//    [UIView animateWithDuration:duration animations:^{
//        self.floatingButton.center = newCenter;
//    }];
//}
//
//// 拖动
//- (void)handlePan:(UIPanGestureRecognizer *)pan {
//    UIView *button = pan.view;
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        // 触摸点与按钮中心的偏移量
//        self.touchOffset = CGPointMake(CGRectGetMidX(button.frame) - [pan locationInView:self.view].x,
//                                      CGRectGetMidY(button.frame) - [pan locationInView:self.view].y);
//    } else if (pan.state == UIGestureRecognizerStateChanged) {
//        // 计算新的中心位置
//        CGPoint newCenter = CGPointMake([pan locationInView:self.view].x + self.touchOffset.x,
//                                       [pan locationInView:self.view].y + self.touchOffset.y);
//        CGFloat halfWidth = CGRectGetWidth(button.frame) / 2;
//        CGFloat halfHeight = CGRectGetHeight(button.frame) / 2;
//        newCenter.x = MAX(halfWidth, MIN(newCenter.x, self.view.bounds.size.width - halfWidth));
//        newCenter.y = MAX(halfHeight, MIN(newCenter.y, self.view.bounds.size.height - halfHeight));
//        button.center = newCenter;
//    }
//}
//
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    [self handleInterfaceOrientationChange:[UIApplication sharedApplication].statusBarOrientation duration:0.3];
//}
//
//

@end
