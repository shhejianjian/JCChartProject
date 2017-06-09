//
//  MXConstant.h
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#ifndef MXConstant_h
#define MXConstant_h



#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreenIphone5    (([[UIScreen mainScreen] bounds].size.width)>320)
#define KScreenW [[UIScreen mainScreen]bounds].size.width
#define KScreenH [[UIScreen mainScreen]bounds].size.height
#define LBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define topBackgroundColor LBColor(8,68,100)
#define globalColor LBColor(36,151,136)
#define grayColor LBColor(100,100,100)
#define middlegrayColor LBColor(210,210,210)
#define cleargrayColor LBColor(240,240,240)
#define whitegrayColor LBColor(251,251,251)


#define LBRandomColor LBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define NAVH 64.0

#import "UIViewController+MXNavigation.h"
#import "MXNavigationItem.h"
#import "MXBarButtonItem.h"
#import "XHHttpTool.h"
#import "AFNetworking.h"
#import "XHConst.h"
#import "MXTabBarController.h"
#import "MJExtension.h"
#import "JCBaseModel.h"
#import "UIView+Frame.h"
#import "UIColor+Expanded.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

#endif /* MXConstant_h */
