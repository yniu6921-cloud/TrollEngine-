#import <spawn.h>
#import <notify.h>
#import <mach-o/dyld.h>
#import <sys/stat.h>
#import <errno.h>
#import <dispatch/dispatch.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#include <dlfcn.h>
#import "HUDHelper.h"

// #import <xpc/xpc.h>   // XPC - 未使用，已注释
#import <UIKit/UIKit.h>
#import "rootless.h"
#import "NSUserDefaults+Private.h"
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


extern "C" char **environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern "C" int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern "C" int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern "C" int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

// 仍保留你原来的 App 本地日志路径
static inline NSString *LFLogFilePath(void) {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [dir stringByAppendingPathComponent:@"app.log"];
}
// 固定共享路径优先 /var/tmp；不可写则回退到 Documents
static inline NSString *LFResolvedSharedPathForWriter(void) {
    NSString *tmp = @"/var/tmp/lf_shared.log";
    int fd = open(tmp.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) { close(fd); return tmp; }

    // 回退：App Documents（本 App 一定可写）
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *docs = [doc stringByAppendingPathComponent:@"lf_shared.log"];
    fd = open(docs.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) { close(fd); return docs; }

    // 理论不会走到：仍返回 docs，后续 open 会重试
    return docs;
}

// 默认写入文件，方便 TrollStore 安装后首次引导也能看到日志。
static BOOL sDebugLogEnabled = YES;

void LFSetDebugLogEnabled(BOOL enabled) {
    sDebugLogEnabled = enabled;
    NSLog(@"[LFNSLog] Debug file log %@", enabled ? @"ENABLED" : @"DISABLED");
}

