//
//  JCBarChartCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/5/17.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCChartModel.h"

@interface JCBarChartCell : UITableViewCell

@property (nonatomic, strong) JCChartModel *chartModel;

@property (nonatomic, copy) NSString *firstObjectId;

@end
