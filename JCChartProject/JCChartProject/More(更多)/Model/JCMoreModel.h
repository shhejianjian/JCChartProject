//
//  JCMoreModel.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCMoreModel : NSObject
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *measureTime;

@property (nonatomic, copy) NSString *dataPointName;

@property (nonatomic, copy) NSString *total;


@property (nonatomic, copy) NSString *createdDate;

@property (nonatomic, copy) NSString *documentType;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSString *officeDocumentName;

@end
