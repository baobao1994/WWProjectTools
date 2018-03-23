//
//  EditMotherNoteViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/23.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditMotherNoteViewModel.h"
#import "NSDate+Addition.h"

@implementation EditMotherNoteViewModel

- (RACCommand *)publicEditMotherNoteCommand {
    if (!_publicEditMotherNoteCommand) {
        kWeakSelf;
        _publicEditMotherNoteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf publicEditMotherNoteSignal];
        }];
    }
    return _publicEditMotherNoteCommand;
}

- (RACSignal *)publicEditMotherNoteSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        BmobObject *obj = [[BmobObject alloc] initWithClassName:MotherTable];
        [obj setObject:weakSelf.photosArr forKey:PhotosKey];
        NSDate *date = [NSDate date];
        NSString *publicTime = [date formateDate:@"yyyy-MM-dd"];
        [obj setObject:publicTime forKey:PublicTimeKey];
        [obj setObject:weakSelf.note forKey:NoteKey];
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
