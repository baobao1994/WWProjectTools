//
//  WWTabBarConfig.h
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HidesBottomBarWhenPushedOption) {
    HidesBottomBarWhenPushedNormal,  /**< 普通样式，存在所有页面 */
    HidesBottomBarWhenPushedAlone,  /**< 只在根页面存在 */
    HidesBottomBarWhenPushedTransform  /**< 只在根页面存在，在其他页下移消失 */
};

@interface WWTabBarConfig : NSObject
/** TabBar个数 */
@property (nonatomic, assign) NSInteger tabBarCount;
/** 设置文字颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 设置文字选中颜色 */
@property (nonatomic, strong) UIColor *selectedTextColor;
/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** Tabbar阴影背景颜色 */
@property (nonatomic, strong) UIColor *shadowBackgroundColor;
/** 指定的初始化控制器 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 中间按钮所在位置 */
@property (nonatomic, assign) NSInteger centerBtnIndex;
/** 中间按钮凸出的高度 */
@property (nonatomic, assign) CGFloat bulgeHeight;
/** 二级页面隐藏选项 */
@property (nonatomic, assign) HidesBottomBarWhenPushedOption HidesBottomBarWhenPushedOption;
//默认没有动画
/** TabBar点击动画 */
@property (nonatomic, copy) NSString *animationPath;
//默认放大缩小的参数
/** Tabbar点击动画执行时间 */
@property (nonatomic, assign) double duration;
/** Tabbar点击动画初始伸缩倍数 */
@property (nonatomic, copy) NSNumber *frmValue;
/** Tabbar点击动画结束伸缩倍数 */
@property (nonatomic, copy) NSNumber *toValue;
//默认移除
/** Tabbar移除过往的动画，仅限当前状态 */
@property (nonatomic, assign) BOOL isRemoveAnimate;

/**
 *  外观配置的单例对象
 */
+ (instancetype)shared;

@end
