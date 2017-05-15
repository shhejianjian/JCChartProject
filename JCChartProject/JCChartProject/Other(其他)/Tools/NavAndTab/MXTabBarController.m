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
#import "JCFunctionVC.h"
#import "JCStrategyVC.h"
#import "JCMoreVC.h"


@interface MXTabBarController ()

@end

@implementation MXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildViews];
    
}


- (void)setUpChildViews
{
    JCHomeVC *homeC = [[JCHomeVC alloc] init];
    MXNavigationController *firstNaC = [[MXNavigationController alloc] initWithRootViewController:homeC];
    homeC.title = @"首页";
    
    JCFunctionVC *FunctionVC = [[JCFunctionVC alloc] init];
    MXNavigationController *secondNaC = [[MXNavigationController alloc] initWithRootViewController:FunctionVC];
    FunctionVC.title = @"功能";
    
    JCStrategyVC *StrategyVC = [[JCStrategyVC alloc] init];
    MXNavigationController *thirdNaC = [[MXNavigationController alloc] initWithRootViewController:StrategyVC];
    StrategyVC.title = @"策略";
    
    JCMoreVC *MoreVC = [[JCMoreVC alloc] init];
    MXNavigationController *fourthNaC = [[MXNavigationController alloc] initWithRootViewController:MoreVC];
    MoreVC.title = @"更多";
    
    self.viewControllers = @[firstNaC,secondNaC,thirdNaC,fourthNaC];
}




@end
