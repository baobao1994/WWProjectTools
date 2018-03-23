//
//  WWNavigationController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWNavigationController.h"
#import "RxWebViewController.h"
#import "UIButton+Addition.h"

@interface WWNavigationController ()<UINavigationBarDelegate,UIGestureRecognizerDelegate>

/**
 *  由于 popViewController 会触发 shouldPopItems，因此用该布尔值记录是否应该正确 popItems
 */
@property BOOL shouldPopItemAfterPopViewController;

@end

@implementation WWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldPopItemAfterPopViewController = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航条透明度
    self.navigationController.navigationBar.translucent = NO;//不透明
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    //图标颜色为黑色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    //导航栏背景颜色
    [self.navigationBar setBarTintColor:UIColorMake(249, 204, 226)];
    //导航栏title颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //导航条下面的黑线
    self.navigationBar.clipsToBounds = NO;
    //刷新状态栏背景颜色
     [self setNeedsStatusBarAppearanceUpdate];
    //设置状态栏颜色
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

//一定要在viewWillDisappear里面写，如果写在viewDidDisappear里面会出问题！！！！
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //为了不影响其他页面在viewDidDisappear做以下设置
    self.navigationBar.translucent = YES;//透明
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    NSLog(@"statusBar.backgroundColor--->%@",statusBar.backgroundColor);
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    if (self.navigationBarHidden) {
        self.navigationBarHidden = NO;
    }
    return [super popViewControllerAnimated:animated];
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    if (self.navigationBarHidden) {
        self.navigationBarHidden = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.shouldPopItemAfterPopViewController = YES;
    if (self.navigationBarHidden) {
        self.navigationBarHidden = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}
-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    
    //! 如果应该pop，说明是在 popViewController 之后，应该直接 popItems
    if (self.shouldPopItemAfterPopViewController) {
        self.shouldPopItemAfterPopViewController = NO;
        
        if ([self.topViewController isKindOfClass:[RxWebViewController class]]) {
            RxWebViewController* webVC = (RxWebViewController*)self.viewControllers.lastObject;
            if (!webVC.webView.canGoBack) {
                [self popViewControllerAnimated:YES];
            }
        } else {
            if([self.viewControllers count] < [navigationBar.items count]) {
                return YES;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self popViewControllerAnimated:YES];
                });
                return NO;
            }
        }
        
        return YES;
    }
    
    //! 如果不应该 pop，说明是点击了导航栏的返回，这时候则要做出判断区分是不是在 webview 中
    if ([self.topViewController isKindOfClass:[RxWebViewController class]]) {
        RxWebViewController* webVC = (RxWebViewController*)self.viewControllers.lastObject;
        if (webVC.webView.canGoBack) {
            [webVC.webView goBack];
            
            //!make sure the back indicator view alpha back to 1
            self.shouldPopItemAfterPopViewController = NO;
            [[self.navigationBar subviews] lastObject].alpha = 1;
            return NO;
        }else{
            [self popViewControllerAnimated:YES];
            return NO;
        }
    }else{
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

/**
 * 可以在这个方法中拦截所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@" 返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        button.size = CGSizeMake(80, 30);
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 让按钮的内容往左边偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        // 更简单的处理方式：
        // [button sizeToFit]; // 让按钮的尺寸跟随内容而变化
        
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end

