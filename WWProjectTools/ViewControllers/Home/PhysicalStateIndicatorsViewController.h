//
//  PhysicalStateIndicatorsViewController.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicalStateIndicatorsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *physicalStateArr;
@property (nonatomic, strong) NSMutableArray *noteArr;
@property (nonatomic, strong) NSMutableArray *publicTimeArr;

- (void)strokePath;

@end
