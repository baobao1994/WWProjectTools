//
//  EditMotherNoteViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/23.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditMotherNoteViewModel : NSObject

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, copy) NSString *note;

@property (nonatomic, strong) RACCommand *publicEditMotherNoteCommand;

@end
