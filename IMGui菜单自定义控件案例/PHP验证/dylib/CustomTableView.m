
#import <objc/runtime.h>
#import "CustomTableView.h"

@interface CustomTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionsArray;

@end

@implementation CustomTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.sectionsArray = [NSMutableArray array];
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)addSectionWithTitle:(NSString *)title andSubfunctions:(void (^)(void))subfunctions {
    NSMutableDictionary *sectionDict = [NSMutableDictionary dictionary];
    [sectionDict setObject:title forKey:@"title"];
    [sectionDict setObject:[NSMutableArray array] forKey:@"rows"];
    [sectionDict setObject:subfunctions forKey:@"subfunctions"];
    [self.sectionsArray addObject:sectionDict];
    [self reloadData];
}

- (void)addButtonWithTitle:(NSString *)title andActionBlock:(void (^)(void))actionBlock {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sectionsArray.count-1];
    NSMutableDictionary *sectionDict = [self.sectionsArray objectAtIndex:indexPath.section];
    NSMutableArray *rowsArray = [sectionDict objectForKey:@"rows"];
    [rowsArray addObject:@{@"type":@"button", @"title":title, @"actionBlock":actionBlock}];
    [self reloadData];
}

- (void)addSwitchWithTitle:(NSString *)title andActionBlock:(void (^)(BOOL isOn))actionBlock {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sectionsArray.count-1];
    NSMutableDictionary *sectionDict = [self.sectionsArray objectAtIndex:indexPath.section];
    NSMutableArray *rowsArray = [sectionDict objectForKey:@"rows"];
    [rowsArray addObject:@{@"type":@"switch", @"title":title, @"actionBlock":actionBlock}];
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowsArray = [[self.sectionsArray objectAtIndex:section] objectForKey:@"rows"];
    return rowsArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionsArray objectAtIndex:section] objectForKey:@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CustomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    NSArray *rowsArray = [[self.sectionsArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSDictionary *rowDict = [rowsArray objectAtIndex:indexPath.row];
    NSString *title = [rowDict objectForKey:@"title"];
    cell.textLabel.text = title;
    if ([[rowDict objectForKey:@"type"] isEqualToString:@"switch"]) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        void (^actionBlock)(BOOL isOn) = [rowDict objectForKey:@"actionBlock"];
        [switchView addTarget:self action:@selector(handleSwitchValueChange:) forControlEvents:UIControlEventValueChanged];
        objc_setAssociatedObject(switchView, "block", actionBlock, OBJC_ASSOCIATION_COPY);
    } else {
        cell.accessoryView = nil;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = [self.sectionsArray objectAtIndex:indexPath.section];
    void (^subfunctionsBlock)(void) = [sectionDict objectForKey:@"subfunctions"];
    if (subfunctionsBlock) {
        subfunctionsBlock();
    }
}

#pragma mark - Private Methods

- (void)handleSwitchValueChange:(UISwitch *)sender {
    void (^actionBlock)(BOOL isOn) = objc_getAssociatedObject(sender, "block");
    if (actionBlock) {
        actionBlock(sender.isOn);
    }
}

@end

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//return 40.0;
//}
