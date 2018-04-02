//
//  EventModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/31.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EventModel.h"
#import "NSDate+Addition.h"

@implementation EventModel

- (id)initWithDictionary:(BmobObject *)object {
    if (self = [super init]) {
        self.title = [object objectForKey:TitleKey];
        self.content = [object objectForKey:ContentKey];
        self.isRemind = [object objectForKey:IsRemindKey];
        self.remindTime = [NSDate dateWithTimeIntervalSince1970:[[object objectForKey:RemindTimeKey] doubleValue]];
        self.remindTimeString = [self.remindTime formateDate:@"MM-dd"];
    }
    return self;
}

@end
