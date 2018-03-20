//
//  MotherNoteTableViewCell.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MotherNoteTableViewCell.h"
#import <ESPictureBrowser/ESPictureBrowser.h>
#import <YYImage/YYAnimatedImageView.h>
#import <YYWebImage/YYWebImage.h>
#import "MotherNoteModel.h"

@interface MotherNoteTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ESPictureBrowserDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (nonatomic, strong) NSArray *photosArr;

@end

@implementation MotherNoteTableViewCell

- (void) setContent:(MotherNoteModel *)noteModel {
    self.noteLabel.text = noteModel.note;
    self.photosArr = [[NSArray alloc] initWithArray:noteModel.photos];
    NSInteger count = (NSInteger)(noteModel.photos.count - 1) < 0? 1:noteModel.photos.count - 1;
    NSInteger rowCount = count / 3 + 1;
    self.collectionHeightConstraint.constant = ((UIScreenWidth - 43.5 - 45) / 3) * rowCount + 20 + rowCount * 10;
    [self.collectionView reloadData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StaticImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell class]) forIndexPath:indexPath];
    [cell.itemImageView yy_setImageWithURL:[NSURL URLWithString:self.photosArr[indexPath.row]] placeholder:nil];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UIScreenWidth - 43.5 - 20) / 3, (UIScreenWidth - 43.5 - 45) / 3);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(UIScreenWidth, CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(UIScreenWidth, CGFLOAT_MIN);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
    [browser setDelegate:self];
    [browser setLongPressBlock:^(NSInteger index) {
        NSLog(@"%zd", index);
    }];
    [browser showFromView:collectionView picturesCount:self.photosArr.count currentPictureIndex:indexPath.row];
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    return [self.photosArr objectAtIndex:index];
}

@end
