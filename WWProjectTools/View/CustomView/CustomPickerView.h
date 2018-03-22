//
//  CustomPickerView.h
//  RecruitmentHallStudentSide
//
//  Created by bestsep on 2017/10/23.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowPickerViewType) {
    ShowPickerViewTypeOfNone,
    ShowPickerViewTypeOfXianJuDi,//居住地
    ShowPickerViewTypeOfJiGuan,//籍贯
    ShowPickerViewTypeOfPoliticsStatus,//政治面貌
    ShowPickerViewTypeOfTime,//时间
    ShowPickerViewTypeOfCertificate,//证书
    ShowPickerViewTypeOfSkill,//技能
    ShowPickerViewTypeOfCompanyType,//企业类型
    ShowPickerViewTypeOfCompanyScope,//企业规模
    ShowPickerViewTypeOfEducation,//学历
    ShowPickerViewTypeOfExperience,//经验
    ShowPickerViewTypeOfMonthlySalary,//月薪
};

@interface CustomPickerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *showTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, assign) ShowPickerViewType pickerViewType;
@property (nonatomic, strong) NSArray *defaultSelectedArr;
@property (nonatomic, assign) NSInteger numberOfComponents;//列数

@property (nonatomic, copy) void (^selectedPickerData)(NSArray *selectedArr,ShowPickerViewType pickerViewType);

+ (CustomPickerView *)shareCustomPickerView;

- (void)reSetData;

@end
