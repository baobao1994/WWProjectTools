//
//  PhysicalStateIndicatorsViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "PhysicalStateIndicatorsViewController.h"
#import "ZFChart.h"

@interface PhysicalStateIndicatorsViewController ()<ZFGenericChartDataSource, ZFBarChartDelegate>

@property (nonatomic, strong) ZFBarChart * barChart;
@property (nonatomic, assign) CGFloat height;

@end

@implementation PhysicalStateIndicatorsViewController

/**
 身体状态：0 无异样 [1 腰酸 2 头痛 3 感冒 4 发烧 5 其它]
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp{
    _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    self.physicalStateArr = [[NSMutableArray alloc] init];
    self.publicTimeArr = [[NSMutableArray alloc] init];
    self.barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _height)];
    self.barChart.dataSource = self;
    self.barChart.delegate = self;
    self.barChart.topicLabel.text = @"近30天身体状态";
    self.barChart.unit = @"人";
    self.barChart.isShowYLineSeparate = YES;
    self.barChart.isShowXLineSeparate = YES;
    self.barChart.valueType = kValueTypeDecimal;
    self.barChart.numberOfDecimal = 2;
    [self.view addSubview:self.barChart];
}

- (void)strokePath {
    [self.barChart strokePath];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return self.physicalStateArr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return self.publicTimeArr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFColor(71, 204, 255, 1)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
    return 0;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 30;
}

#pragma mark - ZFBarChartDelegate

- (id)valueTextColorArrayInBarChart:(ZFBarChart *)barChart{
    return ZFBlue;
    //    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(16, 140, 39, 1)];
}

- (NSArray<ZFGradientAttribute *> *)gradientColorArrayInBarChart:(ZFBarChart *)barChart{
    //该组第1个bar渐变色
    ZFGradientAttribute * gradientAttribute1 = [[ZFGradientAttribute alloc] init];
    gradientAttribute1.colors = @[(id)ZFColor(71, 204, 255, 1).CGColor, (id)ZFWhite.CGColor];
    gradientAttribute1.locations = @[@(0.5), @(0.99)];
    gradientAttribute1.startPoint = CGPointMake(0, 0.5);
    gradientAttribute1.endPoint = CGPointMake(1, 0.5);
    
    //该组第2个bar渐变色
    ZFGradientAttribute * gradientAttribute2 = [[ZFGradientAttribute alloc] init];
    gradientAttribute2.colors = @[(id)ZFGold.CGColor, (id)ZFWhite.CGColor];
    gradientAttribute2.locations = @[@(0.5), @(0.99)];
    gradientAttribute2.startPoint = CGPointMake(0, 0.5);
    gradientAttribute2.endPoint = CGPointMake(1, 0.5);
    
    //该组第3个bar渐变色
    ZFGradientAttribute * gradientAttribute3 = [[ZFGradientAttribute alloc] init];
    gradientAttribute3.colors = @[(id)ZFColor(16, 140, 39, 1).CGColor, (id)ZFWhite.CGColor];
    gradientAttribute3.locations = @[@(0.5), @(0.99)];
    gradientAttribute3.startPoint = CGPointMake(0, 0.5);
    gradientAttribute3.endPoint = CGPointMake(1, 0.5);
    
    return [NSArray arrayWithObjects:gradientAttribute1/*, gradientAttribute2, gradientAttribute3*/, nil];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    //特殊说明，因传入数据是3个subArray(代表3个类型)，每个subArray存的是6个元素(代表每个类型存了1~6年级的数据),所以这里的groupIndex是第几个subArray(类型)
    //eg：三年级第0个元素为 groupIndex为0，barIndex为2
    NSLog(@"第%ld个颜色中的第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置
    bar.barColor = ZFDeepPink;
    bar.isAnimated = YES;
    bar.opacity = 0.5;
    [bar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
    [WWHUD showWithText:self.noteArr[barIndex] inView:SelfViewControllerView afterDelay:2];
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    //理由同上
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    popoverLabel.textColor = ZFSkyBlue;
    [popoverLabel strokePath];
}

@end
