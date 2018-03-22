//
//  MotherNoteListViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MotherNoteListViewModel.h"
#import "MotherNoteModel.h"

@interface MotherNoteListViewModel ()

@property (nonatomic, strong) NSArray *oldArr;

@end

@implementation MotherNoteListViewModel

- (RACSignal *)loadSignal{
    __weak __typeof(self)weakSelf = self;
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        BmobQuery *bquery = [BmobQuery queryWithClassName:MotherTable];
        bquery.limit = weakSelf.pageLimit;
        [bquery orderByDescending:CreatedAtKey];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error.code == 0) {
                NSMutableArray *listArr = [[NSMutableArray alloc] init];
                for (BmobObject *obj in array) {
                    [listArr addObject:[[MotherNoteModel alloc] initWithDictionary:obj]];
                }
                if (weakSelf.pageNumber == 0) {
                    weakSelf.oldArr = [listArr copy];
                } else {
                    NSMutableArray *moreListArr = [NSMutableArray arrayWithArray:weakSelf.oldArr];
                    [moreListArr addObjectsFromArray:listArr];
                    weakSelf.oldArr = [moreListArr copy];
                }
                weakSelf.arrRecords = [weakSelf recombineSource:weakSelf.oldArr];
                if (listArr.count >= weakSelf.pageLimit) {
                    weakSelf.pageNumber = weakSelf.pageNumber + 1;
                    weakSelf.isLoadedAllTheData = NO;
                } else {
                    weakSelf.isLoadedAllTheData = YES;
                }
                [subscriber sendNext:@(listArr.count >= weakSelf.pageLimit)];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

//返回拼接后的数据
- (NSMutableArray *)recombineSource:(NSArray *)arrRecordsArr {
    NSMutableArray *combineSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrRecordsArr.count; i ++) {
        MotherNoteModel *motherNote = arrRecordsArr[i];
        MotherNoteModel *timeNote = [[MotherNoteModel alloc] init];
        if (i == 0) {
            timeNote.isTop = YES;
            timeNote.publicTime = motherNote.publicTime;
            [combineSource addObject:timeNote];
        }
        if (i + 1 < arrRecordsArr.count) {
            MotherNoteModel *nextMotherNote = arrRecordsArr[i + 1];
            if (![nextMotherNote.publicTime isEqualToString:motherNote.publicTime]) {
                [combineSource addObject:motherNote];
                MotherNoteModel *nextTimeNote = [[MotherNoteModel alloc] init];
                nextTimeNote.publicTime = nextMotherNote.publicTime;
                nextTimeNote.isTop = YES;
                [combineSource addObject:nextTimeNote];
            } else {
                [combineSource addObject:motherNote];
            }
        } else {
            [combineSource addObject:motherNote];
        }
    }
    return combineSource;
}

@end
