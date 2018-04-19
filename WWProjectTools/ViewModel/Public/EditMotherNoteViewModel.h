//
//  EditMotherNoteViewModel.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/23.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditMotherNoteViewModel : NSObject

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSArray *photosArr;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *publicTime;
@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, strong) RACCommand *publicEditMotherNoteCommand;
@property (nonatomic, strong) RACCommand *deleteEditMotherNoteCommand;
@property (nonatomic, strong) RACCommand *updateEidtMotherNoteCommand;

@end
