//
//  WeatherViewModel.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/4/3.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherViewModel.h"

@implementation WeatherViewModel

- (RACCommand *)requestWeatherCommand {
    if (_requestWeatherCommand == nil) {
        kWeakSelf;
        _requestWeatherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [weakSelf requestWeatherCommandSignal];
        }];
    }
    return _requestWeatherCommand;
}

//https://www.cnblogs.com/AraragiTsukihi/p/5777505.html
//https://www.heweather.com/documents/api/s6/weather
- (RACSignal *)requestWeatherCommandSignal {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        kWeakSelf;
        NSString *httpArg = @"location=CN101010100";
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@%@&key=%@", HeWeatherUrl, httpArg, HeWeatherIdKey];
        NSURL *url = [NSURL URLWithString: urlStr];
        //1.创建NSURLSession对象（可以获取单例对象）
        NSURLSession *session = [NSURLSession sharedSession];
        //2.根据NSURLSession对象创建一个Task
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //方法参数说明
        /*
         注意：该block是在子线程中调用的，如果拿到数据之后要做一些UI刷新操作，那么需要回到主线程刷新
         第一个参数：需要发送的请求对象
         block:当请求结束拿到服务器响应的数据时调用block
         block-NSData:该请求的响应体
         block-NSURLResponse:存放本次请求的响应信息，响应头，真实类型为NSHTTPURLResponse
         block-NSErroe:请求错误信息
         */
        NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
            if (error) {
                NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                [subscriber sendError:error];
            } else {
                NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"HttpResponseCode:%ld", responseCode);
//                NSLog(@"HttpResponseBody %@",responseString);
                NSLog(@"responseDict %@",responseDict);
                [weakSelf dataDeal:responseDict];
                [subscriber sendNext:@"success"];
                [subscriber sendCompleted];
            }
        }];
        //3.执行Task
        //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
        [dataTask resume];
        return nil;
    }];
}

- (void)dataDeal:(NSDictionary *)responseDic {
    NSArray *jsonArr = [responseDic objectForKey:HeWeatherTitleKey];

}

@end
