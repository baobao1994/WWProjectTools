//
//  EditViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/20.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditViewController.h"
#import "UIView+Addtion.h"
#import "UIViewController+Addition.h"
#import "StaticImageCollectionViewCell.h"
#import "WWPictureSelect.h"

@interface EditViewController ()<QMUITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) QMUITextView *textInputView;
@property (nonatomic, assign) CGFloat textViewMinimumHeight;
@property (nonatomic, assign) CGFloat textViewMaximumHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) WWPictureSelect *pictureSelect;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    [self bind];
    [self.view addSubview:self.textInputView];
    [self createNavigationRightItemWithTitle:@"发布"];
}

- (void)setUp {
    self.textViewMinimumHeight = 150;
    self.textViewMaximumHeight = 200;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StaticImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell class])];
    self.imagesArr = [[NSMutableArray alloc] init];
    self.pictureSelect = [[WWPictureSelect alloc] initWithController:self];
    kWeakSelf;
    self.pictureSelect.selectImages = ^(NSMutableArray *imagesArr) {
        weakSelf.imagesArr = imagesArr;
        [weakSelf.collectionView reloadData];
    };
}

- (void)bind {
    kWeakSelf;
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.pictureSelect presentAlbumViewControllerWithTitle:@"选择图片"];
    }];
}

- (void)selectedNavigationRightItem:(id)sender {
    NSLog(@"发布");
}

- (QMUITextView *)textInputView {
    if (!_textInputView) {
        _textInputView = [[QMUITextView alloc] initWithFrame:CGRectMake(5, 64 + 5, UIScreenWidth - 10, self.textViewMinimumHeight)];
        _textInputView.delegate = self;
        _textInputView.placeholder = @"输入今日的笔记";
        _textInputView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
        _textInputView.autoResizable = YES;
//        _textInputView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
        _textInputView.returnKeyType = UIReturnKeyDone;
        _textInputView.enablesReturnKeyAutomatically = YES;
        // 限制可输入的字符长度
        _textInputView.maximumTextLength = NSUIntegerMax;
        [_textInputView setBorderLineWithColor:UIColorFromHexColor(0X909090)];
        self.selectButtonTopConstraint.constant = self.textViewMinimumHeight + 15;
    }
    return _textInputView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect textInputRect = self.textInputView.frame;
    CGSize textViewSize = [_textInputView sizeThatFits:CGSizeMake(textInputRect.size.width, CGFLOAT_MAX)];
    _textInputView.frame = CGRectMake(textInputRect.origin.x, textInputRect.origin.y, textInputRect.size.width, fmin(self.textViewMaximumHeight, fmax(textViewSize.height, self.textViewMinimumHeight)));
    self.selectButtonTopConstraint.constant = _textInputView.frame.size.height + 15;
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    // 表示点击空白区域都会降下键盘
    return YES;
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
    return self.imagesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StaticImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell class]) forIndexPath:indexPath];
    cell.itemImageView.image = self.imagesArr[indexPath.row];
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

@end
