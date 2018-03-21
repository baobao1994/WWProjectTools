//
//  WeightIndicatorViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeightIndicatorViewController.h"
#import "ZFChart.h"

@interface WeightIndicatorViewController ()<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;
@property (nonatomic, assign) CGFloat height;

@end

@implementation WeightIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp{
    _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.valueType = kValueTypeDecimal;
    self.lineChart.numberOfDecimal = 2;
    self.lineChart.topicLabel.text = @"近30天体重";
    self.lineChart.unit = @"kg";
    self.lineChart.isShowYLineSeparate = YES;
    self.lineChart.isResetAxisLineMinValue = YES;
    self.lineChart.isShadow = NO;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 20;
    [self.view addSubview:self.lineChart];
    [self.lineChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@[@"50.42", @"51.99", @"52.90", @"45.65", @"56.33", @"62.00", @"53.89"]];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"七年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFMagenta];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 80;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    return 45;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 30;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    
    //可在此处进行circle被点击后的自身部分属性设置,可修改的属性查看ZFCircle.h
    //    circle.circleColor = ZFYellow;
    circle.isAnimated = YES;
    //    circle.opacity = 0.5;
    
    [circle strokePath];
    
    //    可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    popoverLabel.textColor = ZFGold;
    [popoverLabel strokePath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.lineChart strokePath];
}

@end
