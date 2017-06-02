//
//  JCFuncChartVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFuncChartVC.h"
#import "MXConstant.h"
#import "JCChartModel.h"
#import "JCBarChartCell.h"
#import "JCLineChartCell.h"
#import "JCLineBarChartCell.h"
#import "JCPieChartCell.h"
#import "JCDashboardChartCell.h"

static NSString *barID=@"JCBarChartCell";
static NSString *lineID=@"JCLineChartCell";
static NSString *lineBarID=@"JCLineBarChartCell";
static NSString *pieID=@"JCPieChartCell";
static NSString *dashboardID=@"JCDashboardChartCell";





@interface JCFuncChartVC () <JCBarChartCellDelegate>


@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *chartCountArr;
@property (nonatomic, strong) NSMutableArray *testArr;

@property (nonatomic, assign) CGFloat barheight;

@end

@implementation JCFuncChartVC

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = self.titleName;
    [self loadMenuDetailWithObjectId:self.objectId];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCBarChartCell" bundle:nil] forCellReuseIdentifier:barID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCLineChartCell" bundle:nil] forCellReuseIdentifier:lineID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCLineBarChartCell" bundle:nil] forCellReuseIdentifier:lineBarID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCPieChartCell" bundle:nil] forCellReuseIdentifier:pieID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCDashboardChartCell" bundle:nil] forCellReuseIdentifier:dashboardID];
    
}

- (void)loadMenuDetailWithObjectId:(NSString*)objectId{
    
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *menuDetailUrl = [NSString stringWithFormat:@"%@%@",MenuDetailUrl,objectId];
    [XHHttpTool get:menuDetailUrl params:nil jessionid:jsessionid success:^(id json) {
        NSLog(@"jsonLL::::%@",json);
//        JCChartModel *mainModel = [JCChartModel mj_objectWithKeyValues:json];
//        NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:mainModel.appCustomMenuItemList];
        NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
        for (JCChartModel *chartModel in arr) {
            [self.testArr addObject:chartModel];
            JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
            [self.chartCountArr addObject:xmodel];
        }
        [self.myTableView reloadData];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return self.chartCountArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = nil;
    JCChartModel *chartTypeModel = self.chartCountArr[indexPath.row];
    if ([chartTypeModel.chartType isEqualToString:@"bar"]) {
        JCBarChartCell *barCell=[tableView dequeueReusableCellWithIdentifier:barID];
        
        if (!barCell) {
            
            barCell=[[JCBarChartCell alloc]init];
            
        }
        barCell.firstObjectId = self.objectId;
        barCell.chartModel = self.testArr[indexPath.row];
        barCell.delegate = self;
        cell = barCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"line"]) {
        JCLineChartCell *lineCell=[tableView dequeueReusableCellWithIdentifier:lineID];
        
        if (!lineCell) {
            
            lineCell=[[JCLineChartCell alloc]init];
            
        }
        lineCell.chartModel = self.testArr[indexPath.row];
        cell = lineCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"linebar"]) {
        JCLineBarChartCell *lineBarCell=[tableView dequeueReusableCellWithIdentifier:lineBarID];
        
        if (!lineBarCell) {
            
            lineBarCell=[[JCLineBarChartCell alloc]init];
            
        }
        lineBarCell.chartModel = self.testArr[indexPath.row];
        cell = lineBarCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"pie"]) {
        JCPieChartCell *pieCell=[tableView dequeueReusableCellWithIdentifier:pieID];
        
        if (!pieCell) {
            
            pieCell=[[JCPieChartCell alloc]init];
            
        }
        pieCell.chartModel = self.testArr[indexPath.row];
       
        cell = pieCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"dashboard"]) {
        JCDashboardChartCell *dashboardCell=[tableView dequeueReusableCellWithIdentifier:dashboardID];
        
        if (!dashboardCell) {
            
            dashboardCell=[[JCDashboardChartCell alloc]init];
            
        }
        dashboardCell.chartModel = self.testArr[indexPath.row];
        cell = dashboardCell;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)passValueForCellHeight:(CGFloat)height{
    self.barheight = height;
    [self.myTableView reloadData];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JCChartModel *chartTypeModel = self.chartCountArr[indexPath.row];
    if ([chartTypeModel.chartType isEqualToString:@"bar"]) {
        if (self.barheight != 0) {
            return self.barheight+80;
        }
    } else {
        return 500;
    }
    return 100;
}



- (NSMutableArray *)chartCountArr {
	if(_chartCountArr == nil) {
		_chartCountArr = [[NSMutableArray alloc] init];
	}
	return _chartCountArr;
}


- (NSMutableArray *)testArr {
	if(_testArr == nil) {
		_testArr = [[NSMutableArray alloc] init];
	}
	return _testArr;
}

@end
