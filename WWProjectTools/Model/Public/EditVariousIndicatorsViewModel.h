//
//  EditVariousIndicatorsViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/23.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditVariousIndicatorsViewModel : NSObject

@property (nonatomic, copy) NSString *weight;
@property (nonatomic, copy) NSString *mood;
@property (nonatomic, copy) NSString *physicalState;
@property (nonatomic, copy) NSString *note;

@property (nonatomic, strong) RACCommand *publicEditVariousIndicatorsCommand;

@end
