//
//  MXNavigationItem.h
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXBarButtonItem.h"

@interface MXNavigationItem : NSObject


@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIView *titleView;


@property (strong, nonatomic) MXBarButtonItem *leftItem;
@property (strong, nonatomic) MXBarButtonItem *rightItem;

/**
 *  默认最多2个item元素
 */
@property (strong, nonatomic) NSArray *leftItems;


/**
 *  默认最多2个item元素
 */
@property (strong, nonatomic) NSArray *rightItems;


@end
