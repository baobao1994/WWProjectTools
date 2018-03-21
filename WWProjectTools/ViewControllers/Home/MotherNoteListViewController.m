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

@interface MotherNoteListViewController ()<WSRefreshDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet WSRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *noteArr;

@end

@implementation MotherNoteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    [self requestMotherList];
}

- (void)setUp {
    self.tableView.customTableDelegate = self;
    [self.tableView setRefreshCategory:BothRefresh];
    self.noteArr = [[NSMutableArray alloc] init];
}

#pragma -mark WSRefreshDelegate

- (void)getHeaderDataSoure { // 下拉刷新代理
    [self requestMotherList];
}

- (void)getFooterDataSoure { //上拉刷新代理
    [self requestMoreMotherList];
}

- (void)requestMoreMotherList {
    [WWHUD showLoadingWithText:@"加载中..." inView:self.view afterDelay:30];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"mother"];
    bquery.limit = self.noteArr.count + 10;
    bquery.skip = self.noteArr.count;
    [bquery orderByDescending:CreatedAtKey];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            [self.noteArr addObject:[[MotherNoteModel alloc] initWithDictionary:obj]];
        }
        [WWHUD hideAllTipsInView:self.view];
        [WWHUD showLoadingWithSucceedInView:self.view afterDelay:2];
        [self.tableView doneLoadingTableViewData];
        [self.tableView reloadData];
    }];
}

- (void)requestMotherList {
    [WWHUD showLoadingWithText:@"加载中..." inView:self.view afterDelay:30];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"mother"];
    bquery.limit = 10;
    [bquery orderByDescending:CreatedAtKey];
    [self.noteArr removeAllObjects];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            [self.noteArr addObject:[[MotherNoteModel alloc] initWithDictionary:obj]];
        }
        [WWHUD hideAllTipsInView:self.view];
        [WWHUD showLoadingWithSucceedInView:self.view afterDelay:2];
        [self.tableView doneLoadingTableViewData];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MotherNoteModel *noteModel = self.noteArr[indexPath.row];
    CGFloat height = 74;
    if (noteModel.photos.count) {
        NSInteger count = (NSInteger)(noteModel.photos.count - 1) < 0? 1:noteModel.photos.count - 1;
        NSInteger rowCount = count / 3 + 1;
        height += ((UIScreenWidth - 43.5 - 45) / 3) * rowCount + 20 + rowCount * 10;
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
    return self.noteArr.count;
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
    MotherNoteTableViewCell * cell = [MotherNoteTableViewCell dequeInTable:tableView];
    if (!cell) {
        cell = [MotherNoteTableViewCell loadFromNib];
        [cell.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StaticImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell  class])];
    }
    [cell setContent:self.noteArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
