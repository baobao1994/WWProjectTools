//
//  BasicListViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicListViewModel : NSObject

@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) NSInteger pageLimit;//defalue 10
@property (nonatomic, strong) NSArray *arrRecords;
@property (nonatomic, assign) BOOL isLoadedAllTheData;
@property (nonatomic, strong) RACSignal *loadSignal;
@property (nonatomic, strong) RACCommand *loadCommand;
@property (nonatomic, strong) RACCommand *loadMoreCommand;

@end
