//
//  PopViewController.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "PopViewController.h"
#import "WWPopTransition.h"
#import "PushViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PopViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) WWPopTransition *popTransition;
@property (nonatomic, strong) PushViewController *pushVC;

@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.avatarImageView];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 400, ScreenWidth - 40, 100)];
    bgView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:bgView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop){ // 就是在这里判断是哪种动画类型
        return self.popTransition; // 返回pop动画的类
    }else{
        return nil;
    }
}

- (WWPopTransition *)popTransition {
    if (_popTransition == nil) {
        _popTransition = [[WWPopTransition alloc] init];
        _popTransition.fromSubView = self.avatarImageView;
        _popTransition.toViewRect = self.toViewRect;
    }
    return _popTransition;
}

- (void)setToViewRect:(CGRect)toViewRect {
    _toViewRect = toViewRect;
    self.popTransition.toViewRect = toViewRect;
}

- (PushViewController *)pushVC {
    if (_pushVC == nil) {
        _pushVC = [[PushViewController alloc] init];
    }
    return _pushVC;
}
- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 10, ScreenWidth - 0, 150)];
        _avatarImageView.image = [UIImage imageNamed:@"ad_bg"];
    }
    return _avatarImageView;
}

@end
