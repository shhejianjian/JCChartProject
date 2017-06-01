//
//  JCFunctionVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFunctionVC.h"
#import "MXConstant.h"
#import "JCFuncSecondVC.h"
#import "JCFuncBaseModel.h"
#import "JCFunctionCell.h"
//#import "ContactsListHeader.h"
//#import "ContactsGroupModel.h"

static NSString *ID=@"JCFunctionCell";



@interface JCFunctionVC ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *funcArr;

@end

@implementation JCFunctionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"功能";
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

            NSLog(@"1级：%@--%@",mainModel.name,mainModel.objectId);
            NSArray *subArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:mainModel.childList];
            for (JCFuncBaseModel *subModel in subArr) {
                NSLog(@"2级：%@",subModel.name);
                
                NSArray *thirdArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:subModel.childList];
                for (JCFuncBaseModel *thirdModel in thirdArr) {
                    NSLog(@"3级：%@",thirdModel.name);
                    
                }
                
            }
            
            [self.funcArr addObject:mainModel];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.funcArr.count;
    
}


- (JCFunctionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCFunctionCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCFunctionCell alloc]init];
        
    }
    cell.functionModel = self.funcArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        JCFuncBaseModel *functionModel = self.funcArr[indexPath.row];
        JCFuncSecondVC *funcSecondVC = [[JCFuncSecondVC alloc]init];
        funcSecondVC.secondFuncModel = functionModel;
        [self.navigationController pushViewController:funcSecondVC animated:YES];
}



- (NSMutableArray *)funcArr {
	if(_funcArr == nil) {
		_funcArr = [[NSMutableArray alloc] init];
	}
	return _funcArr;
}



@end
