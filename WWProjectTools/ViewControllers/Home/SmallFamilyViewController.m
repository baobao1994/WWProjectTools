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

@interface SmallFamilyViewController ()

@property (weak, nonatomic) IBOutlet UIView *eventView;
@property (nonatomic, strong) WWCalendarView *calendarView;

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
    [self.view addSubview:self.calendarView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventNotificationAction:) name:@"EventNotification" object:nil];
}

- (void)EventNotificationAction:(NSNotification *)notification{
    NSLog(@"---接收到通知---");
    [[self.calendarView.eventViewModel requestEventsCommand] execute:nil];
    if (self.calendarView.calendar.selectedDate) {
        [self.calendarView.calendar deselectDate:self.calendarView.calendar.selectedDate];
    }
}

- (void)bind {
    
}

- (WWCalendarView *)calendarView {
    if (!_calendarView) {
        kWeakSelf;
        _calendarView = [[WWCalendarView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 350)];
        _calendarView.pushVC = ^(UIViewController *viewController) {
            if (weakSelf.pushViewControllerBlock) {
                weakSelf.pushViewControllerBlock(viewController);
            }
        };
        _calendarView.scrollLabel = ^(NSDate *date) {
            [weakSelf reSetScrollLabel:date];
        };
        [self.view addSubview:_calendarView];
    }
    return _calendarView;
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
                eventString = [eventString stringByAppendingString:[NSString stringWithFormat:@"%@ %@   ",[model.remindTime formateDate:@"HH:mm"],model.content]];
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
            [msgArr addObject:[NSString stringWithFormat:@"%@ %@",model.remindTimeString,model.content]];
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

- (void)goBackToday {
    [self.calendarView.calendar setCurrentPage:[NSDate date] animated:YES];
}

@end
