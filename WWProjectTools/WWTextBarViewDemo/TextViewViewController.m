//
//  TextViewViewController.m
//  WWProjectDemo
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "TextViewViewController.h"
#import "WWTextInputBarView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TextViewViewController ()

@property (nonatomic, strong) WWTextInputBarView *wwTextView;

@end

@implementation TextViewViewController

- (WWTextInputBarView *)wwTextView {
    if (_wwTextView == nil) {
        _wwTextView = [[WWTextInputBarView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    }
    return _wwTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wwTextView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
