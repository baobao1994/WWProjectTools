//
//  ViewController.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "ViewController.h"
#import "ViewController3.h"
#import "WWTabBarController.h"
#import "AppDelegate.h"

#import "TextViewViewController.h"
#import "PushViewController.h"
#import "WXSViewController.h"
#import "WWGifLoadingView.h"
#import "PictureBrowserViewController.h"
#import "ESPPictureBrowserViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<WSRefreshDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) WSRefreshTableView *tableView;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) WWGifLoadingView *gifLoadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    self.arr = @[@"TextInputBarView-模仿微信输入框扩展高度",@"自定义转场-Push",@"WXS自定义转场-All",@"GIF-Show-投递成功",@"GIF-Show-努力加载中...",@"图片浏览器",@"ESP图片浏览器"];
    [self.tableView reloadData];
}

- (WWGifLoadingView *)gifLoadingView {
    if (_gifLoadingView == nil) {
        _gifLoadingView = [[WWGifLoadingView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 44)];
        [self.view addSubview:_gifLoadingView];
    }
    return _gifLoadingView;
}

- (WSRefreshTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[WSRefreshTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.customTableDelegate = self;
        [_tableView setRefreshCategory:BothRefresh]; // 上下拉刷新
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma -mark WSRefreshDelegate

- (void)getHeaderDataSoure { // 下拉刷新代理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"下拉刷新代理");
        [self.tableView doneLoadingTableViewData];
    });
}

- (void)getFooterDataSoure { //上拉刷新代理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"上拉刷新代理");
        [self.tableView doneLoadingTableViewData];
    });
}

#pragma mark - 设置导航
- (void)initNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.tabBarItem.title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
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
    footerView.backgroundColor = [UIColor yellowColor];
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
    NSInteger row = indexPath.row;
    if (row == 3 || row == 4) {
        if (row == 3) {
            self.gifLoadingView.imageViewRect = CGRectMake(0, 0, 175 * ScreenScale, 175 * ScreenScale);
            self.gifLoadingView.needBackTap = YES;
            UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 250 * ScreenScale ) / 2, _gifLoadingView.frame.size.height / 2 + 30 * ScreenScale, 250 * ScreenScale, 20)];
            tipTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            tipTitleLabel.textColor = [UIColor blackColor];
            tipTitleLabel.textAlignment = NSTextAlignmentCenter;
            tipTitleLabel.text = @"投递成功";
            self.gifLoadingView.tipTitleLabel = tipTitleLabel;
            [self.gifLoadingView showLoading];
        } else {
            self.gifLoadingView.imageViewRect = CGRectMake(0, 0, 175 * ScreenScale, 175 * ScreenScale);
            self.gifLoadingView.needBackTap = YES;
            UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 175 * ScreenScale) / 2, _gifLoadingView.frame.size.height / 2 + 80 * ScreenScale, 175 * ScreenScale, 20)];
            tipTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            tipTitleLabel.textColor = [UIColor blackColor];
            tipTitleLabel.textAlignment = NSTextAlignmentCenter;
            tipTitleLabel.text = @"努力加载中...";
            self.gifLoadingView.tipTitleLabel = tipTitleLabel;
            [self.gifLoadingView showBounce];
        }
        [self.gifLoadingView showStart];
    } else {
        UIViewController *vc;
        if (row == 0) {
            vc = [(TextViewViewController *)[TextViewViewController alloc] init];
        } else if (row == 1) {
            vc = [(PushViewController *)[PushViewController alloc] init];
        } else if (row == 2) {
            vc = [(WXSViewController *)[WXSViewController alloc] init];
        } else if (row == 5) {
            vc = [(PictureBrowserViewController *)[PictureBrowserViewController alloc] init];
        } else if (row == 6) {
            vc = [(ESPPictureBrowserViewController *)[ESPPictureBrowserViewController alloc] init];
        }
        vc.title = self.arr[row];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

