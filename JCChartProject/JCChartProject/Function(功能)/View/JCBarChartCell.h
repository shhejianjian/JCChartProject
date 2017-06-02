//
//  JCBarChartCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCChartModel.h"
#import "ZFChart.h"

@protocol JCBarChartCellDelegate <NSObject>

-(void)passValueForCellHeight:(CGFloat)height;

@end

@interface JCBarChartCell : UITableViewCell

@property (nonatomic, weak) id <JCBarChartCellDelegate> delegate;

@property (nonatomic, strong) JCChartModel *chartModel;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic, strong) ZFBarChart * barChart;

@property (nonatomic, copy) NSString *firstObjectId;
@property (nonatomic, assign) CGFloat barCellHeight;
@end
