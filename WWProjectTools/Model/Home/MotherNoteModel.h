//
//  MotherNoteModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotherNoteModel : BmobObject

@property (nonatomic, copy) NSString *publicTime;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, assign) BOOL isTop;//界面UI需要

- (id)initWithDictionary:(BmobObject *)object;

@end
