//
//  EditEventViewModel.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditEventViewModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remindTime;
@property (nonatomic, assign) BOOL isRemind;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) RACCommand *publicEditEventCommand;

@end
