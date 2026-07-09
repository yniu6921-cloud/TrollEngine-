#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCVerifiedTicket : NSObject
@property (nonatomic, assign) BOOL valid;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy, nullable) NSString *role;
@property (nonatomic, strong, nullable) NSDate *expiresAt;
@property (nonatomic, strong, nullable) NSDictionary *payload;
@end

@interface LFCTicketVerifier : NSObject
+ (LFCVerifiedTicket *)verifyTicket:(NSString *)ticket
                 deviceFingerprint:(NSString *)deviceFingerprint;
@end

NS_ASSUME_NONNULL_END
