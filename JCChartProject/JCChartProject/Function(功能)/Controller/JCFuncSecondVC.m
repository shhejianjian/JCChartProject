//
//  JCFuncSecondVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFuncSecondVC.h"
#import "MXConstant.h"
#import "JCFunctionCell.h"
#import "JCFuncThirdVC.h"
static NSString *ID=@"JCFunctionCell";


@interface JCFuncSecondVC ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *subFuncArr;


@end

@implementation JCFuncSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = self.secondFuncModel.name;
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCFunctionCell" bundle:nil] forCellReuseIdentifier:ID];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadData{
    NSArray *subArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:self.secondFuncModel.childList];
    for (JCFuncBaseModel *subModel in subArr) {
        [self.subFuncArr addObject:subModel];
    }
    [self.myTableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.subFuncArr.count;
    
}


- (JCFunctionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCFunctionCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCFunctionCell alloc]init];
        
    }
    cell.functionModel = self.subFuncArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JCFuncBaseModel *functionModel = self.subFuncArr[indexPath.row];
    JCFuncThirdVC *funcThirdVC = [[JCFuncThirdVC alloc]init];
    funcThirdVC.thirdFuncModel = functionModel;
    [self.navigationController pushViewController:funcThirdVC animated:YES];
}


- (NSMutableArray *)subFuncArr {
	if(_subFuncArr == nil) {
		_subFuncArr = [[NSMutableArray alloc] init];
	}
	return _subFuncArr;
}

@end
