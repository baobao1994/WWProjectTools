//
//  VariousIndicatorsViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariousIndicatorsViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *weightArr;
@property (nonatomic, strong) NSMutableArray *moodArr;
@property (nonatomic, strong) NSMutableArray *physicalStateArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NSMutableArray *publicTimeArr;
@property (nonatomic, strong) RACCommand *requestVariousIndicatorsCommand;

@end
