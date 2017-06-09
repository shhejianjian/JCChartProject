//
//  JCTopChartCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/9.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCTopChartCell.h"
#import "ZFChart.h"
#import "MXConstant.h"

@interface JCTopChartCell ()<ZFPieChartDataSource, ZFPieChartDelegate>

@property (nonatomic, strong) ZFPieChart * pieChart;
@property (nonatomic, strong) NSMutableArray *valueArr;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, assign) BOOL isDelete;

@end

@implementation JCTopChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isDelete = NO;
    NSArray *arr = @[@"4000", @"5000",@"1000"];
    [self.valueArr addObjectsFromArray:arr];
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.piePatternType = kPieChartPatternTypeForCircle;
    self.pieChart.percentType = kPercentTypeInteger;
    self.pieChart.isShadow = NO;
    self.pieChart.isAnimated = YES;
    [self.detailView addSubview:self.pieChart];
    NSArray *nameArr = @[@"电能耗",@"水能耗",@"气能耗"];
    [self loadButtonWithArray:nameArr andColoArr:@[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1),ZFColor(214, 205, 153, 1)]];
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return self.valueArr;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1),ZFColor(214, 205, 153, 1)];
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    NSLog(@"第%ld个",(long)index);
    self.isDelete = YES;
//    [self.valueArr removeAllObjects];
//    NSArray *arr = @[@"100", @"206", @"200", @"253", @"230", @"336"];
//    [self.valueArr addObjectsFromArray:arr];
//    [self.pieChart strokePath];
}

- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart{
    return 5.f;
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
        UIView *label = [[UIView alloc]init];
        label.tag = i;
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        float width = [self getTextWithWhenDrawWithText:arr[i]];
        label.frame = CGRectMake(15 + w, h, width+28, 30);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(10 + w + width+28 > KScreenW-20){
            w = 0; //换行时将w置为0
            h = h + label.frame.size.height + 10;//距离父视图也变化
            label.frame = CGRectMake(15 + w, h, width+28, 30);//重设button的frame
        }
        w = label.frame.size.width + label.frame.origin.x;
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, width, 25)];
        title.text = arr[i];
        title.font = [UIFont systemFontOfSize:15];
        title.textAlignment = NSTextAlignmentCenter;
        [label addSubview:title];
        
        UIView *colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 6, 13, 13)];
        colorView.backgroundColor = colorArr[i];
        [label addSubview:colorView];
        
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

- (NSMutableArray *)valueArr {
	if(_valueArr == nil) {
		_valueArr = [[NSMutableArray alloc] init];
	}
	return _valueArr;
}

@end
