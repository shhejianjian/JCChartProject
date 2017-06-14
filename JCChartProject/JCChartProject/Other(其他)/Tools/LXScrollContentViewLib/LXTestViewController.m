//
//  LXTestViewController.m
//  LXScrollContentView
//
//  Created by 刘行 on 2017/3/23.
//  Copyright © 2017年 刘行. All rights reserved.
//

#import "LXTestViewController.h"
#import "GFMCTableViewCell.h"
#import "GFMultipleColumnsTVCell.h"
#import "MXConstant.h"
#import "JCFuncChartVC.h"

static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LXTestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * dataDictionary;
@property (nonatomic,strong) NSMutableDictionary * objectIdDictionary;
@property (nonatomic,strong) NSMutableDictionary * iconDictionary;

@property (nonatomic,strong) NSMutableArray * allkeys;
@property (nonatomic,strong) NSMutableArray * secondMenuArr;
@end

@implementation LXTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    
    
    NSArray *subArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:self.secondFuncModel.childList];
    for (JCFuncBaseModel *subModel in subArr) {
        [self.allkeys addObject:subModel.name];
        [self.secondMenuArr addObject:subModel];
    }
    
    self.dataDictionary = [NSMutableDictionary dictionary];
    self.objectIdDictionary = [NSMutableDictionary dictionary];
    self.iconDictionary = [NSMutableDictionary dictionary];
    for (JCFuncBaseModel *subModel in subArr) {
        NSArray *arr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:subModel.childList];
        NSMutableArray * array = [NSMutableArray array];
        NSMutableArray *objectidArr = [NSMutableArray array];
        NSMutableArray *iconArr = [NSMutableArray array];
        for (JCFuncBaseModel *thirdModel in arr) {
            if (thirdModel.icon) {
                NSString *newStr = [thirdModel.icon substringFromIndex:3];
                [iconArr addObject:newStr];
            } else{
                [iconArr addObject:@"fa-bolt"];
            }
            
            [array addObject:thirdModel.name];
            [objectidArr addObject:thirdModel.objectId];
        }
        [self.objectIdDictionary setObject:objectidArr forKey:subModel.name];
        [self.dataDictionary setObject:array forKey:subModel.name];
        [self.iconDictionary setObject:iconArr forKey:subModel.name];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allkeys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSArray * array = [self.dataDictionary objectForKey:self.allkeys[section]];
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GFMCTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GFMCTableViewCell"];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GFMCTableViewCell" owner:nil options:nil] objectAtIndex:0];
        //        cell.backgroundColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.indexPath = indexPath;
    NSString * keyStr = self.allkeys[indexPath.section];
    NSArray * array = [self.dataDictionary objectForKey:keyStr];
    cell.dataArray = array;
    NSArray * Idarray = [self.objectIdDictionary objectForKey:keyStr];
    NSArray * iconarray = [self.iconDictionary objectForKey:keyStr];
    cell.iconArray = iconarray;
    cell.tvCellView.ReturnClickItemIndex = ^(NSIndexPath * itemtIP ,NSInteger itemIndex){
        JCFuncChartVC *chartVC = [[JCFuncChartVC alloc]init];
        chartVC.titleName = array[itemIndex];
        chartVC.objectId = Idarray[itemIndex];
        [self.navigationController pushViewController:chartVC animated:YES];
    };
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"%ld -> %ld",indexPath.section,indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    CGFloat labelWidth = [self getTextWithWhenDrawWithText:self.allkeys[section]];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = grayColor;
        UILabel * viewLabel = [[UILabel alloc]init];
        viewLabel.tag = 2;
        viewLabel.backgroundColor = middlegrayColor;
        [headerView.contentView addSubview:viewLabel];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = whitegrayColor;
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.frame = CGRectMake(15, 0, labelWidth, 25);
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.allkeys[section];
    UILabel *lineLabel = (UILabel *)[headerView viewWithTag:2];
    lineLabel.frame = CGRectMake(labelWidth+20, 12.5, KScreenW-(labelWidth+20), 0.5);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[text sizeWithAttributes:attrs];
    
    return size.width;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHt = 0.0;
    NSString * keyStr = self.allkeys[indexPath.section];
    NSArray * array = [self.dataDictionary objectForKey:keyStr];
    if (array.count != 0) {
        GFMultipleColumnsTVCell * cellView = [[GFMultipleColumnsTVCell alloc] init];
        cellView.dataArrayCount = array.count;
        cellHt += cellView.cellHeight;
    }
    return cellHt;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        } 
    }
}
- (NSMutableArray *)allkeys {
	if(_allkeys == nil) {
		_allkeys = [[NSMutableArray alloc] init];
	}
	return _allkeys;
}

- (NSMutableArray *)secondMenuArr {
	if(_secondMenuArr == nil) {
		_secondMenuArr = [[NSMutableArray alloc] init];
	}
	return _secondMenuArr;
}

@end
