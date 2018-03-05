//
//  PushTransition.h
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

/** 需要push的VC **/
@property (nonatomic, strong) UIViewController *fromVC;
/** 需要push的起始控件 **/
@property (nonatomic, strong) UIView *fromView;
/** 需要push到达的VC **/
@property (nonatomic, strong) UIViewController *toVC;
/** 需要push到达的最终控件 **/
@property (nonatomic, strong) UIView *toView;

@end
