//
//  ViewController.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "ViewController.h"
#import "MXConstant.h"
#import "CityViewController.h"
#import "JCLeftVC.h"
#import "YRSideViewController.h"
#import "Lottie.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "NSData+AES.h"
#import "JCModifyModel.h"


@interface ViewController ()
{
    LAContext *context;
}
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectAirportBtn;

@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIView *touchIDView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    context= [[LAContext alloc] init];
    [self setUI];
    
}

- (void)setUI{
    self.loginBtn.layer.cornerRadius = 5;
    
    NSString *checkTouchIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"touchID"];
    if (!checkTouchIdStr) {
        self.touchIDView.hidden = YES;
        self.loginView.hidden = NO;
    } else{
        if ([checkTouchIdStr isEqualToString:@"yes"]) {
            self.loginView.hidden = YES;
            self.touchIDView.hidden = NO;
            [self initIT];
        } else if ([checkTouchIdStr isEqualToString:@"no"]){
            self.loginView.hidden = NO;
            self.touchIDView.hidden = YES;
        }
    }
    
    
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"fingerprint2"];
    CGPoint center=self.touchIDView.center;
    center.y =self.touchIDView.center.y + 100;
    animation.frame = CGRectMake(0, 0, 290, 110);
    animation.center = center;
    [self.touchIDView addSubview:animation];
    [animation play];
    LOTAnimationView *animation2 = [LOTAnimationView animationNamed:@"autoconnect_loading"];
    animation2.frame = CGRectMake(0, 0, self.touchIDView.width, 130);
    animation2.center = center;
    animation2.animationSpeed = 0.5;
    animation2.loopAnimation = YES;
    [self.touchIDView addSubview:animation2];
    [animation2 play];
}


- (void)initIT{
    
    // 判断用户手机系统是否是 iOS 8.0 以上版本
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        self.touchIDView.hidden = YES;
        self.loginView.hidden = NO;

        return;
    }
    
    // 判断是否支持指纹识别
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL]) {
        self.touchIDView.hidden = YES;
        self.loginView.hidden = NO;
        return;
    }
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
            localizedReason:@"请验证已有指纹"
                      reply:^(BOOL success, NSError * _Nullable error) {
                          // 输入指纹开始验证，异步执行
                          if (success) {
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证成功"] message:nil];
                          }else{
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证失败"] message:error.userInfo[NSLocalizedDescriptionKey]];
                          }
                      }];
}
// 主线程刷新 UI
- (void)refreshUI:(NSString *)str message:(NSString *)msg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
                if ([str isEqualToString:@"指纹验证成功"]) {
                    //解密
                    NSData *usernameCipher = [[NSUserDefaults standardUserDefaults]objectForKey:@"aes-username"];
                    NSData *usernamePlain = [usernameCipher AES256DecryptWithKey:@"username"];
                    NSString *username = [[NSString alloc] initWithData:usernamePlain encoding:NSUTF8StringEncoding];
                    NSData *passwordCipher = [[NSUserDefaults standardUserDefaults]objectForKey:@"aes-password"];
                    NSData *passwordPlain = [passwordCipher AES256DecryptWithKey:@"password"];
                    NSString *password = [[NSString alloc] initWithData:passwordPlain encoding:NSUTF8StringEncoding];
                    [self loginWithUsername:username AndPassword:password];
                }
                if ([str isEqualToString:@"指纹验证失败"]) {
                    self.touchIDView.hidden = YES;
                    self.loginView.hidden = NO;
                }
            });
        }];
    });
}




- (IBAction)selectAirportClick:(id)sender {
    CityViewController *controller = [[CityViewController alloc] init];
    controller.selectString = ^(NSString *string){
        [self.selectAirportBtn setTitle:string forState:UIControlStateNormal];
    };
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)login:(id)sender {
    
    [self loginWithUsername:self.username.text AndPassword:self.password.text];
    
}

- (void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password{
    [MBProgressHUD showMessage:@"正在登录" toView:self.view];
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Client-Type"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"username"] = username;
    params[@"password"] = password;
    
    [manager POST:LoginUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        NSURLResponse *response = task.response;
        //转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        //获取headerfields
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        if (fields[@"jsessionid"]) {
            [MBProgressHUD showSuccess:@"登录成功"];
            //加密
            NSData *usernamePlain = [username dataUsingEncoding:NSUTF8StringEncoding];
            NSData *usernameCipher = [usernamePlain AES256EncryptWithKey:@"username"];
            NSData *passwordPlain = [password dataUsingEncoding:NSUTF8StringEncoding];
            NSData *passwordCipher = [passwordPlain AES256EncryptWithKey:@"password"];
            [[NSUserDefaults standardUserDefaults]setObject:usernameCipher forKey:@"aes-username"];
            [[NSUserDefaults standardUserDefaults]setObject:passwordCipher forKey:@"aes-password"];
            
            JCBaseModel *baseModel = [JCBaseModel mj_objectWithKeyValues:fields[@"currentUser"]];
            NSLog(@"%@",baseModel.userId);
            [[NSUserDefaults standardUserDefaults]setObject:baseModel.userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setObject:fields[@"jsessionid"] forKey:@"jsessionid"];
            MXTabBarController *tabC = [[MXTabBarController alloc] init];
            
//            //加载侧滑控制器
//            YRSideViewController *sideVc = [[YRSideViewController alloc]init];
//            JCLeftVC *leftVC = [[JCLeftVC alloc]init];
//            sideVc.rootViewController = tabC;
//            sideVc.leftViewController = leftVC;
//            sideVc.leftViewShowWidth = [[UIScreen mainScreen] bounds].size.width * 0.7;
//            sideVc.needSwipeShowMenu = true;//默认开启的可滑动展示
            [self presentViewController:tabC animated:YES completion:nil];
            
        } else {
            NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
            NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            JCModifyModel *modifyModel = [JCModifyModel mj_objectWithKeyValues:jsonDict];
            [MBProgressHUD showError:modifyModel.message];
            self.loginView.hidden = NO;
            self.touchIDView.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
        NSLog(@"登录失败%@",error);
    }];
}




@end
