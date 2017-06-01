//
//  JCCombineChart.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/31.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCCombineChart.h"
#import "ZFColor.h"
@implementation JCCombineChart

- (void)setCombineBarChart:(CombinedChartView *)combineChart lineTitle:(NSString *)lineTitle bar1Title:(NSString *)bar1Title
{
    combineChart.descriptionText = @"";
    combineChart.pinchZoomEnabled = YES;
    combineChart.marker = [[ChartMarkerView alloc] init];
    combineChart.drawOrder = @[@0,@2];//CombinedChartDrawOrderBar,CombinedChartDrawOrderLine 绘制顺序
    combineChart.doubleTapToZoomEnabled = NO;//取消双击放大
    combineChart.scaleYEnabled = YES;//取消Y轴缩放
    combineChart.dragEnabled = YES;//启用拖拽图表
    [combineChart zoomToCenterWithScaleX:10.0f scaleY:0];
    combineChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    combineChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    combineChart.highlightPerTapEnabled = NO;//取消单击高亮显示
    combineChart.highlightPerDragEnabled = NO;//取消拖拽高亮
    ChartXAxis *xAxis = combineChart.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelFont = [UIFont systemFontOfSize:13];
    xAxis.labelCount = 5;
    
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:self.XValueArr];//设置X轴显示的值
    CGFloat barmaxValue = 0.0;
    NSMutableArray *valueArr = [NSMutableArray array];
    for (int i = 0; i<self.barValueArr.count; i++) {
        CGFloat value = [[self.barValueArr[i] valueForKeyPath:@"@max.floatValue"] floatValue];
        NSString *str = [NSString stringWithFormat:@"%f",value];
        [valueArr addObject:str];
    }
    barmaxValue = [[valueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    //左侧Y轴设置
    ChartYAxis *leftAxis = combineChart.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.axisMinimum = 0;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.axisMaximum = barmaxValue+100;
    
    
    //右侧Y轴
    CGFloat linemaxValue = 0.0;
    NSMutableArray *linevalueArr = [NSMutableArray array];
    for (int i = 0; i<self.lineValueArr.count; i++) {
        CGFloat value = [[self.lineValueArr[i] valueForKeyPath:@"@max.floatValue"] floatValue];
        NSString *str = [NSString stringWithFormat:@"%f",value];
        [linevalueArr addObject:str];
    }
    linemaxValue = [[linevalueArr valueForKeyPath:@"@max.floatValue"] floatValue];
    ChartYAxis *rightAxis = combineChart.rightAxis;
    rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.axisMinimum = 0;
    rightAxis.axisMaximum = linemaxValue+25;
    //设置图例
    ChartLegend *legend = combineChart.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = NO;
    legend.direction = ChartLegendDirectionLeftToRight;
    legend.form = ChartLegendFormSquare;
    legend.formSize = 12;
    //设置数据
    CombinedChartData *data = [[CombinedChartData alloc] init];
    if (self.lineValueArr.count > 0) {
        data.lineData = [self generateLineData:self.lineValueArr lineTitle:lineTitle];
    }
    if (self.barValueArr.count > 0) {
        data.barData = [self generateCombineBarData:self.barValueArr title1:bar1Title];
    } else{
        NSLog(@"nobar");
    }
    combineChart.data = data;
    
    //让柱子在X轴显示全
    xAxis.axisMinimum = data.xMin-1;
    xAxis.axisMaximum = data.xMax+1;
//    combineChart.extraBottomOffset = 20;
    combineChart.extraTopOffset = 0;
    [combineChart animateWithYAxisDuration:1.0];//添加Y轴动画
}
//生成折线的数据
- (LineChartData *)generateLineData:(NSArray *)lineValues lineTitle:(NSString *)lineTitle
{
    NSMutableArray *entries = [NSMutableArray array];
    NSArray *colorArr = @[ ZFColor(45, 92, 34, 1), ZFGrassGreen,ZFColor(253, 203, 76, 1),ZFColor(78, 250, 188, 1), ZFColor(214, 205, 153, 1),ZFColor(71, 204, 255, 1),  ZFColor(16, 140, 39, 1),ZFGold];
    int j = -1;
    NSMutableArray *lineSetArr = [NSMutableArray array];
    for (NSArray *lineArr in lineValues) {
        j++;
        [entries removeAllObjects];
        for (int i = 0; i < lineArr.count; i++) {
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[lineArr[i] floatValue]];
            [entries addObject:entry];
        }
        LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:entries label:lineTitle];
        [dataSet setColor:colorArr[j]];
        [dataSet setCircleColor:colorArr[j]];
        dataSet.fillColor = colorArr[j];
        dataSet.lineWidth = 2.5f;
        dataSet.axisDependency = AxisDependencyRight;
        dataSet.mode = LineChartModeCubicBezier;
        dataSet.drawValuesEnabled = YES;//不绘制线的数据
        [lineSetArr addObject:dataSet];
    }
    
    
    LineChartData *lineData = [[LineChartData alloc] init];
    lineData.dataSets = lineSetArr;
    [lineData setValueFont:[UIFont systemFontOfSize:10]];
    
    return lineData;
}
//生成复杂的组合柱图的数据（两根重叠的柱和折线的图）
- (BarChartData *)generateCombineBarData:(NSArray *)bar1Values title1:(NSString *)bar1Title
{
    NSMutableArray *bar1Entries = [NSMutableArray array];
    NSMutableArray *barSetArr = [NSMutableArray array];
    NSArray *colorArr = @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1),ZFGrassGreen,ZFGold];
    int j = -1;
    for (NSArray *barArr in bar1Values) {
        j++;
        [bar1Entries removeAllObjects];
        for (int i = 0; i < barArr.count; i++) {
            BarChartDataEntry *barEntry = [[BarChartDataEntry alloc] initWithX:i y:[barArr[i] floatValue]];
            [bar1Entries addObject:barEntry];
        }
        BarChartDataSet *dataSet1 = [[BarChartDataSet alloc]  initWithValues:bar1Entries label:bar1Title];
        dataSet1.colors = @[colorArr[j]];
        dataSet1.valueColors = @[[UIColor orangeColor]];
        dataSet1.axisDependency = AxisDependencyLeft;
        dataSet1.drawValuesEnabled = YES;
        [barSetArr addObject:dataSet1];
    }

    float groupSpace = 0.07f;
    float barSpace = 0.02f; // x2 dataset
    float barWidth = 0.45f;
    BarChartData *data = [[BarChartData alloc] init];
    data.dataSets = barSetArr;
    [data setValueFont:[UIFont systemFontOfSize:10]];
    data.barWidth = barWidth;
    if (bar1Values.count > 1) {
        [data groupBarsFromX:0.0 groupSpace:groupSpace barSpace:barSpace];
    }
    return data;
}

@end
