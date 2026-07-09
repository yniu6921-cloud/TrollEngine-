//
//  MyAAA.m
//  MyAppDemo
//
//  Created by Raxiny on 2022/10/3.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JieSuoMaViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "MyInfoJianghu.h"
#import "JsmEditViewController.h"
#import "ViewController.h"

#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow

@interface JieSuoMaViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *personalTableView;
    NSMutableDictionary *MYka;
    NSMutableDictionary *MYka2;
    UISearchBar *mySearchBar;
}

@end


@implementation JieSuoMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    personalTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    personalTableView.backgroundColor = [UIColor systemGray6Color];
    [self.view addSubview:personalTableView];
    personalTableView.dataSource = self;
    personalTableView.delegate = self;
    personalTableView.bounces = NO;//yes，就是滚动超过边界会反弹有反弹回来的效果; NO，那么滚动到达边界会立刻停止。
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线
    personalTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    personalTableView.estimatedRowHeight = 100;
    
    mySearchBar = [[UISearchBar alloc]
    initWithFrame:CGRectMake(0.0, self.navigationController.navigationBar.frame.size.height+1, self.view.bounds.size.width, 45)];
     mySearchBar.delegate = self;
    mySearchBar.placeholder=@"搜索";
    mySearchBar.translucent=YES;
    [mySearchBar setBackgroundImage:[UIImage new]];
    mySearchBar.layer.cornerRadius = 10;

    personalTableView.tableHeaderView = mySearchBar;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    //设置导航栏左边按钮文字的颜色(以及背景图片的颜色)
    leftItem.tintColor = [UIColor labelColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(btnDidClicked)]
                                                ];

}

