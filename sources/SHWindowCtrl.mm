//
//  SHWindowCtrl.mm
//  SystemHelper
//
//  Created by Auto on 2025/1/27.
//  Copyright © 2025 SysAdmin. All rights reserved.
//

#import "SHWindowCtrl.h"
#import "SHRenderView.h"
#import "SHMainWnd.h"
#import "SHRootCtrl.h"
#import "HUDHelper.h"

// 日志宏定义
#define LOG_PREFIX @"[SHWindowCtrl]"
#define LOG_INFO(fmt, ...) LFSNSLog(@"%@ " fmt, LOG_PREFIX, ##__VA_ARGS__)
#define LOG_ERROR(fmt, ...) LFSNSLog(@"%@ [ERROR] " fmt, LOG_PREFIX, ##__VA_ARGS__)
#define LOG_DEBUG(fmt, ...) LFSNSLog(@"%@ [DEBUG] " fmt, LOG_PREFIX, ##__VA_ARGS__)

@interface SHWindowCtrl ()
@property (nonatomic, strong, nullable) SHRenderView *imGuiView;
@property (nonatomic, weak, nullable) SHMainWnd *hudWindow;
@property (nonatomic, assign) BOOL isVisible;
@end

@implementation SHWindowCtrl

+ (instancetype)sharedManager {
    static SHWindowCtrl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SHWindowCtrl alloc] init];
        LOG_INFO(@"单例管理器已创建");
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isVisible = NO;
        _imGuiView = nil;
        _hudWindow = nil;
        LOG_INFO(@"管理器初始化完成");
    }
    return self;
}

#pragma mark - 查找SHMainWnd

- (SHMainWnd * _Nullable)findSHMainWnd {
    LOG_DEBUG(@"开始查找SHMainWnd...");
    
    // 方法1: 遍历所有窗口查找SHMainWnd
    NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
    LOG_DEBUG(@"当前窗口数量: %lu", (unsigned long)windows.count);
    
    for (UIWindow *window in windows) {
        LOG_DEBUG(@"检查窗口: %@, 类型: %@, 层级: %.2f, 隐藏: %d", 
                  window, NSStringFromClass([window class]), window.windowLevel, window.isHidden);
        
        if ([window isKindOfClass:[SHMainWnd class]]) {
            SHMainWnd *hudWindow = (SHMainWnd *)window;
            LOG_INFO(@"找到SHMainWnd: %@, 层级: %.2f, 根视图控制器: %@", 
                     hudWindow, hudWindow.windowLevel, hudWindow.rootViewController);
            return hudWindow;
        }
    }
    
    // 方法2: 尝试通过类名动态查找
    Class SHMainWndClass = NSClassFromString(@"SHMainWnd");
    if (SHMainWndClass) {
        LOG_DEBUG(@"通过类名找到SHMainWnd类: %@", SHMainWndClass);
        for (UIWindow *window in windows) {
            if ([window isKindOfClass:SHMainWndClass]) {
                SHMainWnd *hudWindow = (SHMainWnd *)window;
                LOG_INFO(@"通过类名找到SHMainWnd: %@", hudWindow);
                return hudWindow;
            }
        }
    } else {
        LOG_ERROR(@"无法找到SHMainWnd类");
    }
    
    // 方法3: 尝试创建新的SHMainWnd（如果找不到）
    LOG_DEBUG(@"未找到现有SHMainWnd，尝试创建新窗口...");
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    SHMainWnd *newWindow = [[SHMainWnd alloc] initWithFrame:screenBounds];
    if (newWindow) {
        LOG_INFO(@"成功创建新的SHMainWnd: %@, 层级: %.2f", newWindow, newWindow.windowLevel);
        
        // 设置根视图控制器
        SHRootCtrl *rootVC = [[SHRootCtrl alloc] init];
        newWindow.rootViewController = rootVC;
        LOG_DEBUG(@"已设置根视图控制器: %@", rootVC);
        
        // 确保窗口可见
        [newWindow makeKeyAndVisible];
        LOG_DEBUG(@"已调用makeKeyAndVisible");
        
        return newWindow;
    } else {
        LOG_ERROR(@"创建SHMainWnd失败");
    }
    
    LOG_ERROR(@"所有方法都失败，无法获取SHMainWnd");
    return nil;
}

#pragma mark - 显示/隐藏

