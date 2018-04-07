//
//  WWLocation.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/7.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *placemark, NSString *error);

@interface WWLocation : NSObject

+ (WWLocation *)locationManager;
/** 获取当前位置 */
- (void)getCurrentLocation:(ResultBlock)block;

@end
