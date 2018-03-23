//
//  BasicViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //判断是否是一级视图，若是则关闭滑动返回手势
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

@end
