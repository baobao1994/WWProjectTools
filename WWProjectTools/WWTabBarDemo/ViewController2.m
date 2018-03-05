//
//  ViewController2.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "ViewController2.h"
#import "WWTabBar.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    if (@available(iOS 10.0, *)) {
        self.tabBarItem.badgeColor = [UIColor orangeColor];
    } else {
        // Fallback on earlier versions
    }
    self.tabBarItem.badgeValue = nil;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setImage:[[UIImage imageNamed:@"tab_1_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
}

@end

