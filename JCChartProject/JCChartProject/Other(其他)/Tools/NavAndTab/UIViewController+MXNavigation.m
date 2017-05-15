//
//  UIViewController+MXNavigation.m
//  navDemo
//
//  Created by Max on 16/9/21.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "UIViewController+MXNavigation.h"
#import "MXNavigationItem.h"
#import "MXBarButtonItem.h"

#import "MXNavigation.h"
#import <objc/runtime.h>

static char const *kMXNavigationBarHidden = "kMXNavigationBarHidden";
static char const *kMXNavigationBar = "kMXNavigationBar";
static char const *kMXNavigationItem = "kMXNavigationItem";

@implementation UIViewController (MXNavigation)

@dynamic mxNavigationBarHidden;
@dynamic mxNavigationBar;
@dynamic mxNavigationItem;

- (BOOL)isMxNavigationBarHidden
{
    return [objc_getAssociatedObject(self, kMXNavigationBarHidden) boolValue];
}


- (void)setMxNavigationBarHidden:(BOOL)mxNavigationBarHidden
{
    objc_setAssociatedObject(self, kMXNavigationBarHidden, @(mxNavigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}



- (MXNavigationBar *)mxNavigationBar
{
    return objc_getAssociatedObject(self, kMXNavigationBar);
}


- (void)setMxNavigationBar:(MXNavigationBar *)mxNavigationBar
{
    objc_setAssociatedObject(self, kMXNavigationBar, mxNavigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (MXNavigationItem *)mxNavigationItem
{
    return objc_getAssociatedObject(self, kMXNavigationItem);
}


- (void)setMxNavigationItem:(MXNavigationItem *)mxNavigationItem
{
    objc_setAssociatedObject(self, kMXNavigationItem, mxNavigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




- (void)mxSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated) {
        if (hidden) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mxNavigationBar.y = -64;
                for (UIView *view in self.mxNavigationBar.subviews) {
                    view.alpha = 0.0;
                }
            } completion:^(BOOL finished) {
                self.mxNavigationBarHidden = YES;
            }];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                self.mxNavigationBar.y = 0;
                for (UIView *view in self.mxNavigationBar.subviews) {
                    view.alpha = 1.0;
                }
            } completion:^(BOOL finished) {
                self.mxNavigationBarHidden = NO;
            }];
        }
    }
    else {
        if (hidden) {
            self.mxNavigationBar.y = -64;
            self.mxNavigationBarHidden = YES;
        }
        else {
            self.mxNavigationBar.y = 0;
            self.mxNavigationBarHidden = NO;
        }
    }
}







@end
