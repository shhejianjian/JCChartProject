//
//  MXBarButtonItem.h
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CustomViewAction)();

@interface MXBarButtonItem : UIButton


- (instancetype)initWithTitle:(NSString *)title handler:(CustomViewAction)block;

- (instancetype)initWIthImage:(NSString *)image handler:(CustomViewAction)block;


@end
