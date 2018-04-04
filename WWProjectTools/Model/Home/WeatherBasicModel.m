//
//  WeatherBasicModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherBasicModel.h"

@implementation WeatherBasicModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"daily_forecast" : @"WDailyForecast",
             @"hourly" : @"WHourly",
             @"lifestyle" : @"WLifestyle"
             };
}

@end

@implementation WBasic

@end

@implementation WUpdate

@end

@implementation WNow

@end

@implementation WDailyForecast

@end

@implementation WHourly

@end

@implementation WLifestyle

@end
