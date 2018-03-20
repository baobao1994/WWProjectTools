//
//  MotherViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/19.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "MotherViewController.h"
#import "UITableViewCell+Addition.h"
#import "StaticTableViewCell.h"
#import "TimeHeaderTableViewCell.h"
#import "MotherNoteTableViewCell.h"
#import "NSString+Addition.h"
#import "MotherNoteModel.h"

@interface MotherViewController ()<WSRefreshDelegate>

@property (weak, nonatomic) IBOutlet WSRefreshTableView *tableView;
@property (nonatomic, strong) NSArray *vcArray;
@property (nonatomic, strong) MotherNoteModel *motherNoteModel;

@end

@implementation MotherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    [self requestMotherList];
}

- (void)setUp {
    self.tableView.customTableDelegate = self;
    [self.tableView setRefreshCategory:DropdownRefresh];
    self.vcArray = @[@{ClassNameKey:@"EditViewController",TitleNameKey:@"基础数值"}];
}

- (void)requestMotherList {
    [WWHUD showLoadingWithText:@"加载中..." inView:self.view afterDelay:30];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"mother"];
    bquery.limit = 1;
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            self.motherNoteModel = [[MotherNoteModel alloc] initWithDictionary:obj];
            //打印playerName
            NSLog(@"obj.note = %@", [obj objectForKey:@"note"]);
            //打印objectId,createdAt,updatedAt
            NSLog(@"obj.objectId = %@", [obj objectId]);
            NSLog(@"obj.createdAt = %@", [obj createdAt]);
            NSLog(@"obj.updatedAt = %@", [obj updatedAt]);
        }
        [WWHUD hideAllTipsInView:self.view];
        [WWHUD showLoadingWithSucceedInView:self.view afterDelay:2];
        [self.tableView doneLoadingTableViewData];
        [self.tableView reloadData];
    }];
}

#pragma -mark WSRefreshDelegate

- (void)getHeaderDataSoure { // 下拉刷新代理
    [self requestMotherList];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"下拉刷新代理");
//        [self.tableView doneLoadingTableViewData];
//        [self.tableView reloadData];
//    });
}

//- (void)getFooterDataSoure { //上拉刷新代理
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"上拉刷新代理");
//        [self.tableView doneLoadingTableViewData];
//        [self.tableView reloadData];
//    });
//}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGFloat height = 0;
    if (section == 0) {
        if (row == 0) {
            height = 27;
        } else if (row == 1) {
            NSInteger count = (NSInteger)(self.motherNoteModel.photos.count - 1) < 0? 1:self.motherNoteModel.photos.count - 1;
            NSInteger rowCount = count / 3 + 1;
            height = ((UIScreenWidth - 43.5 - 45) / 3) * rowCount + 20 + rowCount * 10 + 74 ;
        }
    } else {
        height = 45;
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 1;
    if (section == 0) {
        rowCount = 2;
    }
    return rowCount;
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
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        if (row == 0) {
            TimeHeaderTableViewCell * cell = [TimeHeaderTableViewCell dequeOrCreateInTable:tableView selectedBackgroundViewColor:UIColorFromHexColor(0xCCC2C2)];
            return cell;
        } else {
            MotherNoteTableViewCell * cell = [MotherNoteTableViewCell dequeInTable:tableView];
            if (!cell) {
                cell = [MotherNoteTableViewCell loadFromNib];
                [cell.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StaticImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([StaticImageCollectionViewCell  class])];
            }
            [cell setContent:self.motherNoteModel];
            return cell;
        }
    } else {
        StaticTableViewCell * cell = [StaticTableViewCell dequeOrCreateInTable:tableView selectedBackgroundViewColor:UIColorFromHexColor(0xCCC2C2)];
        NSDictionary *dic = [self.vcArray objectAtIndex:indexPath.row];
        cell.itemNameLabel.text = [dic objectForKey:TitleNameKey];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0) {
        
    } else {
        [self jumpVCWithIndex:row];
    }
}

- (void)jumpVCWithIndex:(NSInteger)index {
    NSDictionary *dic = [self.vcArray objectAtIndex:index];
    UIViewController *vc = [[NSClassFromString([dic objectForKey:ClassNameKey]) alloc] init];
    vc.title = [dic objectForKey:TitleNameKey];
    if (_pushViewControllerBlock) {
        _pushViewControllerBlock(vc);
    }
}

@end
