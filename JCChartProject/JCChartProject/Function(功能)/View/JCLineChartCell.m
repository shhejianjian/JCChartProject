//
//  JCLineChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCLineChartCell.h"
#import "ZFChart.h"
#import "MXConstant.h"

@interface JCLineChartCell ()<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic, copy) NSString *UnitStr;
@property (nonatomic, assign) NSInteger UnitValueStr;
@property (nonatomic, copy) NSString *chartTypeStr;

@property (nonatomic, strong) NSMutableArray *lineDescrArr;
@property (nonatomic, strong) NSMutableArray *linePointGroupArr;
@property (nonatomic, strong) NSMutableArray *lineObjectIdArr;
@property (nonatomic, strong) NSMutableArray *lineXValueArr;
@property (nonatomic, strong) NSMutableArray *lineValueArr;
@property (nonatomic, strong) NSMutableArray *subLineChartArr;
@end
@implementation JCLineChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    //    self.lineChart.isShowXLineSeparate = YES;
    self.lineChart.isShowYLineSeparate = YES;
    //    self.lineChart.isAnimated = NO;
    self.lineChart.isResetAxisLineMinValue = YES;
    //    self.lineChart.isShowAxisLineValue = NO;
    //    self.lineChart.isShadowForValueLabel = NO;
    self.lineChart.isShadow = NO;
    self.lineChart.isShowAxisLineValue = NO;
    //    self.lineChart.valueLabelPattern = kPopoverLabelPatternBlank;
    //    self.lineChart.valueCenterToCircleCenterPadding = 0;
    //    self.lineChart.separateColor = ZFYellow;
    self.lineChart.linePatternType = kLinePatternTypeForCurve;
    self.lineChart.unitColor = ZFBlack;
    self.lineChart.backgroundColor = ZFWhite;
    self.lineChart.xAxisColor = ZFBlack;
    self.lineChart.yAxisColor = ZFBlack;
    self.lineChart.axisLineNameColor = ZFBlack;
    self.lineChart.axisLineValueColor = ZFBlack;
    self.lineChart.xLineNameLabelToXAxisLinePadding = 40;
    [self.detailView addSubview:self.lineChart];
}

