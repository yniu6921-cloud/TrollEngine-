//.______          ___      ___   ___  __  .__   __. ____    ____
//|   _  \        /   \     \  \ /  / |  | |  \ |  | \   \  /   /
//|  |_)  |      /  ^  \     \  V  /  |  | |   \|  |  \   \/   /
//|      /      /  /_\  \     >   <   |  | |  . `  |   \_    _/
//|  |\  \----./  _____  \   /  .  \  |  | |  |\   |     |  |
//| _| `._____/__/     \__\ /__/ \__\ |__| |__| \__|     |__|
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppViewController_2.h"
#import <AudioToolbox/AudioToolbox.h>
#import "JieSuoMaViewController.h"
#import "MyInfoJianghu.h"
#import "BlackViewController.h"
#import "EditViewController.h"
#import "DaiLiViewController.h"
#import "ViewController.h"

#define KEY_WINDOW1 [UIApplication sharedApplication].keyWindow

@interface AppViewController2 ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    NSString *chuxing01;
    NSString *chuxing02;
    NSString *chuxing03;
    NSString *chuxing04;
    NSString *chuxing05;
    UITableView *personalTableView;
    NSMutableDictionary *MYka;
    BOOL T;
}

@end


@implementation AppViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    personalTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    personalTableView.backgroundColor =   [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:personalTableView];
    personalTableView.dataSource = self;
    personalTableView.delegate = self;
    personalTableView.bounces = NO;//yes，就是滚动超过边界会反弹有反弹回来的效果; NO，那么滚动到达边界会立刻停止。
    personalTableView.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线
    personalTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    personalTableView.estimatedRowHeight = 100;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@" 返回 " style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    leftItem.tintColor = [UIColor labelColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    

}

-(void)viewWillAppear:(BOOL)animated{
  
    UIActivityIndicatorView *_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    _activityIndicator.frame = CGRectMake(25, 10, 50, 40);
    _activityIndicator.backgroundColor = [UIColor clearColor];
    _activityIndicator.hidesWhenStopped = NO;
    _activityIndicator.center = self.view.center;
    [self.view addSubview:_activityIndicator];
    [_activityIndicator startAnimating];
    
    // 获取 JSON 文件的 URL
    NSString *jsonURLString = @"http://www.iggcheat.com/chuxing.json";
    NSURL *jsonURL = [NSURL URLWithString:jsonURLString];

    // 创建一个 NSURLSession 对象
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_async(dispatch_get_main_queue(), ^{
        // 创建一个数据任务来获取 JSON 数据
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:jsonURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                NSLog(@"网络请求失败: %@", error.localizedDescription);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_activityIndicator stopAnimating];
                    _activityIndicator.hidden = YES;
                    self->T = YES;
                    [self->personalTableView reloadData];
                });
                // 解析 JSON 数据
                NSError *jsonError = nil;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"JSON 解析失败: %@", jsonError.localizedDescription);
                } else {
                    // 解析成功，获取参数值
                    self->chuxing01 = jsonDict[@"chuxing01"];
                    self->chuxing02 = jsonDict[@"chuxing02"];
                    self->chuxing03 = jsonDict[@"chuxing03"];
                    self->chuxing04 = jsonDict[@"chuxing04"];
                    self->chuxing05 = jsonDict[@"chuxing05"];
                }
            }
        }];
        
        // 启动数据任务
        [dataTask resume];
        
    });
    
}


