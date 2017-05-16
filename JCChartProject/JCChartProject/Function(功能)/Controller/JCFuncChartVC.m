//
//  JCFuncChartVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFuncChartVC.h"
#import "JHChartHeader.h"
#import "MXConstant.h"
#import "ZFChart.h"
#import "JCChartModel.h"
@interface JCFuncChartVC ()<ZFGenericChartDataSource, ZFBarChartDelegate>

@property (nonatomic, strong) ZFBarChart * barChart;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *chartArr;

@property (nonatomic, strong) NSMutableArray *barChartXArr;

@end

@implementation JCFuncChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = self.titleName;
    [self loadMenuDetailWithObjectId:self.objectId];
    _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    
}

- (void)loadMenuDetailWithObjectId:(NSString*)objectId{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *menuDetailUrl = [NSString stringWithFormat:@"%@%@",MenuDetailUrl,objectId];
    [XHHttpTool get:menuDetailUrl params:nil jessionid:jsessionid success:^(id json) {
        NSLog(@"+++==%@",json);
        NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
        for (JCChartModel *chartModel in arr) {
            JCChartModel *xmodel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
            
            NSLog(@"---%@",xmodel.chartType);
            if ([xmodel.chartType isEqualToString:@"bar"]) {
                [self drawBarChart];
            }
            
            JCChartModel *unitModel = [JCChartModel mj_objectWithKeyValues:xmodel.defaultDateRange];
            
            NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:xmodel.dataPoints];
            for (JCChartModel *yModel in yArr) {
                [self.chartArr addObject:yModel.objectId];
            }
            [self loadChartDataWithObjectId:self.chartArr andUnit:unitModel.unit AndValue:unitModel.value];
            
            
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadChartDataWithObjectId:(NSArray *)objectIdArr andUnit:(NSString *)unit AndValue:(NSInteger)value{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (int i = 0; i < objectIdArr.count; i++) {
        params[@"dataPoints"] = objectIdArr[i];
    }
    params[@"endTime"] = [self getNowDate];
    params[@"timeUnit"] = unit;
    params[@"startTime"] = [self getStartDateWithValue:value andUnit:unit];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    [XHHttpTool get:ChartDataUrl params:params jessionid:jsessionid success:^(id json) {
        NSLog(@"json:::%@",json);
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (NSString*)getStartDateWithValue:(NSInteger)value andUnit:(NSString *)unit{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    NSDate *myDate = [NSDate date];
    
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

- (void)drawBarChart{
    self.barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, _height)];
    self.barChart.dataSource = self;
    self.barChart.delegate = self;
    self.barChart.topicLabel.text = @"xx小学各年级人数";
    self.barChart.unit = @"人";
    //    self.barChart.isAnimated = NO;
    //    self.barChart.isResetAxisLineMinValue = YES;
    self.barChart.isResetAxisLineMaxValue = YES;
    //    self.barChart.isShowAxisLineValue = NO;
    //    self.barChart.valueLabelPattern = kPopoverLabelPatternBlank;
    //    self.barChart.isShowXLineSeparate = YES;
    //    self.barChart.isShowYLineSeparate = YES;
    //    self.barChart.topicLabel.textColor = ZFWhite;
    //    self.barChart.unitColor = ZFWhite;
    //    self.barChart.xAxisColor = ZFWhite;
    //    self.barChart.yAxisColor = ZFWhite;
    //    self.barChart.xAxisColor = ZFClear;
    //    self.barChart.yAxisColor = ZFClear;
    //    self.barChart.axisLineNameColor = ZFWhite;
    //    self.barChart.axisLineValueColor = ZFWhite;
    //    self.barChart.backgroundColor = ZFPurple;
    //    self.barChart.isShowAxisArrows = NO;
    
    [self.view addSubview:self.barChart];
    [self.barChart strokePath];
}
#pragma mark - ZFGenericChartDataSource

- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"300", @"283", @"490", @"236",@"283", @"490", @"236"];
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级",@"四年级", @"五年级", @"六年级"];
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart{
//    return 50;
//}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return 10;
}

#pragma mark - ZFBarChartDelegate

//- (CGFloat)barWidthInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}

//- (CGFloat)paddingForGroupsInBarChart:(ZFBarChart *)barChart{
//    return 40.f;
//}

//- (id)valueTextColorArrayInBarChart:(ZFGenericChart *)barChart{
//    return ZFBlue;
//}

- (NSArray *)gradientColorArrayInBarChart:(ZFBarChart *)barChart{
    ZFGradientAttribute * gradientAttribute = [[ZFGradientAttribute alloc] init];
    gradientAttribute.colors = @[(id)ZFSkyBlue.CGColor];
    gradientAttribute.locations = @[@(0.99)];
    
    return [NSArray arrayWithObjects:gradientAttribute, nil];
}

- (void)barChart:(ZFBarChart *)barChart didSelectBarAtGroupIndex:(NSInteger)groupIndex barIndex:(NSInteger)barIndex bar:(ZFBar *)bar popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)barIndex);
    
    //可在此处进行bar被点击后的自身部分属性设置,可修改的属性查看ZFBar.h
    bar.barColor = ZFSkyBlue;
    bar.isAnimated = NO;
    //    bar.opacity = 0.5;
    [bar strokePath];
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    //    popoverLabel.hidden = NO;
}

- (void)barChart:(ZFBarChart *)barChart didSelectPopoverLabelAtGroupIndex:(NSInteger)groupIndex labelIndex:(NSInteger)labelIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld组========第%ld个",(long)groupIndex,(long)labelIndex);
    
    //可在此处进行popoverLabel被点击后的自身部分属性设置
    //    popoverLabel.textColor = ZFSkyBlue;
    //    [popoverLabel strokePath];
}

- (NSMutableArray *)chartArr {
	if(_chartArr == nil) {
		_chartArr = [[NSMutableArray alloc] init];
	}
	return _chartArr;
}

- (NSMutableArray *)barChartXArr {
	if(_barChartXArr == nil) {
		_barChartXArr = [[NSMutableArray alloc] init];
	}
	return _barChartXArr;
}

@end
