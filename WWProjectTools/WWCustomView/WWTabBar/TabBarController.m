//
//  TabBarController.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "TabBarController.h"
#import "PlusAnimate.h"
#import "WWTabBarConfig.h"
#import "EditMotherNoteViewController.h"
#import "EditVariousIndicatorsViewController.h"
#import "EditEventViewController.h"
#import "WWNavigationController.h"

@interface TabBarController ()<WWTabBarDelegate>

@property (nonatomic, assign) NSInteger indexFlag;
@property (nonatomic, strong) PlusAnimate *plusAnimateView;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wwtabbar.delegate = self;
    self.indexFlag = [WWTabBarConfig shared].selectIndex;
}

#pragma mark - WWTabBarDelegate
//中间按钮点击 有动画 需自定义
- (void)tabbar:(WWTabBar *)tabbar clickForCenterButton:(WWCenterButton *)centerButton{
    [PlusAnimate standardPublishAnimateWithView:(UIView *)centerButton didSelectButtonBlock:^(NSInteger tag) {
        NSLog(@"tag = %ld",tag);
        WWNavigationController *navigationController = self.selectedViewController;
        UIViewController *rootVC = navigationController.viewControllers[0];
        UIViewController *vc;
        if (tag == 0) {
            vc = [[EditMotherNoteViewController alloc] init];
        } else if (tag == 1) {
            vc = [[EditVariousIndicatorsViewController alloc] init];
        } else {
            vc = [[EditEventViewController alloc] init];
        }
        [rootVC.navigationController pushViewController:vc animated:YES];
    }];
}

//是否允许切换
- (BOOL)tabBar:(WWTabBar *)tabBar willSelectIndex:(NSInteger)index{
    NSLog(@"将要切换到---> %ld",index);
    return YES;
}

//通知切换的下标
- (void)tabBar:(WWTabBar *)tabBar didSelectIndex:(NSInteger)index{
    NSLog(@"切换到---> %ld",index);
    if (self.indexFlag != index && [WWTabBarConfig shared].animationPath != nil) {
        [self animationWithIndex:index];
    }
}

// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.wwtabbar.subviews) {
        //        NSLog(@"dddd%@",tabBarButton.class);
        if ([tabBarButton isKindOfClass:NSClassFromString(@"WWButton")] || [tabBarButton isKindOfClass:NSClassFromString(@"WWCenterButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:[WWTabBarConfig shared].animationPath];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = [WWTabBarConfig shared].duration;       //执行时间
    animation.repeatCount = 1;      //执行次数
    if ([[WWTabBarConfig shared].animationPath isEqualToString:@"transform.scale"]) {
        if ([WWTabBarConfig shared].isRemoveAnimate) {
            //放大缩小 transform.scale
            animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        } else {
            //放大并保持 transform.scale
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;           //保证动画效果延续
        }
    } else if ([[WWTabBarConfig shared].animationPath isEqualToString:@"transform.translation.y"]) {
        //Y轴位移 transform.translation.y 建议值 fromValue:0 toValue:-10
        animation.removedOnCompletion = YES;
    } else if ([[WWTabBarConfig shared].animationPath isEqualToString:@"transform.translation.z"]) {
        //Z轴旋转 transform.rotation.z 建议值 fromValue:0 toValue:M_PI
        animation.removedOnCompletion = YES;
    }
    
    animation.fromValue = [WWTabBarConfig shared].frmValue;   //初始伸缩倍数
    animation.toValue = [WWTabBarConfig shared].toValue;     //结束伸缩倍数
    [[tabbarbuttonArray[index] layer] addAnimation:animation forKey:nil];
    if ([WWTabBarConfig shared].isRemoveAnimate) {
        //移除其他tabbar的动画
        for (int i = 0; i<tabbarbuttonArray.count; i++) {
            if (i != index) {
                [[tabbarbuttonArray[i] layer] removeAllAnimations];
            }
        }
    }
    self.indexFlag = index;
}

@end