void LFSNSLog(NSString *format, ...) {
    static NSFileHandle *sFH = nil;          // app.log 句柄
    static int sSharedFD = -1;               // 共享日志 fd（O_APPEND）
    static dispatch_queue_t sQ;
    static NSDateFormatter *sFmt;
    static NSString *sSharedPath = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        // 1) 准备 app.log（保留你原逻辑）
        NSString *path = LFLogFilePath();
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        sFH = [NSFileHandle fileHandleForWritingAtPath:path];
        [sFH seekToEndOfFile];
        NSLog(@"[LFNSLog] App log path: %@", path);

        // 2) 串行写队列 & 时间格式
        sQ = dispatch_queue_create("lf.filelog.queue", DISPATCH_QUEUE_SERIAL);
        sFmt = [NSDateFormatter new];
        sFmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        sFmt.timeZone = [NSTimeZone localTimeZone];
        sFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";

        // 3) 共享日志路径：固定优先 /var/tmp，不再使用 iCloud
        sSharedPath = LFResolvedSharedPathForWriter();
        NSLog(@"[LFNSLog] Shared log path resolved: %@", sSharedPath);
    });

    // 拼消息
    va_list args; va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    // 无论是否开启文件日志，都打印到控制台
    NSLog(@"%@", msg);

    // 如未开启调试日志，则不写入文件 / 共享日志，直接返回，减轻 IO 压力
    if (!sDebugLogEnabled) {
        return;
    }

    // 组装行
    NSString *ts = [sFmt stringFromDate:[NSDate date]];
    NSString *line = [NSString stringWithFormat:@"%@ %@\n", ts, msg];
    NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

    // 异步写文件
    dispatch_async(sQ, ^{
        // 写 app.log
        @try {
            [sFH seekToEndOfFile];
            [sFH writeData:data];
            NSLog(@"[LFNSLog] Wrote %lu bytes to app.log", (unsigned long)data.length);
        } @catch (__unused NSException *e) {
            NSLog(@"[LFNSLog] Failed writing to app.log: %@", e);
        }

        // 写共享日志（懒打开 + O_APPEND）
        if (sSharedFD < 0 && sSharedPath.length) {
            sSharedFD = open(sSharedPath.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
            NSLog(@"[LFNSLog] Opening shared log: %@ -> fd=%d", sSharedPath, sSharedFD);
            if (sSharedFD < 0) {
                // 如果之前是 /var/tmp 失败，尝试一次回退
                NSString *fallback = LFResolvedSharedPathForWriter();
                if (![fallback isEqualToString:sSharedPath]) {
                    sSharedPath = fallback;
                    sSharedFD = open(sSharedPath.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
                    NSLog(@"[LFNSLog] Fallback to: %@ -> fd=%d", sSharedPath, sSharedFD);
                }
            }
        }

        if (sSharedFD >= 0) {
            ssize_t w = write(sSharedFD, data.bytes, (ssize_t)data.length);
            NSLog(@"[LFNSLog] Wrote %zd bytes to shared log", w);
            if (w < 0) {
                int e = errno;
                NSLog(@"[LFNSLog] Write error: %d (%s)", e, strerror(e));
                // 文件被删/轮转/句柄坏了：关闭等待下次懒重连（读端 VNODE 也会自愈）
                if (e == ENOENT || e == EBADF) {
                    close(sSharedFD); sSharedFD = -1;
                }
            }
        }
    });
}

// 读取 app.log 末尾一段内容（最多 maxBytes 字节），用于 UI 展示
NSString *LFReadAppLogSnippet(NSUInteger maxBytes) {
    if (maxBytes == 0) return @"";
    NSString *path = LFLogFilePath();
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    if (data.length == 0) return @"";

    NSUInteger len = data.length;
    NSUInteger offset = (len > maxBytes) ? (len - maxBytes) : 0;
    NSData *slice = [data subdataWithRange:NSMakeRange(offset, len - offset)];

    NSString *text = [[NSString alloc] initWithData:slice encoding:NSUTF8StringEncoding];
    if (!text) {
        // 编码失败直接返回空，避免 UI 显示乱码
        return @"";
    }
    return text;
}

static inline void LFSSLogInfo(NSString *format, ...) {
    va_list ap; va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    LFSNSLog(@"[INFO] %@", msg);
}



// ========= 你的 IsHUDEnabled：保持原语义（非 0 表示开启）=========
BOOL IsHUDEnabled(void)
{
    static char *executablePath = NULL;
    uint32_t executablePathSize = 0;
    _NSGetExecutablePath(NULL, &executablePathSize);
    executablePath = (char *)calloc(1, executablePathSize);
    _NSGetExecutablePath(executablePath, &executablePathSize);

    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
    posix_spawnattr_set_persona_uid_np(&attr, 0);
    posix_spawnattr_set_persona_gid_np(&attr, 0);

    pid_t task_pid;
    const char *args[] = { executablePath, "-check", NULL };
    posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
    posix_spawnattr_destroy(&attr);

    int status;
    do { if (waitpid(task_pid, &status, 0) != -1) {} }
    while (!WIFEXITED(status) && !WIFSIGNALED(status));

    return (WIFEXITED(status) && WEXITSTATUS(status) != 0);
}
// ========= SetHUDEnabled：起/停 -hud（用令牌接口）=========
void SetHUDEnabled(BOOL isEnabled)
{
#ifdef NOTIFY_DISMISSAL_HUD
    notify_post(NOTIFY_DISMISSAL_HUD);
    NSLog(@"[HUD] 已发送 NOTIFY_DISMISSAL_HUD");
#endif

    static char *executablePath = NULL;
    uint32_t executablePathSize = 0;
    _NSGetExecutablePath(NULL, &executablePathSize);
    executablePath = (char *)calloc(1, executablePathSize);
    _NSGetExecutablePath(executablePath, &executablePathSize);

    LFSSLogInfo(@"[HUD] 可执行路径: %s", executablePath);

    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
    posix_spawnattr_set_persona_uid_np(&attr, 0);
    posix_spawnattr_set_persona_gid_np(&attr, 0);

    if (isEnabled)
    {
        LFSSLogInfo(@"[HUD] 启用 HUD");

        // 先发一次性令牌
     
       

        posix_spawnattr_setpgroup(&attr, 0);
        posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

        pid_t task_pid;
        const char *args[] = { executablePath, "-hud", NULL };
        int ret = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
        NSLog(@"[HUD] 启动 HUD 进程：pid = %d, ret = %d", task_pid, ret);

        posix_spawnattr_destroy(&attr);
    }
    else
    {
        LFSSLogInfo(@"[HUD] 关闭 HUD");

        // 撤销授权（HUD 看到就会退）
      
    

        [NSThread sleepForTimeInterval:0.25];

        pid_t task_pid;
        const char *args[] = { executablePath, "-exit", NULL };
        int ret = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
        NSLog(@"[HUD] 启动退出进程：pid = %d, ret = %d", task_pid, ret);

        posix_spawnattr_destroy(&attr);

        int status;
        do {
            pid_t wp = waitpid(task_pid, &status, 0);
            if (wp != -1) {
                NSLog(@"[HUD] waitpid=%d, status=%d", wp, status);
            }
        } while (!WIFEXITED(status) && !WIFSIGNALED(status));
        if (WIFEXITED(status)) {
            int exitCode = WEXITSTATUS(status);
            NSLog(@"[HUD] 进程正常退出，exit code = %d", exitCode);
        } else if (WIFSIGNALED(status)) {
            int termSignal = WTERMSIG(status);
            NSLog(@"[HUD] 进程因信号终止，signal = %d (%s)", termSignal, strsignal(termSignal));

            if (termSignal == SIGSEGV || termSignal == SIGABRT || termSignal == SIGBUS) {
                NSLog(@"[HUD] ⚠️ HUD 子进程疑似闪退！");
            }
        }
     
    }
}


// ========= 等待 HUD 启动通知（保留你的逻辑）=========
void waitForNotification(void (^onFinish)(), BOOL isEnabled) {
    if (isEnabled)
    {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        int token;
        notify_register_dispatch(NOTIFY_LAUNCHED_HUD, &token, dispatch_get_main_queue(), ^(int token) {
            notify_cancel(token);
            dispatch_semaphore_signal(semaphore);
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
            (void)dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)));
            dispatch_async(dispatch_get_main_queue(), ^{ onFinish(); });
        });
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{ onFinish(); });
    }
}





void fasongxuni(void)
{
   
    uint32_t executablePathSize = 0;
    _NSGetExecutablePath(NULL, &executablePathSize);
    char *executablePath = (char *)calloc(1, executablePathSize);
    _NSGetExecutablePath(executablePath, &executablePathSize);

  

    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);

    // 设置 persona 为 root
    posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
    posix_spawnattr_set_persona_uid_np(&attr, 0);
    posix_spawnattr_set_persona_gid_np(&attr, 0);

    int ret = 0;
    pid_t task_pid = 0;

    posix_spawnattr_setpgroup(&attr, 0);
    posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

    const char *args[] = { executablePath, "HIDDevice", NULL };
    ret = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
    posix_spawnattr_destroy(&attr);

    if (ret == 0) {
      

        sleep(1); // 等待进程启动
        if (kill(task_pid, 0) == 0) {
          
        } else {
            
        }
    } else {
       
    }

   
}



