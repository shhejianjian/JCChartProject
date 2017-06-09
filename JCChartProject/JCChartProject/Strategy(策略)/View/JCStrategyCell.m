//
//  JCStrategyCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/7.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCStrategyCell.h"

@interface JCStrategyCell ()
@property (strong, nonatomic) IBOutlet UILabel *strategyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *activeTimeLabel;

@end

@implementation JCStrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setStrategyListModel:(JCStrategyListModel *)strategyListModel{
    _strategyListModel = strategyListModel;
    self.strategyNameLabel.text = strategyListModel.strategyName;
    self.messageLabel.text = strategyListModel.message;
    self.activeTimeLabel.text = strategyListModel.activeTime;
}

- (void)setAbnormalDataModel:(JCMoreModel *)abnormalDataModel{
    _abnormalDataModel = abnormalDataModel;
    self.strategyNameLabel.text = abnormalDataModel.dataPointName;
    self.messageLabel.text = abnormalDataModel.message;
    self.activeTimeLabel.text = abnormalDataModel.measureTime;

}

-(void)setWordDataModel:(JCMoreModel *)wordDataModel{
    _wordDataModel = wordDataModel;
    self.strategyNameLabel.text = wordDataModel.officeDocumentName;
    self.messageLabel.text = wordDataModel.documentType;
    self.activeTimeLabel.text = wordDataModel.createdDate;
}
@end
