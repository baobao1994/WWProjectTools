//
//  WWTabBarController.m
//  WWTabBar
//
//  Created by 郭伟文 on 2018/1/15.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWTabBarController.h"
#import "WWTabBarConfig.h"

#if  __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
#import "UITabBarItem+BadgeColor.h"
#endif
#import <objc/runtime.h>

@interface WWTabBarController ()<UIGestureRecognizerDelegate>
// center button of place ( -1:none center button >=0:contain center button)
@property(assign , nonatomic) NSInteger centerPlace;
// Whether center button to bulge
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
// items
@property (nonatomic,strong) NSMutableArray <UITabBarItem *>*items;
@end

@implementation WWTabBarController {
    int _tabBarItemTag;
    int _lifewwcleCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerPlace = -1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_lifewwcleCount == 0) {
        _lifewwcleCount = 1;
        //  Initialize selected
        NSInteger index = [WWTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)
            ? self.centerPlace
            : 0;
        } else if (index >= self.viewControllers.count){
            self.selectedIndex = self.viewControllers.count-1;
        }
        else {
            self.selectedIndex = index;
        }
        
        self.wwtabbar.backgroundColor = [WWTabBarConfig shared].backgroundColor;
        // add tabBar
        [self.tabBar addSubview:self.wwtabbar];
        self.wwtabbar.frame = self.tabBar.bounds;
        [self.view addSubview:self.contentView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (UIView *loop in self.tabBar.subviews) {
        NSString *className = [NSString stringWithFormat:@"%@",loop.class];
        if (![className isEqualToString:@"WWTabBar"]) {//将系统的东西全部隐藏了
            loop.hidden = YES;
        }
    }
}

/**
 *  Add other button for child’s controller
 */
- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc = [self findViewControllerWithobject:Controller];
    vc.tabBarItem.title = title;
    
    if (imageName) {
        vc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if (selectedImageName) {
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[[WWTabBarConfig shared] textColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[[WWTabBarConfig shared] selectedTextColor] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    vc.tabBarItem.tag = _tabBarItemTag++;
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:Controller];
}

/**
 *  Add center button
 */
- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = _tabBarItemTag-1;
    }else{
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                          image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                  selectedImage:[[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = _tabBarItemTag;
    }
}

/**
 *  getter
 */

- (WWTabBar *)wwtabbar{
    if (self.items.count && !_wwtabbar) {
        _wwtabbar = [[WWTabBar alloc]initWithFrame:self.tabBar.bounds];
        [_wwtabbar setValue:self forKey:@"controller"];
        [_wwtabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_wwtabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _wwtabbar.items = self.items;
    }
    return _wwtabbar;
}

- (ContentView *)contentView{
    if (!_contentView) {
        CGRect rect = self.tabBar.frame;
        rect.origin.y -= [WWTabBarConfig shared].bulgeHeight+10.f;
        rect.size.height += [WWTabBarConfig shared].bulgeHeight+10.f;
        _contentView = [[ContentView alloc]initWithFrame:rect];
        _contentView.controller = self;
    }
    return _contentView;
}

- (NSMutableArray <UITabBarItem *>*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    [super setSelectedIndex:selectedIndex];
    [self.wwtabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKeyPath:@"selectButtoIndex"];
}

/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

/**
 *  hidden tabbar and do animated
 */
- (void)setTabBarHidden:(id)hidden {
    NSTimeInterval time = 0.6;
    if ([hidden boolValue]) {
        CGFloat h = self.tabBar.frame.size.height*2;
        [UIView animateWithDuration:time-0.1 animations:^{
            self.tabBar.transform = CGAffineTransformMakeTranslation(0,h);
        }completion:^(BOOL finished) {
            self.tabBar.hidden = YES;
        }];
    } else {
        self.tabBar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabBar.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
