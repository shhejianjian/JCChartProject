//
//  JCLeftVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/6.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCLeftVC.h"
#import "MXConstant.h"
#import "LQXSwitch.h"
#import "PasswordAlertView.h"
#import "JCModifyModel.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "NSData+AES.h"

@interface JCLeftVC ()
{
    LAContext *context;
}
@property (strong, nonatomic) IBOutlet UILabel *useTouchIDLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *touchLabelConstraint;
@property(nonatomic,strong)UIView *bGView;

@end

@implementation JCLeftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    context= [[LAContext alloc] init];

    
    LQXSwitch *swit2 = [[LQXSwitch alloc] initWithFrame:CGRectMake(self.useTouchIDLabel.width+80, self.touchLabelConstraint.constant, 60, 25) onColor:globalColor offColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:0.6] font:[UIFont systemFontOfSize:15] ballSize:22];
    
    NSString *checkTouchIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"touchID"];
    if ([checkTouchIdStr isEqualToString:@"yes"]) {
        [swit2 setOn:YES animated:NO];
    }
    swit2.onText = @"开";
    swit2.offText = @"关";
    [self.view addSubview:swit2];
    [swit2 addTarget:self action:@selector(switchSex:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}
- (void)switchSex:(LQXSwitch *)swit
{
    NSError* error = nil;
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                [swit setOn:NO animated:NO];
                [MBProgressHUD showError:@"请前往系统设置中注册TouchID"];
                return;
            }
        }
    }
    if (swit.on) {
        [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"touchID"];
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"touchID"];
    }
}

- (IBAction)updatePassword:(id)sender {
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    [self createBackgroundView];
    PasswordAlertView *alert = [[PasswordAlertView alloc] initWithAlertViewHeight:245];
    __weak PasswordAlertView *weakSelf = alert;
    alert.ButtonClick = ^void(UIButton*button){
        if (button.tag == 1){
            [self.bGView removeFromSuperview];
        }
        if (button.tag == 2) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"newPassword"] = weakSelf.firstNewPassword.text;
            params[@"originPassword"] = weakSelf.oldPassword.text;
            [XHHttpTool put:updatePasswordUrl params:params jessionid:jsessionid success:^(id json) {
                NSLog(@"success:%@",json);
                JCModifyModel *firstmodel = [JCModifyModel mj_objectWithKeyValues:json];
                JCModifyModel *secondModel = [JCModifyModel mj_objectWithKeyValues:firstmodel.response];
                JCModifyModel *thirdModel = [JCModifyModel mj_objectWithKeyValues:secondModel.header];
                if ([thirdModel.success isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"密码修改成功"];
                    [self.bGView removeFromSuperview];
                    [weakSelf hide:YES];
                    //加密
                    NSData *passwordPlain = [weakSelf.firstNewPassword.text dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *passwordCipher = [passwordPlain AES256EncryptWithKey:@"password"];
                    [[NSUserDefaults standardUserDefaults]setObject:passwordCipher forKey:@"aes-password"];
                    
                } else if ([thirdModel.success isEqualToString:@"0"]){
                    [MBProgressHUD showError:thirdModel.message];
                }
            } failure:^(NSError *error) {
                NSLog(@"error:%@",error);
            }];
        }
    };
}

-(void)createBackgroundView{
    self.bGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENwidth, MAINSCREENheight)];
    self.bGView.backgroundColor = [UIColor blackColor];
    self.bGView.alpha = 0.5;
    self.bGView.userInteractionEnabled = YES;
    [WINDOWFirst addSubview:self.bGView];
}


@end
