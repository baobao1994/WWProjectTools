//
//  SmallFamilyViewController.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallFamilyViewController : BasicViewController

@property (nonatomic,copy) void (^pushViewControllerBlock)(UIViewController *);

@end
