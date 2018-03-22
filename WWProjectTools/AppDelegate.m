//
//  AppDelegate.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "AppDelegate.h"
#import "BabyViewController.h"
#import "HomeViewController.h"
#import "TabBarController.h"
#import "WWTabBarConfig.h"
#import "WWNavigationController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()

@property (nonatomic, strong) WWTabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bmob registerWithAppKey:BmobKey];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside =YES;//控制点击背景是否收起键盘
    [IQKeyboardManager sharedManager].toolbarManageBehaviour =IQAutoToolbarByTag;
//    [self migrationRealm];
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
        [self style1:_tabBarController];
    }
    
    return _tabBarController;
}

- (void)replaceTabbar {
    WWTabBarController * tabbar = [[TabBarController alloc]init];
//    [self style5:tabbar];换个样式
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
    WWNavigationController *nav1 = [[WWNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    [tabbar addChildController:nav1 title:@"小窝" imageName:@"Btn01" selectedImageName:@"SelectBtn01"];
    [tabbar addCenterController:nil bulge:YES title:@"发布点滴" imageName:@"post_normal" selectedImageName:@"post_animate_add"];
    WWNavigationController *nav2 = [[WWNavigationController alloc] initWithRootViewController:[BabyViewController new]];
    [tabbar addChildController:nav2 title:@"小宝" imageName:@"Btn02" selectedImageName:@"SelectBtn02"];
}

//数据库realm配置

- (void)migrationRealm{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = kDBVersion;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t  oldSchemaVersion) {
        // The enumerateObjects:block: method iterates
        // over every 'Person' object stored in the Realm file
//        [migration enumerateObjects:RHDBSchoolInfo.className
//                              block:^(RLMObject *oldObject, RLMObject *newObject) {
//                                  if (oldSchemaVersion < kDBVersion) {
//                                      newObject[@"domainWeb"] = @"";
//                                  }
//                              }];
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

@end

