//
//  WeatherBasicViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/3.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WeatherBasicModel;

@interface WeatherBasicViewModel : NSObject

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, strong) WeatherBasicModel *weatherModel;
@property (nonatomic, strong) RACCommand *requestWeatherBasicCommand;
@property (nonatomic, assign) BOOL basic_data_statu;

@end
