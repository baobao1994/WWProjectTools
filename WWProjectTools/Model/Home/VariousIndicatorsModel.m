//
//  VariousIndicatorsModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "VariousIndicatorsModel.h"

@implementation VariousIndicatorsModel

- (id)initWithDictionary:(BmobObject *)object {
    if (self = [super init]) {
        self.publicTime = [object objectForKey:PublicTimeKey];
        self.note = [object objectForKey:NoteKey];
        self.weight = [NSString stringWithFormat:@"%@",[object objectForKey:WeightKey]];
        self.mood = [NSString stringWithFormat:@"%@",[object objectForKey:MoodKey]];
        self.physicalState = [NSString stringWithFormat:@"%@",[object objectForKey:PhysicalStateKey]];
    }
    return self;
}

@end
