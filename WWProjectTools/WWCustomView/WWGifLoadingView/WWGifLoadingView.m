//
//  WWGifLoadingView.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/17.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWGifLoadingView.h"

@interface WWGifLoadingView ()

@property (nonatomic, strong) UIImageView *gifLoadingView;

@end

@implementation WWGifLoadingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = UIColorFromHexColor(0xFAFAFA);
        self.gifLoadingView = [[UIImageView alloc] init];
        [self addSubview:self.gifLoadingView];
        self.hidden = YES;
    }
    return self;
}

- (void)setTipTitleLabel:(UILabel *)tipTitleLabel {
    if (_tipTitleLabel != nil) {
        [_tipTitleLabel removeFromSuperview];
    }
    _tipTitleLabel = tipTitleLabel;
    //    _tipTitleLabel.frame = CGRectMake(self.gifImageView.frame.origin.x, self.gifImageView.frame.origin.y + self.gifImageView.frame.size.height - _tipTitleLabel.frame.size.height - 20, _tipTitleLabel.frame.size.width, _tipTitleLabel.frame.size.height);
    [self addSubview:_tipTitleLabel];
}

#pragma mark - Public Method

- (void)addLoadingLabel {
    UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((UIScreenWidth - 175 * ScreenScale) / 2, self.frame.size.height / 2 + 80 * ScreenScale - self.offsetY, 175 * ScreenScale, 20)];
    tipTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    tipTitleLabel.textColor = [UIColor blackColor];
    tipTitleLabel.textAlignment = NSTextAlignmentCenter;
    tipTitleLabel.text = @"努力加载中...";
    self.tipTitleLabel = tipTitleLabel;
}

- (void)addBounceLabel {
    UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((10 * ScreenScale), self.frame.size.height / 2 + 20 * ScreenScale - self.offsetY, 230 * ScreenScale, 20)];
    tipTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    tipTitleLabel.textColor = [UIColor blackColor];
    tipTitleLabel.textAlignment = NSTextAlignmentCenter;
    tipTitleLabel.text = @"投递成功";
    self.tipTitleLabel = tipTitleLabel;
}

- (void)showLoading {
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:59];
    for (int i = 0; i < 59; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"loading_%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    self.gifLoadingView.animationImages = images;
    self.gifLoadingView.animationRepeatCount = MAXFLOAT;
    self.gifLoadingView.animationDuration = 2.4;
}

- (void)showBounce {
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:50];
    for (int i = 0; i < 50; i ++) {
        NSString *imageName = [NSString stringWithFormat:@"bounce_%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    self.gifLoadingView.animationImages = images;
    self.gifLoadingView.animationRepeatCount = MAXFLOAT;
    self.gifLoadingView.animationDuration = 2;
}

- (void)setNeedBackTap:(BOOL)needBackTap {
    _needBackTap = needBackTap;
    if (needBackTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideStop)];
        [self addGestureRecognizer:tap];
    }
}

- (void)setGifName:(NSString *)gifName {
    _gifName = gifName;
}

- (void)setImageViewRect:(CGRect)imageViewRect {
    _imageViewRect = imageViewRect;    
    self.gifLoadingView.frame = imageViewRect;
    self.gifLoadingView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - self.offsetY);
}

- (void)showStart {
    if (self.hidden) {
        [self.gifLoadingView startAnimating];
        self.hidden = NO;
    }
}

- (void)hideStop {
    if (!self.hidden) {
        self.hidden = YES;
        [self.gifLoadingView stopAnimating];
    }
}

@end

