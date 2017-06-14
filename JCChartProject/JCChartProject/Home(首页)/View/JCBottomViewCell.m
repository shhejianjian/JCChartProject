//
//  JCBottomViewCell.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/9.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCBottomViewCell.h"
#import "GridView.h"
#import "MXConstant.h"
#import "GridButton.h"

@interface JCBottomViewCell () <GridViewDelegate>
@property(nonatomic,strong)GridView *gridView;
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID


@end

@implementation JCBottomViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gridView =[[GridView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, self.contentView.height) showGridTitleArray:self.showGridTitleArray showImageGridArray:self.showImageGridArray showGridIDArray:self.showGridIDArray];
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.gridViewDelegate = self;
    [self.contentView addSubview:_gridView];
    [self.gridView updateNewFrame];
}



-(void)updateHeight:(CGFloat)height
{
    self.gridView.height = height;
    self.cellHeight = height;
    
}
-(void)clickGridView:(GridButton *)item
{
    [self.delegate clickGridBtn:item];
    
}
- (void)showChangeView{
   
    
}






#pragma mark---懒加载---
- (NSMutableArray *)showGridTitleArray {
    if(_showGridTitleArray == nil) {
        _showGridTitleArray = [NSMutableArray arrayWithObjects:@"我的申请",@"我的审批",@"待定", @"待定待定", @"待定",@"待定", @"待定",@"待定", @"待定待定", @"待定", @"待定", @"待定", @"待定" , @"待定待定", @"待定", @"待定",@"更多", nil];
    }
    return _showGridTitleArray;
}

- (NSMutableArray *)showImageGridArray {
    if(_showImageGridArray == nil) {
        _showImageGridArray = [NSMutableArray arrayWithObjects:
                               @"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
                               @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
                               @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
                               @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
                               @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order",@"add_businesses", nil];
        ;
    }
    return _showImageGridArray;
}

- (NSMutableArray *)showGridIDArray {
    if(_showGridIDArray == nil) {
        _showGridIDArray = [NSMutableArray arrayWithObjects:
                            @"1000",@"1001", @"1002",
                            @"1003",@"1004",@"1005" ,@"1006",
                            @"1007",@"1008", @"1009",
                            @"1010",@"1011",@"1012" ,
                            @"1013" , @"1014",@"1015",@"0", nil];
    }
    return _showGridIDArray;
}
@end
