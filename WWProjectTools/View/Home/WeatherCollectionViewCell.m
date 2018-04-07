//
//  WeatherCollectionViewCell.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/6.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "NSDate+Addition.h"

@interface WeatherCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *condTxtDLabel;
@property (weak, nonatomic) IBOutlet UIImageView *condCodeDImageView;
@property (weak, nonatomic) IBOutlet UIImageView *condCodeNImageView;
@property (weak, nonatomic) IBOutlet UILabel *condTxtNLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirLabel;
@property (weak, nonatomic) IBOutlet UILabel *windScLabel;


@end

@implementation WeatherCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentWithDailyForeCast:(WDailyForecast *)dailyForeCast {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *resDate = [formatter dateFromString:dailyForeCast.date];
    NSString *weekDay;
    if ([NSDate isSameDay:[NSDate date] date2:resDate]) {
        weekDay = @"今天";
    } else {
        weekDay = [resDate weekDay];
    }
    self.weekDayLabel.text = weekDay;
    NSArray *dateArr = [dailyForeCast.date componentsSeparatedByString:@"-"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@/%@",dateArr[1],dateArr[2]];
    self.condTxtDLabel.text = dailyForeCast.cond_txt_d;
    self.condCodeDImageView.image = [UIImage imageNamed:dailyForeCast.cond_code_d];
    self.condCodeNImageView.image = [UIImage imageNamed:dailyForeCast.cond_code_n];
    self.condTxtNLabel.text = dailyForeCast.cond_txt_n;
    self.windDirLabel.text = dailyForeCast.wind_dir;
    self.windScLabel.text = [NSString stringWithFormat:@"%@级",dailyForeCast.wind_sc];
}

@end