- (BOOL)showFloatingWindow {
    LOG_INFO(@"========== 开始显示ImGui悬浮窗 ==========");
    
    // 检查是否已经显示
    if (self.isVisible && self.imGuiView && self.imGuiView.superview) {
        LOG_DEBUG(@"ImGui悬浮窗已经显示，跳过");
        return YES;
    }
    
    // 1. 获取或创建SHRenderView实例
    if (!self.imGuiView) {
        LOG_DEBUG(@"创建SHRenderView实例...");
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self.imGuiView = [[SHRenderView alloc] initWithFrame:screenBounds];
        if (!self.imGuiView) {
            LOG_ERROR(@"创建SHRenderView实例失败");
            return NO;
        }
        LOG_INFO(@"成功创建SHRenderView实例: %@, frame: %@", self.imGuiView, NSStringFromCGRect(self.imGuiView.frame));
    } else {
        LOG_DEBUG(@"使用现有SHRenderView实例: %@", self.imGuiView);
    }
    
    // 2. 查找SHMainWnd
    SHMainWnd *hudWindow = [self findSHMainWnd];
    if (!hudWindow) {
        LOG_ERROR(@"无法获取SHMainWnd，显示失败");
        return NO;
    }
    self.hudWindow = hudWindow;
    LOG_INFO(@"成功获取SHMainWnd: %@", hudWindow);
    
    // 3. 检查根视图控制器
    UIViewController *rootVC = hudWindow.rootViewController;
    if (!rootVC) {
        LOG_ERROR(@"SHMainWnd没有根视图控制器");
        return NO;
    }
    LOG_DEBUG(@"根视图控制器: %@, 视图: %@", rootVC, rootVC.view);
    
    // 4. 确保根视图可交互（关键！）
    rootVC.view.userInteractionEnabled = YES;
    LOG_DEBUG(@"设置根视图控制器userInteractionEnabled=YES (之前: %@)", rootVC.view.userInteractionEnabled ? @"YES" : @"NO");
    
    // 5. 检查ImGuiView是否已经在视图层次中
    if (self.imGuiView.superview) {
        LOG_DEBUG(@"ImGuiView已经在视图层次中，父视图: %@", self.imGuiView.superview);
        if (self.imGuiView.superview == rootVC.view) {
            LOG_DEBUG(@"ImGuiView已经在正确的父视图中");
        } else {
            LOG_DEBUG(@"从旧的父视图移除: %@", self.imGuiView.superview);
            [self.imGuiView removeFromSuperview];
        }
    }
    
    // 6. 设置ImGuiView的frame（使用SHMainWnd的bounds，确保尺寸匹配）
    CGRect windowBounds = hudWindow.bounds;
    self.imGuiView.frame = windowBounds;
    LOG_DEBUG(@"设置ImGuiView frame: %@ (使用SHMainWnd bounds)", NSStringFromCGRect(windowBounds));
    
    // 7. 确保ImGuiView可见且可交互
    self.imGuiView.hidden = NO;
    self.imGuiView.userInteractionEnabled = YES;
    // 注意：使用半透明背景而不是完全透明，有助于调试
    self.imGuiView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01]; // 几乎透明但可见
    self.imGuiView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imGuiView.alpha = 1.0; // 确保alpha为1.0
    self.imGuiView.opaque = NO; // 允许透明
    LOG_DEBUG(@"设置ImGuiView属性: hidden=NO, userInteractionEnabled=YES, alpha=1.0, autoresizingMask=FlexibleWidth|FlexibleHeight");
    
    // 8. 检查superview是否有transform，如果有则添加反向transform抵消
    CGAffineTransform superTransform = rootVC.view.transform;
    if (!CGAffineTransformIsIdentity(superTransform)) {
        LOG_DEBUG(@"检测到superview有transform: %@", NSStringFromCGAffineTransform(superTransform));
        // 添加反向transform来抵消旋转
        CGAffineTransform inverseTransform = CGAffineTransformInvert(superTransform);
        self.imGuiView.transform = inverseTransform;
        LOG_DEBUG(@"已为ImGuiView添加反向transform: %@", NSStringFromCGAffineTransform(inverseTransform));
        
        // 调整frame以适应旋转后的坐标系
        CGRect transformedBounds = CGRectApplyAffineTransform(windowBounds, superTransform);
        self.imGuiView.frame = transformedBounds;
        LOG_DEBUG(@"调整ImGuiView frame以适应transform: %@", NSStringFromCGRect(transformedBounds));
    } else {
        // 没有transform，正常设置
        self.imGuiView.frame = windowBounds;
    }
    
    // 9. 添加到SHMainWnd的根视图
    [rootVC.view addSubview:self.imGuiView];
    LOG_INFO(@"已将ImGuiView添加到根视图控制器: %@", rootVC);
    
    // 10. 确保SHRenderView的bounds正确（关键！）
    self.imGuiView.bounds = windowBounds;
    LOG_DEBUG(@"设置ImGuiView bounds: %@", NSStringFromCGRect(windowBounds));
    
    // 10. 强制布局更新（这会触发SHRenderView的layoutSubviews，更新MTKView的frame）
    [rootVC.view setNeedsLayout];
    [rootVC.view layoutIfNeeded];
    [self.imGuiView setNeedsLayout];
    [self.imGuiView layoutIfNeeded];
    LOG_DEBUG(@"已强制布局更新");
    
    // 12. 确保SHRenderView的MTKView正确显示（关键！）
    // 延迟一点确保视图层次完全建立后再检查
    dispatch_async(dispatch_get_main_queue(), ^{
        LOG_DEBUG(@"========== 检查SHRenderView内部状态 ==========");
        // 检查SHRenderView是否有MTKView
        if ([self.imGuiView respondsToSelector:@selector(mtkView)]) {
            id mtkView = [self.imGuiView performSelector:@selector(mtkView)];
            if (mtkView) {
                LOG_DEBUG(@"找到MTKView: %@", mtkView);
                if ([mtkView isKindOfClass:[UIView class]]) {
                    UIView *mtkViewObj = (UIView *)mtkView;
                    LOG_DEBUG(@"MTKView frame: %@, bounds: %@, hidden: %d, superview: %@, window: %@", 
                             NSStringFromCGRect(mtkViewObj.frame),
                             NSStringFromCGRect(mtkViewObj.bounds),
                             mtkViewObj.hidden,
                             mtkViewObj.superview,
                             mtkViewObj.window);
                    if (mtkViewObj.hidden) {
                        mtkViewObj.hidden = NO;
                        LOG_DEBUG(@"MTKView被隐藏，已设置为可见");
                    }
                    if (!mtkViewObj.superview) {
                        LOG_ERROR(@"MTKView没有父视图！");
                    }
                    // 确保MTKView的frame正确
                    if (!CGRectEqualToRect(mtkViewObj.frame, self.imGuiView.bounds)) {
                        mtkViewObj.frame = self.imGuiView.bounds;
                        LOG_DEBUG(@"修正MTKView frame: %@", NSStringFromCGRect(mtkViewObj.frame));
                    }
                    
                    // 检查MTKView的paused状态（关键！）
                    if ([mtkViewObj respondsToSelector:@selector(isPaused)]) {
                        BOOL isPaused = [mtkViewObj performSelector:@selector(isPaused)] ? YES : NO;
                        LOG_DEBUG(@"MTKView paused状态: %@", isPaused ? @"YES" : @"NO");
                        if (isPaused) {
                            if ([mtkViewObj respondsToSelector:@selector(setPaused:)]) {
                                [mtkViewObj performSelector:@selector(setPaused:) withObject:@NO];
                                LOG_INFO(@"MTKView被暂停，已恢复渲染");
                            }
                        }
                    }
                    
                    // 确保MTKView的enableSetNeedsDisplay为NO（使用自动渲染）
                    if ([mtkViewObj respondsToSelector:@selector(setEnableSetNeedsDisplay:)]) {
                        [mtkViewObj performSelector:@selector(setEnableSetNeedsDisplay:) withObject:@NO];
                        LOG_DEBUG(@"已设置MTKView enableSetNeedsDisplay=NO");
                    }
                    
                    // 确保MTKView的preferredFramesPerSecond设置正确
                    if ([mtkViewObj respondsToSelector:@selector(setPreferredFramesPerSecond:)]) {
                        [mtkViewObj performSelector:@selector(setPreferredFramesPerSecond:) withObject:@60];
                        LOG_DEBUG(@"已设置MTKView preferredFramesPerSecond=60");
                    }
                    
                    // 强制MTKView开始渲染
                    if ([mtkViewObj respondsToSelector:@selector(setNeedsDisplay)]) {
                        [mtkViewObj performSelector:@selector(setNeedsDisplay)];
                        LOG_DEBUG(@"已调用MTKView setNeedsDisplay");
                    }
                    
                    // 注意：drawableSize相关代码已移除，避免崩溃
                    // MTKView会自动管理drawableSize，不需要手动设置
                    
                    // 再次确保paused为NO（直接访问属性，不使用performSelector）
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 尝试直接访问paused属性
                        @try {
                            // 方法1：直接设置属性（如果MTKView支持KVC）
                            [mtkViewObj setValue:@NO forKey:@"paused"];
                            LOG_INFO(@"通过KVC设置MTKView paused=NO");
                            
                            // 方法2：使用performSelector（备用）
                            if ([mtkViewObj respondsToSelector:@selector(setPaused:)]) {
                                NSMethodSignature *sig = [mtkViewObj methodSignatureForSelector:@selector(setPaused:)];
                                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
                                [inv setTarget:mtkViewObj];
                                [inv setSelector:@selector(setPaused:)];
                                BOOL paused = NO;
                                [inv setArgument:&paused atIndex:2];
                                [inv invoke];
                                LOG_INFO(@"通过NSInvocation设置MTKView paused=NO");
                            }
                            
                            // 验证设置是否成功
                            BOOL isPaused = [[mtkViewObj valueForKey:@"paused"] boolValue];
                            if (isPaused) {
                                LOG_ERROR(@"警告：设置paused=NO后仍然为YES！尝试强制方法...");
                                // 强制方法：移除并重新添加MTKView
                                UIView *superview = mtkViewObj.superview;
                                if (superview) {
                                    CGRect frame = mtkViewObj.frame;
                                    [mtkViewObj removeFromSuperview];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        mtkViewObj.frame = frame;
                                        [superview addSubview:mtkViewObj];
                                        [mtkViewObj setValue:@NO forKey:@"paused"];
                                        LOG_INFO(@"已通过移除/重新添加强制恢复MTKView");
                                    });
                                }
                            } else {
                                LOG_INFO(@"确认：MTKView paused=NO设置成功");
                            }
                        } @catch (NSException *exception) {
                            LOG_ERROR(@"设置paused时出错: %@", exception);
                        }
                    });
                    
                    // 延迟一点再次检查，确保渲染循环启动
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if ([mtkViewObj respondsToSelector:@selector(isPaused)]) {
                            BOOL isPaused = [mtkViewObj performSelector:@selector(isPaused)] ? YES : NO;
                            LOG_INFO(@"延迟检查：MTKView paused状态: %@", isPaused ? @"YES" : @"NO");
                            if (isPaused) {
                                LOG_ERROR(@"MTKView仍然被暂停！强制恢复...");
                                if ([mtkViewObj respondsToSelector:@selector(setPaused:)]) {
                                    [mtkViewObj performSelector:@selector(setPaused:) withObject:@NO];
                                    LOG_INFO(@"已强制设置MTKView paused=NO");
                                }
                                
                                // 再次确认
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    BOOL stillPaused = [mtkViewObj performSelector:@selector(isPaused)] ? YES : NO;
                                    if (stillPaused) {
                                        LOG_ERROR(@"MTKView仍然被暂停！尝试其他方法...");
                                        // 尝试通过设置frame来触发渲染
                                        CGRect currentFrame = mtkViewObj.frame;
                                        mtkViewObj.frame = CGRectZero;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            mtkViewObj.frame = currentFrame;
                                            if ([mtkViewObj respondsToSelector:@selector(setPaused:)]) {
                                                [mtkViewObj performSelector:@selector(setPaused:) withObject:@NO];
                                            }
                                            LOG_INFO(@"已通过frame重置强制恢复MTKView");
                                        });
                                    } else {
                                        LOG_INFO(@"MTKView已成功恢复渲染");
                                    }
                                });
                            } else {
                                LOG_INFO(@"MTKView渲染正常");
                            }
                        }
                    });
                    
                    // 检查MTKView的delegate
                    if ([mtkViewObj respondsToSelector:@selector(delegate)]) {
                        id delegate = [mtkViewObj performSelector:@selector(delegate)];
                        LOG_DEBUG(@"MTKView delegate: %@", delegate);
                        if (!delegate) {
                            LOG_ERROR(@"MTKView没有delegate！这会导致无法渲染");
                        }
                    }
                }
            } else {
                LOG_ERROR(@"SHRenderView没有MTKView！");
            }
        } else {
            LOG_ERROR(@"SHRenderView没有mtkView方法！");
        }
        
        // 再次验证最终状态
        LOG_DEBUG(@"========== 最终验证 ==========");
        LOG_DEBUG(@"ImGuiView frame: %@, bounds: %@", 
                 NSStringFromCGRect(self.imGuiView.frame),
                 NSStringFromCGRect(self.imGuiView.bounds));
        LOG_DEBUG(@"ImGuiView hidden: %d, userInteractionEnabled: %d", 
                 self.imGuiView.hidden, 
                 self.imGuiView.userInteractionEnabled);
        LOG_DEBUG(@"ImGuiView superview: %@, window: %@",
                 self.imGuiView.superview,
                 self.imGuiView.window);
        LOG_DEBUG(@"SHMainWnd: %@, hidden: %d, keyWindow: %@",
                 self.hudWindow,
                 self.hudWindow.isHidden,
                 [self.hudWindow isKeyWindow] ? @"YES" : @"NO");
        
        // ========== 关键修复：处理superview的transform ==========
        LOG_INFO(@"========== 开始Transform检查 ==========");
        if (self.imGuiView.superview) {
            CGAffineTransform superTransform = self.imGuiView.superview.transform;
            CGAffineTransform viewTransform = self.imGuiView.transform;
            LOG_INFO(@"========== Transform检查 ==========");
            LOG_DEBUG(@"superview transform: %@", NSStringFromCGAffineTransform(superTransform));
            LOG_DEBUG(@"ImGuiView transform: %@", NSStringFromCGAffineTransform(viewTransform));
            LOG_DEBUG(@"superview frame: %@", NSStringFromCGRect(self.imGuiView.superview.frame));
            
            // 如果superview有transform，必须添加反向transform来抵消
            if (!CGAffineTransformIsIdentity(superTransform)) {
                LOG_DEBUG(@"检测到superview有transform，需要添加反向transform抵消");
                CGAffineTransform expectedInverse = CGAffineTransformInvert(superTransform);
                
                // 计算transform是否匹配（允许小的浮点误差）
                CGFloat a = viewTransform.a - expectedInverse.a;
                CGFloat b = viewTransform.b - expectedInverse.b;
                CGFloat c = viewTransform.c - expectedInverse.c;
                CGFloat d = viewTransform.d - expectedInverse.d;
                BOOL isEqual = (fabs(a) < 0.001 && fabs(b) < 0.001 && fabs(c) < 0.001 && fabs(d) < 0.001);
                
                if (!isEqual) {
                    LOG_INFO(@"修正ImGuiView transform以抵消superview的旋转");
                    // 关键：先设置transform，再设置frame
                    // transform会自动处理坐标转换，所以frame应该使用原始bounds
                    CGRect windowBounds = self.hudWindow.bounds;
                    
                    // 设置反向transform来抵消superview的旋转
                    self.imGuiView.transform = expectedInverse;
                    LOG_DEBUG(@"已设置ImGuiView transform: %@", NSStringFromCGAffineTransform(expectedInverse));
                    
                    // frame应该使用windowBounds（不应用transform），因为transform会自动处理坐标转换
                    self.imGuiView.frame = windowBounds;
                    LOG_DEBUG(@"已设置ImGuiView frame: %@ (使用原始windowBounds)", NSStringFromCGRect(windowBounds));
                    
                    // 确保bounds也正确
                    self.imGuiView.bounds = windowBounds;
                    LOG_DEBUG(@"已设置ImGuiView bounds: %@", NSStringFromCGRect(windowBounds));
                    
                    // 强制布局更新
                    [self.imGuiView setNeedsLayout];
                    [self.imGuiView layoutIfNeeded];
                    LOG_DEBUG(@"已强制布局更新");
                    
                    // 确保MTKView也更新
                    if ([self.imGuiView respondsToSelector:@selector(mtkView)]) {
                        id mtkView = [self.imGuiView performSelector:@selector(mtkView)];
                        if (mtkView && [mtkView isKindOfClass:[UIView class]]) {
                            UIView *mtkViewObj = (UIView *)mtkView;
                            mtkViewObj.frame = self.imGuiView.bounds;
                            [mtkViewObj setNeedsLayout];
                            [mtkViewObj layoutIfNeeded];
                            LOG_DEBUG(@"已更新MTKView frame: %@ 和布局", NSStringFromCGRect(mtkViewObj.frame));
                        }
                    }
                } else {
                    LOG_DEBUG(@"ImGuiView transform已正确设置");
                }
            } else {
                LOG_DEBUG(@"superview没有transform，ImGuiView应该也没有transform");
                if (!CGAffineTransformIsIdentity(viewTransform)) {
                    LOG_DEBUG(@"清除ImGuiView的transform");
                    self.imGuiView.transform = CGAffineTransformIdentity;
                }
            }
            LOG_INFO(@"========== Transform检查完成 ==========");
        } else {
            LOG_ERROR(@"ImGuiView没有superview，无法检查transform！");
        }
        
        LOG_INFO(@"========== 延迟检查完成 ==========");
    });
    
    // 8. 确保SHMainWnd可见
    if (hudWindow.isHidden) {
        LOG_DEBUG(@"SHMainWnd被隐藏，设置为可见");
        hudWindow.hidden = NO;
    }
    
    if (![hudWindow isKeyWindow]) {
        LOG_DEBUG(@"SHMainWnd不是关键窗口，调用makeKeyAndVisible");
        [hudWindow makeKeyAndVisible];
    }
    
    // 9. 更新状态
    self.isVisible = YES;
    
    // 10. 验证
    BOOL isInViewHierarchy = (self.imGuiView.superview != nil);
    BOOL isWindowVisible = !hudWindow.isHidden;
    BOOL isWindowKey = [hudWindow isKeyWindow];
    
    LOG_INFO(@"========== 显示完成 ==========");
    LOG_INFO(@"ImGuiView在视图层次中: %@", isInViewHierarchy ? @"是" : @"否");
    LOG_INFO(@"SHMainWnd可见: %@", isWindowVisible ? @"是" : @"否");
    LOG_INFO(@"SHMainWnd是关键窗口: %@", isWindowKey ? @"是" : @"否");
    LOG_INFO(@"SHMainWnd层级: %.2f", hudWindow.windowLevel);
    LOG_INFO(@"ImGuiView frame: %@", NSStringFromCGRect(self.imGuiView.frame));
    LOG_INFO(@"ImGuiView superview: %@", self.imGuiView.superview);
    
    if (isInViewHierarchy && isWindowVisible) {
        LOG_INFO(@"✓✓✓ ImGui悬浮窗显示成功！");
        return YES;
    } else {
        LOG_ERROR(@"✗✗✗ ImGui悬浮窗显示失败！");
        return NO;
    }
}

