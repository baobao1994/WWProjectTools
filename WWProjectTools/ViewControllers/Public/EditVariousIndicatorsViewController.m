//
//  EditVariousIndicatorsViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditVariousIndicatorsViewController.h"
#import "YLTagsChooser.h"
#import "YLTag.h"
#import "CustomPickerView.h"
#import "CustomKeyWindowView.h"
#import "UIView+Addtion.h"
#import "UIViewController+Addition.h"
#import "EditVariousIndicatorsViewModel.h"
#import "NSDate+Addition.h"

@interface EditVariousIndicatorsViewController ()<YLTagsChooserDelegate>

@property (nonatomic, strong) NSArray *moodArr;
@property (nonatomic, strong) NSArray *physicalStateArr;
@property (nonatomic, strong) CustomKeyWindowView *showView;
@property (nonatomic, strong) CustomPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *weightButton;
@property (weak, nonatomic) IBOutlet UIButton *moodButton;
@property (weak, nonatomic) IBOutlet UIButton *physicalStateButton;
@property (weak, nonatomic) IBOutlet UIButton *publicTimeButton;
@property (weak, nonatomic) IBOutlet QMUITextView *noteTextView;
@property (nonatomic, copy) NSString *weightStr;
@property (nonatomic, copy) NSString *moodStr;
@property (nonatomic, copy) NSString *physicalStateStr;
@property (nonatomic, assign) BOOL isMoodType;
@property (nonatomic, strong) EditVariousIndicatorsViewModel *viewModel;
@property (nonatomic, copy) NSString *publicTime;

@end

@implementation EditVariousIndicatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布基本数值";
    [self setUp];
    [self createNavigationRightItemWithTitle:@"发布"];
    [self bind];
}

- (void)setUp {
    self.moodArr = @[@"非常好",@"很好",@"一般",@"差"];
    self.physicalStateArr = @[@"腰酸",@"头痛",@"感冒",@"发烧",@"其它"];
    self.weightStr = @"50.00";
    self.moodStr = @"非常好";
    self.physicalStateStr = @"无异常";
    self.noteTextView.text = @"无异常";
    [self.moodButton setCornerRadius:5];
    [self.weightButton setCornerRadius:5];
    [self.physicalStateButton setCornerRadius:5];
    [self.publicTimeButton setCornerRadius:5];
    self.showView = [[CustomKeyWindowView alloc] init];
    [self.showView setCustomContentView:self.pickerView backGroundColor:[UIColor blackColor] Alpha:0.5];
    self.viewModel = [[EditVariousIndicatorsViewModel alloc] init];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *dateString = [nowDate formateDate:@"yyyy-MM-dd"];
    self.publicTime = [nowDate formateDate:@"yyyy-MM-dd HH:mm"];
    [self.publicTimeButton setTitle:[NSString stringWithFormat:@"发布时间:%@",dateString] forState:UIControlStateNormal];
}

- (void)selectedNavigationRightItem:(id)sender {
    self.viewModel.weight = self.weightStr;
    self.viewModel.mood = self.moodStr;
    self.viewModel.physicalState = self.physicalStateStr;
    self.viewModel.note = self.noteTextView.text;
    self.viewModel.publicTime = self.publicTime;
    [[self.viewModel publicEditVariousIndicatorsCommand] execute:nil];
}

