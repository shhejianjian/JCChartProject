//
//  JCLineBarChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCLineBarChartCell.h"
#import "MXConstant.h"
#import "JCChartProject-Bridging-Header.h"
#import "JCChartProject-Swift.h"
#import "JCCombineChart.h"

@interface JCLineBarChartCell ()
@property (nonatomic, strong) CombinedChartView *combineChartView;

@property (nonatomic, copy) NSString *UnitStr;
@property (nonatomic, assign) NSInteger UnitValueStr;
@property (nonatomic, copy) NSString *chartTypeStr;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *linebarDescrArr;
@property (nonatomic, strong) NSMutableArray *linebarPointGroupArr;
@property (nonatomic, strong) NSMutableArray *linebarObjectIdArr;

@property (nonatomic, strong) NSMutableArray *linebarLineIdArr;
@property (nonatomic, strong) NSMutableArray *linebarBarIdArr;
@property (nonatomic, strong) NSMutableArray *linebarLineValueArr;
@property (nonatomic, strong) NSMutableArray *linebarBarValueArr;

@property (nonatomic, strong) NSMutableArray *linebarXValueArr;


@end

@implementation JCLineBarChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CombinedChartView *combine = [[CombinedChartView alloc] init];
    self.combineChartView = combine;
    combine.frame = CGRectMake(0, 64, KScreenW, 400);
    combine.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:combine];
    
}

- (void)setChartModel:(JCChartModel *)chartModel{
    _chartModel = chartModel;
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    
    self.UnitStr = dateRangeModel.unit;
    self.UnitValueStr = dateRangeModel.value;
    self.chartTypeStr = jsonDataModel.chartType;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",jsonDataModel.name];
    if (self.linebarDescrArr.count == 0) {
        [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:yArr];
    }
    
}

- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr {
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = unit;
    
    [self.linebarPointGroupArr removeAllObjects];
    [self.linebarObjectIdArr removeAllObjects];
    [self.linebarDescrArr removeAllObjects];
    [self.linebarLineIdArr removeAllObjects];
    [self.linebarBarIdArr removeAllObjects];
    for (JCChartModel *yModel in yArr) {
        [self.linebarObjectIdArr addObject:yModel.objectId];
        if (yModel.drillBy) {
            [self.linebarPointGroupArr addObject:yModel.drillBy];
        }
        [self.linebarDescrArr addObject:yModel.name];
        if ([chartType isEqualToString:@"linebar"]) {
            if ([yModel.group isEqualToString:@"bar"]) {
                [self.linebarBarIdArr addObject:yModel.objectId];
            }
            if ([yModel.group isEqualToString:@"line"]){
                [self.linebarLineIdArr addObject:yModel.objectId];
            }
        }
    }
    NSString *barString = [self.linebarBarIdArr componentsJoinedByString:@"&dataPoints="];
    NSString *bargetUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,barString,starTime,endTIme,timeUnit];
    [self getJsonDataWithUrl:bargetUrl andJesId:jsessionid andType:@"bar" andIdArr:self.linebarBarIdArr];
    NSString *lineString = [self.linebarLineIdArr componentsJoinedByString:@"&dataPoints="];
    NSString *linegetUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,lineString,starTime,endTIme,timeUnit];
    [self getJsonDataWithUrl:linegetUrl andJesId:jsessionid andType:@"line" andIdArr:self.linebarLineIdArr];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        JCCombineChart *helper = [[JCCombineChart alloc] init];
        helper.lineValueArr =self.linebarLineValueArr;
        helper.XValueArr =self.linebarXValueArr;
        helper.barValueArr =self.linebarBarValueArr;
        [helper setCombineBarChart:self.combineChartView lineTitle:@"line" bar1Title:@"bar1"];
    });

    
}

