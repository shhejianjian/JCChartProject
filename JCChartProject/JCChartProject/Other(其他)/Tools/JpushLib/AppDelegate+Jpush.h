//
//  AppDelegate+Jpush.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/2.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate (Jpush)<JPUSHRegisterDelegate>
//初始化jpush
-(void)setupJpush:(nullable NSDictionary *)launchOptions;
@end
