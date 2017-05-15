//
//  JCFunctionVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFunctionVC.h"
#import "MXConstant.h"
#import "JCFuncSecondVC.h"

@interface JCFunctionVC ()

@end

@implementation JCFunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"功能";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)jumpToNext:(id)sender {
    JCFuncSecondVC *funcSecondVC = [[JCFuncSecondVC alloc]init];
    [self.navigationController pushViewController:funcSecondVC animated:YES];
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
