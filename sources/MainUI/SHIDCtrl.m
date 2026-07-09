#import "SHIDCtrl.h"
#import "SHIDMonitor.h"
#import "HUDHelper.h"

#import <dlfcn.h>

@interface SHIDCtrl () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, copy)   NSArray<NSNumber *> *data;
@property (nonatomic, assign) uint64_t selectedSID;

// Header
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerTitle;
@property (nonatomic, strong) UILabel *headerSubtitle;
@property (nonatomic, strong) UISwitch *listenSwitch;   // 监听开关
@property (nonatomic, strong) UISwitch *loadSwitch;     // 加载内核开关（触发型）
@end

@implementation SHIDCtrl

- (instancetype)init {
    if ((self = [super init])) {
        _dismissOnSelect = YES; // 逻辑保留，但不再自动关闭
    }
    return self;
}

#pragma mark - Helpers
static inline NSString *BinaryString(uint64_t sid) {
    // 以 4 位一组插空格，美观易读（64 位共 71 字符）
    NSMutableString *s = [NSMutableString stringWithCapacity:71];
    for (NSInteger i = 63; i >= 0; i--) {
        [s appendString:((sid >> i) & 1) ? @"1" : @"0"];
        if (i % 4 == 0 && i != 0) [s appendString:@" "];
    }
    return s;
}

// 轻提示：文本 1.2s 自动消失

#pragma mark - iCloud 存取（UI 不显示 16 进制；仅 iCloud 额外存 16 进制字符串）
static inline NSString *HexString(uint64_t sid) {
    return [NSString stringWithFormat:@"0x%llX", sid];
}

static inline void SaveSIDToICloud(uint64_t sid) {
    NSUbiquitousKeyValueStore *store = NSUbiquitousKeyValueStore.defaultStore;
    // 兼容保留：LongLong（老逻辑可能在用）
    [store setLongLong:(long long)sid forKey:@"TouchSenderID"];
    // 仅用于“其他模块读取”：保存 16 进制字符串；UI 不显示
    [store setString:HexString(sid) forKey:@"TouchSenderIDHex"];
    [store synchronize];
}

static inline uint64_t LoadSIDFromICloud(void) {
    NSUbiquitousKeyValueStore *store = NSUbiquitousKeyValueStore.defaultStore;
    long long v = [store longLongForKey:@"TouchSenderID"]; // 没有则为 0
    if (v != 0) return (uint64_t)v;
    // 兼容：如仅有十六进制字符串，则解析
    NSString *hex = [store stringForKey:@"TouchSenderIDHex"];
    if (hex.length > 0) {
        const char *c = hex.UTF8String;
        char *end = NULL;
        unsigned long long val = strtoull(c, &end, 0); // 支持 0x 前缀
        return (uint64_t)val;
    }
    return 0;
}

static inline void ClearSIDFromICloud(void) {
    NSUbiquitousKeyValueStore *store = NSUbiquitousKeyValueStore.defaultStore;
    [store removeObjectForKey:@"TouchSenderID"];
    [store removeObjectForKey:@"TouchSenderIDHex"];
    [store synchronize];
}

