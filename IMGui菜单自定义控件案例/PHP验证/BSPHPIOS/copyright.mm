//
//  copyright.mm
//  msdn
//  Created by 梦三大牛 on 4/23/18.
//  Copyright © 2018 macgu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SpeedHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"
#import "HTTPRedirectResponse.h"
#import "HTTPFileResponse.h"
#import "SAMKeychain.h"
#include <stdlib.h>
UIButton *button1;
UIButton *button2;
UIButton *button3;
UIView *myView;
UITextField *textField;
//===========================================全局变量===========================================
static NSString *MsUDID = @"sdgjigdgerwgqwgreq";//如果不想用udid,就把这句话改成[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];获取IDFA
//===========================================验证系统==========================================
//=====================只是例子演示,你有更好的写法自己写就完了,不要逼逼赖赖哦=====================
/* 调用函数提交你想要的功能接口
 参数1* bsphp提供的功能接口
 参数2* 提交你的激活码
 调用方法:MsdnMessge(@"接口名字",@"激活码");
*/
static void MsdnMessge(NSString *Msapi,NSString *MsCode){
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd#HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *date = [NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * nowDate = [date dateByAddingTimeInterval:interval];
    NSString *nowDateStr = [[nowDate description] stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    //======================提交必须要的接口参数======================
    param[@"api"] = Msapi;//提交到服务器的接口,接口对应的功能bsphp官网查看
    param[@"BSphpSeSsL"] = MD5Digest(dateStr);//连接Cookies
    param[@"date"] = nowDateStr;//提交时间
    param[@"mutualkey"] = BSPHP_MUTUALKEY;//提交通信认证Key
    //========================按不同接口功能提交不同的参数=====================================
    //基本上这4个是大部分功能必须用到的,如果你需要其他特殊的,自己添加接口必须的参数
    param[@"icid"] = MsCode;//提交到服务器的激活码
    param[@"icpwd"] = @"";//提交激活码的密码,开启激活码和密码同时验证的情况下才使用,一般情况下不使用留空
    param[@"key"] = MsUDID;//提交绑定特征
    param[@"maxoror"] = MsUDID;//后台控制多开功能,提交独一无二的标识,这里提交设备码
    //==================================================================================
    [NetTool Post_AppendURL:BSPHP_HOST myparameters:param mysuccess:^(id responseObject){
      NSDictionary *MsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];//服务器返回完整的字典格式内容
        NSString *MsMessge = MsDict[@"response"][@"data"];//取字典内指定值
        NSLog(@"%@",MsMessge);
        NSRange MsRange = [MsMessge rangeOfString:@"|1081|"];//判断指定值内是否包含|1081|
        if (MsRange.location != NSNotFound){//有|1081|就验证成功
            //==========================激活成功储存激活码==========================
             if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activationDeviceID"] == nil){
                 [[NSUserDefaults standardUserDefaults] setObject:MsCode forKey:@"activationDeviceID"];
             }
             //==================================================================
             NSArray *arr = [MsMessge componentsSeparatedByString:@"|"];
             if (arr.count >= 6){//判断数组大于等于9个
                 /*
                  消息组成: 01|1081|设备码|验证数据|时间|Bsphp公告|版本号|||
                  arr[0];//01
                  arr[1];//1081
                  arr[2];//设备码
                  arr[3];//验证数据
                  arr[4];//到期时间
                  arr[5];//系统公告 默认bsphp接口是没有这个的
                  arr[6];//版本号 默认bsphp接口是没有这个的
                  需要获取更多的数组数据修改login.ic接口文件,服务端文件夹已有旧版写好例子,新版照着写,替换原有的login.ic文件就可以获取到系统公告和版本号,也可以自己提交接口获取,比较麻烦就不写了
                  判断版本号公告自己写吧,按照上面例子写或者我发的ios高进进阶udp版本的里面也都有,照抄总会了吧?
                  */
                 
                 if ([[NSUserDefaults standardUserDefaults] integerForKey:@"TiUID"] == 1){
                     NSString *showMsg = [NSString stringWithFormat:@"到期时间: %@", arr[4]];
                     UIAlertController *alertControllera = [UIAlertController alertControllerWithTitle:@"提示" message:showMsg preferredStyle:UIAlertControllerStyleAlert];
                     [alertControllera addAction:[UIAlertAction actionWithTitle:@"不在提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"TiUID"];
                     }]];
                     [alertControllera addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:nil]];
                     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControllera animated:YES completion:nil];
                 }
                 myView.hidden = YES;
                 /*=======================激活成功后的代码添加=======================
             
                  
                  在这添加激活成功后的代码
                  
                  
                  ================================================================*/
             }
        }else{//没有|1081|
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"activationDeviceID"];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"activationDeviceID"];
            //=================处理非激活成功以外的消息都用弹窗形式显示出来=================
            UIAlertController *alertControllera = [UIAlertController alertControllerWithTitle:@"提示" message:MsMessge preferredStyle:UIAlertControllerStyleAlert];
            [alertControllera addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                exit(0);//手动点击闪退
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControllera animated:YES completion:nil];
        }
    }];
}



