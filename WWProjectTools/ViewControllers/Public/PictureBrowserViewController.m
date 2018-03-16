//
//  PictureBrowserViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "PictureBrowserViewController.h"
#import <ESPictureBrowser/ESPictureBrowser.h>

@interface PictureBrowserViewController ()<ESPictureBrowserDelegate>

@property (nonatomic, strong) ESPictureBrowser *pictureBrowser;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PictureBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_bg"]];
    self.imageView.frame = CGRectMake(20, 50, 100, 200);
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showBtn:(UIButton *)sender {
    self.pictureBrowser = [[ESPictureBrowser alloc] init];
    self.pictureBrowser.delegate = self;
    [self.pictureBrowser showFromView:self.imageView picturesCount:1 currentPictureIndex:0];
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index { 
    return @"http://cdn.ruguoapp.com/FrRs7n0H32CuagQpANIWBbmHPF-f?imageView2/0/h/1000";
}

@end