#pragma mark - 生成 SenderID（以 dlsym 动态查找，避免强链接）
static bool CallExternalGenerateSenderID(void) {
    fasongxuni();
    return true;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自瞄标识符"; // 更直观的标题
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    // 导航大标题 & 主题着色
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;

    // 右侧仅保留：清空
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"trash"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(onClear)];
    self.navigationItem.rightBarButtonItems = @[clearItem];

    // 左侧：返回（以防没有系统返回）
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                            target:self action:@selector(back)];
    }

    // Header：毛玻璃 + 状态/提示 + 两个“开关”并排
    [self buildHeader];

    // 列表
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    self.table.dataSource = self;
    self.table.delegate   = self;
    self.table.rowHeight  = 56;
    self.table.tableHeaderView = self.headerView; // 顶部信息卡
    [self.view addSubview:self.table];

    [NSLayoutConstraint activateConstraints:@[
        [self.table.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.table.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.table.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.table.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];

    // 初始数据 + 监听通知
    self.data = SHIDMonitor.shared.senderIDs;
    self.selectedSID = LoadSIDFromICloud();
    [self refreshHeader];
    [self updateEmptyState];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onUpdate:)
                                                 name:kSHIDMonitorDidUpdate
                                               object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 让 tableHeaderView 自适应内容高度
    if (self.table.tableHeaderView) {
        UIView *header = self.table.tableHeaderView;
        CGSize size = [header systemLayoutSizeFittingSize:CGSizeMake(self.view.bounds.size.width, UILayoutFittingCompressedSize.height)];
        if (fabs(header.frame.size.height - size.height) > 0.5) {
            header.frame = CGRectMake(0, 0, size.width, size.height);
            self.table.tableHeaderView = header;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Header UI
- (UILabel *)smallLabel:(NSString *)text {
    UILabel *lb = [UILabel new];
    lb.translatesAutoresizingMaskIntoConstraints = NO;
    lb.text = text;
    lb.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    lb.textColor = UIColor.secondaryLabelColor;
    return lb;
}

- (void)buildHeader {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 210)];

    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemThinMaterial]];
    blur.translatesAutoresizingMaskIntoConstraints = NO;
    blur.layer.cornerRadius = 20;
    blur.layer.masksToBounds = YES;

    UILabel *title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"快速控制";
    title.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];

    UILabel *sub = [UILabel new];
    sub.translatesAutoresizingMaskIntoConstraints = NO;
    sub.textColor = UIColor.secondaryLabelColor;
    sub.numberOfLines = 2;
    sub.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    // 两个开关并排：监听 / 加载内核
    UILabel *lbListen = [self smallLabel:@"监听"];
    UISwitch *swListen = [UISwitch new];
    swListen.translatesAutoresizingMaskIntoConstraints = NO;
    [swListen addTarget:self action:@selector(onListenToggle:) forControlEvents:UIControlEventValueChanged];

    UILabel *lbLoad = [self smallLabel:@"加载标识符"];
    UISwitch *swLoad = [UISwitch new];
    swLoad.translatesAutoresizingMaskIntoConstraints = NO;
    [swLoad addTarget:self action:@selector(onLoadToggle:) forControlEvents:UIControlEventValueChanged];

    // 左右列栈
    UIStackView *colLeft = [[UIStackView alloc] initWithArrangedSubviews:@[lbListen, swListen]];
    colLeft.axis = UILayoutConstraintAxisVertical;
    colLeft.spacing = 6;

    UIStackView *colRight = [[UIStackView alloc] initWithArrangedSubviews:@[lbLoad, swLoad]];
    colRight.axis = UILayoutConstraintAxisVertical;
    colRight.spacing = 6;

    UIStackView *row = [[UIStackView alloc] initWithArrangedSubviews:@[colLeft, colRight]];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 16;
    row.distribution = UIStackViewDistributionFillEqually;
    row.translatesAutoresizingMaskIntoConstraints = NO;

    [blur.contentView addSubview:title];
    [blur.contentView addSubview:sub];
    [blur.contentView addSubview:row];
    [container addSubview:blur];

    [NSLayoutConstraint activateConstraints:@[
        [blur.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16],
        [blur.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16],
        [blur.topAnchor constraintEqualToAnchor:container.topAnchor constant:10],
        [blur.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-10],

        [title.leadingAnchor constraintEqualToAnchor:blur.contentView.leadingAnchor constant:16],
        [title.topAnchor constraintEqualToAnchor:blur.contentView.topAnchor constant:16],

        [sub.leadingAnchor constraintEqualToAnchor:title.leadingAnchor],
        [sub.trailingAnchor constraintEqualToAnchor:blur.contentView.trailingAnchor constant:-16],
        [sub.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:6],

        [row.leadingAnchor constraintEqualToAnchor:blur.contentView.leadingAnchor constant:16],
        [row.trailingAnchor constraintEqualToAnchor:blur.contentView.trailingAnchor constant:-16],
        [row.topAnchor constraintEqualToAnchor:sub.bottomAnchor constant:12],
        [row.bottomAnchor constraintEqualToAnchor:blur.contentView.bottomAnchor constant:-14],
        [row.heightAnchor constraintGreaterThanOrEqualToConstant:44],
    ]];

    self.headerView = container;
    self.headerTitle = title;
    self.headerSubtitle = sub;
    self.listenSwitch = swListen;
    self.loadSwitch = swLoad;
}

- (void)refreshHeader {
    // 状态文案：一眼能懂
    BOOL listening = SHIDMonitor.shared.isListening;
    self.listenSwitch.on = listening;

    NSUInteger idx = [self.data indexOfObject:@(self.selectedSID)];
    NSString *selectLine = @"未选择";
    if (self.selectedSID != 0 && idx != NSNotFound) {
        selectLine = [NSString stringWithFormat:@"已选：标识符 %lu", (unsigned long)(idx + 1)];
    }

    if (listening) {
        self.headerSubtitle.text = [NSString stringWithFormat:@"监听中 · 列表自动更新 选择完后关闭\n%@", selectLine];
    } else {
        self.headerSubtitle.text = [NSString stringWithFormat:@"未监听 · 打开上方“监听”开始\n%@", selectLine];
    }
}

