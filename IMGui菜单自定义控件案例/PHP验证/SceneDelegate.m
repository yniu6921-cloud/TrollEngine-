//
//  SceneDelegate.m
//  PHP验证
//
//  Created by Raxiny on 2023/2/2.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "DaiLiDuanViewController.h"
#import "aView.h"


@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    self.window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
       self.window.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.window.backgroundColor =[UIColor whiteColor];
       [self.window makeKeyAndVisible];
       
    ViewController* vcFirst=[[ViewController alloc]init];
       vcFirst.view.backgroundColor=[UIColor clearColor];
       
       
    DaiLiDuanViewController* vcSecond=[[DaiLiDuanViewController alloc]init];
    vcSecond.view.backgroundColor=[UIColor clearColor];
    
    aView* aaa=[[aView alloc]init];
    vcSecond.view.backgroundColor=[UIColor clearColor];


       
   //    创建试图控制器
       UITabBarController* tbController=[[UITabBarController alloc]init];
   //    创建视图控制器数组
   //    将所有分栏控制器加到数组中
       NSArray* arrayVC=[NSArray arrayWithObjects:vcFirst,vcSecond,aaa,nil];
   //    将分栏控制器管理数组赋值
       tbController.viewControllers=arrayVC;
   //    将分栏控制器为根视图控制器
       self.window.rootViewController=tbController;
   //    设置选中视图控制器的索引
       tbController.selectedIndex=0;
       
   //    设置透明度
       tbController.tabBar.translucent=NO;
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
