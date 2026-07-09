#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFCLicenseResult : NSObject
@property (nonatomic, assign) BOOL authorized;
@property (nonatomic, assign) BOOL offline;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy, nullable) NSString *role;
@property (nonatomic, strong, nullable) NSDate *expiresAt;
@end

typedef void (^LFCAuthCompletion)(LFCLicenseResult *result);

@interface LFCAuthManager : NSObject
+ (instancetype)sharedManager;
- (void)activateWithCardKey:(NSString *)cardKey completion:(LFCAuthCompletion)completion;
- (LFCLicenseResult *)validateLocalTicket;
- (NSString *)deviceFingerprint;
@end

NS_ASSUME_NONNULL_END
