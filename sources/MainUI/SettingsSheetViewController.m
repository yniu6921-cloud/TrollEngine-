#import "SettingsSheetViewController.h"

@interface SettingsSheetViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray<NSString *> *kernels;
@property (nonatomic, copy) NSString *current;
@property (nonatomic, copy) void (^onSelect)(NSString *);
@property (nonatomic, strong) UITableView *table;
@end

@implementation SettingsSheetViewController

- (instancetype)initWithKernels:(NSArray<NSString *> *)kernels
                        current:(NSString *)current
                       onSelect:(void(^)(NSString *))onSelect {
    if (self = [super init]) {
        _kernels = [kernels copy];
        _current = [current copy] ?: @"physpuppet";
        _onSelect = [onSelect copy];
        self.view.backgroundColor = UIColor.secondarySystemBackgroundColor;
        self.preferredContentSize = CGSizeMake(0, 340); // 供旧系统参考
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 标题
    UILabel *title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"内核选择";
    title.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:title];

    // 表格
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.allowsSelection = YES;
    [self.view addSubview:self.table];

    // 提示
    UILabel *tip = [UILabel new];
    tip.translatesAutoresizingMaskIntoConstraints = NO;
    tip.text = @"提示：iOS 14 建议使用 landa";
    tip.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    tip.textColor = [UIColor secondaryLabelColor];
    tip.numberOfLines = 0;
    [self.view addSubview:tip];

    // 关闭按钮
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.translatesAutoresizingMaskIntoConstraints = NO;
    [close setTitle:@"完成" forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [close addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];

    UILayoutGuide *g = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:g.topAnchor constant:16],
        [title.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:16],

        [close.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-16],
        [close.centerYAnchor constraintEqualToAnchor:title.centerYAnchor],

        [self.table.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:8],
        [self.table.leadingAnchor constraintEqualToAnchor:g.leadingAnchor],
        [self.table.trailingAnchor constraintEqualToAnchor:g.trailingAnchor],

        [tip.topAnchor constraintEqualToAnchor:self.table.bottomAnchor constant:8],
        [tip.leadingAnchor constraintEqualToAnchor:g.leadingAnchor constant:16],
        [tip.trailingAnchor constraintEqualToAnchor:g.trailingAnchor constant:-16],
        [tip.bottomAnchor constraintEqualToAnchor:g.bottomAnchor constant:-16],
    ]];
}


- (void)onClose {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.kernels.count; }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"kernelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *name = self.kernels[indexPath.row];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    cell.accessoryType = [name isEqualToString:self.current] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *choice = self.kernels[indexPath.row];
    self.current = choice;

    // 刷新所有勾选
    for (NSInteger r = 0; r < self.kernels.count; r++) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:r inSection:0];
        UITableViewCell *c = [tableView cellForRowAtIndexPath:ip];
        c.accessoryType = (r == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }

    if (self.onSelect) self.onSelect(choice);
    // 也可以选中即关闭： [self dismissViewControllerAnimated:YES completion:nil];
}
@end
