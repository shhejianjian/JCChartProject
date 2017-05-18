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






@interface JCFuncChartVC ()


@property (nonatomic, strong) NSMutableArray *chartArr;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *chartCountArr;

@property (nonatomic, strong) NSMutableArray *pieChartDescArr;
@property (nonatomic, strong) NSMutableArray *pieChartValueArr;

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
    
    NSString *str = @"17675.99999999953";
    NSLog(@"%@",[NSString stringWithFormat:@"%d",([str intValue])]);
}

- (void)loadMenuDetailWithObjectId:(NSString*)objectId{
    [self.pieChartDescArr removeAllObjects];
    [self.pieChartValueArr removeAllObjects];
    dispatch_queue_t serialQueue=dispatch_queue_create(0, DISPATCH_QUEUE_SERIAL);
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *menuDetailUrl = [NSString stringWithFormat:@"%@%@",MenuDetailUrl,objectId];
    [XHHttpTool get:menuDetailUrl params:nil jessionid:jsessionid success:^(id json) {
        
        NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
        for (JCChartModel *chartModel in arr) {
            [self.chartArr removeAllObjects];
            JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
            [self.chartCountArr addObject:xmodel];
        
            JCChartModel *unitModel = [JCChartModel mj_objectWithKeyValues:xmodel.defaultDateRange];
            
            NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:xmodel.dataPoints];
            for (JCChartModel *yModel in yArr) {
                [self.chartArr addObject:yModel.objectId];
                if ([xmodel.chartType isEqualToString:@"pie"]) {
                    [self.pieChartDescArr addObject:yModel.name];
                }
            }
            [self loadChartDataWithObjectId:self.chartArr andUnit:unitModel.unit AndValue:unitModel.value andChartType:xmodel.chartType andQueue:serialQueue];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadChartDataWithObjectId:(NSMutableArray *)objectIdArr andUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andQueue:(dispatch_queue_t)queue{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = @"";
    if ([chartType isEqualToString:@"pie"] || [chartType isEqualToString:@"dashboard"]) {
        timeUnit = @"None";
    } else {
        timeUnit = unit;
    }
    NSString *objectIdStr = @"";
    int i = 0;
    
    if ([chartType isEqualToString:@"pie"]) {

        
        
        
            for (NSString *objectId in objectIdArr) {
                objectIdStr = [NSString stringWithFormat:@"dataPoints=%@",objectId];
                i++;
                NSLog(@"i====%d",i);
                NSString *url = [NSString stringWithFormat:@"%@%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,objectIdStr,starTime,endTIme,timeUnit];
                dispatch_async(queue, ^{

                
                    [XHHttpTool get:url params:nil jessionid:jsessionid success:^(id json) {
                        NSLog(@"%d---",i);
                        JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
                        NSDictionary *dict = [self changeType:barChartModel.values];
                            for (NSString *firstStr in dict) {
                                for (NSArray *secondStr in dict[firstStr]) {
                                    for (NSString *thirdStr in secondStr) {
                                        [self.pieChartValueArr addObject:thirdStr];
                                    }
                                }
                            }
                        [self.myTableView reloadData];
                        } failure:^(NSError *error) {
                        
                        }];

                });
            }
        
        
        
    } else if ([chartType isEqualToString:@"bar"]){
        NSLog(@"bar");
    } else if ([chartType isEqualToString:@"linebar"]){
        NSLog(@"linebar");
    } else {
        return;
    }
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
    NSLog(@"chartType:%@",chartTypeModel.chartType);
    if ([chartTypeModel.chartType isEqualToString:@"bar"]) {
        JCBarChartCell *barCell=[tableView dequeueReusableCellWithIdentifier:barID];
        
        if (!barCell) {
            
            barCell=[[JCBarChartCell alloc]init];
            
        }
        
        cell = barCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"line"]) {
        JCLineChartCell *lineCell=[tableView dequeueReusableCellWithIdentifier:lineID];
        
        if (!lineCell) {
            
            lineCell=[[JCLineChartCell alloc]init];
            
        }
        cell = lineCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"linebar"]) {
        JCLineBarChartCell *lineBarCell=[tableView dequeueReusableCellWithIdentifier:lineBarID];
        
        if (!lineBarCell) {
            
            lineBarCell=[[JCLineBarChartCell alloc]init];
            
        }
        cell = lineBarCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"pie"]) {
        JCPieChartCell *pieCell=[tableView dequeueReusableCellWithIdentifier:pieID];
        
        if (!pieCell) {
            
            pieCell=[[JCPieChartCell alloc]init];
            
        }
        pieCell.pieDescArr = self.pieChartDescArr;
        pieCell.pieValueArr = self.pieChartValueArr;
        cell = pieCell;
    } else if ([chartTypeModel.chartType isEqualToString:@"dashboard"]) {
        JCDashboardChartCell *dashboardCell=[tableView dequeueReusableCellWithIdentifier:dashboardID];
        
        if (!dashboardCell) {
            
            dashboardCell=[[JCDashboardChartCell alloc]init];
            
        }
        cell = dashboardCell;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 550;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}













-(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}
-(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
-(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
-(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
-(NSString *)nullToString
{
    return @"";
}

- (NSString*)getStartDateWithValue:(NSInteger)value andUnit:(NSString *)unit{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
//    NSDate *myDate = [NSDate date];
    NSDate *myDate = [self getTestDate];

    if ([unit isEqualToString:@"Day"]) {
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * -(value)];
        return [dateFormatter stringFromDate:newDate];
    } else if ([unit isEqualToString:@"Hour"]){
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * -(value)];
        return [dateFormatter stringFromDate:newDate];
    } else if ([unit isEqualToString:@"Week"]){
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * 7 * -(value)];
        return [dateFormatter stringFromDate:newDate];
    } else if ([unit isEqualToString:@"Month"]){
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * 7 * 30 -(value)];
        return [dateFormatter stringFromDate:newDate];
    } else if ([unit isEqualToString:@"Quarter"]){
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * 7 * 30 * 3 -(value)];
        return [dateFormatter stringFromDate:newDate];
    }else if ([unit isEqualToString:@"Year"]){
        NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * 7 * 30 * 12 -(value)];
        return [dateFormatter stringFromDate:newDate];
    }
    return 0;
}




- (NSString*)getNowDate{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}
- (NSDate *)getTestDate{
    //需要转换的字符串
    NSString*dateString=@"2017-04-24+00:00:00";
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:dateString];
    return date;
}

- (NSMutableArray *)chartArr {
	if(_chartArr == nil) {
		_chartArr = [[NSMutableArray alloc] init];
	}
	return _chartArr;
}


- (NSMutableArray *)chartCountArr {
	if(_chartCountArr == nil) {
		_chartCountArr = [[NSMutableArray alloc] init];
	}
	return _chartCountArr;
}


- (NSMutableArray *)pieChartDescArr {
	if(_pieChartDescArr == nil) {
		_pieChartDescArr = [[NSMutableArray alloc] init];
	}
	return _pieChartDescArr;
}

- (NSMutableArray *)pieChartValueArr {
	if(_pieChartValueArr == nil) {
		_pieChartValueArr = [[NSMutableArray alloc] init];
	}
	return _pieChartValueArr;
}



@end
