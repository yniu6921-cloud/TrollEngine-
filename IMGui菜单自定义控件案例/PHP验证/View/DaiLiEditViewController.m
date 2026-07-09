//
//  MyAAA.m
//  MyAppDemo
//
//  Created by Raxiny on 2022/10/3.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DaiLiEditViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MyInfoJianghu.h"
#import "ViewController.h"

#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow

@interface DaiLiEditViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    UITableView *personalTableView;
    NSMutableDictionary *MYka;
    NSString *appid;
    NSString *zzqx;
    NSString *zzsl;
    NSString *sm;
    NSString *mm;
}

@end


@implementation DaiLiEditViewController

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

    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    //设置导航栏左边按钮文字的颜色(以及背景图片的颜色)
    leftItem.tintColor = [UIColor labelColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationItem.rightBarButtonItems = @[
                                                [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(btnDidClicked)]
                                                ];
}

- (void)goBackAction:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnDidClicked{
    UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
    _activityIndicator.backgroundColor = [UIColor clearColor];
    _activityIndicator.hidesWhenStopped = NO;
    _activityIndicator.center = self.view.center;
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *txturl = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?id=4&daiid=%@&zzqx=%@&zzsl=%@&sm=%@&mm=%@&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],[MyInfoJianghu MyUserInfo].daiid,self->zzqx,self->zzsl,self->sm,self->mm,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
        if(txturl){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator removeFromSuperview];
       NSMutableDictionary *dd = [NSJSONSerialization JSONObjectWithData:[txturl dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

    UIAlertController *cg = [UIAlertController alertControllerWithTitle:@"信息" message:dd[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
    [cg addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:cg animated:true completion:nil];
        });
        }
    });
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
        NSString *txturl2 = [NSString stringWithContentsOfURL:[NSURL URLWithString:[self getUTF8EncodeStringWithURLString:[NSString stringWithFormat:@"%@daili.php?daiid=%@&id=3&userid=%@&pass=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"后台地址"],[MyInfoJianghu MyUserInfo].daiid,[[NSUserDefaults standardUserDefaults] objectForKey:@"admin账号"],[[NSUserDefaults standardUserDefaults] objectForKey:@"admin密码"]]]] encoding:NSUTF8StringEncoding error:nil];
        self->MYka = [NSJSONSerialization JSONObjectWithData:[txturl2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    if(txturl2){
    dispatch_async(dispatch_get_main_queue(), ^{
        [_activityIndicator removeFromSuperview];
        self->zzqx = self->MYka[@"制作权限"];
        self->zzsl = self->MYka[@"制作数量"];
        self->mm = self->MYka[@"密码"];
        self->sm= [self->MYka[@"说明"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    [self->personalTableView reloadData];
    });
    }
});
}

#pragma mark - TbaleView的数据源代理方法实现
    //返回组数的代理方法
    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 4;
    }
    //返回行数的代理方法
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 1;
    }
    //每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        if(section == 0)
           return 30;
    
    return 15;
    }
    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
        NSString *headerLabel;
        if(section == 0)
            headerLabel = @"\n\n权限";
        
        if(section == 1)
            headerLabel = @"数量";
        
        if(section == 2)
            headerLabel = @"说明";
        
        if(section == 3)
            headerLabel = @"密码";

        return headerLabel;
    }
    
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    if (section == 3){
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
        
        if(indexPath.section == 0){
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text = @"制作权限";
            if([self->MYka[@"制作权限"] intValue] == 1){
                cell.detailTextLabel.text = @"小时卡";
            }else if([self->MYka[@"制作权限"] intValue] == 2){
                cell.detailTextLabel.text = @"天卡及以下";
            }else if([self->MYka[@"制作权限"] intValue] == 3){
                cell.detailTextLabel.text = @"周卡及以下";
            }else if([self->MYka[@"制作权限"] intValue] == 4){
                cell.detailTextLabel.text = @"月卡及以下";
            }else if([self->MYka[@"制作权限"] intValue] == 5){
                cell.detailTextLabel.text = @"季卡及以下";
            }else if([self->MYka[@"制作权限"] intValue] == 6){
                cell.detailTextLabel.text = @"年卡及以下";
            }else if([self->MYka[@"制作权限"] intValue] == 7){
                cell.detailTextLabel.text = @"无限制";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        if(indexPath.section == 1){
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text = @"可制作数量";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self->MYka[@"制作数量"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        if(indexPath.section == 2){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
             NSString *sm= [self->MYka[@"说明"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",sm];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if(indexPath.section == 3){
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.textLabel.text = @"密码";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self->MYka[@"密码"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        //设置Cell右边的小箭头
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [personalTableView deselectRowAtIndexPath:[personalTableView indexPathForSelectedRow] animated:YES];
    
    if(indexPath.section == 0){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"小时" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            self->zzqx = @"1";
            self->MYka[@"制作权限"] = @"1";
            [self->personalTableView reloadData];
       
         }];

        UIAlertAction *bAction = [UIAlertAction actionWithTitle:@"天卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"2";
            self->MYka[@"制作权限"] = @"2";
            [self->personalTableView reloadData];
          
        }];
        
        UIAlertAction *cAction = [UIAlertAction actionWithTitle:@"周卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"3";
            self->MYka[@"制作权限"] = @"3";
            [self->personalTableView reloadData];
          
        }];
        
        UIAlertAction *dAction = [UIAlertAction actionWithTitle:@"月卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"4";
            self->MYka[@"制作权限"] = @"4";
            [self->personalTableView reloadData];
          
        }];
        
        UIAlertAction *eAction = [UIAlertAction actionWithTitle:@"季卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"5";
            self->MYka[@"制作权限"] = @"5";
            [self->personalTableView reloadData];
          
        }];
        
        UIAlertAction *fAction = [UIAlertAction actionWithTitle:@"年卡及以下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"6";
            self->MYka[@"制作权限"] = @"6";
            [self->personalTableView reloadData];
          
        }];
        
        UIAlertAction *gAction = [UIAlertAction actionWithTitle:@"无限制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self->zzqx = @"7";
            self->MYka[@"制作权限"] = @"7";
            [self->personalTableView reloadData];
          
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
    
    if(indexPath.section == 1){
    UIAlertController *KaMi = [UIAlertController alertControllerWithTitle:@"信息" message:@"请输入可制作数量" preferredStyle:UIAlertControllerStyleAlert];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     UITextField * jh1 = [[UITextField alloc]init];
                     
                     NSArray * textFieldArr = @[jh1];
                     
                     textFieldArr = KaMi.textFields;
                     
                     UITextField * tf1 = KaMi.textFields[0];
                     if(tf1.text.length != 0){
                         self->MYka[@"制作数量"] = tf1.text;
                         self->zzsl = tf1.text;
                         [self->personalTableView reloadData];
                     }
                 }]];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 }]];
                 
                 
                 [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                     
                     textField.placeholder = @"在此输入可制作数量";
                     textField.text = self->MYka[@"制作数量"];
                 }];
                 
                 
                [self presentViewController:KaMi animated:true completion:nil];
    }
    
    if(indexPath.section == 2){
    UIAlertController *KaMi = [UIAlertController alertControllerWithTitle:@"信息" message:@"请输入说明\n换行\\n" preferredStyle:UIAlertControllerStyleAlert];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     UITextField * jh1 = [[UITextField alloc]init];
                     
                     NSArray * textFieldArr = @[jh1];
                     
                     textFieldArr = KaMi.textFields;
                     
                     UITextField * tf1 = KaMi.textFields[0];
                     if(tf1.text.length != 0){
                         self->MYka[@"说明"] = tf1.text;
                         self->sm = tf1.text;
                         [self->personalTableView reloadData];
                     }
                 }]];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 }]];
                 
                 
                 [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                     
                     textField.placeholder = @"在此输入说明";
                     NSString *sm= [self->MYka[@"说明"] stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
                     textField.text = sm;
                 }];
                 
                 
                [self presentViewController:KaMi animated:true completion:nil];
    }
    
    if(indexPath.section == 3){
    UIAlertController *KaMi = [UIAlertController alertControllerWithTitle:@"信息" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     UITextField * jh1 = [[UITextField alloc]init];
                     
                     NSArray * textFieldArr = @[jh1];
                     
                     textFieldArr = KaMi.textFields;
                     
                     UITextField * tf1 = KaMi.textFields[0];
                     if(tf1.text.length != 0){
                         self->MYka[@"密码"] = tf1.text;
                         self->mm = tf1.text;
                         [self->personalTableView reloadData];
                     }
                 }]];
                 
                 [KaMi addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 }]];
                 
                 
                 [KaMi addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                     
                     textField.placeholder = @"在此输入密码";
                     textField.text = self->MYka[@"密码"];
                 }];
                 
                 
                [self presentViewController:KaMi animated:true completion:nil];
    }
    
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
        CALayer *lineLayer = [[CALayer alloc] init];
        
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        
        lineLayer.frame = CGRectMake(58, bounds.size.height-lineHeight, bounds.size.width-18, lineHeight);
        
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        
        [layer addSublayer:lineLayer];
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
