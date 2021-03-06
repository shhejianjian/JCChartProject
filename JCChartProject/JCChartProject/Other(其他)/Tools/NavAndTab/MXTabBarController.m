//
//  MXTabBarController.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "MXTabBarController.h"
#import "MXNavigationController.h"
#import "JCHomeVC.h"
#import "JCStrategyVC.h"
#import "JCMoreVC.h"
#import "JCFuncVC.h"
#import "JCMyCenterVC.h"
#import "JCMainHomeVC.h"

@interface MXTabBarController ()

@end

@implementation MXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViews];
    
}


- (void)setUpChildViews
{
    JCMainHomeVC *homeC = [[JCMainHomeVC alloc] init];
    MXNavigationController *firstNaC = [[MXNavigationController alloc] initWithRootViewController:homeC];
    homeC.title = @"首页";
    
    JCFuncVC *FunctionVC = [[JCFuncVC alloc] init];
    MXNavigationController *secondNaC = [[MXNavigationController alloc] initWithRootViewController:FunctionVC];
    FunctionVC.title = @"功能";
    
    JCStrategyVC *StrategyVC = [[JCStrategyVC alloc] init];
    MXNavigationController *thirdNaC = [[MXNavigationController alloc] initWithRootViewController:StrategyVC];
    StrategyVC.title = @"策略";
    
    JCMoreVC *MoreVC = [[JCMoreVC alloc] init];
    MXNavigationController *fourthNaC = [[MXNavigationController alloc] initWithRootViewController:MoreVC];
    MoreVC.title = @"更多";
    
    JCMyCenterVC *myCenterVC = [[JCMyCenterVC alloc]init];
    MXNavigationController *fifthNaC = [[MXNavigationController alloc]initWithRootViewController:myCenterVC];
    myCenterVC.title = @"个人";
    
    self.viewControllers = @[firstNaC,secondNaC,thirdNaC,fourthNaC,fifthNaC];

}




@end
