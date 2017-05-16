//
//  JCFuncBaseModel.h
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCFuncBaseModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, strong) NSArray *childList;
/** 点击展开或者关闭状态*/
@property (nonatomic, assign) BOOL isOpen;
@end
