//
//  JCModifyModel.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCModifyModel : NSObject
@property (nonatomic, copy) NSDictionary *response;
@property (nonatomic, copy) NSDictionary *header;
@property (nonatomic, copy) NSString *success;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDictionary *body;

@end
