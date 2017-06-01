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

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectAirportBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBtn.layer.cornerRadius = 5;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)selectAirportClick:(id)sender {
    CityViewController *controller = [[CityViewController alloc] init];
    controller.selectString = ^(NSString *string){
        [self.selectAirportBtn setTitle:string forState:UIControlStateNormal];
    };
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)login:(id)sender {
    
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Client-Type"];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"username"] = self.username.text;
    params[@"password"] = self.password.text;
    [manager POST:LoginUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSURLResponse *response = task.response;
        //转换NSURLResponse成为HTTPResponse
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
        //获取headerfields
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        if (fields[@"jsessionid"]) {
            JCBaseModel *baseModel = [JCBaseModel mj_objectWithKeyValues:fields[@"currentUser"]];
            NSLog(@"%@",baseModel.userId);
            [[NSUserDefaults standardUserDefaults]setObject:baseModel.userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults]setObject:fields[@"jsessionid"] forKey:@"jsessionid"];
            MXTabBarController *tabC = [[MXTabBarController alloc] init];
            [self presentViewController:tabC animated:YES completion:nil];
        } else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"登录失败%@",error);
    }];
    
}




@end
