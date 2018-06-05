//
//  SmallFamilyViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "SmallFamilyViewController.h"
#import "WWCalendarView.h"
#import "UIColor+Wonderful.h"
#import "SXMarquee.h"
#import "SXHeadLine.h"
#import "WeatherView.h"

#define kCalendarViewHeight ((self.view.frame.size.height - 25 - 44) / 2)

@interface SmallFamilyViewController ()

@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventViewTopConstraint;
@property (nonatomic, strong) WWCalendarView *calendarView;
@property (nonatomic, strong) WeatherView *weatherView;
@property (nonatomic, strong) AppCache *appCache;

@end

@implementation SmallFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.calendarView.calendar.selectedDate) {
        [self reSetScrollLabel:self.calendarView.calendar.selectedDate];
    }
}

- (void)setUp {
    self.eventViewTopConstraint.constant = kCalendarViewHeight;
    [self.view addSubview:self.calendarView];
    [self.view addSubview:self.weatherView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventNotificationAction:) name:@"EventNotification" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reSetScrollLabel:nil];
    });
}

- (void)EventNotificationAction:(NSNotification *)notification{
    NSLog(@"---接收到通知---");
    [[self.calendarView.eventViewModel requestEventsCommand] execute:nil];
    if (self.calendarView.calendar.selectedDate) {
        [self.calendarView.calendar deselectDate:self.calendarView.calendar.selectedDate];
    }
}

- (void)bind {
    self.appCache = [AppCache sharedCache];
    [RACObserve(self.appCache, isForeground) subscribeNext:^(id  _Nullable x) {
        NSLog(@"xxx = %@",[x boolValue]?@"yes":@"no");
        if ([x boolValue]) {
            if (self.calendarView.calendar.selectedDate) {
                [self reSetScrollLabel:self.calendarView.calendar.selectedDate];
            } else {
                [self reSetScrollLabel:nil];
            }
        }
    }];
}

- (WWCalendarView *)calendarView {
    if (!_calendarView) {
        kWeakSelf;
        _calendarView = [[WWCalendarView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, kCalendarViewHeight)];
        _calendarView.pushVC = ^(UIViewController *viewController) {
            if (weakSelf.pushViewControllerBlock) {
                weakSelf.pushViewControllerBlock(viewController);
            }
        };
        _calendarView.scrollLabel = ^(NSDate *date) {
            [weakSelf reSetScrollLabel:date];
        };
    }
    return _calendarView;
}

- (WeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, kCalendarViewHeight + 25, UIScreenWidth, kCalendarViewHeight + kTopBarDifHeight)];
    }
    return _weatherView;
}

- (void)reSetScrollLabel:(NSDate *)seletDate {
    [self.eventView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *monthEventList = [[NSMutableArray alloc] init];
    NSArray *timeArr = [[NSDate getMonthBeginAndEndWithDate:self.calendarView.calendar.currentPage] componentsSeparatedByString:@","];
    for (EventModel *model in self.calendarView.eventViewModel.eventList) {
        if ([model.remindTime validateWithStartTime:timeArr[0] withExpireTime:timeArr[1]]) {
            [monthEventList addObject:model];
        }
    }
    if (seletDate || monthEventList.count == 0) {
        NSString *eventString = @"";
        for (EventModel *model in monthEventList) {
            if ([NSDate isSameDay:model.remindTime date2:seletDate]) {
                eventString = [eventString stringByAppendingString:[NSString stringWithFormat:@"%@ %@ %@   ",[model.remindTime formateDate:@"HH:mm"],model.title,model.content]];
            }
            
        }
        if (isEmptyString(eventString)) {
            if (monthEventList.count == 0) {
                eventString = @"当月没有事件";
            } else {
                eventString = @"当日没有事件";
            }
        }
        SXMarquee *mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, self.eventView.frame.size.width, self.eventView.frame.size.height) speed:4 Msg:eventString bgColor:UIColorFromHexColor(0XEC7D8A) txtColor:[UIColor whiteColor]];
        [mar changeMarqueeLabelFont:[UIFont systemFontOfSize:15]];
        [mar changeTapMarqueeAction:^{
            [WWHUD showWithText:eventString inView:SelfViewControllerView afterDelay:2];
        }];
        [mar start];
        [self.eventView addSubview:mar];
    } else {
        NSMutableArray *msgArr = [[NSMutableArray alloc] init];
        for (EventModel *model in monthEventList) {
            [msgArr addObject:[NSString stringWithFormat:@"%@ %@ %@",model.remindTimeString,model.title,model.content]];
        }
        SXHeadLine *headLine = [[SXHeadLine alloc]initWithFrame:CGRectMake(0, 0, self.eventView.frame.size.width, self.eventView.frame.size.height)];
        headLine.messageArray = [msgArr copy];
        [headLine setBgColor:UIColorFromHexColor(0XEC7D8A) textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:15]];
        [headLine setScrollDuration:0.5 stayDuration:3];
        headLine.hasGradient = YES;
        
        [headLine changeTapMarqueeAction:^(NSInteger index) {
            [WWHUD showWithText:headLine.messageArray[index] inView:SelfViewControllerView afterDelay:2];
        }];
        [headLine start];
        [self.eventView addSubview:headLine];
    }
}

- (void)goBackToday {
    [self.calendarView.calendar setCurrentPage:[NSDate date] animated:YES];
}

@end
