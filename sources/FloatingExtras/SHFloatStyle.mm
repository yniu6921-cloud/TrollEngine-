//  SHFloatStyle.mm
//  ASCII wrapper implementation for 悬浮球样式

#import "悬浮球样式.h"

@implementation 悬浮球样式

+ (instancetype)sharedInstance {
    static 悬浮球样式 *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)createFloatingBallLayers:(UIImageView *)floatingBall {
    [floatingBall.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    floatingBall.backgroundColor = [UIColor clearColor];

    CGFloat radius = CGRectGetWidth(floatingBall.bounds) * 0.5;

    CALayer *softWhiteBase = [CALayer layer];
    softWhiteBase.frame = CGRectInset(floatingBall.bounds, 5.0, 5.0);
    softWhiteBase.cornerRadius = CGRectGetWidth(softWhiteBase.bounds) * 0.5;
    softWhiteBase.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.78].CGColor;
    [floatingBall.layer addSublayer:softWhiteBase];

    UIImage *iconImage = [UIImage imageNamed:@"新悬浮球图片"];
    if (!iconImage) {
        iconImage = [UIImage imageNamed:@"新悬浮球图片.JPG"];
    }
    if (!iconImage) {
        iconImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"新悬浮球图片" ofType:@"JPG"]];
    }
    if (!iconImage) {
        iconImage = [UIImage imageNamed:@"app111"];
    }

    CALayer *iconLayer = [CALayer layer];
    iconLayer.frame = CGRectInset(floatingBall.bounds, 4.0, 4.0);
    iconLayer.cornerRadius = CGRectGetWidth(iconLayer.bounds) * 0.5;
    iconLayer.masksToBounds = YES;
    iconLayer.contents = (__bridge id)iconImage.CGImage;
    iconLayer.contentsGravity = kCAGravityResizeAspectFill;
    [floatingBall.layer addSublayer:iconLayer];

    CAGradientLayer *marqueeRing = [CAGradientLayer layer];
    marqueeRing.frame = floatingBall.bounds;
    marqueeRing.colors = @[
        (id)[UIColor colorWithRed:0.18 green:0.86 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.39 green:0.40 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.97 green:0.35 blue:1.0 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:1.0 green:0.44 blue:0.44 alpha:1.0].CGColor,
        (id)[UIColor colorWithRed:0.18 green:0.86 blue:1.0 alpha:1.0].CGColor
    ];
    marqueeRing.locations = @[@0.0, @0.25, @0.5, @0.75, @1.0];
    marqueeRing.startPoint = CGPointMake(0.0, 0.5);
    marqueeRing.endPoint = CGPointMake(1.0, 0.5);

    CAShapeLayer *ringMask = [CAShapeLayer layer];
    ringMask.frame = marqueeRing.bounds;
    ringMask.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(marqueeRing.bounds, 1.2, 1.2)].CGPath;
    ringMask.fillColor = [UIColor clearColor].CGColor;
    ringMask.strokeColor = [UIColor whiteColor].CGColor;
    ringMask.lineWidth = 2.6;
    marqueeRing.mask = ringMask;
    [floatingBall.layer addSublayer:marqueeRing];

    CALayer *innerHighlight = [CALayer layer];
    innerHighlight.frame = CGRectInset(floatingBall.bounds, 2.2, 2.2);
    innerHighlight.cornerRadius = radius - 2.2;
    innerHighlight.borderWidth = 1.0;
    innerHighlight.borderColor = [UIColor colorWithWhite:1.0 alpha:0.55].CGColor;
    [floatingBall.layer addSublayer:innerHighlight];

    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    spin.fromValue = @(0.0);
    spin.toValue = @(M_PI * 2.0);
    spin.duration = 3.0;
    spin.repeatCount = HUGE_VALF;
    spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spin.removedOnCompletion = NO;
    [marqueeRing addAnimation:spin forKey:@"lf.ball.marquee.spin"];

    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"opacity"];
    pulse.fromValue = @(0.78);
    pulse.toValue = @(1.0);
    pulse.autoreverses = YES;
    pulse.duration = 0.9;
    pulse.repeatCount = HUGE_VALF;
    [marqueeRing addAnimation:pulse forKey:@"lf.ball.marquee.pulse"];
}

@end
