//
//  JCBottomViewCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/9.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCBottomViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bottomTitle;
@property (strong, nonatomic) IBOutlet UIProgressView *bottomProgress;
@property (strong, nonatomic) IBOutlet UILabel *bottomValue;

@end
