//
//  UserInfoManager.m
//  MyView
//
//  Created by MRW on 2017/9/9.
//  Copyright © 2017年 WangzhiSong. All rights reserved.
//

#import "MyInfoJianghu.h"
#import "ViewController.h"

static MyInfoJianghu *manager = nil;
@implementation MyInfoJianghu
+ (MyInfoJianghu *)__attribute__((optnone))MyUserInfo{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MyInfoJianghu alloc]init];
    });
    return manager;
}
@end
