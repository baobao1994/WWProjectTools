//
//  StaticImageCollectionViewCell.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
