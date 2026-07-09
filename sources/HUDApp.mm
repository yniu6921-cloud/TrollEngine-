//
//  HUDApp.mm
//  SystemHelper
//
//  Created by Lessica on 2024/1/24.
//

#import <notify.h>
#import <mach-o/dyld.h>
#import <sys/utsname.h>
#import <objc/runtime.h>
#import "IOKit+SPI.h"
#import <objc/message.h>
#if !NO_TROLL
#import "IOKit+SPI.h"
#import "HUDHelper.h"
#import "SHEventFetch.h"
#import "BackboardServices.h"
#import "AXEventRepresentation.h"
#import "UIApplication+Private.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <os/log.h>
#import "rootless.h"
#import "NSUserDefaults+Private.h"
#import <sys/stat.h>
#if DEBUG
    #define log_debug os_log_debug
    #define log_info os_log_info
    #define log_error os_log_error
#else
    #define log_debug(...)
    #define log_info(...)
    #define log_error(...)
#endif
// USER_DEFAULTS_PATH 已在 supports/hudapp-prefix.pch 中定义

// HUD -> APP: Notify APP that the HUD's view is appeared.
#define NOTIFY_LAUNCHED_HUD "com.SysAdmin.notification.hud.launched"

// APP -> HUD: Notify HUD to dismiss itself.
#define NOTIFY_DISMISSAL_HUD "com.SysAdmin.notification.hud.dismissal"

// APP -> HUD: Notify HUD that the user defaults has been changed by APP.
#define NOTIFY_RELOAD_HUD "com.SysAdmin.notification.hud.reload"

// HUD -> APP: Notify APP that the user defaults has been changed by HUD.
#define NOTIFY_RELOAD_APP "com.SysAdmin.notification.app.reload"
#define PID_PATH "/var/mobile/Library/Caches/com.apple.systemhelper.pid"

static __used
NSString *mDeviceModel(void) {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

static __used
void _HUDEventCallback(void *target, void *refcon, IOHIDServiceRef service, IOHIDEventRef event)
{
    static UIApplication *app = [UIApplication sharedApplication];
    log_debug(OS_LOG_DEFAULT, "_HUDEventCallback => %{public}@", event);
    
    // iOS 15.1+ has a new API for handling HID events.
    if (@available(iOS 15.1, *)) {}
    else {
        [app _enqueueHIDEvent:event];
    }

    BOOL shouldUseAXEvent = YES;  // Always use AX events now...

    BOOL isExactly15 = NO;
    static NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    if (version.majorVersion == 15 && version.minorVersion == 0 && version.patchVersion == 0) {
        NSString *deviceModel = mDeviceModel();
        if (![deviceModel hasPrefix:@"iPhone13,"] && ![deviceModel hasPrefix:@"iPhone14,"]) { // iPhone 12 & 13 Series
            isExactly15 = YES;
        }
    }

    if (@available(iOS 15.0, *)) {
        shouldUseAXEvent = !isExactly15;
    } else {
        shouldUseAXEvent = NO;
    }

    if (shouldUseAXEvent)
    {
        static Class AXEventRepresentationCls = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/AccessibilityUtilities.framework"] load];
            AXEventRepresentationCls = objc_getClass("AXEventRepresentation");
        });

        AXEventRepresentation *rep = [AXEventRepresentationCls representationWithHIDEvent:event hidStreamIdentifier:@"UIApplicationEvents"];
        log_debug(OS_LOG_DEFAULT, "_HUDEventCallback => %{public}@", rep.handInfo);

        /* I don't like this. It's too hacky, but it works. */
        {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                // 改进：每次拿当前最高层级且可见的窗口
                UIWindow *keyWindow = nil;
                for (UIWindow *w in app.windows) {
                    if (w.hidden) continue;
                    if (!keyWindow || w.windowLevel > keyWindow.windowLevel) {
                        keyWindow = w;
                    }
                }
                if (!keyWindow) {
                    keyWindow = app.keyWindow ?: app.windows.firstObject;
                }

                UIView *keyView = [keyWindow hitTest:[rep location] withEvent:nil];

                UITouchPhase phase = UITouchPhaseEnded;
                if ([rep isTouchDown])
                    phase = UITouchPhaseBegan;
                else if ([rep isMove])
                    phase = UITouchPhaseMoved;
                else if ([rep isCancel])
                    phase = UITouchPhaseCancelled;
                else if ([rep isLift] || [rep isInRange] || [rep isInRangeLift])
                    phase = UITouchPhaseEnded;

                NSInteger pointerId = [[[[rep handInfo] paths] firstObject] pathIdentity];
                if (pointerId > 0)
                    [SHEventFetch receiveAXEventID:MIN(MAX(pointerId, 1), 98) atGlobalCoordinate:[rep location] withTouchPhase:phase inWindow:keyWindow onView:keyView];
            });
        }
    }
}
#endif
static inline NSString *lf_base_dir_ns(void) {
    static NSString *dir;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // 改成全局共享目录
        dir = @"/var/mobile/Media/ATop";
        NSError *err = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                  withIntermediateDirectories:YES
                                                   attributes:@{ NSFilePosixPermissions:@0777 }
                                                        error:&err];
        if (err) {
          
        }
    });
    return dir;
}

