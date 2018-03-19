//
//  StackViewController.h
//  91Market
//
//  Created by huaiqing xie on 12-8-16.
//  Copyright (c) 2012年 wanglong. All rights reserved.
//

@protocol StackViewDelegate <NSObject>

@optional
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)stackViewDidShowSubView:(NSInteger)index;

@end


@interface StackViewController : UIViewController <
    UINavigationControllerDelegate,
    UIScrollViewDelegate > {
        NSInteger _currentIndex;
        NSArray *_controllerConfig;
        NSArray *_controllers;
}

@property (nonatomic, assign) id<StackViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, retain) NSArray *controllerConfig;
@property (nonatomic, retain) NSArray *controllers;

- (id)initWithControllers:(NSArray *)controllers;
- (void)setSegmentViewBlock:(UIView *(^)(NSInteger index))segmentView;
- (void)setStackViewDidSelectViewBlock:(void (^)(NSInteger index))block;
- (void)setStackViewHeaderView:(UIView *)headerView;
- (void)setStackViewHeaderView:(UIView *)headerView signView:(UIView *)signView;
- (void)showSubViewAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollViewEnableScroll:(BOOL)enable;
- (void)hideSegmentView:(BOOL)isHide;
- (void)reloadContentSize;

@end
