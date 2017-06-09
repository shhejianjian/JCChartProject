//
//  JCStrategyCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCStrategyListModel.h"
#import "JCMoreModel.h"
@interface JCStrategyCell : UITableViewCell
@property (nonatomic, strong) JCStrategyListModel *strategyListModel;
@property (nonatomic, strong) JCMoreModel *abnormalDataModel;
@property (nonatomic, strong) JCMoreModel *wordDataModel;

@end
