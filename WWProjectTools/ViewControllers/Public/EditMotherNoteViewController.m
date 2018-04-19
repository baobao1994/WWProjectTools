//
//  EditViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditMotherNoteViewController.h"
#import "UIView+Addtion.h"
#import "UIViewController+Addition.h"
#import "StaticImageCollectionViewCell.h"
#import "WWPictureSelect.h"
#import "UIImage+Addition.h"
#import "NSDate+Addition.h"
#import "WWFile.h"
#import "UIView+Addtion.h"
#import "RHDeviceAuthTool.h"
#import "EditMotherNoteViewModel.h"
#import "CustomPickerView.h"
#import "CustomKeyWindowView.h"
#import "NSDate+Addition.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EditMotherNoteViewController ()<QMUITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QMUITextView *textInputView;
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
@property (nonatomic, assign) CGFloat textViewMaximumHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeButton;
@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, strong) WWPictureSelect *pictureSelect;
@property (nonatomic, strong) NSMutableArray *filePathArr;
@property (nonatomic, strong) EditMotherNoteViewModel *viewModel;
@property (nonatomic, strong) CustomPickerView *timePickerView;
@property (nonatomic, strong) CustomKeyWindowView *showView;
@property (nonatomic, copy) NSString *publicTime;

@end

@implementation EditMotherNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布新笔记";
    [self setUp];
    [self bind];
    [self.view addSubview:self.textInputView];
    [self createNavigationRightItemWithTitle:@"发布"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUp {
    self.textViewMinimumHeight = 150;
    self.textViewMaximumHeight = 200;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StaticImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell class])];
    self.photosArr = [[NSMutableArray alloc] init];
    self.filePathArr = [[NSMutableArray alloc] init];
    self.viewModel = [[EditMotherNoteViewModel alloc] init];
    self.showView = [[CustomKeyWindowView alloc] init];
    [self.showView setCustomContentView:self.timePickerView backGroundColor:[UIColor blackColor] Alpha:0.5];
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    if (self.isEdit) {
        nowDate = [NSDate dateWithTimeIntervalSince1970:[self.motherNoteModel.publicTime longLongValue]];
        self.textInputView.text = self.motherNoteModel.note;
        self.photosArr = [[NSMutableArray alloc] initWithArray:self.motherNoteModel.photos];
        self.viewModel.objectId = self.motherNoteModel.objectId;
    }
    NSString *dateString = [nowDate formateDate:@"yyyy-MM-dd"];
    self.publicTime = [nowDate formateDate:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = dateString;
}

