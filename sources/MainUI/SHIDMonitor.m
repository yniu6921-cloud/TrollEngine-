#import "SHIDMonitor.h"

// 私有 HID 头
#include "IOHIDEvent.h"
#include "IOHIDEventTypes.h"
#include "IOHIDEventSystemClient.h"
#include "IOHIDService.h"
#import <dlfcn.h>
NSString * const kSHIDMonitorDidUpdate = @"kSHIDMonitorDidUpdate";

@interface SHIDMonitor () {
    IOHIDEventSystemClientRef _client;
    CFRunLoopRef _bgRunLoop;
    NSMutableOrderedSet<NSNumber *> *_set; // 去重保序
}
@end

@implementation SHIDMonitor

static __weak SHIDMonitor *sMonitor = nil;




// C 回调 -> 转到实例方法处理
static void HIDCallback(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event) {
    if (!event) return;
    if (IOHIDEventGetType(event) != kIOHIDEventTypeDigitizer) return;

    
    uint64_t sid = IOHIDEventGetSenderID(event);
   
    SHIDMonitor *mon = sMonitor;
    if (!mon) return;
    [mon handleSenderID:sid];
}
- (instancetype)init {
    if ((self = [super init])) {
        _set = [NSMutableOrderedSet orderedSet];
        sMonitor = self;
    }
    return self;
}

+ (instancetype)shared {
    static SHIDMonitor *inst;
    static dispatch_once_t once;
    dispatch_once(&once, ^{ inst = [self new]; });
    return inst;
}

- (NSArray<NSNumber *> *)senderIDs {
    @synchronized (_set) { return _set.array; }
}

- (BOOL)isListening {
    return _client != NULL;
}

- (void)start {
    if (_client) return;
    _client = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    if (!_client) return;

    // 后台线程 + 独立 RunLoop
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        IOHIDEventSystemClientRegisterEventCallback(self->_client,
            (IOHIDEventSystemClientEventCallback)HIDCallback, NULL, NULL);
        IOHIDEventSystemClientScheduleWithRunLoop(self->_client, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
        self->_bgRunLoop = CFRunLoopGetCurrent();
        CFRunLoopRun();
    });
}

- (void)stop {
    if (!_client) return;
    if (_bgRunLoop) {
        IOHIDEventSystemClientUnregisterEventCallback(_client);
        IOHIDEventSystemClientUnscheduleWithRunLoop(_client, _bgRunLoop, kCFRunLoopDefaultMode);
        CFRunLoopStop(_bgRunLoop);
        _bgRunLoop = NULL;
    }
    CFRelease(_client);
    _client = NULL;
}

- (void)clear {
    BOOL needPost = NO;
    @synchronized (_set) {
        if (_set.count) { [_set removeAllObjects]; needPost = YES; }
    }
    if (needPost) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSHIDMonitorDidUpdate object:self];
        });
    }
}

- (void)appendSenderID:(uint64_t)sid {
    
}

#pragma mark - Private
- (void)handleSenderID:(uint64_t)sid {
    if (sid == 0) return;
    NSNumber *num = @(sid);
    BOOL inserted = NO;
    @synchronized (_set) {
        if (![_set containsObject:num]) {
            [_set addObject:num];
            inserted = YES;
        }
    }
    if (inserted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kSHIDMonitorDidUpdate object:self];
        });
    }
}

@end
