//
//  NSDate+Addition.m
//  TigerLottery
//
//  Created by Legolas on 14/12/10.
//  Copyright (c) 2014年 adcocoa. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

- (NSString *)weekDay {
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    NSInteger weekday = [components weekday];
    NSDictionary *weekdayDic = @{@(1) : @"周日",
                                 @(2) : @"周一",
                                 @(3) : @"周二",
                                 @(4) : @"周三",
                                 @(5) : @"周四",
                                 @(6) : @"周五",
                                 @(7) : @"周六"};
    return [weekdayDic objectForKey:@(weekday)];
}

- (NSString *)formateDate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSString *date = [dateFormatter stringFromDate:self];
    return date;
}

- (NSString *)timeIntervalFromTime:(NSString *)time {
    //当前时间
    NSDate *currDate = [NSDate date];
    NSInteger currTimeInterval = [currDate timeIntervalSince1970];
    //时间间隔
    NSInteger lastTime = time.longLongValue;
    NSInteger intevalTime = currTimeInterval - lastTime;
    
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger minutes = intevalTime / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
    NSString *timeStr = nil;
    if (intevalTime <= 59) {
        timeStr = @"刚刚";
    }else if (minutes <= 59){
        timeStr = [NSString stringWithFormat:@"%ld分钟前",minutes];
    }else if (hours < 24){
        timeStr = [NSString stringWithFormat:@"%ld小时前",hours];
    }else if (day < 2){
        timeStr = @"昨天";
    }else {
        timeStr = [lastDate formateDate:@"yyyy/MM/dd"];
    }
    return timeStr;
}

- (NSString *)setTimeInterval:(NSString *)timeInterval formateDate:(NSString *)formate {
    NSTimeInterval interval = [timeInterval longLongValue];
    NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
    NSString *changedStr = [currentDate formateDate:formate];
    return changedStr;
}

+ (NSString *)cTimestampFromString:(NSString *)time {
    //theTime __@"%04d-%02d-%02d %02d:%02d:00"
    //装换为时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"-MM-dd"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    //        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    //        [formatter setTimeZone:timeZone];
    NSDate* dateTodo = [formatter dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSString *)getMonthBeginAndEndWithDate:(NSDate *)date {
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //    [calendar setFirstWeekday:2];//设定周一为周首日 默认设定周日为首日1
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *dateBounce = [NSString stringWithFormat:@"%@,%@",beginString,endString];
    return dateBounce;
}

+ (NSString *)getMonthBeginAndEndWithDateStr:(NSString *)dateStr {
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *newDate=[format dateFromString:dateStr];
    return [self getMonthBeginAndEndWithDate:newDate];
}

/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */

- (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([self compare:start] == NSOrderedDescending && [self compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

//计算任意2个时间的之间的间隔
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime {
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

+ (NSDateComponents *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2 {
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    return cmps;
}

@end
