//
//  EditViewController.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotherNoteModel.h"

@interface EditMotherNoteViewController : BasicViewController

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) MotherNoteModel *motherNoteModel;

@end
