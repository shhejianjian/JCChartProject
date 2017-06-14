//
//  JCThirdMenuVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/13.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCThirdMenuVC.h"
#import "MXConstant.h"
#import "JCThirdFuncCell.h"

static NSString *ID=@"JCThirdFuncCell";

NSString *subscribStr;

@interface JCThirdMenuVC () <JCThirdFuncCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *thirdMenuArr;
@property (nonatomic, strong) NSIndexPath *myIndexPath;
@property (nonatomic, strong) NSMutableArray *btnSelectArr;
@property (nonatomic, strong) NSMutableArray *oldSelectArr;

@property (nonatomic, assign) BOOL isSubscribe;
@end

@implementation JCThirdMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSubscribe = NO;
    self.mxNavigationItem.title = _thirdModel.name;
    [self loadFirstMenu];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCThirdFuncCell" bundle:nil] forCellReuseIdentifier:ID];
}

- (void)loadFirstMenu{
    [self.thirdMenuArr removeAllObjects];
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *firstMenuUrl = [NSString stringWithFormat:@"%@%@",MenuUrl,userid];
    [XHHttpTool get:firstMenuUrl params:nil jessionid:jsessionid success:^(id json) {
        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:json];
        for (JCFuncBaseModel *mainModel in mainArr) {
            NSArray *secondArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:mainModel.childList];
            for (JCFuncBaseModel *secondModel in secondArr) {
                if ([secondModel.objectId isEqualToString:_thirdModel.objectId]) {
                    NSArray *arr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:secondModel.childList];
                    for (JCFuncBaseModel *second in arr) {
                        [self.thirdMenuArr addObject: second];
                        [self.btnSelectArr addObject:second.favorite];
                        [self.oldSelectArr addObject:second.favorite];
                    }
                }
            }
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    
    return self.thirdMenuArr.count;
    
}


- (JCThirdFuncCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    JCThirdFuncCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCThirdFuncCell alloc]init];
        
    }
    self.myIndexPath = indexPath;
    cell.favoriteBtn.tag = indexPath.row;
    cell.delegate = self;
    cell.functionModel = self.thirdMenuArr[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 44;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)clickBtnPassValue:(NSInteger)index andButton:(UIButton *)btn{
    if (btn.selected) {
        [self.btnSelectArr replaceObjectAtIndex:index withObject:@"0"];
    } else if (!btn.selected){
        [self.btnSelectArr replaceObjectAtIndex:index withObject:@"1"];
    }
    btn.selected = !btn.selected;
    
    NSLog(@"%@---%@---%ld",self.oldSelectArr,self.btnSelectArr,index);
    
    bool bol = false;
    [self.oldSelectArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    [self.btnSelectArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2){return [obj1 localizedStandardCompare: obj2];}];
    if (self.btnSelectArr.count == self.oldSelectArr.count) {
        
        bol = true;
        for (int16_t i = 0; i < self.oldSelectArr.count; i++) {
            
            id c1 = [self.oldSelectArr objectAtIndex:i];
            id newc = [self.btnSelectArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = false;
                break;
            }
        }
    }
    
    if (bol) {
        self.isSubscribe = NO;
        NSLog(@"相同");
    }   
    else {   
        self.isSubscribe = YES;
        NSLog(@"不同");
    }
//    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"appCustomMenuId"] = model.objectId;
//    if (btn.selected) {
//        params[@"favorite"] = @"0";
//    } else if (!btn.selected){
//        params[@"favorite"] = @"1";
//    }
//    [XHHttpTool put:favoriteMenuUrl params:params jessionid:jsessionid success:^(id json) {
//        
//        NSLog(@"json:%@---%@",json,params);
//        btn.selected = !btn.selected;
//        subscribStr = @"订阅";
//    } failure:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.isSubscribe) {
        int i = -1;
        NSMutableDictionary *firstParams = [NSMutableDictionary dictionary];
        firstParams[@"parentId"] = _thirdModel.objectId;
        NSMutableArray *listArr = [NSMutableArray array];
        for (JCFuncBaseModel *funModel in self.thirdMenuArr) {
            i++;
            NSMutableDictionary *secondParams = [NSMutableDictionary dictionary];
            secondParams[@"objectId"] = funModel.objectId;
            secondParams[@"favorite"] = self.btnSelectArr[i];
            [listArr addObject:secondParams];
        }
        firstParams[@"favoriteList"] = listArr;
        NSLog(@"params::%@",firstParams);
    }
}


- (NSMutableArray *)thirdMenuArr {
	if(_thirdMenuArr == nil) {
		_thirdMenuArr = [[NSMutableArray alloc] init];
	}
	return _thirdMenuArr;
}

- (NSMutableArray *)btnSelectArr {
	if(_btnSelectArr == nil) {
		_btnSelectArr = [[NSMutableArray alloc] init];
	}
	return _btnSelectArr;
}

- (NSMutableArray *)oldSelectArr {
	if(_oldSelectArr == nil) {
		_oldSelectArr = [[NSMutableArray alloc] init];
	}
	return _oldSelectArr;
}

@end