//======================================系统自动加载函数======================================
static void __attribute__((constructor)) msdnload() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 获取屏幕尺寸
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        // 创建UIView
        CGFloat viewWidth = 300;
        CGFloat viewHeight = 280;
        CGRect frame = CGRectMake((screenBounds.size.width - viewWidth) / 2,
                                  (screenBounds.size.height - viewHeight) / 2,
                                  viewWidth,
                                  viewHeight);
        myView = [[UIView alloc] initWithFrame:frame];
        myView.backgroundColor = [UIColor colorWithRed:1.0 green:0.97 blue:0.95 alpha:1.0]; // 淡粉色背景
        myView.layer.cornerRadius = 15.0; // 圆角半径
        myView.hidden = NO;
        myView.layer.masksToBounds = YES;
        
        // 添加应用程序图标
        UIImageView *appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
        appIconView.image = [UIImage imageNamed:@"/Users/adyen.bv/Downloads/备份文件/图片/BpTxao.png"]; // 替换成你的应用程序图标的文件名
        [myView addSubview:appIconView];
        
        // 添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(appIconView.frame) + 10, 20, 260, 30)];
        titleLabel.text = @"PUBG Engine V1.3";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20.0]; // 加粗字体
        [myView addSubview:titleLabel];
        
        // 添加提示
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 260, 30)];
        hintLabel.text = @"请输入激活码";
        hintLabel.textColor = [UIColor blackColor];
        [myView addSubview:hintLabel];
        
        // 添加输入框
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 260, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.backgroundColor = [UIColor whiteColor];
        // 设置文本颜色为红色
        textField.textColor = [UIColor systemPinkColor];
        textField.layer.borderColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.8 alpha:1.0].CGColor;
        textField.layer.borderWidth = 2.0;
        textField.layer.cornerRadius = 8.0;
        [myView addSubview:textField];
        
        // 添加按钮1
        button1 = [UIButton buttonWithType:UIButtonTypeSystem];
        button1.frame = CGRectMake(20, 160, 120, 38);
        [button1 setTitle:@"Paste" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; // 按钮文本颜色
        button1.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]; // 橙色背景
        button1.layer.cornerRadius = 10.0;
        [myView addSubview:button1];
        [button1 addTarget:[SpeedUDIDHelper class] action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
         
        
        // 添加按钮2
        button2 = [UIButton buttonWithType:UIButtonTypeSystem];
        button2.frame = CGRectMake(160, 160, 120, 38);
        [button2 setTitle:@"Activate" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button2.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0]; // 绿色背景
        button2.layer.cornerRadius = 10.0;
        [myView addSubview:button2];
        [button2 addTarget:[SpeedUDIDHelper class] action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
        // 添加按钮3
        button3 = [UIButton buttonWithType:UIButtonTypeSystem];
        button3.frame = CGRectMake(20, CGRectGetMaxY(button1.frame) + 10, CGRectGetMaxX(button2.frame) - CGRectGetMinX(button1.frame), 32);
        [button3 setTitle:@"Termination procedure" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button3.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // 红色背景
        button3.layer.cornerRadius = 10.0;
        [myView addSubview:button3];
        [button3 addTarget:[SpeedUDIDHelper class] action:@selector(button3Clicked) forControlEvents:UIControlEventTouchUpInside];
        // 添加提示
        UILabel *Copyright = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(button3.frame) + 10, 280, 30)];
        Copyright.text = @"Copyright @TG:ObjCoder";
        Copyright.textColor = [UIColor blueColor];
        [myView addSubview:Copyright];
        
        // 将UIView添加到视图层次中，以便它在界面上可见
        [[UIApplication sharedApplication].keyWindow addSubview:myView];
    });
}


