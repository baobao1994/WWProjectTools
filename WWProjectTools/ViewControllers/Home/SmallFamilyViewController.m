//
//  SmallFamilyViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "SmallFamilyViewController.h"
#import <FSCalendar/FSCalendar.h>
#import <EventKit/EventKit.h>
#import "RHDeviceAuthTool.h"

#define KDay (3600 * 24)
#define KMonth (KDay * 30)
#define KYear (KMonth * 12)

//https://www.jianshu.com/p/3d20a63107c1 学习日历的其它显示
//https://www.jianshu.com/p/6f1592260d35 日历事件设定
//https://www.jianshu.com/p/b2e330b60104 日历外观定制

@interface SmallFamilyViewController () <FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *chineseCalendar;//显示中国地区
@property (strong, nonatomic) NSArray<NSString *> *lunarChars;//农历日历
@property (strong, nonatomic) NSArray<EKEvent *> *events;//事件

@end

@implementation SmallFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
}

- (void)setUp {
    //NSCalendarIdentifierGregorian 公历
    //NSCalendarIdentifierChinese 农历
    self.chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    self.chineseCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    self.lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
    self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase;
    self.calendar.appearance.headerDateFormat = @"yyyy年MM月";
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0;
    kWeakSelf;
    [RHDeviceAuthTool calendarAuth:^{
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if(granted) {
                NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-2 * KYear];// 开始日期
                NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:2 * KYear];// 截止日期
                NSPredicate *fetchCalendarEvents = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
                NSArray<EKEvent *> *eventList = [eventStore eventsMatchingPredicate:fetchCalendarEvents];
                NSArray<EKEvent *> *events = [eventList filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable event, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return event.calendar.subscribed;
                }]];
                weakSelf.events = events;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.calendar reloadData];
                });
            }
        }];
    }];
}

//显示副标题
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    EKEvent *event = [self eventsForDate:date].firstObject;
    if (event) {
        return event.title; // 春分、秋分、儿童节、植树节、国庆节、圣诞节...
    }
    NSInteger day = [_chineseCalendar component:NSCalendarUnitDay fromDate:date];
    return _lunarChars[day-1]; // 初一、初二、初三...
}

// 某个日期的所有事件
- (NSArray<EKEvent *> *)eventsForDate:(NSDate *)date {
    NSArray<EKEvent *> *filteredEvents = [self.events filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EKEvent * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject.occurrenceDate isEqualToDate:date];
    }]];
    return filteredEvents;
}

//显示事件圆点 最多3个圆点
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    return events.count;
}

//显示事件圆点自定义图片
//- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
//    
//}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20 08:24:04
}

- (void)goBackToday {
    [_calendar setCurrentPage:[NSDate date] animated:YES];
}

@end
