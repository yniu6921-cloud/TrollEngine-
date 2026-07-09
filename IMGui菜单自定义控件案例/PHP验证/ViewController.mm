//
//  ViewController.m
//  PHP验证
//
//  Created by Raxiny on 2023/2/2.
//

//.______          ___      ___   ___  __  .__   __. ____    ____
//|   _  \        /   \     \  \ /  / |  | |  \ |  | \   \  /   /
//|  |_)  |      /  ^  \     \  V  /  |  | |   \|  |  \   \/   /
//|      /      /  /_\  \     >   <   |  | |  . `  |   \_    _/
//|  |\  \----./  _____  \   /  .  \  |  | |  |\   |     |  |
//| _| `._____/__/     \__\ /__/ \__\ |__| |__| \__|     |__|

#import "ViewController.h"
#import "APPViewController.h"
#import "AppViewController_1.h"
#import "AppViewController_2.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIButton+actionBlock.h"
#import "UISwitch+Block.h"
#import <WebKit/WebKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "JsmEditViewController.h"
#import "JieSuoMaViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define CurrentViewSize self.view.frame.size

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *personalTableView;
    NSArray *dataSource;
    NSMutableDictionary *responseInfo;
    UIAlertController *MyTc;
    UIView *ToastUI;
    UIScrollView *HDView[5];
    BOOL t;
}


@property (nonatomic,strong)UIDocumentInteractionController * documentInteraction;

@end
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
}

- (void)buttonTapped:(UITapGestureRecognizer *)gesture {
    UIView *tappedView = gesture.view;
    NSInteger buttonIndex = [self.view.subviews indexOfObject:tappedView] - 2; // 减去公告区域和按钮之间的视图数量
    NSLog(@"Button %ld tapped", (long)buttonIndex + 1);
    UIViewController *viewController;
    switch ((long)buttonIndex + 1) {
        case 0:
            viewController = [[AppViewController alloc] init];
            break;
        case 1:
            viewController = [[AppViewController1 alloc] init];
            break;
        case 2:
            viewController = [[AppViewController2 alloc] init];
            break;
        case 3: {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"测试版本 静待更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        }
        default:
            return;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}



-(void)viewWillAppear:(BOOL)animated{
   
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"验证"] == YES){
//            UIAlertController *KaMi = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码\n👇官网地址👇\nhttps://www.ioskky.com\n密码可前往官网软件源获取" preferredStyle:UIAlertControllerStyleAlert];
//
//            [KaMi addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField * jh1 = [[UITextField alloc]init];
//
//                NSArray * textFieldArr = @[jh1];
//
//                textFieldArr = KaMi.textFields;
//
//                UITextField *tf1 = KaMi.textFields[0];
//                if ([tf1.text isEqualToString:@"0108"]) {
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"验证"];
//                } else {
//                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"验证"];
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码错误" message:nil preferredStyle:UIAlertControllerStyleAlert];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        exit(-1);
//                    });
//                }
//
//
//            }]];
//
//
//
//            [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = @"在此输入密码";
//            }];
//
//
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:KaMi animated:YES completion:nil];
//        }
//    });
}

#pragma mark - TbaleView的数据源代理方法实现
// 返回组数的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

// 返回行数的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

// 每个分组上边预留的空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

// 每个分组下边预留的空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

// 设置分组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

// 设置分组底部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

// 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

// 返回每一行Cell的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1 初始化Cell
    // 1.1 设置Cell的重用标识
    static NSString *ID = @"cell";
    // 1.2 去缓存池中取Cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 1.3 若取不到便创建一个带重用标识的Cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        // 清除之前的内容
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 2 根据indexPath配置Cell的内容
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor labelColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13.5 weight:UIFontWeightBold];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"美团🧧每日外卖红包";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"饿了么🧧每日外卖红包";
    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"出行🧧每日打车红包";
    } else if (indexPath.section == 3) {
        cell.textLabel.text = @"其他🧧每日红包";
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController;
    
    switch (indexPath.section) {
        case 0:
            viewController = [[AppViewController alloc] init];
            break;
        case 1:
            viewController = [[AppViewController1 alloc] init];
            break;
        case 2:
            viewController = [[AppViewController2 alloc] init];
            break;
        case 3: {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"测试版本 静待更新" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
            return;
        }
        default:
            return;
    }
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}



- (UIDocumentInteractionController *)documentInteraction{
    if (!_documentInteraction) {
        _documentInteraction = [[UIDocumentInteractionController alloc] init];
        _documentInteraction.delegate = self;
    }
    return _documentInteraction;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application{
    [self.documentInteraction dismissMenuAnimated:YES];
}
@end