- (void)setChartModel:(JCChartModel *)chartModel{
    _chartModel = chartModel;
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    for (JCChartModel *model in yArr) {
        JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:model.measureUnit];
        self.lineChart.unit = xmodel.name;
    }
    self.UnitStr = dateRangeModel.unit;
    self.UnitValueStr = dateRangeModel.value;
    self.chartTypeStr = jsonDataModel.chartType;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",jsonDataModel.name];
    if (self.lineDescrArr.count == 0) {
        [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:yArr];
    }
}
- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr {
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = unit;
    
    [self.linePointGroupArr removeAllObjects];
    [self.lineObjectIdArr removeAllObjects];
    [self.lineDescrArr removeAllObjects];
    for (JCChartModel *yModel in yArr) {
        [self.lineObjectIdArr addObject:yModel.objectId];
        if (yModel.drillBy) {
            [self.linePointGroupArr addObject:yModel.drillBy];
        }
        [self.lineDescrArr addObject:yModel.name];
    }
    if ([chartType isEqualToString:@"line"]) {
        NSString *string = [self.lineObjectIdArr componentsJoinedByString:@"&dataPoints="];
        
        NSString *getUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,string,starTime,endTIme,timeUnit];
        [XHHttpTool get:getUrl params:nil jessionid:jsessionid success:^(id json) {
            
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
            NSDictionary *olddict = [self changeType:barChartModel.values];
            [self.lineXValueArr removeAllObjects];
            for (NSString *str in barChartModel.category) {
                [self.lineXValueArr addObject:str];
            }
            //字典按照objectid进行排序，否则会和name不对应。
            NSMutableArray *valueArray = [NSMutableArray array];
            for (NSString *sortString in self.lineObjectIdArr) {
                [valueArray addObject:[olddict objectForKey:sortString]];
            }
            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
            for (int i = 0; i < valueArray.count; i++) {
                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [self.lineValueArr removeAllObjects];
            for (NSString *firstStr in valueDic) {
                if (valueDic.count == 1) {
                    for (NSArray *secondStr in valueDic[firstStr]) {
                        for (int i = 0; i < secondStr.count; i++) {
                            if (i == 0) {
                                NSString *str = [self notRounding:[secondStr[i] floatValue] afterPoint:0];
                                [self.lineValueArr addObject:str];
                            }
                        }
                    }
                } else {
                    NSMutableArray *subArr = [NSMutableArray array];;
                    for (NSArray *secondStr in valueDic[firstStr]) {
                        for (int i = 0; i < secondStr.count; i++) {
                            if (i == 0) {
                                NSString *str = [self notRounding:[secondStr[i] floatValue] afterPoint:0];
                                [subArr addObject:str];
                            }
                        }
                    }
                    [self.lineValueArr addObject:subArr];
                }
            }
            [self.lineChart strokePath];
            
            //            [self loadButtonWithArray:self.pieDescrArr andColoArr:self.pieColorArr];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return self.lineValueArr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return self.lineXValueArr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1),ZFGrassGreen,ZFGold];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    CGFloat maxValue = 0.0;
    if (self.lineValueArr.count == self.lineDescrArr.count) {
        NSMutableArray *valueArr = [NSMutableArray array];
        for (int i = 0; i<self.lineValueArr.count; i++) {
            CGFloat value = [[self.lineValueArr[i] valueForKeyPath:@"@max.floatValue"] floatValue];
            NSString *str = [NSString stringWithFormat:@"%f",value];
            [valueArr addObject:str];
        }
        maxValue = [[valueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    } else{
        maxValue = [[self.lineValueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    }
    return maxValue;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return -150;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFLineChartDelegate

//- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
//    return 40.f;
//}

//- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
//    return 30.f;
//}

//- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
//    return 10.f;
//}

//- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
//    return 5.f;
//}

//- (NSArray *)valuePositionInLineChart:(ZFLineChart *)lineChart{
//    return @[@(kChartValuePositionOnTop), @(kChartValuePositionDefalut), @(kChartValuePositionOnBelow)];
//}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{

    circle.isAnimated = YES;
    [circle strokePath];
    popoverLabel.hidden = NO;
    
    if (self.linePointGroupArr.count > 0) {
        //        self.titleLabel.text = [NSString stringWithFormat:@"%@",self.pieDescrArr[index]];
        NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"dataPointId"] =self.lineObjectIdArr[lineIndex];
        params[@"relationType"] =self.linePointGroupArr[lineIndex];
        
        [XHHttpTool get:SubChartDetailUrl params:params jessionid:jsessionid success:^(id json) {
            
            NSLog(@"subbar:%@",json);
            NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
            [self.subLineChartArr removeAllObjects];
            for (JCChartModel *relationModel in arr) {
                JCChartModel *subModel = [JCChartModel mj_objectWithKeyValues:relationModel.relationPoint];
                [self.subLineChartArr addObject:subModel];
            }
            [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:self.subLineChartArr ];
            
        } failure:^(NSError *error) {
            
        }];
    } else{
        return;
    }
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld条线========第%ld个",(long)lineIndex,(long)circleIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFGold;
    //    [popoverLabel strokePath];
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



- (NSMutableArray *)lineDescrArr {
	if(_lineDescrArr == nil) {
		_lineDescrArr = [[NSMutableArray alloc] init];
	}
	return _lineDescrArr;
}

- (NSMutableArray *)linePointGroupArr {
	if(_linePointGroupArr == nil) {
		_linePointGroupArr = [[NSMutableArray alloc] init];
	}
	return _linePointGroupArr;
}

- (NSMutableArray *)lineObjectIdArr {
	if(_lineObjectIdArr == nil) {
		_lineObjectIdArr = [[NSMutableArray alloc] init];
	}
	return _lineObjectIdArr;
}

- (NSMutableArray *)lineXValueArr {
	if(_lineXValueArr == nil) {
		_lineXValueArr = [[NSMutableArray alloc] init];
	}
	return _lineXValueArr;
}

- (NSMutableArray *)lineValueArr {
	if(_lineValueArr == nil) {
		_lineValueArr = [[NSMutableArray alloc] init];
	}
	return _lineValueArr;
}

- (NSMutableArray *)subLineChartArr {
	if(_subLineChartArr == nil) {
		_subLineChartArr = [[NSMutableArray alloc] init];
	}
	return _subLineChartArr;
}

@end
