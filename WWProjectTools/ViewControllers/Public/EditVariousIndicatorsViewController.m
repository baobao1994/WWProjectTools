//
//  EditVariousIndicatorsViewController.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/22.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "EditVariousIndicatorsViewController.h"
#import "YLTagsChooser.h"
#import "YLTag.h"
#import "CustomPickerView.h"
#import "CustomKeyWindowView.h"

@interface EditVariousIndicatorsViewController ()<YLTagsChooserDelegate>

@property (nonatomic, strong) NSMutableArray *selectedTags;
@property (nonatomic, strong) NSArray *moodArr;
@property (nonatomic, strong) NSArray *physicalStateArr;
@property (nonatomic, strong) CustomKeyWindowView *showView;
@property (nonatomic, strong) CustomPickerView *pickerView;

@end

@implementation EditVariousIndicatorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedTags = [[NSMutableArray alloc] init];
    self.moodArr = @[@"非常好",@"很好",@"一般",@"差"];
    self.physicalStateArr = @[@"无异样",@"腰酸",@"头痛",@"感冒",@"发烧",@"其它"];
}

- (IBAction)chooseTags:(id)sender {
//    _textLabel.text = nil;
    YLTagsChooser *chooser = [[YLTagsChooser alloc]initWithBottomHeight:500 maxSelectCount:8 delegate:self];
    NSMutableArray *orignDataArray = [NSMutableArray array];
    NSArray *tags = @[@"篮球",
                      @"足球",
                      @"羽毛球",
                      @"乒乓球",
                      @"排球",
                      @"网球",
                      @"高尔夫球",
                      @"冰球",
                      @"沙滩排球",
                      @"棒球",
                      @"垒球",
                      @"藤球",
                      @"毽球",
                      @"台球",
                      @"鞠蹴",
                      @"板球",
                      @"壁球",
                      @"沙壶",
                      @"克郎球",
                      @"橄榄球",
                      @"曲棍球",
                      @"水球",
                      @"马球",
                      @"保龄球",
                      @"健身球",
                      @"门球",
                      @"弹球"
                      ];
    NSInteger index = tags.count;
    NSMutableArray *testTags0 = [NSMutableArray arrayWithCapacity:tags.count];
    for(NSInteger i = 0; i < index; i++){
        YLTag *tag = [[YLTag alloc]initWithId:i name:tags[i]];
        [testTags0 addObject:tag];
    }
    [orignDataArray addObject:testTags0];
    
    //一个section
    //    [chooser showInView:self.view];
    //    [chooser refreshWithTags:orignDataArray selectedTags:selectedTags];
    //    return;
    
    NSMutableArray *testTags1 = [NSMutableArray arrayWithCapacity:40];
    for(NSInteger i = index; i < index + 40; i++){
        NSString *name;
        if(i % 4 == 0){
            name = [NSString stringWithFormat:@"Remember%li",(long)i];
        }else if (i % 4 == 1){
            name = [NSString stringWithFormat:@"Remember Give%li",(long)i];
        }else if(i % 4 == 2){
            name = [NSString stringWithFormat:@"Remember Give Me a@%li",(long)i];
        }else{
            name = [NSString stringWithFormat:@"Remember Give Me a Star@%li",(long)i];
        }
        YLTag *tag = [[YLTag alloc]initWithId:i name:name];
        [testTags1 addObject:tag];
    }
    [orignDataArray addObject:testTags1];
    
    
    index += 40;
    NSMutableArray *testTags2 = [NSMutableArray arrayWithCapacity:20];
    for(NSInteger i = index; i < index + 20; i++){
        NSString *name;
        if(i % 3 == 0){
            name = [NSString stringWithFormat:@"标签选择器%li",(long)i];
        }else if (i % 3 == 1){
            name = [NSString stringWithFormat:@"Lambert%li",(long)i];
        }else{
            name = [NSString stringWithFormat:@"CodeNinja%li",(long)i];
        }
        YLTag *tag = [[YLTag alloc]initWithId:i name:name];
        [testTags2 addObject:tag];
    }
    [orignDataArray addObject:testTags2];
    
    //多个section
    [chooser showInView:self.view];
    [chooser refreshWithTags:orignDataArray selectedTags:self.selectedTags];
}


#pragma mark---YLTagsChooserDelegate
- (void)tagsChooser:(YLTagsChooser *)sheet selectedTags:(NSArray *)sTags
{
    [self.selectedTags removeAllObjects];
    [self.selectedTags addObjectsFromArray:sTags];
    NSString *tagStr = [sTags componentsJoinedByString:@"\n"];
    NSString *result = [NSString stringWithFormat:@"你选择了以下标签：\n%@",tagStr];
    NSLog(@"result = %@",result);
    //    _textLabel.text = result;
}

@end
