#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DaiLiViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JieSuoMaViewController.h"
#import "MyInfoJianghu.h"
#import "BlackViewController.h"
#import "EditViewController.h"
#import "DaiLiJSMMaViewController.h"
#import "DaiLiEditViewController.h"
#import "ViewController.h"

#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow

@interface DaiLiViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *personalTableView;
    NSMutableDictionary *MYka;
}

@end


@implementation DaiLiViewController

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
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    leftItem.tintColor = [UIColor labelColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"添加代理" style:UIBarButtonItemStylePlain target:self action:@selector(btnDidClicked)]
                                                ];

}

- (void)btnDidClicked{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择权限" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"小时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self zk:@"1"];
   
     }];

    UIAlertAction *bAction = [UIAlertAction actionWithTitle:@"天卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"2"];
      
    }];
    
    UIAlertAction *cAction = [UIAlertAction actionWithTitle:@"周卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"3"];
      
    }];
    
    UIAlertAction *dAction = [UIAlertAction actionWithTitle:@"月卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"4"];
      
    }];
    
    UIAlertAction *eAction = [UIAlertAction actionWithTitle:@"季卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"5"];
      
    }];
    
    UIAlertAction *fAction = [UIAlertAction actionWithTitle:@"年卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"6"];
      
    }];
    
    UIAlertAction *gAction = [UIAlertAction actionWithTitle:@"无限制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self zk:@"7"];
      
    }];
    

    UIAlertAction *hAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:aAction];
    [alertVC addAction:bAction];
    [alertVC addAction:cAction];
    [alertVC addAction:dAction];
    [alertVC addAction:eAction];
    [alertVC addAction:fAction];
    [alertVC addAction:gAction];
    [alertVC addAction:hAction];

    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)zk:(NSString *)aaa{
    
    UIAlertController *KaMi = [UIAlertController alertControllerWithTitle:@"信息" message:@"请按说明填写" preferredStyle:UIAlertControllerStyleAlert];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     UITextField * jh1 = [[UITextField alloc]init];
                     UITextField * jh2 = [[UITextField alloc]init];
                     UITextField * jh3 = [[UITextField alloc]init];
                     UITextField * jh4 = [[UITextField alloc]init];
                     
                     NSArray * textFieldArr = @[jh1,jh2,jh3,jh4];
                     
                     textFieldArr = KaMi.textFields;
                     
                     UITextField * tf1 = KaMi.textFields[0];
                     UITextField * tf2 = KaMi.textFields[1];
                     UITextField * tf3 = KaMi.textFields[2];
                     UITextField * tf4 = KaMi.textFields[3];
                     if(tf1.text.length != 0 && tf2.text.length != 0 && tf3.text.length != 0 && tf4.text.length != 0){
                         
                         UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
                         _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
                         _activityIndicator.backgroundColor = [UIColor clearColor];
                         _activityIndicator.hidesWhenStopped = NO;
                         _activityIndicator.center = self.view.center;
                         [self.view addSubview:_activityIndicator];
                         [_activityIndicator startAnimating];
                         NSString *a1 = tf1.text;
                         NSString *a2 = tf2.text;
                         NSString *a3 = tf3.text;
                         NSString *a4 = tf4.text;
                         dispatch_async(dispatch_get_global_queue(0, 0), ^{
                         NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?id=7&appid=%@&daiid=%@&mm=%@&sl=%@&sm=%@&qx=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],[MyInfoJianghu MyUserInfo].appid,a1,a2,a3,a4,aaa,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
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
                     }
                 }]];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 }]];
                 
                 [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                     
                     textField.placeholder = @"在此输入代理ID";
                     
                 }];
    
    [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"在此输入密码";
        
    }];
                 
                 [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                     
                     textField.placeholder = @"在此输入可制作卡密数量";
                     
                 }];
    
    [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"在此输入说明";
        
    }];
                 
                 
                [self presentViewController:KaMi animated:true completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self shuaxin];
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
        NSString *txturl2 = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?id=1&appid=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],[MyInfoJianghu MyUserInfo].appid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];

        self->MYka = [NSJSONSerialization JSONObjectWithData:[txturl2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if(txturl2){
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicator removeFromSuperview];
    [self->personalTableView reloadData];
    });
    }
});
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
        //if(section == 0)
          // return 30;
    
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
        cell.detailTextLabel.textColor = [UIColor labelColor];
        
        if(indexPath.row == 0){
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
        cell.textLabel.text = [NSString stringWithFormat:@"代理ID:%@",self->MYka[@"gongneng"][indexPath.section][@"代理ID"]];

        cell.detailTextLabel.text = [NSString stringWithFormat:@"APPID:%@",self->MYka[@"gongneng"][indexPath.section][@"APPID"]];
        }
        
        if(indexPath.row == 1){
            NSString *str = [NSString stringWithFormat:@"可制作数量：%@\t\t制作权限：%@\n\n说明：%@",self->MYka[@"gongneng"][indexPath.section][@"可制作数量"],self->MYka[@"gongneng"][indexPath.section][@"制作权限"],self->MYka[@"gongneng"][indexPath.section][@"说明"]];
              
              NSString * a = [NSString stringWithFormat:@"可制作数量：%@\t\t",self->MYka[@"gongneng"][indexPath.section][@"可制作数量"]];
              NSString * b = [NSString stringWithFormat:@"可制作数量：%@\t\t制作权限：%@\n\n",self->MYka[@"gongneng"][indexPath.section][@"可制作数量"],self->MYka[@"gongneng"][indexPath.section][@"制作权限"]];
              
              NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];

              [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                             value:[UIColor grayColor]
                                            range:NSMakeRange(0, 6)];
              [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                             value:[UIColor grayColor]
                                            range:NSMakeRange(a.length, 5)];
              [attrStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                             value:[UIColor grayColor]
                                            range:NSMakeRange(b.length, 3)];
              
              

              cell.textLabel.attributedText = attrStr;
              cell.textLabel.font = [UIFont systemFontOfSize:13];

        }
        
        if(indexPath.row == 2){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            NSArray *array = [NSArray arrayWithObjects:@"编辑",@"删除此代理",@"查寻已制卡密", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            segment.frame = CGRectMake(20,5,self.view.frame.size.width-40,30);
            //segment.selectedSegmentIndex = 0;
            segment.momentary = YES;
            segment.apportionsSegmentWidthsByContent = YES;
            [segment addTarget:self action:@selector(guanli:) forControlEvents:UIControlEventValueChanged];
            //cell.accessoryView = segment;
            [cell.contentView addSubview:segment];
        }
        return cell;
    }

