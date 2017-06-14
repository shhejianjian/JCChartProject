//
//  JCFirstMenuVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/13.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFirstMenuVC.h"
#import "JCFunctionCell.h"
#import "MXConstant.h"
#import "JCSecondMenuVC.h"
static NSString *ID=@"JCFunctionCell";



@interface JCFirstMenuVC ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *firstMenuArr;
@end

@implementation JCFirstMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"添加更多";
    [self loadFirstMenu];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCFunctionCell" bundle:nil] forCellReuseIdentifier:ID];
}
- (void)loadFirstMenu{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *firstMenuUrl = [NSString stringWithFormat:@"%@%@",MenuUrl,userid];
    [XHHttpTool get:firstMenuUrl params:nil jessionid:jsessionid success:^(id json) {
        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:json];
        for (JCFuncBaseModel *mainModel in mainArr) {
            [self.firstMenuArr addObject:mainModel];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.firstMenuArr.count;
    
}


- (JCFunctionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCFunctionCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCFunctionCell alloc]init];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.functionModel = self.firstMenuArr[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 44;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JCFuncBaseModel *model = self.firstMenuArr[indexPath.row];
    JCSecondMenuVC *secondMenuVC = [[JCSecondMenuVC alloc]init];
    secondMenuVC.secondModel = model;
    [self.navigationController pushViewController:secondMenuVC animated:YES];
    
}



- (NSMutableArray *)firstMenuArr {
	if(_firstMenuArr == nil) {
		_firstMenuArr = [[NSMutableArray alloc] init];
	}
	return _firstMenuArr;
}

@end
