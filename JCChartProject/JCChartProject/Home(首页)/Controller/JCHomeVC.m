//
//  JCHomeVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCHomeVC.h"
#import "MXConstant.h"
#import "JCChartProject-Bridging-Header.h"
#import "JCChartProject-Swift.h"


@interface JCHomeVC ()

@end

@implementation JCHomeVC

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"首页";
    BarChartView *chatView = [[BarChartView alloc] initWithFrame:CGRectMake(10, 100, 300, 300)];
    [self.view addSubview:chatView];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
