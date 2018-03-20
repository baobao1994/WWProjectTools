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
    __weak typeof (self) weakSelf = self;
    //解决因为自定义导航栏按钮,滑动返回失效的问题
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    // Do any additional setup after loading the view.
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
        [button setTitleColor:UIColorFromHexColor(0x1AA0F8) forState:UIControlStateNormal];
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
