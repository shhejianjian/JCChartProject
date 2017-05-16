//
//  JCFuncThirdVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/16.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFuncThirdVC.h"
#import "MXConstant.h"
#import "GridView.h"
#import "GridButton.h"
@interface JCFuncThirdVC ()<GridViewDelegate>
@property(nonatomic,strong)GridView *gridView;

@property(nonatomic,strong)UIScrollView *myScrollview;
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID
@end

@implementation JCFuncThirdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = self.thirdFuncModel.name;
    [self loadData];
    self.gridView =[[GridView alloc]initWithFrame:CGRectMake(0, 64, KScreenW, 200) showGridTitleArray:self.showGridTitleArray showImageGridArray:self.showImageGridArray showGridIDArray:self.showGridIDArray];
    self.gridView.backgroundColor = [UIColor whiteColor];
    self.gridView.gridViewDelegate = self;
    [self.view addSubview:_gridView];
    
    [self.gridView updateNewFrame];
    self.myScrollview.contentSize = CGSizeMake(0, self.gridView.height+244);
    // Do any additional setup after loading the view from its nib.
}


- (void) loadData{
    NSArray *thirdArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:self.thirdFuncModel.childList];
    for (JCFuncBaseModel *thirdModel in thirdArr) {
        [self.showGridTitleArray addObject:thirdModel.name];
        [self.showGridIDArray addObject:thirdModel.objectId];
        NSLog(@"%@==%@",thirdModel.name,thirdModel.objectId);
    }
}


-(void)updateHeight:(CGFloat)height
{
    self.gridView.height = height;
    self.myScrollview.contentSize = CGSizeMake(KScreenW, height+244);
}
-(void)clickGridView:(GridButton *)item
{
    
    [self loadMenuDetailWithObjectId:item.objectId];
    
}




- (void)loadMenuDetailWithObjectId:(NSString*)objectId{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *menuDetailUrl = [NSString stringWithFormat:@"%@%@",MenuDetailUrl,objectId];
    [XHHttpTool get:menuDetailUrl params:nil jessionid:jsessionid success:^(id json) {
        NSLog(@"--%@",json);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}












- (UIScrollView *)myScrollview {
    if(_myScrollview == nil) {
        _myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -128, KScreenW, KScreenH+128)];
        _myScrollview.contentSize = CGSizeMake(KScreenW, self.gridView.height+244);
        _myScrollview.contentOffset = CGPointMake(0, -64);
        _myScrollview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _myScrollview.showsHorizontalScrollIndicator = NO;
        _myScrollview.showsVerticalScrollIndicator = YES;
        _myScrollview.bounces = NO;
        _myScrollview.backgroundColor =[UIColor clearColor];
    }
    return _myScrollview;
}

#pragma mark---懒加载---


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

- (NSMutableArray *)showGridTitleArray {
	if(_showGridTitleArray == nil) {
		_showGridTitleArray = [[NSMutableArray alloc] init];
	}
	return _showGridTitleArray;
}

- (NSMutableArray *)showGridIDArray {
	if(_showGridIDArray == nil) {
		_showGridIDArray = [[NSMutableArray alloc] init];
	}
	return _showGridIDArray;
}

@end
