//
//  WeatherBasicViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/3.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherBasicViewModel.h"
#import <MJExtension/MJExtension.h>
#import "WeatherBasicModel.h"

@implementation WeatherBasicViewModel

- (RACCommand *)requestWeatherBasicCommand {
    if (_requestWeatherBasicCommand == nil) {
        kWeakSelf;
        _requestWeatherBasicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf requestWeatherBasicCommandSignal];
        }];
    }
    return _requestWeatherBasicCommand;
}

//https://www.heweather.com/documents/api/s6/weather api
//https://www.jianshu.com/p/93c242452b9b MJExtension
- (RACSignal *)requestWeatherBasicCommandSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
//        NSString *httpArg = @"location=CN101010100";
        NSString *loction = [NSString stringWithFormat:@"location=%.2lf.%.2lf",weakSelf.longitude,weakSelf.latitude];
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@&key=%@", HeWeatherBasicUrl, loction, HeWeatherIdKey];
        NSURL *url = [NSURL URLWithString: urlStr];
        //1.创建NSURLSession对象（可以获取单例对象）
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据NSURLSession对象创建一个Task
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSessionDataTask * weatherBaiscDataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
            if (error) {
                NSLog(@"Httperror111: %@%ld", error.localizedDescription, error.code);
                [subscriber sendError:error];
            } else {
//                NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"responseDict111 %@",responseDict);
                weakSelf.basic_data_statu = [weakSelf basicDataDeal:responseDict];
                if (weakSelf.basic_data_statu) {
                    [subscriber sendNext:@"success"];
                    [subscriber sendCompleted];
                } else {
                    NSLog(@"数据解析出错");
                    [subscriber sendError:error];
                }
            }
        }];
        [weatherBaiscDataTask resume];
        return nil;
    }];
}

- (BOOL)basicDataDeal:(NSDictionary *)responseDic {
    NSArray *jsonArr = [responseDic objectForKey:HeWeatherTitleKey];
    NSDictionary *weatherDic;
    if (jsonArr.count) {
        weatherDic = jsonArr[0];
        self.weatherModel = [WeatherBasicModel mj_objectWithKeyValues:weatherDic];
//        NSLog(@"ddd = %@",weatherModel);
        return YES;
    } else {
        return NO;
    }
}

@end
