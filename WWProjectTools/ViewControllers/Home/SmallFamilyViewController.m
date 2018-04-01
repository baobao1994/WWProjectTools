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
#import "EventsViewModel.h"
#import "NSDate+Addition.h"
#import "EventModel.h"
#import "EditEventViewController.h"

#import "UIColor+Wonderful.h"
#import "SXMarquee.h"
#import "SXHeadLine.h"

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
@property (nonatomic, strong) EventsViewModel *eventViewModel;
@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet UIButton *addEventButton;

@end

@implementation SmallFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.calendar.selectedDate) {
        [self reSetScrollLabel:self.calendar.selectedDate];
    }
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
//    [self.calendar selectDate:[NSDate date]];
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.calendar reloadData];
                });
            }
        }];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventNotificationAction:) name:@"EventNotification" object:nil];
}

- (void)EventNotificationAction:(NSNotification *)notification{
    NSLog(@"---接收到通知---");
    [[self.eventViewModel requestEventsCommand] execute:nil];
    [self.calendar deselectDate:self.calendar.selectedDate];
}

- (void)bind {
    kWeakSelf;
    self.eventViewModel = [[EventsViewModel alloc] init];
    [[self.eventViewModel.requestEventsCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.calendar reloadData];
                [weakSelf reSetScrollLabel:nil];
            });
        }];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.eventViewModel.dateTime = [self.calendar.currentPage formateDate:@"yyyy.MM"];
        NSArray *timeArr = [[NSDate getMonthBeginAndEndWithDate:self.calendar.currentPage] componentsSeparatedByString:@"-"];
        self.eventViewModel.beginTime = [[NSDate cTimestampFromString:timeArr[0]] doubleValue];
        self.eventViewModel.endTime = [[NSDate cTimestampFromString:timeArr[1]] doubleValue];
        [[self.eventViewModel requestEventsCommand] execute:nil];
    });
    
    [[self.addEventButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        EditEventViewController *editEventVC = [[EditEventViewController alloc] init];
        editEventVC.publicDate = weakSelf.calendar.selectedDate;
        if (weakSelf.pushViewControllerBlock) {
            weakSelf.pushViewControllerBlock(editEventVC);
        }
    }];
}

- (void)reSetScrollLabel:(NSDate *)seletDate {
    [self.eventView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *monthEventList = [[NSMutableArray alloc] init];
    NSArray *timeArr = [[NSDate getMonthBeginAndEndWithDate:self.calendar.currentPage] componentsSeparatedByString:@","];
    for (EventModel *model in self.eventViewModel.eventList) {
        if ([model.publicTime validateWithStartTime:timeArr[0] withExpireTime:timeArr[1]]) {
            [monthEventList addObject:model];
        }
    }
    if (seletDate || monthEventList.count == 0) {
        NSString *eventString = @"";
        for (EventModel *model in monthEventList) {
            if ([model.publicTime isEqualToDate:seletDate]) {
                eventString = [eventString stringByAppendingString:[NSString stringWithFormat:@"%@ %@",model.publicTimeString,model.content]];
            }
        }
        if (isEmptyString(eventString)) {
            if (monthEventList.count == 0) {
                eventString = @"当月没有事件";
            } else {
                eventString = @"当日没有事件";
            }
        }
        SXMarquee *mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, self.eventView.frame.size.width, self.eventView.frame.size.height) speed:2 Msg:eventString bgColor:[UIColor salmonColor] txtColor:[UIColor whiteColor]];
        [mar changeMarqueeLabelFont:[UIFont systemFontOfSize:26]];
        [mar changeTapMarqueeAction:^{
            [WWHUD showWithText:eventString inView:SelfViewControllerView afterDelay:2];
        }];
        [mar start];
        [self.eventView addSubview:mar];
    } else {
        NSMutableArray *msgArr = [[NSMutableArray alloc] init];
        for (EventModel *model in monthEventList) {
            [msgArr addObject:[NSString stringWithFormat:@"%@ %@",model.publicTimeString,model.content]];
        }
        SXHeadLine *headLine = [[SXHeadLine alloc]initWithFrame:CGRectMake(0, 0, self.eventView.frame.size.width, self.eventView.frame.size.height)];
        headLine.messageArray = [msgArr copy];
        [headLine setBgColor:[UIColor salmonColor] textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:26]];
        [headLine setScrollDuration:0.5 stayDuration:3];
        headLine.hasGradient = YES;
        
        [headLine changeTapMarqueeAction:^(NSInteger index) {
            [WWHUD showWithText:headLine.messageArray[index] inView:SelfViewControllerView afterDelay:2];
        }];
        [headLine start];
        [self.eventView addSubview:headLine];
    }
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
//    NSMutableArray *eventList = [self.viewModel.eventDic objectForKey:[self.calendar.currentPage formateDate:@"yyyy.MM"]];
    for (EventModel *model in self.eventViewModel.eventList) {
        if ([model.publicTime isEqualToDate:date]) {
            return 0;
        }
    }
    NSInteger count = 0;
    NSArray<EKEvent *> *events = [self eventsForDate:date];
    count += events.count;
    return count;
}

//显示事件圆点自定义图片
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    BOOL isEventDay = NO;
//    NSMutableArray *eventList = [self.viewModel.eventDic objectForKey:[self.calendar.currentPage formateDate:@"yyyy.MM"]];
    for (EventModel *model in self.eventViewModel.eventList) {
        if ([model.publicTime isEqualToDate:date]) {
            isEventDay = YES;
        }
    }
    if (isEventDay) {
        return [UIImage imageNamed:@"love"];
    } else {
        return nil;
    }
}

//点击日期
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";//指定转date得日期格式化形式
    NSLog(@"%@",[dateFormatter stringFromDate:date]);//2015-11-20 08:24:04
    [self reSetScrollLabel:date];
}

//切换月份
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
//    self.viewModel.dateTime = [calendar.currentPage formateDate:@"yyyy.MM"];
//    NSArray *timeArr = [[NSDate getMonthBeginAndEndWithDate:calendar.currentPage] componentsSeparatedByString:@"-"];
//    self.viewModel.beginTime = [[NSDate cTimestampFromString:timeArr[0]] doubleValue];
//    self.viewModel.endTime = [[NSDate cTimestampFromString:timeArr[1]] doubleValue];
//    [[self.viewModel requestEventsCommand] execute:nil];
//    [self.calendar reloadData];
    [self reSetScrollLabel:nil];
}

- (void)goBackToday {
    [_calendar setCurrentPage:[NSDate date] animated:YES];
}

@end
