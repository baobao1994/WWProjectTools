//
//  WWPushTransition.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWPushTransition.h"

@implementation WWPushTransition

#pragma mark - UIViewControllerAnimatedTransitioning协议
// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

// 转场动画的具体内容
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 获取动画的源控制器和目标控制器
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = transitionContext.containerView;
    // 创建一个imageView的截图，并把原本imageView隐藏，造成以为移动的就是imageView的假象
    UIView * snapshotView = [_fromSubView snapshotViewAfterScreenUpdates:NO];
    //主控件的位置
    CGRect theRect = [container convertRect:_fromView.frame fromView:fromVC.view];
    if (self.fromRect.size.width == 0 && self.fromRect.size.height == 0 ) {
        //子控件的位置 -- 要取绝对值 目前就做 两级控件
        CGRect theSubRect ;
        if (self.fromView == nil) {
            theSubRect =  [container convertRect:_fromSubView.frame fromView:fromVC.view];
        } else {
            theSubRect =  [_fromSubView convertRect:_fromSubView.frame fromView:_fromView];
        }
        theSubRect.origin.x = fabs(theSubRect.origin.x);
        theSubRect.origin.y = fabs(theSubRect.origin.y);
        if (theRect.origin.y <= 0) {
            theRect.origin.y = 0;
        }
        theRect.origin.y -= self.offset;
        theSubRect.origin.y += theRect.origin.y;
        snapshotView.frame = theSubRect;
        
        self.fromRect = theSubRect;
        if (self.fromRectChange) {
            self.fromRectChange(theSubRect);
        }
    } else {
        snapshotView.frame = self.fromRect;
    }
    _fromView.hidden = YES;
    
    // 设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    fromVC.view.alpha = 0;
    
    // 都添加到container中。注意顺序
    [container addSubview:toVC.view];
    [container addSubview:snapshotView];
    kWeakSelf;
    // 执行动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
        snapshotView.frame = weakSelf.toView.frame;
    } completion:^(BOOL finished) {
        weakSelf.fromView.hidden = NO;
        toVC.view.alpha = 1;
        fromVC.view.alpha = 1;
        weakSelf.toView = weakSelf.fromView;
        [snapshotView removeFromSuperview];
        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:YES];
        weakSelf.fromRect = CGRectZero;
    }];
}

@end
