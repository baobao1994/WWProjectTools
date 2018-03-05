//
//  WWTextInputBarView.m
//  WWTextInputBarView
//
//  Created by 郭伟文 on 2018/1/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWTextInputBarView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface WWTextInputBarView ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, assign) CGFloat oneLineHeight;
@property (nonatomic, assign) CGFloat defaultHeight;//默认textViewHeight

@end

@implementation WWTextInputBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.defaultHeight = 30;
        self.sendButtonBgNormalColor = [UIColor colorWithRed:0/255.0 green:249/255.0 blue:0/255.0 alpha:0.5];
        self.sendButtonBgHightLightColor = [UIColor colorWithRed:0/255.0 green:249/255.0 blue:0/255.0 alpha:1];
        [self addSubview:self.textView];
        [self addSubview:self.senderButton];
        [self resetOneLineHeight];
        self.limitLineCount = 5;
        self.sendButtonAlignment = SendButtonAlignmentDown;
    }
    return self;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth - 95, self.defaultHeight)];//defaule frame
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _textView;
}

- (UIButton *)senderButton {
    if (_sendButton == nil && _rightView == nil) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 65, 5, 50, self.defaultHeight)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendButton.enabled = NO;
        [_sendButton setBackgroundColor:self.sendButtonBgNormalColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton addTarget:self action:@selector(didSelectSenderBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius=5;
        _sendButton.layer.masksToBounds=YES;
        [self addSubview:_sendButton];
    }
    return _sendButton;
}

- (void)resetOneLineHeight {
    CGSize maxSize = CGSizeMake(self.textView.bounds.size.width, MAXFLOAT);
    //一行的高度
    CGRect frame = [@"t" boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.textView.font} context:nil];
    _oneLineHeight = frame.size.height;
}

- (void)keyboardChanged:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect currentFrame = self.frame;
    [UIView animateWithDuration:0.25 animations:^{
        //输入框最终的位置
        CGRect resultFrame;
        if (frame.origin.y == ScreenHeight) {
            resultFrame = CGRectMake(currentFrame.origin.x, ScreenHeight - currentFrame.size.height, currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight = 0;
        } else {
            resultFrame = CGRectMake(currentFrame.origin.x, ScreenHeight - currentFrame.size.height - frame.size.height , currentFrame.size.width, currentFrame.size.height);
            self.keyboardHeight = frame.size.height;
        }
        self.frame=resultFrame;
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat tarHeight = self.defaultHeight;
    CGSize maxSize=CGSizeMake(textView.bounds.size.width, MAXFLOAT);
    //测量string的大小
    CGRect frame = [textView.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:textView.font} context:nil];
    CGFloat contentSizeHeight = textView.contentSize.height;
    if (contentSizeHeight > self.defaultHeight) {
        if (contentSizeHeight >= _oneLineHeight * _limitLineCount) {
            tarHeight = _oneLineHeight * _limitLineCount + 10;
        } else {
            tarHeight = contentSizeHeight;
        }
        if (self.limitLineCount > 1) {
            [textView setContentOffset:CGPointMake(0, frame.size.height - self.defaultHeight) animated:NO];
        } else {
            [textView setContentOffset:CGPointMake(0, frame.size.height - _oneLineHeight) animated:NO];
        }
    }
    //设置输入框背景的frame
    self.frame = CGRectMake(0, (ScreenHeight - self.keyboardHeight) - (tarHeight + 10), ScreenWidth, tarHeight + 10);
    //设置输入框的frame
    self.textView.frame = CGRectMake(15, (self.bounds.size.height - tarHeight) / 2 , textView.frame.size.width, tarHeight);
    if (textView.text.length) {
        _sendButton.enabled = YES;
        [_sendButton setBackgroundColor:self.sendButtonBgHightLightColor];
    } else {
        _sendButton.enabled = NO;
        [_sendButton setBackgroundColor:self.sendButtonBgNormalColor];
    }
    CGRect sendButtonRect = self.sendButton.frame;
    switch (self.sendButtonAlignment) {
        case SendButtonAlignmentTop:
            break;
        case SendButtonAlignmentCenter:
            self.sendButton.frame = CGRectMake(sendButtonRect.origin.x, (self.frame.size.height - sendButtonRect.size.height) / 2, sendButtonRect.size.width, sendButtonRect.size.height);
            break;
        case SendButtonAlignmentDown:
            self.sendButton.frame = CGRectMake(sendButtonRect.origin.x, self.frame.size.height - sendButtonRect.size.height - 5, sendButtonRect.size.width, sendButtonRect.size.height);
            break;
        default:
            break;
    }
}

- (void)didSelectSenderBtn:(UIButton *)sender {
//    self.sendContent(_textView.text);
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)setLimitLineCount:(NSInteger)limitLineCount {
    if (limitLineCount < 0) {
        limitLineCount = 1;
    }
    _limitLineCount = limitLineCount;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (void)setSendButtonBgNormalColor:(UIColor *)sendButtonBgNormalColor {
    _sendButtonBgNormalColor = sendButtonBgNormalColor;
}

- (void)setSendButtonBgHightLightColor:(UIColor *)sendButtonBgHightLightColor {
    _sendButtonBgHightLightColor = sendButtonBgHightLightColor;
}

- (void)setTextViewRect:(CGRect)textViewRect {
    _textViewRect = textViewRect;
    self.textView.frame = textViewRect;
    [self resetOneLineHeight];
}

- (void)setfont:(UIFont *)font {
    _font = font;
    self.textView.font = font;
    [self resetOneLineHeight];
}

-(void)setLeftView:(UIView *)leftView {
    _leftView = leftView;
    [self addSubview:leftView];
}

- (void)setRightView:(UIView *)rightView {
    _rightView = rightView;
    [self addSubview:rightView];
    if (_sendButton) {
        [_sendButton removeFromSuperview];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
