//
//  JCCombineChart.h
//  JCChartProject
//
//  Created by 何键键 on 17/5/31.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCChartProject-Bridging-Header.h"
#import "JCChartProject-Swift.h"

@interface JCCombineChart : UIView

@property (nonatomic, strong) NSArray *lineValueArr;
@property (nonatomic, strong) NSArray *barValueArr;
@property (nonatomic, strong) NSArray *XValueArr;

/**
 两根柱子以及折线的混合显示
 
 @param combineChart 需要设置的CombineChartView
 @param xValues X轴的值数组，里面放字符串
 @param bar1Values 柱子1的值数组
 @param lineTitle 图例中折线的描述
 @param bar1Title 图例中柱子1的描述
 
 warning:由于绘制有顺序，所以绘制高柱子应该在绘制低柱子之前进行，所以bar1Values中的值要大于对应的bar2Values中的值，绘制折线应该在最后进行
 */


- (void)setCombineBarChart:(CombinedChartView *)combineChart lineTitle:(NSString *)lineTitle bar1Title:(NSString *)bar1Title;
@end
