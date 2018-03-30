//
//  ESPPictureBrowserViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/16.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "ESPPictureBrowserViewController.h"
#import "ESPictureModel.h"
#import "ESCellNode.h"
#import "AsyncDisplayKit.h"
#import <PINCache/PINCache.h>
#import <YYWebImage/YYWebImage.h>
@interface ESPPictureBrowserViewController ()<ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) NSArray *datas;

@property (nonatomic, strong) ASTableView *tableView;

@end

@implementation ESPPictureBrowserViewController

- (NSArray *)datas {
    if (_datas == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"list.json" withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSMutableArray *result = [NSMutableArray array];
        for (NSArray *value in array) {
            NSMutableArray *arrayM = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                ESPictureModel *model = [ESPictureModel new];
                [model setValuesForKeysWithDictionary:dict];
                [arrayM addObject:model];
            }
            [result addObject:arrayM];
        }
        _datas = [result copy];
    }
    return _datas;
}

- (void)loadView {
    ASTableView *tableView = [ASTableView new];
    tableView.asyncDelegate = self;
    tableView.asyncDataSource = self;
    self.view = tableView;
    self.tableView = tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearCache)];
}

- (void)clearCache {
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

- (void)dealloc {
    NSLog(@"销毁");
}

#pragma mark - "代理数据源方法"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ESCellNode *node = [ESCellNode new];
    NSArray *pictureModels = self.datas[indexPath.row];
    [node setPictureModels:pictureModels];
    return node;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end

