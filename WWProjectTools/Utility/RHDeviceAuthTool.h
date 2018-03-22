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

typedef void(^CamAuthResutlBlock)(void);

@interface RHDeviceAuthTool : NSObject

+ (void)photoAuth:(CamAuthResutlBlock)resultBlock;
+ (void)camAuth:(CamAuthResutlBlock)resultBlock;

@end
