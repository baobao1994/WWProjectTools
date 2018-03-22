//
//  TimeHeaderTableViewCell.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "TimeHeaderTableViewCell.h"
#import "UIView+Addtion.h"

@interface TimeHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pointImageView;

@end

@implementation TimeHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.pointImageView setCornerRadius:7.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
