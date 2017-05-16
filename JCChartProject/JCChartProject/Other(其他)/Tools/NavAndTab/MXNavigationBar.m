//
//  MXNavigationBar.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "MXNavigationBar.h"
#import "MXConstant.h"
@interface MXNavigationBar ()

@property (strong, nonatomic) UIView *lineView;

@end



@implementation MXNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpDefaultAttribute];
    }
    return self;
}


- (void)setUpDefaultAttribute
{
    self.backgroundColor = topBackgroundColor;
    self.frame = (CGRect){0, 0, [UIScreen mainScreen].bounds.size.width, 64};
    
    self.lineView = [[UIView alloc] initWithFrame:(CGRect){0, 64, [UIScreen mainScreen].bounds.size.width, 0.5}];
    self.lineView.backgroundColor = topBackgroundColor;
    [self addSubview:self.lineView];
}







@end
