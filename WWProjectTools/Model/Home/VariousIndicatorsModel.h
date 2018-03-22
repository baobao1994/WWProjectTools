//
//  VariousIndicatorsModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VariousIndicatorsModel : BmobObject

@property (nonatomic, copy) NSString *mood;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *physicalState;
@property (nonatomic, copy) NSString *publicTime;
@property (nonatomic, copy) NSString *weight;

- (id)initWithDictionary:(BmobObject *)object;

@end
