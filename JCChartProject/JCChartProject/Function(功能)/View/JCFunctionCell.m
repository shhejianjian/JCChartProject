//
//  JCFunctionCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFunctionCell.h"

@interface JCFunctionCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation JCFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFunctionModel:(JCFuncBaseModel *)functionModel {
    _functionModel = functionModel;
    self.titleLabel.text = functionModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
