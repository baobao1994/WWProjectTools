//
//  WSTableViewController.m
//  FrameTemplate
//
//  Created by zws on 2017/10/27.
//  Copyright © 2017年 vma. All rights reserved.
//

#import "WSTableViewController.h"

@interface WSTableViewController ()<WSRefreshDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation WSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.tableView) {
        self.tableView = [[WSRefreshTableView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.tableView];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.customTableDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //解决滑动动画卡顿问题以及头部偏移20问题
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
