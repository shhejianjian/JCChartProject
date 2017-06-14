//
//  JCMainHomeVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/9.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCMainHomeVC.h"
#import "MXConstant.h"
#import "GridView.h"
#import "GridButton.h"
#import "JCFirstMenuVC.h"
#import "JCFuncBaseModel.h"

extern NSString *subscribStr;

@interface JCMainHomeVC ()<GridViewDelegate>
@property(nonatomic,strong)GridView *gridView;
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIButton *allBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;

@end

@implementation JCMainHomeVC

- (void)viewWillAppear:(BOOL)animated{
    if (subscribStr) {
        [self loadHotMenu];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    subscribStr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"首页";
    self.myScrollView.bounces = NO;
    [self loadHotMenu];
    [self.gridView updateNewFrame];
}


-(void)updateHeight:(CGFloat)height
{
    self.gridView.height = height;
    //2行  -22；
    //3行  40.5
//    self.scrollViewConstraint.constant = 40.5;
    self.myScrollView.contentSize = CGSizeMake(0, self.gridView.height+self.gridView.y);
}



-(void)clickGridView:(GridButton *)item
{
    NSLog(@"id::%@--%ld",item.objectId,item.gridId);
    if ([item.gridTitle isEqualToString:@"更多"]) {
        JCFirstMenuVC *firstMenuVC = [[JCFirstMenuVC alloc]init];
        [self.navigationController pushViewController:firstMenuVC animated:YES];
    }
}
- (void)showChangeView{
    NSLog(@"长按");
}

- (void)loadHotMenu{
    [self.showImageGridArray removeAllObjects];
    [self.showGridTitleArray removeAllObjects];
    [self.showGridIDArray removeAllObjects];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[GridView class]]) {
            NSLog(@"111");
            [view removeFromSuperview];
        }
    }
    NSArray *imagearr = @[@"more_icon_Transaction_flow",@"more_icon_cancle_deal", @"more_icon_Search",
                          @"more_icon_t0",@"more_icon_shouyin" ,@"more_icon_d1",
                          @"more_icon_Settlement",@"more_icon_Mall", @"more_icon_gift",
                          @"more_icon_licai",@"more_icon_-transfer",@"more_icon_Recharge" ,
                          @"more_icon_Transfer-" , @"more_icon_Credit-card-",@"more_icon_Manager",@"work-order",@"add_businesses"];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    [XHHttpTool get:favoriteMenuUrl params:nil jessionid:jsessionid success:^(id json) {
        NSLog(@"menu::%@",json);
        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:json];
        for (JCFuncBaseModel *model in mainArr) {
            [self.showGridTitleArray addObject:model.name];
            [self.showGridIDArray addObject:model.objectId];
        }
        for (int i = 0; i < mainArr.count; i++) {
            [self.showImageGridArray addObject:imagearr[i]];
        }
        [self setGridViewWithTitleArr:self.showGridTitleArray andIdArr:self.showGridIDArray];
    } failure:^(NSError *error) {
        
    }];
}

- (void) setGridViewWithTitleArr:(NSArray *)titleArr andIdArr:(NSArray *)IDArr{
    
    NSInteger index = self.showGridTitleArray.count;
    [self.showGridTitleArray insertObject:@"更多" atIndex:index];
    [self.showGridIDArray insertObject:@"more" atIndex:index];
    [self.showImageGridArray insertObject:@"add_businesses" atIndex:index];
    self.gridView =[[GridView alloc]initWithFrame:CGRectMake(0, self.allBtn.y+80, KScreenW, self.detailView.height) showGridTitleArray:self.showGridTitleArray showImageGridArray:self.showImageGridArray showGridIDArray:self.showGridIDArray];
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.gridViewDelegate = self;
    [self.detailView addSubview:_gridView];
    [self.gridView updateNewFrame];
}

#pragma mark---懒加载---


- (NSMutableArray *)showGridIDArray {
	if(_showGridIDArray == nil) {
		_showGridIDArray = [[NSMutableArray alloc] init];
	}
	return _showGridIDArray;
}

- (NSMutableArray *)showGridTitleArray {
	if(_showGridTitleArray == nil) {
		_showGridTitleArray = [[NSMutableArray alloc] init];
	}
	return _showGridTitleArray;
}

- (NSMutableArray *)showImageGridArray {
	if(_showImageGridArray == nil) {
		_showImageGridArray = [[NSMutableArray alloc] init];
	}
	return _showImageGridArray;
}

@end