- (void)getJsonDataWithUrl:(NSString *)url andJesId:(NSString *)jesId andType:(NSString *)type andIdArr:(NSArray *)idArr{
    if ([type isEqualToString:@"bar"]) {
        NSMutableArray *barValueArr = [NSMutableArray array];
        [XHHttpTool get:url params:nil jessionid:jesId success:^(id json) {
            NSLog(@"barjson:%@",json);
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
            NSDictionary *olddict = [self changeType:barChartModel.values];
            [self.linebarXValueArr removeAllObjects];
            if ([self.UnitStr isEqualToString:@"Hour"]) {
                for (NSString *str in barChartModel.category) {
                    NSString *newStr = [str substringFromIndex:10];
                    [self.linebarXValueArr addObject:newStr];
                }
            } else {
                for (NSString *str in barChartModel.category) {
                    [self.linebarXValueArr addObject:str];
                }
            }
            [self.linebarBarValueArr removeAllObjects];
            //字典按照objectid进行排序，否则会和name不对应。
            NSMutableArray *valueArray = [NSMutableArray array];
            for (NSString *sortString in idArr) {
                [valueArray addObject:[olddict objectForKey:sortString]];
            }
            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
            for (int i = 0; i < valueArray.count; i++) {
                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            for (NSString *firstStr in valueDic) {
                    NSMutableArray *subArr = [NSMutableArray array];;
                    for (NSArray *secondStr in valueDic[firstStr]) {
                        for (int i = 0; i < secondStr.count; i++) {
                            if (i == 0) {
                                NSString *str = [self notRounding:[secondStr[i] floatValue] afterPoint:0];
                                [subArr addObject:str];
                            }
                        }
                    }
                [barValueArr addObject:subArr];
            }
            [self performSelectorOnMainThread:@selector(getDataList:)
                                   withObject:barValueArr // 将局部变量dataList作为参数传出去
                                waitUntilDone:YES];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    if ([type isEqualToString:@"line"]) {
        [XHHttpTool get:url params:nil jessionid:jesId success:^(id json) {
            NSLog(@"linejson:%@",json);
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
            NSDictionary *olddict = [self changeType:barChartModel.values];
            [self.linebarXValueArr removeAllObjects];
            if ([self.UnitStr isEqualToString:@"Hour"]) {
                for (NSString *str in barChartModel.category) {
                    NSString *newStr = [str substringFromIndex:10];
                    [self.linebarXValueArr addObject:newStr];
                }
            } else {
                for (NSString *str in barChartModel.category) {
                    [self.linebarXValueArr addObject:str];
                }
            }
            [self.linebarLineValueArr removeAllObjects];
            //字典按照objectid进行排序，否则会和name不对应。
            NSMutableArray *valueArray = [NSMutableArray array];
            for (NSString *sortString in idArr) {
                [valueArray addObject:[olddict objectForKey:sortString]];
            }
            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
            for (int i = 0; i < valueArray.count; i++) {
                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            for (NSString *firstStr in valueDic) {
                NSMutableArray *subArr = [NSMutableArray array];;
                for (NSArray *secondStr in valueDic[firstStr]) {
                    for (int i = 0; i < secondStr.count; i++) {
                        if (i == 0) {
                            NSString *str = [self notRounding:[secondStr[i] floatValue] afterPoint:0];
                            [subArr addObject:str];
                        }
                    }
                }
                [self.linebarLineValueArr addObject:subArr];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
        
}


-(void)getDataList:(id)sender {
    NSMutableArray * dataList = (NSMutableArray *)sender;
    self.linebarBarValueArr = dataList;
    
}


//四舍五入
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[text sizeWithAttributes:attrs];
    
    return size.width;
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

- (NSMutableArray *)linebarDescrArr {
	if(_linebarDescrArr == nil) {
		_linebarDescrArr = [[NSMutableArray alloc] init];
	}
	return _linebarDescrArr;
}

- (NSMutableArray *)linebarPointGroupArr {
	if(_linebarPointGroupArr == nil) {
		_linebarPointGroupArr = [[NSMutableArray alloc] init];
	}
	return _linebarPointGroupArr;
}

- (NSMutableArray *)linebarObjectIdArr {
	if(_linebarObjectIdArr == nil) {
		_linebarObjectIdArr = [[NSMutableArray alloc] init];
	}
	return _linebarObjectIdArr;
}

- (NSMutableArray *)linebarXValueArr {
	if(_linebarXValueArr == nil) {
		_linebarXValueArr = [[NSMutableArray alloc] init];
	}
	return _linebarXValueArr;
}



- (NSMutableArray *)linebarLineIdArr {
	if(_linebarLineIdArr == nil) {
		_linebarLineIdArr = [[NSMutableArray alloc] init];
	}
	return _linebarLineIdArr;
}

- (NSMutableArray *)linebarBarIdArr {
	if(_linebarBarIdArr == nil) {
		_linebarBarIdArr = [[NSMutableArray alloc] init];
	}
	return _linebarBarIdArr;
}

- (NSMutableArray *)linebarLineValueArr {
	if(_linebarLineValueArr == nil) {
		_linebarLineValueArr = [[NSMutableArray alloc] init];
	}
	return _linebarLineValueArr;
}

- (NSMutableArray *)linebarBarValueArr {
	if(_linebarBarValueArr == nil) {
		_linebarBarValueArr = [[NSMutableArray alloc] init];
	}
	return _linebarBarValueArr;
}

@end
