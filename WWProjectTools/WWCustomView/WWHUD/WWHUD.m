//
//  WWHUD.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWHUD.h"
#import "QDCustomToastAnimator.h"
#import "QDCustomToastContentView.h"

@implementation WWHUD

+ (void)showWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [QMUITips showWithText:text inView:view hideAfterDelay:afterDelay];
}

+ (void)showLoadingWithInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    // 如果不需要修改contentView的样式，可以直接使用下面这个工具方法
    //         QMUITips *tips = [QMUITips showLoadingInView:view hideAfterDelay:2];
    
    // 展示如何修改自定义的样式
    QMUITips *tips = [QMUITips createTipsToView:view];
    QMUIToastContentView *contentView = (QMUIToastContentView *)tips.contentView;
    contentView.minimumSize = CGSizeMake(90, 90);
    tips.willShowBlock = ^(UIView *showInView, BOOL animated) {
        NSLog(@"tips calling willShowBlock");
    };
    tips.didShowBlock = ^(UIView *showInView, BOOL animated) {
        NSLog(@"tips calling didShowBlock");
    };
    tips.willHideBlock = ^(UIView *hideInView, BOOL animated) {
        NSLog(@"tips calling willHideBlock");
    };
    tips.didHideBlock = ^(UIView *hideInView, BOOL animated) {
        NSLog(@"tips calling didHideBlock");
    };
    [tips showLoadingHideAfterDelay:afterDelay];
}

+ (void)showLoadingWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [QMUITips showLoading:text inView:view hideAfterDelay:afterDelay];
}

+ (void)showLoadingWithSucceedInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [QMUITips showSucceed:@"加载成功" inView:view hideAfterDelay:afterDelay];
}

+ (void)showLoadingWithErrorInView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [QMUITips showError:@"请检查网络情况" inView:view hideAfterDelay:afterDelay];
}

+ (void)showLoadingWithErrorText:(NSString *)text inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [QMUITips showError:text inView:view hideAfterDelay:afterDelay];
}

+ (void)showLoadingWithInfo:(NSString *)info detailText:(NSString *)detailText styleColor:(UIColor *)styleColor isAnimate:(BOOL)isAnimate inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    QMUITips *tips = [QMUITips showInfo:info detailText:detailText inView:view hideAfterDelay:afterDelay];
    QMUIToastBackgroundView *backgroundView = (QMUIToastBackgroundView *)tips.backgroundView;
//    backgroundView.shouldBlurBackgroundView = YES;
    if (styleColor) {
        backgroundView.styleColor = styleColor;
    }
    if (isAnimate) {
        QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
        tips.toastAnimator = customAnimator;
    }
    tips.tintColor = UIColorBlack;
}

+ (void)showLoadingWithCustomContentView:(UIView *)customView inView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    QMUITips *tips = [QMUITips createTipsToView:view];
    tips.toastPosition = QMUIToastViewPositionBottom;
    QDCustomToastAnimator *customAnimator = [[QDCustomToastAnimator alloc] initWithToastView:tips];
    tips.toastAnimator = customAnimator;
    if (customView) {
        tips.contentView = customView;
    } else {
        QDCustomToastContentView *customContentView = [[QDCustomToastContentView alloc] init];
        [customContentView renderWithImage:UIImageMake(@"image0") text:@"什么是QMUIToastView" detailText:@"QMUIToastView用于临时显示某些信息，并且会在数秒后自动消失。这些信息通常是轻量级操作的成功信息。"];
        tips.contentView = customContentView;
    }
    [tips showAnimated:YES];
    [tips hideAnimated:YES afterDelay:afterDelay];
}

+ (void)hideAllTipsInView {
    [QMUITips hideAllTips];
}

+ (void)hideAllTipsInView:(UIView *)view {
    [QMUITips hideAllTipsInView:view];
}

@end
