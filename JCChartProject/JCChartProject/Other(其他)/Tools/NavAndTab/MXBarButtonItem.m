//
//  MXBarButtonItem.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "MXBarButtonItem.h"
#import "MXNavigation.h"

@interface MXBarButtonItem ()

@property (copy, nonatomic) CustomViewAction block;

@end



@implementation MXBarButtonItem


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 40, 40);
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title handler:(CustomViewAction)block
{
    if ([self init]) {
        
        self.block = block;
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:kNavigationBarTintColor forState:UIControlStateNormal];
        [self.titleLabel setFont:kNavigationItemFont];
        [self addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
        self.width = [title sizeWithFont:self.titleLabel.font].width+2;
    }
    return self;
}


- (instancetype)initWIthImage:(NSString *)image handler:(CustomViewAction)block
{
    if ([self init]) {
        
        self.block = block;
        
        [self setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnClickAction) forControlEvents:UIControlEventTouchUpInside];
        self.width = [UIImage imageNamed:image].size.width + 2;
        
    }
    return self;
}


- (void)btnClickAction
{
    if (self.block) {
        self.block();
    }
}



@end
