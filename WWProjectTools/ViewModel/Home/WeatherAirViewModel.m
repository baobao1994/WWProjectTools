//
//  WeatherAirViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/4.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherAirViewModel.h"
#import <MJExtension/MJExtension.h>
#import "WeatherAirModel.h"

@implementation WeatherAirViewModel

- (RACCommand *)requestWeatherAirCommand {
    if (_requestWeatherAirCommand == nil) {
        kWeakSelf;
        _requestWeatherAirCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf requestWeatherAirCommandSignal];
        }];
    }
    return _requestWeatherAirCommand;
}

- (RACSignal *)requestWeatherAirCommandSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        NSString *httpArg = @"location=CN101010100";
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@&key=%@", HeWeatherAirUrl, httpArg, HeWeatherIdKey];
        NSURL *url = [NSURL URLWithString: urlStr];
        //1.创建NSURLSession对象（可以获取单例对象）
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据NSURLSession对象创建一个Task
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask *weatherAirDataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
            if (error) {
                NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                [subscriber sendError:error];
            } else {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"responseDict %@",responseDict);
                weakSelf.air_data_statu = [weakSelf airDataDeal:responseDict];
                if (weakSelf.basic_data_statu) {
                    [subscriber sendNext:@"success"];
                    [subscriber sendCompleted];
                } else {
                    NSLog(@"数据解析出错");
                    [subscriber sendError:error];
                }
            }
        }];
        [weatherAirDataTask resume];
        return nil;
    }];
}

- (BOOL)airDataDeal:(NSDictionary *)responseDic {
    NSArray *jsonArr = [responseDic objectForKey:HeWeatherTitleKey];
    NSDictionary *weatherDic;
    if (jsonArr.count) {
        weatherDic = jsonArr[0];
        self.weatherAirModel = [WeatherAirModel mj_objectWithKeyValues:weatherDic];
        return YES;
    } else {
        return NO;
    }
}

@end
