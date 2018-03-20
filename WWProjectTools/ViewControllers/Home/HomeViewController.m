//
//  HomeViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomSegmentedControlView.h"
#import "SmallFamilyViewController.h"
#import "MotherViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) CustomSegmentedControlView *customSegmentView;
@property (nonatomic, strong) SmallFamilyViewController *smallFamilyVC;
@property (nonatomic, strong) MotherViewController *motherVC;
@property (nonatomic,copy) void (^pushViewControllerBlock)(UIViewController *);

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
}

- (void)setUp {
    self.customSegmentView = [[CustomSegmentedControlView alloc] initWithFrame:CGRectMake(0, 0, 105 * UIScreenScale * 2, 35)];
    self.customSegmentView.count = 2;
    self.customSegmentView.cornerRadius = 13;
    self.customSegmentView.borderWidth = 1;
    [self.customSegmentView initWithDataArr:@[@"小窝",@"宝妈"]];
    kWeakSelf;
    self.customSegmentView.didChangeSelect = ^(NSInteger current) {
        weakSelf.smallFamilyVC.view.hidden = (current == 0)? NO:YES;
        weakSelf.motherVC.view.hidden  = (current == 1)? NO:YES;
    };
    self.navigationItem.titleView = self.customSegmentView;
    [self.view addSubview:self.smallFamilyVC.view];
    [self.view addSubview:self.motherVC.view];
    void (^pushViewControllerBlock)(UIViewController *) = ^(UIViewController *controller) {
        [weakSelf.navigationController pushViewController:controller animated:YES];
    };
    self.smallFamilyVC.pushViewControllerBlock = pushViewControllerBlock;
    self.motherVC.pushViewControllerBlock = pushViewControllerBlock;
}

- (SmallFamilyViewController *)smallFamilyVC {
    if (!_smallFamilyVC) {
        _smallFamilyVC = [[SmallFamilyViewController alloc] init];
        _smallFamilyVC.view.frame = CGRectMake(0, 64, UIScreenWidth, [UIScreen mainScreen].bounds.size.height);
        _smallFamilyVC.view.backgroundColor = RandomColor;
    }
    return _smallFamilyVC;
}

- (MotherViewController *)motherVC {
    if (!_motherVC) {
        _motherVC = [[MotherViewController alloc] init];
        _motherVC.view.frame = CGRectMake(0, 64, UIScreenWidth, UIScreenHeight - 64 - 44);
        _motherVC.view.hidden = YES;
    }
    return _motherVC;
}

@end