- (void)bind {
    kWeakSelf;
    [[self.weightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSArray *weightArr = [weakSelf.weightStr componentsSeparatedByString:@"."];
        weakSelf.pickerView.pickerViewType = ShowPickerViewTypeOfWeight;
        weakSelf.pickerView.defaultSelectedArr = @[weightArr[0],@".",weightArr[1]];
        [weakSelf.showView showDirection:DirectionTypeOfTop animateWithDuration:0.35];
    }];
    [[self.publicTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *timeString = [weakSelf.publicTimeButton.titleLabel.text substringFromIndex:5];
        NSArray *timeArr = [timeString componentsSeparatedByString:@"-"];
        weakSelf.pickerView.pickerViewType = ShowPickerViewTypeOfTime;
        weakSelf.pickerView.defaultSelectedArr = @[[NSString stringWithFormat:@"%@年",timeArr[0]],
                                                       [NSString stringWithFormat:@"%@月",timeArr[1]],
                                                       [NSString stringWithFormat:@"%@日",timeArr[2]]];
        [weakSelf.showView showDirection:DirectionTypeOfTop animateWithDuration:0.35];
    }];
    [[self.moodButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakSelf.isMoodType = YES;
        [weakSelf showChooseTagsMaxSelectCount:1 dataArr:weakSelf.moodArr sectionTitltArr:@[@"心情"]];
    }];
    [[self.physicalStateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        weakSelf.isMoodType = NO;
        [weakSelf showChooseTagsMaxSelectCount:5 dataArr:weakSelf.physicalStateArr sectionTitltArr:@[@"身体状态"]];
    }];
    [[self.viewModel.publicEditVariousIndicatorsCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [WWHUD showLoadingWithText:@"上传中" inView:NavigationControllerView afterDelay:CGFLOAT_MAX];
        [x subscribeNext:^(id x) {
            [WWHUD hideAllTipsInView:NavigationControllerView];
            [WWHUD showLoadingWithText:@"发布成功" inView:NavigationControllerView afterDelay:1];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self.viewModel.publicEditVariousIndicatorsCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD hideAllTipsInView:NavigationControllerView];
        [WWHUD showLoadingWithErrorInView:NavigationControllerView afterDelay:2];
    }];
}

- (void)showChooseTagsMaxSelectCount:(NSInteger)maxSelectCount dataArr:(NSArray *)dateArr sectionTitltArr:(NSArray *)sectionTitltArr {
    YLTagsChooser *chooser = [[YLTagsChooser alloc] initWithBottomHeight:261 maxSelectCount:maxSelectCount delegate:self];
    chooser.maxSelectCount = maxSelectCount;
    NSMutableArray *orignDataArray = [NSMutableArray array];
    NSInteger count = dateArr.count;
    NSMutableArray *moodTags = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *selectedTagArr = [[NSMutableArray alloc] init];
    NSArray *selectedArr;
    if (self.isMoodType) {
        selectedArr = @[self.moodStr];
    } else {
        selectedArr = [self.physicalStateStr componentsSeparatedByString:@","];
    }
    for(NSInteger i = 0; i < count; i++){
        YLTag *tag = [[YLTag alloc]initWithId:i name:dateArr[i]];
        [moodTags addObject:tag];
        for (NSString *tagStr in selectedArr) {
            if ([tag.name isEqualToString:tagStr]) {
                [selectedTagArr addObject:tag];
                break;
            }
        }
    }
    [orignDataArray addObject:moodTags];
    chooser.sectionHeadTitleArr = sectionTitltArr;
    [chooser showInView:self.view];
    [chooser refreshWithTags:orignDataArray selectedTags:selectedTagArr];
}

#pragma mark---YLTagsChooserDelegate
- (void)tagsChooser:(YLTagsChooser *)sheet selectedTags:(NSArray *)sTags {
    NSString *tagStr = [sTags componentsJoinedByString:@","];
    if (self.isMoodType) {
        self.moodStr = tagStr;
        [self.moodButton setTitle:[NSString stringWithFormat:@"心情:%@",tagStr] forState:UIControlStateNormal];
    } else {
        if (sTags.count == 0) {
            tagStr = @"无异常";
        }
        self.physicalStateStr = tagStr;
        self.noteTextView.text = tagStr;
        [self.physicalStateButton setTitle:[NSString stringWithFormat:@"身体状态:%@",tagStr] forState:UIControlStateNormal];
        if ([tagStr containsString:@"其它"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.noteTextView becomeFirstResponder];
            });
        }
    }
}

- (CustomPickerView *)pickerView {
    if (!_pickerView) {
        kWeakSelf;
        _pickerView = [CustomPickerView shareCustomPickerView];
        [[_pickerView.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.showView hide];
        }];
        [[_pickerView.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.showView hide];
        }];
        _pickerView.numberOfComponents = 3;
        _pickerView.pickerViewType = ShowPickerViewTypeOfWeight;
        [_pickerView setSelectedPickerData:^(NSArray *selectedArr, ShowPickerViewType pickerViewType) {
            if (pickerViewType == ShowPickerViewTypeOfWeight) {
                NSMutableString *choseString = [[NSMutableString alloc] init];
                for (NSString *choose in selectedArr) {
                    [choseString appendString:choose];
                }
                weakSelf.weightStr = choseString;
                [weakSelf.weightButton setTitle:[NSString stringWithFormat:@"体重:%@",choseString] forState:UIControlStateNormal];
            } else {
                [weakSelf.publicTimeButton setTitle:[NSString stringWithFormat:@"发布时间:%ld-%02ld-%02ld",
                                                     [selectedArr[0] integerValue],
                                                     [selectedArr[1] integerValue],
                                                     [selectedArr[2] integerValue]]
                                           forState:UIControlStateNormal];
                weakSelf.publicTime = [NSString stringWithFormat:@"%@-%@-%@ 00:00",selectedArr[0],selectedArr[1],selectedArr[2]];
            }
        }];
    }
    return _pickerView;
}

@end
