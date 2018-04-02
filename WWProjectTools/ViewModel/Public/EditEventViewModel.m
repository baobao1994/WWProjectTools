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
        [obj setObject:[NSDate cTimestampFromString:weakSelf.remindTime] forKey:RemindTimeKey];
        [obj setObject:weakSelf.title forKey:TitleKey];
        [obj setObject:[NSNumber numberWithBool:weakSelf.isRemind] forKey:IsRemindKey];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                if (weakSelf.isRemind) {
                    WWLocalNotificationCenterModel *notification = [[WWLocalNotificationCenterModel alloc] init];
                    notification.content = weakSelf.content;
                    notification.title = weakSelf.title;
                    notification.alertTime = [NSDate pleaseInsertStarTime:[[NSDate date] formateDate:@"yyyy-MM-dd HH:mm"] andInsertEndTime:weakSelf.remindTime];
                    notification.time = weakSelf.remindTime;
                    [notification setNotification];
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

