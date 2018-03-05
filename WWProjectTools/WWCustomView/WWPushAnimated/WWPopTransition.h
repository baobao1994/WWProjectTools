//
//  WWPopTransition.h
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WWPopTransition : NSObject <UIViewControllerAnimatedTransitioning>

/** 需要pop的起始子控件 -- 用来展示的控件 必传 **/
@property (nonatomic, strong) UIView *fromSubView;
/** 需要pop到达的最终控件位置 **/
@property (nonatomic, assign) CGRect toViewRect;

@end
