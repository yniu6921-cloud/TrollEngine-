#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCTicketStore : NSObject
+ (BOOL)saveTicket:(NSString *)ticket
 deviceFingerprint:(NSString *)deviceFingerprint
             error:(NSError * _Nullable * _Nullable)error;
+ (nullable NSString *)loadTicketForDeviceFingerprint:(NSString *)deviceFingerprint
                                                error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
