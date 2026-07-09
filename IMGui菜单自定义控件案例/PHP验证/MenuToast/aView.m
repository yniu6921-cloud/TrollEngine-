//.______          ___      ___   ___  __  .__   __. ____    ____
//|   _  \        /   \     \  \ /  / |  | |  \ |  | \   \  /   /
//|  |_)  |      /  ^  \     \  V  /  |  | |   \|  |  \   \/   /
//|      /      /  /_\  \     >   <   |  | |  . `  |   \_    _/
//|  |\  \----./  _____  \   /  .  \  |  | |  |\   |     |  |
//| _| `._____/__/     \__\ /__/ \__\ |__| |__| \__|     |__|

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "aView.h"
#import "UIImageView+WebCache.h"

#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow

#define CurrentViewSize self.view.frame.size

@interface aView ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
{
    
}


@property (nonatomic,strong)UIDocumentInteractionController * documentInteraction;

@end
//NSString *aaa = @"11111111*&*&*2222222^&^&^11111111*&*&*2222222";
@implementation aView


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-90)];
    containerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:containerView];
    
    // 添加Logo图标
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((containerView.frame.size.width - 100) / 2, 70, 100, 100)];
    logoImageView.layer.cornerRadius = 50.0;
    logoImageView.clipsToBounds = YES;
    [containerView addSubview:logoImageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *logoURLString = @"http://q1.qlogo.cn/g?b=qq&nk=2727705657&s=640";
        NSURL *logoURL = [NSURL URLWithString:logoURLString];
        NSData *logoData = [NSData dataWithContentsOfURL:logoURL];
        
        if (logoData) {
            UIImage *logoImage = [UIImage imageWithData:logoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                logoImageView.image = logoImage;
            });
        }
    });
    
    // 添加软件名称Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame) + 20, containerView.frame.size.width - 40, 30)];
    nameLabel.text = @"每日红包";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    [containerView addSubview:nameLabel];
    
    // 添加版本号Label
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(nameLabel.frame) + 10, containerView.frame.size.width - 40, 20)];
    versionLabel.text = @"By:Raxiny\tV:1.2-Beta";
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:16];
    [containerView addSubview:versionLabel];
    
    // 添加介绍Label
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(versionLabel.frame) + 20, containerView.frame.size.width - 40, 100)];
    descriptionLabel.text = @"这里是软件的介绍，描述一些关于软件的描述和特点等内容。";
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont systemFontOfSize:16];
    [containerView addSubview:descriptionLabel];
    
    // 添加按钮
    CGFloat buttonWidth = 200;
    CGFloat buttonHeight = 60;
    CGFloat buttonSpacing = 20;
    
    UIButton *websiteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    websiteButton.frame = CGRectMake((containerView.frame.size.width - buttonWidth) / 2, CGRectGetMaxY(descriptionLabel.frame) + 40, buttonWidth, buttonHeight);
    websiteButton.backgroundColor = [UIColor whiteColor];
    websiteButton.layer.cornerRadius = 10.0;
    websiteButton.layer.masksToBounds = YES;
    [websiteButton setTitle:@"访问官网" forState:UIControlStateNormal];
    [websiteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [websiteButton addTarget:self action:@selector(visitWebsite) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:websiteButton];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeSystem];
    contactButton.frame = CGRectMake((containerView.frame.size.width - buttonWidth) / 2, CGRectGetMaxY(websiteButton.frame) + buttonSpacing, buttonWidth, buttonHeight);
    contactButton.backgroundColor = [UIColor whiteColor];
    contactButton.layer.cornerRadius = 10.0;
    contactButton.layer.masksToBounds = YES;
    [contactButton setTitle:@"联系作者" forState:UIControlStateNormal];
    [contactButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(contactAuthor) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:contactButton];
    
    // 添加版权Label
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, containerView.frame.size.height - 50, containerView.frame.size.width - 40, 20)];
    copyrightLabel.text = @"© 2022 Adyen B.V For Raxiny. All rights reserved.";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:copyrightLabel];
}

- (void)visitWebsite {
    // 打开官网链接的操作
}

- (void)contactAuthor {
    // 联系作者的操作
}


@end
