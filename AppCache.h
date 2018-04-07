//
//  AppCache.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/7.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface AppCache : NSObject

@property (nonatomic, assign) AppDelegate *appDelegate;
@property (nonatomic, assign) BOOL isForeground;

+ (AppCache *)sharedCache;

@end
