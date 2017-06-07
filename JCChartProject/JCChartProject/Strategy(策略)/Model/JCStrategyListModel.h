//
//  JCStrategyListModel.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCStrategyListModel : NSObject
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *activeTime;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *strategyName;
@property (nonatomic, copy) NSString *total;

@end