//=====================================================================================
//====================================下面传输数据勿动====================================
//类型编码string转url
static NSString *URLEncodedString(NSString *URL){
    NSString *result = ( NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)URL,NULL,CFSTR("!*();+$,%#[] "),kCFStringEncodingUTF8));
    return result;
}

//设置返回原生状态数据：返回NSData类型
static AFHTTPSessionManager *netWorkingClient = nil;
static AFHTTPSessionManager *sharedNetWorkingApiClient(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkingClient = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        netWorkingClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        netWorkingClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    return netWorkingClient;
}

//将字典拼接成URL形式并以字符串返回
static NSString *stitchingStringFromDictionary(NSDictionary *dictionary){
    NSMutableString *str = [[NSMutableString alloc]initWithCapacity:10];
    bool first = YES;
    for (NSString *key in dictionary){
        if (first){
            [str appendString:[NSString stringWithFormat:@"%@=%@",key,[dictionary objectForKey:key]]];
            first = !first;
        }else{
            [str appendString:[NSString stringWithFormat:@"&%@=%@",key,[dictionary objectForKey:key]]];
        }
    }
    return str;
}

//======================================发送post请求======================================
@implementation NetTool : NSObject
+ (NSURLSessionDataTask *)__attribute__((optnone))Post_AppendURL:(NSString *)appendURL
                              myparameters:(NSDictionary *)param
                                 mysuccess:(void (^)(id responseObject))success{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:@"ok" forKey:@"json"];
    if (param != nil) {
        NSString *desString  = stitchingStringFromDictionary(param);
        NSString *md5String = md5(BSPHP_PASSWORD);
        desString = encryptpro(desString,md5String);
        desString = URLEncodedString(desString);
        parameters[@"parameter"] = desString;
    }
    return [sharedNetWorkingApiClient() POST:appendURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *md5String = md5(BSPHP_PASSWORD);
        str = decryptpro(str,md5String);
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        success(data);
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败,请检查网络或权限" preferredStyle:UIAlertControllerStyleAlert];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert1 animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);//延迟十秒闪退
        });
    }];
}
@end
//==================================描述文件获取UDID=======================================
@implementation SpeedUDIDHelper

// 点击事件处理函数
+ (void)buttonClicked {
    // 处理按钮点击事件
    NSLog(@"Button clicked");
    // 在这里执行你的操作
}

// 点击事件处理函数
+ (void)button1Clicked{
    // 从粘贴板获取内容
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *clipboardContent = pasteboard.string;
    
    // 将内容放入UITextField *textField
    if (clipboardContent && textField) {
        textField.text = clipboardContent;
    }
}

+ (void)button2Clicked{
    // 获取UITextField中的文本
     NSString *activationCode = textField.text;

     // 检查文本是否为空或无效
     if (activationCode.length == 0) {
         // 处理文本为空的情况，例如弹出警告框提示用户输入有效的激活码
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入有效的激活码" preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
         [alert addAction:okAction];
         UIViewController *currentViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [currentViewController presentViewController:alert animated:YES completion:nil];
     } else {
         // 文本不为空，可以提交
         // 假设MsdnMessge是一个自定义的函数来提交激活码
         // 你可以在这里调用该函数，传递激活码作为参数
         MsdnMessge(@"login.ic", activationCode);
     }
}

