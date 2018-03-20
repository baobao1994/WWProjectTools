//
//  MotherNoteTableViewCell.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticImageCollectionViewCell.h"

@class MotherNoteModel;

@interface MotherNoteTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void) setContent:(MotherNoteModel *)noteModel;

@end
