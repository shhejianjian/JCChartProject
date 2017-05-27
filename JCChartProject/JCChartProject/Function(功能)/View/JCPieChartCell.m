//
//  JCPieChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCPieChartCell.h"
#import "ZFChart.h"
#import "MXConstant.h"
#import "AlertView.h"

@interface JCPieChartCell () <ZFPieChartDataSource, ZFPieChartDelegate>
@property (nonatomic, strong) NSMutableArray *pieDescrArr;
@property (nonatomic, strong) NSMutableArray *pieValuArr;
@property (nonatomic, strong) NSMutableArray *pieObjectIdArr;
@property (nonatomic, strong) NSMutableArray *piePointGroupArr;
@property (nonatomic, strong) NSMutableArray *subPieChartArr;
@property (nonatomic, strong) NSMutableArray *pieColorArr;

@property (nonatomic, strong) NSArray *searchArr;

@property (nonatomic, strong) ZFPieChart * pieChart;
@property(nonatomic,strong)UIView *bGView;


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (nonatomic, copy) NSString *UnitStr;
@property (nonatomic, assign) NSInteger UnitValueStr;
@property (nonatomic, copy) NSString *chartTypeStr;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;

@end

@implementation JCPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isDelete = NO;
    NSArray *colorArr = @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1)];
    [self.pieColorArr addObjectsFromArray:colorArr];
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];    
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.piePatternType = kPieChartPatternTypeForCircle;
    self.pieChart.isShadow = NO;
    self.pieChart.isAnimated = NO;
}


- (void)setChartModel:(JCChartModel *)chartModel {
    _chartModel = chartModel;
    JCChartModel *jsonDataModel = [JCChartModel mj_objectWithKeyValues:chartModel.jsonData];
    JCChartModel *dateRangeModel = [JCChartModel mj_objectWithKeyValues:jsonDataModel.defaultDateRange];
    NSArray *yArr = [JCChartModel mj_objectArrayWithKeyValuesArray:jsonDataModel.dataPoints];
    self.searchArr = yArr;
    self.UnitStr = dateRangeModel.unit;
    self.UnitValueStr = dateRangeModel.value;
    self.chartTypeStr = jsonDataModel.chartType;
    self.startTimeStr = [self getStartDateWithValue:self.UnitValueStr andUnit:self.UnitStr];
    self.endTimeStr = @"2017-04-24+00:00:00";
    if (self.pieDescrArr.count == 0) {
        [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:yArr andStartTime:self.startTimeStr andEndTime:self.endTimeStr];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",jsonDataModel.name];
    }
}


