//
//  MXNavigationController.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "MXNavigationController.h"
#import "MXNavigation.h"
#import "MXNavigationBar.h"
#import "MXNavigationItem.h"
#import "MXBarButtonItem.h"
#import "UIViewController+MXNavigation.h"

@interface MXNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIViewController *currentController;

@end

@implementation MXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    self.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(interactivePopGestureRecognizerAction:)];
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 给NavigationView添加一个拖拽手势 - 此处这个警告没什么影响
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
//    [self.view addGestureRecognizer:pan];
//    
//    pan.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self setUpCustomNavigationBarForController:viewController];
    
    [super pushViewController:viewController animated:animated];
    
    if (!viewController.mxNavigationItem.leftItem
        && self.viewControllers.count > 1) {
        viewController.mxNavigationItem.leftItem = [[MXBarButtonItem alloc] initWIthImage:@"top_返回" handler:^{
            [viewController.navigationController popViewControllerAnimated:YES];
        }];
    }
}



- (void)setUpCustomNavigationBarForController:(UIViewController *)controller
{
    if (!controller.mxNavigationItem) {
        MXNavigationItem *item = [[MXNavigationItem alloc] init];
        [item setValue:controller forKey:@"_mxViewController"];
        controller.mxNavigationItem = item;
    }
    
    if (!controller.mxNavigationBar) {
        controller.mxNavigationBar = [[MXNavigationBar alloc] initWithFrame:(CGRect){0, 0, kScreen_Width, 64}];
        [controller.view addSubview:controller.mxNavigationBar];
    }
    
    //记录当前的controller
    self.currentController = controller;
}




- (void)interactivePopGestureRecognizerAction:(UIGestureRecognizer *)gesture
{
    NSLog(@"111");
    static CGFloat startLocationX = 0;
    CGPoint location = [gesture locationInView:self.view];
    CGFloat progress = (location.x - startLocationX) / [UIScreen mainScreen].bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    
    self.visibleViewController.mxNavigationBar.alpha = progress;
    self.currentController.mxNavigationBar.alpha = 1 - progress;
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.2 animations:^{
            self.visibleViewController.mxNavigationBar.alpha = 1;
            self.currentController.mxNavigationBar.alpha = 1;
        }];
    }
}


@end
