//
//  JCBottomViewCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/9.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridButton.h"

@protocol JCBottomViewCellDelegate <NSObject>

-(void)changeGridView;
- (void)clickGridBtn:(GridButton *)item;
@end


@interface JCBottomViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bottomTitle;
@property (strong, nonatomic) IBOutlet UIProgressView *bottomProgress;
@property (strong, nonatomic) IBOutlet UILabel *bottomValue;
@property (nonatomic, weak) id <JCBottomViewCellDelegate> delegate;

@property (nonatomic, assign) CGFloat cellHeight;

@end