- (void)loadChartDataWithUnit:(NSString *)unit AndValue:(NSInteger)value andChartType:(NSString *)chartType andYarr:(NSArray *)yArr andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *starTime = startTime;
    NSString *endTIme = endTime;
    NSString *timeUnit = @"";
    if ([chartType isEqualToString:@"pie"] || [chartType isEqualToString:@"dashboard"]) {
        timeUnit = @"None";
    } else {
        timeUnit = unit;
    }
    [self.pieObjectIdArr removeAllObjects];
    [self.pieDescrArr removeAllObjects];
    [self.piePointGroupArr removeAllObjects];
    for (JCChartModel *yModel in yArr) {
        [self.pieObjectIdArr addObject:yModel.objectId];
        if (yModel.drillBy) {
            [self.piePointGroupArr addObject:yModel.drillBy];
        }
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
            
            
            [self loadButtonWithArray:self.pieDescrArr andColoArr:self.pieColorArr];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (IBAction)searchBtnClick:(id)sender {
    [self createBackgroundView];
    AlertView *alert = [[AlertView alloc] initWithAlertViewHeight:250];
    alert.ButtonClick = ^void(UIButton*button){
        [self.bGView removeFromSuperview];
        if (button.tag == 2) {
            self.startTimeStr = alert.startTimeStr;
            self.endTimeStr = alert.endTimeStr;
            [self loadChartDataWithUnit:[self checkUnit:alert.timeValueTypeStr] AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:self.searchArr andStartTime:self.startTimeStr andEndTime:self.endTimeStr];
        }
    };
}

- (NSString *)checkUnit:(NSString *)unit{
    NSString *newUnit;
    if ([unit isEqualToString:@"时"]) {
        newUnit = @"Hour";
    } else if ([unit isEqualToString:@"日"]) {
        newUnit = @"Day";
    } else if ([unit isEqualToString:@"周"]) {
        newUnit = @"Week";
    } else if ([unit isEqualToString:@"月"]) {
        newUnit = @"Month";
    } else if ([unit isEqualToString:@"季"]) {
        newUnit = @"Quarter";
    } else if ([unit isEqualToString:@"年"]) {
        newUnit = @"Year";
    }
    return newUnit;
}

-(void)createBackgroundView{
    self.bGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENwidth, MAINSCREENheight)];
    self.bGView.backgroundColor = [UIColor blackColor];
    self.bGView.alpha = 0.5;
    self.bGView.userInteractionEnabled = YES;
    [WINDOWFirst addSubview:self.bGView];
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return self.pieValuArr;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return self.pieColorArr;
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    self.isDelete = YES;
        if (self.piePointGroupArr.count > 0) {
            self.titleLabel.text = [NSString stringWithFormat:@"%@",self.pieDescrArr[index]];
            NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"dataPointId"] =self.pieObjectIdArr[index];
            params[@"relationType"] =self.piePointGroupArr[index];
    
            [XHHttpTool get:SubChartDetailUrl params:params jessionid:jsessionid success:^(id json) {
    
                NSArray *arr = [JCChartModel mj_objectArrayWithKeyValuesArray:json];
                [self.subPieChartArr removeAllObjects];
                for (JCChartModel *relationModel in arr) {
                    JCChartModel *subModel = [JCChartModel mj_objectWithKeyValues:relationModel.relationPoint];
                    [self.subPieChartArr addObject:subModel];
                }
                [self loadChartDataWithUnit:self.UnitStr AndValue:self.UnitValueStr andChartType:self.chartTypeStr andYarr:self.subPieChartArr andStartTime:self.startTimeStr andEndTime:self.endTimeStr];
    
            } failure:^(NSError *error) {
                
            }];
        } else{
            return;
        }
}

- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart{
    return 0.1f;
}

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return 120.f;
}

- (void)loadButtonWithArray:(NSArray *)arr andColoArr:(NSArray *)colorArr{
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = 320;//用来控制button距离父视图的高
    if (self.isDelete) {
        for (UILabel *label in self.detailView.subviews) {
            [label removeFromSuperview];
        }
    }
        for (int i = 0; i < arr.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.tag = i;
            label.backgroundColor = colorArr[i];
            //根据计算文字的大小
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            //为button赋值
            label.text = arr[i];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            //设置button的frame
            float width = [self getTextWithWhenDrawWithText:arr[i]];
            label.frame = CGRectMake(15 + w, h, width+10, 30);
            //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
            if(10 + w + width+10 > KScreenW-20){
                w = 0; //换行时将w置为0
                h = h + label.frame.size.height + 10;//距离父视图也变化
                label.frame = CGRectMake(15 + w, h, width+10, 30);//重设button的frame
            }
            w = label.frame.size.width + label.frame.origin.x;
            
            [self.detailView addSubview:label];
        }
        [self.pieChart strokePath];
        [self.detailView addSubview:self.pieChart];
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

- (NSMutableArray *)piePointGroupArr {
	if(_piePointGroupArr == nil) {
		_piePointGroupArr = [[NSMutableArray alloc] init];
	}
	return _piePointGroupArr;
}

- (NSMutableArray *)subPieChartArr {
	if(_subPieChartArr == nil) {
		_subPieChartArr = [[NSMutableArray alloc] init];
	}
	return _subPieChartArr;
}

- (NSMutableArray *)pieColorArr {
	if(_pieColorArr == nil) {
		_pieColorArr = [[NSMutableArray alloc] init];
	}
	return _pieColorArr;
}



@end
