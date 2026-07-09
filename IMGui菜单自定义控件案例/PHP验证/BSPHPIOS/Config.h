//
//  Config.h
//  msdn
//  Created by 梦三大牛 on 4/23/18.
//  Copyright © 2018 macgu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "defines.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "MF_Base64Additions.h"
#import "HTTPServer.h"
#import "HTTPConnection.h"
#define gIv @"bsphp666"
/*==================================其他说明(必阅读)==================================
 1.使用域名作为通讯地址需要ssl证书https,IP不需要
 2.已在原有基础上简化复杂的验证
 3.搭配bsphp旧版服务端（已开源免费无需授权）付费BSphp pro版未测试,理论通用,防破解与付不付费版无关
 4.已优化防破解加密等问题,http协议传输没有绝对安全
 5.推荐新手学习使用此验证系统,已注释,已无错编译
 6.对外发布请务必加密混淆,Xcode12以下混淆方法：https://www.jianshu.com/p/1219b5a84ad2 Xcode12以上百度:ollvm
 7.后续会更新其他功能:版本号检测,公告系统,换绑设备码,也可以自行二次开发(2.0已兑现)
 8.对ios开发感兴趣的可加学习交流群:513416765
 9.开发不易,请保留版权,谢谢!
 10.把服务端和客户端配置好就可以直接用
 11.如果出现闪退什么的是你自己没有配置好，一步一步的配置.
 */
//===================================服务端配置(必须配置)========================================
/*  服务端搭建就不讲了吧,这都不会赶紧找个班儿上吧!  服务端搭建好按下面操作↓
 1.bsphp免费旧版必填->系统->系统信息设置->系统地址例如:"https://baidu.com/"需要/结尾,bsphp pro付费版不需要设置此项
 2.软件->添加软件->接口库模式:卡串验证限时模式->软件代号别名自己随便设置
 3.软件管理->找到刚添加的配置软件->高级选项->接收到数据解密方式bsphp_3des_vi->返回数据加密方式bsphp_3des_vi->数据输出格式处理文件bsphp_josn->
 4.基本配置->是否绑定模式->验证绑定特征（这个是决定一卡能不能被多用的重要设置）
 5.如果对接出现数据包已经过期，拒绝接收就设置->通信安全->数据包超时->0 （非必要）
 注:其他都按默认设置来,如果出现问题可以去bsphp官网找到开发者帮助寻求答案
 */
//===================================客户端配置(必须配置)========================================
//下面信息通过软件后台>软件>对应软件配置上获得
//软件管理->基本配置->服务器地址(注意看你的域名后面结尾有没有/例如https://baidu.com/|结尾|如果结尾没有/就按服务端第一项配置)
#define BSPHP_HOST  @"https://iosstar.xyz/AppEn.php?appid=10086111&m=640b354bd64afe83f54cfb3dd7d4facc"
//软件管理->基本配置->通信认证Key
#define BSPHP_MUTUALKEY @"300ad5c1c7721e5863dcb911c6fe536f"
//软件管理->配置软件->数据加密密码
#define BSPHP_PASSWORD @"y1NcXjjzoLyy5IvomU"
//===============================混淆函数名(非必要)===========================================
//防破解建议改下下面的MD5内容,默认例子你有破解者也可能有
//加密函数
#define encryptpro MD5NQ1U2GP4EFVP1075WTA0EJIY5YEE4OME6X7PIO00BPYNGVK
//解密函数
#define decryptpro MD5VIH1TDUHJOB44IRNZKA0DCW7B2R2EPSLA1DOW4D7GYRW5DX9
//MD5加密函数
#define MD5Digest MD5Y2WG26955UFJOLMJ4PMZK2FENGITZ9CZGMJN1B3L2H7D3WSX
//验证函数
#define MsdnMessge MD5NJW4PLTCMPR0MSHGWTUJUTBQII0H4IZHCA9ZB0EEROTDU95A
//MD5函数
#define md5 MD5X0PFVPF467MT4YXDYPABCX24SJ9204D2RPGZJZQCDV0FANR8
//设置返回原生状态数据函数
#define sharedNetWorkingApiClient MD59GFANH5Q3GN2G78D4A8J4T2JKBN3IJ373UKXZP0BFEV5HA6L
//返回状态数据变量
#define netWorkingClient MD5VPSYLKM0WXBEZME7GZVP8IHKNYDUSA3LEVU0322AVG2RIOAF
//将字典拼接成URL形式函数
#define stitchingStringFromDictionary MD5XLNFK0B3TS89S25IX2HC9WEKJIKB7M5PL8FXTO06N5AL0LMS
//发送post请求函数名
#define Post_AppendURL MD5D8I94A4F61A8J8SN952UJCMG7W7ZLQ9XOFO4NF0BVO79HRH0

//==========================================加解勿动========================================
//md5加密
static NSString *MD5Digest(NSString *Str){
    const char* input = [Str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    return digest;
}
//md5加密
static NSString *md5(NSString *input){
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}
// des加密方法
static NSString *encryptpro(NSString *plainText,NSString *gkey){
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [myData base64String];
    return result;
}

// des解密方法
static NSString *decryptpro(NSString *encryptText,NSString *gkey){
    NSData *encryptData =  [NSData dataWithBase64String:encryptText];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = (uint8_t *)malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding] autorelease];
    return result;
}
//===========================================================================================



//POST默认
@interface NetTool : NSObject
/**
 *  AFN异步发送post请求，返回原生数据
 *
 *  @param appendURL 追加URL
 *  @param param     参数字典
 *  @param success   成功Block
 *  @return NSURLSessionDataTask任务类型
 */
+ (NSURLSessionDataTask *)__attribute__((optnone))Post_AppendURL:(NSString *)appendURL myparameters:(NSDictionary *)param mysuccess:(void (^)(id responseObject))success;
static NSString *MD5Digest(NSString *Str);
@end
@interface SpeedUDIDHelper : NSObject
@property (nonatomic, strong) HTTPServer *httpServer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, copy) void(^completion)(NSString *udid);
+ (instancetype)shared;
- (void)getUDIDCompletion;
@end
