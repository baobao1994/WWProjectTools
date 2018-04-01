//
//  EditEventViewModel.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditEventViewModel : NSObject

@property (nonatomic, copy) NSString *remindTime;//暂时不用
@property (nonatomic, copy) NSString *isLate;//暂时不用
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publicTime;

@property (nonatomic, strong) RACCommand *publicEditEventCommand;

@end
