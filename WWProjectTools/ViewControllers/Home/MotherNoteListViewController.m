//
//  MotherNoteListViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MotherNoteListViewController.h"
#import "MotherNoteTableViewCell.h"
#import "UITableViewCell+Addition.h"
#import "StaticImageCollectionViewCell.h"
#import "TimeHeaderTableViewCell.h"
#import "MotherNoteModel.h"
#import "MotherNoteListViewModel.h"
#import "NSString+Addition.h"
#import "NSDate+Addition.h"
#import "UIViewController+Addition.h"
#import "EditMotherNoteViewController.h"

@interface MotherNoteListViewController ()<WSRefreshDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet WSRefreshTableView *tableView;
@property (nonatomic, strong) MotherNoteListViewModel *listViewModel;

@end

@implementation MotherNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self createNavigationRightItemWithTitle:@"发布"];
    [WWHUD showLoadingWithInView:SelfViewControllerView afterDelay:30];
}

- (void)selectedNavigationRightItem:(id)sender {
    EditMotherNoteViewController *editVC = [[EditMotherNoteViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)setUp {
    self.tableView.customTableDelegate = self;
    [self.tableView setRefreshCategory:BothRefresh];
    self.listViewModel = [[MotherNoteListViewModel alloc] init];
    kWeakSelf;
    [[self.listViewModel.loadCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            [weakSelf.tableView doneLoadingTableViewData];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.isLoadedAllTheData = weakSelf.listViewModel.isLoadedAllTheData;
            [WWHUD hideAllTipsInView:SelfViewControllerView];
        }];
    }];
    
    [self.listViewModel.loadCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD hideAllTipsInView:SelfViewControllerView];
        [WWHUD showLoadingWithErrorInView:SelfViewControllerView afterDelay:2];
    }];
    
    [[self.listViewModel.loadMoreCommand executionSignals] subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            [weakSelf.tableView doneLoadingTableViewData];
            [weakSelf.tableView reloadData];
            weakSelf.tableView.isLoadedAllTheData = weakSelf.listViewModel.isLoadedAllTheData;
        }];
    }];
    
    [self.listViewModel.loadMoreCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [WWHUD showLoadingWithErrorInView:SelfViewControllerView afterDelay:2];
    }];
    [[self.listViewModel loadCommand] execute:nil];
}

#pragma -mark WSRefreshDelegate

- (void)getHeaderDataSoure { // 下拉刷新代理
    [[self.listViewModel loadCommand] execute:nil];
}

- (void)getFooterDataSoure { //上拉刷新代理
    [[self.listViewModel loadMoreCommand] execute:nil];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MotherNoteModel *noteModel = self.listViewModel.arrRecords[indexPath.row];
    CGFloat height = 27;
    if (!noteModel.isTop) {
        CGSize size = [noteModel.note adaptSizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(UIScreenWidth - 43.5, CGFLOAT_MAX)];
        height = size.height + 20;
        if (noteModel.photos.count) {
            height += 10;
            NSInteger count = (NSInteger)(noteModel.photos.count - 1) < 0? 1:noteModel.photos.count - 1;
            NSInteger rowCount = count / 3 + 1;
            height += ((UIScreenWidth - 43.5 - 45) / 3) * rowCount + 10 + rowCount * 10;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listViewModel.arrRecords.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, CGFLOAT_MIN)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, CGFLOAT_MIN)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MotherNoteModel *noteModel = self.listViewModel.arrRecords[indexPath.row];
    if (noteModel.isTop) {
        TimeHeaderTableViewCell * cell = [TimeHeaderTableViewCell dequeOrCreateInTable:tableView selectedBackgroundViewColor:UIColorFromHexColor(0xCCC2C2)];
        cell.timeLabel.text = [[NSDate alloc] setTimeInterval:noteModel.publicTime formateDate:@"yyyy-MM-dd"];
        return cell;
    } else {
        MotherNoteTableViewCell * cell = [MotherNoteTableViewCell dequeInTable:tableView];
        if (!cell) {
            cell = [MotherNoteTableViewCell loadFromNib];
            [cell.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StaticImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell  class])];
        }
        [cell setContent:noteModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
