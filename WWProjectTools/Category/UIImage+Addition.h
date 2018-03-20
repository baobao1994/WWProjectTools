//
//  UIImage+Addition.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;
+ (NSData *)zipNSDataWithImage:(UIImage *)sourceImage;

@end
