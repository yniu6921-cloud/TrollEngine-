//
//  ImGuiDrawView.m
//  ImGuiTest
//
//  Created by yiming on 2021/6/2.
//
//.______          ___      ___   ___  __  .__   __. ____    ____
//|   _  \        /   \     \  \ /  / |  | |  \ |  | \   \  /   /
//|  |_)  |      /  ^  \     \  V  /  |  | |   \|  |  \   \/   /
//|      /      /  /_\  \     >   <   |  | |  . `  |   \_    _/
//|  |\  \----./  _____  \   /  .  \  |  | |  |\   |     |  |
//| _| `._____/__/     \__\ /__/ \__\ |__| |__| \__|     |__|
#import "ImGuiDrawView.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "imgui.h"
#include "imgui_impl_metal.h"
#import "font.h"
//#import "jijia.h"
//#import "your_font.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) IBOutlet MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView

static bool MenDeal = true;
// 定义开关状态和开关的大小
static bool switchIsOn = false;
static float switchAnim = 0.0f; // 动画进度
static float sliderValue = 0.5f;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;

    ImGui::StyleColorsDark();
    
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    //
    ImFontConfig config;
    config.FontDataOwnedByAtlas = false;
    io.Fonts->AddFontFromMemoryTTF((void *)lanting_data,lanting_size , 40.0f, NULL,
   io.Fonts->GetGlyphRangesChineseFull());
    
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
}

#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate
static bool SetMenuColorStyle = false;
const char *optionItemName[] = {"Enemy Draw", "Auto Aim", "Function Trace", "Memory Ad", "Draw Debug"};
int optionItemCurrent = 0;
static int MenuSum = 0;
static float AimSlider = 1.00;
static  bool enableFeature = false; // 布尔变量用于存储多选框的状态

//自瞄部位文本
float aimbotIntensity;

const char *aimbotIntensityText[] = {"微","低", "中", "高", "超高", "强锁", "锁死","超强"};
//自瞄模式文本
const char *aimbotModeText[] = {"开镜启动", "开火启动", "开镜开火启动", "自动模式启动", "触摸位置启动"};
//自瞄部位文本
const char *aimbotPartsText[] = {"优先头部漏打", "优先胸口漏打", "自动模式(漏打)", "锁定头部", "锁定身体"};

const char *aimbotPartsText1[] = {"优先头部漏打", "优先胸口漏打", "自动模式(漏打)", "锁定头部", "锁定身体"};
static int AimBotInt = 0;
- (void)AutoAim{
    ImGui::Text("自瞄设置");
    
    ImGui::Checkbox("预判自瞄", &enableFeature);
    ImGui::SameLine();
    ImGui::Checkbox("显示自瞄范围", &enableFeature);
    ImGui::SliderFloat("自瞄强度", &AimSlider, 1.0f, 120.0f, "%.0f");
    ImGui::Checkbox("透烟瞄准", &enableFeature);
    ImGui::SameLine();
    ImGui::Checkbox("自动扳机", &enableFeature);
    ImGui::Combo("自瞄模式", &AimBotInt, aimbotModeText, IM_ARRAYSIZE(aimbotModeText));
    
    ImGui::Combo("自瞄位置", &AimBotInt, aimbotPartsText, IM_ARRAYSIZE(aimbotPartsText));
    
    ImGui::SliderFloat("自瞄范围", &AimSlider, 20.0f, ([UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].nativeScale) / 2, "%.0f");
    ImGui::SliderFloat("自瞄距离限制", &AimSlider, 0.0f, 450.0f, "%.0fM");
    
}




- (void)drawInMTKView:(MTKView*)view
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    

    if (MenDeal == true) {
        [self.view setUserInteractionEnabled:YES];
    } else if (MenDeal == false) {
        [self.view setUserInteractionEnabled:NO];
    }
    
    ImGuiStyle *style = &ImGui::GetStyle();
    style->WindowRounding = 13.0f;//窗口圆角

    ImVec4* colors = style->Colors;


    // 其他颜色设置可以根据需要添加


