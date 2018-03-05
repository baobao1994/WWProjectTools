//
//  WWCenterButton.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWCenterButton.h"
#import "WWTabBarConfig.h"

@implementation WWCenterButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[WWTabBarConfig shared].textColor forState:UIControlStateNormal];
        [self setTitleColor:[WWTabBarConfig shared].selectedTextColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return;
    }
    
    /**
     *  button is bulge
     */
    if (self.is_bulge) {
        self.imageView.frame = self.bounds;
        if (self.titleLabel.text.length) {
            self.titleLabel.frame = CGRectMake(0 , self.frame.size.height +([WWTabBarConfig shared].bulgeHeight-15),
                                               self.frame.size.width , 16);
        }else{
            CGRect rect = self.imageView.frame;
            rect.size.height += 8;
            self.imageView.frame = rect;
        }
        return;
    }
    /**
     *  button is normal and no text
     */
    if (!self.titleLabel.text.length) {
        self.imageView.frame = self.bounds;
        return;
    }
    /**
     *  button is normal and contain text
     */
    CGFloat width = self.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    self.titleLabel.frame = CGRectMake(0, height-[WWTabBarConfig shared].bulgeHeight , width, [WWTabBarConfig shared].bulgeHeight);
    self.imageView.frame = CGRectMake(0 , 0, width, 35);
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
