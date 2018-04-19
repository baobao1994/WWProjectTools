//
//  MotherNoteModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MotherNoteModel.h"
#import "NSDate+Addition.h"

@implementation MotherNoteModel

- (id)initWithDictionary:(BmobObject *)object {
    if (self = [super init]) {
        self.publicTime = [object objectForKey:PublicTimeKey];
        self.note = [object objectForKey:NoteKey];
        self.photos = [[NSArray alloc] initWithArray:[object objectForKey:PhotosKey]];
        self.publicTimeString = [[NSDate alloc] setTimeInterval:self.publicTime formateDate:@"yyyy-MM-dd"];
        self.objectId = [object objectForKey:ObjectIdKey];
        self.createdAt = [object objectForKey:CreatedAtKey];
        self.updatedAt = [object objectForKey:UpdatedAtKey];
    }
    return self;
}

@end
