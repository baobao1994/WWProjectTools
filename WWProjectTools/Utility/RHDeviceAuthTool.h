//
//  RHDeviceAuthTool.h
//  RecruitmentHallStudentSide
//
//  Created by baoshuguang on 2017/7/10.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <EventKit/EventKit.h>
//https://www.cnblogs.com/junhuawang/p/5996699.html 所有权限检查
typedef void(^AuthResutlBlock)(void);

@interface RHDeviceAuthTool : NSObject

+ (void)photoAuth:(AuthResutlBlock)resultBlock;
+ (void)camAuth:(AuthResutlBlock)resultBlock;
+ (void)calendarAuth:(AuthResutlBlock)resultBlock;

@end
