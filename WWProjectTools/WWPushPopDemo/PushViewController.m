//
//  PushViewController.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "PushViewController.h"
#import "PopViewController.h"
#import "WWPushTransition.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PushViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *pushButton;
@property (nonatomic, strong) WWPushTransition *pushTransition;
@property (nonatomic, strong) PopViewController *popVC;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray *arr;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.pushButton];
    [self.view addSubview:self.sourceImageView];
    
//    self.arr = @[@"pop0",@"pop1",@"pop2",@"pop3",@"pop4",@"pop5",@"pop6",@"pop7"];
//    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush){ // 就是在这里判断是哪种动画类型
        self.pushTransition.fromSubView = self.sourceImageView;
        self.pushTransition.toView = self.popVC.avatarImageView;
        return self.pushTransition; // 返回push动画的类
    }else{
        return nil;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PopViewController *vc = [[PopViewController alloc] init];
    vc.title = self.arr[indexPath.row];
    vc.view.backgroundColor = [UIColor whiteColor];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.pushTransition.fromView = cell;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (WWPushTransition *)pushTransition {
    if (_pushTransition == nil) {
        _pushTransition = [[WWPushTransition alloc] init];
    }
    return _pushTransition;
}

- (UIImageView *)sourceImageView {
    if (_sourceImageView == nil) {
        _sourceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, ScreenWidth - 20, 100)];
        _sourceImageView.image = [UIImage imageNamed:@"ad_bg"];
    }
    return _sourceImageView;
}

- (UIButton *)pushButton {
    if (_pushButton == nil) {
        _pushButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, ScreenWidth, 50)];
        [_pushButton setTitle:@"push" forState:UIControlStateNormal];
        [_pushButton addTarget:self action:@selector(pushNext:) forControlEvents:UIControlEventTouchUpInside];
        [_pushButton setBackgroundColor:[UIColor greenColor]];
    }
    return _pushButton;
}

- (void)pushNext:(UIButton *)sender {
    PopViewController *popVC = [[PopViewController alloc] init];
    popVC.view.backgroundColor = [UIColor whiteColor];
    kWeakSelf;
    self.pushTransition.fromRectChange = ^(CGRect fromRect) {
        popVC.toViewRect = weakSelf.pushTransition.fromRect;
    };
    [self.navigationController pushViewController:popVC animated:YES];
}

- (PopViewController *)popVC {
    if (_popVC == nil) {
        _popVC = [[PopViewController alloc] init];
    }
    return _popVC;
}

@end