- (void)bind {
    kWeakSelf;
    [[self.viewModel.publicEditMotherNoteCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [WWHUD showLoadingWithText:@"上传中" inView:NavigationControllerView afterDelay:CGFLOAT_MAX];
        [x subscribeNext:^(id x) {
            NSNotification *notification = [NSNotification notificationWithName:@"MotherNoteNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [WWHUD hideAllTipsInView:NavigationControllerView];
            [WWHUD showLoadingWithText:@"发布成功" inView:NavigationControllerView afterDelay:1];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self.viewModel.publicEditMotherNoteCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD hideAllTipsInView:NavigationControllerView];
        [WWHUD showLoadingWithErrorInView:NavigationControllerView afterDelay:2];
    }];
    
    [[self.viewModel.updateEidtMotherNoteCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [WWHUD showLoadingWithText:@"上传中" inView:NavigationControllerView afterDelay:CGFLOAT_MAX];
        [x subscribeNext:^(id x) {
            NSNotification *notification = [NSNotification notificationWithName:@"MotherNoteNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [WWHUD hideAllTipsInView:NavigationControllerView];
            [WWHUD showLoadingWithText:@"更新成功" inView:NavigationControllerView afterDelay:1];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
    
    [self.viewModel.updateEidtMotherNoteCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD hideAllTipsInView:NavigationControllerView];
        [WWHUD showLoadingWithErrorInView:NavigationControllerView afterDelay:2];
    }];
    
    [[self.selectTimeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSArray *timeArr = [self.timeLabel.text componentsSeparatedByString:@"-"];
        weakSelf.timePickerView.defaultSelectedArr = @[[NSString stringWithFormat:@"%@年",timeArr[0]],
                                                       [NSString stringWithFormat:@"%@月",timeArr[1]],
                                                       [NSString stringWithFormat:@"%@日",timeArr[2]]];
        [weakSelf.showView showDirection:DirectionTypeOfTop animateWithDuration:0.35];
    }];
}

- (void)selectedNavigationRightItem:(id)sender {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"发布" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
        self.viewModel.note = self.textInputView.text;
        self.viewModel.publicTime = self.publicTime;
        if (self.filePathArr.count) {
            [WWHUD showLoadingWithText:@"上传中" inView:NavigationControllerView afterDelay:CGFLOAT_MAX];
            [BmobFile filesUploadBatchWithPaths:self.filePathArr
                                  progressBlock:^(int index, float progress) {
                                      //index 上传数组的下标，progress当前文件的进度
                                      NSLog(@"index %d progress %f",index,progress);
                                  } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                                      //array 文件数组，isSuccessful 成功或者失败,error 错误信息
                                      //存放文件URL的数组
                                      NSMutableArray *fileArray = [NSMutableArray arrayWithArray:self.photosArr];
                                      
                                      for (int i = 0 ; i < array.count ;i ++) {
                                          BmobFile *file = array [i];
                                          [fileArray addObject:file.url];
                                      }
                                      for (id object in fileArray.reverseObjectEnumerator) {
                                          if (![object isKindOfClass:[NSString class]]) {
                                              [fileArray removeObject:object];
                                          }
                                      }
                                      self.viewModel.photosArr = [fileArray copy];
                                      if (self.isEdit) {
                                          [[self.viewModel updateEidtMotherNoteCommand] execute:nil];
                                      } else {
                                          [[self.viewModel publicEditMotherNoteCommand] execute:nil];
                                      }
                                  }
             ];
        } else {
            if (self.isEdit) {
                self.viewModel.photosArr = self.photosArr;
                [[self.viewModel updateEidtMotherNoteCommand] execute:nil];
            } else {
                self.viewModel.photosArr = @[];
                [[self.viewModel publicEditMotherNoteCommand] execute:nil];
            }
        }
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
    }];
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"是否发布" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (CustomPickerView *)timePickerView {
    if (!_timePickerView) {
        kWeakSelf;
        _timePickerView = [CustomPickerView shareCustomPickerView];
        _timePickerView.pickerViewType = ShowPickerViewTypeOfTime;
        [[_timePickerView.cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.showView hide];
        }];
        [[_timePickerView.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.showView hide];
        }];
        [_timePickerView setSelectedPickerData:^(NSArray *selectedArr, ShowPickerViewType pickerViewType) {
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%ld-%02ld-%02ld",[selectedArr[0] integerValue],[selectedArr[1] integerValue],[selectedArr[2] integerValue]];
            weakSelf.publicTime = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00",[selectedArr[0] integerValue],[selectedArr[1] integerValue],[selectedArr[2] integerValue]];
        }];
    }
    return _timePickerView;
}

- (WWPictureSelect *)pictureSelect {
    if (!_pictureSelect) {
        kWeakSelf;
        _pictureSelect = [[WWPictureSelect alloc] initWithController:self];
        _pictureSelect.selectImages = ^(NSMutableArray *imagesArr) {
            for (QMUIAsset *asset in imagesArr) {
                [weakSelf.photosArr addObject:asset];
            }
            [weakSelf.collectionView reloadData];
//            [weakSelf.filePathArr removeAllObjects];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSLog(@"// 处理耗时操作的代码块...");
                for (QMUIAsset *asset in imagesArr) {
                    [WWFile saveFileToDocument:asset block:^(BOOL isSuccess, NSString *tip, NSString *filePath) {
                        NSLog(@"tip = %@",tip);
                        [weakSelf.filePathArr addObject:filePath];
                    }];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"//回调或者说是通知主线程刷新");
                });
            });
        };
    }
    return _pictureSelect;
}

