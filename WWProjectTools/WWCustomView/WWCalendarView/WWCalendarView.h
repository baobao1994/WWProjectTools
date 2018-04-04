//
//  WWCalendarView.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar/FSCalendar.h>
#import "EventsViewModel.h"
#import "NSDate+Addition.h"
#import "EventModel.h"

@interface WWCalendarView : UIView

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic, strong) EventsViewModel *eventViewModel;
@property (nonatomic, copy) void (^pushVC)(UIViewController *viewController);
@property (nonatomic, copy) void (^scrollLabel)(NSDate *date);

@end
