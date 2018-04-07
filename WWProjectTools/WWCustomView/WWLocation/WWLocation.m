//
//  WWLocation.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/7.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface WWLocation ()<CLLocationManagerDelegate>

/** 记录要执行的代码块 */
@property (nonatomic, copy) ResultBlock block;
/**  位置管理者 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/** 地理编码器 */
@property (nonatomic, strong) CLGeocoder *geocoder;
//位置信息更新最小距离，只有移动大于这个距离才更新位置信息，默认为kCLDistanceFilterNone：不进行距离限制
@property(assign, nonatomic) CLLocationDistance distanceFilter;
/*
 定位精确度
 kCLLocationAccuracyBestForNavigation 最适合导航
 kCLLocationAccuracyBest; 最精确定位
 kCLLocationAccuracyNearestTenMeters; 十米误差
 kCLLocationAccuracyHundredMeters; 百米误差
 kCLLocationAccuracyKilometer; 千米误差
 kCLLocationAccuracyThreeKilometers; 三千米误差
 注：精确度越高越耗电，而且定位时间越长
 */
@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;

@end

@implementation WWLocation

+ (WWLocation *)locationManager {
    static WWLocation *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[WWLocation alloc] init];
        location.locationManager = [[CLLocationManager alloc] init];
//        location.locationManager.delegate = location;
        location.geocoder = [[CLGeocoder alloc] init];
        //判断定位功能是否打开
        if ([CLLocationManager locationServicesEnabled]) {
            location.locationManager = [[CLLocationManager alloc] init];
            location.locationManager.distanceFilter = 10000;//10KM
            location.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            [location.locationManager requestAlwaysAuthorization];
        }
    });
    return location;
}

- (void)getCurrentLocation:(ResultBlock)block {
    self.block = block;
    //定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }else {
        self.block(nil, nil, @"定位服务没有开启");
    }
}

#pragma mark CoreLocation delegate

//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"打开定位" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL options:[NSDictionary dictionaryWithObject:@"" forKey:@""] completionHandler:nil];
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    /*
     location.coordinate;  //经纬度
     location.altitude; //海拔
     location.horizontalAccuracy;  //如果是负值，代表当前位置数据不可用
     location.verticalAccuracy; //如果是负值，代表当前海拔数据不可用
     location.course; //航向（0.0-359.9）
     location.speed; //速度
     location.floor; //楼层
     */
    //反编码
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = placemarks[0];
        if (placemarks.count > 0) {
            self.block(placeMark.location, placeMark, nil);
//            currentCity = placeMark.locality;
//            if (!currentCity) {
//                currentCity = @"无法定位当前城市";
//            }
//            NSLog(@"%@",currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
            self.block(placeMark.location, nil, error.localizedDescription);
        } else if (error) {
            NSLog(@"location error: %@ ",error);
            self.block(placeMark.location, nil, error.localizedDescription);
        }
        
    }];
}

/** 改变授权状态时激发 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    /*
     授权状态
     kCLAuthorizationStatusNotDetermined = 0,  用户未决定
     kCLAuthorizationStatusRestricted, 受限制
     kCLAuthorizationStatusDenied, 被拒绝
     kCLAuthorizationStatusAuthorizedAlways 前后台定位授权
     kCLAuthorizationStatusAuthorizedWhenInUse 前台定位授权
     */
    
    //判断当前设备是否支持定位，是否已经开启定位服务
    if (status == kCLAuthorizationStatusDenied && ![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务未开启");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"用户拒绝");
        //提醒用户授权,通过方法直接达到设置界面
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] openURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    } else {
        NSLog(@"定位服务开启");
    }
}

@end
