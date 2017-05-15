//
//  UIViewController+MXNavigation.h
//  navDemo
//
//  Created by Max on 16/9/21.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXNavigationBar.h"
@class MXNavigationItem;

@interface UIViewController (MXNavigation)

@property (strong, nonatomic) MXNavigationItem *mxNavigationItem;
@property (strong, nonatomic) MXNavigationBar *mxNavigationBar;
@property (assign, nonatomic, getter=isMxNavigationBarHidden, readonly) BOOL mxNavigationBarHidden;

- (void)mxSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
