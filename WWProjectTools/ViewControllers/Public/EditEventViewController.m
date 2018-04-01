//
//  EditEventViewController.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditEventViewController.h"
#import "CustomPickerView.h"
#import "CustomKeyWindowView.h"
#import "UIViewController+Addition.h"
#import "UIView+Addtion.h"
#import "NSDate+Addition.h"
#import "EditEventViewModel.h"

@interface EditEventViewController ()<QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet QMUITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *publicTimeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
@property (nonatomic, strong) CustomKeyWindowView *showView;
@property (nonatomic, strong) CustomPickerView *pickerView;
@property (nonatomic, strong) EditEventViewModel *viewModel;
@property (nonatomic, copy) NSString *publicTime;

@end

@implementation EditEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编写记事";
    [self setUp];
    [self bind];
    [self createNavigationRightItemWithTitle:@"发布"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectedNavigationRightItem:(id)sender {
    self.viewModel.content = self.contentTextView.text;
    self.viewModel.publicTime = self.publicTime;
    [[self.viewModel publicEditEventCommand] execute:nil];
}

- (void)setUp {
    [self.publicTimeButton setCornerRadius:5];
    self.viewModel = [[EditEventViewModel alloc] init];
    self.showView = [[CustomKeyWindowView alloc] init];
    self.contentTextView.delegate = self;
    self.contentTextView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.contentTextView.autoResizable = YES;
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    self.contentTextView.enablesReturnKeyAutomatically = YES;
    self.contentTextView.maximumTextLength = NSUIntegerMax;
    [self.showView setCustomContentView:self.pickerView backGroundColor:[UIColor blackColor] Alpha:0.5];
    NSString *dateString;
    if (self.publicDate) {
        dateString = [self.publicDate formateDate:@"yyyy-MM-dd"];
        self.publicTime = [self.publicDate formateDate:@"yyyy-MM-dd HH:mm"];
    } else {
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        dateString = [nowDate formateDate:@"yyyy-MM-dd"];
        self.publicTime = [nowDate formateDate:@"yyyy-MM-dd HH:mm"];
    }
    [self.publicTimeButton setTitle:[NSString stringWithFormat:@"记事时间:%@",dateString] forState:UIControlStateNormal];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect textInputRect = self.contentTextView.frame;
    CGSize textViewSize = [self.contentTextView sizeThatFits:CGSizeMake(textInputRect.size.width, CGFLOAT_MAX)];
    self.contentTextViewHeightConstraint.constant = fmax(40, textViewSize.height) + 15;
}

#pragma mark - <QMUITextViewDelegate>

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmax(40, height);
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)bind {
    kWeakSelf;
    [[self.publicTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *timeString = [weakSelf.publicTimeButton.titleLabel.text substringFromIndex:5];
        NSArray *timeArr = [timeString componentsSeparatedByString:@"-"];
        weakSelf.pickerView.pickerViewType = ShowPickerViewTypeOfTime;
        weakSelf.pickerView.defaultSelectedArr = @[[NSString stringWithFormat:@"%@年",timeArr[0]],
                                                   [NSString stringWithFormat:@"%@月",timeArr[1]],
                                                   [NSString stringWithFormat:@"%@日",timeArr[2]]];
        [weakSelf.showView showDirection:DirectionTypeOfTop animateWithDuration:0.35];
    }];
    
    [[self.viewModel.publicEditEventCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [WWHUD showLoadingWithText:@"上传中" inView:NavigationControllerView afterDelay:CGFLOAT_MAX];
        [x subscribeNext:^(id x) {
            NSNotification *notification =[NSNotification notificationWithName:@"EventNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [WWHUD hideAllTipsInView:NavigationControllerView];
            [WWHUD showLoadingWithText:@"发布成功" inView:NavigationControllerView afterDelay:1];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];

    [self.viewModel.publicEditEventCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD hideAllTipsInView:NavigationControllerView];
        [WWHUD showLoadingWithErrorInView:NavigationControllerView afterDelay:2];
    }];
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

                [weakSelf.publicTimeButton setTitle:[NSString stringWithFormat:@"记事时间:%ld-%02ld-%02ld",
                                                     [selectedArr[0] integerValue],
                                                     [selectedArr[1] integerValue],
                                                     [selectedArr[2] integerValue]]
                                           forState:UIControlStateNormal];
            weakSelf.publicTime = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00",[selectedArr[0] integerValue],[selectedArr[1] integerValue],[selectedArr[2] integerValue]];
            }
        ];
    }
    return _pickerView;
}

@end
