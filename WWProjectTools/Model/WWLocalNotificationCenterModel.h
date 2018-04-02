//
//  WWLocalNotificationCenterModel.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWLocalNotificationCenterModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSTimeInterval alertTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;

- (void)setNotification;

@end
