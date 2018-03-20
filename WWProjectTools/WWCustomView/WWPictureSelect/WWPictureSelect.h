//
//  WWPictureSelect.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWPictureSelect : NSObject
/*
    可以选择多少张，默认9张
 */
@property (nonatomic, assign) NSInteger maxSelectedImageCount;
/*
    基类的控制器，必传
 */
@property (nonatomic, strong) UIViewController *showViewController;
/*
    返回选择的图片
 */
@property (nonatomic, copy) void (^selectImages)(NSMutableArray * imagesArr);

- (instancetype)initWithController:(UIViewController *)controller;

- (void)presentAlbumViewControllerWithTitle:(NSString *)title;

@end