- (void)guanli:(UISegmentedControl *)sender{
    
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [personalTableView indexPathForCell:cell];
    if(sender.selectedSegmentIndex == 0) {
        [MyInfoJianghu MyUserInfo].daiid = self->MYka[@"gongneng"][indexPath.section][@"代理ID"];
        DaiLiEditViewController *settingVc = [[DaiLiEditViewController alloc] init] ;
       [self.navigationController pushViewController:settingVc animated:YES];
       self.hidesBottomBarWhenPushed = YES;
       
   }
    if (sender.selectedSegmentIndex == 1) {
       
       UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
       
       UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"删除代理与所属卡密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

           UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
           _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
           _activityIndicator.backgroundColor = [UIColor clearColor];
           _activityIndicator.hidesWhenStopped = NO;
           _activityIndicator.center = self.view.center;
           [self.view addSubview:_activityIndicator];
           [_activityIndicator startAnimating];
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?daiid=%@&id=5&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],self->MYka[@"gongneng"][indexPath.section][@"代理ID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
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

       UIAlertAction *bAction = [UIAlertAction actionWithTitle:@"只删除代理保留卡密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
           UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
           _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
           _activityIndicator.backgroundColor = [UIColor clearColor];
           _activityIndicator.hidesWhenStopped = NO;
           _activityIndicator.center = self.view.center;
           [self.view addSubview:_activityIndicator];
           [_activityIndicator startAnimating];
           dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?daiid=%@&id=6&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],self->MYka[@"gongneng"][indexPath.section][@"代理ID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
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

       UIAlertAction *cAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
       }];
       
       [alertVC addAction:aAction];
       [alertVC addAction:bAction];
       [alertVC addAction:cAction];

       [self presentViewController:alertVC animated:YES completion:nil];
      
       
   }
     if(sender.selectedSegmentIndex == 2) {
        [MyInfoJianghu MyUserInfo].appid = self->MYka[@"gongneng"][indexPath.section][@"APPID"];
         [MyInfoJianghu MyUserInfo].daiid = self->MYka[@"gongneng"][indexPath.section][@"代理ID"];
        DaiLiJSMMaViewController *settingVc = [[DaiLiJSMMaViewController alloc] init] ;
        [self.navigationController pushViewController:settingVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        
    }
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
    layer.fillColor = [UIColor tertiarySystemBackgroundColor].CGColor;
    
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
