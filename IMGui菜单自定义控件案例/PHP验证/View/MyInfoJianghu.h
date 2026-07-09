//
//  UserInfoManager.h
//  MyView
//
//  Created by MRW on 2017/9/9.
//  Copyright © 2017年 WangzhiSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfoJianghu : NSObject
+ (MyInfoJianghu *)MyUserInfo;
@property (nonatomic, assign) int 锁定;
@property (nonatomic, strong) NSString *json;
@property (nonatomic, strong) NSString *MyTime;
@property (nonatomic, strong) NSMutableDictionary *信息;
@property (nonatomic, strong) NSMutableDictionary *解锁码信息;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *daiid;
@property (nonatomic, strong) NSString *账号;
@property (nonatomic, strong) NSString *密码;
@end
