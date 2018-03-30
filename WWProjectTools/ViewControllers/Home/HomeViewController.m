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
#import "UIViewController+Addition.h"

@interface HomeViewController ()

@property (nonatomic, strong) CustomSegmentedControlView *customSegmentView;
@property (nonatomic, strong) SmallFamilyViewController *smallFamilyVC;
@property (nonatomic, strong) MotherViewController *motherVC;
@property (nonatomic,copy) void (^pushViewControllerBlock)(UIViewController *);

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationLeftItemWithTitle:@"今日"];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.motherVC viewWillAppear:animated];
}

- (void)selectedNavigationLeftItem:(id)sender {
    [self.smallFamilyVC goBackToday];
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
        if (current == 0) {
            [weakSelf createNavigationLeftItemWithTitle:@"今日"];
        } else {
            weakSelf.navigationItem.leftBarButtonItem = nil;
        }
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
        _smallFamilyVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        _smallFamilyVC.view.backgroundColor = RandomColor;
    }
    return _smallFamilyVC;
}

- (MotherViewController *)motherVC {
    if (!_motherVC) {
        _motherVC = [[MotherViewController alloc] init];
        _motherVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
        _motherVC.view.hidden = YES;
    }
    return _motherVC;
}

@end
