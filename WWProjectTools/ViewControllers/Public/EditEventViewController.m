//
//  EditEventViewController.m
//  WWProjectTools
//
//  Created by baobao on 2018/4/1.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditEventViewController.h"
#import "UIViewController+Addition.h"
#import "UIView+Addtion.h"
#import "NSDate+Addition.h"
#import "EditEventViewModel.h"

@interface EditEventViewController ()<QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet QMUITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *remindTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *isRemindSwitch;
@property (nonatomic, strong) EditEventViewModel *viewModel;
@property (nonatomic, copy) NSString *remindTime;
@property (nonatomic, strong) UIDatePicker *datePicker;

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
    self.viewModel.isRemind = self.isRemindSwitch.on;
    self.viewModel.title = self.titleTextField.text;
    self.viewModel.remindTime = self.remindTime;
    [[self.viewModel publicEditEventCommand] execute:nil];
}

- (void)setUp {
    self.isRemindSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.isRemindSwitch.on = YES;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self setMinTime];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    self.remindTextField.inputView = self.datePicker;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    //设置工具条的颜色
    toolbar.barTintColor = UIColorFromHexColor(0XF7F7F7);
    //设置工具条的frame
    toolbar.frame=CGRectMake(0, 0, UIScreenWidth, 44);
    
    //给工具条添加按钮
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleClick)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    
    toolbar.items = @[item0, item1, item2];
    //设置文本输入框键盘的辅助视图
    self.remindTextField.inputAccessoryView = toolbar;
    
    self.viewModel = [[EditEventViewModel alloc] init];
    self.viewModel.isRemind = YES;
    self.contentTextView.delegate = self;
    self.contentTextView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.contentTextView.autoResizable = YES;
    self.contentTextView.returnKeyType = UIReturnKeyDone;
    self.contentTextView.enablesReturnKeyAutomatically = YES;
    self.contentTextView.maximumTextLength = NSUIntegerMax;
    NSString *dateString;
    if (self.remindDate) {//从日历点击进来
        dateString = [self.remindDate formateDate:@"yyyy-MM-dd HH:mm"];
        NSDate *nextDate = [self.remindDate dateByAddingTimeInterval:60*60*8];//顺延8小时
        dateString = [nextDate formateDate:@"yyyy-MM-dd HH:mm"];
    } else {
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:60*60*8];//顺延8小时
        dateString = [nowDate formateDate:@"yyyy-MM-dd HH:mm"];
    }
    self.remindTime = dateString;
    self.remindTextField.text = self.remindTime;
}

- (void)setMinTime {
    long long dateTime = [[NSDate date] timeIntervalSince1970];
    dateTime += 60 * 60 * 8;
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:dateTime];
    self.datePicker.minimumDate = date;
}

- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSLog(@"dateChanged响应事件：%@",date);
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    self.remindTime = dateString;
}

- (void)cancleClick {
    [self.remindTextField resignFirstResponder];
}

- (void)sureClick {
    [self.remindTextField resignFirstResponder];
    self.remindTextField.text = self.remindTime;
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

@end
