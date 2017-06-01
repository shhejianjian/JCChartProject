//
//  JCFuncVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/1.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCFuncVC.h"
#import "MXConstant.h"
#import "LXScollTitleView.h"
#import "LXScrollContentView.h"
#import "LXTestViewController.h"
#import "JCFuncBaseModel.h"


@interface JCFuncVC ()
//@property (nonatomic, strong) LXScollTitleView *titleView;
@property (strong, nonatomic) IBOutlet LXScollTitleView *titleView;
@property (strong, nonatomic) IBOutlet LXScrollContentView *contentView;

@property (nonatomic, strong) NSMutableArray *menuArr;

//@property (nonatomic, strong) LXScrollContentView *contentView;
@end

@implementation JCFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"功能";
    [self loadFirstMenu];
    [self setupUI];
}
- (void)loadFirstMenu{
    NSString *userid = [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSString *firstMenuUrl = [NSString stringWithFormat:@"%@%@",MenuUrl,userid];
    [XHHttpTool get:firstMenuUrl params:nil jessionid:jsessionid success:^(id json) {
        NSArray *mainArr = [JCFuncBaseModel mj_objectArrayWithKeyValuesArray:json];
        NSMutableArray *firstMenuArr = [NSMutableArray array];
        for (JCFuncBaseModel *mainModel in mainArr) {
//            NSLog(@"1级：%@--%@",mainModel.name,mainModel.objectId);
            [firstMenuArr addObject:mainModel.name];
            [self.menuArr addObject:mainModel];
        }
        [self performSelectorOnMainThread:@selector(getDataList:)
                               withObject:firstMenuArr // 将局部变量dataList作为参数传出去
                            waitUntilDone:YES];
    } failure:^(NSError *error) {
        
    }];
}
- (void)setupUI{
    self.titleView = [[LXScollTitleView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    self.titleView.selectedBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.contentView.currentIndex = index;
    };
    self.titleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.titleView.titleWidth = 100.f;
    [self.view addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.scrollBlock = ^(NSInteger index){
        __weak typeof(self) strongSelf = weakSelf;
        strongSelf.titleView.selectedIndex = index;
    };
    [self.view addSubview:self.contentView];
}

-(void)getDataList:(id)sender {
    NSMutableArray * dataList = (NSMutableArray *)sender;
    [self.titleView reloadViewWithTitles:dataList];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (int i = 0;i < dataList.count;i++) {
        LXTestViewController *vc = [[LXTestViewController alloc] init];
        vc.secondFuncModel = self.menuArr[i];
        [vcs addObject:vc];
    }
    [self.contentView reloadViewWithChildVcs:vcs parentVC:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(0, 64, self.view.frame.size.width, 35);
    self.contentView.frame = CGRectMake(0, 99, self.view.frame.size.width, self.view.frame.size.height - 146);
}

- (NSMutableArray *)menuArr {
	if(_menuArr == nil) {
		_menuArr = [[NSMutableArray alloc] init];
	}
	return _menuArr;
}

@end
