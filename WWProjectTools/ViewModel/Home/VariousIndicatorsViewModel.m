//
//  VariousIndicatorsViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "VariousIndicatorsViewModel.h"
#import "VariousIndicatorsModel.h"
#import "NSDate+Addition.h"

@implementation VariousIndicatorsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.weightArr = [[NSMutableArray alloc] init];
        self.moodArr = [[NSMutableArray alloc] init];
        self.physicalStateArr = [[NSMutableArray alloc] init];
        self.publicTimeArr = [[NSMutableArray alloc] init];
        self.noteArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (RACCommand *)requestVariousIndicatorsCommand {
    kWeakSelf;
    if (!_requestVariousIndicatorsCommand) {
        _requestVariousIndicatorsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf requestVariousIndicatorsSignal];
        }];
    }
    return _requestVariousIndicatorsCommand;
}

- (RACSignal *)requestVariousIndicatorsSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        BmobQuery *bquery = [BmobQuery queryWithClassName:VariousIndicatorsTable];
        bquery.limit = 30;
        [bquery orderByDescending:PublicTimeKey];
        [bquery orderByDescending:CreatedAtKey];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error.code == 0) {
                [weakSelf.weightArr removeAllObjects];
                [weakSelf.moodArr removeAllObjects];
                [weakSelf.physicalStateArr removeAllObjects];
                [weakSelf.noteArr removeAllObjects];
                [weakSelf.publicTimeArr removeAllObjects];
                /*
                 心情：0 非常好 1 很好 2 一般 3 差
                 */
                NSInteger veryGoodMood = 0;
                NSInteger goodMood = 0;
                NSInteger justMood = 0;
                NSInteger badMood = 0;
                for (NSInteger j = array.count - 1; j >= 0; j --) {
                    VariousIndicatorsModel *variousIndicatorsModel = [[VariousIndicatorsModel alloc] initWithDictionary:array[j]];
                    [weakSelf.weightArr addObject:variousIndicatorsModel.weight];
                    NSInteger mood = [variousIndicatorsModel.mood integerValue];
                    switch (mood) {
                        case 0:
                            veryGoodMood ++;
                            break;
                        case 1:
                            goodMood ++;
                            break;
                        case 2:
                            justMood ++;
                            break;
                        case 3:
                            badMood ++;
                            break;
                        default:
                            break;
                    }
                    [weakSelf.publicTimeArr addObject:[[NSDate alloc] setTimeInterval:variousIndicatorsModel.publicTime formateDate:@"MM-dd"]];
                    NSArray *physicalStateArr = [variousIndicatorsModel.physicalState componentsSeparatedByString:@","];
                    NSInteger badStateCount = 0;
                    for (int i = 0; i < physicalStateArr.count; i ++) {
                        NSInteger state = [physicalStateArr[i] integerValue];
                        if (state) {
                            badStateCount ++;
                        }
                    }
                    [weakSelf.physicalStateArr addObject:[NSString stringWithFormat:@"%ld",5 - badStateCount]];
                    [weakSelf.noteArr addObject:variousIndicatorsModel.note];
                }
                weakSelf.moodArr = [[NSMutableArray alloc] initWithObjects:
                                   [NSString stringWithFormat:@"%ld",veryGoodMood],
                                   [NSString stringWithFormat:@"%ld",goodMood],
                                   [NSString stringWithFormat:@"%ld",justMood],
                                   [NSString stringWithFormat:@"%ld",badMood], nil];
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
