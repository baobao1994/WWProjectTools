//
//  WWTabBar.h
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWCenterButton;
@class WWButton;
@class WWTabBar;

@protocol WWTabBarDelegate <NSObject>
@optional
/**
 *   中间按钮点击通知
 */
- (void)tabbar:(WWTabBar *)tabbar clickForCenterButton:(WWCenterButton *)centerButton;

/**
 *  是否允许切换控制器,(通过TabBarController来直接设置SelectIndex来切换的是不会收到通知的)
 */
- (BOOL)tabBar:(WWTabBar *)tabBar willSelectIndex:(NSInteger)index;

/**
 *  通知已经选择的控制器下标
 */
- (void)tabBar:(WWTabBar *)tabBar didSelectIndex:(NSInteger)index;

@end

@interface WWTabBar : UIView

/** tabbar按钮显示信息 */
@property (copy, nonatomic) NSArray<UITabBarItem *> *items;
/** 其他按钮 */
@property (strong , nonatomic) NSMutableArray <WWButton*>*btnArr;
/** 中间按钮 */
@property (strong , nonatomic) WWCenterButton *centerBtn;
/** tabBar通知委托 */
@property (weak , nonatomic) id<WWTabBarDelegate>delegate;

@end

@interface ContentView : UIView

@property (strong , nonatomic) UITabBarController *controller;

@end
