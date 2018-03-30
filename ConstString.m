//
//  ConstString.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "ConstString.h"

#pragma mark - basic

NSString *const BmobKey = @"7ff96c3a0695e837ccbb9ceb213a6865";
uint64_t const kDBVersion = 100002;

#pragma mark - bmobTable

NSString *const FamilyTable = @"family";
NSString *const BabyTable = @"baby";
NSString *const MotherTable = @"mother";
NSString *const VariousIndicatorsTable = @"various_indicators";
NSString *const FoodsTable = @"foods";
NSString *const EventTable = @"event";
NSString *const ImportantDatesTable = @"important_dates";

#pragma mark - bmob

NSString *const ObjectIdKey = @"objectId";
NSString *const CreatedAtKey = @"createdAt";
NSString *const UpdatedAtKey = @"updatedAt";

#pragma mark - static

NSString *const ClassNameKey = @"class_name";
NSString *const TitleNameKey = @"title_name";
NSString *const DataKey = @"data";
NSString *const FileNameKey = @"filename";

#pragma mark - eventKey

NSString *const ContentKey = @"content";
NSString *const RemindTimeKey = @"remind_time";
NSString *const IsRemindKey = @"is_remind";
NSString *const LevelKey = @"level";

#pragma mark - motherNoteKey

NSString *const PublicTimeKey = @"public_time";
NSString *const NoteKey = @"note";
NSString *const PhotosKey = @"photos";
NSString *const MoodKey = @"mood";
NSString *const PhysicalStateKey = @"physical_state";
NSString *const WeightKey = @"weight";

#pragma mark - Scrollow

NSString *const kIsCanScroll = @"isCanScroll";
NSString *const kCanScroll = @"canScroll";
NSString *const kNoScroll = @"noScroll";
NSString *const kGoTopNotificationName = @"goTop";
NSString *const kLeaveTopNotificationName = @"leaveTop";

