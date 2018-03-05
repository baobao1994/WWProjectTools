//
//  UITabBarItem+BadgeColor.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "UITabBarItem+BadgeColor.h"
#import <objc/runtime.h>

static const char itemBadgeColor_Key;

@implementation UITabBarItem (BadgeColor)

@dynamic badgeColor;
//@dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成

- (void)setBadgeColor:(UIColor *)badgeColor {
    [self willChangeValueForKey:@"badgeColor"];
    objc_setAssociatedObject(self, &itemBadgeColor_Key, badgeColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"badgeColor"];
}

- (UIColor *)badgeColor {
    return objc_getAssociatedObject(self, &itemBadgeColor_Key);
}

@end
