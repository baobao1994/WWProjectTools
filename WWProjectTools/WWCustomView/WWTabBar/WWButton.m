//
//  WWButton.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWButton.h"
#import "WWBadgeView.h"
#import "WWTabBarConfig.h"

@interface WWButton ()

// remind number
@property (weak , nonatomic) WWBadgeView * badgeView;

@end

@implementation WWButton

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
    CGFloat width = self.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    if (self.titleLabel.text && ![self.titleLabel.text isEqualToString:@""]) {
        self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 16, width, 16);
        self.imageView.frame = CGRectMake(0 , 0, width, 35);
    } else {
        self.imageView.frame = CGRectMake(0 , 0, width, height);
    }
}

/**
 *  Set red dot item
 */
- (void)setItem:(UITabBarItem *)item {
    self.badgeView.badgeValue = [item valueForKeyPath:@"badgeValue"];
    self.badgeView.badgeColor = [item valueForKeyPath:@"badgeColor"];
}

/**
 *  getter
 */
-(WWBadgeView *)badgeView {
    if (!_badgeView) {
        WWBadgeView * badgeView = [[WWBadgeView alloc] init];
        _badgeView = badgeView;
        [self addSubview:badgeView];
    }
    return _badgeView;
}

- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
