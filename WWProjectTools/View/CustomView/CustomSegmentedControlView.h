//
//  CustomSegmentedControlView.h
//  RecruitmentHallStudentSide
//
//  Created by bestsep on 2017/12/14.
//  Copyright © 2017年 BestSep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSegmentedControlView : UIView

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, copy) void (^didChangeSelect)(NSInteger current);

- (void)initWithDataArr:(NSArray *)dataArr;
- (void)setRedPointIndex:(NSInteger)index showStatu:(BOOL)showStatu;

- (void)didSelectIndex:(NSInteger)index;

@end

