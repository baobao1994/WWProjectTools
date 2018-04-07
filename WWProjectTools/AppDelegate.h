//
//  AppDelegate.h
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WillResignActiveBlock)();
typedef void(^WillEnterForegroundBlock)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) WillResignActiveBlock resignActiveBlock;
@property (copy, nonatomic) WillEnterForegroundBlock enterForegroundBlock;

//切换整个tabbar
- (void)replaceTabbar;

@end

