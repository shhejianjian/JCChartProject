//
//  AlertView.m
//  CustomAlertView
//
//  Created by 何键键 on 17/5/24.
//  Copyright © 2017年 dzk. All rights reserved.
//

#import "AlertView.h"
#import "HCGDatePickerAppearance.h"
#import "LTPickerView.h"

@interface AlertView ()<ZFDropDownDelegate>
@property (nonatomic, strong) ZFDropDown * dropDown;



@end

@implementation AlertView

-(instancetype)initWithAlertViewHeight:(CGFloat)height
{
    self=[super init];
    if (self) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.layer.cornerRadius = 5;
        self.center = CGPointMake(MAINSCREENwidth/2, MAINSCREENheight/2-80);
        self.bounds = CGRectMake(0, 0, MAINSCREENwidth-20-20, height);
        [WINDOWFirst addSubview:self];
        [self show:YES];
        self.dropDown = [[ZFDropDown alloc] initWithFrame:CGRectMake(100, 53, 150, 25) pattern:kDropDownPatternDefault];
        self.dropDown.delegate = self;
        self.dropDown.cellTextAlignment = NSTextAlignmentCenter;
        [self.dropDown.topicButton setTitle:@"请选择时间周期" forState:UIControlStateNormal];
        self.dropDown.topicButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        self.dropDown.borderStyle = 1;
        self.dropDown.cornerRadius = 10.f;
        [self addSubview:self.dropDown];
    }
    return self;
}

- (IBAction)chooseStartTimeBtn:(id)sender {
    if (!self.timeValueTypeStr) {
        return;
    }
    
    if ([self.timeValueTypeStr isEqualToString:@"时"]) {
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerHourMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd-HH:mm:ss";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.startTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"日"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.startTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"周"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.startTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"月"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.startTimeLabel.text = [dateFormatter stringFromDate:date];
            
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"季"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.startTimeLabel.text = [dateFormatter stringFromDate:date];
            
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"年"]){
        LTPickerView* pickerView = [LTPickerView new];
        pickerView.dataSource = @[@"2000年",@"2001年",@"2002年",@"2003年",@"2004年",@"2005年",@"2006年",@"2007年",@"2008年",@"2009年",@"2010年",@"2011年",@"2012年",@"2013年",@"2014年",@"2015年",@"2016年",@"2017年"];//设置要显示的数据
        pickerView.defaultStr = @"2017年";//默认选择的数据
        [pickerView show];//显示
        //回调block
        pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
            
            self.startTimeLabel.text = str;
            
        };
    }
}


- (IBAction)chooseEndTimeBtn:(id)sender {
    if (!self.timeValueTypeStr) {
        return;
    }
    if ([self.timeValueTypeStr isEqualToString:@"时"]) {
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerHourMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd-HH:mm:ss";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.endTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"日"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.endTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"周"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM-dd";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.endTimeLabel.text = [dateFormatter stringFromDate:date];
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"月"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.endTimeLabel.text = [dateFormatter stringFromDate:date];
            
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"季"]){
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthMode completeBlock:^(NSDate *date) {
            NSString *formatStr = @"yyyy-MM";
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatStr];
            [picker hide];
            self.endTimeLabel.text = [dateFormatter stringFromDate:date];
            
        }];
        [picker show];
    } else if ([self.timeValueTypeStr isEqualToString:@"年"]){
        
    }
}

#pragma mark - ZFDropDownDelegate

- (NSArray *)itemArrayInDropDown:(ZFDropDown *)dropDown{
    return @[@"时", @"日", @"周", @"月", @"季", @"年"];
}

- (NSUInteger)numberOfRowsToDisplayIndropDown:(ZFDropDown *)dropDown itemArrayCount:(NSUInteger)count{
    return 4;
}

- (void)dropDown:(ZFDropDown *)dropDown didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = @[@"时", @"日", @"周", @"月", @"季", @"年"];
    self.timeValueTypeStr = arr[indexPath.row];
}


- (void)show:(BOOL)animated
{
    if (animated)
    {
        self.transform = CGAffineTransformScale(self.transform,0,0);
        __weak AlertView *weakSelf = self;
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
    [self hide:YES];
    if (self.ButtonClick) {
        self.ButtonClick(sender);
    }
}


- (void)hide:(BOOL)animated
{
        NSLog(@"hide");
        __weak AlertView *weakSelf = self;
        
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
