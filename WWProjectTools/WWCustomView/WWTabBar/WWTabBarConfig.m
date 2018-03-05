//
//  WWTabBarConfig.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWTabBarConfig.h"

@implementation WWTabBarConfig

+ (instancetype)shared {
    static WWTabBarConfig *config = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        config = [WWTabBarConfig new];
        config.tabBarCount = 5;
        config.textColor = [UIColor grayColor];
        config.selectedTextColor = config.textColor;
        config.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        config.shadowBackgroundColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:1];
        config.bulgeHeight = 16.f;
        config.selectIndex = -1; // 指定的初始化控制器(<0时为默认)
        config.centerBtnIndex = -1;
        config.HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedNormal;
        config.animationPath = nil;
        config.duration = 0.1;
        config.frmValue = [NSNumber numberWithFloat:0.7];
        config.toValue = [NSNumber numberWithFloat:1.1];
        config.isRemoveAnimate = YES;
    });
    return config;
}

- (void)setTabBarCount:(NSInteger)tabBarCount {
    _tabBarCount = tabBarCount;
    self.centerBtnIndex = tabBarCount / 2;
}

@end
