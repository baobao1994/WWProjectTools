//
//  WeatherViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/3.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherViewModel : NSObject

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, strong) RACCommand *requestWeatherCommand;

@end
