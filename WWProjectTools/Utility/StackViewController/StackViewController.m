//
//  StackViewController.m
//  91Market
//
//  Created by huaiqing xie on 12-8-16.
//  Copyright (c) 2012年 wanglong. All rights reserved.
//

#import "StackViewController.h"

@interface StackViewController () {
    UIScrollView *_scrollView;
}

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, copy) void (^ selectViewBlock)(NSInteger index);
@property (nonatomic, retain) UIView *signView;
@property (nonatomic, retain) UIView *headView;

- (void)setup;

@end


@implementation StackViewController

@synthesize delegate = _delegate;
@synthesize currentIndex = _currentIndex;
@synthesize controllers = _controllers;
@synthesize controllerConfig = _controllerConfig;

#pragma mark - View lifecycle

- (id)initWithControllers:(NSArray *)contollers {
    if (self = [super init]) {
        _controllers = contollers;
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat x = _scrollView.contentOffset.x;
    NSInteger index = x / self.view.frame.size.width;
    id currentController = [_controllers objectAtIndex:index];
    [currentController viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    CGFloat x = _scrollView.contentOffset.x;
    NSInteger index = x / self.view.frame.size.width;
    id currentController = [_controllers objectAtIndex:index];
    [currentController viewWillDisappear:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    _delegate = nil;
}

#pragma mark - Public Method

- (void)setSegmentViewBlock:(UIView *(^)(NSInteger index))segmentView {
    NSInteger controllerCount = _controllers.count;
    CGFloat viewWidth = self.view.frame.size.width / controllerCount;
    for (int i = 0; i < controllerCount; i++) {
        UIView *view = segmentView(i);
        _segmentHeight = view.frame.size.height;
        view.frame = CGRectMake(i * viewWidth, 0, viewWidth, view.frame.size.height);
        [self.view addSubview:view];
    }
    [self setSubviewsFrame:_segmentHeight];
}

- (void)setStackViewDidSelectViewBlock:(void (^)(NSInteger))block {
    self.selectViewBlock = block;
    block(_currentIndex);
}

- (void)setStackViewHeaderView:(UIView *)headerView {
    [self setStackViewHeaderView:headerView signView:nil];
}

- (void)setStackViewHeaderView:(UIView *)headerView signView:(UIView *)signView {
    [_headView removeFromSuperview];
    [_signView removeFromSuperview];
    _headView = headerView;
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, headerView.frame.size.width, 0.5)];
    [headerView addSubview:line];
    
    _segmentHeight = CGRectGetHeight(headerView.frame);
    [self.view addSubview:headerView];
    if (signView) {
        _signView = signView;
        float offsetX = (self.view.frame.size.width / _controllers.count - _signView.frame.size.width) / 2;
        _signView.frame = CGRectMake(self.view.frame.size.width / _controllers.count * _currentIndex + offsetX, _segmentHeight - _signView.frame.size.height, _signView.frame.size.width, _signView.frame.size.height);
  
    }else {
        _signView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_select_sign"]];
        _signView.frame = CGRectMake(self.view.frame.size.width / _controllers.count * _currentIndex, _segmentHeight - _signView.frame.size.height, self.view.frame.size.width / _controllers.count, _signView.frame.size.height);
    }
    
    [self.view addSubview:_signView];
    [self.view bringSubviewToFront:_scrollView];
    [self setSubviewsFrame:_segmentHeight];
}

- (void)scrollViewEnableScroll:(BOOL)enable {
    _scrollView.scrollEnabled = enable;
}

- (void)hideSegmentView:(BOOL)isHide {
    CGFloat height = 0;
    if (!isHide) {
        height = _segmentHeight;
    }
    [self setSubviewsFrame:height];
}

- (void)reloadContentSize {
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * _controllers.count, 0)];
}

#pragma mark - Sub UIViewController Delegate

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
    if ([self.delegate respondsToSelector:@selector(pushViewController:animated:)]) {
        [self.delegate pushViewController:viewController animated:animated];
    }
}

#pragma mark - IntroductionView Delegate

- (void)showSubViewAtIndex:(NSInteger)index animated:(BOOL)animated {
    _currentIndex = index;
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width * index, 0) animated:animated];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float x = scrollView.contentOffset.x;
    float offsetX = (self.view.frame.size.width / _controllers.count - _signView.frame.size.width) / 2;
    _signView.frame = CGRectMake(x/_controllers.count + offsetX, _signView.frame.origin.y, _signView.frame.size.width, _signView.frame.size.height);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self becomeFirstResponder];
    float x = scrollView.contentOffset.x;
    float offsetX = (self.view.frame.size.width / _controllers.count - _signView.frame.size.width) / 2;
    _signView.frame = CGRectMake(x/_controllers.count + offsetX, _signView.frame.origin.y, _signView.frame.size.width, _signView.frame.size.height);
    NSInteger index = x / self.view.frame.size.width;
    id nextController = [_controllers objectAtIndex:index];
    [nextController viewWillAppear:YES];
    NSInteger controllerCount = [_controllers count];
    for (int i = 0; i < controllerCount; i++) {
        if (i != index) {
            id targetController = [_controllers objectAtIndex:i];
            if (targetController != [NSNull null]) {
                [targetController viewWillDisappear:YES];
            }
        }
    }
    _currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(stackViewDidShowSubView:)]) {
        [self.delegate stackViewDidShowSubView:index];
    }
    if (self.selectViewBlock != nil) {
        self.selectViewBlock(index);
    }
}

#pragma mark - Private method

- (void)setup {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width * _controllers.count, 0)];
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < _controllers.count; i++) {
        UIViewController *controller = [_controllers objectAtIndex:i];
        controller.view.frame = CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView addSubview:controller.view];
    }
}

- (void)setSubviewsFrame:(CGFloat)headerHeight {
    _scrollView.frame = CGRectMake(0, headerHeight, self.view.frame.size.width, self.view.frame.size.height - headerHeight);
    for (int i = 0; i < _controllers.count; i++) {
        UIViewController *controller = [_controllers objectAtIndex:i];
        controller.view.frame = CGRectMake(i * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    }
}

@end
