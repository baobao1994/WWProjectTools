//
//  PushTransition.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWPushTransition.h"
#import "PushViewController.h"
#import "PopViewController.h"

@implementation WWPushTransition

#pragma mark - UIViewControllerAnimatedTransitioning协议
// 指定动画的持续时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return  0.5;
}
//// 转场动画的具体内容
//- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    NSLog(@"toVC.className = %@",self.toVC.class);
//    NSLog(@"fromVC.classname = %@",self.fromVC.class);
//
//    // 获取动画的源控制器和目标控制器
//    PushViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    PopViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIView * container = transitionContext.containerView;
//
//    // 创建一个imageView的截图，并把原本imageView隐藏，造成以为移动的就是imageView的假象
//    UIView * snapshotView = [fromVC.sourceImageView snapshotViewAfterScreenUpdates:NO];
//    snapshotView.frame = [container convertRect:fromVC.sourceImageView.frame fromView:fromVC.view];
//    fromVC.sourceImageView.hidden = YES;
//
//    // 设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
//    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
//    toVC.view.alpha = 0;
//
//    // 都添加到container中。注意顺序
//    [container addSubview:toVC.view];
//    [container addSubview:snapshotView];
//
//    // 执行动画
//    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        snapshotView.frame = toVC.avatarImageView.frame;
//        toVC.view.alpha = 1;
//    } completion:^(BOOL finished) {
//        fromVC.sourceImageView.hidden = NO;
//        toVC.avatarImageView.image = fromVC.sourceImageView.image;
//        [snapshotView removeFromSuperview];
//
//        //一定要记得动画完成后执行此方法，让系统管理 navigation
//        [transitionContext completeTransition:YES];
//    }];
//}

// 转场动画的具体内容
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"toVC.className = %@",self.toVC.class);
    NSLog(@"fromVC.classname = %@",self.fromVC.class);

    // 获取动画的源控制器和目标控制器
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView * container = transitionContext.containerView;

    // 创建一个imageView的截图，并把原本imageView隐藏，造成以为移动的就是imageView的假象
    UIView * snapshotView = [_fromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [container convertRect:_fromView.frame fromView:fromVC.view];
    _fromView.hidden = YES;

    // 设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;

    // 都添加到container中。注意顺序
    [container addSubview:toVC.view];
    [container addSubview:snapshotView];

    // 执行动画
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        snapshotView.frame = _toView.frame;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        _fromView.hidden = NO;
        _toView = _fromView;
        [snapshotView removeFromSuperview];

        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:YES];
    }];
}

@end
