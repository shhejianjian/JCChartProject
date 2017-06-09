//
//  JCStrategyVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCStrategyVC.h"
#import "MXConstant.h"
#import "JCStrategyCell.h"
#import "JCStrategyListModel.h"

static NSString *ID=@"JCStrategyCell";



@interface JCStrategyVC ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *strategyListArr;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;

@end

@implementation JCStrategyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"策略";
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCStrategyCell" bundle:nil] forCellReuseIdentifier:ID];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.myTableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
- (void)loadNewData
{
    [self.strategyListArr removeAllObjects];
    self.currentPage = 1;
    [self loadStrategyDataList];
}
- (void)loadMoreData
{
    self.currentPage ++;
    [self loadStrategyDataList];
}
- (void)loadStrategyDataList{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = @(self.currentPage);
    params[@"pageSize"] = @"8";
    [XHHttpTool get:StrategyListUrl params:params jessionid:jsessionid success:^(id json) {
        NSLog(@"json::%@",json);
        JCStrategyListModel *strategyModel = [JCStrategyListModel mj_objectWithKeyValues:json];
        NSArray *arr = [JCStrategyListModel mj_objectArrayWithKeyValuesArray:strategyModel.dataList];
        for (JCStrategyListModel *model in arr) {
            [self.strategyListArr addObject:model];
        }
        self.totalCount = [strategyModel.total integerValue];
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if (self.strategyListArr.count == self.totalCount) {
        self.myTableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.strategyListArr.count;
    
}


- (JCStrategyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCStrategyCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCStrategyCell alloc]init];
        
    }
    if (self.strategyListArr.count != 0) {
        cell.strategyListModel = self.strategyListArr[indexPath.row];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



- (NSMutableArray *)strategyListArr {
	if(_strategyListArr == nil) {
		_strategyListArr = [[NSMutableArray alloc] init];
	}
	return _strategyListArr;
}

@end
