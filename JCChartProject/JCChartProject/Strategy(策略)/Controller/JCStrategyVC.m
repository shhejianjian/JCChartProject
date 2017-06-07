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
@end

@implementation JCStrategyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"策略";
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCStrategyCell" bundle:nil] forCellReuseIdentifier:ID];
    [self loadStrategyDataList];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadStrategyDataList{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = @"1";
    params[@"pageSize"] = @"8";
    [XHHttpTool get:StrategyListUrl params:params jessionid:jsessionid success:^(id json) {
        NSLog(@"json::%@",json);
        JCStrategyListModel *strategyModel = [JCStrategyListModel mj_objectWithKeyValues:json];
        NSArray *arr = [JCStrategyListModel mj_objectArrayWithKeyValuesArray:strategyModel.dataList];
        for (JCStrategyListModel *model in arr) {
            [self.strategyListArr addObject:model];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.strategyListArr.count;
    
}


- (JCStrategyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCStrategyCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCStrategyCell alloc]init];
        
    }
    cell.strategyListModel = self.strategyListArr[indexPath.row];
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
