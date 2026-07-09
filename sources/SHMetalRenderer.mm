#import "SHMetalRenderer.h"
#include "imgui.h"
#include "imgui_internal.h"
#include "imgui_impl_metal.h"
#include "Font.h"

#define iPhone8P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface SHMetalRenderer () <MTKViewDelegate>
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation SHMetalRenderer {
    BOOL _showMenu;
}

+ (SHMetalRenderer *)sharedInstance {
    static SHMetalRenderer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithMetalKitView:(MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = MTLCreateSystemDefaultDevice();
        _commandQueue = [_device newCommandQueue];
        if (!self.device) {
           
            abort();
        }
       
        if (self) {
            self.mtkView = [[MTKView alloc] initWithFrame:self.bounds device:_device];
            self.mtkView.clearColor = MTLClearColorMake(1, 0, 1, 0.3);
            self.mtkView.backgroundColor = [UIColor clearColor];
            self.mtkView.clipsToBounds = YES;
            self.mtkView.delegate = self;
            [self.subviews.firstObject addSubview:self.mtkView];
            self.userInteractionEnabled = YES;
            
            IMGUI_CHECKVERSION();
            ImGui::CreateContext();
            ImGui::StyleColorsDark();
            ImGuiIO& io = ImGui::GetIO(); (void)io;
             io.Fonts->AddFontFromMemoryTTF((void *)OPPOSans_H, OPPOSans_H_size, 50.0f, nullptr, io.Fonts->GetGlyphRangesChineseFull());
            ImGui_ImplMetal_Init(_device);
        }
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mtkView.frame = self.bounds;
}

- (void)setMenuVisible:(BOOL)visible {
    _showMenu = visible;
    self.hidden = !visible;
}

- (void)drawInMTKView:(MTKView *)view {
    if (!_showMenu) return;
    NSLog(@"[8888]: MetalLoading...");
}


- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size { }
- (void)UpdateTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint TouchPos = [anyTouch locationInView:self];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(TouchPos.x, TouchPos.y);
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }

- (void)dealloc {
    ImGui_ImplMetal_Shutdown();
    ImGui::DestroyContext();
}

@end
