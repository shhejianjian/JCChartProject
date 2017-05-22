//
//  JCBarChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCBarChartCell.h"
#import "ZFChart.h"
#import "MXConstant.h"

@interface JCBarChartCell ()<ZFGenericChartDataSource, ZFBarChartDelegate>
@property (nonatomic, strong) ZFBarChart * barChart;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *barXValueArr;
@property (strong, nonatomic) NSMutableArray *barValueArr;
@property (strong, nonatomic) NSMutableArray *barDescrArr;
@property (strong, nonatomic) NSMutableArray *barObjectIdArr;
@property (strong, nonatomic) NSMutableArray *barPointGroupArr;
@property (strong, nonatomic) NSMutableArray *subBarChartArr;
@property (strong, nonatomic) NSMutableArray *barColorArr;
@property (nonatomic, copy) NSString *UnitStr;
@property (nonatomic, assign) NSInteger UnitValueStr;
@property (nonatomic, copy) NSString *chartTypeStr;

@end

@implementation JCBarChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *colorArr = @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1),ZFGrassGreen,ZFGold];
    [self.barColorArr addObjectsFromArray:colorArr];
    self.barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    self.barChart.dataSource = self;
    self.barChart.delegate = self;
//    self.barChart.topicLabel.text = @"xx小学各年级人数";
    self.barChart.isShadow = NO;
    self.barChart.isAnimated = YES;
    //    self.barChart.isAnimated = NO;
    //    self.barChart.isResetAxisLineMinValue = YES;
    self.barChart.isResetAxisLineMaxValue = YES;
    [self.detailView addSubview:self.barChart];
    
}

- (void)setChartModel:(JCChartModel *)chartModel{
    _chartModel = chartModel;
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    for (JCChartModel *model in yArr) {
        JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:model.measureUnit];
        self.barChart.unit = xmodel.name;
    }
    self.UnitStr = dateRangeModel.unit;
    self.UnitValueStr = dateRangeModel.value;
    self.chartTypeStr = jsonDataModel.chartType;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",jsonDataModel.name];
    if (self.barDescrArr.count == 0) {
        [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:yArr];
    }
    
    
//    self.barChart.unit = measureModel.name;
}
- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr {
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = [self getStartDateWithValue:value andUnit:unit];
    NSString *endTIme = @"2017-04-24+00:00:00";
    NSString *timeUnit = unit;
    
    [self.barPointGroupArr removeAllObjects];
    [self.barObjectIdArr removeAllObjects];
    [self.barDescrArr removeAllObjects];
    for (JCChartModel *yModel in yArr) {
        [self.barObjectIdArr addObject:yModel.objectId];
        if (yModel.drillBy) {
            [self.barPointGroupArr addObject:yModel.drillBy];
        }
        [self.barDescrArr addObject:yModel.name];
    }
    if ([chartType isEqualToString:@"bar"]) {
        NSString *string = [self.barObjectIdArr componentsJoinedByString:@"&dataPoints="];
        
        NSString *getUrl = [NSString stringWithFormat:@"%@dataPoints=%@&startTime=%@&endTime=%@&timeUnit=%@",ChartDataUrl,string,starTime,endTIme,timeUnit];
        [XHHttpTool get:getUrl params:nil jessionid:jsessionid success:^(id json) {
            JCChartModel *barChartModel = [JCChartModel mj_objectWithKeyValues:json];
            NSDictionary *olddict = [self changeType:barChartModel.values];
            [self.barXValueArr removeAllObjects];
            for (NSString *str in barChartModel.category) {
                [self.barXValueArr addObject:str];
            }
            //字典按照objectid进行排序，否则会和name不对应。
            NSMutableArray *valueArray = [NSMutableArray array];
            for (NSString *sortString in self.barObjectIdArr) {
                [valueArray addObject:[olddict objectForKey:sortString]];
            }
            NSMutableDictionary *valueDic=[[NSMutableDictionary alloc]init];
            for (int i = 0; i < valueArray.count; i++) {
                [valueDic setObject:valueArray[i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [self.barValueArr removeAllObjects];
            for (NSString *firstStr in valueDic) {
                if (valueDic.count == 1) {
                    for (NSArray *secondStr in valueDic[firstStr]) {
                        for (int i = 0; i < secondStr.count; i++) {
                            if (i == 0) {
                                NSString *str = [self notRounding:[secondStr[i] floatValue] afterPoint:0];
                                [self.barValueArr addObject:str];
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
                    [self.barValueArr addObject:subArr];
                }
            }
            [self.barChart strokePath];
            
//            [self loadButtonWithArray:self.pieDescrArr andColoArr:self.pieColorArr];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}


#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{

    return self.barValueArr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return self.barXValueArr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return self.barColorArr;
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    CGFloat maxValue = 0.0;
    if (self.barValueArr.count == self.barDescrArr.count) {
        NSMutableArray *valueArr = [NSMutableArray array];
        for (int i = 0; i<self.barValueArr.count; i++) {
            CGFloat value = [[self.barValueArr[i] valueForKeyPath:@"@max.floatValue"] floatValue];
            NSString *str = [NSString stringWithFormat:@"%f",value];
            [valueArr addObject:str];
        }
        maxValue = [[valueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    } else{
        maxValue = [[self.barValueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    }
    return maxValue;
}


- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFBarChartDelegate
- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
    return 30;
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    
//    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
    
    if (self.barPointGroupArr.count > 0) {
//        self.titleLabel.text = [NSString stringWithFormat:@"%@",self.pieDescrArr[index]];
        NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"dataPointId"] =self.barObjectIdArr[groupIndex];
        params[@"relationType"] =self.barPointGroupArr[groupIndex];
        
        [XHHttpTool get:SubChartDetailUrl params:params jessionid:jsessionid success:^(id json) {
            
            NSLog(@"subbar:%@",json);
            NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
            [self.subBarChartArr removeAllObjects];
            for (JCChartModel *relationModel in arr) {
                JCChartModel *subModel = [JCChartModel mj_objectWithKeyValues:relationModel.relationPoint];
                [self.subBarChartArr addObject:subModel];
            }
            [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:self.subBarChartArr ];
            
        } failure:^(NSError *error) {
            
        }];
    } else{
        return;
    }
    
    
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
    

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


- (NSMutableArray *)barValueArr {
	if(_barValueArr == nil) {
		_barValueArr = [[NSMutableArray alloc] init];
	}
	return _barValueArr;
}

- (NSMutableArray *)barObjectIdArr {
	if(_barObjectIdArr == nil) {
		_barObjectIdArr = [[NSMutableArray alloc] init];
	}
	return _barObjectIdArr;
}

- (NSMutableArray *)barXValueArr {
	if(_barXValueArr == nil) {
		_barXValueArr = [[NSMutableArray alloc] init];
	}
	return _barXValueArr;
}

- (NSMutableArray *)barPointGroupArr {
	if(_barPointGroupArr == nil) {
		_barPointGroupArr = [[NSMutableArray alloc] init];
	}
	return _barPointGroupArr;
}

- (NSMutableArray *)subBarChartArr {
	if(_subBarChartArr == nil) {
		_subBarChartArr = [[NSMutableArray alloc] init];
	}
	return _subBarChartArr;
}

- (NSMutableArray *)barDescrArr {
	if(_barDescrArr == nil) {
		_barDescrArr = [[NSMutableArray alloc] init];
	}
	return _barDescrArr;
}

- (NSMutableArray *)barColorArr {
	if(_barColorArr == nil) {
		_barColorArr = [[NSMutableArray alloc] init];
	}
	return _barColorArr;
}

@end