- (void)goBackAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TbaleView的数据源代理方法实现

    //返回组数的代理方法
    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        if(T){
            return 5;
        }else{
            return 0;
        }
    }
    //返回行数的代理方法
    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 2;
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
    
   
        NSString *copyright = @" ";
        return copyright;
    
    
    
    return nil;
}
    
    //每个分组下边预留的空白高度
    -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        
        return 20;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        if(indexPath.section == 0){
            if(indexPath.row == 0){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                
                cell.textLabel.text = [NSString stringWithFormat:@"🧧滴滴打车优惠卷"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"滴滴打车"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row == 1){
                NSString *str = [NSString stringWithFormat:@"最高100元\t可叠加使用"];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                cell.textLabel.attributedText = attrStr;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
                btn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
                [btn setTitle:@"前往领取" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
                btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
                btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
                btn.layer.borderWidth = 1.95f;//边框大小
                btn.tag = 101;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = btn;
            }
        }
        
        
        if(indexPath.section == 1){
            if(indexPath.row == 0){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                
                cell.textLabel.text = [NSString stringWithFormat:@"🧧滴滴打车折扣卷"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"滴滴打车"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row == 1){
                NSString *str = [NSString stringWithFormat:@"最高优惠100元\t可叠加使用"];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                cell.textLabel.attributedText = attrStr;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
                btn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
                [btn setTitle:@"前往领取" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
                btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
                btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
                btn.layer.borderWidth = 1.95f;//边框大小
                btn.tag = 102;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = btn;
            }
        }
        
        if(indexPath.section == 2){
            if(indexPath.row == 0){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                
                cell.textLabel.text = [NSString stringWithFormat:@"🧧滴滴网约车优惠卷"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"滴滴打车"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row == 1){
                NSString *str = [NSString stringWithFormat:@"网约车专用\t最高100元"];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                cell.textLabel.attributedText = attrStr;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
                btn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
                [btn setTitle:@"前往领取" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
                btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
                btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
                btn.layer.borderWidth = 1.95f;//边框大小
                btn.tag = 103;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = btn;
            }
        }
        
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                
                cell.textLabel.text = [NSString stringWithFormat:@"🧧T3出行无门槛优惠卷"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"T3出行"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row == 1){
                NSString *str = [NSString stringWithFormat:@"百分百10元\t无门槛使用"];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                cell.textLabel.attributedText = attrStr;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
                btn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
                [btn setTitle:@"前往领取" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
                btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
                btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
                btn.layer.borderWidth = 1.95f;//边框大小
                btn.tag = 104;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                //[cell.contentView addSubview:btn];
                cell.accessoryView = btn;
            }
        }
        
        if(indexPath.section == 4){
            if(indexPath.row == 0){
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
                
                cell.textLabel.text = [NSString stringWithFormat:@"🧧花小猪聚合红包"];
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"花小猪打车"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(indexPath.row == 1){
                NSString *str = [NSString stringWithFormat:@"100元组合优惠卷\t部分无门槛使用"];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                cell.textLabel.attributedText = attrStr;
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
                btn.layer.cornerRadius = 7.0;//2.0是圆角的弧度，根据需求自己更改
                [btn setTitle:@"前往领取" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//p1颜色
                btn.backgroundColor = [UIColor colorWithRed:34/255.0 green:181/255.0 blue:115/250.0 alpha:1];
                btn.layer.borderColor = [[UIColor whiteColor] CGColor];//边框颜色
                btn.layer.borderWidth = 1.95f;//边框大小
                btn.tag = 105;
                [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];//字体大小
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                //[cell.contentView addSubview:btn];
                cell.accessoryView = btn;
            }
        }
        
        

        return cell;
    }

- (void)buttonClicked:(UIButton *)sender {
    // 获取按钮的tag值
    NSInteger tag = sender.tag;
    // 根据tag值进行相应的处理
    if (tag == 101) {
        NSURL *URL = [NSURL URLWithString:chuxing01];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    } else if (tag == 102) {
        NSURL *URL = [NSURL URLWithString:chuxing02];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if (tag == 103) {
        NSURL *URL = [NSURL URLWithString:chuxing03];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if (tag == 104) {
        NSURL *URL = [NSURL URLWithString:chuxing04];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }else if (tag == 105) {
        NSURL *URL = [NSURL URLWithString:chuxing05];
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
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
