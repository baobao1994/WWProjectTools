//
//  WeatherBasicModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBasic;
@class WUpdate;
@class WNow;
@class WDailyForecast;
@class WHourly;
@class WLifestyle;

@interface WeatherBasicModel : NSObject

@property (nonatomic, strong) WBasic *basic;
@property (nonatomic, strong) WUpdate *update;
@property (nonatomic, strong) WNow *now;
@property (nonatomic, strong) NSMutableArray *daily_forecast;
@property (nonatomic, strong) NSMutableArray *hourly;
@property (nonatomic, strong) NSMutableArray *lifestyle;
@property (nonatomic, copy) NSString *status;

@end

/**
 基础信息
 */
@interface WBasic : NSObject

@property (nonatomic, copy) NSString *admin_area;//该地区／城市所属行政区域
@property (nonatomic, copy) NSString *cid;//地区／城市ID
@property (nonatomic, copy) NSString *cnty;//该地区／城市所属国家名称
@property (nonatomic, copy) NSString *lat;//地区／城市经度
@property (nonatomic, copy) NSString *location;//地区／城市名称
@property (nonatomic, copy) NSString *lon;//地区／城市纬度
@property (nonatomic, copy) NSString *parent_city;//该地区／城市的上级城市
@property (nonatomic, copy) NSString *tz;//该地区／城市所在时区

@end

/**
 接口更新时间
 */
@interface WUpdate : NSObject

@property (nonatomic, copy) NSString *loc;//当地时间，24小时制，格式yyyy-MM-dd HH:mm
@property (nonatomic, copy) NSString *utc;//UTC时间，24小时制，格式yyyy-MM-dd HH:mm

@end

/**
 实况天气
 */
@interface WNow : NSObject

@property (nonatomic, copy) NSString *cloud;//云量
@property (nonatomic, copy) NSString *cond_code;//实况天气状况代码
@property (nonatomic, copy) NSString *cond_txt;//实况天气状况代码
@property (nonatomic, copy) NSString *fl;//体感温度，默认单位：摄氏度
@property (nonatomic, copy) NSString *hum;//相对湿度
@property (nonatomic, copy) NSString *pcpn;//降水量
@property (nonatomic, copy) NSString *pres;//大气压强
@property (nonatomic, copy) NSString *tmp;//温度，默认单位：摄氏度
@property (nonatomic, copy) NSString *vis;//能见度，默认单位：公里
@property (nonatomic, copy) NSString *wind_deg;//风向360角度
@property (nonatomic, copy) NSString *wind_dir;//风向
@property (nonatomic, copy) NSString *wind_sc;//风力
@property (nonatomic, copy) NSString *wind_spd;//风速，公里/小时

@end

/**
 天气预报
 */
@interface WDailyForecast : NSObject

@property (nonatomic, copy) NSString *cond_code_d;//白天天气状况代码
@property (nonatomic, copy) NSString *cond_code_n;//晚间天气状况代码
@property (nonatomic, copy) NSString *cond_txt_d;//白天天气状况描述
@property (nonatomic, copy) NSString *cond_txt_n;//晚间天气状况描述
@property (nonatomic, copy) NSString *date;//预报日期
@property (nonatomic, copy) NSString *mr;//月升时间
@property (nonatomic, copy) NSString *ms;//月落时间
@property (nonatomic, copy) NSString *hum;//相对湿度
@property (nonatomic, copy) NSString *pcpn;//降水量
@property (nonatomic, copy) NSString *pop;//降水概率
@property (nonatomic, copy) NSString *pres;//大气压强
@property (nonatomic, copy) NSString *sr;//日出时间
@property (nonatomic, copy) NSString *ss;//日落时间
@property (nonatomic, copy) NSString *tmp_max;//最高温度
@property (nonatomic, copy) NSString *tmp_min;//最低温度
@property (nonatomic, copy) NSString *uv_index;//紫外线强度指数
@property (nonatomic, copy) NSString *vis;//能见度，单位：公里
@property (nonatomic, copy) NSString *wind_deg;//风向360角度
@property (nonatomic, copy) NSString *wind_dir;//风向
@property (nonatomic, copy) NSString *wind_sc;//风力
@property (nonatomic, copy) NSString *wind_spd;//风速，公里/小时

@end

/**
  逐小时预报
 */
@interface WHourly : NSObject

@property (nonatomic, copy) NSString *cloud;//云量
@property (nonatomic, copy) NSString *cond_code;//天气状况代码
@property (nonatomic, copy) NSString *cond_txt;//天气状况代码
@property (nonatomic, copy) NSString *dew;//露点温度
@property (nonatomic, copy) NSString *hum;//相对湿度
@property (nonatomic, copy) NSString *pop;//降水概率
@property (nonatomic, copy) NSString *pres;//大气压强
@property (nonatomic, copy) NSString *time;//预报时间，格式yyyy-MM-dd hh:mm
@property (nonatomic, copy) NSString *tmp;//温度
@property (nonatomic, copy) NSString *wind_deg;//风向360角度
@property (nonatomic, copy) NSString *wind_dir;//风向
@property (nonatomic, copy) NSString *wind_sc;//风力
@property (nonatomic, copy) NSString *wind_spd;//风速，公里/小时

@end

/**
 生活指数
 */
@interface WLifestyle : NSObject

@property (nonatomic, copy) NSString *brf;//生活指数简介
@property (nonatomic, copy) NSString *txt;//生活指数详细描述
@property (nonatomic, copy) NSString *type;//生活指数类型
/*
 生活指数类型 comf：舒适度指数、cw：洗车指数、drsg：穿衣指数、flu：感冒指数、sport：运动指数、trav：旅游指数、uv：紫外线指数、air：空气污染扩散条件指数、ac：空调开启指数、ag：过敏指数、gl：太阳镜指数、mu：化妆指数、airc：晾晒指数、ptfc：交通指数、fisin：钓鱼指数、spi：防晒指数
 */

@end

