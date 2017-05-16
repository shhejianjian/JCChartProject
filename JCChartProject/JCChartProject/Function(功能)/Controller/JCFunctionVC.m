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
//@property (nonatomic, strong) NSMutableArray *contactsListData;
//@property (nonatomic, strong) NSMutableArray *nameArr;
//@property (nonatomic, strong) NSMutableArray *mainFuncArr;
@property (nonatomic, strong) NSMutableArray *funcArr;

@end

@implementation JCFunctionVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"功能";
    [self loadFirstMenu];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCFunctionCell" bundle:nil] forCellReuseIdentifier:ID];
//    self.myTableView.tableFooterView = [UIView new];
//    self.myTableView.sectionHeaderHeight = 0;
}
- (void)loadFirstMenu{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *firstMenuUrl = [NSString stringWithFormat:@"%@%@",MenuUrl,userid];
    
    [XHHttpTool get:firstMenuUrl params:nil jessionid:jsessionid success:^(id json) {
        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:json];
        for (JCFuncBaseModel *mainModel in mainArr) {
            //[self.nameArr addObject:mainModel.name];
            [self.funcArr addObject:mainModel];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
//    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessionid] forHTTPHeaderField:@"Cookie"];
//    [manager GET:firstMenuUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
//        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:result];
//        for (JCFuncBaseModel *mainModel in mainArr) {
////            [self.nameArr addObject:mainModel.name];
//            [self.funcArr addObject:mainModel];
//            
//        }
////        for(NSInteger i = 0; i < [self.nameArr count]; i ++){
////            ContactsGroupModel *tempModel = [[ContactsGroupModel alloc]init];
////            tempModel.name = self.nameArr[i];
////            [self.contactsListData addObject:tempModel];
////        }
//
//        [self.myTableView reloadData];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
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















//- (NSArray *)contactsListData{
//    if(!contactsListData){
//        contactsListData = [NSMutableArray new];
//        NSArray *names = @[@"全部好友",@"阿里巴巴",@"腾讯集团",@"百度",@"迅雷",@"优酷",@"爱奇艺"];
//        
//        for(NSInteger i = 0; i < [names count]; i ++){
//            ContactsGroupModel *tempModel = [[ContactsGroupModel alloc]init];
//            tempModel.name = names[i];
//            tempModel.personNumber = [NSString stringWithFormat:@"%li/%li",i*arc4random_uniform(50),i*arc4random_uniform(100)+50];
//            [contactsListData addObject:tempModel];
//        }
//    }
//    return contactsListData;
//}







//#pragma mark - TableView DataSource and Delegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.contactsListData.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    ContactsGroupModel *model = self.contactsListData[section];
//    return model.isOpen?self.subFuncArr.count:0;
//}
//- (JCFunctionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    JCFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[JCFunctionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//    }
//    [self configureTableViewCell:cell indexPath:indexPath];
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//}
//- (void)configureTableViewCell:(JCFunctionCell *)cell indexPath:(NSIndexPath *)indexPath{
//    cell.functionModel = self.subFuncArr[indexPath.row];
//    
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ContactsListHeader *headView = [ContactsListHeader headerView:tableView];
//    headView.arrowButton.tag = section;
//    headView.delegate = self;
//    headView.groupModel = self.contactsListData[section];
//    headView.contentView.backgroundColor = [UIColor whiteColor];
//    return headView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44.f;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44.f;
//}
//#pragma mark - 代理方法的实现
//- (void)didSelectTableViewHeaderFooterView:(NSInteger)index
//{
//    NSLog(@"%ld",index);
//    ContactsGroupModel *model = self.contactsListData[index];
//    
//    ContactsGroupModel *subModel = self.mainFuncArr[index];
//    NSLog(@"isopen:%d",model.isOpen);
//    if (model.isOpen) {
//        [self.subFuncArr removeAllObjects];
//    }
//        NSArray *subArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:subModel.childList];
//        for (JCFuncBaseModel *secondModel in subArr) {
//            [self.subFuncArr addObject:secondModel];
//        }
//    
//    
//    
//    [self.myTableView reloadData];
//}

















//
//
- (NSMutableArray *)funcArr {
	if(_funcArr == nil) {
		_funcArr = [[NSMutableArray alloc] init];
	}
	return _funcArr;
}

//- (NSMutableArray *)contactsListData {
//	if(_contactsListData == nil) {
//		_contactsListData = [[NSMutableArray alloc] init];
//	}
//	return _contactsListData;
//}
//
//- (NSMutableArray *)nameArr {
//	if(_nameArr == nil) {
//		_nameArr = [[NSMutableArray alloc] init];
//	}
//	return _nameArr;
//}
//
//- (NSMutableArray *)subFuncArr {
//	if(_subFuncArr == nil) {
//		_subFuncArr = [[NSMutableArray alloc] init];
//	}
//	return _subFuncArr;
//}
//
//- (NSMutableArray *)mainFuncArr {
//	if(_mainFuncArr == nil) {
//		_mainFuncArr = [[NSMutableArray alloc] init];
//	}
//	return _mainFuncArr;
//}

@end
