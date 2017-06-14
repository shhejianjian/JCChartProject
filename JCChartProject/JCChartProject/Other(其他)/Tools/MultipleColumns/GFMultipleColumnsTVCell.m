//
//  GFMultipleColumnsTVCell.m
//  UITableView多列展示
//
//  Created by 高得华 on 16/9/2.
//  Copyright © 2016年 GaoFei. All rights reserved.
//

#define kJianXi 15.0f
#define kViewWidth  [UIScreen mainScreen].bounds.size.width
#define kViewHeight [UIScreen mainScreen].bounds.size.height
#define kClickBtnHeight 36

#import "GFMultipleColumnsTVCell.h"
#import "MXConstant.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
@interface GFMultipleColumnsTVCell ()

@property (nonatomic,assign) NSInteger columns;

@end

@implementation GFMultipleColumnsTVCell

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self loadCreateViewLayout];
        
        
    }
    return self;
}

-(instancetype)init{
    if ([super init]) {
        [self loadCreateViewLayout];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadCreateViewLayout];
}

//设置页面布局
- (void) loadCreateViewLayout{
    self.backgroundColor = [UIColor whiteColor];
    self.columns = 3;
}
-(void)setDataArrayCount:(NSInteger)dataArrayCount{
    _dataArrayCount = dataArrayCount;
    self.cellHeight = [self heightForCount:_dataArrayCount];
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
    }
    [self loadCreateScratchableLatex];
}
-(void)setIconArray:(NSArray *)iconArray{
    _iconArray = iconArray;
    [self loadCreateScratchableLatex];
}
//创建九宫格---
- (void)loadCreateScratchableLatex {
    
    if (self.iconArray.count == self.dataArray.count) {
        if (self.dataArray.count <= 0) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            label.text = @"暂无数据";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            [self addSubview:label];
        }else{
            
            for (NSInteger i = 0; i < self.dataArray.count ; i++) {
                
                UIButton * selectBtn = [[UIButton alloc] initWithFrame:[self frameForItemIndex:i]];
                selectBtn.backgroundColor = cleargrayColor;
                [selectBtn addTarget:self action:@selector(clickBtnAct:) forControlEvents:UIControlEventTouchUpInside];
                [selectBtn setTitle:self.dataArray[i] forState:UIControlStateNormal];
                [selectBtn setTitleColor:grayColor forState:UIControlStateNormal];
                selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                selectBtn.contentEdgeInsets = UIEdgeInsetsMake(0,0, -60, 0);
                [self addSubview:selectBtn];
                //            NSString * tagStr = [NSString stringWithFormat:@"%ld%ld%ld",self.indexPath.section,self.indexPath.row,i];
                //            NSLog(@"%ld",[tagStr integerValue]);//[tagStr integerValue]
                selectBtn.tag = i+100;
                
                UILabel *iconLabel = [[UILabel alloc]initWithFrame:[self frameForIconLabelIndex:i]];
                NSError *error;
                iconLabel.textAlignment = NSTextAlignmentCenter;
                FAKFontAwesome *starIcon = [FAKFontAwesome  iconWithIdentifier:self.iconArray[i] size:40 error:&error];
                iconLabel.attributedText = [starIcon attributedString];
                [self addSubview:iconLabel];
            }
        }
    }
}

//btn的点击响应事件
- (void)clickBtnAct:(UIButton *)sender {
    self.ReturnClickItemIndex(self.indexPath, sender.tag - 100);
}

//计算每个UIButton的frame
-(CGRect)frameForItemIndex:(NSInteger)count{

    //每个图片的宽度
    CGFloat itemW = (kViewWidth - (self.columns+1)*kJianXi)/self.columns;
    //计算xy轴的坐标
    CGFloat x = count%self.columns*itemW +kJianXi *(count%self.columns+1);
    CGFloat y = count/self.columns*itemW +kJianXi *(count/self.columns+1);
    return CGRectMake(x, y, itemW, itemW);
}
//计算每个UIButton的frame
-(CGRect)frameForIconLabelIndex:(NSInteger)count{
    
    //每个图片的宽度
    CGFloat itemW = (kViewWidth - (self.columns+1)*kJianXi)/self.columns;
    //计算xy轴的坐标
    CGFloat x = count%self.columns*itemW +kJianXi *(count%self.columns+1);
    CGFloat y = count/self.columns*itemW +kJianXi *(count/self.columns+1);
    return CGRectMake(x+15, y, itemW-30, itemW-30);
}
//根据数据计算高度
-(CGFloat)heightForCount:(NSInteger)count{
    CGFloat itemW = (kViewWidth - (self.columns+1)*kJianXi)/self.columns;
    //计算行数
    long row = count/self.columns;
    
    if (count%self.columns != 0) {
        
        row++;
    }
    
    //每个图片的宽度
//    CGFloat itemW = (kViewWidth - (self.columns+1)*kJianXi)/self.columns;
    CGFloat height = itemW * row +kJianXi*(row+1);
    return height;
}

@end
