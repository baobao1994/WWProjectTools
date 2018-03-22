//
//  CustomKeyWindowView.h
//  companyms
//
//  Created by bestsep on 2017/11/8.
//  Copyright © 2017年 bestsep. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DirectionType) {
    DirectionTypeOfNormal,//普通
    DirectionTypeOfTop = 1,
    DirectionTypeOfDown,
    DirectionTypeOfLeft,
    DirectionTypeOfRight,
    DirectionTypeOfOrgin
};

@interface CustomKeyWindowView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL needBackTap;//为YES 设置点击背景取消手势
@property (nonatomic, assign) DirectionType directionType;//进入退出方式

+ (CustomKeyWindowView *)sharedCache;

//普通
- (void)show;
- (void)hide;

//自定义
- (void)setCustomContentView:(UIView *)customConentView backGroundColor:(UIColor *)bgColor Alpha:(CGFloat)alpha;
- (void)showDirection:(DirectionType)directionType animateWithDuration:(CGFloat)animateWithDuration;
- (void)hideDirection:(DirectionType)directionType animateWithDuration:(CGFloat)animateWithDuration;
- (void)hideKeyWindow;
- (void)showKeyWindow;

@end
