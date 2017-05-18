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
@implementation JCPieChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setPieDescArr:(NSArray *)pieDescArr{
    _pieDescArr = pieDescArr;
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 44, KScreenW, 400)];
    pie.valueArr = self.pieValueArr;
    pie.descArr = self.pieDescArr;
    pie.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:pie];
    pie.positionChangeLengthWhenClick = 15;
    pie.showDescripotion = YES;
    [pie showAnimation];
}

@end