+ (void)button3Clicked{
    // 退出应用程序
    [[UIApplication sharedApplication] terminateWithSuccess];

}

+ (instancetype)shared {
    static SpeedUDIDHelper *helper_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper_ = [SpeedUDIDHelper new];
        helper_.backgroundTask = UIBackgroundTaskInvalid;
    });
    return helper_;
}

- (void)_startBackgroundTask {
  if (_backgroundTask == UIBackgroundTaskInvalid) {
    _backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
      [self _endBackgroundTask];
    }];
  }
}

- (void)_endBackgroundTask {
  if (_backgroundTask != UIBackgroundTaskInvalid) {
    [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
    _backgroundTask = UIBackgroundTaskInvalid;
  }
}

- (void)getUDIDCompletion{
    //TODO: 缓存自己修改保存位置，放这边容易被猜到。
        if (!self.httpServer.isRunning) {
            NSError *error;
            if (![self.httpServer start:&error]) {
                [self.httpServer stop];
                return exit(0);//闪退
            }
        }
        [self _startBackgroundTask];
        static dispatch_once_t onceToken;
        NSString *url = @"https://lengfeng.cc/";
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
}

- (HTTPServer *)httpServer {
    if (!_httpServer) {
        [_httpServer stop:NO];
        _httpServer = [[HTTPServer alloc] init];
        [_httpServer setConnectionClass:[SpeedHTTPConnection class]];
        [_httpServer setPort:20001];
        [_httpServer setDocumentRoot:[NSBundle mainBundle].bundlePath];
    }
    return _httpServer;
}

@end

@implementation SpeedHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
    if ([method isEqualToString:@"POST"]) {
        if ([path isEqualToString:@"/getudid"]) {
            return YES;
        }
    }
    return [super supportsMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    self.currentPath = path;
    self.currentMethod = method;
    NSObject<HTTPResponse> *response = nil;
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/getudid"]) {
        NSData *data = [request body];
        if (!data) {
            return nil;
        }
        @autoreleasepool {
            NSRange dataRange = NSMakeRange(0, data.length);
            NSString *prefix = @"<?xml";
            NSString *suffix = @"</plist>";
            NSRange prefixRange = [data rangeOfData:[prefix dataUsingEncoding:NSISOLatin1StringEncoding] options:kNilOptions range:dataRange];
            NSRange suffixRange = [data rangeOfData:[suffix dataUsingEncoding:NSISOLatin1StringEncoding] options:kNilOptions range:dataRange];
            if (prefixRange.location == NSNotFound || suffixRange.location == NSNotFound) {
                return nil;
            }
            NSRange enableRange;
            enableRange.location = prefixRange.location;
            enableRange.length = NSMaxRange(suffixRange) - enableRange.location;
            NSData *plist = [data subdataWithRange:enableRange];
            NSDictionary *plistInfo = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:nil];
            NSString *Msudid = [plistInfo objectForKey:@"UDID"];
            if(Msudid != nil && Msudid.length >= 10){
                //=====================储存钥匙串=====================
                [SAMKeychain setPassword:Msudid forService:@"MsUDID" account:@"MengSanDaNiu"];//储存钥匙串
                //==================================================
                dispatch_async(dispatch_get_main_queue(), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            exit(0);//获取到设备码执行闪退,重进生效
                    });
                });
                NSString *path = @"https://lengfeng.cc/6.html";
                response = [[HTTPRedirectResponse alloc] initWithPath:path];
            }
        }
    } else {
        response = [super httpResponseForMethod:method URI:path];
    }
    return response;
}

- (void)prepareForBodyWithSize:(UInt64)contentLength {
    HTTPLogTrace();
}

- (void)processBodyData:(NSData *)postDataChunk {
    HTTPLogTrace();
    BOOL result = [request appendData:postDataChunk];
    if (!result)
    {
        HTTPLogError(@"%@[%p]: %@ - Couldn't append bytes!", THIS_FILE, self, THIS_METHOD);
    }
}
@end
