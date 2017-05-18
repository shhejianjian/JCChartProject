//
//  JCChartModel.h
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCChartModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) id jsonData;

@property (nonatomic, assign) long long createdDate;

@property (nonatomic, assign) NSInteger enabled;

@property (nonatomic, assign) NSInteger orderNo;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, assign) long long lastUpdateDate;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *chartType;

@property (nonatomic, strong) NSArray *dataPoints;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, copy) NSString *symbol;


@property (nonatomic, strong) id defaultDateRange;
@property (nonatomic, strong) id measureUnit;

@property (nonatomic, strong) NSArray *category;
@property (nonatomic, strong) id values;


@end
