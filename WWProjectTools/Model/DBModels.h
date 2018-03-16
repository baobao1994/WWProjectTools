//
//  DBModels.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBModels : RLMObject

@end

/*
 插入
 RLMRealm *realm = [RLMRealm defaultRealm];
 [realm beginWriteTransaction];
 for (RHSchoolMessageInfo *messageInfo in weakSelf.viewModel.arrRecords) {
 NSString *where = [NSString stringWithFormat:@"messageId=%lld AND studentId=%lld",(long long)messageInfo.id_p,[AppCache sharedCache].studentInfo.id_p];
 RLMResults *messageResults = [RHDBSchoolMessage objectsWhere:where];
 if (messageResults.count == 0) {
 RHDBSchoolMessage *message = [[RHDBSchoolMessage alloc]init];
 message.messageId = messageInfo.id_p;
 message.studentId = weakSelf.studetnId;
 [realm addObject:message];
 }
 }
 [realm commitWriteTransaction];

 重新插入
 + (void)saveSchoolInfoToDB:(RHSchoolInfo *)schoolInfo{
 NSDictionary *dic = [schoolInfo mj_keyValues];
 RHDBSchoolInfo *dbSchoolInfo = [RHDBSchoolInfo mj_objectWithKeyValues:dic];
 //#warning -- Static Url warning
 ////    dbSchoolInfo.domainName = @"10.10.2.90:8092";
 RLMRealm *realm = [RLMRealm defaultRealm];
 [realm beginWriteTransaction];
 RLMResults *allObj = [RHDBSchoolInfo allObjects];
 [realm deleteObjects:allObj];
 
 [realm addOrUpdateObject:dbSchoolInfo];
 [realm commitWriteTransaction];
 }
 
 删除
 
 NSString *where = [NSString stringWithFormat:@"messageId=%lld AND studentId=%lld",(long long)ids.deleteId,[AppCache sharedCache].studentInfo.id_p];
 RLMResults *message = [RHDBSchoolMessage objectsWhere:where];
 RLMRealm *realm = [RLMRealm defaultRealm];
 for (RHDBSchoolMessage *schoolMessage in message) {
 [realm transactionWithBlock:^{
 [realm deleteObject:schoolMessage];
 }];
 }
 
 //数据库查找已读记录
 - (Boolean)findMessageWithMessageId:(int64_t)messageId{
 NSString *where = [NSString stringWithFormat:@"messageId=%lld AND studentId=%lld",messageId,self.studetnId];
 RLMResults *message = [RHDBSchoolMessage objectsWhere:where];
 if(message.count>0){
 return true;
 }else{
 return false;
 }
 }
 
 */
