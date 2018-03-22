//
//  CustomPickerView.m
//  RecruitmentHallStudentSide
//
//  Created by bestsep on 2017/10/23.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import "CustomPickerView.h"

@interface CustomPickerView() <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *politicsStatusArr;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSArray *certificateArr;
@property (nonatomic, strong) NSArray *skillArr;

@property (nonatomic, strong) NSArray *companyTypeArr;//企业类型
@property (nonatomic, strong) NSArray *companyScopeArr;//企业规模
@property (nonatomic, strong) NSArray *educationArr;//学历要求
@property (nonatomic, strong) NSArray *experienceArr;//经验要求
@property (nonatomic, strong) NSArray *monthlySalaryArr;//月薪范围

@property (nonatomic, strong) NSArray *firArr;
@property (nonatomic, strong) NSArray *secArr;
@property (nonatomic, strong) NSArray *thiArr;
@property (nonatomic, assign) NSInteger firSelectIndex;
@property (nonatomic, assign) NSInteger secSelectIndex;
@property (nonatomic, assign) NSInteger thiSelectIndex;

@end

@implementation CustomPickerView

+ (CustomPickerView *)shareCustomPickerView {
    static CustomPickerView * customPickerView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        customPickerView = [[self alloc] init];
    });
    return customPickerView;
}

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CustomPickerView" owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, UIScreenWidth, 261);
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.numberOfComponents = 0;
    self.firSelectIndex = 0;
    self.secSelectIndex = 0;
    self.thiSelectIndex = 0;
    self.politicsStatusArr = [NSArray arrayWithObjects:@"中共党员",@"共青团员",@"群众", nil];
    self.certificateArr = [NSArray arrayWithObjects:@"院级",@"校级",@"省级",@"国家级", nil];
    self.skillArr = [NSArray arrayWithObjects:@"了解",@"入门",@"熟练",@"精通", nil];
    self.educationArr = [NSArray arrayWithObjects:@"学历不限",@"大专",@"本科",@"硕士",@"博士", nil];
    self.experienceArr = [NSArray arrayWithObjects:@"经验不限",@"应届生",@"1-3年",@"3-5年",@"5-10年",@"10年以上", nil];
    self.monthlySalaryArr = [NSArray arrayWithObjects:@"面议",@"1k-2k",@"2k-4k",@"4k-6k",@"6k-8k",@"8k-10k",@"10k-15k",@"15k-20k",@"20k-25k",@"25k-50k",@"50k以上", nil];
    [self initTime];
}

- (IBAction)didSelectCancleSelectedBtn:(UIButton *)sender {
//    self.hidden = YES;
}

- (IBAction)didSelectedSureBtn:(UIButton *)sender {
//    self.hidden = YES;
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    if (_firArr.count) {
        [dataArr addObject:_firArr[_firSelectIndex]];
    }
    if (_secArr.count) {
        [dataArr addObject:_secArr[_secSelectIndex]];
    }
    if (_thiArr.count) {
        [dataArr addObject:_thiArr[_thiSelectIndex]];
    }
    self.selectedPickerData([dataArr copy], self.pickerViewType);
}

//是否滑动停止
- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)setPickerViewType:(ShowPickerViewType)pickerViewType {
    _pickerViewType = pickerViewType;
    switch (pickerViewType) {
        case ShowPickerViewTypeOfJiGuan:
            self.showTitleLabel.text = @"选择省市";
            self.numberOfComponents = 2;
            self.firSelectIndex = 0;
            self.secSelectIndex = 0;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfXianJuDi:
            self.showTitleLabel.text = @"选择省市";
            self.numberOfComponents = 2;
            self.firSelectIndex = 0;
            self.secSelectIndex = 0;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfPoliticsStatus:
            self.showTitleLabel.text = @"选择政治面貌";
            _firArr = [_politicsStatusArr copy];
            _secArr = nil;
            _thiArr = nil;
            self.numberOfComponents = 1;
            break;
        case ShowPickerViewTypeOfCertificate:
            self.showTitleLabel.text = @"选择证书等级";
            _firArr = [_certificateArr copy];
            _secArr = nil;
            _thiArr = nil;
            self.numberOfComponents = 1;
            break;
        case ShowPickerViewTypeOfSkill:
            self.showTitleLabel.text = @"选择技能熟练度";
            _firArr = [_skillArr copy];
            _secArr = nil;
            _thiArr = nil;
            self.numberOfComponents = 1;
            break;
        case ShowPickerViewTypeOfTime:
            self.showTitleLabel.text = @"选择出生日期";
            self.numberOfComponents = 3;
            _firArr = [_timeArr[0] copy];
            _secArr = [_timeArr[1] copy];;
            _thiArr = [_timeArr[2] copy];;
            break;
        case ShowPickerViewTypeOfCompanyType:
            self.showTitleLabel.text = @"请选择企业类型";
            self.numberOfComponents = 1;
            _firArr = [_companyTypeArr copy];
            _secArr = nil;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfCompanyScope:
            self.showTitleLabel.text = @"请选择企业规模";
            self.numberOfComponents = 1;
            _firArr = [_companyScopeArr copy];
            _secArr = nil;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfEducation:
            self.showTitleLabel.text = @"请选择学历要求";
            self.numberOfComponents = 1;
            _firArr = [_educationArr copy];
            _secArr = nil;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfExperience:
            self.showTitleLabel.text = @"请选择经验要求";
            self.numberOfComponents = 1;
            _firArr = [_experienceArr copy];
            _secArr = nil;
            _thiArr = nil;
            break;
        case ShowPickerViewTypeOfMonthlySalary:
            self.showTitleLabel.text = @"请选择月薪范围";
            self.numberOfComponents = 1;
            _firArr = [_monthlySalaryArr copy];
            _secArr = nil;
            _thiArr = nil;
            break;
        default:
            break;
    }
    [self.pickerView reloadAllComponents];
}

