//
//  Offsets.hpp
//  UE4
//
//  Created by yy on 2022/5/9.
//

#ifndef Offsets_hpp
#define Offsets_hpp

#include <stdio.h>
#include <string>
//
using namespace std;

namespace Offsets {
// iOS runtime hints. Member offsets below come from 新数据/SDK_Offset.hpp.
#define kUWorld 0x110C464C8// iOS UWorld pointer hint
#define kGNames 0x111710108// iOS GNames pointer hint
//1.31版本
#define kLineOfSightTo_1 0x109C854ACULL// Function /Script/Engine.Controller.LineOfSightTo
#define kLineOfSightTo_2 0x10DFDF4F9ULL//0x10A2A07D1 40 0F 40 BD 40 0B 00 BD unk

/*
 
 
 X21, [SP,#0x108]
__text:0000000102A06BFC                 LDR             W8, [SP,#0x310+var_200+4]
__text:0000000102A06C00                 STR             W8, [SP,#0x310+var_2C4]
__text:0000000102A06C04                 ADD             X8, SP, #0x310+var_148
__text:0000000102A06C08                 ADD             X9, X8, #0x64 ; 'd'
__text:0000000102A06C0C                 STR             X9, [SP,#0x310+var_2D0]
__text:0000000102A06C10                 ADD             X8, X8, #0x6C ; 'l'
__text:0000000102A06C14                 STR             X8, [SP,#0x310+var_2F8]
__text:0000000102A06C18                 MOV             W28, #0x3F800000
 */
#define kLineOfSightTo_3 0x108046F90ULL//0x105F2911C  E8 03 05 AA 40 04 40 2D 42 08 40 BD  往上//黄字下面 //第三个

#define kLineOfSightTo_4 0x10804AAD4ULL //1F 30 00 F9 1F 40 00 F9 1F 50 00 F9 往下 不太多 黄字下面
//
//__text:000000010804AAD4                 CBZ             X1, locret_10804AB38
//__text:000000010804AAD8                 STP             X22, X21, [SP,#-0x10+var_20]!
//__text:000000010804AADC                 STP             X20, X19, [SP,#0x20+var_10]
//__text:000000010804AAE0                 STP             X29, X30, [SP,#0x20+var_s0]



#define kLineOfSightTo_5 0x108056CE4ULL//E8 03 04 AA 20 04 40 2D 22 08 40 BD 只出


#define kPersistentLevel 0xB8      // Class: World. -> Level* PersistentLevel;
#define kActorList 0xA0
#define kCurrentLevelPendingVisibility 0x148 // Class: World. -> ULevel* CurrentLevelPendingVisibility;
#define kActiveLevelActors 0x0AA8   // Class: World. -> TArray<AActor*> ActiveLevelActors;
#define kGameState 0x0AC8           // Class: World. -> AGameStateBase* GameState;
#define kLevels 0x0AE0              // Class: World. -> TArray<ULevel*> Levels;
#define kCurrentLevel 0x0B08        // Class: World. -> ULevel* CurrentLevel;
#define kActorCluster 0x00E0        // Class: Level. -> ULevelActorContainer* ActorCluster;
#define kLevelActorContainerActors 0x0028 // Class: LevelActorContainer. -> TArray<AActor*> Actors;

#define kNetDriver 0xC0            // Class: World. -> NetDriver* NetDriver;   自身2级指针；
#define kServerConnection 0x88     // Class: NetDriver. -> NetConnection* ServerConnection;    自身3级指针；
#define klocalPlayerController 0x30// Class: UPlayer. -> APlayerController* PlayerController; 自身4级指针；



#define kPlayerCameraManager 0x680 // Class: PlayerController. -> PlayerCameraManager* PlayerCameraManager；    相机指针：

#define kPawn 0x5D8                // Class: Controller. -> Pawn* Pawn;



#define kMyTeam 0x0BA8             // Class: UAEPlayerController. -> int TeamID;
//

#define kViewTarget 0x14A0               // Class: PlayerCameraManager. -> TViewTarget ViewTarget;
//CameraCacheEntry CameraCache;

#define kRootComponent 0x260       // Class: Actor. -> SceneComponent* RootComponent;    坐标指针；
#define kLocation 0x1CC            // Class: SceneComponent. -> FVector RelativeLocation;
//1b4
//Vector VelocitySafety;

#define kRelativeScale3D 0x1E4     //    Class: SceneComponent. -> Vector RelativeScale3D;
//1A4
//0x19c
//0x1cc偏移0x14
//0x1dc
//ector RelativeLocation;//[Offset: 0x194, Size: 0xc]// Address: 0x6f9f3eb300
//Rotator RelativeRotation;//[Offset: 0x1a0, Size: 0xc]// Address: 0x6f9f3eb280
//Vector RelativeScale3D;//[Offset: 0x1ac, Size: 0xc]// Address: 0x6f9f3eb200
#define kHealth 0x1048   // Class: STExtraCharacter. -> float Health;       当前血量；
#define kHealthMax 0x1050// Class: STExtraCharacter. -> float HealthMax;    最大血量；
#define kbDead 0x10C8    // Class: STExtraCharacter. -> bool bDead;






#define kPlayerName 0x0AF8// Class: UAECharacter. -> FString PlayerName;
#define kTeamID 0x0B78    // Class: UAECharacter. -> int TeamID;   队伍编号；
#define kbIsAI 0x0B94     // Class: UAECharacter. -> bool bIsAI;    人机识别；
#define kVelocitySafety 0x114C // Class: STExtraCharacter. -> FVector VelocitySafety;
#define kCurrentUsingWeaponSafety 0x1158 // Class: STExtraCharacter. -> ASTExtraWeapon* CurrentUsingWeaponSafety;
#define kCurrentVehicle 0x12F8 // Class: STExtraCharacter. -> ASTExtraVehicleBase* CurrentVehicle;
#define kWeaponOwnerProxy 0x1330 // Class: STExtraCharacter. -> UWeaponOwnerProxy* WeaponOwnerProxy;
#define kbIsGunADS 0x1818 // Class: STExtraCharacter. -> bool bIsGunADS;
#define kbIsWeaponFiring 0x2710 // Class: STExtraBaseCharacter. -> bool bIsWeaponFiring;
#define kMesh 0x658       // Class: Character. -> SkeletalMeshComponent* Mesh;
#define kCapsuleComponent 0x668 // Class: Character. -> UCapsuleComponent* CapsuleComponent;
//#define kBones "0x6e8"     /* igg */
#define kStaticMesh 0x828 // Class: StaticMeshComponent. -> StaticMesh* StaticMesh;
#define kSkeletalMeshAsset 0x818 // Class: SkinnedMeshComponent. -> USkeletalMesh* SkeletalMesh;
#define kCachedComponentSpaceTransforms 0x0C08 // Class: SkeletalMeshComponent. -> TArray<FTransform> CachedComponentSpaceTransforms;
#define kComponentToWorld 0x01F0 // Class: SceneComponent. -> FTransform ComponentToWorld;
//+10
////#define kNearDeathBreath "0x1718"        // Class: STExtraBaseCharacter. -> float NearDeathBreath;

#define kCurrentWeaponReplicated 0x08D8 // Class: WeaponManagerComponent. -> STExtraWeapon* CurrentWeaponReplicated;
#define kWeaponManagerComponent 0x3690 // Class: STExtraBaseCharacter. -> CharacterWeaponManagerComponent*
#define kWeaponEntityComp 0x0C78 // Class: STExtraWeapon. -> UWeaponEntity* WeaponEntityComp;

#define kShootWeaponEntityComp 0x2000  // Class: STExtraShootWeapon. -> ShootWeaponEntity* ShootWeaponEntityComp;
#define kCachedBulletTrackComponent 0x1FF0 // Class: STExtraShootWeapon. -> UBulletTrackComponent* CachedBulletTrackComponent;
#define kBulletFireSpeed 0x15D4 // Class: ShootWeaponEntity. -> float BulletFireSpeed;
#define kVerticalRecoilTarget 0x01CC // Class: BulletTrackComponent. -> float VerticalRecoilTarget;
#define kWeaponId 0x150                // Class: WeaponEntity. -> int WeaponID;
#define kReplicatedWorldTimeSeconds 0x05FC // Class: GameStateBase. -> float ReplicatedWorldTimeSeconds;

}

#endif /* Offsets_hpp */
