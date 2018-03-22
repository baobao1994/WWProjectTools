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
@property (nonatomic, strong) UILabel *topicLabel;
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
    self.moodArr = [[NSMutableArray alloc] init];
    self.publicTimeArr = [[NSMutableArray alloc] init];
    _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.piePatternType = kPieChartPatternTypeCircle;
    self.pieChart.isShadow = NO;
    [self.view addSubview:self.pieChart];
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, TOPIC_HEIGHT)];
    self.topicLabel.font = [UIFont boldSystemFontOfSize:18.f];
    self.topicLabel.textAlignment = NSTextAlignmentCenter;
    self.topicLabel.text = @"近30天心情状态";
    [self.view addSubview:self.topicLabel];
}

- (void)strokePath {
    [self.pieChart strokePath];
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return self.moodArr;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1)];
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    NSLog(@"第%ld个",(long)index);
    NSString *tip = @"";
    switch (index) {
        case 0:
            tip = @"非常好";
            break;
        case 1:
            tip = @"很好";
            break;
        case 2:
            tip = @"一般";
            break;
        case 3:
            tip = @"差";
            break;
        default:
            break;
    }
    [WWHUD showWithText:tip inView:SelfViewControllerView afterDelay:1];
}

- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart{
    return 0.f;
}

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return 120.f;
}

@end
