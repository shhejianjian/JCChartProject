//
//  JCSecondMenuVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/13.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCSecondMenuVC.h"
#import "JCFunctionCell.h"
#import "MXConstant.h"
#import "JCThirdMenuVC.h"
static NSString *ID=@"JCFunctionCell";

@interface JCSecondMenuVC ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *secondMenuArr;
@end

@implementation JCSecondMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = _secondModel.name;
    NSArray *arr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:_secondModel.childList];
    for (JCFuncBaseModel *second in arr) {
        [self.secondMenuArr addObject: second];
    }
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCFunctionCell" bundle:nil] forCellReuseIdentifier:ID];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.secondMenuArr.count;
    
}


- (JCFunctionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCFunctionCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCFunctionCell alloc]init];
        
    }
    cell.functionModel = self.secondMenuArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 44;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JCFuncBaseModel *model = self.secondMenuArr[indexPath.row];
    JCThirdMenuVC *thirdMenuVC = [[JCThirdMenuVC alloc]init];
    thirdMenuVC.thirdModel = model;
    [self.navigationController pushViewController:thirdMenuVC animated:YES];
    
}



- (NSMutableArray *)secondMenuArr {
	if(_secondMenuArr == nil) {
		_secondMenuArr = [[NSMutableArray alloc] init];
	}
	return _secondMenuArr;
}

@end