//    // 主题颜色 高级灰
//    colors[ImGuiCol_Text] = ImVec4(0.9f, 0.9f, 0.9f, 1.0f);           // 文本颜色
//    colors[ImGuiCol_TextDisabled] = ImVec4(0.5f, 0.5f, 0.5f, 1.0f);   // 禁用文本颜色
//    colors[ImGuiCol_WindowBg] = ImVec4(0.1f, 0.1f, 0.1f, 1.0f);       // 窗口背景颜色
//    colors[ImGuiCol_Border] = ImVec4(0.5f, 0.5f, 0.5f, 0.65f);        // 边框颜色
//    colors[ImGuiCol_BorderShadow] = ImVec4(0.0f, 0.0f, 0.0f, 0.0f);    // 边框阴影颜色
//    colors[ImGuiCol_FrameBg] = ImVec4(0.2f, 0.2f, 0.2f, 1.0f);        // 框架背景颜色
//    colors[ImGuiCol_FrameBgHovered] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);  // 框架悬停时的背景颜色
//    colors[ImGuiCol_FrameBgActive] = ImVec4(0.4f, 0.4f, 0.4f, 1.0f);   // 框架激活时的背景颜色
//    colors[ImGuiCol_TitleBg] = ImVec4(0.0f, 0.0f, 0.0f, 1.0f);        // 标题栏背景颜色
//    colors[ImGuiCol_TitleBgActive] = ImVec4(0.1f, 0.1f, 0.1f, 1.0f);  // 标题栏激活时的背景颜色
//    colors[ImGuiCol_TitleBgCollapsed] = ImVec4(0.0f, 0.0f, 0.0f, 0.75f); // 标题栏折叠时的背景颜色
//    colors[ImGuiCol_MenuBarBg] = ImVec4(0.2f, 0.2f, 0.2f, 1.0f);      // 菜单栏背景颜色
//    colors[ImGuiCol_ScrollbarBg] = ImVec4(0.1f, 0.1f, 0.1f, 1.0f);    // 滚动条背景颜色
//    colors[ImGuiCol_ScrollbarGrab] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);  // 滚动条抓取器颜色
//    colors[ImGuiCol_ScrollbarGrabHovered] = ImVec4(0.4f, 0.4f, 0.4f, 1.0f); // 滚动条抓取器悬停时的颜色
//    colors[ImGuiCol_ScrollbarGrabActive] = ImVec4(0.5f, 0.5f, 0.5f, 1.0f);  // 滚动条抓取器激活时的颜色
//    colors[ImGuiCol_CheckMark] = ImVec4(0.3f, 0.8f, 0.5f, 1.0f);      // 复选标记颜色
//    colors[ImGuiCol_SliderGrab] = ImVec4(0.3f, 0.8f, 0.5f, 1.0f);      // 滑块抓取器颜色
//    colors[ImGuiCol_SliderGrabActive] = ImVec4(0.4f, 0.9f, 0.6f, 1.0f);  // 滑块抓取器激活时的颜色
//    colors[ImGuiCol_Button] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);         // 按钮背景颜色
//    colors[ImGuiCol_ButtonHovered] = ImVec4(0.4f, 0.4f, 0.4f, 1.0f);   // 按钮悬停时的背景颜色
//    colors[ImGuiCol_ButtonActive] = ImVec4(0.5f, 0.5f, 0.5f, 1.0f);    // 按钮激活时的背景颜色
//
//    // 自定义颜色
//    colors[ImGuiCol_Header] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);         // 标题颜色
//    colors[ImGuiCol_HeaderHovered] = ImVec4(0.4f, 0.4f, 0.4f, 1.0f);   // 标题悬停时的颜色
//    colors[ImGuiCol_HeaderActive] = ImVec4(0.5f, 0.5f, 0.5f, 1.0f);    // 标题激活时的颜色
//    colors[ImGuiCol_PlotLines] = ImVec4(0.3f, 0.8f, 0.5f, 1.0f);       // 绘图线条颜色
//    colors[ImGuiCol_PlotLinesHovered] = ImVec4(0.4f, 0.9f, 0.6f, 1.0f); // 绘图线条悬停时的颜色
//    colors[ImGuiCol_PlotHistogram] = ImVec4(0.3f, 0.8f, 0.5f, 1.0f);   // 绘图直方图颜色
//    colors[ImGuiCol_PlotHistogramHovered] = ImVec4(0.4f, 0.9f, 0.6f, 1.0f); // 绘图直方图悬停时的颜色
//    colors[ImGuiCol_TextSelectedBg] = ImVec4(0.3f, 0.3f, 0.3f, 0.5f);  // 选定文本背景颜色
//
//    // 为关联词添加醒目和明显的颜色
//    colors[ImGuiCol_TitleBg] = ImVec4(0.2f, 0.2f, 0.2f, 1.0f);        // 标题栏背景颜色
//    colors[ImGuiCol_TitleBgActive] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);  // 标题栏激活时的背景颜色
//    colors[ImGuiCol_Header] = ImVec4(0.3f, 0.3f, 0.3f, 1.0f);         // 标题颜色
//    colors[ImGuiCol_HeaderHovered] = ImVec4(0.4f, 0.4f, 0.4f, 1.0f);   // 标题悬停时的颜色
//    colors[ImGuiCol_HeaderActive] = ImVec4(0.5f, 0.5f, 0.5f, 1.0f);    // 标题激活时的颜色
//
//    // 添加一些高级黑客风格的颜色
//    colors[ImGuiCol_FrameBg] = ImVec4(0.0f, 0.0f, 0.0f, 1.0f);        // 框架背景颜色
//    colors[ImGuiCol_FrameBgHovered] = ImVec4(0.1f, 0.1f, 0.1f, 1.0f);  // 框架悬停时的背景颜色
//    colors[ImGuiCol_FrameBgActive] = ImVec4(0.2f, 0.2f, 0.2f, 1.0f);   // 框架激活时的背景颜色
//
//    // 高级黑客风格的按钮
//    colors[ImGuiCol_Button] = ImVec4(0.0f, 0.0f, 0.0f, 1.0f);         // 按钮背景颜色
//    colors[ImGuiCol_ButtonHovered] = ImVec4(0.1f, 0.1f, 0.1f, 1.0f);   // 按钮悬停时的背景颜色
//    colors[ImGuiCol_ButtonActive] = ImVec4(0.2f, 0.2f, 0.2f, 1.0f);    // 按钮激活时的背景颜色
    // 设置不选中状态的颜色
    style->Colors[ImGuiCol_WindowBg] = ImVec4(0.0f, 0.0f, 0.0f, 0.85f); // 半透明黑色

    // 在某些地方设置选中状态的颜色
    style->Colors[ImGuiCol_TitleBgActive] = ImVec4(0.0f, 0.0f, 0.0f, 0.85f); // 较不透明的黑色
 
 

    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil)
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui "];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        
        ImFont* font = ImGui::GetFont();
        font->Scale = 16.f / font->FontSize;
        
        CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 600) / 2;
        CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 330) / 2;
        
       // ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
        ImGui::SetNextWindowSize({1580, 820}, ImGuiCond_FirstUseEver);
        
        if (MenDeal == true)
        {
            
            ImGui::Begin("TG@ObjcOder", &MenDeal, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize |  ImGuiWindowFlags_NoTitleBar);
           ImGui::Text("IMGUI Dream TEST:2023-10-10");
//
          ImGui::CustomSwitch("My Switch", &switchIsOn);
//
//
           ImGui::CustomSlider("My Slider", &sliderValue, 0.0f, 1.0f);
            
            //这俩个控件是我自己写的 代码在imgui.cpp 里面 模拟器运行直接看效果 自定义了俩个类似iOS的控件 一个是开关 一个是滑块
            
      

            ImGui::End();

        }
        
       
        

        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);

        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];

        [commandBuffer presentDrawable:view.currentDrawable];
    }

    [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