#pragma mark - 空状态
- (void)updateEmptyState {
    if (self.data.count == 0) {
        UILabel *empty = [UILabel new];
        empty.textAlignment = NSTextAlignmentCenter;
        empty.textColor = UIColor.secondaryLabelColor;
        empty.numberOfLines = 0;
        empty.text = @"暂无标识符\n打开上方‘监听’获取列表";
        empty.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.table.backgroundView = empty;
    } else {
        self.table.backgroundView = nil;
    }
}

#pragma mark - Actions
- (void)onListenToggle:(UISwitch *)sw {
    if (sw.isOn) {
        [SHIDMonitor.shared start];
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [gen impactOccurred];
       
    } else {
        [SHIDMonitor.shared stop];
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [gen impactOccurred];
      
    }
    [self refreshHeader];
}

- (void)onLoadToggle:(UISwitch *)sw {
    // 触发型：拨到 ON 触发加载，随后自动回弹为 OFF
    if (sw.isOn) {
        UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [gen impactOccurred];
        if (CallExternalGenerateSenderID()) {
          
        } else {
           
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [sw setOn:NO animated:YES];
        });
    }
}

- (void)onClear {
    if (self.selectedSID == 0 && self.data.count == 0) {
      
        return;
    }

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"确认清空？"
                                                                message:@"将清除已监听的标识符列表，并移除已选择的记录。"
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    __weak typeof(self) weakSelf = self;
    [ac addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SHIDMonitor.shared clear];
        weakSelf.selectedSID = 0;
        ClearSIDFromICloud();
        [weakSelf.table reloadData];
        [weakSelf refreshHeader];
        [weakSelf updateEmptyState];
      
    }]];

    ac.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItems.firstObject; // iPad 适配（锚定右上角“删除”）
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)onGenerate { // 兼容旧调用（目前不在 UI 中直接使用）
    if (CallExternalGenerateSenderID()) {
       
    } else {
       
    }
}

- (void)back {
    if (self.presentingViewController && self.navigationController.viewControllers.firstObject == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Notification
- (void)onUpdate:(NSNotification *)note {
    self.data = SHIDMonitor.shared.senderIDs;
    [self.table reloadData];
    [self updateEmptyState];
    [self refreshHeader];
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"已监听到的标识符（%lu）", (unsigned long)self.data.count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *ID = @"sid.cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];

    uint64_t sid = self.data[ip.row].unsignedLongLongValue;

    // 左侧：内核编号（简单易懂）
    cell.textLabel.text = [NSString stringWithFormat:@"标识符 %ld", (long)ip.row+1];
    cell.textLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];

    // 右侧：不显示 16 进制，不显示超长二进制；简单文案
    BOOL selected = (sid == self.selectedSID);
    cell.detailTextLabel.text = selected ? @"已选择" : @"点击选择";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    cell.detailTextLabel.textColor = selected ? UIColor.labelColor : UIColor.secondaryLabelColor;
    cell.detailTextLabel.numberOfLines = 1;

    cell.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];

    uint64_t newSID = self.data[ip.row].unsignedLongLongValue;

    uint64_t oldSID = self.selectedSID;
    self.selectedSID = newSID;

    SaveSIDToICloud(newSID); // 保存：十进制（兼容）+ 十六进制字符串（供其他模块读取）；UI 不显示 16 进制

    [self refreshHeader];

    NSMutableArray<NSIndexPath *> *toReload = [NSMutableArray arrayWithObject:ip];
    if (oldSID != 0 && oldSID != newSID) {
        NSUInteger oldIndex = [self.data indexOfObject:@(oldSID)];
        if (oldIndex != NSNotFound) {
            [toReload addObject:[NSIndexPath indexPathForRow:oldIndex inSection:0]];
        }
    }
    [tv reloadRowsAtIndexPaths:toReload withRowAnimation:UITableViewRowAnimationNone];

    UIImpactFeedbackGenerator *gen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [gen impactOccurred];
   

    // 不自动关闭
}

// 按需求：移除长按复制功能（不再提供复制二进制/十进制的菜单）

@end
