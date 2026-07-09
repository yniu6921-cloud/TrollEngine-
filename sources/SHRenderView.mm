//
//  SHRenderView.m
//  SystemHelper
//
//  Created by 特特 on 2025/4/15.
//  Copyright © 2025 SysAdmin. All rights reserved.
//
//BOOL act=NO;
//if (LoadActivationFromICloud_NOKeychain(&act)) {
//    NSLog(@"激活 activated=%d", act);
//} else {
//    NSLog(@"激活 not activated / tampered");
//}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
#if defined(kIOHIDEventFieldDigitizerIndex) && !defined(kIOHIDEventFieldDigitizerTransducerIndex)
#define kIOHIDEventFieldDigitizerTransducerIndex kIOHIDEventFieldDigitizerIndex
#endif



//#include "krw.h"
#include "OffsetsTool.hpp"
#include "RuntimeWorldResolver.hpp"
#include "Ue4Tool.hpp"
#include "SmobaReader.hpp"
#include "StringObf.h"
#include <stdio.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "HUDHelper.h"
#import "SHRenderView.h"
#import "TEConfig.h"
#import "MainUI/SHEntryCtrl.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "stb_image.h"
#import <Metal/Metal.h>
#include <unordered_map>
#include <deque>
#include <cmath>
#include <notify.h>
#include "IOHIDEvent.h"
#include "touchaa.h"
#include <thread>
#include <notify.h>
#import <spawn.h>
#import <spawn.h>
#import <notify.h>
#import <mach-o/dyld.h>
#include <sys/syscall.h>
#include <sys/wait.h>
#include <unistd.h>
#include "IOHIDEventData.h"
#include "IOHIDEventTypes.h"
#include "IOHIDEventSystemClient.h"
#include "IOHIDEventSystem.h"
#include "IOHIDService.h"
#include "IOKitLib.h"
#import "OffsetsTool.hpp"
#import "Ue4Tool.hpp"
#import "PhysXColliderExtractor.hpp"
#import "PhysXRaycast.hpp"
#import "Font.h"
#import "imgui.h"
#import "imgui_internal.h"
#import "imgui_impl_metal.h"




#import <MetalKit/MetalKit.h>
#import "IOHIDUserDevice.h"
#include <dlfcn.h>
#include <stdio.h>
#include <stdint.h>
#import <UIKit/UIKit.h>
#include <stdio.h>
#include <dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <string>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>
#include <math.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#import <notify.h>
#import <objc/message.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <objc/runtime.h>
#import <mach/vm_param.h>
#include <vector>
#include <map>
#include "UtfTool.hpp"
#include "KFD.hpp"

#import <mach-o/dyld.h>
#import <spawn.h>
@interface SHRenderView () <MTKViewDelegate>
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) NSTimer *prefsTimer;
@property (nonatomic, strong) NSMutableDictionary<NSString*, id<MTLTexture>> *TextUre;
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<MTLTexture>> *texturesDictionary;
@end

@implementation SHRenderView

int 屏幕宽度;
int 屏幕高度;
bool hidzhuang;
static NSString * const kShowTouchTraceKey = @"kShowTouchTraceEnabled";



// ActivationGuard.m
#import <signal.h>
#import <unistd.h>
#import <Foundation/Foundation.h>
// ===== 日志开关 =====
#ifndef TOUCH_LOG_ENABLE
#define TOUCH_LOG_ENABLE 1
#endif

#if TOUCH_LOG_ENABLE
#define TLOG(fmt, ...) NSLog(@"[HID-SLOT] " fmt, ##__VA_ARGS__)
#else
#define TLOG(fmt, ...)
#endif

id<MTLTexture> chi101010;
id<MTLTexture> chi101001;
id<MTLTexture> chi101002;
id<MTLTexture> chi101003;
id<MTLTexture> chi101004;
id<MTLTexture> chi101005;
id<MTLTexture> chi101006;
id<MTLTexture> chi101007;
id<MTLTexture> chi101008;
id<MTLTexture> chi101009;
id<MTLTexture> chi101011;
id<MTLTexture> chi101012;
id<MTLTexture> chi101013;
id<MTLTexture> chi102001;
id<MTLTexture> chi102002;
id<MTLTexture> chi102003;
id<MTLTexture> chi102004;
id<MTLTexture> chi102005;
id<MTLTexture> chi102007;
id<MTLTexture> chi102008;
id<MTLTexture> chi102105;
id<MTLTexture> chi103001;
id<MTLTexture> chi103002;
id<MTLTexture> chi103003;
id<MTLTexture> chi103004;
id<MTLTexture> chi103005;
id<MTLTexture> chi103006;
id<MTLTexture> chi103007;
id<MTLTexture> chi103008;
id<MTLTexture> chi103009;
id<MTLTexture> chi103010;
id<MTLTexture> chi103011;
id<MTLTexture> chi103012;
id<MTLTexture> chi103013;
id<MTLTexture> chi103014;
id<MTLTexture> chi103015;
id<MTLTexture> chi103016;
id<MTLTexture> chi103100;
id<MTLTexture> chi104001;
id<MTLTexture> chi104002;
id<MTLTexture> chi104003;
id<MTLTexture> chi104004;
id<MTLTexture> chi104005;
id<MTLTexture> chi104100;
id<MTLTexture> chi105001;
id<MTLTexture> chi105002;
id<MTLTexture> chi105010;
id<MTLTexture> chi105012;
id<MTLTexture> chi105013;
id<MTLTexture> chi106001;
id<MTLTexture> chi106002;
id<MTLTexture> chi106003;
id<MTLTexture> chi106004;
id<MTLTexture> chi106005;
id<MTLTexture> chi106006;
id<MTLTexture> chi106007;
id<MTLTexture> chi106008;
id<MTLTexture> chi106010;
id<MTLTexture> chi106011;
id<MTLTexture> chi106094;
id<MTLTexture> chi107001;
id<MTLTexture> chi107006;
id<MTLTexture> chi107007;
id<MTLTexture> chi107008;
id<MTLTexture> chi107010;
id<MTLTexture> chi107909;
id<MTLTexture> chi108000;
id<MTLTexture> chi108001;
id<MTLTexture> chi108002;
id<MTLTexture> chi108003;
id<MTLTexture> chi108004;
id<MTLTexture> chi108006;
id<MTLTexture> chi108010;
id<MTLTexture> chi501002;
id<MTLTexture> chi501003;
id<MTLTexture> chi501005;
id<MTLTexture> chi501006;
id<MTLTexture> chi502002;
id<MTLTexture> chi502003;
id<MTLTexture> chi502005;
id<MTLTexture> chi503002;
id<MTLTexture> chi503003;
id<MTLTexture> chi601001;
id<MTLTexture> chi601003;
id<MTLTexture> chi601005;
id<MTLTexture> chi601006;
id<MTLTexture> chi602001;
id<MTLTexture> chi602002;
id<MTLTexture> chi602003;
id<MTLTexture> chi602004;
id<MTLTexture> chi602009;
id<MTLTexture> chi602075;







///载具
id<MTLTexture> VH_Dacia_; ///轿车
id<MTLTexture> VH_UAZ; ///吉普
id<MTLTexture> BP_VH_Buggy_; ///蹦蹦
id<MTLTexture> BP_VH_CoupeRB_; ///姥爷车
id<MTLTexture> CoupeRB_1; ///姥爷车_1
id<MTLTexture> VH_Motorcycle_; ///摩托
id<MTLTexture> VH_MotorcycleCart_; ///人摩托3
id<MTLTexture> MotorcycleCart; ///人摩托3_1
id<MTLTexture> VH_PG117; ///快艇
id<MTLTexture> AquaRail_; ///摩托艇
id<MTLTexture> VH_StationWagon_C; ///旅行车
id<MTLTexture> Mirado_; ///跑车
id<MTLTexture> PickUp_0; ///皮卡_0
id<MTLTexture> Rony_01_C; ///皮卡_1
id<MTLTexture> Rony_3_C; ///皮卡_2
id<MTLTexture> Rony_2_C; ///皮卡_3
id<MTLTexture> VH_MiniBus_; ///巴士
id<MTLTexture> VH_BRDM_; ///装甲车
id<MTLTexture> BP_VH_Tuk_; ///雨林三轮
id<MTLTexture> Snowbike; ///轻型雪地摩托
id<MTLTexture> Snowmobile; ///重型雪地摩托
id<MTLTexture> BP_VH_Bigfoot_C; ///大脚车
id<MTLTexture> VH_Mountainbike_Training_C; ///自行车
id<MTLTexture> VH_Scooter_C; ///小电驴
id<MTLTexture> VH_4SportCar_C; ///敞篷车
id<MTLTexture> VH_ATV1_C; ///全地形车
id<MTLTexture> VH_LadaNiva_01_C; ///雪地越野车
id<MTLTexture> VH_Motorglider_C; ///滑翔机
id<MTLTexture> VH_Horse_; ///马儿
id<MTLTexture> VH_LostMobile; ///马儿
id<MTLTexture> VH_Drift_; ///马儿


// 日志输出函数 - 同时输出到控制台和文件
void 写日志(NSString *format, ...) {
    // 发布版：禁用所有日志输出，消除字符串特征
    (void)format;
}


///医疗
id<MTLTexture> FirstAidbox_Pickup_C; ///医疗箱
id<MTLTexture> Firstaid_Pickup_C; ///急救包
id<MTLTexture> Pills_Pickup_C; ///止痛药
id<MTLTexture> Drink_Pickup_C; ///饮料
id<MTLTexture> Injection_Pickup_C; ///肾上腺素

///护具
id<MTLTexture> Helmet_Lv3; ///三级头
id<MTLTexture> PickUp_BP_Helmet_Lv3_A_C; ///三级头_1
id<MTLTexture> PickUp_BP_Helmet_Lv3_B_C; ///三级头_2
id<MTLTexture> Bag_Lv3; ///三级包
id<MTLTexture> PickUp_BP_Bag_Lv3_A_C; ///三级包_1
id<MTLTexture> PickUp_BP_Bag_Lv3_B_C; ///三级包_2
id<MTLTexture> Armor_Lv3; ///三级甲
id<MTLTexture> PickUp_BP_Armor_Lv3_A_C; ///三级甲_1
id<MTLTexture> PickUp_BP_Armor_Lv3_B_C; ///三级甲_2

///投掷物
id<MTLTexture> BP_Grenade_Stun_Weapon_Wrapper_; ///散光弹
id<MTLTexture> BP_Grenade_Smoke_Weapon_Wrapper; ///烟雾弹
id<MTLTexture> BP_Grenade_Shoulei_Weapon_Wrapper; ///手榴弹
id<MTLTexture> BP_Grenade_Burn_Weapon_Wrapper_; ///燃烧瓶

///其他物品
id<MTLTexture> GasCanBattery_Destructible_Pick; ///汽油桶
id<MTLTexture> BP_AirDropPlane_SuperPeople_C; ///超级空投飞机
id<MTLTexture> BP_AirDropBox_SuperPeople_C; ///超级空投
id<MTLTexture> BP_AirDropPlane_C; ///空投飞机
id<MTLTexture> BP_AirDropBox_C; ///空投
id<MTLTexture> BP_CG025_AirDropBox_C; ///空投_1
id<MTLTexture> BP_revivalAED_Pickup_C; ///自救器
id<MTLTexture> BP_Pistol_Flaregun_Wrapper_C; ///信号枪
id<MTLTexture> Pistol_Flaregun; ///信号枪_1
id<MTLTexture> CharacterDeadInventoryBox_C; ///人物盒子
///枪托
id<MTLTexture> BP_QT_Sniper_Pickup_C; ///托腮板_狙击枪
id<MTLTexture> BP_QT_A_Pickup_C; ///战术枪托
id<MTLTexture> BP_QT_UZI_Pickup_C; ///枪托_Micro_UZI
///枪口
id<MTLTexture> BP_QK_Sniper_Supperssor_Pickup_; ///消音器_狙击枪
id<MTLTexture> BP_QK_Sniper_FlashHider_Pickup_; ///消焰器_狙击枪
id<MTLTexture> BP_QK_Large_Supperssor_Pickup_; ///消音器_步枪
id<MTLTexture> BP_QK_Large_Compensator_Pickup_; ///枪口补偿器_步枪
id<MTLTexture> BP_QK_Mid_Supperssor_Pickup_; ///消音器_冲锋枪

/// 握把
id<MTLTexture> BP_WB_Lasersight_Pickup_C; ///激光瞄准器
id<MTLTexture> BP_WB_ThumbGrip_Pickup_C; ///拇指握把
id<MTLTexture> BP_WB_LightGrip_Pickup_C; ///轻型握把
id<MTLTexture> BP_WB_Angled_Pickup_C; ///直角前握把
id<MTLTexture> BP_WB_Vertical_Pickup_C; ///垂直握把

/// 扩容
id<MTLTexture> BP_DJ_Large_EQ_Pickup_C; ///快速扩容弹夹_步枪
id<MTLTexture> BP_DJ_Large_E_Pickup_C; ///扩容弹夹_步枪
id<MTLTexture> BP_DJ_Sniper_EQ_Pickup_C; ///快速扩容弹夹_狙击枪
id<MTLTexture> BP_DJ_Sniper_E_Pickup_C; ///扩容弹夹_狙击枪
id<MTLTexture> BP_DJ_Mid_EQ_Pickup_C; ///快速扩容弹夹_冲锋枪_手枪
id<MTLTexture> BP_DJ_Mid_E_Pickup_C; ///扩容弹夹_冲锋枪_手枪

/// 倍镜
id<MTLTexture> BP_MZJ_3X_Pickup_C; ///瞄准镜3倍
id<MTLTexture> BP_MZJ_4X_Pickup_C; ///瞄准镜4倍
id<MTLTexture> BP_MZJ_6X_Pickup_C; ///瞄准镜6倍
id<MTLTexture> BP_MZJ_8X_Pickup_C; ///瞄准镜8倍

/// 近战武器
id<MTLTexture> BP_WEP_Pan_Pickup_C; ///平底锅
id<MTLTexture> BP_WEP_Machete_Pickup_C; ///砍刀
id<MTLTexture> BP_WEP_Sickle_Pickup_C; ///镰刀
id<MTLTexture> BP_WEP_Cowbar_Pickup_C; ///撬棍

/// 子弹
id<MTLTexture> BP_Ammo_556mm_Pickup_C; ///556毫米子弹
id<MTLTexture> BP_Ammo_762mm_Pickup_C; ///762毫米子弹
id<MTLTexture> BP_Ammo_300Magnum_Pickup_C; ///300马格南子弹
id<MTLTexture> BP_Ammo_50BMG_Pickup_C; ///50口径子弹

/// 其他枪械
id<MTLTexture> BP_Other_MG3_Wrapper_C; ///MG3轻机枪
id<MTLTexture> BP_Other_PKM_Wrapper_C; ///PKM轻机枪
id<MTLTexture> BP_Other_M249_Wrapper_C; ///M249轻机枪
id<MTLTexture> BP_Other_DP28_Wrapper_C; ///DP_28轻机枪
id<MTLTexture> BP_Other_Shield_Wrapper_C; ///突击盾牌
id<MTLTexture> BP_Other_HuntingBow_Wrapper_C; ///爆炸裂弓

/// 散弹枪
id<MTLTexture> BP_ShotGun_DP12_Wrapper_C; ///DBS散弹枪
id<MTLTexture> BP_ShotGun_SPAS_12_Wrapper_C; ///SPAS_12散弹枪
id<MTLTexture> BP_ShotGun_S12K_Wrapper_C; ///S12K散弹枪
id<MTLTexture> BP_ShotGun_AA12_Wrapper_C; ///AA12_G散弹枪
id<MTLTexture> BP_ShotGun_S1897_Wrapper_C; ///S1897散弹枪
id<MTLTexture> BP_ShotGun_S686_Wrapper_C; ///S686散弹枪
id<MTLTexture> BP_Pistol_TMP_Wrapper_C; ///TMP_9手枪

/// 冲锋枪
id<MTLTexture> BP_MachineGun_MP5K_Wrapper_C; ///MP5K冲锋枪
id<MTLTexture> BP_MachineGun_PP19_Wrapper_C; ///野牛冲锋枪
id<MTLTexture> BP_MachineGun_P90CG17_Wrapper_C; ///P90冲锋枪
id<MTLTexture> BP_MachineGun_TommyGun_Wrapper_; ///汤姆逊冲锋枪
id<MTLTexture> BP_MachineGun_Vector_Wrapper_C; ///维克托冲锋枪
id<MTLTexture> BP_MachineGun_UMP9_Wrapper_C; ///UMP45冲锋枪
id<MTLTexture> BP_MachineGun_Uzi_Wrapper_C; ///UZI冲锋枪

/// 狙击步枪
id<MTLTexture> BP_Sniper_M24_Wrapper_C; ///M24狙击枪
id<MTLTexture> BP_Sniper_AMR_Wrapper_C; ///AMR狙击枪
id<MTLTexture> BP_Sniper_M200_Wrapper_C; ///M200狙击枪
id<MTLTexture> BP_Sniper_AWM_Wrapper_C; ///AWM狙击枪
id<MTLTexture> BP_Sniper_Kar98K_Wrapper_C; ///Kar98K狙击枪
id<MTLTexture> BP_Sniper_Mosin_Wrapper_C; ///莫辛纳甘狙击枪
id<MTLTexture> BP_Sniper_Win94_Wrapper_C; ///Win94狙击枪

/// 射手步枪
id<MTLTexture> BP_WEP_Mk14_Wrapper_C; ///Mk14射手步枪
id<MTLTexture> BP_Sinper_Mini14_Wrapper_C; ///Mini14射手步枪
id<MTLTexture> BP_Sinper_VSS_Wrapper_C; ///VSS射手步枪
id<MTLTexture> BP_Sinper_SKS_Wrapper_C; ///SKS射手步枪
id<MTLTexture> BP_Sinper_QBU_Wrapper_C; ///QBU射手步枪
id<MTLTexture> BP_Sinper_SLR_Wrapper_C; ///SLR射手步枪
id<MTLTexture> BP_Sinper_MK12_Wrapper_C; ///MK12射手步枪
id<MTLTexture> BP_Sinper_MK20_Wrapper_C; ///MK20_H射手步枪
id<MTLTexture> BP_Rifle_M417_Wrapper_C; ///M417射手步枪

/// 762突击步枪
id<MTLTexture> BP_Rifle_M762_Wrapper_C; ///M762突击步枪
id<MTLTexture> BP_Rifle_Groza_Wrapper_C; ///GROZA突击步枪
id<MTLTexture> BP_Rifle_Mk47_Wrapper_C; ///Mk47突击步枪
id<MTLTexture> BP_Rifle_HoneyBadger_Wrapper_C; ///蜜罐突击步枪
id<MTLTexture> BP_Rifle_AKM_Wrapper_C; ///AKM突击步枪

/// 556突击步枪
id<MTLTexture> BP_Rifle_QBZ_Wrapper_C; ///QBZ突击步枪
id<MTLTexture> BP_Rifle_AUG_Wrapper_C; ///AUG突击步枪
id<MTLTexture> BP_Rifle_VAL_Wrapper_C; ///AC_VAL突击步枪
id<MTLTexture> BP_Rifle_G36_Wrapper_C; ///G36C突击步枪
id<MTLTexture> BP_Rifle_M416_Wrapper_C; ///M416突击步枪
id<MTLTexture> BP_Rifle_SCAR_Wrapper_C; ///SCAR_L突击步枪
id<MTLTexture> BP_Rifle_M16A4_Wrapper_C; ///M16A4突击步枪

/// 警告
id<MTLTexture> ProjGrenade_BP_C; ///手榴弹_警告
id<MTLTexture> ProjSmoke_BP_C; ///烟雾弹_警告
id<MTLTexture> ProjBurn_BP_C; ///燃烧瓶_警告
id<MTLTexture> ProjStun_BP_C; ///闪光弹_警告

/// 手持
id<MTLTexture> BP_Grenade_Shoulei_Weapon_C; ///手持_手榴弹
id<MTLTexture> BP_Grenade_Stun_Weapon_C; ///手持_散光弹
id<MTLTexture> BP_Grenade_Smoke_Weapon_C; ///手持_烟雾弹
id<MTLTexture> BP_Grenade_Burn_Weapon_C; ///手持_燃烧瓶

/// 其他
id<MTLTexture> BP_PlayerDeadListWrapper_C; ///盒子列表
id<MTLTexture> AirDropListWrapperActor_C;///空投列表
id<MTLTexture> Bp_AirDrop_C; ///小队奖励空投
id<MTLTexture> BP_CG024HumanCannon_Pickup_C; ///战术弹射炮
id<MTLTexture> BP_Grenade_EmergencyCall_Weapon; ///紧急呼机器
id<MTLTexture> PickUp_BP_Mountainbike1_C; ///山地自行车



id<MTLTexture> daodi; ///山地自行车
id<MTLTexture> 自行车;


id<MTLTexture> 赛车;
id<MTLTexture> 挖掘机;


ImTextureID AKM_ID;
ImTextureID M416_ID;
ImTextureID SCAR_L_ID;
ImTextureID M164A4_ID;
ImTextureID Groza_ID;
ImTextureID AUG_ID;
ImTextureID QBZ_ID;
ImTextureID M762_ID;
ImTextureID Mk47_ID;
ImTextureID G36C_ID;
ImTextureID AC_VAL_ID;
ImTextureID 蜜罐_ID;
ImTextureID Kar98k_ID;
ImTextureID M24_ID;
ImTextureID AWM_ID;
ImTextureID SKS_ID;
ImTextureID VSS_ID;
ImTextureID Mini14_ID;
ImTextureID MK_14_ID;
ImTextureID Win94_ID;
ImTextureID SLR_ID;
ImTextureID QBU_ID;
ImTextureID 莫辛纳甘_ID;
ImTextureID AMR_ID;
ImTextureID M417_ID;
ImTextureID MK20_ID;
ImTextureID UZI_ID;
ImTextureID P90_ID;
ImTextureID UMP45_ID;
ImTextureID Vector_ID;
ImTextureID TommyGun_ID;
ImTextureID 野牛_ID;
ImTextureID S686_ID;
ImTextureID S1897_ID;
ImTextureID S12K_ID;
ImTextureID DBS_ID;
ImTextureID 短管喷子_ID;
ImTextureID SPAS_12_ID;
ImTextureID P92_ID;
ImTextureID P1911_ID;
ImTextureID R1895_ID;
ImTextureID P18C_ID;
ImTextureID R45_ID;
ImTextureID 沙漠之鹰_ID;
ImTextureID MP5K_ID;
id<MTLTexture> quan;


bool 烟雾;

extern "C" char **environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern "C" int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern "C" int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern "C" int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);



static void kill_parent_and_exit(void) {
    pid_t parent = getppid();
    if (parent > 1) {
        // 随机延迟一点，避免被同步拦截
        usleep(100000 + arc4random_uniform(200000)); // 100~300ms
        kill(parent, SIGKILL);
    }
    _exit(0);
}

void EnsureActivatedOrExitViaChildProcess(BOOL (^checker)(void)) {
   

    // 先做一次同步校验：不通过就直接不往下跑
    if (!checker || !checker()) {
       

#if !TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
       
        pid_t pid = fork();
        if (pid == 0) {
          
            kill_parent_and_exit();
        }
        _exit(0);
#else
#ifdef JB_ENV_ALLOW_FORK

        pid_t pid = fork();
        if (pid == 0) {
         
            kill_parent_and_exit();
        }
#endif
      
        _exit(0);
#endif
        return;
    }

  

#ifdef JB_ENV_ALLOW_FORK
    // 通过时也可以起一个守护子进程，周期性二次校验（可选）
    pid_t pid = fork();
    if (pid == 0) {
       
        // 子进程后台巡检：一旦检测为未激活 -> 杀父进程
        while (1) {
            usleep(500000 + arc4random_uniform(500000)); // 0.5~1s
            if (!checker()) {
               
                kill_parent_and_exit();
            }
        }
    }
#endif
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        
        _device = MTLCreateSystemDefaultDevice();
        _commandQueue = [_device newCommandQueue];
        if (!_device) {
            LFLogError(@"[SHRenderView] MTLCreateSystemDefaultDevice() failed. Disabling renderer.");
            return self; // graceful degrade，别直接崩
        }
        [self setupImGuiView:frame];
        [self setupImGui];
     
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self initImageTexture:self.device];
        });
        [self startPrefsTimer];
        // 后台异步初始化内核，避免阻塞 UI；游戏未启动时会自动重试
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self InitializeClient];
        });
        
       
       
        initSenderId();
        
    }
    
    return self;
}



static inline uint64_t U64FromValue(id value) {
    if ([value isKindOfClass:NSNumber.class]) {
        return [(NSNumber *)value unsignedLongLongValue];
    }
    if ([value isKindOfClass:NSString.class]) {
        const char *s = [(NSString *)value UTF8String];
        // base=0: 自动识别 0x 前缀为十六进制，没前缀则按十进制
        char *endp = NULL;
        unsigned long long x = strtoull(s, &endp, 0);
        return (uint64_t)x;
    }
    return 0;
}
#pragma mark - 远程坐标
static CFStringRef (*MGCopyAnswerFunc)(CFStringRef) = NULL;
static void *gestaltHandle = NULL;
__attribute__((always_inline)) void InitializeMobileGestaltIfNeededds(void) {
    if (!gestaltHandle) {
        gestaltHandle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY);
        if (gestaltHandle) {
            MGCopyAnswerFunc = (CFStringRef (*)(CFStringRef))dlsym(gestaltHandle, "MGCopyAnswer");
        }
    }
}
__attribute__((always_inline)) void CleanupMobileGestaltds(void) {
    if (gestaltHandle) {
        dlclose(gestaltHandle);
        gestaltHandle = NULL;
        MGCopyAnswerFunc = NULL;
    }
}
void *LoadAndLogDylib(NSString *path) {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
     
        return NULL;
    }

    // 预检：只做依赖检查，不真正加载
    if (!dlopen_preflight(path.fileSystemRepresentation)) {
        const char *e = dlerror();
       
        // 继续尝试真正 dlopen，也可以直接 return
    }

    dlerror(); // 清空上一条错误
    void *h = dlopen(path.fileSystemRepresentation, RTLD_NOW | RTLD_GLOBAL);
    if (!h) {
        const char *e = dlerror();
        
        return NULL;
    }

   

 
    return h;
}
uint64_t offset_vm_map_pmap = 0;
uint64_t vm_map_pmap;

// 记录当前实际加载成功的内核 dylib 路径（用于排查“更新后仍像老版本”的问题）
static NSString *gLFLoadedKernelDylibPath = nil;
NSString *LFLoadedKernelDylibPath(void) {
    return gLFLoadedKernelDylibPath;
}

// 多路径尝试加载内核 dylib（libjailbreak / 系统路径）
static void *LoadKernelDylib(void) {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSArray<NSString *> *candidates = @[
        [bundlePath stringByAppendingPathComponent:@"libjailbreak.dylib"],
        @"/usr/lib/libjailbreak.dylib",
        @"/var/jb/usr/lib/libjailbreak.dylib",
        @"/var/mobile/lib/libjailbreak.dylib",
    ];
    for (NSString *path in candidates) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            写日志(@"[初始化] 尝试加载 dylib: %@", path);
            void *h = LoadAndLogDylib(path);
            if (h) {
                写日志(@"[初始化] ✓ dylib 加载成功: %@", path);
                gLFLoadedKernelDylibPath = path;
                return h;
            }
        }
    }
    写日志(@"[初始化] ❌ 所有 dylib 路径均加载失败");
    gLFLoadedKernelDylibPath = nil;
    return NULL;
}

typedef NS_ENUM(NSInteger, TETrekRuntimeState) {
    TETrekRuntimeStateIdle = 0,
    TETrekRuntimeStateRunning,
    TETrekRuntimeStateSucceeded,
    TETrekRuntimeStateFailed,
};

static volatile TETrekRuntimeState gTETrekRuntimeState = TETrekRuntimeStateIdle;

static void StartTrekRuntimePreparationIfNeeded(void) {
    @synchronized ([SHRenderView class]) {
        if (gTETrekRuntimeState == TETrekRuntimeStateRunning ||
            gTETrekRuntimeState == TETrekRuntimeStateSucceeded) {
            写日志(@"[TrekRuntime] 初始化已在进行或已完成，跳过重复启动");
            return;
        }
        gTETrekRuntimeState = TETrekRuntimeStateRunning;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *helperPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"TrekRuntime"];
        if (![[NSFileManager defaultManager] isExecutableFileAtPath:helperPath]) {
            写日志(@"[TrekRuntime] ❌ 未找到可执行 helper: %@", helperPath);
            gTETrekRuntimeState = TETrekRuntimeStateFailed;
            return;
        }

        写日志(@"[TrekRuntime] 启动最小运行时初始化: %@", helperPath);
        const char *path = helperPath.fileSystemRepresentation;
        char *argv[] = {(char *)path, (char *)"trollengine-init", NULL};
        extern char **environ;
        pid_t pid = 0;
        int spawnErr = posix_spawn(&pid, path, NULL, NULL, argv, environ);
        if (spawnErr != 0) {
            写日志(@"[TrekRuntime] ❌ posix_spawn 失败: %d", spawnErr);
            gTETrekRuntimeState = TETrekRuntimeStateFailed;
            return;
        }

        int status = 0;
        if (waitpid(pid, &status, 0) < 0) {
            写日志(@"[TrekRuntime] ❌ waitpid 失败: %d", errno);
            gTETrekRuntimeState = TETrekRuntimeStateFailed;
            return;
        }

        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
            写日志(@"[TrekRuntime] ✓ 最小运行时初始化完成，准备重试 AOI");
            gTETrekRuntimeState = TETrekRuntimeStateSucceeded;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [[SHRenderView sharedInstance] InitializeClient];
            });
        } else {
            写日志(@"[TrekRuntime] ❌ 初始化退出异常 status=%d", status);
            gTETrekRuntimeState = TETrekRuntimeStateFailed;
        }
    });
}

- (void)InitializeClient {
    写日志(@"========== 开始初始化客户端 ==========");
    
    KFD::Reset();
    写日志(@"[初始化] KFD::Reset() 完成");
    
    void *h = LoadKernelDylib();
    KFD::SetHandle(h);

    if (!KFD::Handle()) {
        写日志(@"[初始化] ❌ KFD::Handle() 为空，内核初始化失败");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ KFD::Handle() 有效: %p", KFD::Handle());

    // 1) 避免重复初始化（第二次进来直接跳过）
    static bool sJBDInited = false;
    if (!sJBDInited) {
        写日志(@"[初始化] 开始初始化 PPLRW...");
        int ret = KFD::jbdInitPPLRW_call(KFD::Handle());
        写日志(@"[初始化] jbdInitPPLRW_call 返回: %d", ret);
        if (ret != 0) {
            写日志(@"[初始化] ❌ PPLRW 初始化失败，返回码: %d", ret);
            KFD::S().kernelReady = false;
            return;
        }
        写日志(@"[初始化] ✓ PPLRW 初始化成功");
        sJBDInited = true;
    } else {
        写日志(@"[初始化] PPLRW 已初始化，跳过");
    }

    // 2) 设置偏移
    offset_vm_map_pmap = 0x48;
    if (@available(iOS 15.4, *)) {
        offset_vm_map_pmap = 0x40;
        写日志(@"[初始化] iOS 15.4+，使用偏移: 0x%llx", (unsigned long long)offset_vm_map_pmap);
    } else {
        写日志(@"[初始化] iOS < 15.4，使用偏移: 0x%llx", (unsigned long long)offset_vm_map_pmap);
    }

    // 和平精英多进程名支持（不同版本/区服可能不同）
    static const char *gameProcessNames[] = {"ShadowTrackerExt", "ShadowTracker", "TslGame", "PUBGMobile"};
    int pid = -1;
    for (size_t i = 0; i < sizeof(gameProcessNames)/sizeof(gameProcessNames[0]); i++) {
        pid = KFD::findProcessByName(gameProcessNames[i]);
        if (pid > 0) {
            写日志(@"[初始化] ✓ 找到游戏进程 %s，PID: %d", gameProcessNames[i], pid);
            break;
        }
    }
    if (pid <= 0) {
        写日志(@"[初始化] ❌ 未找到游戏进程！请确保和平精英正在运行");
        KFD::S().kernelReady = false;
        return;
    }
    
    写日志(@"[初始化] 查找进程结构体，PID: %d", pid);
    uint64_t proc_addr = KFD::call_proc_find(KFD::Handle(), pid);
    写日志(@"[初始化] proc_find 返回地址: 0x%llx", (unsigned long long)proc_addr);
    if (!proc_addr) {
        写日志(@"[初始化] ❌ 无法找到进程结构体");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ 找到进程结构体: 0x%llx", (unsigned long long)proc_addr);

    写日志(@"[初始化] 获取 task 地址...");
    uint64_t task_addr = KFD::call_proc_task(KFD::Handle(), proc_addr);
    写日志(@"[初始化] proc_task 返回地址: 0x%llx", (unsigned long long)task_addr);
    if (!task_addr) {
        写日志(@"[初始化] ❌ 无法获取 task 地址");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ 找到 task 地址: 0x%llx", (unsigned long long)task_addr);

    写日志(@"[初始化] 读取 vm_map (task + 0x28)...");
    uint64_t vm_map = KFD::KextRW_kread_ptr(&KFD::S().handle, task_addr + 0x28);
    写日志(@"[初始化] vm_map 地址: 0x%llx", (unsigned long long)vm_map);
    if (!vm_map) {
        写日志(@"[初始化] ❌ 无法读取 vm_map");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ 找到 vm_map: 0x%llx", (unsigned long long)vm_map);

    写日志(@"[初始化] 读取 pmap (vm_map + 0x%llx)...", (unsigned long long)offset_vm_map_pmap);
    uint64_t pmap = KFD::KextRW_kread_ptr(&KFD::S().handle, vm_map + offset_vm_map_pmap);
    写日志(@"[初始化] pmap 地址: 0x%llx", (unsigned long long)pmap);
    if (!pmap) {
        写日志(@"[初始化] ❌ 无法读取 pmap");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ 找到 pmap: 0x%llx", (unsigned long long)pmap);

    写日志(@"[初始化] 读取 vm_map_pmap (pmap + 0x8)...");
    vm_map_pmap = KFD::KextRW_kread64(&KFD::S().handle, pmap + 0x8);
    写日志(@"[初始化] vm_map_pmap: 0x%llx", (unsigned long long)vm_map_pmap);

    写日志(@"[初始化] 探测 vm_map__hdr 偏移...");
    size_t off_vm_map__hdr = KFD::probe_off_vm_map__hdr(vm_map);
    写日志(@"[初始化] off_vm_map__hdr: 0x%zx", off_vm_map__hdr);
    if (!off_vm_map__hdr) {
        写日志(@"[初始化] ❌ 无法探测 vm_map__hdr 偏移");
        KFD::S().kernelReady = false;
        return;
    }
    写日志(@"[初始化] ✓ 找到 vm_map__hdr 偏移: 0x%zx", off_vm_map__hdr);

    写日志(@"[初始化] 查找主程序基地址...");
    uint64_t base = KFD::find_main_exe_base_from_vm_map(vm_map, off_vm_map__hdr);
    写日志(@"[初始化] 基地址查找结果: 0x%llx", (unsigned long long)base);
    if (base) {
        写日志(@"[初始化] ✓✓✓ 成功获取游戏基地址: 0x%llx", (unsigned long long)base);
        KFD::S().base = base;
        KFD::S().kernelReady = true;
        写日志(@"[初始化] ✓✓✓ 内核状态已设置为在线");
    } else {
        写日志(@"[初始化] ❌ 无法找到游戏基地址");
        KFD::S().kernelReady = false;
    }
    
    KFD::S().vm_map_pmap = vm_map_pmap;
    写日志(@"[初始化] vm_map_pmap 已保存: 0x%llx", (unsigned long long)vm_map_pmap);
    
    
    写日志(@"========== 客户端初始化完成，内核状态: %@ ==========", 内核 ? @"在线" : @"离线");



    

}

- (void)setupTouchTraceIfNeeded {
    // 触控点可视化已禁用。
}
- (void)_icloudKVSChanged:(NSNotification *)note {
    (void)note;
}



// 仍保留你原来的 App 本地日志路径
static inline NSString *LFLogFilePath(void) {
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [dir stringByAppendingPathComponent:@"app.log"];
}
// 固定共享路径优先 /var/tmp；不可写则回退到 Documents
static inline NSString *LFResolvedSharedPathForWriter(void) {
    NSString *tmp = @"/var/tmp/lf_shared.log";
    int fd = open(tmp.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) { close(fd); return tmp; }

    // 回退：App Documents（本 App 一定可写）
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *docs = [doc stringByAppendingPathComponent:@"lf_shared.log"];
    fd = open(docs.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd >= 0) { close(fd); return docs; }

    // 理论不会走到：仍返回 docs，后续 open 会重试
    return docs;
}

void LFNSLog(NSString *format, ...) {
    static NSFileHandle *sFH = nil;          // app.log 句柄
    static int sSharedFD = -1;               // 共享日志 fd（O_APPEND）
    static dispatch_queue_t sQ;
    static NSDateFormatter *sFmt;
    static NSString *sSharedPath = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        // 1) 准备 app.log（保留你原逻辑）
        NSString *path = LFLogFilePath();
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        sFH = [NSFileHandle fileHandleForWritingAtPath:path];
        [sFH seekToEndOfFile];
        NSLog(@"[LFNSLog] App log path: %@", path);

        // 2) 串行写队列 & 时间格式
        sQ = dispatch_queue_create("lf.filelog.queue", DISPATCH_QUEUE_SERIAL);
        sFmt = [NSDateFormatter new];
        sFmt.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        sFmt.timeZone = [NSTimeZone localTimeZone];
        sFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";

        // 3) 共享日志路径：固定优先 /var/tmp，不再使用 iCloud
        sSharedPath = LFResolvedSharedPathForWriter();
        NSLog(@"[LFNSLog] Shared log path resolved: %@", sSharedPath);
    });

    // 拼消息
    va_list args; va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    // 同步打印到控制台
    NSLog(@"%@", msg);

    // 组装行
    NSString *ts = [sFmt stringFromDate:[NSDate date]];
    NSString *line = [NSString stringWithFormat:@"%@ %@\n", ts, msg];
    NSData *data = [line dataUsingEncoding:NSUTF8StringEncoding];

    // 异步写文件
    dispatch_async(sQ, ^{
        // 写 app.log
        @try {
            [sFH seekToEndOfFile];
            [sFH writeData:data];
            NSLog(@"[LFNSLog] Wrote %lu bytes to app.log", (unsigned long)data.length);
        } @catch (__unused NSException *e) {
            NSLog(@"[LFNSLog] Failed writing to app.log: %@", e);
        }

        // 写共享日志（懒打开 + O_APPEND）
        if (sSharedFD < 0 && sSharedPath.length) {
            sSharedFD = open(sSharedPath.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
            NSLog(@"[LFNSLog] Opening shared log: %@ -> fd=%d", sSharedPath, sSharedFD);
            if (sSharedFD < 0) {
                // 如果之前是 /var/tmp 失败，尝试一次回退
                NSString *fallback = LFResolvedSharedPathForWriter();
                if (![fallback isEqualToString:sSharedPath]) {
                    sSharedPath = fallback;
                    sSharedFD = open(sSharedPath.fileSystemRepresentation, O_WRONLY | O_CREAT | O_APPEND, 0644);
                   // NSLog(@"[LFNSLog] Fallback to: %@ -> fd=%d", sSharedPath, sSharedFD);
                }
            }
        }

        if (sSharedFD >= 0) {
            ssize_t w = write(sSharedFD, data.bytes, (ssize_t)data.length);
            //NSLog(@"[LFNSLog] Wrote %zd bytes to shared log", w);
            if (w < 0) {
                int e = errno;
              //  NSLog(@"[LFNSLog] Write error: %d (%s)", e, strerror(e));
                // 文件被删/轮转/句柄坏了：关闭等待下次懒重连（读端 VNODE 也会自愈）
                if (e == ENOENT || e == EBADF) {
                    close(sSharedFD); sSharedFD = -1;
                }
            }
        }
    });
}
static inline void LFLogError(NSString *format, ...) {
    va_list ap; va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    LFNSLog(@"[AIM][ERROR] ❌ %@", msg);
}

static inline void LFLogWarn(NSString *format, ...) {
    va_list ap; va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    LFNSLog(@"[AIM][WARN] %@", msg);
}

static inline void LFLogInfo(NSString *format, ...) {
    va_list ap; va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    LFNSLog(@"[AIM][INFO] %@", msg);
}

static inline void LFLogDebug(NSString *format, ...) {
    va_list ap; va_start(ap, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    LFNSLog(@"[AIM][DEBUG] %@", msg);
}

#define LF_K1   0x0123456789ABCDEFULL
#define LF_K2   0xFEDCBA9876543210ULL
#define LF_NONCE 0x1122334455667788ULL



// 可选：轮数（保持一致；16 已经很强）
#ifndef LF_ROUNDS
#define LF_ROUNDS 16
#endif

// 载荷“类型标签”（用于解包）
#define LF_TAG_32   0xA0u   // 单个 32-bit 值
#define LF_TAG_XY16 0xA1u   // (x,y) 16-bit + 16-bit
#define LF_TAG_XY32 0xA2u   // (x,y) 32-bit + 32-bit


static inline uint32_t rotl32(uint32_t x, uint32_t r){ r&=31; return (x<<r)|(x>>(32u-r)); }
static inline uint64_t rotl64(uint64_t x, uint32_t r){ r&=63; return (x<<r)|(x>>(64u-r)); }
static inline uint64_t sm64_next(uint64_t *s){
    *s += 0x9E3779B97F4A7C15ULL;
    uint64_t z = *s;
    z ^= z>>30; z *= 0xBF58476D1CE4E5B9ULL;
    z ^= z>>27; z *= 0x94D049BB133111EBULL;
    z ^= z>>31; return z;
}
static inline void make_sbox(uint8_t sbox[256], uint64_t seed){
    for (int i=0;i<256;++i) sbox[i]=(uint8_t)i;
    for (int i=255;i>0;--i){
        uint64_t r = sm64_next(&seed);
        int j = (int)(r % (uint64_t)(i+1));
        uint8_t t=sbox[i]; sbox[i]=sbox[j]; sbox[j]=t;
    }
}
static inline void make_perm4(uint8_t p[4], uint64_t seed){
    p[0]=0; p[1]=1; p[2]=2; p[3]=3;
    for (int i=3;i>0;--i){
        uint64_t r = sm64_next(&seed);
        int j = (int)(r % (uint64_t)(i+1));
        uint8_t t=p[i]; p[i]=p[j]; p[j]=t;
    }
}
static inline uint32_t apply_sbox32(uint32_t x, const uint8_t s[256]){
    return  (uint32_t)s[(x    )&0xFFu]
          | ((uint32_t)s[(x>>8)&0xFFu]  << 8)
          | ((uint32_t)s[(x>>16)&0xFFu] <<16)
          | ((uint32_t)s[(x>>24)&0xFFu] <<24);
}
static inline uint32_t permute_bytes32(uint32_t x, const uint8_t p[4]){
    uint8_t b0=(uint8_t)(x     ), b1=(uint8_t)(x>> 8);
    uint8_t b2=(uint8_t)(x>>16), b3=(uint8_t)(x>>24);
    uint8_t B[4]={b0,b1,b2,b3};
    return  (uint32_t)B[p[0]] | ((uint32_t)B[p[1]]<<8)
          | ((uint32_t)B[p[2]]<<16) | ((uint32_t)B[p[3]]<<24);
}
static inline void derive_subkeys(uint64_t rk[LF_ROUNDS], uint64_t k1, uint64_t k2, uint64_t nonce){
    uint64_t seed = k1 ^ rotl64(k2,17) ^ nonce ^ 0xA5A55A5AA55A5A5AULL;
    for (int i=0;i<LF_ROUNDS;++i){
        uint64_t r = sm64_next(&seed);
        r ^= (uint64_t)i * 0x9E3779B185EBCA87ULL;
        r = rotl64(r, (unsigned)(r>>58));
        rk[i]=r;
    }
}
static inline uint32_t F32(uint32_t R, uint64_t k, const uint8_t sbox[256], const uint8_t perm4[4]){
    uint32_t x = R ^ (uint32_t)k;
    x = rotl32(x, (uint32_t)((k>>59)&31u));
    x = apply_sbox32(x, sbox);
    x ^= (uint32_t)((k ^ (k>>32)) * 0x9E3779B1u);
    x = permute_bytes32(x, perm4);
    x = rotl32(x, (uint32_t)((k>>17)&31u));
    x ^= (x>>7) ^ (x<<11);
    return x;
}
static inline uint64_t LFDec64(uint64_t c, uint64_t k1, uint64_t k2, uint64_t nonce){
    uint64_t rk[LF_ROUNDS]; derive_subkeys(rk,k1,k2,nonce);
    uint8_t sbox[256], perm4[4];
    uint64_t sseed = k2 ^ rotl64(k1,23) ^ nonce ^ 0x6C8E9CF570932BD5ULL;
    make_sbox(sbox, sseed);
    make_perm4(perm4, sseed ^ 0xD00DFE15DEADBEEFULL);
    uint32_t L=(uint32_t)(c>>32), R=(uint32_t)c;
    for (int i=LF_ROUNDS-1;i>=0;--i){ uint32_t t=R ^ F32(L, rk[i], sbox, perm4); R=L; L=t; }
    return ((uint64_t)L<<32) | (uint64_t)R;
}

// ===== 对外：解密包装 =====
uint32_t LFDec32(uint64_t cipher){
    uint64_t p = LFDec64(cipher, LF_K1, LF_K2, LF_NONCE);
    uint8_t tag = (uint8_t)(p >> 56);
    if (tag != LF_TAG_32) return (uint32_t)p; // 兼容无标签老包
    return (uint32_t)(p & 0xFFFFFFFFu);
}

extern "C" char **environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern "C" int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern "C" int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern "C" int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);



// ====== 小工具：哈希一个稳定的颜色给每个 ID ======
static inline ImU32 ColorForID(uint32_t id) {
    uint32_t h = id * 2654435761u;
    int r = (h      ) & 0xFF;
    int g = (h >>  8) & 0xFF;
    int b = (h >> 16) & 0xFF;
    return IM_COL32(r, g, b, 255);
}

struct TouchSample { ImVec2 p; double t; };

struct TouchTrack {
    bool active = false;
    uint32_t cid = 0;
    std::deque<TouchSample> path;
    ImU32 color = IM_COL32(255,255,255,255);
    ImVec2 lastPix{0,0};
    double lastUpdate = 0.0;
};

static std::unordered_map<uint32_t, TouchTrack> g_tracks;

// 你的文字函数（修一下：不改 font->Scale，避免全局串改）
static void DrawTextOutline(const char* str, ImVec2 pos, bool centered, ImU32 color, bool outline, float fontSize) {
    ImFont* font = ImGui::GetFont();
    ImVec2 vec2 = pos;
    ImVec2 textSize = font->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, str);
    if (centered) vec2.x -= textSize.x * 0.5f;
    if (outline) {
        ImU32 oc = 0xFF000000;
        auto* dl = ImGui::GetForegroundDrawList();
        dl->AddText(font, fontSize, ImVec2(vec2.x+1, vec2.y+1), oc, str);
        dl->AddText(font, fontSize, ImVec2(vec2.x-1, vec2.y-1), oc, str);
        dl->AddText(font, fontSize, ImVec2(vec2.x+1, vec2.y-1), oc, str);
        dl->AddText(font, fontSize, ImVec2(vec2.x-1, vec2.y+1), oc, str);
    }
    ImGui::GetForegroundDrawList()->AddText(font, fontSize, vec2, color, str);
}


// 像素 -> 你的标准化坐标（与你给的函数一致）
inline ImVec2 NormalizeGameCoord(float W, float H, ImVec2 p) {
    float nx = fminf(fmaxf((H - p.y) / H, 0.f), 1.f);
    float ny = fminf(fmaxf(p.x / W,        0.f), 1.f);
    return ImVec2(nx, ny);
}

// 你的标准化坐标 -> 像素（上面的严格逆变换）
inline ImVec2 DenormalizeGameCoord(float W, float H, float nx, float ny) {
    float x = ny * W;          // ny = x / W
    float y = H * (1.f - nx);  // nx = (H - y) / H
    return ImVec2(x, y);
}


// 供回调调用：更新/新增一个触点
static const double kStaleTTL = 0.20; // 兜底 TTL，200ms

static inline void TouchViz_Update(uint32_t cid, float x, float y, bool active) {
    if (!active) { g_tracks.erase(cid); return; }

    ImVec2 pix = (x >= 0 && x <= 1 && y >= 0 && y <= 1)
        ? DenormalizeGameCoord(屏幕宽度, 屏幕高度, x, y)
        : ImVec2(x, y);
    pix.x = fmaxf(0.f, fminf(pix.x, 屏幕宽度));
    pix.y = fmaxf(0.f, fminf(pix.y, 屏幕高度));

    double now = ImGui::GetTime();
    auto& tk = g_tracks[cid];

    // 关键：给新/变更的 cid 正确赋色
    if (tk.cid != cid) {
        tk.cid   = cid;
        tk.color = ColorForID(cid);
    }

    tk.active     = true;
    tk.lastUpdate = now;
    tk.lastPix    = pix;
}
// 每帧绘制
static inline void DrawCenteredTextInCircle(const char* text,
                                            ImVec2 center,
                                            float radius,
                                            ImU32 color,
                                            bool outline,
                                            float fontSize /*建议 12~14*/) {
    ImFont* font = ImGui::GetFont();
    ImVec2 sz = font->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, text);
    ImVec2 pos(center.x - sz.x * 0.5f, center.y - sz.y * 0.5f);

    if (outline) {
        ImU32 oc = 0xFF000000;
        auto* dl = ImGui::GetForegroundDrawList();
        dl->AddText(font, fontSize, ImVec2(pos.x+1, pos.y+1), oc, text);
        dl->AddText(font, fontSize, ImVec2(pos.x-1, pos.y-1), oc, text);
        dl->AddText(font, fontSize, ImVec2(pos.x+1, pos.y-1), oc, text);
        dl->AddText(font, fontSize, ImVec2(pos.x-1, pos.y+1), oc, text);
    }
    ImGui::GetForegroundDrawList()->AddText(font, fontSize, pos, color, text);
}

static inline void TouchViz_Draw() {
    auto* dl = ImGui::GetForegroundDrawList();
    double now = ImGui::GetTime();

    // 兜底清理：超过 TTL 没更新就删（解决丢 Up 的情况）
    for (auto it = g_tracks.begin(); it != g_tracks.end(); ) {
        if ((now - it->second.lastUpdate) > kStaleTTL) it = g_tracks.erase(it);
        else ++it;
    }

    for (auto& kv : g_tracks) {
        auto& tk = kv.second;

        // 圆点
        const float R = 30.f;
        dl->AddCircleFilled(tk.lastPix, R, tk.color);

        // 圈内显示 ID 和 x,y（整数）
        char label[64];
        snprintf(label, sizeof(label), "#%u  %d,%d", tk.cid, (int)tk.lastPix.x, (int)tk.lastPix.y);
        DrawCenteredTextInCircle(label, tk.lastPix, R, IM_COL32(255,255,255,255), true, 12.f);
    }
}
// ===== IOHID 监听 =====
static IOHIDEventSystemClientRef g_client = NULL;

// 封装：从 Digitizer 事件里取 CID / Touch / X / Y

// 取一根指点
static inline bool ExtractOneDigitizer(IOHIDEventRef e,
                                       uint32_t* outCID, bool* outActive,
                                       float* outX, float* outY) {
    if (!e || IOHIDEventGetType(e) != kIOHIDEventTypeDigitizer) return false;

    // 统一“触点ID”，优先 Identity，退回 Index
    int cid = (int)IOHIDEventGetIntegerValue(e, kIOHIDEventFieldDigitizerIdentity);
#if defined(kIOHIDEventFieldDigitizerIndex)
    if (cid <= 0)
        cid = (int)IOHIDEventGetIntegerValue(e, kIOHIDEventFieldDigitizerIndex);
#endif
    // 注意：有的设备 cid 可能是 0，也算有效，不要直接丢弃
    // if (cid < 0) return false;

    bool touching = IOHIDEventGetIntegerValue(e, kIOHIDEventFieldDigitizerTouch);
    bool inRange  = IOHIDEventGetIntegerValue(e, kIOHIDEventFieldDigitizerRange);
    float x = (float)IOHIDEventGetFloatValue(e, kIOHIDEventFieldDigitizerX);
    float y = (float)IOHIDEventGetFloatValue(e, kIOHIDEventFieldDigitizerY);

    *outCID    = (uint32_t)cid;
    *outActive = (touching && inRange); // 关键：两者都要
    *outX = x; *outY = y;
    return true;
}

static void HIDCallback(void* target, void* refcon, IOHIDServiceRef service, IOHIDEventRef event) {
    if (!event || IOHIDEventGetType(event) != kIOHIDEventTypeDigitizer) return;

    bool processed = false;

    // 方案1：有 children 就遍历 children（每个子事件 = 一根手指）
    if (IOHIDEventGetChildren) {
        CFArrayRef children = IOHIDEventGetChildren(event);
        if (children) {
            CFIndex n = CFArrayGetCount(children);
            for (CFIndex i = 0; i < n; ++i) {
                IOHIDEventRef child = (IOHIDEventRef)CFArrayGetValueAtIndex(children, i);
                uint32_t cid; bool touching; float x, y;
                if (ExtractOneDigitizer(child, &cid, &touching, &x, &y)) {
                    TouchViz_Update(cid, x, y, touching);
                    processed = true;
                }
            }
        } else {
            // 无 children：直接尝试从根事件抽取一次
            uint32_t cid; bool touching; float x, y;
            if (ExtractOneDigitizer(event, &cid, &touching, &x, &y)) {
                TouchViz_Update(cid, x, y, touching);
            }
        }
    }

}
// 启动监听
void StartTouchTraceListener(void) {
    if (g_client) return;
    g_client = IOHIDEventSystemClientCreate(kCFAllocatorDefault);
    if (!g_client) return;
    IOHIDEventSystemClientRegisterEventCallback(g_client, (IOHIDEventSystemClientEventCallback)HIDCallback, NULL, NULL);
    IOHIDEventSystemClientScheduleWithRunLoop(g_client, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
}



Vector2 标准化坐标(int width,int height, Vector2 point){
    Vector2 aa;
    aa.X= fmin(fmax((height - point.Y) / height, 0.0), 1.0);
    aa.Y=fmin(fmax(point.X / width, 0.0), 1.0);
    return aa;
}
#pragma mark - 数据
int UseText,totalEnemies,totalAIEnemies,totalRealEnemies,tupian;
CoViewbyo POV;
Vector3 LocationWorldPos;
bool Visible[14];
Vector2 Bones_Pos[20];
static const int kMaxSkeletonBones = 128;
static Vector2 s_boneScreenPos[kMaxSkeletonBones];
// 雷达：敌人世界坐标列表与本地参考（在 读取() 的 Actor 循环中收集，循环后绘制）
static std::vector<Vector3> s_radarEnemyWorldPos;
static Vector3 s_radarLocalPos = {0,0,0};
static CoViewbyo s_radarPOV;

// 王者荣耀数据
static SmobaReadResult g_smobaResult;
static bool g_smobaMode = false; // true = 当前在王者荣耀模式
static constexpr float kCountTextY = 50.0f;
static constexpr float kCountColumnOffsetX = 96.0f;
static constexpr float kCountRayStartOffsetY = 30.0f;
extern BOOL 雷达开关;
extern BOOL 绘制掩体;
extern BOOL 对局显示;
extern float 雷达位置X, 雷达位置Y, 雷达大小;
ImDrawList *绘制图形;
static bool sniperrifle = false;

static float tDistance = 0, markDistance;
static Vector2 markScreenPos;
static bool needAdjustAim = false;
long zimiaoshuju;
Vector3 markPos;
bool kaishchumo;
Vector2 nextPoint;

#pragma mark - KFD




#pragma mark - 数据
static Vector3 GetRelativeLocation(long actor) {
    return KFD::Read<Vector3>(KFD::Read<long>(actor + kRootComponent) + kLocation);
}


static int GetCenterOffsetForVector(Vector2 point) {
    
    return sqrt(pow(point.X - 屏幕宽度/2, 2.0) + pow(point.Y - 屏幕高度/2, 2.0));
}
static string GetPlayerName(long player) {
    string n = "";
    long PlayerName = KFD::Read<long>(player + kPlayerName);
    if (KFD::地址泄露(PlayerName)) {
        UTF8 name[32] = "";
        UTF16 buf16[16] = {0};
        if (!KFD::KextRW_readMemory(&KFD::S().handle,PlayerName, buf16, sizeof(buf16),KFD::S().vm_map_pmap)) {
            return "";
        }
        Utf16_To_Utf8(buf16, name, 28, strictConversion);
        n = string((const char *)name);
    }
    return n;
}

static bool IsFiniteFloatValue(float value) {
    return std::isfinite(value);
}

static bool HasReadablePlayerName(long actor, std::string *outName = nullptr) {
    std::string name = GetPlayerName(actor);
    if (outName) {
        *outName = name;
    }
    if (name.empty()) {
        return false;
    }

    size_t visibleCount = 0;
    for (unsigned char ch : name) {
        if (ch == 0) {
            break;
        }
        if (ch >= 0x20 && ch <= 0x7E) {
            visibleCount++;
            continue;
        }
        if (ch & 0x80) {
            visibleCount++;
            continue;
        }
        return false;
    }
    return visibleCount >= 2;
}

static bool IsSaneWorldPosition(const Vector3 &pos) {
    return IsFiniteFloatValue(pos.X) &&
           IsFiniteFloatValue(pos.Y) &&
           IsFiniteFloatValue(pos.Z) &&
           fabsf(pos.X) < 2000000.0f &&
           fabsf(pos.Y) < 2000000.0f &&
           fabsf(pos.Z) < 2000000.0f;
}

static bool IsStructLikePlayerActor(long actor,
                                    long localCharacter,
                                    bool *outMaybeAI = nullptr,
                                    std::string *outDebug = nullptr) {
    if (!KFD::地址泄露(actor) || actor == localCharacter) {
        return false;
    }

    long rootComponent = KFD::Read<long>(actor + kRootComponent);
    long meshComponent = KFD::Read<long>(actor + kMesh);
    long capsuleComponent = KFD::Read<long>(actor + kCapsuleComponent);
    long playerNamePtr = KFD::Read<long>(actor + kPlayerName);
    long skeletalMesh = KFD::地址泄露(meshComponent) ? KFD::Read<long>(meshComponent + kSkeletalMeshAsset) : 0;
    long boneDataPtr = KFD::地址泄露(meshComponent) ? KFD::Read<long>(meshComponent + kCachedComponentSpaceTransforms) : 0;
    int boneNum = KFD::地址泄露(meshComponent) ? KFD::Read<int>(meshComponent + kCachedComponentSpaceTransforms + 0x8) : 0;

    bool rootOk = KFD::地址泄露(rootComponent);
    bool meshOk = KFD::地址泄露(meshComponent);
    bool capsuleOk = KFD::地址泄露(capsuleComponent);
    bool namePtrOk = KFD::地址泄露(playerNamePtr);
    bool skeletalMeshOk = KFD::地址泄露(skeletalMesh);
    bool boneDataOk = KFD::地址泄露(boneDataPtr) && boneNum >= 15 && boneNum <= kMaxSkeletonBones;

    Vector3 actorPos = {};
    bool posOk = false;
    if (rootOk) {
        actorPos = KFD::Read<Vector3>(rootComponent + kLocation);
        posOk = IsSaneWorldPosition(actorPos);
    }

    float health = KFD::Read<float>(actor + kHealth);
    float healthMax = KFD::Read<float>(actor + kHealthMax);
    int teamID = KFD::Read<int>(actor + kTeamID);
    uint8_t aiFlag = KFD::Read<uint8_t>(actor + kbIsAI);
    uint8_t deadFlag = KFD::Read<uint8_t>(actor + kbDead);
    std::string readableName;
    bool readableNameOk = namePtrOk && HasReadablePlayerName(actor, &readableName);

    bool healthMaxOk = IsFiniteFloatValue(healthMax) && healthMax > 1.0f && healthMax < 20000.0f;
    bool healthOk = healthMaxOk && IsFiniteFloatValue(health) && health >= 0.0f && health <= healthMax + 50.0f;
    bool teamOk = teamID > 0 && teamID < 256;
    bool aiOk = (aiFlag == 0 || aiFlag == 1);
    bool deadOk = (deadFlag == 0 || deadFlag == 1);

    int score = 0;
    if (rootOk) score += 15;
    if (meshOk) score += 15;
    if (capsuleOk) score += 15;
    if (posOk) score += 10;
    if (skeletalMeshOk) score += 15;
    if (boneDataOk) score += 25;
    if (healthMaxOk) score += 15;
    if (healthOk) score += 10;
    if (teamOk) score += 10;
    if (readableNameOk) score += 10;
    if (aiOk) score += 3;
    if (deadOk) score += 2;

    bool identityOk = healthMaxOk || healthOk || teamOk || readableNameOk || aiFlag != 0;
    bool matched = rootOk &&
                   meshOk &&
                   capsuleOk &&
                   posOk &&
                   skeletalMeshOk &&
                   boneDataOk &&
                   identityOk &&
                   score >= 85;
    if (matched && deadFlag != 0 && healthMaxOk && health <= 0.0f) {
        matched = false;
    }

    if (outMaybeAI) {
        *outMaybeAI = (aiFlag != 0);
    }
    if (outDebug) {
        *outDebug = string_format("0x%llx S:%d M:%d C:%d SK:%d B:%d(%d) N:%d HP:%.0f/%.0f T:%d AI:%d D:%d",
                                  (unsigned long long)actor,
                                  score,
                                  meshOk ? 1 : 0,
                                  capsuleOk ? 1 : 0,
                                  skeletalMeshOk ? 1 : 0,
                                  boneDataOk ? 1 : 0,
                                  boneNum,
                                  readableNameOk ? 1 : 0,
                                  health,
                                  healthMax,
                                  teamID,
                                  (int)aiFlag,
                                  (int)deadFlag);
    }
    return matched;
}


static FTransform GetMatrixConversion(long address) {
    FTransform ret;
    // 初始化所有成员为0
    ret.Rotation.x = 0.0f;
    ret.Rotation.y = 0.0f;
    ret.Rotation.z = 0.0f;
    ret.Rotation.w = 0.0f;
    ret.Translation.X = 0.0f;
    ret.Translation.Y = 0.0f;
    ret.Translation.Z = 0.0f;
    ret.Scale3D.X = 0.0f;
    ret.Scale3D.Y = 0.0f;
    ret.Scale3D.Z = 0.0f;
    
    // 安全检查：确保地址有效
    if (address == 0 || address < 0x1000 || address > 0x7FFFFFFF0000) {
        return ret;
    }
    
    // 安全读取矩阵数据，如果读取失败则返回0
    ret.Rotation.x = KFD::Read<float>(address);
    ret.Rotation.y = KFD::Read<float>(address + 4);
    ret.Rotation.z = KFD::Read<float>(address + 8);
    ret.Rotation.w = KFD::Read<float>(address + 12);

    ret.Translation.X = KFD::Read<float>(address + 16);
    ret.Translation.Y = KFD::Read<float>(address + 20);
    ret.Translation.Z = KFD::Read<float>(address + 24);

    ret.Scale3D.X = KFD::Read<float>(address + 32);
    ret.Scale3D.Y = KFD::Read<float>(address + 36);
    ret.Scale3D.Z = KFD::Read<float>(address + 40);
    
    // 检查读取的数据是否有效（避免NaN或无穷大）
    if (isnan(ret.Translation.X) || isnan(ret.Translation.Y) || isnan(ret.Translation.Z) ||
        isinf(ret.Translation.X) || isinf(ret.Translation.Y) || isinf(ret.Translation.Z)) {
        // 如果数据无效，返回全0
        ret.Rotation.x = 0.0f;
        ret.Rotation.y = 0.0f;
        ret.Rotation.z = 0.0f;
        ret.Rotation.w = 0.0f;
        ret.Translation.X = 0.0f;
        ret.Translation.Y = 0.0f;
        ret.Translation.Z = 0.0f;
        ret.Scale3D.X = 0.0f;
        ret.Scale3D.Y = 0.0f;
        ret.Scale3D.Z = 0.0f;
    }
    
    return ret;
}

static Vector3 GetBoneWithRotation(long mesh, int ID, FTransform publicObj) {
    Vector3 BoneCoordinates = {0, 0, 0};
    
    if (!KFD::地址泄露(mesh)) {
        return BoneCoordinates;
    }
    
    // 当前 SDK: CachedComponentSpaceTransforms 在 SkeletalMeshComponent 偏移 0xBE0
    // TArray 布局: Data*(8) + Num(4) + Max(4)，Data 指针在 +0x0
    long boneDataPtr = KFD::Read<long>(mesh + kCachedComponentSpaceTransforms);
    
    if (!KFD::地址泄露(boneDataPtr)) {
        return BoneCoordinates;
    }
    
    // 每个 FTransform 占 0x30 字节 (48 bytes)
    long boneMatrixAddr = boneDataPtr + ID * 0x30;
    
    // 安全检查：确保地址在合理范围内（避免访问无效内存）
    if (boneMatrixAddr == 0 || boneMatrixAddr < 0x1000 || boneMatrixAddr > 0x7FFFFFFF0000) {
        return BoneCoordinates;
    }
    
    // 读取骨骼矩阵
    FTransform BoneMatrix = GetMatrixConversion(boneMatrixAddr);
    
    // 检查矩阵是否有效（避免NaN或无穷大，且不全为0）
    if ((BoneMatrix.Translation.X == 0.0f && BoneMatrix.Translation.Y == 0.0f && BoneMatrix.Translation.Z == 0.0f) ||
        isnan(BoneMatrix.Translation.X) || isnan(BoneMatrix.Translation.Y) || isnan(BoneMatrix.Translation.Z) ||
        isinf(BoneMatrix.Translation.X) || isinf(BoneMatrix.Translation.Y) || isinf(BoneMatrix.Translation.Z)) {
        return BoneCoordinates;
    }
   
    D3DXMATRIX LocalSkeletonMatrix = ToMatrixWithScale(BoneMatrix.Rotation, BoneMatrix.Translation, BoneMatrix.Scale3D);
    D3DXMATRIX PartTotheWorld = ToMatrixWithScale(publicObj.Rotation, publicObj.Translation, publicObj.Scale3D);
    D3DXMATRIX NewMatrix = MatrixMultiplication(LocalSkeletonMatrix, PartTotheWorld);
    
    BoneCoordinates.X = NewMatrix._41;
    BoneCoordinates.Y = NewMatrix._42;
    BoneCoordinates.Z = NewMatrix._43;
    
    // 最终检查：确保坐标不是NaN或无穷大
    if (isnan(BoneCoordinates.X) || isnan(BoneCoordinates.Y) || isnan(BoneCoordinates.Z) ||
        isinf(BoneCoordinates.X) || isinf(BoneCoordinates.Y) || isinf(BoneCoordinates.Z)) {
        BoneCoordinates = {0, 0, 0};
    }
    
    return BoneCoordinates;
}
- (void)startPrefsTimer {
    // 降频到 2s，减小风暴；配合 readPreferences 防重入
 
   
    self.prefsTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                      target:self
                                                    selector:@selector(readPreferences)
                                                    userInfo:nil
                                                     repeats:YES];
    
    
    
}
NSUbiquitousKeyValueStore *iCloudStore;
float 触摸X;
float 触摸Y;
float 缩放X;
float 缩放Y;

float 自瞄速度;
float 自瞄大小;
float 压枪力度;
float 自瞄距离;
float 腰射距离;
bool 倒地不瞄;
bool 触摸轨迹;

//绘制
bool 射线;
bool 背后射线;
bool 方框;
bool 骨骼;
bool 距离;
bool 手持;
bool 背敌;
bool 信息;
bool 血量;
bool 人数;
bool 掩体判断;
float 绘制距离;
bool 地铁物资;
bool 盒内物资;
bool 人机隐藏;
extern BOOL 掩体变色调试;


//物资
bool 防具;
bool 药品;
bool 盒子;
bool 空投;
bool 载具;
bool 预警;
bool 武器;
bool 配件;
bool 人机;
bool 狙击自瞄;
bool 投掷物;
bool 地铁盒子;

bool 自瞄;
bool 自瞄连线;


bool 内核状态=YES;


NSInteger 狙击模式;
NSInteger circleMode;
NSInteger 打击位置;
uint64_t ttpe = 0;
static int chiqiang=0;

// 和我改好的 ESPregulateView 使用的名字保持一致

- (void)readPreferences {

   

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
  
        
        iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
        if (!iCloudStore) {
            LFLogError(@"iCloudStore 为 nil，无法读取自瞄/绘制配置");
            return;
        }
        
        NSDictionary *pointDict = [iCloudStore dictionaryForKey:@"自瞄位置_像素"];
    
        缩放X = [[iCloudStore objectForKey:@"pref.draw.scale.x"] floatValue];
        缩放Y = [[iCloudStore objectForKey:@"pref.draw.scale.y"] floatValue];
        
        自瞄速度 = [[iCloudStore objectForKey:@"自瞄速度"] floatValue];
        自瞄大小 = [[iCloudStore objectForKey:@"自瞄大小"] floatValue];
        压枪力度 = [[iCloudStore objectForKey:@"压枪力度"] floatValue];
        自瞄距离 = [[iCloudStore objectForKey:@"自瞄距离"] floatValue];
        腰射距离 = [[iCloudStore objectForKey:@"腰射距离"] floatValue];
        
        倒地不瞄 = [[iCloudStore objectForKey:@"倒地不瞄"] boolValue];
        触摸轨迹 = [[iCloudStore objectForKey:@"kShowTouchTraceEnabled"] boolValue];
        
        
        血量 = [[iCloudStore objectForKey:@"显示血量"] boolValue];
        射线 = [[iCloudStore objectForKey:@"显示射线"] boolValue];
        信息 = [[iCloudStore objectForKey:@"显示信息"] boolValue];
        手持 = [[iCloudStore objectForKey:@"显示手持"] boolValue];
        距离  = [[iCloudStore objectForKey:@"显示距离"] boolValue];
        背敌  = [[iCloudStore objectForKey:@"显示背敌"] boolValue];
        背后射线   = [[iCloudStore objectForKey:@"背后射线"] boolValue];
        骨骼   = [[iCloudStore objectForKey:@"显示骨骼"] boolValue];
        掩体判断 = [iCloudStore boolForKey:@"掩体判断"];
        if ([iCloudStore objectForKey:@"对局显示"]) {
            对局显示 = [[iCloudStore objectForKey:@"对局显示"] boolValue];
        }
        人机   = [[iCloudStore objectForKey:@"地铁BOOS"] boolValue];
        
        
        
        自瞄      = [[iCloudStore objectForKey:@"开启自瞄"] boolValue];
        自瞄连线  = [[iCloudStore objectForKey:@"自瞄连线"] boolValue];
        
        circleMode = [iCloudStore objectForKey:@"自瞄圆圈模式"] ? (NSInteger)[iCloudStore longLongForKey:@"自瞄圆圈模式"] : 2;
        if (circleMode < 0 || circleMode > 2) circleMode = 2;
        
        
    /*    打击位置 = [iCloudStore objectForKey:@"打击位置"];   */    // 0=头部, 1=胸口, 2=腰部, 3=随机
        打击位置 = [iCloudStore objectForKey:@"打击位置"] ? (NSInteger)[iCloudStore longLongForKey:@"打击位置"] : 0;
        
        狙击模式 = [iCloudStore objectForKey:@"狙击模式"] ? (NSInteger)[iCloudStore longLongForKey:@"狙击模式"] : 0;

   

        地铁物资 = [iCloudStore boolForKey:@"地铁物资"];
        地铁盒子 = [iCloudStore boolForKey:@"地铁盒子"];
        盒内物资 = [iCloudStore boolForKey:@"盒内物资"];
        防具 = [iCloudStore boolForKey:@"显示防具"];
        药品 = [iCloudStore boolForKey:@"显示药品"];
        盒子 = [iCloudStore boolForKey:@"显示盒子"];
        空投 = [iCloudStore boolForKey:@"显示空投"];
        载具 = [iCloudStore boolForKey:@"显示载具"];
        预警 = [iCloudStore boolForKey:@"手雷预警"];
        武器 = [iCloudStore boolForKey:@"显示武器"];
        配件 = [iCloudStore boolForKey:@"显示配件"];
        投掷物 = [iCloudStore boolForKey:@"显示投掷"];
        
        方框 = [iCloudStore boolForKey:@"显示方框"];
        人数 = [iCloudStore boolForKey:@"显示人数"];
        
        内核状态 = [iCloudStore boolForKey:@"内核状态"];
        
        
        
        人机隐藏  = [iCloudStore boolForKey:@"人机隐藏"];
        狙击自瞄  = [iCloudStore boolForKey:@"狙击自瞄"];

        LFLogInfo(@"自瞄配置：开关=%d 连线=%d 速度=%.2f 大小=%.1f 距离=%.1f 腰射距离=%.1f 打击位置=%ld 圆圈模式=%ld",
                  自瞄, 自瞄连线, 自瞄速度, 自瞄大小, 自瞄距离, 腰射距离,
                  (long)打击位置, (long)circleMode);
     
       
    });
}





static std::string GetFName(uint64_t actor,
                            uint64_t UName)
{
    // 1️⃣ 读取 FNameID
    int32_t FNameID = KFD::Read<int32_t>( actor + 0x18);
    if (FNameID <= 0 || FNameID >= 2000000) {
        return "";
    }

    // 2️⃣ 读取 GNames 基址
   

    // 3️⃣ 计算 PageAddr 和 NameAddr
    uint64_t pageAddr = KFD::Read<uint64_t>( UName + ((FNameID / 0x4000) * 8));
    if (!pageAddr) return "";

    uint64_t nameAddr = KFD::Read<uint64_t>( pageAddr + ((FNameID % 0x4000) * 8));
    if (!nameAddr) return "";

    // 4️⃣ 读取名称字符串
    char buf[64] = {0};
    if (!KFD::KextRW_readMemory(&KFD::S().handle, nameAddr + 0xE, buf, sizeof(buf), KFD::S().vm_map_pmap)) {
     
        return "";
    }
   // NSLog(@"读取 到的字符串: %s", buf);

    // 打印调试信息
 

    return std::string(buf);
}

static std::string GetObjectClassName(uint64_t object, uint64_t UName) {
    uint64_t classObject = StripRuntimePAC(KFD::Read<uint64_t>(object + 0x10));
    if (!LooksLikeUserVA(classObject)) {
        return "";
    }
    return GetFName(classObject, UName);
}

static bool IsPlayerObjectName(const std::string &name) {
    return KFD::isContain(name, "PlayerPawn") ||
           KFD::isContain(name, "PlayerCharacter") ||
           KFD::isContain(name, "PlayerControllertSl") ||
           KFD::isContain(name, "CharacterModelTaget") ||
           KFD::isContain(name, "FakePlayer_AIPawn") ||
           KFD::isContain(name, "BPPawn");
}

static bool IsPlayerClassName(const std::string &className) {
    return KFD::isContain(className, "STExtraPlayerCharacter") ||
           KFD::isContain(className, "STExtraBaseCharacter") ||
           KFD::isContain(className, "PlayerPawn") ||
           KFD::isContain(className, "PlayerCharacter") ||
           KFD::isContain(className, "BP_Character") ||
           KFD::isContain(className, "BPPawn") ||
           KFD::isContain(className, "FakePlayer_AIPawn");
}

struct ActorArrayPlayerProbeResult {
    int playerNameCount = 0;
    int playerClassCount = 0;
    std::string sampleObjectName;
    std::string sampleClassName;
};

static int 探测Actor数组人物得分(uint64_t actorArray,
                        int actorCount,
                        uint64_t UName,
                        ActorArrayPlayerProbeResult *out = nullptr) {
    if (out) {
        *out = {};
    }
    if (!LooksLikeUserVA(actorArray) || actorCount <= 0 || !LooksLikeUserVA(UName)) {
        return -1;
    }

    ActorArrayPlayerProbeResult result;
    int sampleBudget = actorCount > 1024 ? 1024 : actorCount;
    int step = actorCount > sampleBudget ? actorCount / sampleBudget : 1;
    if (step < 1) {
        step = 1;
    }
    int scanned = 0;
    for (int i = 0; i < actorCount && scanned < sampleBudget; i += step, ++scanned) {
        uint64_t actor = StripRuntimePAC(KFD::Read<uint64_t>(actorArray + (uint64_t)i * 0x8));
        if (!LooksLikeUserVA(actor)) {
            continue;
        }

        std::string objectName = GetFName(actor, UName);
        std::string className = GetObjectClassName(actor, UName);
        if (result.sampleObjectName.empty() && IsLikelyNameString(objectName)) {
            result.sampleObjectName = objectName;
        }
        if (result.sampleClassName.empty() && IsLikelyNameString(className)) {
            result.sampleClassName = className;
        }
        if (IsPlayerObjectName(objectName)) {
            result.playerNameCount++;
        }
        if (IsPlayerClassName(className)) {
            result.playerClassCount++;
            if (result.sampleClassName.empty()) {
                result.sampleClassName = className;
            }
        }
        if (result.playerClassCount >= 8 && result.playerNameCount >= 2) {
            break;
        }
    }

    if (out) {
        *out = result;
    }
    return result.playerClassCount * 1000 + result.playerNameCount * 200 + (actorCount > 512 ? 512 : actorCount);
}

static bool IsLikelyNameString(const std::string &name) {
    if (name.size() < 3 || name.size() > 63) {
        return false;
    }
    for (unsigned char ch : name) {
        if (ch < 32 || ch > 126) {
            return false;
        }
    }
    return true;
}

static int 评分GNames候选(uint64_t actorArray,
                    int actorCount,
                    uint64_t UName,
                    std::string *outSampleName = nullptr) {
    if (!LooksLikeUserVA(actorArray) || actorCount <= 0 || !LooksLikeUserVA(UName)) {
        return -1;
    }

    int score = 0;
    int nonEmpty = 0;
    int strongMatches = 0;
    std::string sampleName;
    int scanCount = actorCount > 24 ? 24 : actorCount;
    for (int i = 0; i < scanCount; ++i) {
        uint64_t actor = StripRuntimePAC(KFD::Read<uint64_t>(actorArray + (uint64_t)i * 0x8));
        if (!LooksLikeUserVA(actor)) {
            continue;
        }

        std::string name = GetFName(actor, UName);
        if (!IsLikelyNameString(name)) {
            continue;
        }

        nonEmpty++;
        if (sampleName.empty()) {
            sampleName = name;
        }
        score += 20;

        if (KFD::isContain(name, "Player") ||
            KFD::isContain(name, "Character") ||
            KFD::isContain(name, "Pawn") ||
            KFD::isContain(name, "Vehicle") ||
            KFD::isContain(name, "Pickup") ||
            KFD::isContain(name, "Dropped") ||
            KFD::isContain(name, "STExtra")) {
            strongMatches++;
            score += 40;
        }
    }

    if (outSampleName) {
        *outSampleName = sampleName;
    }
    if (nonEmpty == 0) {
        return -1;
    }
    return score + nonEmpty * 5 + strongMatches * 10;
}

static bool 弱校验GNames根(uint64_t UName) {
    UName = StripRuntimePAC(UName);
    if (!LooksLikeUserVA(UName)) {
        return false;
    }

    int validPages = 0;
    for (int i = 0; i < 4; ++i) {
        uint64_t pageAddr = StripRuntimePAC(KFD::Read<uint64_t>(UName + (uint64_t)i * 0x8));
        if (LooksLikeUserVA(pageAddr)) {
            validPages++;
        }
    }
    return validPages > 0;
}

static uint64_t 解析GNames偏移(uint64_t baseAddr,
                         uint64_t actorArray,
                         int actorCount,
                         uint64_t hintOffset,
                         uint64_t *outUName = nullptr,
                         std::string *outSampleName = nullptr) {
    static uint64_t sCachedBaseAddr = 0;
    static uint64_t sCachedActorArray = 0;
    static int sCachedActorCount = 0;
    static uint64_t sCachedGNamesOffset = 0;
    static uint64_t sCachedUName = 0;
    static time_t sLastScanAt = 0;

    auto 试偏移 = [&](uint64_t offset, uint64_t *resolvedUName, std::string *sampleName) -> int {
        uint64_t gNamesVA = ResolveRuntimeHintVA(baseAddr, offset);
        if (!LooksLikeUserVA(gNamesVA)) {
            if (resolvedUName) *resolvedUName = 0;
            return -1;
        }

        uint64_t UName = StripRuntimePAC(KFD::Read<uint64_t>(gNamesVA));
        if (resolvedUName) *resolvedUName = UName;
        return 评分GNames候选(actorArray, actorCount, UName, sampleName);
    };

    if (sCachedBaseAddr == baseAddr &&
        sCachedActorArray == actorArray &&
        sCachedActorCount == actorCount &&
        sCachedGNamesOffset != 0) {
        std::string cachedSample;
        int cachedScore = 评分GNames候选(actorArray, actorCount, sCachedUName, &cachedSample);
        if (cachedScore >= 80) {
            if (outUName) *outUName = sCachedUName;
            if (outSampleName) *outSampleName = cachedSample;
            return sCachedGNamesOffset;
        }
    }

    if (sCachedBaseAddr == baseAddr &&
        sCachedGNamesOffset != 0 &&
        弱校验GNames根(sCachedUName)) {
        if (outUName) *outUName = sCachedUName;
        if (outSampleName && outSampleName->empty()) *outSampleName = "StickyGNames";
        return sCachedGNamesOffset;
    }

    uint64_t hintUName = 0;
    std::string hintSample;
    int hintScore = 试偏移(hintOffset, &hintUName, &hintSample);
    if (hintScore >= 80) {
        sCachedBaseAddr = baseAddr;
        sCachedActorArray = actorArray;
        sCachedActorCount = actorCount;
        sCachedGNamesOffset = hintOffset;
        sCachedUName = hintUName;
        if (outUName) *outUName = hintUName;
        if (outSampleName) *outSampleName = hintSample;
        return hintOffset;
    }

    if (弱校验GNames根(hintUName)) {
        sCachedBaseAddr = baseAddr;
        sCachedActorArray = actorArray;
        sCachedActorCount = actorCount;
        sCachedGNamesOffset = hintOffset;
        sCachedUName = hintUName;
        if (outUName) *outUName = hintUName;
        if (outSampleName && outSampleName->empty()) *outSampleName = hintSample.empty() ? "HintGNames" : hintSample;
        return hintOffset;
    }

    (void)sLastScanAt;
    // 按当前需求禁用 GNames 邻域扫描，只接受固定偏移。
    return 0;
}

static void DrawLine(ImVec2 startPoint, ImVec2 endPoint, int color, float thicknes = 1)
{
    
        绘制图形->AddLine(startPoint, endPoint, color, thicknes);
   
}

static int DrawAllActorDebugRays(uint64_t actorArray, int actorCount, const CoViewbyo& pov)
{
    (void)actorArray;
    (void)actorCount;
    (void)pov;
    return 0;

    /*
    if (!LooksLikeUserVA(actorArray) || actorCount <= 0) {
        return 0;
    }

    const int maxRays = 2000;
    int step = actorCount > maxRays ? (actorCount / maxRays) : 1;
    if (step < 1) {
        step = 1;
    }

    ImVec2 rayStart(屏幕宽度 * 0.5f, 140.0f);
    int drawn = 0;
    for (int i = 0; i < actorCount; i += step) {
        if (drawn >= maxRays) {
            break;
        }

        long actor = KFD::Read<long>(actorArray + (uint64_t)i * 0x8);
        if (!KFD::地址泄露(actor)) {
            continue;
        }

        long rootComponent = KFD::Read<long>(actor + kRootComponent);
        if (!KFD::地址泄露(rootComponent)) {
            continue;
        }

        Vector3 actorPos = KFD::Read<Vector3>(rootComponent + kLocation);
        if (!std::isfinite(actorPos.X) || !std::isfinite(actorPos.Y) || !std::isfinite(actorPos.Z)) {
            continue;
        }

        Vector2 actorScreen = WorldToScreen(actorPos, pov, 屏幕宽度, 屏幕高度);
        if (!isScreenVisible(actorScreen, Vector2(屏幕宽度, 屏幕高度))) {
            continue;
        }

        float distanceM = GetDistance(actorPos, pov.Location) / 100.0f;
        int color = distanceM < 150.0f ? IM_COL32(255, 140, 90, 120) : IM_COL32(90, 220, 255, 90);
        DrawLine(rayStart, ImVec2(actorScreen.X, actorScreen.Y), color, 0.6f);
        drawn++;
    }
    return drawn;
    */
}

// 3D 立体包围盒（线框）：
// - 输入：世界空间 AABB(min/max)
// - 输出：将8个角点投影到屏幕并绘制12条边
// - 同时返回屏幕二维包围矩形（便于复用旧的ESP布局）
static inline bool ProjectToScreenSafe(const Vector3& world,
                                       const CoViewbyo& pov,
                                       float screenW,
                                       float screenH,
                                       Vector2* outScreen)
{
    Vector2 s = WorldToScreen(world, pov, (int)screenW, (int)screenH);
    if (isnan(s.X) || isnan(s.Y) || isinf(s.X) || isinf(s.Y)) return false;
    // 允许在屏幕外（边缘也要画），但不能是离谱值
    if (fabsf(s.X) > screenW * 10.0f || fabsf(s.Y) > screenH * 10.0f) return false;
    *outScreen = s;
    return true;
}

static bool Draw3DWireBoxAABB(const Vector3& bmin,
                              const Vector3& bmax,
                              const CoViewbyo& pov,
                              float screenW,
                              float screenH,
                              ImU32 edgeColor,
                              float thickness,
                              Vector2* outMin2D,
                              Vector2* outMax2D)
{
    Vector3 cornersW[8] = {
        Vector3(bmin.X, bmin.Y, bmin.Z), // 0
        Vector3(bmax.X, bmin.Y, bmin.Z), // 1
        Vector3(bmax.X, bmax.Y, bmin.Z), // 2
        Vector3(bmin.X, bmax.Y, bmin.Z), // 3
        Vector3(bmin.X, bmin.Y, bmax.Z), // 4
        Vector3(bmax.X, bmin.Y, bmax.Z), // 5
        Vector3(bmax.X, bmax.Y, bmax.Z), // 6
        Vector3(bmin.X, bmax.Y, bmax.Z)  // 7
    };

    Vector2 cornersS[8];
    for (int i = 0; i < 8; i++) {
        if (!ProjectToScreenSafe(cornersW[i], pov, screenW, screenH, &cornersS[i]))
            return false;
    }

    // 计算屏幕二维包围
    float minX = cornersS[0].X, minY = cornersS[0].Y, maxX = cornersS[0].X, maxY = cornersS[0].Y;
    for (int i = 1; i < 8; i++) {
        minX = fminf(minX, cornersS[i].X);
        minY = fminf(minY, cornersS[i].Y);
        maxX = fmaxf(maxX, cornersS[i].X);
        maxY = fmaxf(maxY, cornersS[i].Y);
    }
    if (outMin2D) *outMin2D = Vector2(minX, minY);
    if (outMax2D) *outMax2D = Vector2(maxX, maxY);

    auto L = [&](int a, int b) {
        绘制图形->AddLine(ImVec2(cornersS[a].X, cornersS[a].Y),
                       ImVec2(cornersS[b].X, cornersS[b].Y),
                       edgeColor,
                       thickness);
    };

    // bottom
    L(0, 1); L(1, 2); L(2, 3); L(3, 0);
    // top
    L(4, 5); L(5, 6); L(6, 7); L(7, 4);
    // verticals
    L(0, 4); L(1, 5); L(2, 6); L(3, 7);

    return true;
}





- (void)setupImGuiView:(CGRect)frame {
    self.mtkView = [[MTKView alloc] initWithFrame:self.bounds device:_device];
    self.mtkView.backgroundColor = [UIColor clearColor];
    self.mtkView.clipsToBounds = YES;
    self.mtkView.delegate = self;

    // 关键：别用按需刷新
    self.mtkView.enableSetNeedsDisplay = NO;
    self.mtkView.paused = NO;

        // 方式B：老系统直接指定 120（不支持就回落）
   self.mtkView.preferredFramesPerSecond = 240;
    

    [self addSubview:self.mtkView];
}
- (void)setupImGui {
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    // 字体：恢复为原来的中文完整字库，保证 ImGui 正常绘制
    io.Fonts->AddFontFromMemoryTTF((void *)OPPOSans_H, OPPOSans_H_size, 50.0f, nullptr, io.Fonts->GetGlyphRangesChineseFull());
    ImGui::StyleColorsDark();
    ImGui_ImplMetal_Init(_device);
 
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mtkView.frame = self.bounds;
}

- (void)drawInMTKView:(MTKView *)view {
    static int frameCount = 0;
    frameCount++;
    if (frameCount % 60 == 0) { // 每60帧输出一次，避免日志过多
        NSLog(@"[SHRenderView] drawInMTKView被调用，frameCount=%d", frameCount);
    }
    
    view.clearColor = MTLClearColorMake(0.0f, 0.0f, 0.0f, 0.0f);
    
    // 优化后的 FPS 计算
    struct timespec current_timespec;
    static double g_Time = 0.0;
    clock_gettime(CLOCK_MONOTONIC, &current_timespec);
    double current_time = (double)(current_timespec.tv_sec) + (current_timespec.tv_nsec / 1000000000.0);
    ImGui::GetIO().DeltaTime = g_Time > 0.0 ? (float)(current_time - g_Time) : (float)(1.0f / 120);
    g_Time = current_time;
    
    // 设置 DisplaySize 和 FramebufferScale
    ImGuiIO &io = ImGui::GetIO();
    
    // 检查view的transform，如果被旋转了，需要调整DisplaySize
    CGAffineTransform viewTransform = view.transform;
    BOOL isRotated = !CGAffineTransformIsIdentity(viewTransform);
    
    if (isRotated) {
        // 如果view被旋转了90度，交换宽高
        CGFloat width = view.bounds.size.width;
        CGFloat height = view.bounds.size.height;
        // 检查是否是90度旋转（transform的a和d接近0，b和c接近±1）
        if (fabs(viewTransform.a) < 0.1 && fabs(viewTransform.d) < 0.1) {
            // 90度或270度旋转，交换宽高
            io.DisplaySize = ImVec2(height, width);
            屏幕宽度 = height;
            屏幕高度 = width;
            NSLog(@"[SHRenderView] 检测到旋转，调整DisplaySize: %.0f x %.0f -> %.0f x %.0f", width, height, height, width);
        } else {
            io.DisplaySize = ImVec2(width, height);
            屏幕宽度 = width;
            屏幕高度 = height;
        }
    } else {
        io.DisplaySize = ImVec2(view.bounds.size.width, view.bounds.size.height);
        屏幕宽度 = io.DisplaySize.x;
        屏幕高度 = io.DisplaySize.y;
    }
    
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
   

    ///
  
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    
    NSLog(@"[SHRenderView] DisplaySize: %.0f x %.0f, Scale: %.2f, View bounds: %.0f x %.0f", 
          io.DisplaySize.x, io.DisplaySize.y, framebufferScale, 
          view.bounds.size.width, view.bounds.size.height);


    // 创建命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (!renderPassDescriptor) return;
    
    // 新帧开始
    ImGui_ImplMetal_NewFrame(renderPassDescriptor);
    ImGui::NewFrame();
    
    // 绘制逻辑
    // 检查服务器是否禁用了绘制功能（仅做记录，不再强制关闭本地绘制）
    TEInitUserCache();  // 确保初始化
    if (!gTEDrawEnabled) {
        NSLog(@"[SHRenderView] 注意：服务器标记 draw_enabled=NO，但本地仍继续绘制以方便调试/使用。");
    }
    
    绘制图形 = ImGui::GetForegroundDrawList();
    
    // 在屏幕顶端绘制文字 "TG@xim4c"
    float screenWidth = ImGui::GetIO().DisplaySize.x;
    float fontSize = 20.0f;
    std::string text = "Troll Engine";
    ImVec2 textPos(screenWidth * 0.5f, 10.0f);  // 屏幕顶部居中，距离顶部10像素
    int textColor = IM_COL32(255, 255, 255, 255);  // 白色
    DrawText(text, textPos, true, textColor, true, fontSize);  // 居中，带描边
    
    [self draw];
    
    //
  
    
    // 渲染 ImGui
    ImGui::Render();
    ImDrawData *drawData = ImGui::GetDrawData();
    
    id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
#ifdef DEBUG
    [renderEncoder pushDebugGroup:@"SwiftGUI"];
#endif
    ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderEncoder);
    
#ifdef DEBUG
    [renderEncoder popDebugGroup];
#endif
    [renderEncoder endEncoding];
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
}

std::string string_format(const std::string &fmt, ...) {
    @autoreleasepool {
        std::vector<char> str(100,'\0');
        va_list ap;
        while (1) {
            va_start(ap, fmt);
            auto n = vsnprintf(str.data(), str.size(), fmt.c_str(), ap);
            va_end(ap);
            if ((n > -1) && (size_t(n) < str.size())) {
                return str.data();
            }
            if (n > -1)
                str.resize( n + 1 );
            else
                str.resize( str.size() * 2);
        }
        return str.data();
    }
}
static float currentRadius = 5.0f;
static float animationSpeed = 10.0f; // 动画速度

float Lerp(float a, float b, float t) {
    return a + (b - a) * t;
}

void DrawAnimatedCircle(const ImVec2& center, float targetRadius, float thickness, ImU32 color, float deltaTime) {
    float t = 1.0f - expf(-animationSpeed * deltaTime); // 平滑插值
    currentRadius = Lerp(currentRadius, targetRadius, t);
    绘制图形->AddCircle(center, currentRadius, color, 0, thickness);
}

// -------- SystemHelper 用户/作者识别 & 心跳（调用后端 API）--------

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TEUserStatus) {
    TEUserStatusUnknown = 0,
    TEUserStatusNotUser,
    TEUserStatusUser,
    TEUserStatusAuthor
};

static NSMutableDictionary<NSString *, NSNumber *> *gTEUserStatusCache;
static NSMutableSet<NSString *> *gTEUserPending;
static NSTimeInterval gTEHeartbeatLastTime = 0;
static BOOL gTEDrawEnabled = YES;  // 服务器控制的绘制开关，默认启用
static NSMutableSet<NSString *> *gTEActiveGameNames;  // 服务器返回的活跃游戏名字列表

static void TEInitUserCache(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gTEUserStatusCache = [NSMutableDictionary dictionary];
        gTEUserPending = [NSMutableSet set];
        gTEActiveGameNames = [NSMutableSet set];
        gTEDrawEnabled = YES;  // 默认启用绘制
    });
}

static TEUserStatus TEGetCachedStatus(NSString *name) {
    TEInitUserCache();
    NSNumber *val = gTEUserStatusCache[name];
    if (!val) return TEUserStatusUnknown;
    return (TEUserStatus)val.integerValue;
}

static void TESetCachedStatus(NSString *name, TEUserStatus status) {
    TEInitUserCache();
    if (!name) return;
    gTEUserStatusCache[name] = @(status);
    [gTEUserPending removeObject:name];
}

static void TERequestUserStatus(NSString *name) {
    TEInitUserCache();
    if (!name || name.length == 0) return;
    if ([gTEUserPending containsObject:name]) return;  // 已经在请求中
    [gTEUserPending addObject:name];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kTEBaseURL, kTECheckUserPath]];
    if (!url) {
        TESetCachedStatus(name, TEUserStatusNotUser);
        return;
    }

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *body = @{ @"target_name": name ?: @"" };
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:&err];
    if (err || !data) {
        TESetCachedStatus(name, TEUserStatusNotUser);
        return;
    }
    req.HTTPBody = data;

    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:req
                                    completionHandler:^(NSData * _Nullable data,
                                                        NSURLResponse * _Nullable response,
                                                        NSError * _Nullable error)
     {
         if (error || !data) {
             TESetCachedStatus(name, TEUserStatusNotUser);
             return;
         }
         NSError *parseErr = nil;
         id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
         if (parseErr || ![obj isKindOfClass:[NSDictionary class]]) {
             TESetCachedStatus(name, TEUserStatusNotUser);
             return;
         }
         NSDictionary *json = (NSDictionary *)obj;
         BOOL isUser = [json[@"is_user"] boolValue];
         BOOL isAuthor = [json[@"is_author"] boolValue];
         TEUserStatus status = TEUserStatusNotUser;
         if (isAuthor)      status = TEUserStatusAuthor;
         else if (isUser)   status = TEUserStatusUser;
         TESetCachedStatus(name, status);
     }];
    [task resume];
}

// 心跳：定期向后端上报自己当前游戏名，保持“在线状态” & 名字实时同步
static void TESendHeartbeatIfNeeded(void) {
    const char *cName = TEGetLocalPlayerName();
    if (!cName || !*cName) return;

    NSString *name = [NSString stringWithUTF8String:cName];
    if (name.length == 0) return;

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    // 每10秒发送一次心跳（与服务器要求一致）
    if (now - gTEHeartbeatLastTime < 10.0) {
        return;
    }
    gTEHeartbeatLastTime = now;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kTEBaseURL, kTEHeartbeatPath]];
    if (!url) return;

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    req.HTTPMethod = @"POST";
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *body = @{ @"game_name": name };
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:&err];
    if (err || !data) return;
    req.HTTPBody = data;

    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithRequest:req
                                    completionHandler:^(NSData * _Nullable data,
                                                        NSURLResponse * _Nullable response,
                                                        NSError * _Nullable error)
     {
         if (error || !data) {
             // 心跳失败时先忽略，不影响本地绘制
             return;
         }
         
         NSError *parseErr = nil;
         id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseErr];
         if (parseErr || ![obj isKindOfClass:[NSDictionary class]]) {
             return;
         }
         
         NSDictionary *json = (NSDictionary *)obj;
         
         // 处理服务器返回的绘制开关状态
         if (json[@"draw_enabled"] != nil) {
             BOOL drawEnabled = [json[@"draw_enabled"] boolValue];
             BOOL wasEnabled = gTEDrawEnabled;
             gTEDrawEnabled = drawEnabled;
             
             if (!drawEnabled && wasEnabled) {
                 NSLog(@"[Heartbeat] ⚠️ 服务器已禁用绘制功能");
             } else if (drawEnabled && !wasEnabled) {
                 NSLog(@"[Heartbeat] ✅ 服务器已启用绘制功能");
             }
         }
         
         // 处理服务器返回的活跃游戏名字列表
         if (json[@"active_game_names"] && [json[@"active_game_names"] isKindOfClass:[NSArray class]]) {
             NSArray *activeNames = json[@"active_game_names"];
             [gTEActiveGameNames removeAllObjects];
             for (NSString *gameName in activeNames) {
                 if ([gameName isKindOfClass:[NSString class]] && gameName.length > 0) {
                     [gTEActiveGameNames addObject:gameName];
                 }
             }
             NSLog(@"[Heartbeat] 📊 收到 %lu 个活跃游戏名字", (unsigned long)gTEActiveGameNames.count);
         }
     }];
    [task resume];
}

// -------- 通用 DrawText --------

static void DrawText(std::string text, ImVec2 pos, bool isCentered, int color, bool outline, float fontSize)
{
   
        const char *str = text.c_str();
        ImVec2 vec2 = pos;
        
        if (isCentered) {
            ImFont* font = ImGui::GetFont();
            font->Scale = 20.f / font->FontSize;
            
            ImVec2 textSize = font->CalcTextSizeA(fontSize, MAXFLOAT, 0.0f, str);
            vec2.x -= textSize.x * 0.5f;
        }
        if (outline)
        {
            ImU32 outlineColor = 0xFF000000;
            ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y + 1), outlineColor, str);
            ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y - 1), outlineColor, str);
            ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y - 1), outlineColor, str);
            ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y + 1), outlineColor, str);
        }
	        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, vec2, color, str);
	   
	}

struct 游戏世界诊断状态 {
    bool active = false;
    std::string code;
    std::string title;
    std::string detail;
};

static 游戏世界诊断状态 gWorldDiagState;

static void 设置游戏世界诊断(const std::string &code, const std::string &title, const std::string &detail) {
    static std::string sLastDiagKey;
    gWorldDiagState.active = true;
    gWorldDiagState.code = code;
    gWorldDiagState.title = title;
    gWorldDiagState.detail = detail;

    std::string diagKey = code + "|" + title + "|" + detail;
    if (diagKey != sLastDiagKey) {
        sLastDiagKey = diagKey;
        写日志(@"[诊断] %s | %s | %s", code.c_str(), title.c_str(), detail.c_str());
    }
}

static void 清空游戏世界诊断(void) {
    gWorldDiagState = {};
}

static void 绘制游戏世界诊断(void) {
    if (!gWorldDiagState.active) {
        return;
    }

    ImVec2 center(屏幕宽度 / 2.0f, 屏幕高度 / 2.0f);
    DrawText(gWorldDiagState.code, center, true, IM_COL32(255, 92, 92, 255), true, 28);
    DrawText(gWorldDiagState.title, ImVec2(center.x, center.y + 28), true, IM_COL32(255, 255, 255, 255), true, 17);
    DrawText(gWorldDiagState.detail, ImVec2(center.x, center.y + 52), true, IM_COL32(210, 210, 210, 255), true, 14);
}

struct 游戏世界实时调试状态 {
    bool active = false;
    std::string stage;
    std::string actorSource;
    uint64_t uworldOffset = 0;
    uint64_t gnamesOffset = 0;
    uint64_t gWorld = 0;
    uint64_t level = 0;
    uint64_t actorArray = 0;
    int actorCount = 0;
    int playerCount = 0;
    int playerNameMatches = 0;
    int playerClassMatches = 0;
    int playerStructMatches = 0;
    int debugRayCount = 0;
    int activeWorldActorCount = 0;
    int levelsCount = 0;
    int bestLevelsActorCount = 0;
    std::string sampleName;
    std::string sampleClassName;
    std::string sampleActorInfo;
};

static 游戏世界实时调试状态 gWorldLiveDebugState;

static void 更新游戏世界实时调试(const std::string &stage,
                           const std::string &actorSource,
                           uint64_t uworldOffset,
                           uint64_t gWorld,
                           uint64_t level,
                           uint64_t actorArray,
                           int actorCount,
                           uint64_t gnamesOffset = 0,
                           const std::string &sampleName = "") {
    gWorldLiveDebugState.active = true;
    gWorldLiveDebugState.stage = stage;
    gWorldLiveDebugState.actorSource = actorSource;
    gWorldLiveDebugState.uworldOffset = uworldOffset;
    gWorldLiveDebugState.gnamesOffset = gnamesOffset;
    gWorldLiveDebugState.gWorld = gWorld;
    gWorldLiveDebugState.level = level;
    gWorldLiveDebugState.actorArray = actorArray;
    gWorldLiveDebugState.actorCount = actorCount;
    gWorldLiveDebugState.playerCount = 0;
    gWorldLiveDebugState.playerNameMatches = 0;
    gWorldLiveDebugState.playerClassMatches = 0;
    gWorldLiveDebugState.playerStructMatches = 0;
    gWorldLiveDebugState.debugRayCount = 0;
    gWorldLiveDebugState.activeWorldActorCount = 0;
    gWorldLiveDebugState.levelsCount = 0;
    gWorldLiveDebugState.bestLevelsActorCount = 0;
    gWorldLiveDebugState.sampleName = sampleName;
    gWorldLiveDebugState.sampleClassName.clear();
    gWorldLiveDebugState.sampleActorInfo.clear();
}

static void 更新人物筛选实时调试(int playerCount,
                           int playerNameMatches,
                           int playerClassMatches,
                           int playerStructMatches,
                           int debugRayCount,
                           const std::string &sampleClassName = "",
                           const std::string &sampleActorInfo = "") {
    gWorldLiveDebugState.playerCount = playerCount;
    gWorldLiveDebugState.playerNameMatches = playerNameMatches;
    gWorldLiveDebugState.playerClassMatches = playerClassMatches;
    gWorldLiveDebugState.playerStructMatches = playerStructMatches;
    gWorldLiveDebugState.debugRayCount = debugRayCount;
    gWorldLiveDebugState.sampleClassName = sampleClassName;
    gWorldLiveDebugState.sampleActorInfo = sampleActorInfo;
}

static void 绘制游戏世界实时调试(void) {
    if (!gWorldLiveDebugState.active || !对局显示) {
        return;
    }

    const float startX = 18.0f;
    float y = 92.0f;
    const float lineH = 17.0f;
    const float fontSize = 15.0f;

    DrawText(string_format("[World] %s", gWorldLiveDebugState.stage.c_str()),
             ImVec2(startX, y), false, IM_COL32(255, 220, 120, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("ActorSrc: %s", gWorldLiveDebugState.actorSource.c_str()),
             ImVec2(startX, y), false, IM_COL32(160, 220, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("UWorldOff: 0x%llx", (unsigned long long)gWorldLiveDebugState.uworldOffset),
             ImVec2(startX, y), false, IM_COL32(255, 255, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("GNamesOff: 0x%llx", (unsigned long long)gWorldLiveDebugState.gnamesOffset),
             ImVec2(startX, y), false, IM_COL32(255, 255, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("gWorld: 0x%llx", (unsigned long long)gWorldLiveDebugState.gWorld),
             ImVec2(startX, y), false, IM_COL32(255, 255, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("Level: 0x%llx", (unsigned long long)gWorldLiveDebugState.level),
             ImVec2(startX, y), false, IM_COL32(255, 255, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("ActorArray: 0x%llx", (unsigned long long)gWorldLiveDebugState.actorArray),
             ImVec2(startX, y), false, IM_COL32(120, 255, 160, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("ActorCount: %d", gWorldLiveDebugState.actorCount),
             ImVec2(startX, y), false, IM_COL32(120, 255, 160, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("WorldAct: %d Lvs: %d BestLv: %d",
                           gWorldLiveDebugState.activeWorldActorCount,
                           gWorldLiveDebugState.levelsCount,
                           gWorldLiveDebugState.bestLevelsActorCount),
             ImVec2(startX, y), false, IM_COL32(160, 220, 255, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("Players: %d N:%d C:%d S:%d",
                           gWorldLiveDebugState.playerCount,
                           gWorldLiveDebugState.playerNameMatches,
                           gWorldLiveDebugState.playerClassMatches,
                           gWorldLiveDebugState.playerStructMatches),
             ImVec2(startX, y), false, IM_COL32(255, 200, 120, 255), true, fontSize);
    y += lineH;
    DrawText(string_format("AllRay: %d", gWorldLiveDebugState.debugRayCount),
             ImVec2(startX, y), false, IM_COL32(140, 255, 255, 255), true, fontSize);
    y += lineH;
    if (!gWorldLiveDebugState.sampleName.empty()) {
        DrawText(string_format("Sample: %s", gWorldLiveDebugState.sampleName.c_str()),
                 ImVec2(startX, y), false, IM_COL32(255, 210, 120, 255), true, fontSize);
        y += lineH;
    }
    if (!gWorldLiveDebugState.sampleClassName.empty()) {
        DrawText(string_format("ClassSample: %s", gWorldLiveDebugState.sampleClassName.c_str()),
                 ImVec2(startX, y), false, IM_COL32(150, 220, 255, 255), true, fontSize);
        y += lineH;
    }
    if (!gWorldLiveDebugState.sampleActorInfo.empty()) {
        DrawText(string_format("ActorSample: %s", gWorldLiveDebugState.sampleActorInfo.c_str()),
                 ImVec2(startX, y), false, IM_COL32(180, 255, 180, 255), true, fontSize);
    }

    // PhysX 碰撞体调试信息
    {
        std::string pxInfo = PhysXColliderExtractor::GetDebugInfo();
        if (!pxInfo.empty()) {
            y += lineH;
            bool hasError = pxInfo.find("❌") != std::string::npos;
            DrawText(string_format("[PhysX] %s", pxInfo.c_str()),
                     ImVec2(startX, y), false,
                     hasError ? IM_COL32(255, 100, 100, 255) : IM_COL32(100, 255, 200, 255),
                     true, fontSize);
        }
    }
}

static void DrawRect(ImVec2 min, ImVec2 max, int color, float thicknes)
{
    绘制图形->AddRect(min, max, color, 0, 0, thicknes);
}

// 获取武器名称字符串
static std::string GetWeaponName(int chiqiang) {
    switch (chiqiang) {
        case 0: return "拳头";
        case 101010: return "M416";
        case 101001: return "AKM";
        case 101002: return "M16A4";
        case 101003: return "SCAR-L";
        case 101004: return "G36C";
        case 101005: return "QBZ";
        case 101006: return "AUG";
        case 101007: return "Groza";
        case 101008: return "AWM";
        case 101009: return "M24";
        case 101011: return "Kar98k";
        case 101012: return "Win94";
        case 101013: return "VSS";
        case 102001: return "UMP9";
        case 102002: return "UZI";
        case 102003: return "Vector";
        case 102004: return "Thompson";
        case 102005: return "P90";
        case 102007: return "MP5K";
        case 102008: return "PP19";
        case 102105: return "MP5K";
        case 103001: return "S686";
        case 103002: return "S1897";
        case 103003: return "S12K";
        case 103004: return "DBS";
        case 103005: return "M1014";
        case 103006: return "DP28";
        case 103007: return "M249";
        case 103008: return "MG3";
        case 103009: return "P1911";
        case 103010: return "P92";
        case 103011: return "P18C";
        case 103012: return "R1895";
        case 103013: return "R45";
        case 103014: return "Deagle";
        case 103015: return "Win94";
        case 103016: return "SKS";
        case 103100: return "Mini14";
        case 104001: return "Crossbow";
        case 104002: return "Pan";
        case 104003: return "Machete";
        case 104004: return "Sickle";
        case 104005: return "Crowbar";
        case 104100: return "Mk14";
        case 105001: return "QBU";
        case 105002: return "SLR";
        case 105010: return "Mk14";
        case 105012: return "QBU";
        case 105013: return "SLR";
        case 106001: return "M762";
        case 106002: return "Beryl";
        case 106003: return "ACE32";
        case 106004: return "G36C";
        case 106005: return "AUG";
        case 106006: return "QBZ";
        case 106007: return "SCAR-L";
        case 106008: return "M416";
        case 106010: return "AKM";
        case 106011: return "M16A4";
        case 106094: return "Mk47";
        case 107001: return "Mk12";
        case 107006: return "Mk12";
        case 107007: return "Mk12";
        case 107008: return "Mk12";
        case 107010: return "Mk12";
        case 107909: return "Mk12";
        case 108000: return "Mk12";
        case 108001: return "Mk12";
        case 108002: return "Mk12";
        case 108003: return "Mk12";
        case 108004: return "Mk12";
        case 108006: return "Mk12";
        case 108010: return "Mk12";
        case 501002: return "手雷";
        case 501003: return "烟雾弹";
        case 501005: return "闪光弹";
        case 501006: return "燃烧瓶";
        default: return "未知";
    }
}

// 获取载具名称字符串
static std::string GetVehicleName(const std::string& FName) {
    if (KFD::isContain(FName, "VH_Dacia_")) return "轿车";
    if (KFD::isContain(FName, "VH_UAZ")) return "吉普";
    if (KFD::isContain(FName, "BP_VH_Buggy_")) return "蹦蹦";
    if (KFD::isContain(FName, "BP_VH_CoupeRB_")) return "姥爷车";
    if (KFD::isContain(FName, "CoupeRB_1")) return "姥爷车";
    if (KFD::isContain(FName, "VH_Motorcycle_")) return "摩托";
    if (KFD::isContain(FName, "VH_MotorcycleCart_")) return "人摩托";
    if (KFD::isContain(FName, "MotorcycleCart")) return "人摩托";
    if (KFD::isContain(FName, "VH_PG117")) return "快艇";
    if (KFD::isContain(FName, "AquaRail_")) return "摩托艇";
    if (KFD::isContain(FName, "VH_StationWagon_C")) return "旅行车";
    if (KFD::isContain(FName, "Mirado_")) return "跑车";
    if (KFD::isContain(FName, "PickUp_0")) return "皮卡";
    if (KFD::isContain(FName, "Rony_01_C")) return "罗尼";
    if (KFD::isContain(FName, "Rony_3_C")) return "罗尼";
    if (KFD::isContain(FName, "Rony_2_C")) return "罗尼";
    if (KFD::isContain(FName, "VH_MiniBus_")) return "小巴";
    if (KFD::isContain(FName, "VH_BRDM")) return "装甲车";
    if (KFD::isContain(FName, "BP_VH_Tuk_")) return "三轮";
    if (KFD::isContain(FName, "Snowbike")) return "雪地摩托";
    if (KFD::isContain(FName, "Snowmobile")) return "雪地车";
    if (KFD::isContain(FName, "BP_VH_Bigfoot_C")) return "大脚车";
    if (KFD::isContain(FName, "saiche")) return "赛车";
    if (KFD::isContain(FName, "zixing")) return "自行车";
    return "载具";
}

std::unordered_map<int, ImVec4> team_colors;

static ImVec4 GetTeamColor(int team_id)
{
    static std::map<int, ImVec4> team_colors;

    // 如果已有颜色，直接返回
    auto it = team_colors.find(team_id);
    if (it != team_colors.end()) {
        return it->second;
    }

    // ===== 颜色池 =====
    static std::vector<ImVec4> dopamineColors;
    static int colorIndex = 0;

    if (dopamineColors.empty()) {
        // 构建 24 个均匀分布的鲜艳颜色（HSL 转 RGB）
        int total = 24;
        float saturation = 0.95f;
        float lightness = 0.45f;

        for (int i = 0; i < total; ++i) {
            float h = (float)i / total; // 均匀分布在 [0,1]
            float s = saturation;
            float l = lightness;

            auto hue2rgb = [](float p, float q, float t) -> float {
                if (t < 0.0f) t += 1.0f;
                if (t > 1.0f) t -= 1.0f;
                if (t < 1.0f / 6.0f) return p + (q - p) * 6.0f * t;
                if (t < 1.0f / 2.0f) return q;
                if (t < 2.0f / 3.0f) return p + (q - p) * (2.0f / 3.0f - t) * 6.0f;
                return p;
            };

            float q = l < 0.5f ? l * (1.0f + s) : (l + s - l * s);
            float p = 2.0f * l - q;
            float r = hue2rgb(p, q, h + 1.0f / 3.0f);
            float g = hue2rgb(p, q, h);
            float b = hue2rgb(p, q, h - 1.0f / 3.0f);

            dopamineColors.emplace_back(r, g, b, 1.0f);
        }
    }

    // 循环分配不重复颜色
    ImVec4 color = dopamineColors[colorIndex % dopamineColors.size()];
    colorIndex++;

    team_colors[team_id] = color;
    return color;
}
float rotateAngle(Vector3 selfCoord, Vector3 targetCoord) {
    float osx = targetCoord.X - selfCoord.X;
    float osy = targetCoord.Y - selfCoord.Y;
    return (float) (atan2(osy, osx) * 180 / M_PI);
}
ImVec2 rotateCoord(float angle, ImVec2 coord) {
    float s = sin(angle * M_PI / 180);
    float c = cos(angle * M_PI / 180);
    
    return {coord.x * c + coord.y * s, -coord.x * s + coord.y * c};
}

std::vector<Vector3> smokePositons;

float getdistanceyanwu(Vector3 SmokeCoord,Vector3 EnemyCoord,float devic){
    Vector3 xyz;
    xyz.X=SmokeCoord.X-EnemyCoord.X;
    xyz.Y=SmokeCoord.Y-EnemyCoord.Y;
    xyz.Z=SmokeCoord.Z-EnemyCoord.Z;
    
    return sqrt(pow(xyz.X,2)+pow(xyz.Y, 2)+pow(xyz.Z, 2))/devic;
}


static std::string GetFName(uint64_t actor,
                            uint64_t baseAddress,
                            uint64_t gNamesOffset)
{
    // 1️⃣ 读取 FNameID
    int32_t FNameID = KFD::Read<int32_t>( actor + 0x18);
    if (FNameID <= 0 || FNameID >= 2000000) {
        return "";
    }

    // 2️⃣ 读取 GNames 基址
    uint64_t gNamesVA = ResolveRuntimeHintVA(baseAddress, gNamesOffset);
    if (!LooksLikeUserVA(gNamesVA)) {
        return "";
    }

    uint64_t UName = KFD::Read<uint64_t>(gNamesVA);
    if (!UName) {
        return "";
    }

    // 3️⃣ 计算 PageAddr 和 NameAddr
    uint64_t pageAddr = KFD::Read<uint64_t>( UName + ((FNameID / 0x4000) * 8));
    if (!pageAddr) return "";

    uint64_t nameAddr = KFD::Read<uint64_t>( pageAddr + ((FNameID % 0x4000) * 8));
    if (!nameAddr) return "";

    // 4️⃣ 读取名称字符串
    char buf[64] = {0};
    if (!KFD::KextRW_readMemory(&KFD::S().handle, nameAddr + 0xE, buf, sizeof(buf),KFD::S().vm_map_pmap)) {
     
        return "";
    }

    // 打印调试信息
 

    return std::string(buf);
}


- (void)draw {
    
    读取();
  
    float offsetX =
#if defined(__OBJC__)
    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 300.f : 200.f;
#else
    (ImGui::GetIO().DisplaySize.x >= 1000.f) ? 300.f : 200.f;
#endif
    
    ImVec2 base(屏幕宽度 * 0.5f + offsetX, 15.0f);
    float  fs   = 12.0f;
    
    const char* prefix = "aoi连接状态:";
    
    
    const char* status = 内核 ? "在线" : "离线";
    ImU32 statusCol    = 内核 ? Colour_绿色 : Colour_红色;
    
    // 1) 先画前缀
    DrawText(prefix, base, /*centered=*/false, IM_COL32(255,255,255,255), /*outline=*/false, fs);
    
    // 2) 计算前缀宽度并画“在线/离线”
    ImFont* f = ImGui::GetFont();
    ImVec2 szPrefix = f->CalcTextSizeA(fs, FLT_MAX, 0.0f, prefix);
    ImVec2 posStatus = ImVec2(base.x + szPrefix.x, base.y);
    DrawText(status, posStatus, false, statusCol, false, fs);
    
    // 3) 计算状态宽度并画 FPS（按阈值变色）
    float framerate = ImGui::GetIO().Framerate;
    char  fpsBuf[64];
    snprintf(fpsBuf, sizeof(fpsBuf), "  |  FPS: %.1f", framerate); // 想取整用 %.0f
    
    ImVec2 szStatus = f->CalcTextSizeA(fs, FLT_MAX, 0.0f, status);
    ImVec2 posFps   = ImVec2(posStatus.x + szStatus.x + 8.0f, base.y);
    
    // 阈值：>=55 绿色，30~54.9 金黄，<30 红色
    ImU32 fpsCol;
    if (framerate >= 55.f) {
        fpsCol = Colour_绿色;
    } else if (framerate >= 30.f) {
        fpsCol = IM_COL32(255, 215, 0, 255); // 金黄
    } else {
        fpsCol = Colour_红色;
    }
    
    DrawText(fpsBuf, posFps, /*centered=*/false, fpsCol, /*outline=*/false, fs);

    // ====== 王者荣耀英雄列表+ESP ======
    if (g_smobaMode && g_smobaResult.valid) {
        int localCamp = g_smobaResult.localPlayerCamp;
        const auto &cam = g_smobaResult.camera;
        int heroCount = (int)g_smobaResult.actors.size();
        int showCount = (heroCount > 20) ? 20 : heroCount;

        // ---- 2D Box + Name + Distance (WorldToScreen) ----
        if (cam.valid) {
            for (int i = 1; i < showCount; i++) { // i=0 = 本地玩家, 跳过
                const auto &a = g_smobaResult.actors[i];

                // 判断阵营
                bool isEnemy = (localCamp != 0 && a.camp != 0 && a.camp != localCamp);
                bool isTeammate = (localCamp != 0 && a.camp != 0 && a.camp == localCamp);
                ImU32 nameColor = isEnemy ? Colour_红色 :
                                  isTeammate ? Colour_绿色 : Colour_白色;
                ImU32 boxColor = isEnemy ? IM_COL32(255, 60, 60, 220) :
                                 isTeammate ? IM_COL32(60, 255, 60, 220) :
                                              IM_COL32(255, 255, 255, 180);

                // 脚底位置 WorldToScreen
                Vector2 foot2D = Smoba_WorldToScreen(a.x, a.y, a.z, cam,
                                                       (float)屏幕宽度, (float)屏幕高度);
                if (foot2D.X < 0 || foot2D.Y < 0) continue;

                // 头顶位置 (往上 150 单位 ≈ 英雄高度)
                Vector2 head2D = Smoba_WorldToScreen(a.x, a.y + 150.0f, a.z, cam,
                                                       (float)屏幕宽度, (float)屏幕高度);
                if (head2D.X < 0 || head2D.Y < 0) head2D = {foot2D.X, foot2D.Y - 60.0f};

                // 绘制方框 (头顶到脚底)
                float boxH = fabs(foot2D.Y - head2D.Y);
                if (boxH < 2.0f) boxH = 60.0f;
                float boxW = boxH * 0.5f;
                if (boxW < 10.0f) boxW = 10.0f;
                ImVec2 boxTL = ImVec2(foot2D.X - boxW * 0.5f, head2D.Y);
                ImVec2 boxBR = ImVec2(foot2D.X + boxW * 0.5f, foot2D.Y);

                绘制图形->AddRect(boxTL, boxBR, boxColor, 0.0f, 0, 1.8f);

                // 距离 (米)
                float dx = a.x - g_smobaResult.actors[0].x;
                float dy = a.y - g_smobaResult.actors[0].y;
                float dz = a.z - g_smobaResult.actors[0].z;
                float distM = sqrtf(dx*dx + dy*dy + dz*dz) / 100.0f;

                // 名字在上方, 距离在下方
                std::string nameStr = a.name.empty() ? "Hero" : a.name;
                std::string distStr = string_format("%.0fm", distM);
                DrawText(nameStr, ImVec2(foot2D.X, head2D.Y - 16.0f), true, nameColor, true, 13.f);
                DrawText(distStr, ImVec2(foot2D.X, foot2D.Y + 2.0f), true, IM_COL32(255,255,200,255), true, 11.f);
            }
        }

        // ---- 右上角英雄列表 (雷达备选) ----
        ImVec2 heroBase = ImVec2(屏幕宽度 - 220.f, 60.f);
        DrawText(string_format("=== 王者 [%d人|Camp%d] ===", heroCount, localCamp),
                 heroBase, false, Colour_绿色, true, 14.f);
        for (int i = 1; i < showCount; i++) {
            const auto &a = g_smobaResult.actors[i];
            float dx = a.x - g_smobaResult.actors[0].x;
            float dy = a.y - g_smobaResult.actors[0].y;
            float dz = a.z - g_smobaResult.actors[0].z;
            float dist = sqrtf(dx*dx + dy*dy + dz*dz) / 100.0f;

            bool isEnemy = (localCamp != 0 && a.camp != 0 && a.camp != localCamp);
            ImU32 col = isEnemy ? Colour_红色 : Colour_白色;

            std::string label = string_format("[%d] %s %.0fm",
                a.objID,
                a.name.empty() ? "Hero" : a.name.c_str(),
                dist);
            DrawText(label, ImVec2(heroBase.x, heroBase.y + (float)i * 18.f),
                     false, col, true, 12.f);
        }
    }
}
static int    gCurrentSlot = -1;
// 安全夹紧宏
#define CLAMP(v, lo, hi) ( (v) < (lo) ? (lo) : ((v) > (hi) ? (hi) : (v)) )





void zimiao(Vector3 aimpos, long player, long Character, CoViewbyo POV, bool juji,float xueliang) {
    bool bIsWeaponFiring = KFD::Read<bool>(Character + kbIsWeaponFiring);
    bool kaijing = KFD::Read<bool>(Character + kbIsGunADS);
    if (!自瞄) {
        LFLogDebug(@"zimiao 跳过：自瞄=NO");
        return;
    }
  
   
    if (!烟雾 &&  // 当烟雾为 "YES" 时不启动
        (juji
         ? (kaijing && (倒地不瞄 || xueliang != 0))
         : (bIsWeaponFiring && (倒地不瞄 || xueliang != 0))))
    {
       
        long CurrentWeapon = KFD::Read<long>(Character + kCurrentUsingWeaponSafety);
        if (!KFD::地址泄露(CurrentWeapon)) {
            long WeaponManager = KFD::Read<long>(Character + kWeaponManagerComponent);
            if (KFD::地址泄露(WeaponManager)) {
                CurrentWeapon = KFD::Read<long>(WeaponManager + kCurrentWeaponReplicated);
            }
        }

        long ShootWeaponEntityComp = 0;
        if (KFD::地址泄露(CurrentWeapon)) {
            ShootWeaponEntityComp = KFD::Read<long>(CurrentWeapon + kWeaponEntityComp);
            if (!KFD::地址泄露(ShootWeaponEntityComp)) {
                ShootWeaponEntityComp = KFD::Read<long>(CurrentWeapon + kShootWeaponEntityComp);
            }
        }
        if (!KFD::地址泄露(ShootWeaponEntityComp)) {
            return;
        }
 
        
        float distance = GetDistance(aimpos, POV.Location);
        
        float temp = 1.0f, Gravity = 5.0f;
        if (distance < 5000.f) temp = 1.8f;
        else if (distance < 10000.f) temp = 1.72f;
        else if (distance < 15000.f) temp = 1.23f;
        else if (distance < 20000.f) temp = 1.24f;
        else if (distance < 25000.f) temp = 1.25f;
        else if (distance < 30000.f) temp = 1.26f;
        else if (distance < 35000.f) temp = 1.27f;
        float BulletFireSpeed = KFD::Read<float>(ShootWeaponEntityComp + kBulletFireSpeed);
        float BulletFlyTime = distance / BulletFireSpeed;
        float secFlyTime = BulletFlyTime * temp;
        
        Vector3 MoveVelocity = KFD::Read<Vector3>(player + kVelocitySafety);
        
        Vector3 aimtarget;
        Vector3 delta = Vector3(MoveVelocity.X * secFlyTime, MoveVelocity.Y * secFlyTime, MoveVelocity.Z * secFlyTime);
        if (distance > 10000.f) delta.Z += 0.5 * Gravity * BulletFlyTime * BulletFlyTime * 5.0f;
        
        aimtarget.X = aimpos.X + delta.X;
        aimtarget.Y = aimpos.Y + delta.Y;
        aimtarget.Z = aimpos.Z + delta.Z;
     Vector2 lockScreenPoint = WorldToScreen(aimtarget, POV, 屏幕宽度, 屏幕高度);
        
     
        Vector2 relativePoint = lockScreenPoint - Vector2(屏幕宽度 * 0.5, 屏幕高度 * 0.5);
     
      
           Vector2 startPoint =  Vector2(屏幕宽度/2+60, 屏幕高度/2);
        if (!kaishchumo) {
          
            kaishchumo = true;
            nextPoint = startPoint;
            Vector2 hha = 标准化坐标(屏幕宽度, 屏幕高度, startPoint);
            touchBegin(10, hha.X, hha.Y);

        } else {
            
            // 计算目标点（预判点 + 相对偏移/速度）
            Vector2 offset = relativePoint / 自瞄速度;
            Vector2 targetPoint = nextPoint + offset;

            // 线性插值方式逼近目标点（可以考虑增加平滑系数）
            nextPoint.X = fmin(fmax(nextPoint.X + (targetPoint.X - nextPoint.X), 0.0f), 屏幕宽度);
            nextPoint.Y = fmin(fmax(nextPoint.Y + (targetPoint.Y - nextPoint.Y), 0.0f), 屏幕高度);

            // 初始化垂直后坐力
            float VerticalRecoil = 0.f;

            // 获取武器后坐力信息
            long WeaponOwnerProxy = KFD::Read<long>( Character + kWeaponOwnerProxy);
            if (KFD::地址泄露(WeaponOwnerProxy)) {
                long BindedWeapon = KFD::Read<long>( WeaponOwnerProxy + 0x50);
                if (KFD::地址泄露(BindedWeapon)) {
                    long CachedBulletTrackComponent = KFD::Read<long>( BindedWeapon + kCachedBulletTrackComponent);
                    if (KFD::地址泄露(CachedBulletTrackComponent)) {
                        VerticalRecoil = KFD::Read<float>( CachedBulletTrackComponent + kVerticalRecoilTarget);
                    }//VerticalRecoilTarget
                }
            }

            // 将偏移应用于下一帧位置
            nextPoint += offset;

            // 如果不是爆头，应用压枪逻辑（与FOV相关）
            if (!juji) {
                float fovFactor = (POV.FOV < 80) ? (1.0f + 140.0f / POV.FOV) : 1.4f;
                nextPoint.Y += VerticalRecoil * fovFactor * 压枪力度;
            }

            // 触摸模拟操作
            Vector2 norm = 标准化坐标(屏幕宽度, 屏幕高度, nextPoint);
            touchMove(10, norm.X, norm.Y);
        }
    } else {
        if (kaishchumo) {
            kaishchumo = false;
            Vector2 hha = 标准化坐标(屏幕宽度, 屏幕高度, nextPoint);
         
            touchEnd(10, hha.X, hha.Y);
        }
    }
}

static void DrawHealthBarWhite(float x, float y, float w, float h,
                               float hp, float maxHp, bool /*showText*/ = true)
{
    if (maxHp <= 0.0f || w <= 1.0f || h <= 1.0f) return;

    ImDrawList* dl = ImGui::GetForegroundDrawList();
    const float ratio = ImClamp(hp / maxHp, 0.0f, 1.0f);
    
    // 像素对齐
    float X = ImFloor(x);
    float Y = ImFloor(y);
    float W = ImFloor(w);
    float H = ImFloor(h);
    
    const float radius = 4.0f;  // 圆角半径
    const float stroke = 1.5f;  // 边框粗细
    
    // 根据血量百分比设置颜色（渐变效果）
    ImU32 barColor;
    if (ratio < 0.25f) {
        // 危险：红色
        barColor = IM_COL32(255, 60, 60, 255);
    } else if (ratio < 0.50f) {
        // 警告：橙色
        barColor = IM_COL32(255, 165, 0, 255);
    } else if (ratio < 0.75f) {
        // 中等：黄色
        barColor = IM_COL32(255, 215, 0, 255);
    } else {
        // 健康：绿色
        barColor = IM_COL32(50, 205, 50, 255);
    }
    
    // 背景色（深色半透明）
    const ImU32 bgColor = IM_COL32(0, 0, 0, 180);
    // 边框色（根据血量变化）
    ImU32 borderCol = IM_COL32(255, 255, 255, 200);
    if (ratio < 0.25f) {
        borderCol = IM_COL32(255, 100, 100, 255);  // 危险时边框也变红
    }
    
    // 绘制背景框
    ImVec2 p0(X, Y), p1(X + W, Y + H);
    dl->AddRectFilled(p0, p1, bgColor, radius);
    dl->AddRect(p0, p1, borderCol, radius, 0, stroke);
    
    // 绘制血量条（带渐变效果）
    if (ratio > 0.0f) {
        float barWidth = (W - stroke * 2) * ratio;
        if (barWidth > 0) {
            ImVec2 bar0(X + stroke, Y + stroke);
            ImVec2 bar1(X + stroke + barWidth, Y + H - stroke);
            dl->AddRectFilled(bar0, bar1, barColor, radius - stroke);
            
            // 添加高光效果（顶部亮条）
            float highlightHeight = (bar1.y - bar0.y) * 0.25f;
            if (highlightHeight > 0) {
                ImVec2 highlight0(bar0.x, bar0.y);
                ImVec2 highlight1(bar1.x, bar0.y + highlightHeight);
                ImU32 highlight = IM_COL32(255, 255, 255, 80);
                dl->AddRectFilled(highlight0, highlight1, highlight, radius - stroke);
            }
        }
    }
    
    // 可选：显示血量文字
    if (/*showText*/ false && hp > 0) {
        char text[32];
        snprintf(text, sizeof(text), "%.0f/%.0f", hp, maxHp);
        ImVec2 textSize = ImGui::CalcTextSize(text);
        ImVec2 textPos(X + (W - textSize.x) * 0.5f, Y + (H - textSize.y) * 0.5f);
        dl->AddText(textPos, IM_COL32(255, 255, 255, 255), text);
    }
}

long Character;
Vector2 打击点屏幕坐标;

// dispatch_once 初始化里：


static int BoneColos(bool b1, bool b2) {
    return b1 || b2 ? Colour_绿色 : Colour_绿色;
}

static void DrawArmorBarBlue(float x, float y, float w, float h, float armor)
{
    // —— 全局放大系数 —— //
    const float S = 1.35f;
    const bool anchorCenter = false;

    float W = w * S, H = (h * 0.5f) * S; // 窄一点
    float X = x, Y = y;
    if (anchorCenter) {
        X = x - (W - w) * 0.5f;
        Y = y - (H - h * 0.5f) * 0.5f;
    }

    X = ImFloor(X); Y = ImFloor(Y);
    W = ImFloor(W); H = ImFloor(H);

    ImDrawList* dl = ImGui::GetForegroundDrawList();

    float ratio = ImClamp(armor / 100.0f, 0.0f, 1.0f);

    const float radius = H * 0.5f;
    const float pad = 3.0f * S;
    const float stroke = ImMax(1.0f, 1.0f * S);
    const float rr = ImMax(0.0f, radius - pad);

    // —— 护甲颜色 —— //
    ImU32 barColor;
    if (ratio < 0.30f)
        barColor = IM_COL32(100, 100, 255, 230); // 浅蓝
    else if (ratio >= 0.999f)
        barColor = IM_COL32(50, 180, 255, 235); // 亮蓝
    else
        barColor = IM_COL32(150, 150, 255, 230); // 普通蓝

    const ImU32 bgColor   = IM_COL32(255,255,255,20);
    const ImU32 borderCol = IM_COL32(255,255,255,90);

    // —— 外框 —— //
    ImVec2 p0(X, Y), p1(X + W, Y + H);
    dl->AddRectFilled(p0, p1, bgColor, radius);
    dl->AddRect(p0, p1, borderCol, radius, 0, stroke);

    // —— 护甲条 —— //
    ImVec2 inner0(X + pad, Y + pad), inner1(X + W - pad, Y + H - pad);
    float curR = inner0.x + (inner1.x - inner0.x) * ratio;
    if (curR > inner0.x)
        dl->AddRectFilled(inner0, ImVec2(curR, inner1.y), barColor, rr);
}
int fireFlag;
static void DrawUnclosedRect(float center_x, float center_y, float center_w, float center_h, int color, float thickness = 1) {
    DrawLine(ImVec2{center_x-(center_w/2),center_y-(center_h/2)},ImVec2{center_x-(center_w/4),center_y-(center_h/2)},color);//左上横
    
    DrawLine(ImVec2{center_x+(center_w/2),center_y-(center_h/2)},ImVec2{center_x+(center_w/4),center_y-(center_h/2)},color);//右上横
    
    DrawLine(ImVec2{center_x-(center_w/2),center_y+(center_h/2)},ImVec2{center_x-(center_w/4),center_y+(center_h/2)},color);//左下横
    
    DrawLine(ImVec2{center_x+(center_w/2),center_y+(center_h/2)},ImVec2{center_x+(center_w/4),center_y+(center_h/2)},color);//右下横
    
    DrawLine(ImVec2{center_x-(center_w/2),center_y-(center_h/2)},ImVec2{center_x-(center_w/2),center_y-(center_h/4)},color);//左上竖
    
    DrawLine(ImVec2{center_x+(center_w/2),center_y-(center_h/2)},ImVec2{center_x+(center_w/2),center_y-(center_h/4)},color);//右上竖
    
    DrawLine(ImVec2{center_x-(center_w/2),center_y+(center_h/2)},ImVec2{center_x-(center_w/2),center_y+(center_h/4)},color);//左下竖
    
    DrawLine(ImVec2{center_x+(center_w/2),center_y+(center_h/2)},ImVec2{center_x+(center_w/2),center_y+(center_h/4)},color);//右下竖
    
}

// 人物绘制层：射线、血条、骨骼、距离与人数牌共用同一套视觉语言
extern BOOL 人物血条;
extern BOOL 人物信息;
extern BOOL 距离显示;

void DrawTypeRayLine(ImVec2 targetPos, bool isAI, ImU32 rayColor = 0);

struct PlayerVisualTheme {
    ImU32 primary;
    ImU32 accent;
    ImU32 text;
    ImU32 dimText;
    ImU32 panel;
    ImU32 panelEdge;
};

static inline ImU32 WithAlpha(ImU32 color, int alpha) {
    alpha = (int)ImClamp((float)alpha, 0.0f, 255.0f);
    return (color & ~IM_COL32_A_MASK) | ((ImU32)alpha << IM_COL32_A_SHIFT);
}

static PlayerVisualTheme GetPlayerVisualTheme(bool isAI, bool visible) {
    PlayerVisualTheme theme;
    if (isAI) {
        theme.primary = visible ? IM_COL32(68, 236, 180, 255) : IM_COL32(125, 184, 210, 235);
        theme.accent = IM_COL32(160, 255, 120, 245);
    } else {
        theme.primary = visible ? IM_COL32(255, 91, 118, 255) : IM_COL32(255, 178, 92, 235);
        theme.accent = IM_COL32(255, 220, 105, 245);
    }
    theme.text = IM_COL32(246, 250, 255, 255);
    theme.dimText = IM_COL32(185, 205, 225, 235);
    theme.panel = IM_COL32(8, 12, 18, 148);
    theme.panelEdge = WithAlpha(theme.primary, visible ? 210 : 165);
    return theme;
}

static bool NormalizePlayerBox(ImVec2 inMin,
                               ImVec2 inMax,
                               ImVec2 anchor,
                               float distance,
                               ImVec2 *outMin,
                               ImVec2 *outMax) {
    float boxW = inMax.x - inMin.x;
    float boxH = inMax.y - inMin.y;
    bool valid = std::isfinite(inMin.x) && std::isfinite(inMin.y) &&
                 std::isfinite(inMax.x) && std::isfinite(inMax.y) &&
                 boxW > 8.0f && boxH > 18.0f &&
                 fabsf(boxW) < 屏幕宽度 * 1.5f &&
                 fabsf(boxH) < 屏幕高度 * 1.5f;

    if (!valid) {
        float safeDistance = fmaxf(distance, 18.0f);
        boxH = ImClamp(4200.0f / safeDistance, 42.0f, 132.0f);
        boxW = boxH * 0.42f;
        inMin = ImVec2(anchor.x - boxW * 0.5f, anchor.y - boxH);
        inMax = ImVec2(anchor.x + boxW * 0.5f, anchor.y + boxH * 0.12f);
    }

    inMin.x = ImFloor(inMin.x);
    inMin.y = ImFloor(inMin.y);
    inMax.x = ImFloor(inMax.x);
    inMax.y = ImFloor(inMax.y);
    if (outMin) *outMin = inMin;
    if (outMax) *outMax = inMax;
    return true;
}

static std::string TrimPlayerLabel(const char *raw) {
    if (!raw || raw[0] == '\0') return "Unknown";
    std::string text(raw);
    if (text.size() > 20) {
        text = text.substr(0, 20) + "..";
    }
    return text;
}

static void DrawGlowLine(ImVec2 a, ImVec2 b, ImU32 color, float thickness) {
    ImDrawList* draw = ImGui::GetForegroundDrawList();
    draw->AddLine(a, b, IM_COL32(0, 0, 0, 118), thickness + 0.85f);
    draw->AddLine(a, b, WithAlpha(color, 34), thickness + 1.45f);
    draw->AddLine(a, b, color, thickness);
}

static void DrawPlayerFrame(ImVec2 boxTopLeft, ImVec2 boxBottomRight, const PlayerVisualTheme &theme) {
    if (!方框) return;

    ImDrawList* draw = ImGui::GetForegroundDrawList();
    float boxW = boxBottomRight.x - boxTopLeft.x;
    float boxH = boxBottomRight.y - boxTopLeft.y;
    float lenX = ImClamp(boxW * 0.28f, 8.0f, 22.0f);
    float lenY = ImClamp(boxH * 0.16f, 10.0f, 28.0f);
    float t = 0.85f;
    ImU32 shadow = IM_COL32(0, 0, 0, 135);

    auto corner = [&](ImVec2 p, float sx, float sy) {
        ImVec2 px(p.x + sx * lenX, p.y);
        ImVec2 py(p.x, p.y + sy * lenY);
        draw->AddLine(ImVec2(p.x + sx, p.y + sy), ImVec2(px.x + sx, px.y + sy), shadow, t + 1.1f);
        draw->AddLine(ImVec2(p.x + sx, p.y + sy), ImVec2(py.x + sx, py.y + sy), shadow, t + 1.1f);
        draw->AddLine(p, px, theme.panelEdge, t);
        draw->AddLine(p, py, theme.panelEdge, t);
    };

    corner(boxTopLeft, 1.0f, 1.0f);
    corner(ImVec2(boxBottomRight.x, boxTopLeft.y), -1.0f, 1.0f);
    corner(ImVec2(boxTopLeft.x, boxBottomRight.y), 1.0f, -1.0f);
    corner(boxBottomRight, -1.0f, -1.0f);

    float centerX = (boxTopLeft.x + boxBottomRight.x) * 0.5f;
    draw->AddCircleFilled(ImVec2(centerX, boxTopLeft.y), 1.45f, WithAlpha(theme.accent, 205), 8);
}

static void DrawPlayerHealthBar(ImVec2 boxTopLeft,
                                ImVec2 boxBottomRight,
                                float hp,
                                float maxHp,
                                const PlayerVisualTheme &theme) {
    if (!(血量 || 人物血条)) return;
    if (maxHp <= 1.0f) return;

    ImDrawList* draw = ImGui::GetForegroundDrawList();
    float boxW = boxBottomRight.x - boxTopLeft.x;
    float ratio = ImClamp(hp / maxHp, 0.0f, 1.0f);
    float width = ImClamp(boxW * 0.96f, 36.0f, 70.0f);
    float height = 3.4f;
    float centerX = (boxTopLeft.x + boxBottomRight.x) * 0.5f;
    float y = boxTopLeft.y - 8.0f;
    ImVec2 p0(ImFloor(centerX - width * 0.5f), ImFloor(y));
    ImVec2 p1(ImFloor(centerX + width * 0.5f), ImFloor(y + height));

    ImU32 fill = theme.primary;
    if (ratio <= 0.25f) fill = IM_COL32(255, 68, 70, 255);
    else if (ratio <= 0.55f) fill = IM_COL32(255, 184, 64, 255);

    draw->AddRectFilled(ImVec2(p0.x - 0.7f, p0.y - 0.7f), ImVec2(p1.x + 0.7f, p1.y + 0.7f), IM_COL32(0, 0, 0, 130), 2.0f);
    draw->AddRectFilled(p0, p1, IM_COL32(18, 22, 29, 205), 2.0f);
    float fillRight = p0.x + (p1.x - p0.x) * ratio;
    if (fillRight > p0.x + 0.6f) {
        draw->AddRectFilled(ImVec2(p0.x, p0.y), ImVec2(fillRight, p1.y), fill, 2.0f);
        draw->AddRectFilled(ImVec2(p0.x, p0.y), ImVec2(fillRight, p0.y + 1.0f), IM_COL32(255, 255, 255, 58), 2.0f);
    }
    draw->AddRect(p0, p1, WithAlpha(theme.panelEdge, 205), 2.0f, 0, 0.65f);
}

static void DrawPlayerInfoText(ImVec2 boxTopLeft,
                               ImVec2 boxBottomRight,
                               int team,
                               const char *name,
                               float dist,
                               bool isAI,
                               const PlayerVisualTheme &theme) {
    float boxW = boxBottomRight.x - boxTopLeft.x;
    float boxH = boxBottomRight.y - boxTopLeft.y;
    float centerX = (boxTopLeft.x + boxBottomRight.x) * 0.5f;
    float fontSize = ImClamp(boxH * 0.13f, 10.0f, 15.0f);

    if (信息 || 人物信息) {
        std::string nameText = TrimPlayerLabel(name);
        std::string label = isAI ? string_format("AI #%d", team) : string_format("#%d %s", team, nameText.c_str());
        float maxWidth = ImClamp(boxW * 1.85f, 70.0f, 160.0f);
        ImVec2 textSize = ImGui::GetFont()->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, label.c_str());
        if (textSize.x > maxWidth && textSize.x > 1.0f) {
            fontSize = ImClamp(fontSize * (maxWidth / textSize.x), 9.0f, fontSize);
        }
        DrawText(label, ImVec2(centerX, boxTopLeft.y - 30.0f), true, theme.text, true, fontSize);
    } else if (方框) {
        DrawText(string_format("%d", team), ImVec2(centerX, boxTopLeft.y - 28.0f), true, theme.primary, true, fontSize);
    }

    if (距离 || 距离显示) {
        std::string distText = string_format("%.0fm", dist);
        ImU32 distColor = dist <= 50.0f ? IM_COL32(255, 220, 88, 255) : theme.dimText;
        DrawText(distText, ImVec2(centerX, boxBottomRight.y + 4.0f), true, distColor, true, ImClamp(fontSize + 1.0f, 10.0f, 16.0f));
    }
}

static void DrawESPAtBox(ImVec2 boxTopLeft, ImVec2 boxBottomRight, int team, const char* name, float dist, float hp, float maxHp, bool isAI, bool targetVisible) {
    bool visibleTone = (hp > 0.0f) && targetVisible;
    PlayerVisualTheme theme = GetPlayerVisualTheme(isAI, visibleTone);
    ImVec2 anchor((boxTopLeft.x + boxBottomRight.x) * 0.5f, boxBottomRight.y);
    NormalizePlayerBox(boxTopLeft, boxBottomRight, anchor, dist, &boxTopLeft, &boxBottomRight);

    DrawPlayerFrame(boxTopLeft, boxBottomRight, theme);
    DrawPlayerHealthBar(boxTopLeft, boxBottomRight, hp, maxHp, theme);
    DrawPlayerInfoText(boxTopLeft, boxBottomRight, team, name, dist, isAI, theme);

    if (射线) {
        ImVec2 target((boxTopLeft.x + boxBottomRight.x) * 0.5f, boxTopLeft.y - 14.0f);
        DrawTypeRayLine(target, isAI, theme.primary);
    }
}

static ImVec2 GetCountTextPosition(bool isAI) {
    float centerX = 屏幕宽度 * 0.5f;
    return ImVec2(centerX + (isAI ? -kCountColumnOffsetX : kCountColumnOffsetX), kCountTextY);
}

static ImVec2 GetCountRayStartPosition(bool isAI) {
    ImVec2 textPos = GetCountTextPosition(isAI);
    return ImVec2(textPos.x, textPos.y + kCountRayStartOffsetY);
}

static void DrawCountBadge(ImVec2 center, const char *title, int value, bool isAI) {
    ImDrawList* draw = ImGui::GetForegroundDrawList();
    PlayerVisualTheme theme = GetPlayerVisualTheme(isAI, value > 0);
    const float w = 118.0f;
    const float h = 34.0f;
    ImVec2 p0(ImFloor(center.x - w * 0.5f), ImFloor(center.y - h * 0.5f));
    ImVec2 p1(ImFloor(center.x + w * 0.5f), ImFloor(center.y + h * 0.5f));

    draw->AddRectFilled(ImVec2(p0.x + 1.0f, p0.y + 2.0f), ImVec2(p1.x + 1.0f, p1.y + 2.0f), IM_COL32(0, 0, 0, 105), 8.0f);
    draw->AddRectFilled(p0, p1, theme.panel, 8.0f);
    draw->AddRect(p0, p1, WithAlpha(theme.panelEdge, value > 0 ? 230 : 120), 8.0f, 0, 1.2f);
    draw->AddRectFilled(p0, ImVec2(p0.x + 4.0f, p1.y), WithAlpha(theme.primary, value > 0 ? 235 : 120), 8.0f, ImDrawFlags_RoundCornersLeft);

    std::string label = string_format("%s %d", title, value);
    ImU32 textColor = value > 0 ? theme.text : theme.dimText;
    DrawText(label, ImVec2(center.x, center.y - 8.5f), true, textColor, true, 17.0f);
}

// 指示射线：从人数区下方向敌人射出（人机=冷色，玩家=暖色）
void DrawTypeRayLine(ImVec2 targetPos, bool isAI, ImU32 rayColor) {
    ImVec2 rayStart = GetCountRayStartPosition(isAI);
    if (rayColor == 0) {
        rayColor = GetPlayerVisualTheme(isAI, true).primary;
    }
    DrawGlowLine(rayStart, targetPos, rayColor, 0.68f);
    ImGui::GetForegroundDrawList()->AddCircleFilled(targetPos, 1.45f, WithAlpha(rayColor, 220), 8);
}

void DrawBone(ImVec2 a, ImVec2 b, ImU32 color = IM_COL32(255, 255, 255, 255)) {
    DrawGlowLine(a, b, color, 0.68f);
}

static float 读取世界时间秒(uint64_t gWorld, const RuntimeWorldLayout *layout = nullptr);

static inline bool IsValidBoneScreenPoint(const Vector2 &point) {
    return point.X >= 0 && point.X <= 屏幕宽度 &&
           point.Y >= 0 && point.Y <= 屏幕高度 &&
           !isnan(point.X) && !isnan(point.Y) &&
           !isinf(point.X) && !isinf(point.Y);
}

static inline bool IsDrawableBoneScreenPoint(const Vector2 &point) {
    const float margin = 160.0f;
    return point.X >= -margin && point.X <= 屏幕宽度 + margin &&
           point.Y >= -margin && point.Y <= 屏幕高度 + margin &&
           !isnan(point.X) && !isnan(point.Y) &&
           !isinf(point.X) && !isinf(point.Y);
}

static inline bool IsValidBoneWorldPoint(const Vector3 &point) {
    return (point.X != 0.0f || point.Y != 0.0f || point.Z != 0.0f) &&
           !isnan(point.X) && !isnan(point.Y) && !isnan(point.Z) &&
           !isinf(point.X) && !isinf(point.Y) && !isinf(point.Z);
}

static inline float BoneWorldDistance(const Vector3 &a, const Vector3 &b) {
    float dx = a.X - b.X;
    float dy = a.Y - b.Y;
    float dz = a.Z - b.Z;
    return sqrtf(dx * dx + dy * dy + dz * dz);
}

static inline float BoneScreenDistance(const Vector2 &a, const Vector2 &b) {
    float dx = a.X - b.X;
    float dy = a.Y - b.Y;
    return sqrtf(dx * dx + dy * dy);
}

static bool IsReasonableSkeletonSegment(const Vector3 &parentWorld,
                                        const Vector3 &childWorld,
                                        const Vector2 &parentScreen,
                                        const Vector2 &childScreen,
                                        float skeletonHeight) {
    float worldLen = BoneWorldDistance(parentWorld, childWorld);
    if (worldLen < 0.5f || worldLen > 175.0f) {
        return false;
    }

    float screenLen = BoneScreenDistance(parentScreen, childScreen);
    float maxScreenLen = ImClamp(skeletonHeight * 0.58f, 22.0f, 260.0f);
    if (screenLen < 1.0f || screenLen > maxScreenLen) {
        return false;
    }

    return true;
}

struct SkeletonSegment {
    int parent;
    int child;
};

static int ReadCachedSkeletonBoneCount(long meshComponent) {
    int boneCount = KFD::Read<int>(meshComponent + kCachedComponentSpaceTransforms + 0x8);
    if (boneCount < 2 || boneCount > kMaxSkeletonBones) {
        return kMaxSkeletonBones;
    }
    return boneCount;
}

static int BuildSkeletonBoneCache(long meshComponent,
                                  const FTransform &componentToWorld,
                                  int boneCount,
                                  Vector3 *worldPositions,
                                  Vector2 *screenPositions,
                                  bool *validPoints,
                                  float *outHeight) {
    float minY = FLT_MAX;
    float maxY = -FLT_MAX;
    int validCount = 0;

    for (int i = 0; i < boneCount; i++) {
        validPoints[i] = false;
        screenPositions[i] = Vector2(-1, -1);

        Vector3 boneWorldPos = GetBoneWithRotation(meshComponent, i, componentToWorld);
        if (!IsValidBoneWorldPoint(boneWorldPos)) {
            continue;
        }

        Vector2 screenPos = WorldToScreen(boneWorldPos, POV, 屏幕宽度, 屏幕高度);
        if (!IsDrawableBoneScreenPoint(screenPos)) {
            continue;
        }

        worldPositions[i] = boneWorldPos;
        screenPositions[i] = screenPos;
        validPoints[i] = true;
        minY = ImMin(minY, screenPos.Y);
        maxY = ImMax(maxY, screenPos.Y);
        validCount++;
    }

    if (outHeight) {
        *outHeight = validCount >= 2 ? ImMax(maxY - minY, 24.0f) : 24.0f;
    }
    return validCount;
}

static int DrawSkeletonSegments(const SkeletonSegment *segments,
                                int segmentCount,
                                const Vector3 *worldPositions,
                                const Vector2 *screenPositions,
                                const bool *validPoints,
                                int boneCount,
                                float skeletonHeight,
                                ImU32 boneColor,
                                bool draw) {
    int drawn = 0;
    for (int i = 0; i < segmentCount; i++) {
        int parent = segments[i].parent;
        int child = segments[i].child;
        if (parent < 0 || child < 0 || parent >= boneCount || child >= boneCount ||
            !validPoints[parent] || !validPoints[child]) {
            continue;
        }

        if (!IsReasonableSkeletonSegment(worldPositions[parent],
                                         worldPositions[child],
                                         screenPositions[parent],
                                         screenPositions[child],
                                         skeletonHeight)) {
            continue;
        }

        drawn++;
        if (draw) {
            DrawBone(ImVec2(screenPositions[parent].X, screenPositions[parent].Y),
                     ImVec2(screenPositions[child].X, screenPositions[child].Y),
                     boneColor);
        }
    }
    return drawn;
}

static int DrawBoneTreeSkeleton(long meshComponent,
                                const Vector3 *worldPositions,
                                const Vector2 *screenPositions,
                                const bool *validPoints,
                                int boneCount,
                                float skeletonHeight,
                                ImU32 boneColor,
                                bool draw) {
    long SkeletalMesh = KFD::Read<long>(meshComponent + kSkeletalMeshAsset);
    long Skeleton = KFD::地址泄露(SkeletalMesh) ? KFD::Read<long>(SkeletalMesh + 0x48) : 0;
    long BoneTreeData = 0;
    int BoneTreeNum = 0;
    if (KFD::地址泄露(Skeleton)) {
        BoneTreeData = KFD::Read<long>(Skeleton + 0x30);
        BoneTreeNum = KFD::Read<int>(Skeleton + 0x30 + 8);
    }
    if (!KFD::地址泄露(BoneTreeData) || BoneTreeNum <= 1 || BoneTreeNum > kMaxSkeletonBones) {
        return 0;
    }

    int linkCount = 0;
    int limit = ImMin(BoneTreeNum, boneCount);
    for (int i = 1; i < limit; i++) {
        int parent = KFD::Read<int>(BoneTreeData + i * 0x60 + 0x8);
        if (parent < 0 || parent >= limit || !validPoints[parent] || !validPoints[i]) {
            continue;
        }

        if (!IsReasonableSkeletonSegment(worldPositions[parent],
                                         worldPositions[i],
                                         screenPositions[parent],
                                         screenPositions[i],
                                         skeletonHeight)) {
            continue;
        }

        linkCount++;
        if (draw) {
            DrawBone(ImVec2(screenPositions[parent].X, screenPositions[parent].Y),
                     ImVec2(screenPositions[i].X, screenPositions[i].Y),
                     boneColor);
        }
    }
    return linkCount;
}

static int DrawFallbackHumanSkeleton(const Vector3 *worldPositions,
                                     const Vector2 *screenPositions,
                                     const bool *validPoints,
                                     int boneCount,
                                     float skeletonHeight,
                                     ImU32 boneColor) {
    static const SkeletonSegment kUE4Mannequin[] = {
        {6,5}, {5,4}, {4,3}, {3,2}, {2,1},
        {4,7}, {7,8}, {8,9}, {9,10},
        {4,28}, {28,29}, {29,30}, {30,31},
        {1,49}, {49,50}, {50,51},
        {1,55}, {55,56}, {56,57}
    };
    static const SkeletonSegment kPubgA[] = {
        {6,5}, {5,4}, {4,3}, {3,2}, {2,1},
        {4,11}, {11,12}, {12,13}, {13,14},
        {4,32}, {32,33}, {33,34}, {34,35},
        {1,52}, {52,53}, {53,54},
        {1,56}, {56,57}, {57,58}
    };
    static const SkeletonSegment kPubgB[] = {
        {5,4}, {4,3}, {3,2}, {2,1},
        {4,12}, {12,13}, {13,14},
        {4,33}, {33,34}, {34,35},
        {1,53}, {53,54}, {54,55},
        {1,57}, {57,58}, {58,59}
    };
    static const SkeletonSegment kCompactA[] = {
        {4,3}, {3,2}, {2,1}, {1,0},
        {3,5}, {5,6}, {6,7}, {7,8},
        {3,9}, {9,10}, {10,11}, {11,12},
        {0,13}, {13,14}, {14,15},
        {0,16}, {16,17}, {17,18}
    };
    static const SkeletonSegment kCompactB[] = {
        {0,1}, {1,2}, {2,3}, {3,4},
        {3,6}, {6,7}, {7,8}, {8,9},
        {3,10}, {10,11}, {11,12}, {12,13},
        {0,14}, {14,15}, {15,16},
        {0,17}, {17,18}, {18,19}
    };

    struct SkeletonCandidate {
        const SkeletonSegment *segments;
        int count;
    };

    static const SkeletonCandidate candidates[] = {
        {kUE4Mannequin, (int)(sizeof(kUE4Mannequin) / sizeof(kUE4Mannequin[0]))},
        {kPubgA, (int)(sizeof(kPubgA) / sizeof(kPubgA[0]))},
        {kPubgB, (int)(sizeof(kPubgB) / sizeof(kPubgB[0]))},
        {kCompactA, (int)(sizeof(kCompactA) / sizeof(kCompactA[0]))},
        {kCompactB, (int)(sizeof(kCompactB) / sizeof(kCompactB[0]))}
    };

    int bestIndex = -1;
    int bestScore = 0;
    for (int i = 0; i < (int)(sizeof(candidates) / sizeof(candidates[0])); i++) {
        int score = DrawSkeletonSegments(candidates[i].segments,
                                         candidates[i].count,
                                         worldPositions,
                                         screenPositions,
                                         validPoints,
                                         boneCount,
                                         skeletonHeight,
                                         boneColor,
                                         false);
        if (score > bestScore) {
            bestScore = score;
            bestIndex = i;
        }
    }

    if (bestIndex < 0 || bestScore < 4) {
        return 0;
    }

    return DrawSkeletonSegments(candidates[bestIndex].segments,
                                candidates[bestIndex].count,
                                worldPositions,
                                screenPositions,
                                validPoints,
                                boneCount,
                                skeletonHeight,
                                boneColor,
                                true);
}

static void DrawLimbSkeleton(long meshComponent, const FTransform &componentToWorld, ImU32 boneColor) {
    int boneCount = ReadCachedSkeletonBoneCount(meshComponent);
    Vector3 boneWorldPositions[kMaxSkeletonBones];
    Vector2 boneScreenPositions[kMaxSkeletonBones];
    bool boneValid[kMaxSkeletonBones];
    float skeletonHeight = 24.0f;
    int validCount = BuildSkeletonBoneCache(meshComponent,
                                            componentToWorld,
                                            boneCount,
                                            boneWorldPositions,
                                            boneScreenPositions,
                                            boneValid,
                                            &skeletonHeight);
    if (validCount < 2) {
        return;
    }

    int treeScore = DrawBoneTreeSkeleton(meshComponent,
                                         boneWorldPositions,
                                         boneScreenPositions,
                                         boneValid,
                                         boneCount,
                                         skeletonHeight,
                                         boneColor,
                                         false);
    if (treeScore >= 5) {
        DrawBoneTreeSkeleton(meshComponent,
                             boneWorldPositions,
                             boneScreenPositions,
                             boneValid,
                             boneCount,
                             skeletonHeight,
                             boneColor,
                             true);
        return;
    }

    int fallbackScore = DrawFallbackHumanSkeleton(boneWorldPositions,
                                                 boneScreenPositions,
                                                 boneValid,
                                                 boneCount,
                                                 skeletonHeight,
                                                 boneColor);
    if (fallbackScore == 0 && treeScore > 0) {
        DrawBoneTreeSkeleton(meshComponent,
                             boneWorldPositions,
                             boneScreenPositions,
                             boneValid,
                             boneCount,
                             skeletonHeight,
                             boneColor,
                             true);
    }
}

struct DrawOcclusionState {
    bool visible = true;
    float worldTime = 0.0f;
    float renderTime = 0.0f;
    float delta = 0.0f;
    bool valid = false;
};

static DrawOcclusionState GetDrawOcclusionState(uint64_t gWorld, long meshComponent) {
    DrawOcclusionState state;
    if (!KFD::地址泄露(meshComponent)) {
        return state;
    }

    state.worldTime = 读取世界时间秒(gWorld);
    state.renderTime = KFD::Read<float>(meshComponent + 0x414);
    if (!std::isfinite(state.worldTime) || !std::isfinite(state.renderTime) ||
        state.worldTime <= 0.0f || state.renderTime <= 0.0f) {
        return state;
    }

    state.delta = state.worldTime - state.renderTime;
    state.valid = std::isfinite(state.delta) && state.delta > -0.25f && state.delta < 30.0f;
    if (state.valid) {
        state.visible = state.delta < 1.0f;
    }
    return state;
}

static bool IsPlayerVisibleForDraw(uint64_t gWorld, long player, DrawOcclusionState *outState = nullptr) {
    if (!掩体判断) {
        if (outState) {
            *outState = DrawOcclusionState{};
            outState->visible = true;
        }
        return true;
    }

    // 方法1: PhysX 物理射线掩体检测（基于真实碰撞体数据）
    const auto& colliders = PhysXColliderExtractor::GetColliders();
    if (!colliders.empty()) {
        Vector3 playerPos = GetRelativeLocation(player);
        if (std::isfinite(playerPos.X) && std::isfinite(playerPos.Y) && std::isfinite(playerPos.Z) &&
            (playerPos.X != 0 || playerPos.Y != 0 || playerPos.Z != 0)) {
            // 获取摄像机位置 (POV.Location)
            uint64_t NetDriver = KFD::Read<uint64_t>(gWorld + kNetDriver);
            if (LooksLikeUserVA(NetDriver)) {
                uint64_t ServerConnection = KFD::Read<uint64_t>(NetDriver + kServerConnection);
                if (LooksLikeUserVA(ServerConnection)) {
                    uint64_t PlayerController = KFD::Read<uint64_t>(ServerConnection + klocalPlayerController);
                    if (LooksLikeUserVA(PlayerController)) {
                        uint64_t PlayerCameraManager = KFD::Read<uint64_t>(PlayerController + kPlayerCameraManager);
                        if (LooksLikeUserVA(PlayerCameraManager)) {
                            CoViewbyo POV = KFD::Read<CoViewbyo>(PlayerCameraManager + kViewTarget + 0x10);
                            bool occluded = PhysXRaycast::IsOccluded(POV.Location, playerPos, colliders);
                            if (outState) {
                                *outState = DrawOcclusionState{};
                                outState->visible = !occluded;
                                outState->valid = true;
                            }
                            return !occluded;
                        }
                    }
                }
            }
        }
    }

    // 回退: 基于渲染时间的启发式检测
    long meshComponent = KFD::Read<long>(player + kMesh);
    DrawOcclusionState state = GetDrawOcclusionState(gWorld, meshComponent);
    if (outState) {
        *outState = state;
    }
    return !state.valid || state.visible;
}

float Health;
// SystemHelper 本局识别标记
static bool gTEHasAuthorThisMatch = false;
static bool gTEHasUserThisMatch   = false;

// SystemHelper 本局本地玩家名字（用于激活时上传游戏名）
static std::string gTE_LocalPlayerName;

extern "C" const char* TEGetLocalPlayerName(void) {
    return gTE_LocalPlayerName.empty() ? nullptr : gTE_LocalPlayerName.c_str();
}

struct Level诊断信息 {
    uint64_t persistentLevel = 0;
    uint64_t currentLevel = 0;
    uint64_t pendingVisibilityLevel = 0;
    uint64_t chosenLevel = 0;
    uint64_t chosenActorArray = 0;
    int chosenActorCount = 0;
    const char *chosenSource = "none";
};

static Level诊断信息 gLastLevelDiag;

static std::string Level诊断摘要(const Level诊断信息 &diag) {
    return string_format("P:0x%llx C:0x%llx V:0x%llx 选中:%s",
                         (unsigned long long)diag.persistentLevel,
                         (unsigned long long)diag.currentLevel,
                         (unsigned long long)diag.pendingVisibilityLevel,
                         diag.chosenSource);
}

static bool 读取LevelActor数组(uint64_t level,
                         uint64_t *outActorArray,
                         int *outActorCount,
                         uint64_t *outActorCluster = nullptr,
                         const RuntimeWorldLayout *layout = nullptr) {
    if (outActorArray) *outActorArray = 0;
    if (outActorCount) *outActorCount = 0;
    if (outActorCluster) *outActorCluster = 0;

    return ResolveActorArrayFromLevelCandidate(level, outActorArray, outActorCount, outActorCluster, layout);
}

static bool 读取世界Actor数组(uint64_t gWorld,
                        uint64_t *outActorArray,
                        int *outActorCount,
                        const RuntimeWorldLayout *layout = nullptr) {
    if (outActorArray) *outActorArray = 0;
    if (outActorCount) *outActorCount = 0;

    return ResolveActorArrayFromWorld(gWorld, outActorArray, outActorCount, layout);
}

static float 读取世界时间秒(uint64_t gWorld, const RuntimeWorldLayout *layout) {
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return 0.f;
    }

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    uint64_t gameState = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.gameState));
    if (!LooksLikeUserVA(gameState)) {
        return 0.f;
    }

    return KFD::Read<float>(gameState + kReplicatedWorldTimeSeconds);
}

static uint64_t 读取有效Level(uint64_t gWorld, const RuntimeWorldLayout *layout = nullptr) {
    gLastLevelDiag = {};
    gWorld = StripRuntimePAC(gWorld);
    if (!LooksLikeUserVA(gWorld)) {
        return 0;
    }

    const RuntimeWorldLayout &activeLayout = layout ? *layout : CurrentRuntimeWorldLayout();
    gLastLevelDiag.persistentLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.persistentLevel));
    gLastLevelDiag.currentLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.currentLevel));
    gLastLevelDiag.pendingVisibilityLevel = StripRuntimePAC(KFD::Read<uint64_t>(gWorld + activeLayout.pendingVisibilityLevel));

    const struct {
        uint64_t level;
        const char *source;
    } levelCandidates[] = {
        { gLastLevelDiag.persistentLevel, "Persistent" },
        { gLastLevelDiag.currentLevel, "Current" },
        { gLastLevelDiag.pendingVisibilityLevel, "Pending" },
    };

    uint64_t firstReadableLevel = 0;
    const char *firstReadableSource = "none";
    for (const auto &candidate : levelCandidates) {
        uint64_t level = StripRuntimePAC(candidate.level);
        if (!LooksLikeUserVA(level)) {
            continue;
        }
        if (!firstReadableLevel) {
            firstReadableLevel = level;
            firstReadableSource = candidate.source;
        }

        uint64_t actorArray = 0;
        int actorCount = 0;
        if (读取LevelActor数组(level, &actorArray, &actorCount, nullptr, &activeLayout)) {
            gLastLevelDiag.chosenLevel = level;
            gLastLevelDiag.chosenActorArray = actorArray;
            gLastLevelDiag.chosenActorCount = actorCount;
            gLastLevelDiag.chosenSource = candidate.source;
            return level;
        }
    }

    if (firstReadableLevel != 0) {
        gLastLevelDiag.chosenLevel = firstReadableLevel;
        gLastLevelDiag.chosenSource = firstReadableSource;
        读取LevelActor数组(firstReadableLevel,
                       &gLastLevelDiag.chosenActorArray,
                       &gLastLevelDiag.chosenActorCount,
                       nullptr,
                       &activeLayout);
    }
    return firstReadableLevel;
}

void 读取数据(uint64_t GWorld, long player, bool actorMaybeAI)
{
    chiqiang =0;
    
    long NetDriver = KFD::Read<long>(GWorld + kNetDriver);
    long ServerConnection = KFD::Read<long>(NetDriver + kServerConnection);
    
    long PlayerController = KFD::Read<long>(ServerConnection + klocalPlayerController);
    long PlayerCameraManager = KFD::Read<long>(PlayerController + kPlayerCameraManager);
    
    // 本地角色（人物 + 载具都要排除）
    Character = KFD::Read<long>(PlayerController + kPawn);
    long LocalVehicle = 0;
    if (KFD::地址泄露(Character)) {
        // 一些版本里，角色上车后 Pawn 变成载具 Pawn，这里兼容一下
        LocalVehicle = KFD::Read<long>(Character + kCurrentVehicle);
    }
    if (player == Character || (LocalVehicle != 0 && player == LocalVehicle)) {
        // 记录本地玩家名字（供前端验证时上传到服务器）
        std::string localName = GetPlayerName(Character);
        if (!localName.empty()) {
            gTE_LocalPlayerName = localName;
        }
        // 不绘制自己（人物本体 + 自己正在乘坐的载具 Pawn）
        return;
    }
    
    // 队伍过滤：不绘制队友（包含坐在载具里的队友）
    int localTeamID = 0;
    if (KFD::地址泄露(Character)) {
        localTeamID = KFD::Read<int>(Character + kTeamID);
    }
    int actorTeamID = 0;
    if (KFD::地址泄露(player)) {
        actorTeamID = KFD::Read<int>(player + kTeamID);
    }
    if (localTeamID != 0 && actorTeamID != 0 && actorTeamID == localTeamID) {
        // 同队玩家（含载具中的队友）全部跳过
        return;
    }
   
    POV = KFD::Read<CoViewbyo>(PlayerCameraManager + kViewTarget + 0x10);

    
    LocationWorldPos = GetRelativeLocation(player);
    Vector2 LocationScreen = WorldToScreen(LocationWorldPos, POV, 屏幕宽度, 屏幕高度);
    float distance = GetDistance(LocationWorldPos, POV.Location) / 100;

    totalEnemies++;
    bool bIsAI = actorMaybeAI;
    if (!bIsAI && KFD::地址泄露(player)) {
        uint8_t aiFlag = KFD::Read<uint8_t>(player + kbIsAI);
        bIsAI = (aiFlag != 0);
    }
    if (bIsAI) totalAIEnemies++;
    else totalRealEnemies++;
    s_radarEnemyWorldPos.push_back(LocationWorldPos);
    
    VectorRect rect;
    BoxConversion(LocationWorldPos, &rect, POV, Vector2(屏幕宽度, 屏幕高度));
   
    if (isScreenVisible(LocationScreen, Vector2(屏幕宽度, 屏幕高度)))
    {
        Vector3 Hitpart[13];
      
        Vector3 打击点世界坐标,root;
    
        // 以当前角色位置作为自瞄打击点（后续如需精确到头部，可替换为骨骼坐标）
        打击点世界坐标 = LocationWorldPos;
        打击点屏幕坐标 = LocationScreen;
     
        Vector2 HeadScreen = LocationScreen;
        // 兼容老逻辑：后面“手持图标”等功能仍在使用 dx/dy 作为参考点
        // 这里把 dx/dy 固定为 HeadScreen 基准，避免作用域问题导致编译报错
        float dx = HeadScreen.X;
        float dy = HeadScreen.Y;

        
        bool bIsWeaponFiring = KFD::Read<bool>(Character + kbIsWeaponFiring);
        bool kaijing = KFD::Read<bool>(Character + kbIsGunADS);
        
        int TeamID = actorTeamID;    // 使用真实队伍编号（仅敌人，因为队友已被过滤）
        DrawOcclusionState occlusionState;
        bool targetVisible = IsPlayerVisibleForDraw(GWorld, player, &occlusionState);
      
    

        // —— 自瞄候选目标筛选（基于 FOV 圈） ——
        if ((!掩体判断 || targetVisible) && GetInsideFov(屏幕宽度, 屏幕高度, 打击点屏幕坐标, 自瞄大小)) {
                   float tDistance = GetCenterOffsetForVector(打击点屏幕坐标);

                   // 默认用自瞄距离
                   float maxDistance = 自瞄距离;

                   // 如果在开枪但没开镜 = 腰射，限制为腰射距离
                   if (bIsWeaponFiring && !kaijing) {
                       maxDistance = 腰射距离;
                   }

                   if (tDistance <= 自瞄大小 && tDistance < markDistance && distance < maxDistance) {
                       needAdjustAim = true;
                       if (needAdjustAim) {
                           // 仅当更优才更新“当前最佳”目标
                           markDistance  = tDistance;
                           markScreenPos = 打击点屏幕坐标;

                           zimiaoshuju   = player;
                           markPos.X     = 打击点世界坐标.X;
                           markPos.Y     = 打击点世界坐标.Y;
                           markPos.Z     = 打击点世界坐标.Z;

                           LFLogDebug(@"自瞄候选命中：dist=%.1f markDist=%.1f maxDist=%.1f circle=%.1f pos=(%.1f,%.1f,%.1f)",
                                      distance, tDistance, maxDistance, 自瞄大小,
                                      markPos.X, markPos.Y, markPos.Z);
                       }
                   }
               }
        
        
        // 人物绘制数据：血量、队伍、名字和距离统一交给 DrawESPAtBox。
        float Health1 = KFD::Read<float>(player + kHealth);
        float HealthMax = KFD::Read<float>(player + kHealthMax);
        Health          = (HealthMax > 0.0f ? (Health1 / HealthMax * 100.0f) : 0.0f);

        // 获取玩家名字（在方框/人物信息两处共用，故放在外层作用域）
        string rawName = GetPlayerName(player);
        string displayName;
        if (信息) {
            if (bIsAI) {
                displayName = string_format("%d·B", TeamID);
            } else {
                NSString *nameStr = [NSString stringWithUTF8String:rawName.c_str()];
                TEUserStatus status = TEGetCachedStatus(nameStr);
                if (status == TEUserStatusUnknown) {
                    TERequestUserStatus(nameStr);
                }
                if (status == TEUserStatusAuthor) {
                    gTEHasAuthorThisMatch = true;
                    displayName = string_format("V%s", rawName.c_str());
                } else if (status == TEUserStatusUser) {
                    gTEHasUserThisMatch = true;
                    displayName = string_format("[Troll]%s", rawName.c_str());
                } else {
                    displayName = rawName;
                }
            }
        } else {
            displayName = string_format("%d", TeamID);
        }
        if (displayName.empty()) displayName = rawName;
        const char* nameCStr = displayName.empty() ? "Unknown" : displayName.c_str();
        ImVec2 defaultBoxMin(rect.x, rect.y);
        ImVec2 defaultBoxMax(rect.x + rect.w, rect.y + rect.h);
        NormalizePlayerBox(defaultBoxMin,
                           defaultBoxMax,
                           ImVec2(LocationScreen.X, LocationScreen.Y),
                           distance,
                           &defaultBoxMin,
                           &defaultBoxMax);
        bool playerOverlayDrawn = false;
        auto DrawCurrentPlayerOverlay = [&](ImVec2 minPos, ImVec2 maxPos) {
            if (playerOverlayDrawn) return;
            DrawESPAtBox(minPos, maxPos, TeamID, nameCStr, distance, Health1, HealthMax, bIsAI, targetVisible);
            playerOverlayDrawn = true;
        };

        if(方框 || 绘制掩体){
            uint64_t CapsuleComponent = KFD::Read<uint64_t>(player + kCapsuleComponent);
            if (KFD::地址泄露(CapsuleComponent)) {
                        // Class: CapsuleComponent.ShapeComponent.PrimitiveComponent.SceneComponent.ActorComponent.Object -> float CapsuleHalfHeight;
                        float CapsuleHalfHeight = KFD::Read<float>(CapsuleComponent + 0x7c8);
                        float CapsuleRadius = KFD::Read<float>(CapsuleComponent + 0x7cc);
                        if (CapsuleHalfHeight > 0) {
                            Vector3 RelativeScale3D = KFD::Read<Vector3>(CapsuleComponent + kRelativeScale3D);
                            // Class: SceneComponent.ActorComponent.Object -> Transform ComponentToWorld;
                            // Class: Transform -> Vector Scale3D;
                        
                            float MinScale = std::fmin(std::fmin(fabs(RelativeScale3D.X), fabs(RelativeScale3D.Y)), fabs(RelativeScale3D.Z));
                            float ScaledRadius = CapsuleRadius * MinScale;
                            float ScaledHalfHeight = CapsuleHalfHeight * MinScale;
                            
                            // === 3D 立体包围盒（AABB） ===
                            // 以胶囊体半径/半高构造一个世界轴对齐的立体包围盒
                            Vector3 bmin(LocationWorldPos.X - ScaledRadius,
                                         LocationWorldPos.Y - ScaledRadius,
                                         LocationWorldPos.Z - ScaledHalfHeight);
                            Vector3 bmax(LocationWorldPos.X + ScaledRadius,
                                         LocationWorldPos.Y + ScaledRadius,
                                         LocationWorldPos.Z + ScaledHalfHeight);
                            
                            Vector2 BoxTopLeft, BoxBottomRight;
                            
                            long boxMeshComp = KFD::Read<long>(player + kMesh);
                            // 掩体 3D 盒保留原有阵营配色，普通方框走新的括角样式。
                            ImColor boxColor = targetVisible
                                ? (bIsAI ? ImColor(0.f, 1.f, 0.f, 1.f) : ImColor(1.f, 0.f, 0.f, 1.f))
                                : ImColor(1.f, 0.55f, 0.f, 1.f);
                            // 3D盒这里不做面填充（避免遮挡画面），只保留线框“立体盒”
                            // ImColor fillColor = boxEnemyVisible ? ImColor(0.f, 1.f, 0.f, 0.06f) : ImColor(1.f, 0.f, 0.f, 0.06f);
                            
                            // 仅当“绘制掩体”开启时绘制 3D 几何。
                            bool box3DOk = true;
                            if (绘制掩体) {
                                Vector2 outMin2D, outMax2D;
                                box3DOk = Draw3DWireBoxAABB(bmin, bmax, POV, 屏幕宽度, 屏幕高度,
                                                           (ImU32)boxColor, 1.2f, &outMin2D, &outMax2D);
                                if (box3DOk) {
                                    BoxTopLeft = outMin2D;
                                    BoxBottomRight = outMax2D;
                                }
                            } else {
                                BoxTopLeft = Vector2(defaultBoxMin.x, defaultBoxMin.y);
                                BoxBottomRight = Vector2(defaultBoxMax.x, defaultBoxMax.y);
                            }
                            
                            if (box3DOk) {
                                if (掩体变色调试 && KFD::地址泄露(boxMeshComp)) {
                                    const auto& debugColliders = PhysXColliderExtractor::GetColliders();
                                    if (!debugColliders.empty() && occlusionState.valid) {
                                        // PhysX 模式: 显示遮挡状态
                                        char buf[96];
                                        snprintf(buf, sizeof(buf), "PhysX %s (%zu colliders)",
                                                 targetVisible ? "可见" : "遮挡",
                                                 debugColliders.size());
                                        DrawText(std::string(buf), ImVec2(BoxTopLeft.X, BoxTopLeft.Y - 18), false, IM_COL32(255, 255, 255, 255), false, 11);
                                    } else if (occlusionState.valid) {
                                        // 回退模式: 显示渲染时间
                                        long gameStateD = KFD::Read<long>(GWorld + kGameState);
                                        char buf[160];
                                        snprintf(buf, sizeof(buf), "gw=0x%llx t=%.2f r=%.2f d=%.2f %s",
                                                 (unsigned long long)gameStateD,
                                                 occlusionState.worldTime,
                                                 occlusionState.renderTime,
                                                 occlusionState.delta,
                                                 targetVisible ? "可见" : "遮挡");
                                        DrawText(std::string(buf), ImVec2(BoxTopLeft.X, BoxTopLeft.Y - 18), false, IM_COL32(255, 255, 255, 255), false, 11);
                                    }
                                }
                                DrawCurrentPlayerOverlay(ImVec2(BoxTopLeft.X, BoxTopLeft.Y),
                                                         ImVec2(BoxBottomRight.X, BoxBottomRight.Y));
                            }
                        }
                    }
           
            
        }
        if (!playerOverlayDrawn) {
            DrawCurrentPlayerOverlay(defaultBoxMin, defaultBoxMax);
        }
        
        // 骨骼绘制（按 Skeleton.BoneTree 父子关系连线，避免乱线）
        if(骨骼){
            if (distance > 500.0f) {
                // 超过500米不绘制骨骼
            } else {
                long MeshComponent = KFD::Read<long>(player + kMesh);
                if (KFD::地址泄露(MeshComponent)) {
                    FTransform ComponentToWorld;
                    long ComponentToWorldAddr = MeshComponent + kComponentToWorld;
                    ComponentToWorld.Rotation.x = KFD::Read<float>(ComponentToWorldAddr + 0x0);
                    ComponentToWorld.Rotation.y = KFD::Read<float>(ComponentToWorldAddr + 0x4);
                    ComponentToWorld.Rotation.z = KFD::Read<float>(ComponentToWorldAddr + 0x8);
                    ComponentToWorld.Rotation.w = KFD::Read<float>(ComponentToWorldAddr + 0xC);
                    ComponentToWorld.Translation.X = KFD::Read<float>(ComponentToWorldAddr + 0x10);
                    ComponentToWorld.Translation.Y = KFD::Read<float>(ComponentToWorldAddr + 0x14);
                    ComponentToWorld.Translation.Z = KFD::Read<float>(ComponentToWorldAddr + 0x18);
                    ComponentToWorld.Scale3D.X = KFD::Read<float>(ComponentToWorldAddr + 0x20);
                    ComponentToWorld.Scale3D.Y = KFD::Read<float>(ComponentToWorldAddr + 0x24);
                    ComponentToWorld.Scale3D.Z = KFD::Read<float>(ComponentToWorldAddr + 0x28);
                    
                    if (ComponentToWorld.Scale3D.X == 0.0f && ComponentToWorld.Scale3D.Y == 0.0f && ComponentToWorld.Scale3D.Z == 0.0f) {
                    } else {
                    ImU32 boneDrawColor = targetVisible ? IM_COL32(0, 255, 0, 255) : IM_COL32(255, 128, 0, 255);
                    DrawLimbSkeleton(MeshComponent, ComponentToWorld, boneDrawColor);
                    }
                }
            }
        }
      
        if(手持){
            
            
            
            
            
                ImVec2 手持图片大小(60, 30);
                ImVec2 手持武器位置(dx - 手持图片大小.x *0.1 +10 , dy - 53);
            ImU32 手持图片颜色 = ImColor(0.2f, 1.0f, 1.0f, 0.5f);
                ImVec2 is_Pos(手持武器位置.x + 手持图片大小.x, 手持武器位置.y + 手持图片大小.y);
                ImVec2 is1(0,0);
                ImVec2 is2(1,1);
            
            
            
                // 绘制图标
            
            if(Health1==0){
                绘制图形->AddImage((__bridge ImTextureID)daodi, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
        
            
            
                }else{
                    
                    
                    switch (chiqiang) {
                        case 0: {
            
                              绘制图形->AddImage((__bridge ImTextureID)quan, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
            
            
                            break;
                        }
            
                        case 101010: {
            
                        绘制图形->AddImage((__bridge ImTextureID)chi101010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
            
                            break;
                        }
                        case 101001: {
            
                            绘制图形->AddImage((__bridge ImTextureID)chi101001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
            
            
                        case 101002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101007: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101007, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101008: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101008, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101009: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101009, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101011: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101011, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101012: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101012, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 101013: {
                            绘制图形->AddImage((__bridge ImTextureID)chi101013, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102007: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102007, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102008: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102008, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 102105: {
                            绘制图形->AddImage((__bridge ImTextureID)chi102105, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103007: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103007, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103008: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103008, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103009: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103009, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103010: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103011: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103011, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103012: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103012, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103013: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103013, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103014: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103014, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103015: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103015, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103016: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103016, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 103100: {
                            绘制图形->AddImage((__bridge ImTextureID)chi103100, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 104100: {
                            绘制图形->AddImage((__bridge ImTextureID)chi104100, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 105001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi105001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 105002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi105002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 105010: {
                            绘制图形->AddImage((__bridge ImTextureID)chi105010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 105012: {
                            绘制图形->AddImage((__bridge ImTextureID)chi105012, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 105013: {
                            绘制图形->AddImage((__bridge ImTextureID)chi105013, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106007: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106007, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106008: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106008, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106010: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106011: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106011, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 106094: {
                            绘制图形->AddImage((__bridge ImTextureID)chi106094, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107007: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107007, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107008: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107008, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107010: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 107909: {
                            绘制图形->AddImage((__bridge ImTextureID)chi107909, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108000: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108000, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 108010: {
                            绘制图形->AddImage((__bridge ImTextureID)chi108010, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
            
                        case 501002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi501002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 501003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi501003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 501005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi501005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 501006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi501006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 502002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi502002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 502003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi502003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 502005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi502005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 503002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi503002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 503003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi503003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 601001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi601001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 601003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi601003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 601005: {
                            绘制图形->AddImage((__bridge ImTextureID)chi601005, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 601006: {
                            绘制图形->AddImage((__bridge ImTextureID)chi601006, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602001: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602001, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602002: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602002, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602003: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602003, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602004: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602004, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602009: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602009, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
                        case 602075: {
                            绘制图形->AddImage((__bridge ImTextureID)chi602075, 手持武器位置, is_Pos, is1, is2, 手持图片颜色);
                            break;
                        }
            
            
                        default:
            
                            break;
                    }
                }
            
            

            
        }
     
        
    }else{
        
        if(背敌){
            float lateralAngleView = KFD::Read<float>( PlayerController + 0x5a8 + 0x4) - 90.0f;//Rotator ControlRotation;
            float angle = lateralAngleView - rotateAngle(LocationWorldPos, POV.Location); // 敌人相对角

            // —— 方向向量（单位）——
            ImVec2 dir  = rotateCoord(angle,       ImVec2(1.0f, 0.0f));
            ImVec2 perp = rotateCoord(angle + 90., ImVec2(1.0f, 0.0f));

            // —— 与屏幕矩形求交，落在四周边缘 ——
            const float cx = 屏幕宽度  * 0.5f;
            const float cy = 屏幕高度 * 0.5f;
            const float margin = 12.0f;
            const float left   = margin;
            const float right  = 屏幕宽度  - margin;
            const float top    = margin;
            const float bottom = 屏幕高度 - margin;

            float tx = 1e30f, ty = 1e30f;
            if (fabsf(dir.x) > 1e-4f) tx = (dir.x > 0.0f) ? (right  - cx) / dir.x : (left - cx) / dir.x;
            if (fabsf(dir.y) > 1e-4f) ty = (dir.y > 0.0f) ? (bottom - cy) / dir.y : (top  - cy) / dir.y;

            float t = ImMin((tx > 0.0f ? tx : 1e30f), (ty > 0.0f ? ty : 1e30f));
            ImVec2 edgePos(cx + dir.x * t, cy + dir.y * t);

            // 往里缩一点，别压在边线上
            const float inset = 10.0f;
            edgePos.x -= dir.x * inset;
            edgePos.y -= dir.y * inset;

            // —— 颜色&尺寸随距离变化（近→红；远→蓝；半透明）——
            // 距离映射：nearD ~ farD 线性归一化到 0..1
            const float nearD = 0.0f;    // 近距离下限（按你项目的实际单位可调）
            const float farD  = 500.0f;  // 远距离上限（越远越偏蓝）
            float tDist = (distance - nearD) / (farD - nearD);
            tDist = ImClamp(tDist, 0.0f, 1.0f);

            // HSV：h 0.0=红 -> 0.66=蓝；更“彩”就让饱和度高一点
            float hue = (1.0f - tDist) * 0.00f + tDist * 0.66f; // 红→橙→黄→绿→青→蓝
            ImU32  colFill   = ImColor::HSV(hue, 0.95f, 1.00f, 0.55f); // 半透明填充
            ImU32  colStroke = ImColor::HSV(hue, 0.90f, 0.95f, 0.95f); // 轮廓更清晰

            // 半径也轻微跟随距离（近大远小，可选）
            const float R_near = 16.0f;
            const float R_far  = 10.0f;
            float R = R_near + (R_far - R_near) * tDist;

            // —— 画“半透明圆点” + 微光晕 ——
            绘制图形->AddCircleFilled(edgePos, R, colFill, 24);
            绘制图形->AddCircle(edgePos, R, colStroke, 24, 2.0f);

            // 柔和外圈（可选，营造发光感）
            绘制图形->AddCircle(edgePos, R + 3.0f, ImColor::HSV(hue, 0.6f, 1.0f, 0.22f), 24, 1.5f);
            绘制图形->AddCircle(edgePos, R + 6.0f, ImColor::HSV(hue, 0.6f, 1.0f, 0.10f), 24, 1.0f);
            // —— 中心显示米数 ——
            char buf[16];
            int m = (int)ImFloor(distance + 0.5f);               // 四舍五入
            m = (int)ImClamp((float)m, 0.0f, 9999.0f);           // 限个上限，避免太长
            snprintf(buf, sizeof(buf), "%dm", m);

            // 字号随半径调整（近大远小）
            float fontSize = ImClamp(R * 0.9f, 10.0f, 24.0f);

            // 居中摆放
            ImFont* font = ImGui::GetFont();
            ImVec2 ts = font->CalcTextSizeA(fontSize, FLT_MAX, 0.0f, buf);
            ImVec2 tp(edgePos.x - ts.x * 0.5f, edgePos.y - ts.y * 0.5f);

            // 黑色描边（八向阴影），增强可读性
            ImU32 outline = IM_COL32(0, 0, 0, 180);
            for (int dx = -1; dx <= 1; ++dx)
            for (int dy = -1; dy <= 1; ++dy)
                if (dx || dy)
                    绘制图形->AddText(font, fontSize, ImVec2(tp.x + dx, tp.y + dy), outline, buf);

            // 白色实字
            绘制图形->AddText(font, fontSize, tp, IM_COL32(255, 255, 255, 240), buf);
        }
        // 背后射线已移除
        
        
      
    }
    
}



void 读取()
{
   
    totalEnemies=0;
    totalAIEnemies=0;
    totalRealEnemies=0;
    更新游戏世界实时调试("Init", "none", 0, 0, 0, 0, 0);

    // 每帧重置 SystemHelper 识别标记
    gTEHasAuthorThisMatch = false;
    gTEHasUserThisMatch   = false;

    // 定期上报心跳，保持"最近在线用户"列表与识别状态
    TESendHeartbeatIfNeeded();

    // 内核离线时自动重试（每 3 秒一次，游戏可能后启动）
    if (!内核) {
        static NSTimeInterval sLastKernelRetry = 0;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now - sLastKernelRetry >= 3.0) {
            sLastKernelRetry = now;
            SHRenderView *drawer = [SHRenderView sharedInstance];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [drawer InitializeClient];
            });
        }
    }
    
    tDistance = 0;
    needAdjustAim = false;
    markDistance = 屏幕宽度;
    Vector2 屏幕中心;
    屏幕中心.X= 屏幕宽度/2;
    屏幕中心.Y=屏幕高度/2;
    markScreenPos= 屏幕中心;
    
    
    打击点屏幕坐标 = 屏幕中心;
   
    
    
    if (!内核) {
        static NSTimeInterval sLastOfflineLog = 0;
        NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
        if (t - sLastOfflineLog >= 5.0) {
            sLastOfflineLog = t;
            写日志(@"[游戏世界] 内核离线，自动重试中...");
        }
        设置游戏世界诊断("E01", "内核未连接", "等待驱动重连，可返回桌面后重进游戏");
        更新游戏世界实时调试("KernelOffline", "none", 0, 0, 0, 0, 0);
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }
    
    写日志(@"========== 开始读取游戏世界数据 ==========");
    uint64_t baseAddr = KFD::S().base; // 从KFD获取基地址
    写日志(@"[游戏世界] 当前基地址: 0x%llx", (unsigned long long)baseAddr);
    
    if (baseAddr == 0) {
        写日志(@"[游戏世界] ❌ 基地址为 0，无法读取游戏世界");
        设置游戏世界诊断("E02", "基址未就绪", "目标模块尚未完成装载，请先进入对局内");
        更新游戏世界实时调试("BaseZero", "none", 0, 0, 0, 0, 0);
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }

    // ====== 王者荣耀模式：使用 IL2CPP 路径读取 ActorManager ======
    if (SHGetSelectedGameType() == SHGameTypeSMoba) {
        g_smobaMode = true;
        写日志(@"========== 王者荣耀模式 ==========");
        g_smobaResult = Smoba_ReadActorManager();
        if (g_smobaResult.valid) {
            写日志(@"[王者荣耀] ✓ 读取 %zu 个英雄, ActorManager=0x%llx, 本地Camp=%d",
                 g_smobaResult.actors.size(),
                 (unsigned long long)g_smobaResult.actorManagerAddr,
                 g_smobaResult.localPlayerCamp);

            // 读取第一个英雄作为本地玩家参考位置
            if (!g_smobaResult.actors.empty()) {
                const auto &local = g_smobaResult.actors[0];
                s_radarLocalPos = {(float)local.x, (float)local.y, (float)local.z};

                // 收集其他英雄的雷达位置 (所有非本地英雄)
                s_radarEnemyWorldPos.clear();
                for (size_t i = 1; i < g_smobaResult.actors.size(); i++) {
                    s_radarEnemyWorldPos.push_back({
                        (float)g_smobaResult.actors[i].x,
                        (float)g_smobaResult.actors[i].y,
                        (float)g_smobaResult.actors[i].z
                    });
                }
            }

            // 设置相机数据用于 WorldToScreen
            if (g_smobaResult.camera.valid) {
                s_radarPOV.Location = {
                    (float)g_smobaResult.camera.posX,
                    (float)g_smobaResult.camera.posY,
                    (float)g_smobaResult.camera.posZ
                };
                // 计算相机旋转: 从相机指向注视点的方向
                float dx = g_smobaResult.camera.lookX - g_smobaResult.camera.posX;
                float dy = g_smobaResult.camera.lookY - g_smobaResult.camera.posY;
                float dz = g_smobaResult.camera.lookZ - g_smobaResult.camera.posZ;
                float len = sqrtf(dx*dx + dy*dy + dz*dz);
                if (len > 0.001f) {
                    // UE4 坐标系 Z=up, 但 Unity Y=up
                    // 映射: UE4.X = Unity.Z, UE4.Y = Unity.X, UE4.Z = Unity.Y
                    float ue4DirX = dz / len;  // Unity Z → UE4 X
                    float ue4DirY = dx / len;  // Unity X → UE4 Y
                    float ue4DirZ = dy / len;  // Unity Y → UE4 Z
                    s_radarPOV.Rotation.Yaw = atan2f(ue4DirY, ue4DirX) * 180.0f / (float)M_PI;
                    s_radarPOV.Rotation.Pitch = asinf(ue4DirZ) * 180.0f / (float)M_PI;
                    s_radarPOV.Rotation.Roll = 0;
                }
                s_radarPOV.FOV = g_smobaResult.camera.fov;

                if (g_smobaResult.camera.estimated) {
                    写日志(@"[王者荣耀] 相机使用估算位置 (未找到 Camera 组件实例)");
                } else {
                    写日志(@"[王者荣耀] ✓ 找到 Camera 实例 @ 0x%llx, FOV=%.1f",
                         (unsigned long long)g_smobaResult.camera.cameraAddr,
                         g_smobaResult.camera.fov);
                }
            }

            清空游戏世界诊断();
        } else {
            写日志(@"[王者荣耀] ❌ 读取失败");
            设置游戏世界诊断("S01", "ActorManager 读取失败",
                     string_format("请确认已进入对局内, ufBase=0x%llx",
                                   (unsigned long long)g_smobaResult.unityFrameworkBase));
        }
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return; // 跳过 UE4 管道
    }
    g_smobaMode = false;

    uint64_t hintedGWorldVA = ResolveRuntimeHintVA(baseAddr, kUWorld);
    uint64_t hintedGWorld = StripRuntimePAC(KFD::Read<uint64_t>(hintedGWorldVA));
    RuntimeWorldProbeResult worldProbe;
    uint64_t resolvedUWorldOffset = ResolveRuntimeUWorldOffset(baseAddr, kUWorld, &worldProbe);
    const RuntimeWorldLayout *resolvedWorldLayout = FindRuntimeWorldLayoutByName(worldProbe.layoutName);
    std::string worldProbeSource = RuntimeWorldProbeSourceString(worldProbe);
    更新游戏世界实时调试("ResolveUWorld",
                  worldProbeSource,
                  resolvedUWorldOffset,
                  worldProbe.gWorld,
                  worldProbe.level,
                  worldProbe.actorArray,
                  worldProbe.actorCount);
    if (resolvedUWorldOffset == 0) {
        写日志(@"[游戏世界] ❌ 未找到有效 UWorld，固定偏移原始读取: 0x%llx", (unsigned long long)hintedGWorld);
        设置游戏世界诊断("E03", "UWorld 未匹配",
                 string_format("hint=0x%llx raw=0x%llx src=%s",
                               (unsigned long long)kUWorld,
                               (unsigned long long)hintedGWorld,
                               worldProbeSource.c_str()));
        更新游戏世界实时调试("UWorldMiss", "none", 0, hintedGWorld, 0, 0, 0);
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }

    uint64_t gWorldVA = ResolveRuntimeHintVA(baseAddr, resolvedUWorldOffset);
    写日志(@"[游戏世界] 使用 UWorld 偏移: 0x%llx", (unsigned long long)resolvedUWorldOffset);
    写日志(@"[游戏世界] 计算 gWorldVA = 基地址(0x%llx) + 0x%llx = 0x%llx", (unsigned long long)baseAddr, (unsigned long long)resolvedUWorldOffset, (unsigned long long)gWorldVA);

    写日志(@"[游戏世界] 读取 gWorld 指针...");
    uint64_t gWorld = worldProbe.gWorld ? worldProbe.gWorld : StripRuntimePAC(KFD::Read<uint64_t>(gWorldVA));
    写日志(@"[游戏世界] gWorld 读取结果: 0x%llx", (unsigned long long)gWorld);
    更新游戏世界实时调试("ReadGWorld",
                  worldProbeSource,
                  resolvedUWorldOffset,
                  gWorld,
                  worldProbe.level,
                  worldProbe.actorArray,
                  worldProbe.actorCount);

    if (!LooksLikeUserVA(gWorld)) {
        写日志(@"[游戏世界] ❌ gWorld 无效，固定偏移原始读取: 0x%llx", (unsigned long long)hintedGWorld);
        设置游戏世界诊断("E03", "世界对象无效", string_format("offset=0x%llx gWorld=0x%llx", (unsigned long long)resolvedUWorldOffset, (unsigned long long)gWorld));
        更新游戏世界实时调试("InvalidGWorld", "none", resolvedUWorldOffset, gWorld, 0, 0, 0);
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }
    写日志(@"[游戏世界] ✓ gWorld 有效: 0x%llx", (unsigned long long)gWorld);
    写日志(@"[游戏世界] World探测来源: %s layout=%s source=%s field=0x%llx",
         worldProbeSource.c_str(),
         worldProbe.layoutName ? worldProbe.layoutName : "none",
         worldProbe.worldSource ? worldProbe.worldSource : "none",
         (unsigned long long)worldProbe.scannedFieldOffset);

    // —— PhysX 碰撞体数据提取（用于掩体判断） ——
    PhysXColliderExtractor::ExtractIfNeeded();

    写日志(@"[游戏世界] 读取 Level（PersistentLevel / CurrentLevel 回退）...");
    uint64_t PersistentLevel = LooksLikeUserVA(worldProbe.level) ? worldProbe.level : 读取有效Level(gWorld, resolvedWorldLayout);
    写日志(@"[游戏世界] PersistentLevel: 0x%llx", (unsigned long long)PersistentLevel);
    写日志(@"[游戏世界] Level候选: P=0x%llx C=0x%llx V=0x%llx 选中=%s",
         (unsigned long long)gLastLevelDiag.persistentLevel,
         (unsigned long long)gLastLevelDiag.currentLevel,
         (unsigned long long)gLastLevelDiag.pendingVisibilityLevel,
         gLastLevelDiag.chosenSource);
    更新游戏世界实时调试("ReadLevel",
                  worldProbeSource,
                  resolvedUWorldOffset,
                  gWorld,
                  PersistentLevel,
                  worldProbe.actorArray,
                  worldProbe.actorCount);
    
    if (PersistentLevel == 0 && !LooksLikeUserVA(worldProbe.actorArray)) {
        写日志(@"[游戏世界] ❌ PersistentLevel 为 0");
        设置游戏世界诊断("E04", "场景层未就绪", Level诊断摘要(gLastLevelDiag));
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }
    if (PersistentLevel != 0) {
        写日志(@"[游戏世界] ✓ PersistentLevel 有效: 0x%llx", (unsigned long long)PersistentLevel);
    } else {
        写日志(@"[游戏世界] ⚠️ PersistentLevel 为 0，直接使用预探测 ActorArray");
    }
    
    写日志(@"[游戏世界] 读取 ActorArray (Level->ActorCluster->Actors)...");
    uint64_t ActorArray = LooksLikeUserVA(worldProbe.actorArray) ? worldProbe.actorArray : 0;
    int ActorCount = worldProbe.actorCount;
    uint64_t ActorCluster = 0;
    std::string actorArraySource = !worldProbeSource.empty() ? worldProbeSource : "none";
    bool 使用LevelActor数组 = LooksLikeUserVA(ActorArray) && ActorCount > 0;
    if (!使用LevelActor数组 && PersistentLevel != 0) {
        使用LevelActor数组 = 读取LevelActor数组(PersistentLevel, &ActorArray, &ActorCount, &ActorCluster, resolvedWorldLayout);
        actorArraySource = 使用LevelActor数组 ? string_format("LevelActorContainer/%s",
                                                         resolvedWorldLayout && resolvedWorldLayout->name ? resolvedWorldLayout->name : "layout") : actorArraySource;
    }
    if (!使用LevelActor数组) {
        写日志(@"[游戏世界] LevelActorContainer 读取失败，回退 World.ActiveLevelActors...");
        if (读取世界Actor数组(gWorld, &ActorArray, &ActorCount, resolvedWorldLayout)) {
            actorArraySource = string_format("ActiveLevelActors/%s",
                                             resolvedWorldLayout && resolvedWorldLayout->name ? resolvedWorldLayout->name : "layout");
            使用LevelActor数组 = true;
        }
    }
    写日志(@"[游戏世界] ActorArray: 0x%llx", (unsigned long long)ActorArray);
    更新游戏世界实时调试("ReadActorArray", actorArraySource, resolvedUWorldOffset, gWorld, PersistentLevel, ActorArray, ActorCount);
    
    if (ActorArray == 0) {
        写日志(@"[游戏世界] ❌ ActorArray 为 0");
        设置游戏世界诊断("E05", "实体列表为空",
                 string_format("%s Level=0x%llx Arr=0x%llx Count=%d",
                               gLastLevelDiag.chosenSource,
                               (unsigned long long)gLastLevelDiag.chosenLevel,
                               (unsigned long long)gLastLevelDiag.chosenActorArray,
                               gLastLevelDiag.chosenActorCount));
        绘制游戏世界实时调试();
        绘制游戏世界诊断();
        return;
    }
    写日志(@"[游戏世界] ✓ ActorArray 有效: 0x%llx", (unsigned long long)ActorArray);
    清空游戏世界诊断();
    
    写日志(@"[游戏世界] ActorCluster: 0x%llx", (unsigned long long)ActorCluster);
    写日志(@"[游戏世界] 读取 ActorCount (ActorCluster + 0x%llx + 0x8)...", (unsigned long long)kLevelActorContainerActors);
    写日志(@"[游戏世界] ActorCount: %d", ActorCount);
    uint64_t resolvedGNamesUName = 0;
    std::string sampleName;
    uint64_t resolvedGNamesOffset = 解析GNames偏移(baseAddr, ActorArray, ActorCount, kGNames, &resolvedGNamesUName, &sampleName);
    int activeWorldActorCountForDebug = 0;
    int levelsCountForDebug = 0;
    int bestLevelsActorCountForDebug = 0;

    if (resolvedGNamesUName != 0) {
        struct 候选Actor数组 {
            uint64_t actorArray = 0;
            int actorCount = 0;
            uint64_t level = 0;
            std::string source = "none";
        };

        候选Actor数组 bestCandidate = { ActorArray, ActorCount, PersistentLevel, actorArraySource.c_str() };
        ActorArrayPlayerProbeResult bestProbe = {};
        int bestScore = 探测Actor数组人物得分(ActorArray, ActorCount, resolvedGNamesUName, &bestProbe);

        auto 尝试候选 = [&](uint64_t candidateArray,
                        int candidateCount,
                        uint64_t candidateLevel,
                        const std::string &candidateSource) {
            ActorArrayPlayerProbeResult candidateProbe = {};
            int score = 探测Actor数组人物得分(candidateArray, candidateCount, resolvedGNamesUName, &candidateProbe);
            写日志(@"[游戏世界] 候选数组[%s] Arr=0x%llx Count=%d Score=%d Class=%d Name=%d SampleClass=%s SampleName=%s",
                 candidateSource.c_str(),
                 (unsigned long long)candidateArray,
                 candidateCount,
                 score,
                 candidateProbe.playerClassCount,
                 candidateProbe.playerNameCount,
                 candidateProbe.sampleClassName.c_str(),
                 candidateProbe.sampleObjectName.c_str());
            if (score > bestScore) {
                bestScore = score;
                bestCandidate = { candidateArray, candidateCount, candidateLevel, candidateSource };
                bestProbe = candidateProbe;
            }
        };

        uint64_t activeActorArray = 0;
        int activeActorCount = 0;
        if (读取世界Actor数组(gWorld, &activeActorArray, &activeActorCount, resolvedWorldLayout)) {
            activeWorldActorCountForDebug = activeActorCount;
            尝试候选(activeActorArray, activeActorCount, PersistentLevel,
                  string_format("ActiveLevelActors/%s",
                                resolvedWorldLayout && resolvedWorldLayout->name ? resolvedWorldLayout->name : "layout").c_str());
        }

        uint64_t levelsArray = 0;
        int levelsCount = 0;
        if (ResolveLevelsArrayFromWorld(gWorld, &levelsArray, &levelsCount, resolvedWorldLayout)) {
            levelsCountForDebug = levelsCount;
            int scanLevels = levelsCount > 128 ? 128 : levelsCount;
            for (int i = 0; i < scanLevels; ++i) {
                uint64_t level = StripRuntimePAC(KFD::Read<uint64_t>(levelsArray + (uint64_t)i * 0x8));
                uint64_t levelActorArray = 0;
                int levelActorCount = 0;
                if (!读取LevelActor数组(level, &levelActorArray, &levelActorCount, nullptr, resolvedWorldLayout)) {
                    continue;
                }
                if (levelActorCount > bestLevelsActorCountForDebug) {
                    bestLevelsActorCountForDebug = levelActorCount;
                }
                尝试候选(levelActorArray, levelActorCount, level,
                      string_format("LevelsArray/%s",
                                    resolvedWorldLayout && resolvedWorldLayout->name ? resolvedWorldLayout->name : "layout").c_str());
            }
        }

        if (bestScore > 0 &&
            (bestCandidate.actorArray != ActorArray || bestCandidate.actorCount != ActorCount || actorArraySource != bestCandidate.source)) {
            写日志(@"[游戏世界] 切换到更优数组: %s Arr=0x%llx Count=%d",
                 bestCandidate.source.c_str(),
                 (unsigned long long)bestCandidate.actorArray,
                 bestCandidate.actorCount);
            ActorArray = bestCandidate.actorArray;
            ActorCount = bestCandidate.actorCount;
            PersistentLevel = bestCandidate.level ? bestCandidate.level : PersistentLevel;
            actorArraySource = bestCandidate.source;
            sampleName = bestProbe.sampleObjectName.empty() ? sampleName : bestProbe.sampleObjectName;
        }

        // 如果当前仍停留在小规模 LevelActorContainer，优先回退到更大的活动层数组，
        // 避免把地图静态分块误当成主枚举源。
        if (actorArraySource.find("LevelActorContainer") != std::string::npos && ActorCount > 0 && ActorCount < 64) {
            uint64_t fallbackActorArray = 0;
            int fallbackActorCount = 0;
            if (读取世界Actor数组(gWorld, &fallbackActorArray, &fallbackActorCount, resolvedWorldLayout) &&
                fallbackActorCount > ActorCount) {
                写日志(@"[游戏世界] 小规模 LevelActorContainer(%d) 回退到 ActiveLevelActors(%d)",
                     ActorCount,
                     fallbackActorCount);
                ActorArray = fallbackActorArray;
                ActorCount = fallbackActorCount;
                actorArraySource = string_format("ActiveLevelActors/%s",
                                                 resolvedWorldLayout && resolvedWorldLayout->name ? resolvedWorldLayout->name : "layout");
            }
        }
    }
    更新游戏世界实时调试("EnumeratingActors", actorArraySource, resolvedUWorldOffset, gWorld, PersistentLevel, ActorArray, ActorCount, resolvedGNamesOffset, sampleName);
    gWorldLiveDebugState.activeWorldActorCount = activeWorldActorCountForDebug;
    gWorldLiveDebugState.levelsCount = levelsCountForDebug;
    gWorldLiveDebugState.bestLevelsActorCount = bestLevelsActorCountForDebug;
    if (ActorCount > 0 && ActorCount < 50000) {
        写日志(@"[游戏世界] ✓ ActorCount 有效范围，开始遍历 %d 个 Actor", ActorCount);
        static int loopCount = 0;
        loopCount++;
        if (loopCount % 60 == 0) {  // 每60帧输出一次
            写日志(@"[游戏世界] 第 %d 次循环，处理 %d 个 Actor", loopCount, ActorCount);
        }
        
        int playerCount = 0;
        int playerNameMatches = 0;
        int playerClassMatches = 0;
        int playerStructMatches = 0;
        int debugRayCount = DrawAllActorDebugRays(ActorArray, ActorCount, POV);
        std::string classSampleName;
        std::string structSampleActorInfo;
        s_radarEnemyWorldPos.clear();
        long NetDriverR = KFD::Read<long>(gWorld + kNetDriver);
        long ServerConnectionR = KFD::Read<long>(NetDriverR + kServerConnection);
        long PlayerControllerR = KFD::Read<long>(ServerConnectionR + klocalPlayerController);
        long CharacterForRadar = KFD::Read<long>(PlayerControllerR + kPawn);
        long PlayerCameraManagerR = KFD::Read<long>(PlayerControllerR + kPlayerCameraManager);
        s_radarPOV = KFD::Read<CoViewbyo>(PlayerCameraManagerR + kViewTarget + 0x10);
        if (KFD::地址泄露(CharacterForRadar)) s_radarLocalPos = GetRelativeLocation(CharacterForRadar);
        for (int i = 0; i < ActorCount; i++) {
            long actor = KFD::Read<long>(ActorArray + i * 8);
            if (actor == 0) continue;
            
            std::string FName = resolvedGNamesUName ? GetFName(actor, resolvedGNamesUName) : GetFName(actor, 基地址, kGNames);
            std::string className = resolvedGNamesUName ? GetObjectClassName(actor, resolvedGNamesUName) : "";
            
            if (loopCount % 60 == 0 && i < 10) {  // 前10个Actor输出详细信息
                写日志(@"[游戏世界] Actor[%d]: 0x%llx, FName: %s, Class: %s",
                     i,
                     (unsigned long long)actor,
                     FName.c_str(),
                     className.c_str());
            }
            
            Vector3 演员位置 = GetRelativeLocation(actor);
            Vector2 演员屏幕 = WorldToScreen(演员位置, POV, 屏幕宽度, 屏幕高度);
            
            bool isPlayerByName = KFD::isContain(FName, "PlayerPawn") ||
                                  KFD::isContain(FName, "PlayerCharacter") ||
                                  KFD::isContain(FName, "PlayerControllertSl") ||
                                  (人机 && KFD::isContain(FName, "BPPawn")) ||
                                  KFD::isContain(FName, "CharacterModelTaget") ||
                                  KFD::isContain(FName, "FakePlayer_AIPawn");
            bool isPlayerByClass = KFD::isContain(className, "STExtraPlayerCharacter") ||
                                   KFD::isContain(className, "PlayerPawn") ||
                                   KFD::isContain(className, "PlayerCharacter") ||
                                   KFD::isContain(className, "BP_Character") ||
                                   KFD::isContain(className, "BPPawn") ||
                                   KFD::isContain(className, "FakePlayer_AIPawn");
            bool isAIByName = KFD::isContain(FName, "FakePlayer_AIPawn") ||
                              KFD::isContain(FName, "BPPawn") ||
                              KFD::isContain(FName, "CharacterModelTaget");
            bool isAIByClass = KFD::isContain(className, "FakePlayer_AIPawn") ||
                               KFD::isContain(className, "BPPawn");
            bool isPlayerByStruct = false;
            bool isAIByStruct = false;
            std::string structDebugInfo;
            // 始终保留结构体兜底，避免赛季更新后名字/类名匹配失效时把真人和人机全过滤掉。
            if (!isPlayerByName && !isPlayerByClass) {
                isPlayerByStruct = IsStructLikePlayerActor(actor, CharacterForRadar, &isAIByStruct, &structDebugInfo);
                if (isPlayerByStruct && structSampleActorInfo.empty()) {
                    structSampleActorInfo = structDebugInfo;
                }
            }
            if ((isPlayerByClass || isPlayerByName) && classSampleName.empty()) {
                classSampleName = className;
            }
            bool isPlayer = isPlayerByName || isPlayerByClass || isPlayerByStruct;
            
            if (isPlayer) {
                if (actor == CharacterForRadar) {
                    continue; // 跳过自己
                }
                
                playerCount++;
                if (isPlayerByName) playerNameMatches++;
                if (isPlayerByClass) playerClassMatches++;
                if (isPlayerByStruct) playerStructMatches++;
                if (loopCount % 60 == 0) {
                    写日志(@"[游戏世界] 找到玩家 Actor[%d]: 0x%llx, FName: %s, Class: %s, Struct: %s",
                         i,
                         (unsigned long long)actor,
                         FName.c_str(),
                         className.c_str(),
                         structDebugInfo.c_str());
                }
                读取数据(gWorld, actor, isAIByName || isAIByClass || isAIByStruct);
            }
        }
        更新人物筛选实时调试(playerCount, playerNameMatches, playerClassMatches, playerStructMatches, debugRayCount, classSampleName, structSampleActorInfo);
        
        // 继续处理其他Actor（物资等）
        for (int i = 0; i < ActorCount; i++) {
            long actor = KFD::Read<long>(ActorArray + i * 8);
            if (actor == 0) continue;
            
            std::string FName = resolvedGNamesUName ? GetFName(actor, resolvedGNamesUName) : GetFName(actor, 基地址, kGNames);
            
            Vector3 wuziWorldPos = GetRelativeLocation(actor);
            Vector2 LocationScreen = WorldToScreen(wuziWorldPos, POV, 屏幕宽度, 屏幕高度);
            float wuzijuli = GetDistance(wuziWorldPos, POV.Location) / 100;
            
            float xd = LocationScreen.X;
            float yd = LocationScreen.Y;
            
            
            // 计算屏幕比例，假设大于 1000px 的屏幕为桌面设备，小于 1000px 的屏幕为手机设备
            bool isMobile =YES; // 判断是否为手机设备
            ImVec2 图片高度(isMobile ? ImVec2(20, 20) : ImVec2(30, 30));
            ImVec2 IcPos(xd, yd+ (isMobile ?20:0));
            ImVec2 图片位置(IcPos.x - 图片高度.x / 2, IcPos.y + 图片高度.y / 2);
            ImVec2 图片大小(图片位置.x + 图片高度.x, 图片位置.y + 图片高度.y);
            
            
            // 添加背景
            float 半径 = isMobile ? 10 : 15;
            ImU32 背景色 = IM_COL32(200, 200, 200, 70);
            ImU32 背景色1 = IM_COL32(200, 200, 200, 110);// 淡粉色背景 // 原色背景，可以自定义颜色 (RGBA)
            
            
            ImVec2 文本位置(xd, yd + (isMobile ? 60 : 80));
            float 矩形宽度 = isMobile ? 20 : 60;  // 手机上稍小一点
            float 矩形高度 = isMobile ? 10 : 25; // 矩形高度稍低一些
            float 文本大小 = isMobile ? 4.5 : 13;
            ImVec2 矩形位置(xd-(isMobile ? 11 : 30), yd+(isMobile ? 55 : 67));
            
            ImU32 背景颜色 = IM_COL32(0, 0, 0, 100);  // 黑色背景
            
          
            
            if(武器){
                if (KFD::isContain(FName , "BP_Rifle_AUG_Wrapper_C")){
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_AUG_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_AUG_Wrapper_C);
                }
                
            }
            if(药品){
                if (KFD::isContain(FName, "FirstAidbox_Pickup_C")) { /// 医疗箱
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)FirstAidbox_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,FirstAidbox_Pickup_C);
                }
                
                if (KFD::isContain(FName, "Firstaid_Pickup_C")) { /// 急救包
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Firstaid_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Firstaid_Pickup_C);
                }
                
                if (KFD::isContain(FName, "Pills_Pickup_C")) { /// 止痛药
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Pills_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Pills_Pickup_C);
                }
                
                if (KFD::isContain(FName, "Drink_Pickup_C")) { /// 饮料
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Drink_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Drink_Pickup_C);
                }
                
                if (KFD::isContain(FName, "Injection_Pickup_C")) { /// 肾上腺素
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Injection_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Injection_Pickup_C);
                }
            }
            if(防具){
                if (KFD::isContain(FName, "Helmet_Lv3")) { /// 三级头
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Helmet_Lv3, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Helmet_Lv3);
                }
                
                if (KFD::isContain(FName, "PickUp_BP_Helmet_Lv3_A_C")) { /// 三级头_1
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)PickUp_BP_Helmet_Lv3_A_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,PickUp_BP_Helmet_Lv3_A_C);
                }
                
                if (KFD::isContain(FName, "PickUp_BP_Helmet_Lv3_B_C")) { /// 三级头_2
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)PickUp_BP_Helmet_Lv3_B_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,PickUp_BP_Helmet_Lv3_B_C);
                }
                
                if (KFD::isContain(FName, "Bag_Lv3")) { /// 三级包
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Bag_Lv3, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Bag_Lv3);
                }
                
                
                
                if (KFD::isContain(FName, "Armor_Lv3")) { /// 三级甲
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Armor_Lv3, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,Armor_Lv3);
                }
                
                if (KFD::isContain(FName, "PickUp_BP_Armor_Lv3_A_C")) { /// 三级甲_1
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)PickUp_BP_Armor_Lv3_A_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,PickUp_BP_Armor_Lv3_A_C);
                }
                
                if (KFD::isContain(FName, "PickUp_BP_Armor_Lv3_B_C")) { /// 三级甲_2
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)PickUp_BP_Armor_Lv3_B_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,PickUp_BP_Armor_Lv3_B_C);
                }
            }
            if(投掷物){
                /// 投掷物
                if (KFD::isContain(FName, "BP_Grenade_Stun_Weapon_Wrapper_")) { /// 散光弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Stun_Weapon_Wrapper_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        // 修复地上手雷显示异常的大数字：只在合理距离内显示数值
                        if (wuzijuli >= 0.f && wuzijuli <= 300.f) {
                            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                        }
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Stun_Weapon_Wrapper_);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Smoke_Weapon_Wrapper")) { /// 烟雾弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Smoke_Weapon_Wrapper, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        if (wuzijuli >= 0.f && wuzijuli <= 300.f) {
                            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                        }
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Smoke_Weapon_Wrapper);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Shoulei_Weapon_Wrapper")) { /// 手榴弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Shoulei_Weapon_Wrapper, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        if (wuzijuli >= 0.f && wuzijuli <= 300.f) {
                            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                        }
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Shoulei_Weapon_Wrapper);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Burn_Weapon_Wrapper_")) { /// 燃烧瓶
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Burn_Weapon_Wrapper_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        if (wuzijuli >= 0.f && wuzijuli <= 300.f) {
                            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                        }
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Burn_Weapon_Wrapper_);
                }
                
                
                
                /// 其他物品
                if (KFD::isContain(FName, "GasCanBattery_Destructible_Pick")) { /// 汽油桶
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)GasCanBattery_Destructible_Pick, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        if (wuzijuli >= 0.f && wuzijuli <= 300.f) {
                            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                        }
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,GasCanBattery_Destructible_Pick);
                }
            }
            if(空投){
                if (KFD::isContain(FName, "BP_AirDropPlane_SuperPeople_C")) { /// 超级空投飞机
                    
                    绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                    绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                    
                    绘制图形->AddImage((__bridge ImTextureID)BP_AirDropPlane_SuperPeople_C, 图片位置, 图片大小);
                    
                    
                    绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                    
                    DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    
                    //huizhiwuzi(xd,yd,wuzijuli,BP_AirDropPlane_SuperPeople_C);
                }
                
                if (KFD::isContain(FName, "BP_AirDropBox_SuperPeople_C")) { /// 超级空投
                    
                    绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                    绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                    
                    绘制图形->AddImage((__bridge ImTextureID)BP_AirDropBox_SuperPeople_C, 图片位置, 图片大小);
                    
                    
                    绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                    
                    DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    //huizhiwuzi(xd,yd,wuzijuli,BP_AirDropBox_SuperPeople_C);
                }
                
                if (KFD::isContain(FName, "BP_AirDropPlane_C")) { /// 空投飞机
                    
                    绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                    绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                    
                    绘制图形->AddImage((__bridge ImTextureID)BP_AirDropPlane_C, 图片位置, 图片大小);
                    
                    
                    绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                    
                    DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    //huizhiwuzi(xd,yd,wuzijuli,BP_AirDropPlane_C);
                }
                
                if (KFD::isContain(FName, "AirDropBox")||KFD::isContain(FName, "LiftPort_TreasureBox_C")) { /// 空投
                    
                    绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                    绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                    
                    绘制图形->AddImage((__bridge ImTextureID)BP_AirDropBox_C, 图片位置, 图片大小);
                    
                    
                    绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                    
                    DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    //huizhiwuzi(xd,yd,wuzijuli,BP_AirDropBox_C);
                }
                
                if (KFD::isContain(FName, "BP_CG025_AirDropBox_C")) { /// 空投_1
                    
                    绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                    绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                    
                    绘制图形->AddImage((__bridge ImTextureID)BP_CG025_AirDropBox_C, 图片位置, 图片大小);
                    
                    
                    绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                    
                    DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    //huizhiwuzi(xd,yd,wuzijuli,BP_CG025_AirDropBox_C);
                }
            }
            if(药品){
                if (KFD::isContain(FName, "BP_revivalAED_Pickup_C")) { /// 自救器
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_revivalAED_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_revivalAED_Pickup_C);
                }
            }
            if(武器){
                if (KFD::isContain(FName, "BP_Pistol_Flaregun_Wrapper_C")) { /// 信号枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Pistol_Flaregun_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Pistol_Flaregun_Wrapper_C);
                }
            }
            if(配件){
                /// 枪托
                if (KFD::isContain(FName, "BP_QT_Sniper_Pickup_C")) { /// 托腮板_狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QT_Sniper_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QT_Sniper_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_QT_A_Pickup_C")) { /// 战术枪托
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QT_A_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QT_A_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_QT_UZI_Pickup_C")) { /// 枪托_Micro_UZI
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QT_UZI_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QT_UZI_Pickup_C);
                }
                /// 枪口
                if (KFD::isContain(FName, "BP_QK_Sniper_Supperssor_Pickup_")) { /// 消音器_狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QK_Sniper_Supperssor_Pickup_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QK_Sniper_Supperssor_Pickup_);
                }
                
                if (KFD::isContain(FName, "BP_QK_Sniper_FlashHider_Pickup_")) { /// 消焰器_狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QK_Sniper_FlashHider_Pickup_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QK_Sniper_FlashHider_Pickup_);
                }
                
                if (KFD::isContain(FName, "BP_QK_Large_Supperssor_Pickup_")) { /// 消音器_步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QK_Large_Supperssor_Pickup_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QK_Large_Supperssor_Pickup_);
                }
                
                if (KFD::isContain(FName, "BP_QK_Large_Compensator_Pickup_")) { /// 枪口补偿器_步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QK_Large_Compensator_Pickup_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QK_Large_Compensator_Pickup_);
                }
                
                if (KFD::isContain(FName, "BP_QK_Mid_Supperssor_Pickup_")) { /// 消音器_冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_QK_Mid_Supperssor_Pickup_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_QK_Mid_Supperssor_Pickup_);
                }
                /// 握把
                if (KFD::isContain(FName, "BP_WB_Lasersight_Pickup_C")) { /// 激光瞄准器
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WB_Lasersight_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WB_Lasersight_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WB_ThumbGrip_Pickup_C")) { /// 拇指握把
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WB_ThumbGrip_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WB_ThumbGrip_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WB_LightGrip_Pickup_C")) { /// 轻型握把
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WB_LightGrip_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WB_LightGrip_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WB_Angled_Pickup_C")) { /// 直角前握把
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WB_Angled_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WB_Angled_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WB_Vertical_Pickup_C")) { /// 垂直握把
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WB_Vertical_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WB_Vertical_Pickup_C);
                }
                /// 扩容
                if (KFD::isContain(FName, "BP_DJ_Large_EQ_Pickup_C")) { /// 快速扩容弹夹_步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Large_EQ_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Large_EQ_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_DJ_Large_E_Pickup_C")) { /// 扩容弹夹_步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Large_E_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Large_E_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_DJ_Sniper_EQ_Pickup_C")) { /// 快速扩容弹夹_狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Sniper_EQ_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Sniper_EQ_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_DJ_Sniper_E_Pickup_C")) { /// 扩容弹夹_狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Sniper_E_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Sniper_E_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_DJ_Mid_EQ_Pickup_C")) { /// 快速扩容弹夹_冲锋枪_手枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Mid_EQ_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Mid_EQ_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_DJ_Mid_E_Pickup_C")) { /// 扩容弹夹_冲锋枪_手枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_DJ_Mid_E_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_DJ_Mid_E_Pickup_C);
                }
                
            }
           
            if(武器){
                /// 近战武器
                if (KFD::isContain(FName, "BP_WEP_Pan_Pickup_C")) { /// 平底锅
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WEP_Pan_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WEP_Pan_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WEP_Machete_Pickup_C")) { /// 砍刀
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WEP_Machete_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WEP_Machete_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WEP_Sickle_Pickup_C")) { /// 镰刀
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WEP_Sickle_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WEP_Sickle_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_WEP_Cowbar_Pickup_C")) { /// 撬棍
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WEP_Cowbar_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WEP_Cowbar_Pickup_C);
                }
            }
           
            if(武器){
                /// 其他枪械
                if (KFD::isContain(FName, "BP_Other_MG3_Wrapper_C")) { /// MG3轻机枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_MG3_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_MG3_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Other_PKM_Wrapper_C")) { /// PKM轻机枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_PKM_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_PKM_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Other_M249_Wrapper_C")) { /// M249轻机枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_M249_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_M249_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Other_DP28_Wrapper_C")) { /// DP_28轻机枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_DP28_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_DP28_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Other_Shield_Wrapper_C")) { /// 突击盾牌
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_Shield_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_Shield_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Other_HuntingBow_Wrapper_C")) { /// 爆炸裂弓
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Other_HuntingBow_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Other_HuntingBow_Wrapper_C);
                }
                /// 散弹枪
                if (KFD::isContain(FName, "BP_ShotGun_DP12_Wrapper_C")) { /// DBS散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_DP12_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_DP12_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_ShotGun_SPAS_12_Wrapper_C")) { /// SPAS_12散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_SPAS_12_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_SPAS_12_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_ShotGun_S12K_Wrapper_C")) { /// S12K散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_S12K_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_S12K_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_ShotGun_AA12_Wrapper_C")) { /// AA12_G散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_AA12_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_AA12_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_ShotGun_S1897_Wrapper_C")) { /// S1897散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_S1897_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_S1897_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_ShotGun_S686_Wrapper_C")) { /// S686散弹枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_ShotGun_S686_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_ShotGun_S686_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Pistol_TMP_Wrapper_C")) { /// TMP_9手枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Pistol_TMP_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Pistol_TMP_Wrapper_C);
                }
                /// 冲锋枪
                if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_C")) { /// MP5K冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_MP5K_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_MP5K_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_PP19_Wrapper_C")) { /// 野牛冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_PP19_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_PP19_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_C")) { /// P90冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_P90CG17_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_P90CG17_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_TommyGun_Wrapper_")) { /// 汤姆逊冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_TommyGun_Wrapper_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_TommyGun_Wrapper_);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_C")) { /// 维克托冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_Vector_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_Vector_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_C")) { /// UMP45冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_UMP9_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_UMP9_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_C")) { /// UZI冲锋枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_MachineGun_Uzi_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_MachineGun_Uzi_Wrapper_C);
                }
                /// 狙击步枪
                if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_C")) { /// M24狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_M24_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_M24_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_C")) { /// AMR狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_AMR_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_AMR_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_C")) { /// M200狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_M200_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_M200_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_C")) { /// AWM狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_AWM_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_AWM_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_Kar98K_Wrapper_C")) { /// Kar98K狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_Kar98K_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_Kar98K_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_Mosin_Wrapper_C")) { /// 莫辛纳甘狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_Mosin_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_Mosin_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sniper_Win94_Wrapper_C")) { /// Win94狙击枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sniper_Win94_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sniper_Win94_Wrapper_C);
                }
                /// 射手步枪
                if (KFD::isContain(FName, "BP_WEP_Mk14_Wrapper_C")) { /// Mk14射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_WEP_Mk14_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_WEP_Mk14_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_Mini14_Wrapper_C")) { /// Mini14射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_Mini14_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_Mini14_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_VSS_Wrapper_C")) { /// VSS射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_VSS_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_VSS_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_SKS_Wrapper_C")) { /// SKS射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_SKS_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_SKS_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_QBU_Wrapper_C")) { /// QBU射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_QBU_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_QBU_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_SLR_Wrapper_C")) { /// SLR射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_SLR_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_SLR_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_MK12_Wrapper_C")) { /// MK12射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_MK12_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_MK12_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Sinper_MK20_Wrapper_C")) { /// MK20_H射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Sinper_MK20_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Sinper_MK20_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_M417_Wrapper_C")) { /// M417射手步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_M417_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_M417_Wrapper_C);
                }
                /// 762突击步枪
                if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_C")) { /// M762突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_M762_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_M762_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_Groza_Wrapper_C")) { /// GROZA突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_Groza_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_Groza_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_Mk47_Wrapper_C")) { /// Mk47突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_Mk47_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_Mk47_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_C")) { /// 蜜罐突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_HoneyBadger_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_HoneyBadger_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_AKM_Wrapper_C")) { /// AKM突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_AKM_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_AKM_Wrapper_C);
                }
                /// 556突击步枪
                if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_C")) { /// QBZ突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_QBZ_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_QBZ_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_C")) { /// AUG突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_AUG_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_AUG_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_C")) { /// AC_VAL突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_VAL_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_VAL_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_C")) { /// G36C突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_G36_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_G36_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_M416_Wrapper_C")) { /// M416突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_M416_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_M416_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_SCAR_Wrapper_C")) { /// SCAR_L突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_SCAR_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_SCAR_Wrapper_C);
                }
                
                if (KFD::isContain(FName, "BP_Rifle_M16A4_Wrapper_C")) { /// M16A4突击步枪
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Rifle_M16A4_Wrapper_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Rifle_M16A4_Wrapper_C);
                }
            }
            if(预警){
                /// 警告
                if (KFD::isContain(FName, "ProjGrenade_BP_C")) { /// 手榴弹_警告
                    
                    
                    float ExplosionTime = KFD::Read<float>(actor+0x81c);//float ExplosionTime;
                    float ReplicatedWorldTimeSeconds = 读取世界时间秒(gWorld);
                    float displayValue = ExplosionTime - ReplicatedWorldTimeSeconds;
                    
                    // 读取手雷的速度来判断是否在空中
                    // 尝试多个可能的velocity偏移
                    Vector3 grenadeVelocity = {0, 0, 0};
                    grenadeVelocity = KFD::Read<Vector3>(actor + 0x10DC); // VelocitySafety偏移
                    if (grenadeVelocity.X == 0 && grenadeVelocity.Y == 0 && grenadeVelocity.Z == 0) {
                        grenadeVelocity = KFD::Read<Vector3>(actor + 0x10BC); // 另一个可能的偏移
                    }
                    
                    // 判断是否在空中：Z方向速度绝对值大于5，或者displayValue为0（刚投出）
                    bool isInAir = false;
                    if (fabs(grenadeVelocity.Z) > 5.0f) {
                        isInAir = true; // Z方向速度较大，说明在空中
                    } else if (displayValue <= 0.1f) {
                        isInAir = true; // displayValue接近0，可能是刚投出
                    } else {
                        isInAir = false; // 速度很小且displayValue正常，说明在地上
                    }
                    
                    if (displayValue >= 0) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        // 根据是否在空中显示不同的文本
                        string grenadeText;
                        if (isInAir) {
                            grenadeText = "空中的手雷";
                        } else {
                            grenadeText = "手雷";
                        }
                        
                        DrawText(grenadeText, ImVec2(LocationScreen.X, LocationScreen.Y-30), true, IM_COL32(255, 255, 255, 255), true, 20);
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, IM_COL32(255, 255, 255, 255), false, 文本大小);
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Shoulei_Weapon_C, 图片位置, 图片大小);

                        // 额外警告：手雷距离自己 50m 以内，在人数下方显示红色提示
                        if (wuzijuli <= 50.0f) {
                            ImVec2 warnPos(屏幕宽度 / 2, 80); // 人数在 y=50，这里稍微靠下
                            DrawText("小心手雷！！！", warnPos, true, IM_COL32(255, 50, 50, 255), true, 24);
                        }
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,ProjGrenade_BP_C);
                }
                
                if (KFD::isContain(FName, "ProjSmoke_BP_C")) { /// 烟雾弹_警告
                    
           
                    float ExplosionTime = KFD::Read<float>(actor+0x81c);//float ExplosionTime;
                    float ReplicatedWorldTimeSeconds = 读取世界时间秒(gWorld);
                    
                    float displayValue = ExplosionTime - ReplicatedWorldTimeSeconds;
                    
                    
                  
                    if(getdistanceyanwu(wuziWorldPos, POV.Location, 100)<4){
                        烟雾=YES;
                    }
                    
                    if (displayValue >= 0) {
                     
                        
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        DrawText(string_format("%.f", displayValue), ImVec2(LocationScreen.X, LocationScreen.Y-30), true, Colour_白色, true, 20);
                        DrawText(string_format("%.0fm|%.fs", wuzijuli, displayValue), 文本位置, true, Colour_白色, false, 文本大小);
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Smoke_Weapon_C, 图片位置, 图片大小);
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,ProjSmoke_BP_C);
                }else{
                    烟雾=NO;
                   
                }
                
                if (KFD::isContain(FName, "ProjBurn_BP_C")) { /// 燃烧瓶_警告
                    
                    
                    float ExplosionTime = KFD::Read<float>(actor+0x81c);//float ExplosionTime;
                    float ReplicatedWorldTimeSeconds = 读取世界时间秒(gWorld);
                    
                    float displayValue = ExplosionTime - ReplicatedWorldTimeSeconds;
                    if (displayValue >= 0) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        DrawText(string_format("%.f", displayValue), ImVec2(LocationScreen.X, LocationScreen.Y-30), true, Colour_白色, true, 20);
                        DrawText(string_format("%.0fm|%.fs", wuzijuli, displayValue), 文本位置, true, Colour_白色, false, 文本大小);
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Burn_Weapon_C, 图片位置, 图片大小);
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,ProjBurn_BP_C);
                }
                
                if (KFD::isContain(FName, "ProjStun_BP_C")) { /// 闪光弹_警告
                    
                    
                    float ExplosionTime = KFD::Read<float>(actor+0x81c);//float ExplosionTime;
                    float ReplicatedWorldTimeSeconds = 读取世界时间秒(gWorld);
                    float displayValue = ExplosionTime - ReplicatedWorldTimeSeconds;
                    if (displayValue >= 0) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        DrawText(string_format("%.f", displayValue), ImVec2(LocationScreen.X, LocationScreen.Y-30), true, Colour_白色, true, 20);
                        DrawText(string_format("%.0fm|%.fs", wuzijuli, displayValue), 文本位置, true, Colour_白色, false, 文本大小);
                        绘制图形->AddImage((__bridge ImTextureID)ProjGrenade_BP_C, 图片位置, 图片大小);
                    }
                    
                    //huizhiwuzi(xd,yd,wuzijuli,ProjStun_BP_C);
                }
                /// 手持
                if (KFD::isContain(FName, "BP_Grenade_Shoulei_Weapon_C")) { /// 手持_手榴弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Shoulei_Weapon_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Shoulei_Weapon_C);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Stun_Weapon_C")) { /// 手持_散光弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Stun_Weapon_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Stun_Weapon_C);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Smoke_Weapon_C")) { /// 手持_烟雾弹
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Smoke_Weapon_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Smoke_Weapon_C);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_Burn_Weapon_C")) { /// 手持_燃烧瓶
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_Burn_Weapon_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_Burn_Weapon_C);
                }
            }
            if(盒子){
                /// 其他
                if (KFD::isContain(FName, "BP_PlayerDeadListWrapper_C")) { /// 盒子列表
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)CharacterDeadInventoryBox_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_PlayerDeadListWrapper_C);
                }
            }
            if(空投){
                if (KFD::isContain(FName, "AirDropList")) { /// 空投列表
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)AirDropListWrapperActor_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,AirDropListWrapperActor_C);
                }
                
                if (KFD::isContain(FName, "Bp_AirDrop_C")) { /// 小队奖励空投
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Bp_AirDrop_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Bp_AirDrop_C);
                }
            }
            if(武器){
                if (KFD::isContain(FName, "BP_CG024HumanCannon_Pickup_C")) { /// 战术弹射炮
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_CG024HumanCannon_Pickup_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_CG024HumanCannon_Pickup_C);
                }
                
                if (KFD::isContain(FName, "BP_Grenade_EmergencyCall_Weapon")) { /// 紧急呼机器
                    if (wuzijuli > 10 && wuzijuli <= 100) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_Grenade_EmergencyCall_Weapon, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_Grenade_EmergencyCall_Weapon);
                }
            }
            if(载具){
                
                
                /// 载具
                if (KFD::isContain(FName, "VH_Dacia_")) { /// 轿车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        // 使用文字显示载具名称，替代图片
                        std::string vehicleName = GetVehicleName(FName);
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        DrawText(vehicleName, 图片位置, true, IM_COL32(255, 255, 255, 255), true, 文本大小);
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, IM_COL32(255, 255, 255, 255), false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Dacia_);
                }
                
                if (KFD::isContain(FName, "VH_UAZ")) { /// 吉普
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        // 使用文字显示载具名称，替代图片
                        std::string vehicleName = GetVehicleName(FName);
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        DrawText(vehicleName, 图片位置, true, IM_COL32(255, 255, 255, 255), true, 文本大小);
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, IM_COL32(255, 255, 255, 255), false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_UAZ);
                }
                
                // 对剩下的载具，逻辑相同，只需替换对应的资源名称
                if (KFD::isContain(FName, "BP_VH_Buggy_")) { /// 蹦蹦
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_VH_Buggy_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_VH_Buggy_);
                }
                
                // 依次添加所有其他载具的逻辑，保持相同的结构，仅替换资源名称
                if (KFD::isContain(FName, "BP_VH_CoupeRB_")) { /// 姥爷车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_VH_CoupeRB_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_VH_CoupeRB_);
                }
                
                if (KFD::isContain(FName, "CoupeRB_1")) { /// 姥爷车_1
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)CoupeRB_1, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,CoupeRB_1);
                }
                
                if (KFD::isContain(FName, "VH_Motorcycle_")) { /// 摩托
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Motorcycle_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Motorcycle_);
                }
                
                if (KFD::isContain(FName, "VH_MotorcycleCart_")) { /// 人摩托3
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_MotorcycleCart_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_MotorcycleCart_);
                }
                
                if (KFD::isContain(FName, "MotorcycleCart")) { /// 人摩托3_1
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)MotorcycleCart, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,MotorcycleCart);
                }
                
                if (KFD::isContain(FName, "VH_PG117")) { /// 快艇
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_PG117, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_PG117);
                }
                
                if (KFD::isContain(FName, "AquaRail_")) { /// 摩托艇
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)AquaRail_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,AquaRail_);
                }
                if (KFD::isContain(FName, "VH_StationWagon_C")) { /// 旅行车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_StationWagon_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_StationWagon_C);
                }
                
                if (KFD::isContain(FName, "Mirado_")) { /// 跑车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Mirado_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Mirado_);
                }
                
                if (KFD::isContain(FName, "PickUp_0")) { /// 皮卡_0
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)PickUp_0, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,PickUp_0);
                }
                
                if (KFD::isContain(FName, "Rony_01_C")) { /// 皮卡_1
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Rony_01_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Rony_01_C);
                }
                
                if (KFD::isContain(FName, "Rony_3_C")) { /// 皮卡_2
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Rony_3_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Rony_3_C);
                }
                
                if (KFD::isContain(FName, "Rony_2_C")) { /// 皮卡_3
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Rony_2_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Rony_2_C);
                }
                if (KFD::isContain(FName, "VH_MiniBus_")) { /// 巴士
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_MiniBus_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_MiniBus_);
                }
                
                if (KFD::isContain(FName, "VH_BRDM_")) { /// 装甲车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_BRDM_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_BRDM_);
                }
                
                if (KFD::isContain(FName, "BP_VH_Tuk_")) { /// 雨林三轮
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_VH_Tuk_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_VH_Tuk_);
                }
                
                if (KFD::isContain(FName, "Snowbike")) { /// 轻型雪地摩托
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Snowbike, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Snowbike);
                }
                
                if (KFD::isContain(FName, "Snowmobile")) { /// 重型雪地摩托
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)Snowmobile, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,Snowmobile);
                }
                
                if (KFD::isContain(FName, "BP_VH_Bigfoot_C")) { /// 大脚车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)BP_VH_Bigfoot_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,BP_VH_Bigfoot_C);
                }
                
                
                if (KFD::isContain(FName, "VH_Scooter_C")) { /// 小电驴
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Scooter_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Scooter_C);
                }
                
                if (KFD::isContain(FName, "VH_4SportCar_C")) { /// 敞篷车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_4SportCar_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_4SportCar_C);
                }
                
                if (KFD::isContain(FName, "VH_ATV1_C")) { /// 全地形车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_ATV1_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_ATV1_C);
                }
                
                if (KFD::isContain(FName, "VH_LadaNiva_01_C")) { /// 雪地越野车
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_LadaNiva_01_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_LadaNiva_01_C);
                }
                
                if (KFD::isContain(FName, "VH_Motorglider_C")) { /// 滑翔机
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Motorglider_C, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Motorglider_C);
                }
                
                if (KFD::isContain(FName, "VH_Horse_")) { /// 马儿
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Horse_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Horse_);
                }
                
                if (KFD::isContain(FName, "VH_Horse_")) { /// 马儿
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Horse_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Horse_);
                }
                
                if (KFD::isContain(FName, "VH_LostMobile_")) { /// 马儿
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_LostMobile, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Horse_);
                }
                
                if (KFD::isContain(FName, "VH_Drift_")) { /// 马儿
                    if (wuzijuli > 10 && wuzijuli <= 600) {
                        绘制图形->AddCircleFilled(ImVec2(xd, yd + 40), 半径, 背景色);
                        绘制图形->AddCircle(ImVec2(xd, yd + 40), 半径 + 1.5, 背景色1);
                        
                        绘制图形->AddImage((__bridge ImTextureID)VH_Drift_, 图片位置, 图片大小);
                        
                        
                        绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
                        
                        DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_白色, false, 文本大小);
                    }
                    //huizhiwuzi(xd,yd,wuzijuli,VH_Horse_);
                }
                
                
                
                
            }
     
            if(地铁物资){
                // 突击步枪
                if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_4_C")) {
                    ditie( wuzijuli , xd , yd, isMobile, 文本大小, 矩形宽度 , 矩形高度, 背景颜色, 矩形位置 , 文本位置,"Famas（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Famas（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Famas（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Famas（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Famas（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_Famas_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Famas（铁爪）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_HoneyBadger_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "蜜獾（铁爪）");
                } else if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AC-VAL（破损）");
                } else if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AC-VAL（修复）");
                } else if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AC-VAL（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AC-VAL（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_VAL_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AC-VAL（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_G36_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "G36C（铁爪）");
                } else if (KFD::isContain(FName, "BP_Rifle_Mk47_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Mk47（破损）");
                }
                
                if (KFD::isContain(FName, "BBP_Rifle_Mk47_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Mk47（修复）");
                } else if (KFD::isContain(FName, "BP_Rifle_Mk47_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Mk47（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_Mk47_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Mk47（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（铁爪）");
                } else if (KFD::isContain(FName, "BP_Rifle_M762_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M762（卓越）金");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（完好）");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_QBZ_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "QBZ（铁爪）");
                } else if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AUG（改进）");
                } else if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AUG（精致）");
                } else if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AUG（卓越）");
                } else if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AUG（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Rifle_AUG_Wrapper_Eagle_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AUG（铁爪）");
                }
                // 继续按相同的模式处理其他武器……
                //冲锋枪
                if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "P90（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "P90（精致）");
                } else if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "P90（卓越）");
                } else if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "P90（黑鹰）");
                } else if (KFD::isContain(FName, "BP_MachineGun_P90CG17_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "P90（铁爪）");
                } else if (KFD::isContain(FName, "BP_MachineGun_AKS74U_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AKS74U（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_AKS74U_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AKS74U（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_AKS74U_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AKS74U（精致）");
                } else if (KFD::isContain(FName, "BP_MachineGun_AKS74U_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AKS74U（卓越）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（精致）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（卓越）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（黑鹰）");
                } else if (KFD::isContain(FName, "BP_MachineGun_MP5K_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MP5K（铁爪）");
                } else if (KFD::isContain(FName, "BP_MachineGun_PP19_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "野牛（破损）");
                } else if (KFD::isContain(FName, "BP_MachineGun_PP19_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "野牛（修复）");
                } else if (KFD::isContain(FName, "BP_MachineGun_PP19_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "野牛（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_TommyGun_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "汤姆逊（破损）");
                } else if (KFD::isContain(FName, "BP_MachineGun_TommyGun_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "汤姆逊（修复）");
                } else if (KFD::isContain(FName, "BP_MachineGun_TommyGun_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "汤姆逊（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_TommyGun_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "汤姆逊（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（精致）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（卓越）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（黑鹰）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Vector_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Vector（铁爪）");
                } else if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "UMP45（破损）");
                } else if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "UMP45（修复）");
                } else if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "UMP45（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "UMP45（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_UMP9_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "UMP45（精致）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Uzi（破损）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Uzi（修复）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Uzi（完好）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Uzi（改进）");
                } else if (KFD::isContain(FName, "BP_MachineGun_Uzi_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Uzi（精致）");
                }
                
                //狙击枪
                if (KFD::isContain(FName, "BP_Sniper_SVD_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "SVD（改进）");
                } else if (KFD::isContain(FName, "BP_Sniper_SVD_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "SVD（精致）");
                } else if (KFD::isContain(FName, "BP_Sniper_SVD_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "SVD（卓越）");
                } else if (KFD::isContain(FName, "BP_Sniper_SVD_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "SVD（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Sniper_SVD_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "SVD（铁爪）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（完好）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（改进）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（精致）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（卓越）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Sniper_M200_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M200（铁爪）");
                } else if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWR（改进）");
                } else if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWR（精致）");
                } else if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWR（卓越）");
                } else if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWR（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Sniper_AMR_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWR（铁爪）");
                } else if (KFD::isContain(FName, "BP_Sniper_Win94_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Win94（破损）");
                } else if (KFD::isContain(FName, "BP_Sniper_Win94_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Win94（修复）");
                } else if (KFD::isContain(FName, "BP_Sniper_Win94_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Win94（完好）");
                } else if (KFD::isContain(FName, "BP_Sniper_Mosin_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "莫辛纳甘（破损）");
                } else if (KFD::isContain(FName, "BP_Sniper_Mosin_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "莫辛纳甘（修复）");
                } else if (KFD::isContain(FName, "BP_Sniper_Mosin_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "莫辛纳甘（完好）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（完好）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（改进）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（精致）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（卓越）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Sniper_AWM_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "AWM（铁爪）");
                } else if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M24（改进）");
                } else if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M24（精致）");
                } else if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M24（卓越）");
                } else if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_7_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M24（黑鹰）");
                } else if (KFD::isContain(FName, "BP_Sniper_M24_Wrapper_8_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M24（铁爪）");
                } else if (KFD::isContain(FName, "BP_Sniper_Kar98k_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Kar98K（修复）");
                } else if (KFD::isContain(FName, "BP_Sniper_Kar98k_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Kar98K（完好）");
                } else if (KFD::isContain(FName, "BP_Sniper_Kar98k_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Kar98K（改进）");
                }
                //轻机枪
                
                if (KFD::isContain(FName, "BP_Other_MG36_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG-36（改进）");
                } else if (KFD::isContain(FName, "BP_Other_MG36_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG-36（精致）");
                } else if (KFD::isContain(FName, "BP_Other_MG36_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG-36（卓越）");
                } else if (KFD::isContain(FName, "BP_Other_PKM_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "PKM（改进）");
                } else if (KFD::isContain(FName, "BP_Other_PKM_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "PKM（精致）");
                } else if (KFD::isContain(FName, "BP_Other_PKM_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "PKM（卓越）");
                } else if (KFD::isContain(FName, "BP_Other_MG3_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG3（改进）");
                } else if (KFD::isContain(FName, "BP_Other_MG3_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG3（精致）");
                } else if (KFD::isContain(FName, "BP_Other_MG3_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "MG3（卓越）");
                } else if (KFD::isContain(FName, "BP_Other_DP28_Wrapper_1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "DP-28（破损）");
                } else if (KFD::isContain(FName, "BP_Other_DP28_Wrapper_2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "DP-28（修复）");
                } else if (KFD::isContain(FName, "BP_Other_DP28_Wrapper_3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "DP-28（完好）");
                } else if (KFD::isContain(FName, "BP_Other_M249_Wrapper_4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M249（改进）");
                } else if (KFD::isContain(FName, "BP_Other_M249_Wrapper_5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M249（精致）");
                } else if (KFD::isContain(FName, "BP_Other_M249_Wrapper_6_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M249（卓越）");
                }
                
                if (KFD::isContain(FName, "PickUp_BP_ArmorAttatchment_SignalEnhancement_lv1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "信号增强器");
                } else if (KFD::isContain(FName, "BP_EscapePhone_Pickup_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "撤离信号电话");
                } else if (KFD::isContain(FName, "BP_Other_Shield_Wrapper_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "突击盾牌");
                } else if (KFD::isContain(FName, "BP_Other_RPG7_Wrapper_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "RPG-7火箭筒");
                } else if (KFD::isContain(FName, "BP_Other_M79_Wrapper")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "M79榴弹");
                }
            }
            
            if(地铁盒子){
                
                if (KFD::isContain(FName, "SupplyBox_Lv1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv1物资箱");
                }
                if (KFD::isContain(FName, "SupplyBox_Lv2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv2物资箱");
                }
                if (KFD::isContain(FName, "SupplyBox_Lv3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv3物资箱");
                }
                if (KFD::isContain(FName, "SupplyBox_Lv4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv4物资箱");
                }
                if (KFD::isContain(FName, "SupplyBox_Lv5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv5物资箱");
                }
                if (KFD::isContain(FName, "Weapon_Lv1_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv1武器箱");
                }
                if (KFD::isContain(FName, "Weapon_Lv2_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv2武器箱");
                }
                if (KFD::isContain(FName, "Weapon_Lv3_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv3武器箱");
                }
                if (KFD::isContain(FName, "Weapon_Lv4_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv4武器箱");
                }
                if (KFD::isContain(FName, "Weapon_Lv5_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "Lv5武器箱");
                }
                
                if (KFD::isContain(FName, "BP_EscapeInnerWrapperList_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "箱子（关）");
                } else if (KFD::isContain(FName, "BP_InnerSupplyBoxBase_C")) {
                    ditie(wuzijuli, xd, yd, isMobile, 文本大小, 矩形宽度, 矩形高度, 背景颜色, 矩形位置, 文本位置, "箱子（开）");
                }
            }
            if(盒内物资){
                
                    if((GetCenterOffsetForVector(LocationScreen))<250){
                        
                        int goodsListValidCount=0;
                        bool goodslistid=false;
                        long pickupdata =KFD::Read<long>(actor +0xcd8);//0xb10  0xb80 PickUpItemData[] PickUpDataList;
                        int goodslistcount =KFD::Read<int>(actor +0xcd8+sizeof(uintptr_t));
                        
                        float ExplosionTime = KFD::Read<float>(actor+0x81c);//float ExplosionTime;
                        for (int index =0; index<goodslistcount; index++){
                            if(index >100){
                                break;
                            }
                            long Boxadd = pickupdata +index *0x38;
                            int BulletCount =KFD::Read<int>(Boxadd +0x18);
                            string goodsName =PickUpDataName(KFD::Read<int>(pickupdata+ 0x4 +index *0x38));
                            
                            int goodslist =KFD::Read<int>(pickupdata+ 0x4 +index *0x38);
                            
                            if(!goodsName.empty()&& !KFD::isContain(goodsName, "Error")){
                                goodslistid=true;
                                goodsListValidCount++;
                                
                                DrawText(string_format("%s x%d", goodsName.c_str(),BulletCount), ImVec2(LocationScreen.X,LocationScreen.Y- 10 *(goodsListValidCount)), true, Colour_纯黄, false, 8);
                                
                            }
                            
                        }

                    }
            }
            
        }
        
        // 雷达图绘制（圆心 雷达位置X/Y，半径 雷达大小，敌人相对本地玩家 2D 投影）
        if (雷达开关 && 雷达大小 > 0) {
            float cx = 屏幕宽度 * 雷达位置X;
            float cy = 屏幕高度 * 雷达位置Y;
            float radius = 雷达大小;
            const float maxRange = 20000.0f;
            float scale = radius / maxRange;
            float yawRad = s_radarPOV.Rotation.Yaw * (float)M_PI / 180.0f;
            float ca = cosf(yawRad), sa = sinf(yawRad);
            绘制图形->AddCircleFilled(ImVec2(cx, cy), radius, IM_COL32(0, 0, 0, 140), 24);
            绘制图形->AddCircle(ImVec2(cx, cy), radius, IM_COL32(255, 255, 255, 200), 24, 1.5f);
            // 圆心：用户在此，朝上箭头表示玩家朝向（屏幕上方=前方），按半径较小比例描边
            const float arrowScale = fmaxf(0.6f, radius * 0.06f);
            const float arrowLen = 10.0f * arrowScale, arrowHalfW = 6.0f * arrowScale;
            ImVec2 tip(cx, cy - arrowLen), baseL(cx - arrowHalfW, cy + arrowLen), baseR(cx + arrowHalfW, cy + arrowLen);
            绘制图形->AddCircleFilled(ImVec2(cx, cy), 3.0f, IM_COL32(200, 255, 255, 255), 8);
            绘制图形->AddTriangleFilled(ImVec2(tip.x+1, tip.y+1), ImVec2(baseL.x+1, baseL.y+1), ImVec2(baseR.x+1, baseR.y+1), IM_COL32(0, 0, 0, 220));
            绘制图形->AddTriangleFilled(ImVec2(tip.x-1, tip.y-1), ImVec2(baseL.x-1, baseL.y-1), ImVec2(baseR.x-1, baseR.y-1), IM_COL32(0, 0, 0, 220));
            绘制图形->AddTriangleFilled(tip, baseL, baseR, IM_COL32(200, 255, 255, 255));
            for (size_t k = 0; k < s_radarEnemyWorldPos.size(); k++) {
                float rx = s_radarEnemyWorldPos[k].X - s_radarLocalPos.X;
                float ry = s_radarEnemyWorldPos[k].Y - s_radarLocalPos.Y;
                float tx = rx * ca + ry * sa;
                float ty = -rx * sa + ry * ca;
                float px = cx + tx * scale;
                float py = cy - ty * scale;
                if (fabsf(px - cx) <= radius + 2 && fabsf(py - cy) <= radius + 2)
                    绘制图形->AddCircleFilled(ImVec2(px, py), 4.0f, IM_COL32(255, 0, 0, 255), 8);
            }
        }
    }
    if(人数){
        const float textY = kCountTextY;
        ImVec2 aiPos = GetCountTextPosition(true);
        ImVec2 realPos = GetCountTextPosition(false);
        if (gTEHasAuthorThisMatch) {
            // 本局发现 SystemHelper 作者
            DrawText(OBF_STR("A00"), ImVec2(屏幕宽度/2, textY - 24), true, Colour_橙黄, true, 18);
        } else if (gTEHasUserThisMatch) {
            // 没有作者，但发现同等用户
            DrawText("发现同等用户", ImVec2(屏幕宽度/2, textY - 24), true, Colour_绿色, true, 18);
        }

        DrawCountBadge(aiPos, "人机", totalAIEnemies, true);
        DrawCountBadge(realPos, "玩家", totalRealEnemies, false);
        if (totalAIEnemies + totalRealEnemies == 0) {
            DrawText("安全", ImVec2(屏幕宽度/2, textY + 24), true, IM_COL32(255, 220, 105, 255), true, 18);
        }
    }
    绘制游戏世界实时调试();
    
    
  

ImVec2 center = ImVec2(屏幕宽度 / 2, 屏幕高度 / 2);
bool 不在中心 = (fabs(center.x - markScreenPos.X) > 1 || fabs(center.y - markScreenPos.Y) > 1);
float targetRadius = 不在中心 ? 自瞄大小 : 5.0f;
float deltaTime = ImGui::GetIO().DeltaTime;

    if (circleMode == 0) {
        // 动态圈
        DrawAnimatedCircle(center, targetRadius, 1.0f, Colour_绿色, deltaTime);
    } else if (circleMode == 1) {
        // 静态圈（可适当比动态圈稍粗一点）
        DrawStaticCircle(center, targetRadius, 1.5f, Colour_绿色);
    }

if (markDistance <= 自瞄大小) {
    needAdjustAim = true;
    if (自瞄连线) {
    DrawLine(center, ImVec2(markScreenPos.X, markScreenPos.Y), Colour_绿色, 0.5);
    }
    zimiao(markPos, zimiaoshuju, Character, POV,sniperrifle,Health );
}

    // 独立的敌人距离检测：检查是否有敌人距离用户50米以内
    bool hasEnemyNearby = false;
    long NetDriver = KFD::Read<long>(gWorld + kNetDriver);
    long ServerConnection = KFD::Read<long>(NetDriver + kServerConnection);
    long PlayerController = KFD::Read<long>(ServerConnection + klocalPlayerController);
    long LocalCharacter = KFD::Read<long>(PlayerController + kPawn);
    if (KFD::地址泄露(LocalCharacter)) {
        int localTeamID = KFD::Read<int>(LocalCharacter + kTeamID);
        Vector3 localPos = GetRelativeLocation(LocalCharacter);
        
        // 遍历当前 Level 的 Actor 数组检查敌人
        long PersistentLevel = 读取有效Level(gWorld);
        if (KFD::地址泄露(PersistentLevel)) {
            uint64_t ActorArray = 0;
            int ActorCount = 0;
            if (读取LevelActor数组(PersistentLevel, &ActorArray, &ActorCount) ||
                读取世界Actor数组(gWorld, &ActorArray, &ActorCount)) {
                ActorCount = std::min(ActorCount, 10000);
                uint64_t baseAddr = KFD::S().base;
                uint64_t resolvedUName = 0;
                解析GNames偏移(baseAddr, ActorArray, ActorCount, kGNames, &resolvedUName, nullptr);
                for (int i = 0; i < ActorCount; i++) {
                    long checkActor = KFD::Read<long>(ActorArray + i * 0x8);
                    if (!KFD::地址泄露(checkActor)) continue;
                    
                    std::string checkFName = resolvedUName ? GetFName(checkActor, resolvedUName) : GetFName(checkActor, baseAddr, kGNames);
                    std::string checkClassName = resolvedUName ? GetObjectClassName(checkActor, resolvedUName) : "";
                    bool isPlayer = KFD::isContain(checkFName, "PlayerPawn") ||
                                    KFD::isContain(checkFName, "PlayerCharacter") ||
                                    KFD::isContain(checkFName, "STExtraPlayerCharacter") ||
                                    KFD::isContain(checkFName, "BP_Character");
                    if (!isPlayer) {
                        isPlayer = KFD::isContain(checkClassName, "STExtraPlayerCharacter") ||
                                   KFD::isContain(checkClassName, "PlayerPawn") ||
                                   KFD::isContain(checkClassName, "PlayerCharacter") ||
                                   KFD::isContain(checkClassName, "BP_Character") ||
                                   KFD::isContain(checkClassName, "BPPawn") ||
                                   KFD::isContain(checkClassName, "FakePlayer_AIPawn");
                    }
                    if (!isPlayer) {
                        isPlayer = IsStructLikePlayerActor(checkActor, LocalCharacter, nullptr, nullptr);
                    }
                    
                    if (isPlayer && checkActor != LocalCharacter) {
                        int checkTeamID = KFD::Read<int>(checkActor + kTeamID);

                        // 队伍号在某些模式可能为 0，这时不要因为 teamID==0 就把敌人全过滤掉
                        bool isEnemy = false;
                        if (localTeamID == 0 || checkTeamID == 0) {
                            isEnemy = true; // 无队伍信息：默认视为敌方（除自己外）
                        } else if (checkTeamID != localTeamID) {
                            isEnemy = true;
                        }

                        if (isEnemy) {
                            Vector3 enemyPos = GetRelativeLocation(checkActor);
                            float enemyDistance = GetDistance(enemyPos, localPos) / 100;
                            if (enemyDistance <= 50.0f) {
                                hasEnemyNearby = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 如果有敌人距离50米以内，显示提示
    if (hasEnemyNearby) {
        ImVec2 enemyWarnPos(屏幕宽度 / 2, 110); // 屏幕上方偏中间
        DrawText("有敌人距离50米内你可以合理地杀死他", enemyWarnPos, true, IM_COL32(255, 200, 50, 255), true, 20);
    }
    
}

void ditie (float wuzijuli ,float xd ,float yd,bool isMobile,float 文本大小,float 矩形宽度 ,float 矩形高度,ImU32 背景颜色,ImVec2 矩形位置 ,ImVec2 文本位置,string namee){
   
        
        /// 马儿
        if (wuzijuli > 10 && wuzijuli <= 100) {
            DrawText(string_format("%s", namee.c_str()), ImVec2(xd, yd + (isMobile ? 40 : 60)), true, Colour_白色, false, 文本大小);
            绘制图形->AddRectFilled(矩形位置, ImVec2(矩形位置.x + 矩形宽度, 矩形位置.y + 矩形高度), 背景颜色);
            
            DrawText(string_format("%.0fm", wuzijuli), 文本位置, true, Colour_橙色, false, 文本大小);
        }
        //huizhiwuzi(xd,yd,wuzijuli,VH_Horse_);
        
   
}
static inline void DrawStaticCircle(const ImVec2& center,
                                    float radius,
                                    float thickness,
                                    ImU32 color)
{
    ImGui::GetForegroundDrawList()->AddCircle(center, radius, color, 64, thickness);
}






























- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size { }

- (void)UpdateTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint TouchPos = [anyTouch locationInView:self];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(TouchPos.x, TouchPos.y);
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { [self UpdateTouchEvent:event]; }

- (void)dealloc {
    ImGui_ImplMetal_Shutdown();
    ImGui::DestroyContext();
   
}

+ (SHRenderView *)sharedInstance {
    static SHRenderView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)initImageTexture:(id<MTLDevice>)device {
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //////////NSLog(@"Start loading textures on background thread");
      
        // 初始化纹理
        NSString *quan1 = [[NSBundle mainBundle] pathForResource:@"hold/quan" ofType:@"png"];
        quan =[self loadPNGTexture:device fromFilePath:quan1];
        
        
        NSString *pngFilePath = [[NSBundle mainBundle] pathForResource:@"hold/101010" ofType:@"png"];
        chi101010 =[self loadPNGTexture:device fromFilePath:pngFilePath];
        
        NSString *pngFilePath1 = [[NSBundle mainBundle] pathForResource:@"hold/101001" ofType:@"png"];
        chi101001 =[self loadPNGTexture:device fromFilePath:pngFilePath1];
        
        NSString *pngFilePath2 = [[NSBundle mainBundle] pathForResource:@"hold/101002" ofType:@"png"];
        chi101002 =[self loadPNGTexture:device fromFilePath:pngFilePath2];
        
        NSString *pngFilePath3 = [[NSBundle mainBundle] pathForResource:@"hold/101003" ofType:@"png"];
        chi101003 =[self loadPNGTexture:device fromFilePath:pngFilePath3];
        
        NSString *pngFilePath4 = [[NSBundle mainBundle] pathForResource:@"hold/101004" ofType:@"png"];
        chi101004 =[self loadPNGTexture:device fromFilePath:pngFilePath4];
        
        NSString *pngFilePath5 = [[NSBundle mainBundle] pathForResource:@"hold/101005" ofType:@"png"];
        chi101005 =[self loadPNGTexture:device fromFilePath:pngFilePath5];
        
        NSString *pngFilePath6 = [[NSBundle mainBundle] pathForResource:@"hold/101006" ofType:@"png"];
        chi101006 =[self loadPNGTexture:device fromFilePath:pngFilePath6];
        
        NSString *pngFilePath7 = [[NSBundle mainBundle] pathForResource:@"hold/101007" ofType:@"png"];
        chi101007 =[self loadPNGTexture:device fromFilePath:pngFilePath7];
        
        NSString *pngFilePath8 = [[NSBundle mainBundle] pathForResource:@"hold/101008" ofType:@"png"];
        chi101008 =[self loadPNGTexture:device fromFilePath:pngFilePath8];
        
        NSString *pngFilePath9 = [[NSBundle mainBundle] pathForResource:@"hold/101009" ofType:@"png"];
        chi101009 =[self loadPNGTexture:device fromFilePath:pngFilePath9];
        
        NSString *pngFilePath11 = [[NSBundle mainBundle] pathForResource:@"hold/101011" ofType:@"png"];
        chi101011 =[self loadPNGTexture:device fromFilePath:pngFilePath11];
        
        NSString *pngFilePath12 = [[NSBundle mainBundle] pathForResource:@"hold/101012" ofType:@"png"];
        chi101012 =[self loadPNGTexture:device fromFilePath:pngFilePath12];
        
        NSString *pngFilePath13 = [[NSBundle mainBundle] pathForResource:@"hold/101013" ofType:@"png"];
        chi101013 =[self loadPNGTexture:device fromFilePath:pngFilePath13];
        
        
        NSString *pngFilePath15 = [[NSBundle mainBundle] pathForResource:@"hold/102001" ofType:@"png"];
        chi102001 =[self loadPNGTexture:device fromFilePath:pngFilePath15];
        
        NSString *pngFilePath16 = [[NSBundle mainBundle] pathForResource:@"hold/102002" ofType:@"png"];
        chi102002 =[self loadPNGTexture:device fromFilePath:pngFilePath16];
        
        NSString *pngFilePath17 = [[NSBundle mainBundle] pathForResource:@"hold/102003" ofType:@"png"];
        chi102003 =[self loadPNGTexture:device fromFilePath:pngFilePath17];
        
        NSString *pngFilePath18 = [[NSBundle mainBundle] pathForResource:@"hold/102004" ofType:@"png"];
        chi102004 =[self loadPNGTexture:device fromFilePath:pngFilePath18];
        
        NSString *pngFilePath19 = [[NSBundle mainBundle] pathForResource:@"hold/102005" ofType:@"png"];
        chi102005 =[self loadPNGTexture:device fromFilePath:pngFilePath19];
        
        NSString *pngFilePath20 = [[NSBundle mainBundle] pathForResource:@"hold/102007" ofType:@"png"];
        chi102007 =[self loadPNGTexture:device fromFilePath:pngFilePath20];
        
        NSString *pngFilePath21 = [[NSBundle mainBundle] pathForResource:@"hold/102008" ofType:@"png"];
        chi102008 =[self loadPNGTexture:device fromFilePath:pngFilePath21];
        
        NSString *pngFilePath22 = [[NSBundle mainBundle] pathForResource:@"hold/102105" ofType:@"png"];
        chi102105 =[self loadPNGTexture:device fromFilePath:pngFilePath22];
        
        NSString *pngFilePath23 = [[NSBundle mainBundle] pathForResource:@"hold/103001" ofType:@"png"];
        chi103001 =[self loadPNGTexture:device fromFilePath:pngFilePath23];
        
        NSString *pngFilePath24 = [[NSBundle mainBundle] pathForResource:@"hold/103002" ofType:@"png"];
        chi103002 =[self loadPNGTexture:device fromFilePath:pngFilePath24];
        
        NSString *pngFilePath25 = [[NSBundle mainBundle] pathForResource:@"hold/103003" ofType:@"png"];
        chi103003 =[self loadPNGTexture:device fromFilePath:pngFilePath25];
        
        NSString *pngFilePath26 = [[NSBundle mainBundle] pathForResource:@"hold/103004" ofType:@"png"];
        chi103004 =[self loadPNGTexture:device fromFilePath:pngFilePath26];
        
        NSString *pngFilePath27 = [[NSBundle mainBundle] pathForResource:@"hold/103005" ofType:@"png"];
        chi103005 =[self loadPNGTexture:device fromFilePath:pngFilePath27];
        
        NSString *pngFilePath28 = [[NSBundle mainBundle] pathForResource:@"hold/103006" ofType:@"png"];
        chi103006 =[self loadPNGTexture:device fromFilePath:pngFilePath28];
        
        NSString *pngFilePath29 = [[NSBundle mainBundle] pathForResource:@"hold/103007" ofType:@"png"];
        chi103007 =[self loadPNGTexture:device fromFilePath:pngFilePath29];
        
        NSString *pngFilePath30 = [[NSBundle mainBundle] pathForResource:@"hold/103008" ofType:@"png"];
        chi103008 =[self loadPNGTexture:device fromFilePath:pngFilePath30];
        
        NSString *pngFilePath31 = [[NSBundle mainBundle] pathForResource:@"hold/103009" ofType:@"png"];
        chi103009 =[self loadPNGTexture:device fromFilePath:pngFilePath31];
        
        NSString *pngFilePath32 = [[NSBundle mainBundle] pathForResource:@"hold/103010" ofType:@"png"];
        chi103010 =[self loadPNGTexture:device fromFilePath:pngFilePath32];
        
        NSString *pngFilePath33 = [[NSBundle mainBundle] pathForResource:@"hold/103011" ofType:@"png"];
        chi103011 =[self loadPNGTexture:device fromFilePath:pngFilePath33];
        
        NSString *pngFilePath34 = [[NSBundle mainBundle] pathForResource:@"hold/103012" ofType:@"png"];
        chi103012 =[self loadPNGTexture:device fromFilePath:pngFilePath34];
        
        NSString *pngFilePath35 = [[NSBundle mainBundle] pathForResource:@"hold/103013" ofType:@"png"];
        chi103013 =[self loadPNGTexture:device fromFilePath:pngFilePath35];
        
        NSString *pngFilePath36 = [[NSBundle mainBundle] pathForResource:@"hold/103014" ofType:@"png"];
        chi103014 =[self loadPNGTexture:device fromFilePath:pngFilePath36];
        
        NSString *pngFilePath37 = [[NSBundle mainBundle] pathForResource:@"hold/103015" ofType:@"png"];
        chi103015 =[self loadPNGTexture:device fromFilePath:pngFilePath37];
        
        NSString *pngFilePath38 = [[NSBundle mainBundle] pathForResource:@"hold/103016" ofType:@"png"];
        chi103016 =[self loadPNGTexture:device fromFilePath:pngFilePath38];
        
        NSString *pngFilePath39 = [[NSBundle mainBundle] pathForResource:@"hold/103100" ofType:@"png"];
        chi103100 =[self loadPNGTexture:device fromFilePath:pngFilePath39];
        
        NSString *pngFilePath40 = [[NSBundle mainBundle] pathForResource:@"hold/104001" ofType:@"png"];
        chi104001 =[self loadPNGTexture:device fromFilePath:pngFilePath40];
        
        NSString *pngFilePath41 = [[NSBundle mainBundle] pathForResource:@"hold/104002" ofType:@"png"];
        chi104002 =[self loadPNGTexture:device fromFilePath:pngFilePath41];
        
        NSString *pngFilePath42 = [[NSBundle mainBundle] pathForResource:@"hold/104003" ofType:@"png"];
        chi104003 =[self loadPNGTexture:device fromFilePath:pngFilePath42];
        
        NSString *pngFilePath43 = [[NSBundle mainBundle] pathForResource:@"hold/104005" ofType:@"png"];
        chi104005 =[self loadPNGTexture:device fromFilePath:pngFilePath43];
        
        NSString *pngFilePath44 = [[NSBundle mainBundle] pathForResource:@"hold/104100" ofType:@"png"];
        chi104100 =[self loadPNGTexture:device fromFilePath:pngFilePath44];
        
        NSString *pngFilePath45 = [[NSBundle mainBundle] pathForResource:@"hold/105001" ofType:@"png"];
        chi105001 =[self loadPNGTexture:device fromFilePath:pngFilePath45];
        
        NSString *pngFilePath46 = [[NSBundle mainBundle] pathForResource:@"hold/105002" ofType:@"png"];
        chi105002 =[self loadPNGTexture:device fromFilePath:pngFilePath46];
        
        NSString *pngFilePath47 = [[NSBundle mainBundle] pathForResource:@"hold/105010" ofType:@"png"];
        chi105010 =[self loadPNGTexture:device fromFilePath:pngFilePath47];
        
        NSString *pngFilePath48 = [[NSBundle mainBundle] pathForResource:@"hold/105012" ofType:@"png"];
        chi105012 =[self loadPNGTexture:device fromFilePath:pngFilePath48];
        
        NSString *pngFilePath49 = [[NSBundle mainBundle] pathForResource:@"hold/105013" ofType:@"png"];
        chi105013 =[self loadPNGTexture:device fromFilePath:pngFilePath49];
        
        NSString *pngFilePath50 = [[NSBundle mainBundle] pathForResource:@"hold/106001" ofType:@"png"];
        chi106001 =[self loadPNGTexture:device fromFilePath:pngFilePath50];
        
        NSString *pngFilePath51 = [[NSBundle mainBundle] pathForResource:@"hold/106002" ofType:@"png"];
        chi106002 =[self loadPNGTexture:device fromFilePath:pngFilePath51];
        
        NSString *pngFilePath52 = [[NSBundle mainBundle] pathForResource:@"hold/106003" ofType:@"png"];
        chi106003 =[self loadPNGTexture:device fromFilePath:pngFilePath52];
        
        NSString *pngFilePath53 = [[NSBundle mainBundle] pathForResource:@"hold/106004" ofType:@"png"];
        chi106004 =[self loadPNGTexture:device fromFilePath:pngFilePath53];
        
        NSString *pngFilePath54 = [[NSBundle mainBundle] pathForResource:@"hold/106005" ofType:@"png"];
        chi106005 =[self loadPNGTexture:device fromFilePath:pngFilePath54];
        
        NSString *pngFilePath55 = [[NSBundle mainBundle] pathForResource:@"hold/106006" ofType:@"png"];
        chi106006 =[self loadPNGTexture:device fromFilePath:pngFilePath55];
        
        NSString *pngFilePath56 = [[NSBundle mainBundle] pathForResource:@"hold/106008" ofType:@"png"];
        chi106008 =[self loadPNGTexture:device fromFilePath:pngFilePath56];
        
        NSString *pngFilePath57 = [[NSBundle mainBundle] pathForResource:@"hold/106010" ofType:@"png"];
        chi106010 =[self loadPNGTexture:device fromFilePath:pngFilePath57];
        
        NSString *pngFilePath58 = [[NSBundle mainBundle] pathForResource:@"hold/106011" ofType:@"png"];
        chi106011 =[self loadPNGTexture:device fromFilePath:pngFilePath58];
        
        NSString *pngFilePath59 = [[NSBundle mainBundle] pathForResource:@"hold/106094" ofType:@"png"];
        chi106094 =[self loadPNGTexture:device fromFilePath:pngFilePath59];
        
        NSString *pngFilePath60 = [[NSBundle mainBundle] pathForResource:@"hold/107001" ofType:@"png"];
        chi107001 =[self loadPNGTexture:device fromFilePath:pngFilePath60];
        
        NSString *pngFilePath61 = [[NSBundle mainBundle] pathForResource:@"hold/107006" ofType:@"png"];
        chi107006 =[self loadPNGTexture:device fromFilePath:pngFilePath61];
        
        NSString *pngFilePath62 = [[NSBundle mainBundle] pathForResource:@"hold/107007" ofType:@"png"];
        chi107007 =[self loadPNGTexture:device fromFilePath:pngFilePath62];
        
        NSString *pngFilePath63 = [[NSBundle mainBundle] pathForResource:@"hold/107008" ofType:@"png"];
        chi107008 =[self loadPNGTexture:device fromFilePath:pngFilePath63];
        
        NSString *pngFilePath64 = [[NSBundle mainBundle] pathForResource:@"hold/107010" ofType:@"png"];
        chi107010 =[self loadPNGTexture:device fromFilePath:pngFilePath64];
        
        NSString *pngFilePath65 = [[NSBundle mainBundle] pathForResource:@"hold/107909" ofType:@"png"];
        chi107909 =[self loadPNGTexture:device fromFilePath:pngFilePath65];
        
        NSString *pngFilePath66 = [[NSBundle mainBundle] pathForResource:@"hold/108000" ofType:@"png"];
        chi108000 =[self loadPNGTexture:device fromFilePath:pngFilePath66];
        
        NSString *pngFilePath67 = [[NSBundle mainBundle] pathForResource:@"hold/108001" ofType:@"png"];
        chi108002 =[self loadPNGTexture:device fromFilePath:pngFilePath67];
        
        NSString *pngFilePath68 = [[NSBundle mainBundle] pathForResource:@"hold/108004" ofType:@"png"];
        chi108003 =[self loadPNGTexture:device fromFilePath:pngFilePath68];
        
        NSString *pngFilePath69 = [[NSBundle mainBundle] pathForResource:@"hold/108006" ofType:@"png"];
        chi108006 =[self loadPNGTexture:device fromFilePath:pngFilePath69];
        
        NSString *pngFilePath70 = [[NSBundle mainBundle] pathForResource:@"hold/108010" ofType:@"png"];
        chi108010 =[self loadPNGTexture:device fromFilePath:pngFilePath70];
        
        NSString *pngFilePath71 = [[NSBundle mainBundle] pathForResource:@"hold/501002" ofType:@"png"];
        chi501002 =[self loadPNGTexture:device fromFilePath:pngFilePath71];
        
        NSString *pngFilePath72 = [[NSBundle mainBundle] pathForResource:@"hold/501003" ofType:@"png"];
        chi501003 =[self loadPNGTexture:device fromFilePath:pngFilePath72];
        
        NSString *pngFilePath73 = [[NSBundle mainBundle] pathForResource:@"hold/501005" ofType:@"png"];
        chi501005 =[self loadPNGTexture:device fromFilePath:pngFilePath73];
        
        NSString *pngFilePath74 = [[NSBundle mainBundle] pathForResource:@"hold/501006" ofType:@"png"];
        chi501006 =[self loadPNGTexture:device fromFilePath:pngFilePath74];
        
        NSString *pngFilePath75 = [[NSBundle mainBundle] pathForResource:@"hold/502002" ofType:@"png"];
        chi502002 =[self loadPNGTexture:device fromFilePath:pngFilePath75];
        
        NSString *pngFilePath76 = [[NSBundle mainBundle] pathForResource:@"hold/502003" ofType:@"png"];
        chi502003 =[self loadPNGTexture:device fromFilePath:pngFilePath76];
        
        NSString *pngFilePath77 = [[NSBundle mainBundle] pathForResource:@"hold/502005" ofType:@"png"];
        chi502005 =[self loadPNGTexture:device fromFilePath:pngFilePath77];
        
        NSString *pngFilePath78 = [[NSBundle mainBundle] pathForResource:@"hold/503002" ofType:@"png"];
        chi503002 =[self loadPNGTexture:device fromFilePath:pngFilePath78];
        
        NSString *pngFilePath79 = [[NSBundle mainBundle] pathForResource:@"hold/503003" ofType:@"png"];
        chi503003 =[self loadPNGTexture:device fromFilePath:pngFilePath79];
        
        NSString *pngFilePath80 = [[NSBundle mainBundle] pathForResource:@"hold/601001" ofType:@"png"];
        chi601001 =[self loadPNGTexture:device fromFilePath:pngFilePath80];
        
        NSString *pngFilePath81 = [[NSBundle mainBundle] pathForResource:@"hold/601003" ofType:@"png"];
        chi601003 =[self loadPNGTexture:device fromFilePath:pngFilePath81];
        
        NSString *pngFilePath82 = [[NSBundle mainBundle] pathForResource:@"hold/601005" ofType:@"png"];
        chi601005 =[self loadPNGTexture:device fromFilePath:pngFilePath82];
        
        NSString *pngFilePath83 = [[NSBundle mainBundle] pathForResource:@"hold/601006" ofType:@"png"];
        chi601006 =[self loadPNGTexture:device fromFilePath:pngFilePath83];
        
        NSString *pngFilePath84 = [[NSBundle mainBundle] pathForResource:@"hold/602001" ofType:@"png"];
        chi602001 =[self loadPNGTexture:device fromFilePath:pngFilePath84];
        
        NSString *pngFilePath85 = [[NSBundle mainBundle] pathForResource:@"hold/602002" ofType:@"png"];
        chi602002 =[self loadPNGTexture:device fromFilePath:pngFilePath85];
        
        NSString *pngFilePath86 = [[NSBundle mainBundle] pathForResource:@"hold/602004" ofType:@"png"];
        chi602004 =[self loadPNGTexture:device fromFilePath:pngFilePath86];
        
        NSString *pngFilePath88 = [[NSBundle mainBundle] pathForResource:@"hold/602009" ofType:@"png"];
        chi602009 =[self loadPNGTexture:device fromFilePath:pngFilePath88];
        
        NSString *pngFilePath89 = [[NSBundle mainBundle] pathForResource:@"hold/602075" ofType:@"png"];
        chi602075 =[self loadPNGTexture:device fromFilePath:pngFilePath89];
        
        NSString *pngFilePath90 = [[NSBundle mainBundle] pathForResource:@"hold/104004" ofType:@"png"];
        chi104004 =[self loadPNGTexture:device fromFilePath:pngFilePath90];
        
        
        
        
        
        /// 载具
        NSString *vhDaciaPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Dacia_" ofType:@"png"];
        VH_Dacia_ = [self loadPNGTexture:device fromFilePath:vhDaciaPath];
        
        NSString *vhUAZPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_UAZ" ofType:@"png"];
        VH_UAZ = [self loadPNGTexture:device fromFilePath:vhUAZPath];
        
        NSString *bpVH_BuggyPath = [[NSBundle mainBundle] pathForResource:@"载具/BP_VH_Buggy_" ofType:@"png"];
        BP_VH_Buggy_ = [self loadPNGTexture:device fromFilePath:bpVH_BuggyPath];
        
        NSString *bpVH_CoupeRBPath = [[NSBundle mainBundle] pathForResource:@"载具/BP_VH_CoupeRB_" ofType:@"png"];
        BP_VH_CoupeRB_ = [self loadPNGTexture:device fromFilePath:bpVH_CoupeRBPath];
        
        NSString *coupeRB_1Path = [[NSBundle mainBundle] pathForResource:@"载具/CoupeRB_1" ofType:@"png"];
        CoupeRB_1 = [self loadPNGTexture:device fromFilePath:coupeRB_1Path];
        
        NSString *vhMotorcyclePath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Motorcycle_" ofType:@"png"];
        VH_Motorcycle_ = [self loadPNGTexture:device fromFilePath:vhMotorcyclePath];
        
        NSString *vhMotorcycleCartPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_MotorcycleCart_" ofType:@"png"];
        VH_MotorcycleCart_ = [self loadPNGTexture:device fromFilePath:vhMotorcycleCartPath];
        
        NSString *motorcycleCartPath = [[NSBundle mainBundle] pathForResource:@"载具/MotorcycleCart" ofType:@"png"];
        MotorcycleCart = [self loadPNGTexture:device fromFilePath:motorcycleCartPath];
        
        NSString *vhPG117Path = [[NSBundle mainBundle] pathForResource:@"载具/VH_PG117" ofType:@"png"];
        VH_PG117 = [self loadPNGTexture:device fromFilePath:vhPG117Path];
        
        NSString *aquaRailPath = [[NSBundle mainBundle] pathForResource:@"载具/AquaRail_" ofType:@"png"];
        AquaRail_ = [self loadPNGTexture:device fromFilePath:aquaRailPath];
        
        NSString *vhStationWagonPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_StationWagon_C" ofType:@"png"];
        VH_StationWagon_C = [self loadPNGTexture:device fromFilePath:vhStationWagonPath];
        
        NSString *miradoPath = [[NSBundle mainBundle] pathForResource:@"载具/Mirado_" ofType:@"png"];
        Mirado_ = [self loadPNGTexture:device fromFilePath:miradoPath];
        
        NSString *pickUp0Path = [[NSBundle mainBundle] pathForResource:@"载具/PickUp_0" ofType:@"png"];
        PickUp_0 = [self loadPNGTexture:device fromFilePath:pickUp0Path];
        
        NSString *rony01Path = [[NSBundle mainBundle] pathForResource:@"载具/Rony_01_C" ofType:@"png"];
        Rony_01_C = [self loadPNGTexture:device fromFilePath:rony01Path];
        
        NSString *rony3Path = [[NSBundle mainBundle] pathForResource:@"载具/Rony_3_C" ofType:@"png"];
        Rony_3_C = [self loadPNGTexture:device fromFilePath:rony3Path];
        
        NSString *rony2Path = [[NSBundle mainBundle] pathForResource:@"载具/Rony_2_C" ofType:@"png"];
        Rony_2_C = [self loadPNGTexture:device fromFilePath:rony2Path];
        
        NSString *vhMiniBusPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_MiniBus_" ofType:@"png"];
        VH_MiniBus_ = [self loadPNGTexture:device fromFilePath:vhMiniBusPath];
        
        NSString *vhBRDMPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_BRDM" ofType:@"png"];
        VH_BRDM_ = [self loadPNGTexture:device fromFilePath:vhBRDMPath];
        
        NSString *bpVH_TukPath = [[NSBundle mainBundle] pathForResource:@"载具/BP_VH_Tuk_" ofType:@"png"];
        BP_VH_Tuk_ = [self loadPNGTexture:device fromFilePath:bpVH_TukPath];
        
        NSString *snowbikePath = [[NSBundle mainBundle] pathForResource:@"载具/Snowbike" ofType:@"png"];
        Snowbike = [self loadPNGTexture:device fromFilePath:snowbikePath];
        
        NSString *snowmobilePath = [[NSBundle mainBundle] pathForResource:@"载具/Snowmobile" ofType:@"png"];
        Snowmobile = [self loadPNGTexture:device fromFilePath:snowmobilePath];
        
        NSString *bpVH_BigfootPath = [[NSBundle mainBundle] pathForResource:@"载具/BP_VH_Bigfoot_C" ofType:@"png"];
        BP_VH_Bigfoot_C = [self loadPNGTexture:device fromFilePath:bpVH_BigfootPath];
        
        NSString *赛车path = [[NSBundle mainBundle] pathForResource:@"载具/saiche" ofType:@"png"];
        赛车 = [self loadPNGTexture:device fromFilePath:赛车path];
        
        
        
        
        NSString *vhMountainbikePath = [[NSBundle mainBundle] pathForResource:@"载具/zixing" ofType:@"jpg"];
        自行车 = [self loadPNGTexture:device fromFilePath:vhMountainbikePath];
        
        NSString *vhScooterPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Scooter_C" ofType:@"png"];
        VH_Scooter_C = [self loadPNGTexture:device fromFilePath:vhScooterPath];
        
        NSString *vhSportCarPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_4SportCar_C" ofType:@"png"];
        VH_4SportCar_C = [self loadPNGTexture:device fromFilePath:vhSportCarPath];
        
        NSString *vhATVPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_ATV1_C" ofType:@"png"];
        VH_ATV1_C = [self loadPNGTexture:device fromFilePath:vhATVPath];
        
        NSString *vhLadaPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_LadaNiva_01_C" ofType:@"png"];
        VH_LadaNiva_01_C = [self loadPNGTexture:device fromFilePath:vhLadaPath];
        
        NSString *vhMotorgliderPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Motorglider_C" ofType:@"png"];
        VH_Motorglider_C = [self loadPNGTexture:device fromFilePath:vhMotorgliderPath];
        
        NSString *vhHorsePath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Horse_" ofType:@"png"];
        VH_Horse_ = [self loadPNGTexture:device fromFilePath:vhHorsePath];
        
        
        NSString *LostMobilePath = [[NSBundle mainBundle] pathForResource:@"载具/VH_LostMobile" ofType:@"png"];
        VH_LostMobile = [self loadPNGTexture:device fromFilePath:LostMobilePath];
        
        
        NSString *DriftPath = [[NSBundle mainBundle] pathForResource:@"载具/VH_Drift_" ofType:@"png"];
        VH_Drift_ = [self loadPNGTexture:device fromFilePath:DriftPath];
        
        
        
        
        
        /// 医疗
        NSString *firstAidboxPath = [[NSBundle mainBundle] pathForResource:@"医疗/FirstAidbox_Pickup_C" ofType:@"png"];
        FirstAidbox_Pickup_C = [self loadPNGTexture:device fromFilePath:firstAidboxPath];
        
        NSString *firstaidPath = [[NSBundle mainBundle] pathForResource:@"医疗/Firstaid_Pickup_C" ofType:@"png"];
        Firstaid_Pickup_C = [self loadPNGTexture:device fromFilePath:firstaidPath];
        
        NSString *pillsPath = [[NSBundle mainBundle] pathForResource:@"医疗/Pills_Pickup_C" ofType:@"png"];
        Pills_Pickup_C = [self loadPNGTexture:device fromFilePath:pillsPath];
        
        NSString *drinkPath = [[NSBundle mainBundle] pathForResource:@"医疗/Drink_Pickup_C" ofType:@"png"];
        Drink_Pickup_C = [self loadPNGTexture:device fromFilePath:drinkPath];
        
        NSString *injectionPath = [[NSBundle mainBundle] pathForResource:@"医疗/Injection_Pickup_C" ofType:@"png"];
        Injection_Pickup_C = [self loadPNGTexture:device fromFilePath:injectionPath];
        
        /// 护具
        NSString *helmetLv3Path = [[NSBundle mainBundle] pathForResource:@"护具/Helmet_Lv3" ofType:@"png"];
        Helmet_Lv3 = [self loadPNGTexture:device fromFilePath:helmetLv3Path];
        
        NSString *helmetLv3APath = [[NSBundle mainBundle] pathForResource:@"护具/PickUp_BP_Helmet_Lv3_A_C" ofType:@"png"];
        PickUp_BP_Helmet_Lv3_A_C = [self loadPNGTexture:device fromFilePath:helmetLv3APath];
        
        NSString *helmetLv3BPath = [[NSBundle mainBundle] pathForResource:@"护具/PickUp_BP_Helmet_Lv3_B_C" ofType:@"png"];
        PickUp_BP_Helmet_Lv3_B_C = [self loadPNGTexture:device fromFilePath:helmetLv3BPath];
        
        NSString *bagLv3Path = [[NSBundle mainBundle] pathForResource:@"护具/Bag_Lv3" ofType:@"png"];
        Bag_Lv3 = [self loadPNGTexture:device fromFilePath:bagLv3Path];
        
        NSString *bagLv3APath = [[NSBundle mainBundle] pathForResource:@"护具/PickUp_BP_Bag_Lv3_A_C" ofType:@"png"];
        
        PickUp_BP_Bag_Lv3_A_C=[self loadPNGTexture:device fromFilePath:bagLv3APath];
        /// 投掷物
        
        NSString *stunGrenadePath = [[NSBundle mainBundle] pathForResource:@"投掷物/BP_Grenade_Stun_Weapon_Wrapper_" ofType:@"png"];
        BP_Grenade_Stun_Weapon_Wrapper_ = [self loadPNGTexture:device fromFilePath:stunGrenadePath];
        
        NSString *smokeGrenadePath = [[NSBundle mainBundle] pathForResource:@"投掷物/BP_Grenade_Smoke_Weapon_Wrapper" ofType:@"png"];
        BP_Grenade_Smoke_Weapon_Wrapper = [self loadPNGTexture:device fromFilePath:smokeGrenadePath];
        
        NSString *fragGrenadePath = [[NSBundle mainBundle] pathForResource:@"投掷物/BP_Grenade_Shoulei_Weapon_Wrapper" ofType:@"png"];
        BP_Grenade_Shoulei_Weapon_Wrapper = [self loadPNGTexture:device fromFilePath:fragGrenadePath];
        
        NSString *molotovPath = [[NSBundle mainBundle] pathForResource:@"投掷物/BP_Grenade_Burn_Weapon_Wrapper_" ofType:@"png"];
        BP_Grenade_Burn_Weapon_Wrapper_ = [self loadPNGTexture:device fromFilePath:molotovPath];
        
        /// 其他物品
        NSString *gasCanPath = [[NSBundle mainBundle] pathForResource:@"其他/GasCanBattery_Destructible_Pick" ofType:@"png"];
        GasCanBattery_Destructible_Pick = [self loadPNGTexture:device fromFilePath:gasCanPath];
        
        NSString *superDropPlanePath = [[NSBundle mainBundle] pathForResource:@"其他/BP_AirDropPlane_SuperPeople_C" ofType:@"png"];
        BP_AirDropPlane_SuperPeople_C = [self loadPNGTexture:device fromFilePath:superDropPlanePath];
        
        NSString *superDropBoxPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_AirDropBox_SuperPeople_C" ofType:@"png"];
        BP_AirDropBox_SuperPeople_C = [self loadPNGTexture:device fromFilePath:superDropBoxPath];
        
        NSString *dropPlanePath = [[NSBundle mainBundle] pathForResource:@"其他/BP_AirDropPlane_C" ofType:@"png"];
        BP_AirDropPlane_C = [self loadPNGTexture:device fromFilePath:dropPlanePath];
        
        NSString *dropBoxPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_AirDropBox_C" ofType:@"png"];
        BP_AirDropBox_C = [self loadPNGTexture:device fromFilePath:dropBoxPath];
        
        NSString *dropBox1Path = [[NSBundle mainBundle] pathForResource:@"其他/BP_CG025_AirDropBox_C" ofType:@"png"];
        BP_CG025_AirDropBox_C = [self loadPNGTexture:device fromFilePath:dropBox1Path];
        
        NSString *revivalAEDPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_revivalAED_Pickup_C" ofType:@"png"];
        BP_revivalAED_Pickup_C = [self loadPNGTexture:device fromFilePath:revivalAEDPath];
        
        NSString *flareGunPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_Pistol_Flaregun_Wrapper_C" ofType:@"png"];
        BP_Pistol_Flaregun_Wrapper_C = [self loadPNGTexture:device fromFilePath:flareGunPath];
        
        NSString *flareGun1Path = [[NSBundle mainBundle] pathForResource:@"其他/Pistol_Flaregun" ofType:@"png"];
        Pistol_Flaregun = [self loadPNGTexture:device fromFilePath:flareGun1Path];
        
        NSString *deadInventoryBoxPath = [[NSBundle mainBundle] pathForResource:@"其他/CharacterDeadInventoryBox_C" ofType:@"png"];
        CharacterDeadInventoryBox_C = [self loadPNGTexture:device fromFilePath:deadInventoryBoxPath];
        
        /// 枪托
        NSString *sniperStockPath = [[NSBundle mainBundle] pathForResource:@"枪托/BP_QT_Sniper_Pickup_C" ofType:@"png"];
        BP_QT_Sniper_Pickup_C = [self loadPNGTexture:device fromFilePath:sniperStockPath];
        
        NSString *tacticalStockPath = [[NSBundle mainBundle] pathForResource:@"枪托/BP_QT_A_Pickup_C" ofType:@"png"];
        BP_QT_A_Pickup_C = [self loadPNGTexture:device fromFilePath:tacticalStockPath];
        
        NSString *uziStockPath = [[NSBundle mainBundle] pathForResource:@"枪托/BP_QT_UZI_Pickup_C" ofType:@"png"];
        BP_QT_UZI_Pickup_C = [self loadPNGTexture:device fromFilePath:uziStockPath];
        
        /// 枪口
        NSString *sniperSuppressorPath = [[NSBundle mainBundle] pathForResource:@"枪口/BP_QK_Sniper_Supperssor_Pickup_" ofType:@"png"];
        BP_QK_Sniper_Supperssor_Pickup_ = [self loadPNGTexture:device fromFilePath:sniperSuppressorPath];
        
        NSString *sniperFlashHiderPath = [[NSBundle mainBundle] pathForResource:@"枪口/BP_QK_Sniper_FlashHider_Pickup_" ofType:@"png"];
        BP_QK_Sniper_FlashHider_Pickup_ = [self loadPNGTexture:device fromFilePath:sniperFlashHiderPath];
        
        NSString *rifleSuppressorPath = [[NSBundle mainBundle] pathForResource:@"枪口/BP_QK_Large_Supperssor_Pickup_" ofType:@"png"];
        BP_QK_Large_Supperssor_Pickup_ = [self loadPNGTexture:device fromFilePath:rifleSuppressorPath];
        
        NSString *rifleCompensatorPath = [[NSBundle mainBundle] pathForResource:@"枪口/BP_QK_Large_Compensator_Pickup_" ofType:@"png"];
        BP_QK_Large_Compensator_Pickup_ = [self loadPNGTexture:device fromFilePath:rifleCompensatorPath];
        
        NSString *smgSuppressorPath = [[NSBundle mainBundle] pathForResource:@"枪口/BP_QK_Mid_Supperssor_Pickup_" ofType:@"png"];
        BP_QK_Mid_Supperssor_Pickup_ = [self loadPNGTexture:device fromFilePath:smgSuppressorPath];
        
        /// 握把
        NSString *laserSightPath = [[NSBundle mainBundle] pathForResource:@"握把/BP_WB_Lasersight_Pickup_C" ofType:@"png"];
        BP_WB_Lasersight_Pickup_C = [self loadPNGTexture:device fromFilePath:laserSightPath];
        
        NSString *thumbGripPath = [[NSBundle mainBundle] pathForResource:@"握把/BP_WB_ThumbGrip_Pickup_C" ofType:@"png"];
        BP_WB_ThumbGrip_Pickup_C = [self loadPNGTexture:device fromFilePath:thumbGripPath];
        
        NSString *lightGripPath = [[NSBundle mainBundle] pathForResource:@"握把/BP_WB_LightGrip_Pickup_C" ofType:@"png"];
        BP_WB_LightGrip_Pickup_C = [self loadPNGTexture:device fromFilePath:lightGripPath];
        
        NSString *angledGripPath = [[NSBundle mainBundle] pathForResource:@"握把/BP_WB_Angled_Pickup_C" ofType:@"png"];
        BP_WB_Angled_Pickup_C = [self loadPNGTexture:device fromFilePath:angledGripPath];
        
        NSString *verticalGripPath = [[NSBundle mainBundle] pathForResource:@"握把/BP_WB_Vertical_Pickup_C" ofType:@"png"];
        BP_WB_Vertical_Pickup_C = [self loadPNGTexture:device fromFilePath:verticalGripPath];
        /// 扩容
        NSString *largeEQPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Large_EQ_Pickup_C" ofType:@"png"];
        BP_DJ_Large_EQ_Pickup_C = [self loadPNGTexture:device fromFilePath:largeEQPickupPath];
        
        NSString *largeEPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Large_E_Pickup_C" ofType:@"png"];
        BP_DJ_Large_E_Pickup_C = [self loadPNGTexture:device fromFilePath:largeEPickupPath];
        
        NSString *sniperEQPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Sniper_EQ_Pickup_C" ofType:@"png"];
        BP_DJ_Sniper_EQ_Pickup_C = [self loadPNGTexture:device fromFilePath:sniperEQPickupPath];
        
        NSString *sniperEPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Sniper_E_Pickup_C" ofType:@"png"];
        BP_DJ_Sniper_E_Pickup_C = [self loadPNGTexture:device fromFilePath:sniperEPickupPath];
        
        NSString *midEQPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Mid_EQ_Pickup_C" ofType:@"png"];
        BP_DJ_Mid_EQ_Pickup_C = [self loadPNGTexture:device fromFilePath:midEQPickupPath];
        
        NSString *midEPickupPath = [[NSBundle mainBundle] pathForResource:@"扩容/BP_DJ_Mid_E_Pickup_C" ofType:@"png"];
        BP_DJ_Mid_E_Pickup_C = [self loadPNGTexture:device fromFilePath:midEPickupPath];
        
        /// 倍镜
        NSString *m3XPickupPath = [[NSBundle mainBundle] pathForResource:@"倍镜/BP_MZJ_3X_Pickup_C" ofType:@"png"];
        BP_MZJ_3X_Pickup_C = [self loadPNGTexture:device fromFilePath:m3XPickupPath];
        
        NSString *m4XPickupPath = [[NSBundle mainBundle] pathForResource:@"倍镜/BP_MZJ_4X_Pickup_C" ofType:@"png"];
        BP_MZJ_4X_Pickup_C = [self loadPNGTexture:device fromFilePath:m4XPickupPath];
        
        NSString *m6XPickupPath = [[NSBundle mainBundle] pathForResource:@"倍镜/BP_MZJ_6X_Pickup_C" ofType:@"png"];
        BP_MZJ_6X_Pickup_C = [self loadPNGTexture:device fromFilePath:m6XPickupPath];
        
        NSString *m8XPickupPath = [[NSBundle mainBundle] pathForResource:@"倍镜/BP_MZJ_8X_Pickup_C" ofType:@"png"];
        BP_MZJ_8X_Pickup_C = [self loadPNGTexture:device fromFilePath:m8XPickupPath];
        
        /// 近战武器
        NSString *panPickupPath = [[NSBundle mainBundle] pathForResource:@"近战武器/BP_WEP_Pan_Pickup_C" ofType:@"png"];
        BP_WEP_Pan_Pickup_C = [self loadPNGTexture:device fromFilePath:panPickupPath];
        
        NSString *machetePickupPath = [[NSBundle mainBundle] pathForResource:@"近战武器/BP_WEP_Machete_Pickup_C" ofType:@"png"];
        BP_WEP_Machete_Pickup_C = [self loadPNGTexture:device fromFilePath:machetePickupPath];
        
        NSString *sicklePickupPath = [[NSBundle mainBundle] pathForResource:@"近战武器/BP_WEP_Sickle_Pickup_C" ofType:@"png"];
        BP_WEP_Sickle_Pickup_C = [self loadPNGTexture:device fromFilePath:sicklePickupPath];
        
        NSString *cowbarPickupPath = [[NSBundle mainBundle] pathForResource:@"近战武器/BP_WEP_Cowbar_Pickup_C" ofType:@"png"];
        BP_WEP_Cowbar_Pickup_C = [self loadPNGTexture:device fromFilePath:cowbarPickupPath];
        
        /// 子弹
        NSString *ammo556Path = [[NSBundle mainBundle] pathForResource:@"子弹/BP_Ammo_556mm_Pickup_C" ofType:@"png"];
        BP_Ammo_556mm_Pickup_C = [self loadPNGTexture:device fromFilePath:ammo556Path];
        
        NSString *ammo762Path = [[NSBundle mainBundle] pathForResource:@"子弹/BP_Ammo_762mm_Pickup_C" ofType:@"png"];
        BP_Ammo_762mm_Pickup_C = [self loadPNGTexture:device fromFilePath:ammo762Path];
        
        NSString *ammo300MagnumPath = [[NSBundle mainBundle] pathForResource:@"子弹/BP_Ammo_300Magnum_Pickup_C" ofType:@"png"];
        BP_Ammo_300Magnum_Pickup_C = [self loadPNGTexture:device fromFilePath:ammo300MagnumPath];
        
        NSString *ammo50BMGPath = [[NSBundle mainBundle] pathForResource:@"子弹/BP_Ammo_50BMG_Pickup_C" ofType:@"png"];
        BP_Ammo_50BMG_Pickup_C = [self loadPNGTexture:device fromFilePath:ammo50BMGPath];
        
        /// 其他枪械
        NSString *mg3Path = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_MG3_Wrapper_C" ofType:@"png"];
        BP_Other_MG3_Wrapper_C = [self loadPNGTexture:device fromFilePath:mg3Path];
        
        NSString *pkmPath = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_PKM_Wrapper_C" ofType:@"png"];
        BP_Other_PKM_Wrapper_C = [self loadPNGTexture:device fromFilePath:pkmPath];
        
        NSString *m249Path = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_M249_Wrapper_C" ofType:@"png"];
        BP_Other_M249_Wrapper_C = [self loadPNGTexture:device fromFilePath:m249Path];
        
        NSString *dp28Path = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_DP28_Wrapper_C" ofType:@"png"];
        BP_Other_DP28_Wrapper_C = [self loadPNGTexture:device fromFilePath:dp28Path];
        
        NSString *shieldPath = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_Shield_Wrapper_C" ofType:@"png"];
        BP_Other_Shield_Wrapper_C = [self loadPNGTexture:device fromFilePath:shieldPath];
        
        NSString *huntingBowPath = [[NSBundle mainBundle] pathForResource:@"其他枪械/BP_Other_HuntingBow_Wrapper_C" ofType:@"png"];
        BP_Other_HuntingBow_Wrapper_C = [self loadPNGTexture:device fromFilePath:huntingBowPath];
        
        /// 散弹枪
        NSString *dp12Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_DP12_Wrapper_C" ofType:@"png"];
        BP_ShotGun_DP12_Wrapper_C = [self loadPNGTexture:device fromFilePath:dp12Path];
        
        NSString *spas12Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_SPAS_12_Wrapper_C" ofType:@"png"];
        BP_ShotGun_SPAS_12_Wrapper_C = [self loadPNGTexture:device fromFilePath:spas12Path];
        
        NSString *s12kPath = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_S12K_Wrapper_C" ofType:@"png"];
        BP_ShotGun_S12K_Wrapper_C = [self loadPNGTexture:device fromFilePath:s12kPath];
        
        NSString *aa12Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_AA12_Wrapper_C" ofType:@"png"];
        BP_ShotGun_AA12_Wrapper_C = [self loadPNGTexture:device fromFilePath:aa12Path];
        
        NSString *s1897Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_S1897_Wrapper_C" ofType:@"png"];
        BP_ShotGun_S1897_Wrapper_C = [self loadPNGTexture:device fromFilePath:s1897Path];
        
        NSString *s686Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_ShotGun_S686_Wrapper_C" ofType:@"png"];
        BP_ShotGun_S686_Wrapper_C = [self loadPNGTexture:device fromFilePath:s686Path];
        
        NSString *tmp9Path = [[NSBundle mainBundle] pathForResource:@"散弹枪/BP_Pistol_TMP_Wrapper_C" ofType:@"png"];
        BP_Pistol_TMP_Wrapper_C = [self loadPNGTexture:device fromFilePath:tmp9Path];
        /// 冲锋枪
        NSString *mp5kPath = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_MP5K_Wrapper_C" ofType:@"png"];
        BP_MachineGun_MP5K_Wrapper_C = [self loadPNGTexture:device fromFilePath:mp5kPath];
        
        NSString *pp19Path = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_PP19_Wrapper_C" ofType:@"png"];
        BP_MachineGun_PP19_Wrapper_C = [self loadPNGTexture:device fromFilePath:pp19Path];
        
        NSString *p90Path = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_P90CG17_Wrapper_C" ofType:@"png"];
        BP_MachineGun_P90CG17_Wrapper_C = [self loadPNGTexture:device fromFilePath:p90Path];
        
        NSString *tommyGunPath = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_TommyGun_Wrapper_" ofType:@"png"];
        BP_MachineGun_TommyGun_Wrapper_ = [self loadPNGTexture:device fromFilePath:tommyGunPath];
        
        NSString *vectorPath = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_Vector_Wrapper_C" ofType:@"png"];
        BP_MachineGun_Vector_Wrapper_C = [self loadPNGTexture:device fromFilePath:vectorPath];
        
        NSString *ump9Path = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_UMP9_Wrapper_C" ofType:@"png"];
        BP_MachineGun_UMP9_Wrapper_C = [self loadPNGTexture:device fromFilePath:ump9Path];
        
        NSString *uziPath = [[NSBundle mainBundle] pathForResource:@"冲锋枪/BP_MachineGun_Uzi_Wrapper_C" ofType:@"png"];
        BP_MachineGun_Uzi_Wrapper_C = [self loadPNGTexture:device fromFilePath:uziPath];
        
        /// 狙击步枪
        NSString *m24Path = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_M24_Wrapper_C" ofType:@"png"];
        BP_Sniper_M24_Wrapper_C = [self loadPNGTexture:device fromFilePath:m24Path];
        
        NSString *amrPath = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_AMR_Wrapper_C" ofType:@"png"];
        BP_Sniper_AMR_Wrapper_C = [self loadPNGTexture:device fromFilePath:amrPath];
        
        NSString *m200Path = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_M200_Wrapper_C" ofType:@"png"];
        BP_Sniper_M200_Wrapper_C = [self loadPNGTexture:device fromFilePath:m200Path];
        
        NSString *awmPath = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_AWM_Wrapper_C" ofType:@"png"];
        BP_Sniper_AWM_Wrapper_C = [self loadPNGTexture:device fromFilePath:awmPath];
        
        NSString *kar98kPath = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_Kar98K_Wrapper_C" ofType:@"png"];
        BP_Sniper_Kar98K_Wrapper_C = [self loadPNGTexture:device fromFilePath:kar98kPath];
        
        NSString *mosinPath = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_Mosin_Wrapper_C" ofType:@"png"];
        BP_Sniper_Mosin_Wrapper_C = [self loadPNGTexture:device fromFilePath:mosinPath];
        
        NSString *win94Path = [[NSBundle mainBundle] pathForResource:@"狙击步枪/BP_Sniper_Win94_Wrapper_C" ofType:@"png"];
        BP_Sniper_Win94_Wrapper_C = [self loadPNGTexture:device fromFilePath:win94Path];
        
        /// 射手步枪
        NSString *mk14Path = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_WEP_Mk14_Wrapper_C" ofType:@"png"];
        BP_WEP_Mk14_Wrapper_C = [self loadPNGTexture:device fromFilePath:mk14Path];
        
        NSString *mini14Path = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_Mini14_Wrapper_C" ofType:@"png"];
        BP_Sinper_Mini14_Wrapper_C = [self loadPNGTexture:device fromFilePath:mini14Path];
        
        NSString *vssPath = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_VSS_Wrapper_C" ofType:@"png"];
        BP_Sinper_VSS_Wrapper_C = [self loadPNGTexture:device fromFilePath:vssPath];
        
        NSString *sksPath = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_SKS_Wrapper_C" ofType:@"png"];
        BP_Sinper_SKS_Wrapper_C = [self loadPNGTexture:device fromFilePath:sksPath];
        
        NSString *qbuPath = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_QBU_Wrapper_C" ofType:@"png"];
        BP_Sinper_QBU_Wrapper_C = [self loadPNGTexture:device fromFilePath:qbuPath];
        
        NSString *slrPath = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_SLR_Wrapper_C" ofType:@"png"];
        BP_Sinper_SLR_Wrapper_C = [self loadPNGTexture:device fromFilePath:slrPath];
        
        NSString *mk12Path = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_MK12_Wrapper_C" ofType:@"png"];
        BP_Sinper_MK12_Wrapper_C = [self loadPNGTexture:device fromFilePath:mk12Path];
        
        NSString *mk20Path = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Sinper_MK20_Wrapper_C" ofType:@"png"];
        BP_Sinper_MK20_Wrapper_C = [self loadPNGTexture:device fromFilePath:mk20Path];
        
        NSString *m417Path = [[NSBundle mainBundle] pathForResource:@"射手步枪/BP_Rifle_M417_Wrapper_C" ofType:@"png"];
        BP_Rifle_M417_Wrapper_C = [self loadPNGTexture:device fromFilePath:m417Path];
        
        /// 762突击步枪
        NSString *m762Path = [[NSBundle mainBundle] pathForResource:@"762突击步枪/BP_Rifle_M762_Wrapper_C" ofType:@"png"];
        BP_Rifle_M762_Wrapper_C = [self loadPNGTexture:device fromFilePath:m762Path];
        
        NSString *grozaPath = [[NSBundle mainBundle] pathForResource:@"762突击步枪/BP_Rifle_Groza_Wrapper_C" ofType:@"png"];
        BP_Rifle_Groza_Wrapper_C = [self loadPNGTexture:device fromFilePath:grozaPath];
        
        NSString *mk47Path = [[NSBundle mainBundle] pathForResource:@"762突击步枪/BP_Rifle_Mk47_Wrapper_C" ofType:@"png"];
        BP_Rifle_Mk47_Wrapper_C = [self loadPNGTexture:device fromFilePath:mk47Path];
        
        NSString *honeyBadgerPath = [[NSBundle mainBundle] pathForResource:@"762突击步枪/BP_Rifle_HoneyBadger_Wrapper_C" ofType:@"png"];
        BP_Rifle_HoneyBadger_Wrapper_C = [self loadPNGTexture:device fromFilePath:honeyBadgerPath];
        
        NSString *akmPath = [[NSBundle mainBundle] pathForResource:@"762突击步枪/BP_Rifle_AKM_Wrapper_C" ofType:@"png"];
        BP_Rifle_AKM_Wrapper_C = [self loadPNGTexture:device fromFilePath:akmPath];
        /// 556突击步枪
        NSString *qbzPath = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_QBZ_Wrapper_C" ofType:@"png"];
        BP_Rifle_QBZ_Wrapper_C = [self loadPNGTexture:device fromFilePath:qbzPath];
        
        NSString *augPath = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_AUG_Wrapper_C" ofType:@"png"];
        BP_Rifle_AUG_Wrapper_C = [self loadPNGTexture:device fromFilePath:augPath];
        
        NSString *valPath = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_VAL_Wrapper_C" ofType:@"png"];
        BP_Rifle_VAL_Wrapper_C = [self loadPNGTexture:device fromFilePath:valPath];
        
        NSString *g36Path = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_G36_Wrapper_C" ofType:@"png"];
        BP_Rifle_G36_Wrapper_C = [self loadPNGTexture:device fromFilePath:g36Path];
        
        NSString *m416Path = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_M416_Wrapper_C" ofType:@"png"];
        BP_Rifle_M416_Wrapper_C = [self loadPNGTexture:device fromFilePath:m416Path];
        
        NSString *scarPath = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_SCAR_Wrapper_C" ofType:@"png"];
        BP_Rifle_SCAR_Wrapper_C = [self loadPNGTexture:device fromFilePath:scarPath];
        
        NSString *m16a4Path = [[NSBundle mainBundle] pathForResource:@"556突击步枪/BP_Rifle_M16A4_Wrapper_C" ofType:@"png"];
        BP_Rifle_M16A4_Wrapper_C = [self loadPNGTexture:device fromFilePath:m16a4Path];
        
        /// 警告
        NSString *grenadeWarningPath = [[NSBundle mainBundle] pathForResource:@"警告/ProjGrenade_BP_C" ofType:@"png"];
        ProjGrenade_BP_C = [self loadPNGTexture:device fromFilePath:grenadeWarningPath];
        
        NSString *smokeWarningPath = [[NSBundle mainBundle] pathForResource:@"警告/ProjSmoke_BP_C" ofType:@"png"];
        ProjSmoke_BP_C = [self loadPNGTexture:device fromFilePath:smokeWarningPath];
        
        NSString *burnWarningPath = [[NSBundle mainBundle] pathForResource:@"警告/ProjBurn_BP_C" ofType:@"png"];
        ProjBurn_BP_C = [self loadPNGTexture:device fromFilePath:burnWarningPath];
        
        NSString *stunWarningPath = [[NSBundle mainBundle] pathForResource:@"警告/ProjStun_BP_C" ofType:@"png"];
        ProjStun_BP_C = [self loadPNGTexture:device fromFilePath:stunWarningPath];
        
        /// 手持
        NSString *handGrenadePath = [[NSBundle mainBundle] pathForResource:@"手持/BP_Grenade_Shoulei_Weapon_Wrapper" ofType:@"png"];
        BP_Grenade_Shoulei_Weapon_C = [self loadPNGTexture:device fromFilePath:handGrenadePath];
        
        NSString *handStunPath = [[NSBundle mainBundle] pathForResource:@"手持/BP_Grenade_Stun_Weapon_Wrapper_" ofType:@"png"];
        BP_Grenade_Stun_Weapon_C = [self loadPNGTexture:device fromFilePath:handStunPath];
        
        NSString *handSmokePath = [[NSBundle mainBundle] pathForResource:@"手持/BP_Grenade_Smoke_Weapon_Wrapper" ofType:@"png"];
        BP_Grenade_Smoke_Weapon_C = [self loadPNGTexture:device fromFilePath:handSmokePath];
        
        NSString *handBurnPath = [[NSBundle mainBundle] pathForResource:@"手持/BP_Grenade_Burn_Weapon_Wrapper_" ofType:@"png"];
        BP_Grenade_Burn_Weapon_C = [self loadPNGTexture:device fromFilePath:handBurnPath];
        
        /// 其他
        NSString *deadListBoxPath = [[NSBundle mainBundle] pathForResource:@"其他/CharacterDeadInventoryBox_C" ofType:@"png"];
        BP_PlayerDeadListWrapper_C = [self loadPNGTexture:device fromFilePath:deadListBoxPath];
        
        NSString *airDropListPath = [[NSBundle mainBundle] pathForResource:@"其他/AirDropListWrapperActor_C" ofType:@"png"];
        AirDropListWrapperActor_C = [self loadPNGTexture:device fromFilePath:airDropListPath];
        
        NSString *teamDropPath = [[NSBundle mainBundle] pathForResource:@"其他/Bp_AirDrop_C" ofType:@"png"];
        Bp_AirDrop_C = [self loadPNGTexture:device fromFilePath:teamDropPath];
        
        NSString *cannonPickupPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_CG024HumanCannon_Pickup_C" ofType:@"png"];
        BP_CG024HumanCannon_Pickup_C = [self loadPNGTexture:device fromFilePath:cannonPickupPath];
        
        NSString *emergencyCallPath = [[NSBundle mainBundle] pathForResource:@"其他/BP_Grenade_EmergencyCall_Weapon" ofType:@"png"];
        BP_Grenade_EmergencyCall_Weapon = [self loadPNGTexture:device fromFilePath:emergencyCallPath];
        
     
        
        NSString *Armor_Lv3BikePath = [[NSBundle mainBundle] pathForResource:@"护具/Armor_Lv3" ofType:@"png"];
        Armor_Lv3 = [self loadPNGTexture:device fromFilePath:Armor_Lv3BikePath];
        
        NSString *Armor_Lv3BikePath1 = [[NSBundle mainBundle] pathForResource:@"倒地" ofType:@"png"];
        daodi = [self loadPNGTexture:device fromFilePath:Armor_Lv3BikePath1];
           
        
    });
}




- (id<MTLTexture>)loadPNGTexture:(id<MTLDevice>)device fromFilePath:(NSString *)filePath {
    if (!device) {
     
        return nil;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      
        return nil;
    }

    NSError *readErr = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingMappedIfSafe
                                                error:&readErr];
    if (!fileData) {
      
        return nil;
    }

    int w = 0, h = 0, channels = 0;
    unsigned char *pixels = stbi_load_from_memory((const stbi_uc *)fileData.bytes,
                                                  (int)fileData.length,
                                                  &w, &h, &channels,
                                                  STBI_rgb_alpha);
    if (!pixels) {
        const char *reason = stbi_failure_reason();
        NSLog(@"[Texture][ERR] stbi 解码失败: %@  reason=%s",
              filePath, reason ? reason : "(null)");
        return nil;
    }
    if (w <= 0 || h <= 0) {
        stbi_image_free(pixels);
        NSLog(@"[Texture][ERR] 图像尺寸异常: %dx%d  file=%@", w, h, filePath);
        return nil;
    }

    MTLTextureDescriptor *desc =
        [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                           width:w
                                                          height:h
                                                       mipmapped:NO];
    desc.usage = MTLTextureUsageShaderRead;
    desc.storageMode = MTLStorageModeShared;

    id<MTLTexture> texture = [device newTextureWithDescriptor:desc];
    if (!texture) {
        stbi_image_free(pixels);
        NSLog(@"[Texture][ERR] 创建 Metal 纹理失败: %@", filePath);
        return nil;
    }

    [texture replaceRegion:MTLRegionMake2D(0, 0, w, h)
               mipmapLevel:0
                 withBytes:pixels
               bytesPerRow:w * 4];

    stbi_image_free(pixels);
    return texture;
}

@end
