//
//  EditVariousIndicatorsViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/23.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditVariousIndicatorsViewModel.h"
#import "NSDate+Addition.h"

@implementation EditVariousIndicatorsViewModel

- (RACCommand *)publicEditVariousIndicatorsCommand {
    if (!_publicEditVariousIndicatorsCommand) {
        kWeakSelf;
        _publicEditVariousIndicatorsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf publicEditVariousIndicatorsSignal];
        }];
    }
    return _publicEditVariousIndicatorsCommand;
}

- (RACSignal *)publicEditVariousIndicatorsSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        BmobObject *obj = [[BmobObject alloc] initWithClassName:VariousIndicatorsTable];
        [obj setObject:weakSelf.weight forKey:WeightKey];
        [obj setObject:weakSelf.note forKey:NoteKey];
        NSDate *date = [NSDate date];
        NSString *publicTime = [date formateDate:@"MM.dd"];
        [obj setObject:publicTime forKey:PublicTimeKey];
        NSString *moodType = @"";
        if ([weakSelf.mood isEqualToString:@"非常好"]) {
            moodType = @"0";
        } else if ([weakSelf.mood isEqualToString:@"很好"]) {
            moodType = @"1";
        } else if ([weakSelf.mood isEqualToString:@"一般"]) {
            moodType = @"2";
        } else {
            moodType = @"3";
        }
        [obj setObject:moodType forKey:MoodKey];
        NSString *physicalStateType = @"";
        if ([weakSelf.physicalState isEqualToString:@"无异样"]) {
            physicalStateType = @"0";
        } else if ([weakSelf.physicalState isEqualToString:@"腰酸"]) {
            physicalStateType = @"1";
        } else if ([weakSelf.physicalState isEqualToString:@"头痛"]) {
            physicalStateType = @"2";
        }  else if ([weakSelf.physicalState isEqualToString:@"感冒"]) {
            physicalStateType = @"3";
        } else if ([weakSelf.physicalState isEqualToString:@"发烧"]) {
            physicalStateType = @"4";
        } else {
            physicalStateType = @"5";
        }
        [obj setObject:physicalStateType forKey:PhysicalStateKey];

        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
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
