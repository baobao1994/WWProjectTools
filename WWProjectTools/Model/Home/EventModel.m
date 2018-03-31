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
        self.content = [object objectForKey:ContentKey];
        self.isLate = [object objectForKey:IsLateKey];
        self.remindTime = [object objectForKey:RemindTimeKey];
        self.publicTime = [NSDate dateWithTimeIntervalSince1970:[[object objectForKey:PublicTimeKey] doubleValue]];
        self.publicTimeString = [self.publicTime formateDate:@"MM-dd"];
    }
    return self;
}

@end
