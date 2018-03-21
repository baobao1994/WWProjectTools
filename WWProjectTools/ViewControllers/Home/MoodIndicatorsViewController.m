//
//  MoodIndicatorsViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MoodIndicatorsViewController.h"
#import "ZFChart.h"

@interface MoodIndicatorsViewController ()<ZFPieChartDataSource, ZFPieChartDelegate>

@property (nonatomic, strong) ZFPieChart * pieChart;
@property (nonatomic, assign) CGFloat height;

@end


/**
 心情：0 非常好 1 很好 2 一般 3 差
 */
@implementation MoodIndicatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp{
    _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.piePatternType = kPieChartPatternTypeCircle;
    self.pieChart.isShadow = NO;
    [self.pieChart strokePath];
    [self.view addSubview:self.pieChart];
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return @[@"256", @"300", @"283", @"490", @"236"];
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1)];
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    NSLog(@"第%ld个",(long)index);
}

- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart{
    return 0.f;
}

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return 120.f;
}

@end
