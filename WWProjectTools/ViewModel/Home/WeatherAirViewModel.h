//
//  WeatherAirViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherBasicViewModel.h"

@class WeatherAirModel;

@interface WeatherAirViewModel : WeatherBasicViewModel

@property (nonatomic, strong) WeatherAirModel *weatherAirModel;
@property (nonatomic, strong) RACCommand *requestWeatherAirCommand;
@property (nonatomic, assign) BOOL air_data_statu;

@end
