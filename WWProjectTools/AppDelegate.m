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
#import <UserNotifications/UserNotifications.h>

//https://blog.csdn.net/u011146511/article/details/51226879 本地推送学习资料

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) WWTabBarController *tabBarController;
@property (nonatomic, assign) BOOL isWillEnterForground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _isWillEnterForground = false;
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self resignNotificationCenter];
    
    //添加3DTouch
    //也可以在plist添加静态的
    //https://www.jianshu.com/p/d472c6350a1a
    
//    NSMutableArray *arrShortcutItem = (NSMutableArray *)[UIApplication sharedApplication].shortcutItems;
//    
//    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"smallFamily.ww.openSearch" localizedTitle:@"搜索" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem1];
//    
//    UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"smallFamily.ww.openCompose" localizedTitle:@"新消息" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose] userInfo:nil];
//    [arrShortcutItem addObject:shoreItem2];
//    
//    [UIApplication sharedApplication].shortcutItems = arrShortcutItem;
    
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    //不管APP在后台还是进程被杀死，只要通过主屏快捷操作进来的，都会调用这个方法
    NSLog(@"name:%@\ntype:%@", shortcutItem.localizedTitle, shortcutItem.type);
}

- (void)resignNotificationCenter {
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
}

// 处理完成后调用 completionHandler ，用于指示在前台显示通知的形式
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [self showNotificationAlert:notification.request.content];
    completionHandler(UNNotificationPresentationOptionSound);
}

//后台
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    [self showNotificationAlert:response.notification.request.content];
    completionHandler();
}

- (void)showNotificationAlert:(UNNotificationContent *)notificationContent {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"知道了" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:notificationContent.title message:notificationContent.body preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController showWithAnimated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    _isWillEnterForground = true;
    if (_resignActiveBlock != nil) {
        _resignActiveBlock();
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    _isWillEnterForground = false;
    if (_enterForegroundBlock != nil) {
        _enterForegroundBlock();
    }
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

