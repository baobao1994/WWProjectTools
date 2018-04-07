//
//  WeatherCollectionViewCell.h
//  WWProjectTools
//
//  Created by baobao on 2018/4/6.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherBasicModel.h"

@interface WeatherCollectionViewCell : UICollectionViewCell

- (void)setContentWithDailyForeCast:(WDailyForecast *)dailyForeCast;

@end
