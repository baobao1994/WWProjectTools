//
//  EventModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/31.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : BmobObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *isRemind;
@property (nonatomic, strong) NSDate *remindTime;
@property (nonatomic, copy) NSString *remindTimeString;

- (id)initWithDictionary:(BmobObject *)object;

@end
