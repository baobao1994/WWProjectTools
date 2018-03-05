//
//  AppDelegate.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "TabBarController.h"
#import "WWTabBarConfig.h"

@interface AppDelegate ()

@property (nonatomic, strong) WWTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (WWTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        // 继承WWTabBar的控制器， 你可以自定定义 或 不继承直接使用
        _tabBarController = [[TabBarController alloc]init];
        
        // 配置
        [WWTabBarConfig shared].selectedTextColor = [UIColor orangeColor];
        [WWTabBarConfig shared].textColor = [UIColor grayColor];
        [WWTabBarConfig shared].backgroundColor = [UIColor whiteColor];
        [WWTabBarConfig shared].selectIndex = 0;
        [WWTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedAlone;
        
        // 样式
        switch (3) {
            case 0:
                // 中间按钮突出 ， 设为按钮 , 底部有文字 ， 闲鱼
                [self style1:_tabBarController];
                break;
            case 1:
                // 中间按钮不突出 ， 设为控制器 ,底部无文字  , 微博
                [self style2:_tabBarController];
                break;
            case 2:
                //无中间按钮 ，普通样式
                [self style3:_tabBarController];
                break;
            default:
                //无中间按钮 ，普通样式
                [self style4:_tabBarController];
                break;
        }
    }
    
    return _tabBarController;
}

- (void)replaceTabbar {
    WWTabBarController * tabbar = [[TabBarController alloc]init];
    [self style5:tabbar];
    CGRect theRect = tabbar.wwtabbar.frame;
    [WWTabBarConfig shared].animationPath = @"transform.scale";
    [WWTabBarConfig shared].selectIndex = 0;
    self.window.rootViewController = tabbar;
    tabbar.wwtabbar.frame = CGRectMake(-theRect.size.width, 0, theRect.size.width, theRect.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        tabbar.wwtabbar.frame = CGRectMake(0, 0, tabbar.wwtabbar.frame.size.width, tabbar.wwtabbar.frame.size.height);
    }];
}

- (void)style1:(WWTabBarController *)tabbar {
    [WWTabBarConfig shared].tabBarCount = 3;
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
    [tabbar addChildController:nav1 title:@"发现" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav2 title:@"我的" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
    [tabbar addCenterController:nil bulge:YES title:@"发布" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
}

- (void)style2:(WWTabBarController *)tabbar {
    [WWTabBarConfig shared].tabBarCount = 3;
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
    [tabbar addCenterController:[ViewController2 new] bulge:NO title:nil imageName:@"tabbar_centerplus_selected" selectedImageName:@"tabbar_centerplus_selected"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController2 new]];
    [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
    
}

- (void)style3:(WWTabBarController *)tabbar {
    [WWTabBarConfig shared].tabBarCount = 2;
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"消息" imageName:@"tabbar_mainframe" selectedImageName:@"tabbar_mainframeHL"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav2 title:@"朋友圈" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discoverHL"];
}

- (void)style4:(WWTabBarController *)tabbar {
    [WWTabBarConfig shared].tabBarCount = 3;
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"发现" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    [tabbar addCenterController:[ViewController2 new] bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"post_normal"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController3 new]];
    [tabbar addChildController:nav2 title:@"我的" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
}

- (void)style5:(WWTabBarController *)tabbar {
    [WWTabBarConfig shared].tabBarCount = 5;
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav1 title:@"发现" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav2 title:@"我的1" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
    [tabbar addCenterController:[ViewController2 new] bulge:YES title:@"发布" imageName:@"post_normal" selectedImageName:@"post_normal"];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav3 title:@"我的2" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [tabbar addChildController:nav4 title:@"我的3" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
}

@end

