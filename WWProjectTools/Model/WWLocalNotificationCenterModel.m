//
//  WWLocalNotificationCenterModel.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWLocalNotificationCenterModel.h"
#import <UserNotifications/UserNotifications.h>

@implementation WWLocalNotificationCenterModel

- (void)setNotification {
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = self.time;//[NSString localizedUserNotificationStringForKey:@"本地推送Title" arguments:nil];
    content.body = self.content;//[NSString localizedUserNotificationStringForKey:@"本地推送Body" arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    // 在 设定时间 后推送本地推送
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:self.alertTime repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:self.time
                                                                          content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"推送添加成功");
    }];
}

/*
 // 1.创建通知内容
 UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
 content.title = @"徐不同测试通知";
 content.subtitle = @"测试通知";
 content.body = @"来自徐不同的简书";
 content.badge = @1;
 NSError *error = nil;
 NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_certification_status1@2x" ofType:@"png"];
 // 2.设置通知附件内容
 UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
 if (error) {
 NSLog(@"attachment error %@", error);
 }
 content.attachments = @[att];
 content.launchImageName = @"icon_certification_status1@2x";
 // 2.设置声音
 UNNotificationSound *sound = [UNNotificationSound defaultSound];
 content.sound = sound;
 
 // 3.触发模式
 UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
 
 // 4.设置UNNotificationRequest
 NSString *requestIdentifer = @"TestRequest";
 UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger1];
 
 //5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
 [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
 }];
 
 作者：徐不同
 链接：https://www.jianshu.com/p/3d602a60ca4f
 來源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

@end
