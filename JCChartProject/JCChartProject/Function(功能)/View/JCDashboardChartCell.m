//
//  JCDashboardChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCDashboardChartCell.h"
#import "WMGaugeView.h"
#import "MXConstant.h"
#import "ZFChart.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface JCDashboardChartCell ()
@property (strong, nonatomic) IBOutlet WMGaugeView *gaugeView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, copy) NSString *UnitStr;
@property (nonatomic, assign) NSInteger UnitValueStr;
@property (nonatomic, copy) NSString *chartTypeStr;

@property (nonatomic, strong) NSMutableArray *dashboardDescrArr;
@property (nonatomic, strong) NSMutableArray *dashboardObjectIdArr;
@end

@implementation JCDashboardChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setUI {
    
    _gaugeView.showRangeLabels = YES;
    _gaugeView.rangeColors = @[ RGB(90, 255, 211),RGB(231, 32, 43)];
    
    _gaugeView.showUnitOfMeasurement = YES;
    _gaugeView.showInnerBackground = NO;
    _gaugeView.needleStyle = WMGaugeViewNeedleStyleFlatThin;
    _gaugeView.needleScrewStyle = WMGaugeViewNeedleScrewStylePlain;
    
}

- (void)setChartModel:(JCChartModel *)chartModel {
    _chartModel = chartModel;
    [self setUI];
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    
    int maxValue = jsonDataModel.maxValue.intValue;
    _gaugeView.maxValue = maxValue;
    int range1 = jsonDataModel.maxValue.intValue * 0.8;
    _gaugeView.rangeValues = @[ @(range1),@(maxValue)];
    _gaugeView.value = 3157;
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    for (JCChartModel *model in yArr) {
        JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:model.measureUnit];
        _gaugeView.unitOfMeasurement = [NSString stringWithFormat:@"3157 %@",xmodel.name];
    }
    
    self.UnitStr = dateRangeModel.unit;
    self.UnitValueStr = dateRangeModel.value;
    self.chartTypeStr = jsonDataModel.chartType;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",jsonDataModel.name];
    if (self.dashboardDescrArr.count == 0) {
        [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:yArr];
    }
}

- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr {
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = unit;
    
    [self.dashboardObjectIdArr removeAllObjects];
    [self.dashboardDescrArr removeAllObjects];
    for (JCChartModel *yModel in yArr) {
        [self.dashboardObjectIdArr addObject:yModel.objectId];
        [self.dashboardDescrArr addObject:yModel.name];
    }
    if ([chartType isEqualToString:@"dashboard"]) {
        NSString *string = [self.dashboardObjectIdArr componentsJoinedByString:@"&dataPoints="];
        
        NSString *getUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,string,starTime,endTIme,timeUnit];
        [XHHttpTool get:getUrl params:nil jessionid:jsessionid success:^(id json) {
            
            NSLog(@"json:::%@",json);
            
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
//            NSDictionary *olddict = [self changeType:barChartModel.values];
//            
//            //字典按照objectid进行排序，否则会和name不对应。
//            NSMutableArray *valueArray = [NSMutableArray array];
//            for (NSString *sortString in self.dashboardObjectIdArr) {
//                [valueArray addObject:[olddict objectForKey:sortString]];
//            }
//            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
//            for (int i = 0; i < valueArray.count; i++) {
//                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
//            }
            
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
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


- (NSMutableArray *)dashboardDescrArr {
	if(_dashboardDescrArr == nil) {
		_dashboardDescrArr = [[NSMutableArray alloc] init];
	}
	return _dashboardDescrArr;
}

- (NSMutableArray *)dashboardObjectIdArr {
	if(_dashboardObjectIdArr == nil) {
		_dashboardObjectIdArr = [[NSMutableArray alloc] init];
	}
	return _dashboardObjectIdArr;
}

@end
