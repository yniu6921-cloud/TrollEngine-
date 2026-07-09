#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 监听到的 senderIDs 更新时发出
extern NSString * const kSHIDMonitorDidUpdate;

/// 后台常驻监听器（独立线程 + 独立 RunLoop）
@interface SHIDMonitor : NSObject

+ (instancetype)shared;

/// 当前是否在监听
@property (atomic, assign, readonly, getter=isListening) BOOL listening;

/// 当前抓到的所有 senderID（去重，按发现顺序）
@property (atomic, copy, readonly) NSArray<NSNumber *> *senderIDs;

/// 开始/停止监听（前后台都继续）
- (void)start;
- (void)stop;

/// 清空已抓到的 senderID（仅内存）
- (void)clear;

/// 手动追加一个 senderID（用于“生成 sender ID”按钮）
- (void)appendSenderID:(uint64_t)sid;

@end

NS_ASSUME_NONNULL_END
