//
//  EventsViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/31.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventsViewModel : NSObject

@property (nonatomic, assign) long long beginTime;
@property (nonatomic, assign) long long endTime;
@property (nonatomic, assign) NSString *dateTime;
@property (nonatomic, strong) NSMutableDictionary *eventDic;
@property (nonatomic, strong) RACCommand *requestEventsCommand;

@end
