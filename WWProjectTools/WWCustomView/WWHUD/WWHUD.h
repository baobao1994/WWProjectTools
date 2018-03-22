//
//  WWHUD.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWHUD : NSObject

+ (void)showWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithSucceedInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithErrorInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithErrorText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithInfo:(NSString *)info detailText:(NSString *)detailText styleColor:(UIColor *)styleColor isAnimate:(BOOL)isAnimate inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)showLoadingWithCustomContentView:(UIView *)customView inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;
+ (void)hideAllTipsInView;
+ (void)hideAllTipsInView:(UIView *)view;

@end
