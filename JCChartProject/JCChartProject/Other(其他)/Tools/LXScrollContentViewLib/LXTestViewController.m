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
static NSString *kCellIdentifier = @"kCellIdentifier";

@interface LXTestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * dataDictionary;
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
    for (JCFuncBaseModel *subModel in subArr) {
        NSArray *arr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:subModel.childList];
        NSMutableArray * array = [NSMutableArray array];
        for (JCFuncBaseModel *thirdModel in arr) {
            [array addObject:thirdModel.name];
        }
        [self.dataDictionary setObject:array forKey:subModel.name];
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
    cell.tvCellView.ReturnClickItemIndex = ^(NSIndexPath * itemtIP ,NSInteger itemIndex){
        NSLog(@"----###----###---(%ld,%ld)----##---%ld----###-----",itemtIP.section,itemtIP.row,itemIndex);
    };
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"%ld -> %ld",indexPath.section,indexPath.row];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = grayColor;
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = whitegrayColor;
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.allkeys[section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.allkeys[section];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 2;
//}
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
