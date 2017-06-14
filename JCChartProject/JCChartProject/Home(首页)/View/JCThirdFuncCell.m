
//
//  JCThirdFuncCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/13.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCThirdFuncCell.h"

@interface JCThirdFuncCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation JCThirdFuncCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)favoriteBtn:(UIButton *)sender {
//    sender.selected = !sender.selected;
    [self.delegate clickBtnPassValue:sender.tag andButton:sender];
}

- (void)setFunctionModel:(JCFuncBaseModel *)functionModel{
    _functionModel = functionModel;
    self.titleLabel.text = functionModel.name;
    if ([functionModel.favorite isEqualToString:@"1"]) {
        self.favoriteBtn.selected = YES;
    } else if([functionModel.favorite isEqualToString:@"0"]){
        self.favoriteBtn.selected = NO;
    }
}

@end
