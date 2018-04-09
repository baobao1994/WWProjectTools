//
//  WeatherView.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/3.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherView.h"
#import "WeatherBasicViewModel.h"
#import "WeatherAirViewModel.h"
#import "ZFChart.h"
#import "WeatherCollectionViewCell.h"
#import "WWLocation.h"
#import <AddressBookUI/AddressBookUI.h>

#define kTopMargin (25)
#define kChartHeight ((self.tempframe.size.height - kTopMargin) / 3.0 * 2 - 50)

@interface WeatherView ()<ZFGenericChartDataSource, ZFLineChartDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) WeatherAirViewModel *weatherViewModel;
@property (nonatomic, assign) CGRect tempframe;
@property (nonatomic, strong) ZFLineChart * lineChart;
@property (nonatomic, strong) NSMutableArray *weightArr;
@property (nonatomic, strong) NSMutableArray *publicTimeArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *reFreshButton;
@property (nonatomic, strong) WWLocation *location;

@end

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil] firstObject];
        self.tempframe = frame;
        [self setUp];
        [self bind];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    self.frame = self.tempframe;
}

- (void)setUp{
    self.location = [WWLocation locationManager];
    self.weatherViewModel = [[WeatherAirViewModel alloc] init];
    self.weightArr = [[NSMutableArray alloc] init];
    self.publicTimeArr = [[NSMutableArray alloc] init];
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(-60, (self.tempframe.size.height - kChartHeight) / 2 - 10, UIScreenWidth + 60, kChartHeight)];
    self.lineChart.backgroundColor = [UIColor clearColor];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.linePatternType = kLinePatternTypeCurve;
    self.lineChart.topicLabel.text = @"";
    self.lineChart.valueCenterToCircleCenterPadding = 10.0f;
    self.lineChart.xAxisColor = [UIColor clearColor];
    self.lineChart.yAxisColor = [UIColor clearColor];
    self.lineChart.axisLineNameColor = [UIColor clearColor];
    self.lineChart.axisLineValueColor = [UIColor clearColor];
    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    self.lineChart.isResetAxisLineMinValue = YES;
    self.lineChart.isShadow = NO;
    self.lineChart.isShowXLineSeparate = NO;
    self.lineChart.isShowYLineSeparate = NO;
    self.lineChart.isShowAxisArrows = NO;
    self.lineChart.isShadowForValueLabel = NO;
    [self addSubview:self.lineChart];
    [self strokePath];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WeatherCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([WeatherCollectionViewCell class])];
}

- (void)strokePath {
    [self.lineChart strokePath];
}

- (void)bind {
    kWeakSelf;
    [[self.weatherViewModel.requestWeatherBasicCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf strokePath];
                [weakSelf.collectionView reloadData];
            });
        }];
    }];
    
    [self.weatherViewModel.requestWeatherBasicCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD showLoadingWithErrorInView:KeyWindow afterDelay:2];
    }];
    
    [[self.weatherViewModel.requestWeatherAirCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        }];
    }];
    
    [self.weatherViewModel.requestWeatherAirCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD showLoadingWithErrorInView:KeyWindow afterDelay:2];
    }];
    
    [[self.reFreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf getCurentLocation];
    }];
    [self getCurentLocation];
}

- (void)getCurentLocation {
    kWeakSelf;
    [self.location getCurrentLocation:^(CLLocation *location, CLPlacemark *placemark, NSString *error) {
        if (placemark) {
            weakSelf.weatherViewModel.latitude = location.coordinate.latitude;
            weakSelf.weatherViewModel.longitude = location.coordinate.longitude;
            weakSelf.addressLabel.text = [NSString stringWithFormat:@"%@%@ %@",[placemark.addressDictionary objectForKey:@"City"],placemark.subLocality,placemark.thoroughfare];
            [weakSelf loadWeather];
        } else {
            weakSelf.addressLabel.text = @"现在处于外太空中...";
        }
    }];
}

- (void)loadWeather {
    [[self.weatherViewModel requestWeatherBasicCommand] execute:nil];
//    [[self.weatherViewModel requestWeatherAirCommand] execute:nil];
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    NSMutableArray *hightArr = [[NSMutableArray alloc] init];
    NSMutableArray *lowArr = [[NSMutableArray alloc] init];
    for (WDailyForecast *dailyForecast in self.weatherViewModel.weatherModel.daily_forecast) {
        [hightArr addObject:[NSString stringWithFormat:@"%@°",dailyForecast.tmp_max]];
        [lowArr addObject:[NSString stringWithFormat:@"%@°",dailyForecast.tmp_min]];
    }
    return @[hightArr,lowArr];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSInteger count = self.weatherViewModel.weatherModel.daily_forecast.count;
    for (int i = 0; i < count; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return arr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[UIColorFromHexColor(0XFFCF00),UIColorFromHexColor(0X77C0E0)];
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 5;
}

#pragma mark - ZFLineChartDelegate

- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart {
    return 50.0f;
}

- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart {
    return 2.0f;
}

- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart {
    return 1.0f;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.lineChart strokePath];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //设置CollectionView的属性
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopMargin, self.tempframe.size.width, self.tempframe.size.height - kTopMargin) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
        [self addSubview:self.collectionView];
        [self bringSubviewToFront:self.collectionView];
    }
    return _collectionView;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.weatherViewModel.weatherModel.daily_forecast.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WeatherCollectionViewCell class]) forIndexPath:indexPath];
    [cell setContentWithDailyForeCast:self.weatherViewModel.weatherModel.daily_forecast[row]];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, self.tempframe.size.height - kTopMargin);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSLog(@"row = %ld",row);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.lineChart.genericAxis setContentOffset:scrollView.contentOffset animated:NO];
}

@end
