//
//  CustomSegmentedControlView.m
//  RecruitmentHallStudentSide
//
//  Created by bestsep on 2017/12/14.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import "CustomSegmentedControlView.h"

#define kButtonWidth ((self.frame.size.width - self.count - 1) * 1.0 / self.count)

@interface CustomSegmentedControlView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *selectButton;

@end


@implementation CustomSegmentedControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, self.frame.size.height - 5)];
        self.bgView.layer.borderColor = UIColorFromHexColor(0X01AAF8).CGColor;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.clipsToBounds = YES;
        [self addSubview:self.bgView];
    }
    return self;
}

- (void)setCount:(NSInteger)count {
    _count = count;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.bgView.layer.cornerRadius = cornerRadius;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.bgView.layer.borderWidth = borderWidth;
    self.bgView.layer.masksToBounds = YES;
}

- (void)initWithDataArr:(NSArray *)dataArr {
    
    for (int i = 0; i < self.count; i ++) {
        CGFloat width = kButtonWidth;
        if (i + 1 == self.count) {
            width += 1;
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (kButtonWidth + 1), 0, width, self.frame.size.height - 5)];
        [button setTitle:dataArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHexColor(0X01AAF8) forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        button.tag = 2000 + i;
        [button addTarget:self action:@selector(didSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
        
        UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.size.width + button.frame.origin.x - 10 * ScreenScale, 10, 5, 5)];
        pointLabel.backgroundColor = UIColorFromHexColor(0XFF0000);
        pointLabel.layer.cornerRadius = 3;
        pointLabel.layer.masksToBounds = YES;
        pointLabel.tag = 1000 + i;
        pointLabel.hidden = YES;
        [self addSubview:pointLabel];
        
        if (i + 1 != self.count) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.size.width + button.frame.origin.x, 0, 1, self.frame.size.height - 5)];
            lineView.backgroundColor = UIColorFromHexColor(0X01AAF8);
            [_bgView addSubview:lineView];
        }
        if (i == 0) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromHexColor(0X01AAF8)];
            self.selectButton = button;
        }
    }
}

- (void)didSelectBtn:(UIButton *)sender {
    if (sender != self.selectButton) {
        [self.selectButton setTitleColor:UIColorFromHexColor(0X01AAF8) forState:UIControlStateNormal];
        [self.selectButton setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setBackgroundColor:UIColorFromHexColor(0X01AAF8)];
        self.selectButton = sender;
        self.didChangeSelect(sender.tag - 2000);
    }
}

- (void)setRedPointIndex:(NSInteger)index showStatu:(BOOL)showStatu {
    UILabel *redPointLabel = [self viewWithTag:1000 + index];
    redPointLabel.hidden = !showStatu;
}

- (void)didSelectIndex:(NSInteger)index {
    UIButton *button = [self viewWithTag:2000 + index];
    [self didSelectBtn:button];
}

@end