- (void)btnDidClicked{
    NSArray *sl = [self->MYka[@"数据"] componentsSeparatedByString:@"---"];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"tips" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"全部(%@)",sl[3]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self->MYka = self->MYka2;
        [self->personalTableView reloadData];
        
     }];

    UIAlertAction *bAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"未激活(%@)",sl[0]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->MYka = self->MYka2;
        NSString *lala = nil;
        for(int a = 0; a<[self->MYka[@"gongneng"] count];a++){
            
            if(a == 0){
                lala = @"{\"gongneng\":[";
            }
            
            if ([self->MYka[@"gongneng"][a][@"激活状态"] localizedCaseInsensitiveContainsString:@"未激活"]) {
                    lala = [NSString stringWithFormat:@"%@{\"卡号\":\"%@\",\"udid\":\"%@\",\"到期时间\":\"%@\",\"到期时间戳\":\"%@\",\"激活状态\":\"%@\",\"换绑\":\"%@\",\"生成时间\":\"%@\",\"使用时间\":\"%@\",\"卡密类型\":\"%@\"},",lala,self->MYka[@"gongneng"][a][@"卡号"],self->MYka[@"gongneng"][a][@"udid"],self->MYka[@"gongneng"][a][@"到期时间"],self->MYka[@"gongneng"][a][@"到期时间戳"],self->MYka[@"gongneng"][a][@"激活状态"],self->MYka[@"gongneng"][a][@"换绑"],self->MYka[@"gongneng"][a][@"生成时间"],self->MYka[@"gongneng"][a][@"使用时间"],self->MYka[@"gongneng"][a][@"卡密类型"]];
                    //NSLog(@"%@",lala);

            }
            
            if(a == [self->MYka[@"gongneng"] count]-1){
            lala = [NSString stringWithFormat:@"%@],\"数据\":\"%@\"}",lala,self->MYka[@"数据"]];
                //NSLog(@"%@",lala);
                self->MYka = [NSJSONSerialization JSONObjectWithData:[lala dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [self->personalTableView reloadData];
            }
        }

    }];
    
    UIAlertAction *cAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"未到期(%@)",sl[1]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->MYka = self->MYka2;
        NSString *lala = nil;
        for(int a = 0; a<[self->MYka[@"gongneng"] count];a++){
            
            if(a == 0){
                lala = @"{\"gongneng\":[";
            }
            
            if (![self->MYka[@"gongneng"][a][@"到期时间"] localizedCaseInsensitiveContainsString:@"已到期"]) {
                    lala = [NSString stringWithFormat:@"%@{\"卡号\":\"%@\",\"udid\":\"%@\",\"到期时间\":\"%@\",\"到期时间戳\":\"%@\",\"激活状态\":\"%@\",\"换绑\":\"%@\",\"生成时间\":\"%@\",\"使用时间\":\"%@\",\"卡密类型\":\"%@\"},",lala,self->MYka[@"gongneng"][a][@"卡号"],self->MYka[@"gongneng"][a][@"udid"],self->MYka[@"gongneng"][a][@"到期时间"],self->MYka[@"gongneng"][a][@"到期时间戳"],self->MYka[@"gongneng"][a][@"激活状态"],self->MYka[@"gongneng"][a][@"换绑"],self->MYka[@"gongneng"][a][@"生成时间"],self->MYka[@"gongneng"][a][@"使用时间"],self->MYka[@"gongneng"][a][@"卡密类型"]];
                    //NSLog(@"%@",lala);

            }
            
            if(a == [self->MYka[@"gongneng"] count]-1){
            lala = [NSString stringWithFormat:@"%@],\"数据\":\"%@\"}",lala,self->MYka[@"数据"]];
                //NSLog(@"%@",lala);
                self->MYka = [NSJSONSerialization JSONObjectWithData:[lala dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [self->personalTableView reloadData];
            }
        }

    }];

    UIAlertAction *dAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"已到期(%@)",sl[2]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->MYka = self->MYka2;
        NSString *lala = nil;
        for(int a = 0; a<[self->MYka[@"gongneng"] count];a++){
            
            if(a == 0){
                lala = @"{\"gongneng\":[";
            }
            
            if ([self->MYka[@"gongneng"][a][@"到期时间"] localizedCaseInsensitiveContainsString:@"已到期"]) {
                    lala = [NSString stringWithFormat:@"%@{\"卡号\":\"%@\",\"udid\":\"%@\",\"到期时间\":\"%@\",\"到期时间戳\":\"%@\",\"激活状态\":\"%@\",\"换绑\":\"%@\",\"生成时间\":\"%@\",\"使用时间\":\"%@\",\"卡密类型\":\"%@\"},",lala,self->MYka[@"gongneng"][a][@"卡号"],self->MYka[@"gongneng"][a][@"udid"],self->MYka[@"gongneng"][a][@"到期时间"],self->MYka[@"gongneng"][a][@"到期时间戳"],self->MYka[@"gongneng"][a][@"激活状态"],self->MYka[@"gongneng"][a][@"换绑"],self->MYka[@"gongneng"][a][@"生成时间"],self->MYka[@"gongneng"][a][@"使用时间"],self->MYka[@"gongneng"][a][@"卡密类型"]];
                    //NSLog(@"%@",lala);

            }
            
            if(a == [self->MYka[@"gongneng"] count]-1){
            lala = [NSString stringWithFormat:@"%@],\"数据\":\"%@\"}",lala,self->MYka[@"数据"]];
                //NSLog(@"%@",lala);
                self->MYka = [NSJSONSerialization JSONObjectWithData:[lala dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [self->personalTableView reloadData];
            }
        }
        
    }];
    
    UIAlertAction *eAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:aAction];
    [alertVC addAction:bAction];
    [alertVC addAction:cAction];
    [alertVC addAction:dAction];
    [alertVC addAction:eAction];

    [self presentViewController:alertVC animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self shuaxin];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                    [btn setEnabled:YES];
                    [btn setUserInteractionEnabled:YES];
                }
            }
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    mySearchBar.text = @"";
    MYka = MYka2;
    [self->personalTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    if(searchBar.text.length == 0){
        MYka = MYka2;
        [self->personalTableView reloadData];
    }else{
        NSString *lala = nil;
        for(int a = 0; a<[self->MYka[@"gongneng"] count];a++){
            
            if(a == 0){
                lala = @"{\"gongneng\":[";
            }
            
            if ([self->MYka[@"gongneng"][a][@"卡号"] localizedCaseInsensitiveContainsString:searchBar.text] || [self->MYka[@"gongneng"][a][@"udid"] localizedCaseInsensitiveContainsString:searchBar.text]) {
                    lala = [NSString stringWithFormat:@"%@{\"卡号\":\"%@\",\"udid\":\"%@\",\"到期时间\":\"%@\",\"到期时间戳\":\"%@\",\"激活状态\":\"%@\",\"换绑\":\"%@\",\"生成时间\":\"%@\",\"使用时间\":\"%@\",\"卡密类型\":\"%@\"},",lala,self->MYka[@"gongneng"][a][@"卡号"],self->MYka[@"gongneng"][a][@"udid"],self->MYka[@"gongneng"][a][@"到期时间"],self->MYka[@"gongneng"][a][@"到期时间戳"],self->MYka[@"gongneng"][a][@"激活状态"],self->MYka[@"gongneng"][a][@"换绑"],self->MYka[@"gongneng"][a][@"生成时间"],self->MYka[@"gongneng"][a][@"使用时间"],self->MYka[@"gongneng"][a][@"卡密类型"]];
                    //NSLog(@"%@",lala);

            }
            
            if(a == [self->MYka[@"gongneng"] count]-1){
            lala = [NSString stringWithFormat:@"%@],\"数据\":\"%@\"}",lala,self->MYka[@"数据"]];
                //NSLog(@"%@",lala);
                MYka = [NSJSONSerialization JSONObjectWithData:[lala dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                [self->personalTableView reloadData];
            }
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchBar.text.length == 0){
    MYka = MYka2;
    [self->personalTableView reloadData];
    }
}

//回车收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    
}

- (void)goBackAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TbaleView的数据源代理方法实现
    //返回组数的代理方法
    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return [self->MYka[@"gongneng"] count];
    }
    //返回行数的代理方法
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 3;
    }
    //每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
    }
    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
        NSString *headerLabel;

        return headerLabel;
    }
    
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    if (section == [self->MYka[@"gongneng"] count]-1){
        NSString *copyright = @" ";
        return copyright;
    }
    
    
    return nil;
}
    
    //每个分组下边预留的空白高度
    -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        
        return 50;
    }
 

    //返回每一行Cell的代理方法
    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        // 1 初始化Cell
        // 1.1 设置Cell的重用标识
        static NSString *ID = @"cell";
        // 1.2 去缓存池中取Cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 1.3 若取不到便创建一个带重用标识的Cell
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            //UITableViewCellStyleSubtitle // 带小标题
            //UITableViewCellStyleDefault
        }else//当页面拉动的时候 当cell存在并且最后一个存在 把它进行删除就出来一个独特的cell我们在进行数据配置即可避免
        {
            while ([cell.contentView.subviews lastObject] != nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel sizeToFit];
        cell.detailTextLabel.numberOfLines = 0;
        [cell.detailTextLabel sizeToFit];
        cell.textLabel.textColor = [UIColor labelColor];
   
        if(indexPath.row == 0){
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            cell.textLabel.textColor = [UIColor blueColor];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor grayColor];
            
            cell.textLabel.text = [NSString stringWithFormat:@"卡号：%@",self->MYka[@"gongneng"][indexPath.section][@"卡号"]];
              //self->MYka[@"gongneng"][indexPath.section][@"卡号"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"UDID：%@",self->MYka[@"gongneng"][indexPath.section][@"udid"]];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 80, 30)];
            btn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
            if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 1){
            [btn setTitle:@"小 时 卡" forState:UIControlStateNormal];
            }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 2){
                [btn setTitle:@"天 卡" forState:UIControlStateNormal];
                }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 3){
                    [btn setTitle:@"周 卡" forState:UIControlStateNormal];
                    }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 4){
                        [btn setTitle:@"月 卡" forState:UIControlStateNormal];
                        }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 5){
                            [btn setTitle:@"季 卡" forState:UIControlStateNormal];
                            }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 6){
                                [btn setTitle:@"年 卡" forState:UIControlStateNormal];
                                }else if([self->MYka[@"gongneng"][indexPath.section][@"卡密类型"] intValue] == 7){
                                    [btn setTitle:@"永 久 卡" forState:UIControlStateNormal];
                                    }
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];//p1颜色
            [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];//字体大小
            //[cell.contentView addSubview:btn];
            cell.accessoryView = btn;
        }
        
        if(indexPath.row == 1){
          NSString *str = [NSString stringWithFormat:@"状态：%@\t\t生成时间：%@\n\n换绑：%@\t\t使用时间：%@",self->MYka[@"gongneng"][indexPath.section][@"激活状态"],self->MYka[@"gongneng"][indexPath.section][@"生成时间"],[self->MYka[@"gongneng"][indexPath.section][@"换绑"] intValue] == 0 ? @"未换绑":@"已换绑",self->MYka[@"gongneng"][indexPath.section][@"使用时间"]];
            
            NSString * a = [NSString stringWithFormat:@"状态：%@\t\t",self->MYka[@"gongneng"][indexPath.section][@"激活状态"]];
            NSString * b = [NSString stringWithFormat:@"状态：%@\t\t生成时间：%@\n\n",self->MYka[@"gongneng"][indexPath.section][@"激活状态"],self->MYka[@"gongneng"][indexPath.section][@"生成时间"]];
            
            NSString * c = [NSString stringWithFormat:@"状态：%@\t\t生成时间：%@\n\n换绑：%@\t\t",self->MYka[@"gongneng"][indexPath.section][@"激活状态"],self->MYka[@"gongneng"][indexPath.section][@"生成时间"],[self->MYka[@"gongneng"][indexPath.section][@"换绑"] intValue] == 0 ? @"未换绑":@"已换绑"];
            
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];

            [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                           value:[UIColor grayColor]
                                          range:NSMakeRange(0, 3)];
            [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                           value:[UIColor grayColor]
                                          range:NSMakeRange(a.length, 5)];
            [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                           value:[UIColor grayColor]
                                          range:NSMakeRange(b.length, 3)];
            [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                           value:[UIColor grayColor]
                                          range:NSMakeRange(c.length, 5)];
            
            

            cell.textLabel.attributedText = attrStr;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
        
        if(indexPath.row == 2){

            NSString *str = [NSString stringWithFormat:@"到期时间：%@",self->MYka[@"gongneng"][indexPath.section][@"到期时间"]];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];

            [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                           value:[UIColor redColor]
                                          range:NSMakeRange(5, str.length-5)];

            cell.textLabel.attributedText = attrStr;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 60, 30)];
            btn.layer.cornerRadius = 5.0;//2.0是圆角的弧度，根据需求自己更改
            [btn setTitle:@"管 理" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
            btn.backgroundColor = [UIColor blueColor];//框里面白色
            btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
            btn.layer.borderWidth = 1.95f;//边框大小
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
            [btn addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
            //[cell.contentView addSubview:btn];
            cell.accessoryView = btn;
            
        }
        
        //设置Cell右边的小箭头
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

- (void)shuaxin{
UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
_activityIndicator.frame = CGRectMake(25, 10, 50, 40);
_activityIndicator.backgroundColor = [UIColor clearColor];
_activityIndicator.hidesWhenStopped = NO;
_activityIndicator.center = self.view.center;
[self.view addSubview:_activityIndicator];
[_activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *txturl2 = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@jiesuomahuoqu.php?appid=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],[MyInfoJianghu MyUserInfo].appid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
        
        self->MYka = [NSJSONSerialization JSONObjectWithData:[txturl2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        self->MYka2 = self->MYka;
    if(txturl2){
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicator removeFromSuperview];
    [self->personalTableView reloadData];
    //    [self->MyTc dismissViewControllerAnimated:YES completion:nil];
    });
    }
});
}
- (void)change{
    
}