- (void)reSetData {
    self.pickerViewType = _pickerViewType;
    [self.pickerView reloadAllComponents];
}

#pragma mark - initTime

- (void)initTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSInteger currentYear = [dateTime integerValue];
    
    NSMutableArray *yearArr = [NSMutableArray array];
    for (int year = 1900; year <= currentYear; year ++) {
        NSString *str = [NSString stringWithFormat:@"%d年", year];
        [yearArr addObject:str];
    }
    
    NSMutableArray *monthArr = [NSMutableArray array];
    for (int month = 1; month <= 12; month ++) {
        NSString *str = [NSString stringWithFormat:@"%02d月", month];
        [monthArr addObject:str];
    }
    
    NSMutableArray *dayArr = [NSMutableArray array];
    for (int day = 1; day <= 31; day++) {
        NSString *str = [NSString stringWithFormat:@"%02d日", day];
        [dayArr addObject:str];
    }
    
    _timeArr = [NSArray arrayWithObjects:yearArr, monthArr, dayArr, nil];
}

//判断每个月有多少天
- (NSInteger)howManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
        return 28;
    if(year % 400 == 0)
        return 29;
    if(year % 100 == 0)
        return 28;
    return 29;
}

#pragma mark - 已经选中后第一次默认跳转选中的
- (void)setDefaultSelectedArr:(NSArray *)defaultSelectedArr {
    _defaultSelectedArr = defaultSelectedArr;
    self.numberOfComponents = defaultSelectedArr.count;
    NSArray *dataSource;
    for (int i = 0; i < defaultSelectedArr.count; i ++) {
        if (i == 0) {
            dataSource = [_firArr copy];
        } else if (i == 1) {
            dataSource = [_secArr copy];
        } else if (i == 2) {
            dataSource = [_thiArr copy];
        }
        [self selectInComponent:i filterString:defaultSelectedArr[i] dataSource:dataSource animated:NO];
    }
    [self.pickerView reloadAllComponents];
}

- (void)selectInComponent:(NSInteger)inComponent filterString:(NSString *)filterString dataSource:(NSArray *)dataSource animated:(BOOL)animated {
    NSInteger selectRow = 0;
    for (int i = 0; i < dataSource.count; i ++) {
        if ([dataSource[i] isEqualToString:filterString]) {
            selectRow = i;
            break;
        }
    }
    [self.pickerView selectRow:selectRow inComponent:inComponent animated:animated];
    if (inComponent == 0) {
        self.firSelectIndex = selectRow;
    } else if (inComponent == 1) {
        self.secSelectIndex = selectRow;
    } else if (inComponent == 2) {
        self.thiSelectIndex = selectRow;
    }
}

#pragma mark - UIPickerViewDataSource

// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfComponents;
}

// 返回每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rowCount = 0;
    if (component == 0) {
        rowCount = _firArr.count;
    } else if (component == 1) {
        rowCount = _secArr.count;
    } else if (component == 2) {
        if (_pickerViewType == ShowPickerViewTypeOfTime) {
            rowCount = [self howManyDaysInThisYear:self.firSelectIndex + 1 withMonth:self.secSelectIndex + 1];
            if (_thiSelectIndex >= rowCount) {
                _thiSelectIndex = rowCount - 1;
                [_pickerView reloadComponent:2];
            }
        } else {
            rowCount = _thiArr.count;
        }
    }
    return rowCount;
}

#pragma mark - UIPickerViewDelegate

// 返回每行的标题
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitle = @"";
    if (component == 0) {
        showTitle = _firArr[row];
    } else if (component == 1) {
        showTitle = _secArr[row];
    } else if (component == 2) {
        showTitle = _thiArr[row];
    }
    return showTitle;
}
// 选中行显示在label上
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _firSelectIndex = row;
        [_pickerView reloadAllComponents];
    } else if (component == 1) {
        _secSelectIndex = row;
        [_pickerView reloadAllComponents];
    } else if (component == 2) {
        _thiSelectIndex = row;
        [_pickerView reloadAllComponents];
    }
    NSLog(@"选中停止");
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = UIColorFromHexColor(0XEEEEEE);
        }
    }
    
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = (UILabel*)view;
    
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextColor:UIColorFromHexColor(0X909090)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
    }
    // Fill the label text here
    
    //重写 - (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED; 方法加载title
    
    //pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    if (component == 0) {
        if (row == _firSelectIndex) {
            /*选中后的row的字体颜色*/
            /*重写- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; 方法加载 attributedText*/
            [pickerLabel setFont:[UIFont systemFontOfSize:19.0f]];
            pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:_firSelectIndex forComponent:component];
        } else {
            pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        }
    } else if (component == 1) {
        if (row == _secSelectIndex){
            [pickerLabel setFont:[UIFont systemFontOfSize:19.0f]];
            pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:_secSelectIndex forComponent:component];
        } else {
            pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        }
    } else if (component == 2) {
        if (row == _thiSelectIndex) {
            [pickerLabel setFont:[UIFont systemFontOfSize:19.0f]];
            pickerLabel.attributedText  = [self pickerView:pickerView attributedTitleForRow:_thiSelectIndex forComponent:component];
        } else {
            pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        }
    }
    return pickerLabel;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitle = @"";
    if (component == 0) {
        showTitle = _firArr[row];
    } else if (component == 1) {
        showTitle = _secArr[row];
    } else if (component == 2) {
        showTitle = _thiArr[row];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:showTitle];
    NSRange range = [showTitle rangeOfString:showTitle];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromHexColor(0X1AA0F8) range:range];
    return attributedString;
}

@end
