//
//  WWGifLoadingView.h
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWGifLoadingView : UIView

@property (nonatomic, copy) NSString *gifName;//第三方的gif。会奔溃。弃用
@property (nonatomic, assign) CGRect imageViewRect;
@property (nonatomic, strong) UILabel *tipTitleLabel;
@property (nonatomic, assign) BOOL needBackTap;//为YES 设置点击背景取消手势
@property (nonatomic, assign) CGFloat offsetY;//Y轴偏移量

- (void)addLoadingLabel;
- (void)addBounceLabel;
//用帧数来显示gif
- (void)showLoading;
- (void)showBounce;

- (void)showStart;
- (void)hideStop;

@end

