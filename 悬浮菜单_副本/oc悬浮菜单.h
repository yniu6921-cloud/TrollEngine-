// ImGuiMenu.h
//  QQ1587820860
//  Created by LAN on 2025/7/24.
//  Copyright © 2025 LAN. All rights reserved.
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define 加载自定义字体 a40c125efbf009b3a49ab60469f6fd

#define CustomPageButton c40c125efbf009b3a49ab60469f6fd

#define 自用oc悬浮菜单 ed1ca06e7f46ae0973a0104c7c777c

#define CustomSliderView f7a59fdec1f662e906f3e2eb9ccd3c3

#define CustomSwitchView e30c925efbf009b3a49ab60469f6fd

#define CustomSwitchView2 a30c925efbf009b3a49ab60469f6fd

#define 帧率设置 a30c125efbf009b3a49ab60469f6fd




// 页面类型枚举
typedef NS_ENUM(NSInteger, MenuPageType) {
    MenuPageTypeCharacter = 0, // 人物绘制
    MenuPageTypeItems,         // 物资绘制
    MenuPageTypeAimbot,         // 其他功能
    MenuPageTypeAdvanced,       // 日志
    MenuPageTypeRadar           // 雷达配置
};

@interface 自用oc悬浮菜单 : UIView



extern BOOL 显示人数;
extern BOOL 人物射线;
extern BOOL 人物血条;
extern BOOL 人物骨骼;
extern BOOL 人物信息;
extern BOOL 距离显示;
extern BOOL 背敌显示;
extern BOOL 手持开关;
extern BOOL 隐藏人机;
extern BOOL 手雷预警;
extern BOOL 显示帧率;
extern BOOL 直播模式;
extern BOOL 雷达开关;


extern float 绘制距离;
extern float 雷达位置X;
extern float 雷达位置Y;
extern float 雷达大小;


extern BOOL 突击步枪;
extern BOOL 机枪武器;
extern BOOL 狙击枪械;
extern BOOL 冲锋枪械;
extern BOOL 散弹枪械;
extern BOOL 手枪武器;
extern BOOL 弓箭武器;
extern BOOL 近战武器;
extern BOOL 射手步枪;
extern BOOL 投掷物品;
extern BOOL 步枪弹夹;
extern BOOL 狙击弹夹;
extern BOOL 冲锋弹夹;
extern BOOL 握把配件;
extern BOOL 步枪补偿;
extern BOOL 狙击补偿;
extern BOOL 冲锋补偿;
extern BOOL 枪托配件;
extern BOOL 武器子弹;
extern BOOL 倍镜配件;

extern BOOL 显示载具;
extern BOOL 显示头甲;
extern BOOL 显示背包;
extern BOOL 空投显示;
extern BOOL 信号枪;
extern BOOL 紧急呼救器;
extern BOOL 盒内物资;
extern BOOL 显示药品;
extern BOOL 显示盒子;
extern BOOL 版本物资;
extern BOOL 地铁物资;
extern BOOL 地铁盒子;

extern int 当前帧率;


extern BOOL 调试物资;
extern BOOL 调试盒内;
extern BOOL 调试手持;

@end

NS_ASSUME_NONNULL_END
