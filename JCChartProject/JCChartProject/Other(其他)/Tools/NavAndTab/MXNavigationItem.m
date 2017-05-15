//
//  MXNavigationItem.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "MXNavigationItem.h"
#import "MXNavigation.h"
#import "UIViewController+MXNavigation.h"

@interface MXNavigationItem ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, assign) UIViewController *_mxViewController;

@end


@implementation MXNavigationItem


- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (!title) {
        _titleLabel.text = @"";
        return;
    }
    
    if ([title isEqualToString:_titleLabel.text]) {
        return;
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleLabel setTextColor:kNavigationBarTintColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [__mxViewController.mxNavigationBar addSubview:_titleLabel];
    }
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    NSUInteger otherButtonWidth = self.leftItem.width + self.rightItem.width;
    _titleLabel.width = [UIScreen mainScreen].bounds.size.width - otherButtonWidth - 40;
    _titleLabel.centerY = 42;
    _titleLabel.centerX = [UIScreen mainScreen].bounds.size.width/2;
}


- (void)setTitleView:(UIView *)titleView
{
    if (__mxViewController) {
        [_titleView removeFromSuperview];
        _titleView.centerX = kScreen_Width/2.0f;
        _titleView.centerY = 42;
        [__mxViewController.mxNavigationBar addSubview:titleView];
    }
    _titleView = titleView;
}



- (void)setLeftItem:(MXBarButtonItem *)leftItem
{
    if (__mxViewController) {
        [_leftItem removeFromSuperview];
        leftItem.x = 10;
        leftItem.centerY = 42;
        [__mxViewController.mxNavigationBar addSubview:leftItem];
    }
    _leftItem = leftItem;
}


- (void)setRightItem:(MXBarButtonItem *)rightItem
{
    if (__mxViewController) {
        [_rightItem removeFromSuperview];
        rightItem.x = [UIScreen mainScreen].bounds.size.width - rightItem.width - 10;
        rightItem.centerY = 42;
        [__mxViewController.mxNavigationBar addSubview:rightItem];
    }
    _rightItem = rightItem;
}


- (void)setLeftItems:(NSArray *)leftItems
{
    if (__mxViewController) {
        [_leftItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MXBarButtonItem *firstItem = leftItems.firstObject;
        MXBarButtonItem *lastItem = leftItems.lastObject;
        firstItem.x = 10;
        firstItem.centerY = 42;
        
        lastItem.x = 10 + firstItem.width;
        lastItem.centerY = 42;
        [__mxViewController.mxNavigationBar addSubview:firstItem];
        [__mxViewController.mxNavigationBar addSubview:lastItem];
    }
    _leftItems = leftItems;
}



- (void)setRightItems:(NSArray *)rightItems
{
    if (__mxViewController) {
        [_rightItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MXBarButtonItem *firstItem = rightItems.firstObject;
        MXBarButtonItem *lastItem = rightItems.lastObject;
        firstItem.x = kScreen_Width - 10 - firstItem.width;
        firstItem.centerY = 42;
        
        lastItem.x = kScreen_Width - 20 - firstItem.width;
        lastItem.centerY = 42;
        [__mxViewController.mxNavigationBar addSubview:firstItem];
        [__mxViewController.mxNavigationBar addSubview:lastItem];
    }
    _rightItems = rightItems;
}




@end
