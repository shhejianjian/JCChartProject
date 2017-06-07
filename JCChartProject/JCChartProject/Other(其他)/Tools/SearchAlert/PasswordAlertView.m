//
//  PasswordAlertView.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "PasswordAlertView.h"
#import "MBProgressHUD+MJ.h"

@interface PasswordAlertView ()
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation PasswordAlertView

-(instancetype)initWithAlertViewHeight:(CGFloat)height
{
    self=[super init];
    if (self) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"PasswordAlertView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.layer.cornerRadius = 5;
        self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2-80);
        self.bounds = CGRectMake(0, 0, MAINSCREENwidth-30-30, height);
        [WINDOWFirst addSubview:self];
        self.sureBtn.layer.cornerRadius = 5;
        self.cancelBtn.layer.cornerRadius = 5;
    }
    return self;
}

- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak PasswordAlertView *weakSelf = self;
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                weakSelf.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (IBAction)BtnClick:(UIButton *)sender {
    
    if (sender.tag == 1) {
        [self hide:YES];
        if (self.ButtonClick) {
            self.ButtonClick(sender);
        }
    }
    if (sender.tag == 2) {
        if (self.oldPassword.text.length == 0) {
            [MBProgressHUD showError:@"原始密码不得为空"];
            return;
        }
        if (self.firstNewPassword.text.length == 0) {
            [MBProgressHUD showError:@"新密码不得为空"];
            return;
        }
        if (self.secondNewPassword.text.length == 0) {
            [MBProgressHUD showError:@"请确认新密码"];
            return;
        }
        if ([self.oldPassword.text isEqualToString:self.firstNewPassword.text] && [self.oldPassword.text isEqualToString:self.secondNewPassword.text]) {
            [MBProgressHUD showError:@"新密码不得与原始密码相同"];
            return;
        }
        if (self.firstNewPassword.text.length < 6) {
            [MBProgressHUD showError:@"新密码不得少于6位"];
            return;
        }
        if (![self.secondNewPassword.text isEqualToString:self.firstNewPassword.text]) {
            [MBProgressHUD showError:@"两次输入的新密码不同"];
            return;
        }
        
        if (self.ButtonClick) {
            self.ButtonClick(sender);
        }
    }
}


- (void)hide:(BOOL)animated
{
    NSLog(@"hide");
    __weak PasswordAlertView *weakSelf = self;
    
    [UIView animateWithDuration:animated ?0.3: 0 animations:^{
        weakSelf.transform = CGAffineTransformScale(weakSelf.transform,1,1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration: animated ?0.3: 0 animations:^{
            weakSelf.transform = CGAffineTransformScale(weakSelf.transform,0.2,0.2);
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    }];
}

@end