- (QMUITextView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[QMUITextView alloc] initWithFrame:CGRectMake(5, 64 + 5, UIScreenWidth - 10, self.textViewMinimumHeight)];
        _textInputView.delegate = self;
        _textInputView.font = [UIFont systemFontOfSize:15.0f];
        _textInputView.placeholder = @"输入今日的笔记";
        _textInputView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
        _textInputView.autoResizable = YES;
//        _textInputView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
        _textInputView.returnKeyType = UIReturnKeyDone;
        _textInputView.enablesReturnKeyAutomatically = YES;
        // 限制可输入的字符长度
        _textInputView.maximumTextLength = NSUIntegerMax;
        self.topConstraint.constant = self.textViewMinimumHeight + 15;
    }
    return _textInputView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect textInputRect = self.textInputView.frame;
    CGSize textViewSize = [_textInputView sizeThatFits:CGSizeMake(textInputRect.size.width, CGFLOAT_MAX)];
    _textInputView.frame = CGRectMake(textInputRect.origin.x, textInputRect.origin.y, textInputRect.size.width, fmin(self.textViewMaximumHeight, fmax(textViewSize.height, self.textViewMinimumHeight)));
    self.topConstraint.constant = _textInputView.frame.size.height + 15;
}

#pragma mark - <QMUITextViewDelegate>

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmin(self.textViewMaximumHeight, fmax(height, self.textViewMinimumHeight));
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    if (needsChangeHeight) {
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

// 可以利用这个 delegate 来监听发送按钮的事件，当然，如果你习惯以前的方式的话，也可以继续在 textView:shouldChangeTextInRange:replacementText: 里处理
- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [QMUITips showSucceed:[NSString stringWithFormat:@"成功发送文字：%@", textView.text] inView:self.view hideAfterDelay:3.0];
    textView.text = nil;
    // return YES 表示这次 return 按钮的点击是为了触发“发送”，而不是为了输入一个换行符
    return YES;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    StaticImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell class]) forIndexPath:indexPath];
    kWeakSelf;
    [[[cell.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:[cell rac_prepareForReuseSignal]] subscribeNext:^(__kindof UIControl * _Nullable x) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"删除" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertAction *action) {
            [weakSelf.photosArr removeObjectAtIndex:indexPath.row];
            [weakSelf.collectionView reloadData];
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertAction *action) {
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"是否删除" message:@"" preferredStyle:QMUIAlertControllerStyleAlert];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [alertController showWithAnimated:YES];
    }];
    if (row == self.photosArr.count) {
        cell.deleteButton.hidden = YES;
        cell.itemImageView.image = [UIImage imageNamed:@"picture_add"];
    } else {
        cell.deleteButton.hidden = NO;
        if ([self.photosArr[indexPath.row] isKindOfClass:[QMUIAsset class]]) {
            QMUIAsset *asset = self.photosArr[indexPath.row];
            cell.itemImageView.image = asset.originImage;
        } else if ([self.photosArr[indexPath.row] isKindOfClass:[NSString class]]) {
            [cell.itemImageView sd_setImageWithURL:self.photosArr[indexPath.row]];
        }
    }
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((UIScreenWidth - 50) / 4, (UIScreenWidth - 50) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
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
    NSInteger row = indexPath.row;
    if (row == self.photosArr.count) {
        [RHDeviceAuthTool photoAuth:^{
            [self.pictureSelect presentAlbumViewControllerWithTitle:@"选择图片"];
        }];
    }
}

@end
