//
//  PasswordAlertView.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface PasswordAlertView : UIView
@property(copy,nonatomic)void (^ButtonClick)(UIButton*);
-(instancetype)initWithAlertViewHeight:(CGFloat)height;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *firstNewPassword;
@property (strong, nonatomic) IBOutlet UITextField *secondNewPassword;

@end
