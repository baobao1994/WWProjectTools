//
//  EditEventViewModel.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditEventViewModel.h"
#import "NSDate+Addition.h"
#import "WWLocalNotificationCenterModel.h"

@implementation EditEventViewModel

- (RACCommand *)publicEditEventCommand {
    if (!_publicEditEventCommand) {
        kWeakSelf;
        _publicEditEventCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf publicEditEventSignal];
        }];
    }
    return _publicEditEventCommand;
}

- (RACSignal *)publicEditEventSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        BmobObject *obj = [[BmobObject alloc] initWithClassName:EventTable];
        [obj setObject:weakSelf.content forKey:ContentKey];
        [obj setObject:[NSDate cTimestampFromString:weakSelf.publicTime] forKey:PublicTimeKey];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                WWLocalNotificationCenterModel *notification = [[WWLocalNotificationCenterModel alloc] init];
                notification.content = weakSelf.content;
                notification.alertTime = [NSDate pleaseInsertStarTime:[[NSDate date] formateDate:@"yyyy-MM-dd HH:mm"] andInsertEndTime:weakSelf.publicTime];
                notification.time = weakSelf.publicTime;
                [notification setNotification];
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