static inline const char *lf_flag_dir_c(void) {
    return lf_base_dir_ns().fileSystemRepresentation;
}

static inline __attribute__((unused)) const char *lf_token_path_c(void) {
    static char path[1024];
    snprintf(path, sizeof(path), "%s/%s", lf_flag_dir_c(), "hud.token");
    return path;
}
int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        log_debug(OS_LOG_DEFAULT, "launched argc %{public}d, argv[1] %{public}s", argc, argc > 1 ? argv[1] : "NULL");
       
      
#if !NO_TROLL
        if (argc <= 1) {
            
            return UIApplicationMain(argc, argv, @"SHApplication", @"SHAppDelegate");
        }

        if (strcmp(argv[1], "-hud") == 0)
        {
            pid_t ppid = getppid();
              if (ppid <= 1 || (kill(ppid, 0) != 0 && errno == ESRCH)) {
                  exit(0);   // 启动时父已经没了，直接退
                  NSString *pidString = [NSString stringWithContentsOfFile:ROOT_PATH_NS(@PID_PATH)
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:nil];

                  if (pidString)
                  {
                      pid_t pid = (pid_t)[pidString intValue];
                      kill(pid, SIGKILL);
                      unlink([ROOT_PATH_NS(@PID_PATH) UTF8String]);
                  }
              }
              dispatch_source_t procSrc =
              dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, (uintptr_t)ppid,
                                     DISPATCH_PROC_EXIT, dispatch_get_main_queue());
              dispatch_source_set_event_handler(procSrc, ^{
                  exit(0);   // 父退出 → 子退出
                  NSString *pidString = [NSString stringWithContentsOfFile:ROOT_PATH_NS(@PID_PATH)
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:nil];

                  if (pidString)
                  {
                      pid_t pid = (pid_t)[pidString intValue];
                      kill(pid, SIGKILL);
                      unlink([ROOT_PATH_NS(@PID_PATH) UTF8String]);
                  }
              });
              dispatch_resume(procSrc);
            
          
            
            pid_t pid = getpid();
            pid_t pgid = getgid();
            (void)pgid;
            log_debug(OS_LOG_DEFAULT, "HUD pid %d, pgid %d", pid, pgid);

            NSString *pidString = [NSString stringWithFormat:@"%d", pid];
            [pidString writeToFile:ROOT_PATH_NS(@PID_PATH)
                        atomically:YES
                          encoding:NSUTF8StringEncoding
                             error:nil];

            [UIScreen initialize];
            CFRunLoopGetCurrent();

            GSInitialize();
            BKSDisplayServicesStart();
            UIApplicationInitialize();

            UIApplicationInstantiateSingleton(objc_getClass("SHMainApp"));
            
            static id<UIApplicationDelegate> appDelegate = [[objc_getClass("SHMainAppDelegate") alloc] init];
            [UIApplication.sharedApplication setDelegate:appDelegate];
            [UIApplication.sharedApplication _accessibilityInit];

            [NSRunLoop currentRunLoop];
            BKSHIDEventRegisterEventCallback(_HUDEventCallback);

            if (@available(iOS 15.0, *)) {
                GSEventInitialize(0);
                GSEventPushRunLoopMode(kCFRunLoopDefaultMode);
            }

            [UIApplication.sharedApplication __completeAndRunAsPlugin];

            static int _springboardBootToken;
            notify_register_dispatch("SBSpringBoardDidLaunchNotification", &_springboardBootToken, dispatch_get_main_queue(), ^(int token) {
                notify_cancel(token);

                notify_post(NOTIFY_DISMISSAL_HUD);

                // Re-enable HUD after SpringBoard is launched.
                SetHUDEnabled(YES);

                // Exit the current instance of HUD.
                kill(pid, SIGKILL);
            });

            CFRunLoopRun();
            return EXIT_SUCCESS;
        }
        else if (strcmp(argv[1], "-exit") == 0)
        {
            NSString *pidString = [NSString stringWithContentsOfFile:ROOT_PATH_NS(@PID_PATH)
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];

            if (pidString)
            {
                pid_t pid = (pid_t)[pidString intValue];
                kill(pid, SIGKILL);
                unlink([ROOT_PATH_NS(@PID_PATH) UTF8String]);

            }

            return EXIT_SUCCESS;
        } else if (strcmp(argv[1], "-check") == 0) {
            NSString *pidString = [NSString stringWithContentsOfFile:ROOT_PATH_NS(@PID_PATH)
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];

            if (pidString) {
                pid_t pid = (pid_t)[pidString intValue];
                int killed = kill(pid, 0);
                return (killed == 0 ? EXIT_FAILURE : EXIT_SUCCESS);
            } else return EXIT_SUCCESS;  // No PID file, so HUD is not running
        }else if (strcmp(argv[1], "-PermThread") == 0)
        {
            NSString *where = [NSString stringWithUTF8String:argv[2]];
            NSString *auth = [NSString stringWithUTF8String:argv[3]];
            int permission = [auth intValue];
            const char *file = [where UTF8String];
            chmod(file, permission);
            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
            return EXIT_SUCCESS;
        }
        
        
        
        
        
#else
        return UIApplicationMain(argc, argv, @"SHApplication", @"SHAppDelegate");
#endif
    }
}
