//
//  MotherViewController.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotherViewController : BasicViewController

@property (nonatomic,copy) void (^pushViewControllerBlock)(UIViewController *);

@end
