//
//  EventsViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/31.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EventsViewModel.h"
#import "EventModel.h"

@implementation EventsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (RACCommand *)requestEventsCommand {
    if (_requestEventsCommand == nil) {
        kWeakSelf;
        _requestEventsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf requestEventsSignal];
        }];
    }
    return _requestEventsCommand;
}

- (RACSignal *)requestEventsSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        BmobQuery *bquery = [BmobQuery queryWithClassName:EventTable];
        NSArray *sortArr = @[@{PublicTimeKey:@{@"$gt":@(weakSelf.beginTime)}},@{PublicTimeKey:@{@"$lt":@(weakSelf.endTime)}}];
        [bquery addTheConstraintByAndOperationWithArray:sortArr];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error.code == 0) {
                NSMutableArray<EventModel *> *eventList = [[NSMutableArray alloc] init];
                for (BmobObject *obj in array) {
                    [eventList addObject:[[EventModel alloc] initWithDictionary:obj]];
                }
                [weakSelf.eventDic setObject:eventList forKey:weakSelf.dateTime];
                [subscriber sendNext:@"success"];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

@end