- (void)cellBtnClicked:(id)sender event:(id)event {
    
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [generator impactOccurred];
    
    NSSet *touches =[event allTouches];
    
    UITouch *touch =[touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:personalTableView];
    
    NSIndexPath *indexPath= [personalTableView indexPathForRowAtPoint:currentTouchPosition];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"tips" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"%@",self->MYka[@"gongneng"][indexPath.section]);
        [MyInfoJianghu MyUserInfo].解锁码信息 = self->MYka[@"gongneng"][indexPath.section];
        
        JsmEditViewController *rvc = [[JsmEditViewController alloc] init];
        [self.navigationController pushViewController:rvc animated:YES];
        self.hidesBottomBarWhenPushed = YES;

     }];

    UIAlertAction *bAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = NO;
        _activityIndicator.center = self.view.center;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@kamiguanli.php?id=2&kami=%@&appid=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],self->MYka[@"gongneng"][indexPath.section][@"卡号"],[MyInfoJianghu MyUserInfo].appid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
            if(txturl){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activityIndicator removeFromSuperview];
           NSMutableDictionary *dd = [NSJSONSerialization JSONObjectWithData:[txturl dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        UIAlertController *cg = [UIAlertController alertControllerWithTitle:@"信息" message:dd[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        [cg addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shuaxin];
        }]];
        [self presentViewController:cg animated:true completion:nil];
            });
            }
        });
    }];
    
    UIAlertAction *cAction = [UIAlertAction actionWithTitle:@"拉黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = NO;
        _activityIndicator.center = self.view.center;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@kamiguanli.php?id=3&kami=%@&udid=%@&appid=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],self->MYka[@"gongneng"][indexPath.section][@"卡号"],self->MYka[@"gongneng"][indexPath.section][@"udid"],[MyInfoJianghu MyUserInfo].appid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
            if(txturl){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activityIndicator removeFromSuperview];
           NSMutableDictionary *dd = [NSJSONSerialization JSONObjectWithData:[txturl dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        UIAlertController *cg = [UIAlertController alertControllerWithTitle:@"信息" message:dd[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        [cg addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shuaxin];
        }]];
        [self presentViewController:cg animated:true completion:nil];
            });
            }
        });
    }];
    
    UIAlertAction *dAction = [UIAlertAction actionWithTitle:@"拉黑udid并删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = NO;
        _activityIndicator.center = self.view.center;
        [self.view addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@kamiguanli.php?id=4&kami=%@&udid=%@&appid=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],self->MYka[@"gongneng"][indexPath.section][@"卡号"],self->MYka[@"gongneng"][indexPath.section][@"udid"],[MyInfoJianghu MyUserInfo].appid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
            if(txturl){
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activityIndicator removeFromSuperview];
           NSMutableDictionary *dd = [NSJSONSerialization JSONObjectWithData:[txturl dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

        UIAlertController *cg = [UIAlertController alertControllerWithTitle:@"信息" message:dd[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
        [cg addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self shuaxin];
        }]];
        [self presentViewController:cg animated:true completion:nil];
            });
            }
        });
    }];

    UIAlertAction *eAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:aAction];
    [alertVC addAction:bAction];
    [alertVC addAction:eAction];
    if([self->MYka[@"gongneng"][indexPath.section][@"激活状态"] containsString:@"已激活"]){
    [alertVC addAction:cAction];
    [alertVC addAction:dAction];
    }

    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [personalTableView deselectRowAtIndexPath:[personalTableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 圆角弧度半径
    CGFloat cornerRadius = 10.0f;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    // 显示选中
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init];
    //   创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    //   获取cell的size
    //    第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 10, 0);
    
    //      CGRectGetMinY：返回对象顶点坐标
    //      CGRectGetMaxY：返回对象底点坐标
    //      CGRectGetMinX：返回对象左边缘坐标
    //      CGRectGetMaxX：返回对象右边缘坐标
    //      CGRectGetMidX: 返回对象中心点的X坐标
    //      CGRectGetMidY: 返回对象中心点的Y坐标
    //      这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
    BOOL addLine = NO;
    if (rows == 1) {
        // 初始起点为cell的左侧中间坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMidY(bounds));
    } else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        addLine = YES;
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
        addLine = YES;
    }
    
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    
    // 按照shape layer的path填充颜色，类似于渲染render
    if ([UIDevice currentDevice].systemVersion.floatValue >= 13.0) {
    layer.fillColor = [UIColor tertiarySystemBackgroundColor].CGColor;
    }else{
    layer.fillColor = [UIColor whiteColor].CGColor;
    }
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    
    // cell的背景view
    cell.backgroundView = roundView;
    
    // 添加分割线
    
    if (addLine == YES) {
        if(indexPath.row == 1){
        CALayer *lineLayer = [[CALayer alloc] init];
        
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        
        lineLayer.frame = CGRectMake(10, bounds.size.height-lineHeight, bounds.size.width, lineHeight+1);
        
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        
        [layer addSublayer:lineLayer];
        }
    }
    
    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = tableView.separatorColor.CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getUTF8EncodeStringWithURLString:(NSString *)urlString
{
    if (urlString && urlString.length > 0)
    {
        NSString *encodedString = (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)urlString,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
        return encodedString;
    }
    else
    {
        return @"";
    }
}



@end
