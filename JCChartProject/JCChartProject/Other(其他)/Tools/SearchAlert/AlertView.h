//
//  AlertView.h
//  CustomAlertView
//
//  Created by 何键键 on 17/5/24.
//  Copyright © 2017年 dzk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDropDown.h"

#define MAINSCREENwidth   [UIScreen mainScreen].bounds.size.width
#define MAINSCREENheight  [UIScreen mainScreen].bounds.size.height
#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]
#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface AlertView : UIView
@property(copy,nonatomic)void (^ButtonClick)(UIButton*);

-(instancetype)initWithAlertViewHeight:(CGFloat)height;
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;
@property (nonatomic, copy) NSString *timeValueTypeStr;

@end
