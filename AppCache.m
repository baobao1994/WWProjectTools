//
//  AppCache.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/7.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "AppCache.h"

@interface AppCache ()


@end

@implementation AppCache

+ (AppCache *)sharedCache{
    static AppCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[AppCache alloc] init];
    });
    return cache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self bind];
    }
    return self;
}

- (void)bind{
    __weak __typeof(self)weakSelf = self;
    _appDelegate.resignActiveBlock = ^{
        //进入后台
        weakSelf.isForeground = false;
    };
    
    _appDelegate.enterForegroundBlock = ^{
        //进入前台
        weakSelf.isForeground = true;
    };
}

@end
