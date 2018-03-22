//
//  RHDeviceAuthTool.m
//  RecruitmentHallStudentSide
//
//  Created by baoshuguang on 2017/7/10.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import "RHDeviceAuthTool.h"
#import "WWHUD.h"

@implementation RHDeviceAuthTool

+ (void)photoAuth:(CamAuthResutlBlock)resultBlock{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status){
            
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self photoAuth:resultBlock];
                });
            }];
            break;
        }
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied: {
            [WWHUD showLoadingWithErrorText:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的照片" inView:KeyWindow afterDelay:2];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            resultBlock();
            break;
        }
    }
}

+ (void)camAuth:(CamAuthResutlBlock)resultBlock{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        //第一次用户接受
                        resultBlock();
                    }else{
                        //用户拒绝
                        [WWHUD showLoadingWithErrorText:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机" inView:KeyWindow afterDelay:2];
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            resultBlock();
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            [WWHUD showLoadingWithErrorText:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机" inView:KeyWindow afterDelay:2];
            break;
        default:
            break;
    }
}

@end
