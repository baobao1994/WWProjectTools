//
//  WWBadgeView.h
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBadgeView : UIButton

/** remind number */
@property (copy , nonatomic) NSString *badgeValue;
/** remind color */
@property (copy , nonatomic) UIColor *badgeColor;

@end
