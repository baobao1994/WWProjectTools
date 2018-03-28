//
//  BasicListViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "BasicListViewModel.h"

@implementation BasicListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _pageNumber = 0;
        _arrRecords = @[];
        _pageLimit = 10;
        _skip = 0;
        _isLoadedAllTheData = NO;
    }
    return self;
}

- (RACCommand *)loadCommand{
    _pageNumber = 0;
    _skip = 0;
    _isLoadedAllTheData = NO;
    if (_loadCommand == nil) {
        __weak __typeof(self)weakSelf = self;
        _loadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return weakSelf.loadSignal;
        }];
    }
    _loadCommand.allowsConcurrentExecution = true;
    return _loadCommand;
}

- (RACCommand *)loadMoreCommand{
    if (_loadMoreCommand == nil) {
        __weak __typeof(self)weakSelf = self;
        _loadMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return weakSelf.loadSignal;
        }];
    }
    return _loadMoreCommand;
}

@end
