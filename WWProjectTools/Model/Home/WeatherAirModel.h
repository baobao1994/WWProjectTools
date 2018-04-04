//
//  WeatherAirModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherBasicModel.h"

@class WAirNowCity;
@class WAirNowStation;

@interface WeatherAirModel : WeatherBasicModel

@property (nonatomic, strong) WAirNowCity *air_now_city;
@property (nonatomic, strong) NSMutableArray *air_now_station;

@end

/**
 AQI城市实况
 */
@interface WAirNowCity : NSObject

@property (nonatomic, copy) NSString *aqi;//空气质量指数，AQI和PM25的关系
@property (nonatomic, copy) NSString *co;//一氧化碳
@property (nonatomic, copy) NSString *main;//主要污染物
@property (nonatomic, copy) NSString *no2;//二氧化氮
@property (nonatomic, copy) NSString *o3;//臭氧
@property (nonatomic, copy) NSString *pm10;//pm10
@property (nonatomic, copy) NSString *pm25;//pm25
@property (nonatomic, copy) NSString *pub_time;//数据发布时间,格式yyyy-MM-dd HH:mm
@property (nonatomic, copy) NSString *qlty;//空气质量，取值范围:优，良，轻度污染，中度污染，重度污染，严重污染，查看计算方式
@property (nonatomic, copy) NSString *so2;//二氧化硫

@end

/**
 AQI站点实况
 */
@interface WAirNowStation : NSObject

@property (nonatomic, copy) NSString *air_sta;//站点名称
@property (nonatomic, copy) NSString *aqi;//空气质量指数，AQI和PM25的关系
@property (nonatomic, copy) NSString *asid;//站点ID，请参考所有站点ID
@property (nonatomic, copy) NSString *co;//一氧化碳
@property (nonatomic, copy) NSString *lat;//站点纬度
@property (nonatomic, copy) NSString *lon;//站点经度
@property (nonatomic, copy) NSString *main;//主要污染物
@property (nonatomic, copy) NSString *no2;//二氧化氮
@property (nonatomic, copy) NSString *o3;//臭氧
@property (nonatomic, copy) NSString *pm10;//pm10
@property (nonatomic, copy) NSString *pm25;//pm25
@property (nonatomic, copy) NSString *pub_time;//数据发布时间,格式yyyy-MM-dd HH:mm
@property (nonatomic, copy) NSString *qlty;//空气质量，取值范围:优，良，轻度污染，中度污染，重度污染，严重污染，查看计算方式
@property (nonatomic, copy) NSString *so2;//二氧化硫

@end