- (BOOL)hideFloatingWindow {
    LOG_INFO(@"========== 开始隐藏ImGui悬浮窗 ==========");
    
    if (!self.isVisible) {
        LOG_DEBUG(@"ImGui悬浮窗已经隐藏，跳过");
        return YES;
    }
    
    if (!self.imGuiView) {
        LOG_DEBUG(@"ImGuiView不存在，无需隐藏");
        self.isVisible = NO;
        return YES;
    }
    
    // 1. 从父视图移除
    if (self.imGuiView.superview) {
        LOG_DEBUG(@"从父视图移除ImGuiView: %@", self.imGuiView.superview);
        [self.imGuiView removeFromSuperview];
    } else {
        LOG_DEBUG(@"ImGuiView没有父视图，无需移除");
    }
    
    // 2. 隐藏视图
    self.imGuiView.hidden = YES;
    LOG_DEBUG(@"设置ImGuiView hidden=YES");
    
    // 3. 更新状态
    self.isVisible = NO;
    
    LOG_INFO(@"========== 隐藏完成 ==========");
    LOG_INFO(@"ImGuiView在视图层次中: %@", (self.imGuiView.superview != nil) ? @"是" : @"否");
    LOG_INFO(@"✓✓✓ ImGui悬浮窗隐藏成功！");
    
    return YES;
}

- (BOOL)toggleFloatingWindow {
    LOG_INFO(@"========== 切换ImGui悬浮窗状态 ==========");
    LOG_DEBUG(@"当前状态: %@", self.isVisible ? @"显示" : @"隐藏");
    
    BOOL newState = !self.isVisible;
    BOOL success = NO;
    
    if (newState) {
        success = [self showFloatingWindow];
    } else {
        success = [self hideFloatingWindow];
    }
    
    LOG_INFO(@"切换后状态: %@, 操作结果: %@", newState ? @"显示" : @"隐藏", success ? @"成功" : @"失败");
    
    return newState;
}

- (BOOL)isFloatingWindowVisible {
    BOOL visible = self.isVisible && 
                   self.imGuiView != nil && 
                   self.imGuiView.superview != nil && 
                   !self.imGuiView.hidden;
    
    LOG_DEBUG(@"检查可见性: isVisible=%d, imGuiView存在=%d, 有父视图=%d, 未隐藏=%d, 结果=%d",
              self.isVisible, 
              (self.imGuiView != nil),
              (self.imGuiView.superview != nil),
              !self.imGuiView.hidden,
              visible);
    
    return visible;
}

@end
