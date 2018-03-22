//
//  CustomKeyWindowView.m
//  companyms
//
//  Created by bestsep on 2017/11/8.
//  Copyright © 2017年 bestsep. All rights reserved.
//

#import "CustomKeyWindowView.h"
#import "UIView+Addtion.h"

@interface CustomKeyWindowView () <CAAnimationDelegate>

@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, retain) UIView *bgView;

@end

@implementation CustomKeyWindowView

+ (CustomKeyWindowView *)sharedCache {
    static CustomKeyWindowView *customKeyWindowView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customKeyWindowView = [[CustomKeyWindowView alloc] init];
    });
    return customKeyWindowView;
}

- (id)init {
    if (self = [super init]) {
        _keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _keyWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _keyWindow.windowLevel = UIWindowLevelAlert;

        _bgView = [[UIView alloc] initWithFrame:_keyWindow.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        [_keyWindow addSubview:_bgView];
        _bgView.alpha = 0.5;
    }
    return self;
}

- (void)setContentView:(UIView *)contentView {
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5;
    _contentView = contentView;
    [_contentView setCornerRadius:10.0];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    _contentView.center = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    [_keyWindow addSubview:contentView];
}

#pragma mark - Public Method

- (void)setNeedBackTap:(BOOL)needBackTap {
    _needBackTap = needBackTap;
    if (needBackTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_bgView addGestureRecognizer:tap];
    }
}

#pragma mark - Public Method

- (void)setCustomContentView:(UIView *)customConentView backGroundColor:(UIColor *)bgColor Alpha:(CGFloat)alpha{
    _contentView = customConentView;
    _bgView.backgroundColor = bgColor;
    _bgView.alpha = alpha;
    _contentView.frame = customConentView.frame;
    [_keyWindow addSubview:_contentView];
}

- (void)show {
    if (_keyWindow.hidden) {
        [_keyWindow makeKeyAndVisible];
        _keyWindow.hidden = NO;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.01), @(1.1), @(0.9), @(1)];
        animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        animation.duration = 0.5;
        //    animation.delegate = self;
        //    [animation setValue:completion forKey:@"handler"];
        [_contentView.layer addAnimation:animation forKey:@"bounce"];
        _contentView.transform = CGAffineTransformMakeScale(1, 1);
    }
}

- (void)hide {
    if (self.directionType == DirectionTypeOfNormal) {
        if (!_keyWindow.hidden) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.1), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            //    [animation setValue:completion forKey:@"handler"];
            [_contentView.layer addAnimation:animation forKey:@"bounce"];
            _contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    } else {
        DirectionType type;
        if (self.directionType == DirectionTypeOfTop) {
            type = DirectionTypeOfDown;
        } else if (self.directionType == DirectionTypeOfDown) {
            type = DirectionTypeOfTop;
        } else if (self.directionType == DirectionTypeOfLeft) {
            type = DirectionTypeOfRight;
        } else if (self.directionType == DirectionTypeOfRight) {
            type = DirectionTypeOfLeft;
        } else {
            
        }
        [self hideDirection:type animateWithDuration:0.35];
    }
}
//只适配宽度是屏幕宽度
- (void)showDirection:(DirectionType)directionType animateWithDuration:(CGFloat)animateWithDuration  {
    [_keyWindow makeKeyAndVisible];
    _keyWindow.hidden = NO;
    self.directionType = directionType;
    NSArray *orginArr = [self orginArrWithShowDirectionType:directionType];
    CGFloat orginX = [orginArr[0] floatValue];
    CGFloat orginY = [orginArr[1] floatValue];
    [UIView animateWithDuration:animateWithDuration animations:^{
        _contentView.frame = CGRectMake(orginX, orginY, _contentView.frame.size.width, _contentView.frame.size.height);
    }];
}

- (NSArray *)orginArrWithShowDirectionType:(DirectionType)directionType {
    CGFloat orginX = 0.0f;
    CGFloat orginY = 0.0f;
    switch (directionType) {
        case DirectionTypeOfTop:
            orginX = 0;
            orginY = UIScreenHeight - _contentView.frame.size.height;
            _contentView.frame = CGRectMake(0, UIScreenHeight, _contentView.frame.size.width, _contentView.frame.size.height);
            break;
        case DirectionTypeOfDown:
            orginX = 0;
            orginY = 0;
            _contentView.frame = CGRectMake(0, - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height);
            break;
        case DirectionTypeOfLeft:
            orginX = 0;
            orginY = 0;
            _contentView.frame = CGRectMake(_contentView.frame.size.width, 0, _contentView.frame.size.width, _contentView.frame.size.height);
            break;
        case DirectionTypeOfRight:
            orginX = 0;
            orginY = 0;
            _contentView.frame = CGRectMake(- _contentView.frame.size.width, 0, _contentView.frame.size.width, _contentView.frame.size.height);
            break;
        default:
            break;
    }
    return @[@(orginX),@(orginY)];
}

- (void)hideDirection:(DirectionType)directionType animateWithDuration:(CGFloat)animateWithDuration {
    NSArray *orginArr = [self orginArrWithHideDirectionType:directionType];
    CGFloat orginX = [orginArr[0] floatValue];
    CGFloat orginY = [orginArr[1] floatValue];
    [UIView animateWithDuration:animateWithDuration animations:^{
        _contentView.frame = CGRectMake(orginX, orginY, _contentView.frame.size.width, _contentView.frame.size.height);
    } completion:^(BOOL finished) {
        _keyWindow.hidden = YES;
    }];
}

- (NSArray *)orginArrWithHideDirectionType:(DirectionType)directionType {
    CGFloat orginX = 0.0f;
    CGFloat orginY = 0.0f;
    switch (directionType) {
        case DirectionTypeOfTop:
            orginX = 0;
            orginY = - _contentView.frame.size.height;
            break;
        case DirectionTypeOfDown:
            orginX = 0;
            orginY = UIScreenHeight;
            break;
        case DirectionTypeOfLeft:
            orginX = - _contentView.frame.size.width;
            orginY = 0;
            break;
        case DirectionTypeOfRight:
            orginX = _contentView.frame.size.width;
            orginY = 0;
            break;
        default:
            break;
    }
    return @[@(orginX),@(orginY)];
}

- (void)hideKeyWindow {
    _keyWindow.hidden = YES;
}

- (void)showKeyWindow {
    _keyWindow.hidden = NO;
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _keyWindow.hidden = YES;
    _contentView.transform = CGAffineTransformIdentity;
    void(^completion)(void) = [anim valueForKey:@"handler"];
    if (completion) {
        completion();
    }
}

@end
