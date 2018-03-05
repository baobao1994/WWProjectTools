//
//  WWTextInputBarView.h
//  WWTextInputBarView
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

//全部在右边
typedef NS_ENUM(NSInteger, SendButtonAlignment) {
    SendButtonAlignmentTop,
    SendButtonAlignmentCenter,
    SendButtonAlignmentDown
};
@interface WWTextInputBarView : UIView

/** 是否限制几行 默认无限制5行 **/
@property (nonatomic, assign) NSInteger limitLineCount;
/** 字体 **/
@property (nonatomic, strong) UIFont *font;
/** 背景视图颜色 **/
@property (nonatomic, strong) UIColor *bgColor;
/** 发送按钮背景默认颜色 **/
@property (nonatomic, strong) UIColor *sendButtonBgNormalColor;
/** 发送按钮背景高亮颜色 **/
@property (nonatomic, strong) UIColor *sendButtonBgHightLightColor;
/** 发送按钮位置 默认在底部 **/
@property (nonatomic, assign) SendButtonAlignment sendButtonAlignment;
/** TextViewRect **/
@property (nonatomic, assign) CGRect textViewRect;
/** TextView右边的视图 -- 可自定义 **/
@property (nonatomic, strong) UIView *rightView;
/** TextView左边的视图 -- 可自定义 **/
@property (nonatomic, strong) UIView *leftView;
/** 点击发送按钮传输内容 **/
@property (nonatomic, copy) void (^sendContent)(NSString *content);

@end
