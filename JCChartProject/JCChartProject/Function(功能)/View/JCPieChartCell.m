//
//  JCPieChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCPieChartCell.h"
#import "JHChartHeader.h"
#import "MXConstant.h"

@interface JCPieChartCell ()
@property (nonatomic, strong) NSMutableArray *pieDescrArr;
@property (nonatomic, strong) NSMutableArray *pieValuArr;
@property (nonatomic, strong) NSMutableArray *pieObjectIdArr;
@property (nonatomic, strong) JHPieChart *pieChart;

@property (nonatomic, copy) NSString *checkStr;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JCPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkStr = @"0";
    self.pieChart.frame = CGRectMake(0, 44, KScreenW, 400);
    self.pieChart.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.pieChart];
    self.pieChart.positionChangeLengthWhenClick = 15;
    self.pieChart.showDescripotion = YES;
    
}


- (void)setChartModel:(JCChartModel *)chartModel {
    _chartModel = chartModel;
    NSLog(@"chartModel:%@",chartModel.jsonData);
    
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    self.titleLabel.text = [NSString stringWithFormat:@"%@-%@",chartModel.name,jsonDataModel.name];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    [self loadChartDataWithUnit:dateRangeModel.unit AndValue:dateRangeModel.value andChartType:jsonDataModel.chartType andYarr:yArr];
}


- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr{
    
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = @"";
    if ([chartType isEqualToString:@"pie"] || [chartType isEqualToString:@"dashboard"]) {
        timeUnit = @"None";
    } else {
        timeUnit = unit;
    }
    [self.pieObjectIdArr removeAllObjects];
    [self.pieDescrArr removeAllObjects];
    
    for (JCChartModel *yModel in yArr) {
        [self.pieObjectIdArr addObject:yModel.objectId];
        [self.pieDescrArr addObject:yModel.name];
    }
    if ([chartType isEqualToString:@"pie"]) {
        NSString *string = [self.pieObjectIdArr componentsJoinedByString:@"&dataPoints="];
        
        NSString *getUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,string,starTime,endTIme,timeUnit];
        [XHHttpTool get:getUrl params:nil jessionid:jsessionid success:^(id json) {
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
            NSDictionary *olddict = [self changeType:barChartModel.values];
            
            //字典按照objectid进行排序，否则会和name不对应。
            NSMutableArray *valueArray = [NSMutableArray array];
            for (NSString *sortString in self.pieObjectIdArr) {
                [valueArray addObject:[olddict objectForKey:sortString]];
            }
            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
            for (int i = 0; i < valueArray.count; i++) {
                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [self.pieValuArr removeAllObjects];
            for (NSString *firstStr in valueDic) {
                for (NSArray *secondStr in valueDic[firstStr]) {
                    for (NSString *thirdStr in secondStr) {
                        [self.pieValuArr addObject:thirdStr];
                    }
                }
            }
            self.pieChart.valueArr = self.pieValuArr;
            self.pieChart.descArr = self.pieDescrArr;
            if (![self.checkStr isEqualToString:@"1"]) {
                [self.pieChart showAnimation];
                self.checkStr = @"1";
            }
        } failure:^(NSError *error) {
            
        }];
        
    } else if ([chartType isEqualToString:@"bar"]){
        NSLog(@"bar");
    } else if ([chartType isEqualToString:@"linebar"]){
        NSLog(@"linebar");
    } else {
        return;
    }
    
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
    return @"0";
}
//获取开始时间
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



- (NSMutableArray *)pieDescrArr {
	if(_pieDescrArr == nil) {
		_pieDescrArr = [[NSMutableArray alloc] init];
	}
	return _pieDescrArr;
}

- (NSMutableArray *)pieValuArr {
	if(_pieValuArr == nil) {
		_pieValuArr = [[NSMutableArray alloc] init];
	}
	return _pieValuArr;
}

- (NSMutableArray *)pieObjectIdArr {
	if(_pieObjectIdArr == nil) {
		_pieObjectIdArr = [[NSMutableArray alloc] init];
	}
	return _pieObjectIdArr;
}

- (JHPieChart *)pieChart {
	if(_pieChart == nil) {
		_pieChart = [[JHPieChart alloc] init];
	}
	return _pieChart;
}

@end
