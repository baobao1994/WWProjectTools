//
//  VariousIndicatorsViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "VariousIndicatorsViewController.h"
#import "CustomSegmentedControlView.h"
#import "WeightIndicatorViewController.h"
#import "MoodIndicatorsViewController.h"
#import "PhysicalStateIndicatorsViewController.h"

@interface VariousIndicatorsViewController ()

@property (nonatomic, strong) CustomSegmentedControlView *customSegmentView;
@property (nonatomic, strong) WeightIndicatorViewController *weightIndicatorVC;
@property (nonatomic, strong) MoodIndicatorsViewController *moodIndicatorsVC;
@property (nonatomic, strong) PhysicalStateIndicatorsViewController *physicalStateIndicatorsVC;

@end

@implementation VariousIndicatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    self.customSegmentView = [[CustomSegmentedControlView alloc] initWithFrame:CGRectMake(0, 0, 70 * UIScreenScale * 3, 35)];
    self.customSegmentView.count = 3;
    self.customSegmentView.cornerRadius = 13;
    self.customSegmentView.borderWidth = 1;
    [self.customSegmentView initWithDataArr:@[@"体重状态",@"心情状态",@"身体状态"]];
    kWeakSelf;
    self.customSegmentView.didChangeSelect = ^(NSInteger current) {
        if (current == 0) {
            weakSelf.weightIndicatorVC.view.hidden = NO;
            weakSelf.moodIndicatorsVC.view.hidden = YES;
            weakSelf.physicalStateIndicatorsVC.view.hidden = YES;
        } else if (current == 1) {
            weakSelf.weightIndicatorVC.view.hidden = YES;
            weakSelf.moodIndicatorsVC.view.hidden = NO;
            weakSelf.physicalStateIndicatorsVC.view.hidden = YES;
        } else {
            weakSelf.weightIndicatorVC.view.hidden = YES;
            weakSelf.moodIndicatorsVC.view.hidden = YES;
            weakSelf.physicalStateIndicatorsVC.view.hidden = NO;
        }
    };
    self.navigationItem.titleView = self.customSegmentView;
    [self.view addSubview:self.weightIndicatorVC.view];
    [self.view addSubview:self.moodIndicatorsVC.view];
    [self.view addSubview:self.physicalStateIndicatorsVC.view];
}

- (WeightIndicatorViewController *)weightIndicatorVC {
    if (!_weightIndicatorVC) {
        _weightIndicatorVC = [[WeightIndicatorViewController alloc] init];
        _weightIndicatorVC.view.frame = CGRectMake(0, 64, UIScreenWidth, [UIScreen mainScreen].bounds.size.height);
        _weightIndicatorVC.view.backgroundColor = RandomColor;
        _weightIndicatorVC.view.hidden = NO;
    }
    return _weightIndicatorVC;
}

- (MoodIndicatorsViewController *)moodIndicatorsVC {
    if (!_moodIndicatorsVC) {
        _moodIndicatorsVC = [[MoodIndicatorsViewController alloc] init];
        _moodIndicatorsVC.view.frame = CGRectMake(0, 64, UIScreenWidth, [UIScreen mainScreen].bounds.size.height);
        _moodIndicatorsVC.view.backgroundColor = RandomColor;
        _moodIndicatorsVC.view.hidden = YES;
    }
    return _moodIndicatorsVC;
}

- (PhysicalStateIndicatorsViewController *)physicalStateIndicatorsVC {
    if (!_physicalStateIndicatorsVC) {
        _physicalStateIndicatorsVC = [[PhysicalStateIndicatorsViewController alloc] init];
        _physicalStateIndicatorsVC.view.frame = CGRectMake(0, 64, UIScreenWidth, [UIScreen mainScreen].bounds.size.height);
        _physicalStateIndicatorsVC.view.backgroundColor = RandomColor;
        _physicalStateIndicatorsVC.view.hidden = YES;
    }
    return _physicalStateIndicatorsVC;
}

@end
