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

@interface WeatherView ()

@property (nonatomic, strong) WeatherAirViewModel *weatherViewModel;
@property (nonatomic, assign) CGRect tempframe;

@end

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:self options:nil] firstObject];
        //        self.frame = frame;
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

- (void)setUp {
    
}

- (void)bind {
    
}

- (void)loadWeather {
//    self.weatherViewModel = [[WeatherAirViewModel alloc] init];
//    [[self.weatherViewModel requestWeatherBasicCommand] execute:nil];
//    [[self.weatherViewModel requestWeatherAirCommand] execute:nil];
}

@end
