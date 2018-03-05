//
//  WWPushTransition.h
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

//讲解3种转场动画 http://blog.csdn.net/seven_eleven_lgw/article/details/72723995

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

/** 需要push的起始主控件 -- 主要用于二级层级的界面 **/
@property (nonatomic, strong) UIView *fromView;
/** 需要push的起始子控件 -- 用来展示的控件 必传 **/
@property (nonatomic, strong) UIView *fromSubView;
/** 需要push的起始主控件的位置 **/
@property (nonatomic, assign) CGRect fromRect;
/** 需要push的起始子控件的位置 **/
//@property (nonatomic, assign) CGRect fromSubRect;
/** 需要减去起始控件的偏移量 -- scraol 上的偏移量 **/
@property (nonatomic, assign) CGFloat offset;
/** 需要push到达的最终控件 **/
@property (nonatomic, strong) UIView *toView;
/** fromRect变化 **/
@property (nonatomic, copy) void (^fromRectChange)(CGRect fromRect);

@end

