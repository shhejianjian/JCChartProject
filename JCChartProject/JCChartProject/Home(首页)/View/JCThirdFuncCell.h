//
//  JCThirdFuncCell.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/13.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCFuncBaseModel.h"

@protocol  JCThirdFuncCellDelegate <NSObject>

- (void)clickBtnPassValue:(NSInteger )index andButton:(UIButton *)btn;

@end

@interface JCThirdFuncCell : UITableViewCell
@property (nonatomic, strong) JCFuncBaseModel *functionModel;
@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (nonatomic, weak) id <JCThirdFuncCellDelegate> delegate;
@end
