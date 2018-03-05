//
//  ViewController3.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "ViewController3.h"
#import "WWTabBarController.h"
#import "AppDelegate.h"

@interface ViewController3 ()<UITableViewDelegate>
@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self initButtons];
    
    self.tabBarItem.badgeValue = @"1";
}

#pragma mark - 跳转页面
- (void)btnClick{
    //    ViewController *vc = [ViewController new];
    //    vc.view.backgroundColor = [UIColor grayColor];
    //    [self.navigationController pushViewController:vc animated:YES];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate replaceTabbar];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


#pragma mark - 设置导航
- (void)initNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = self.tabBarItem.title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.view.backgroundColor = [UIColor yellowColor];
}

#pragma mark - 设置功能按钮
- (void)initButtons{
    UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0 ,0 ,150 ,30)];
    btn.center = self.view.center;
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


@end


