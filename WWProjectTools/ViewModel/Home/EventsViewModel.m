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
        self.eventList = [[NSMutableArray alloc] init];
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
//        NSArray *sortArr = @[@{PublicTimeKey:@{@"$gt":@(weakSelf.beginTime)}},@{PublicTimeKey:@{@"$lt":@(weakSelf.endTime)}}];
//        [bquery addTheConstraintByAndOperationWithArray:sortArr];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error.code == 0) {
                for (BmobObject *obj in array) {
                    [weakSelf.eventList addObject:[[EventModel alloc] initWithDictionary:obj]];
                }
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
