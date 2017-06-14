//
//  JCHomeVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCHomeVC.h"
#import "MXConstant.h"
#import "JCTopChartCell.h"
#import "JCBottomViewCell.h"
#import "JCFirstMenuVC.h"
static NSString *topID=@"JCTopChartCell";
static NSString *bottomID=@"JCBottomViewCell";

@interface JCHomeVC () <JCBottomViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation JCHomeVC

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"首页";
//    [self checkAppVersion];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCTopChartCell" bundle:nil] forCellReuseIdentifier:topID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCBottomViewCell" bundle:nil] forCellReuseIdentifier:bottomID];
}

- (void) checkAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"version"] = appCurVersion;
    params[@"appType"] = @"iOS";
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    [XHHttpTool get:updateAppVersionUrl params:params jessionid:jsessionid success:^(id json) {
        NSLog(@"json::%@",json);
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}


#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    if (indexPath.section == 0) {
        JCTopChartCell *topCell=[tableView dequeueReusableCellWithIdentifier:topID];
        
        if (!topCell) {
            
            topCell=[[JCTopChartCell alloc]init];
            
        }
        
        cell = topCell;
    }
    if (indexPath.section == 1) {
        JCBottomViewCell *bottomCell=[tableView dequeueReusableCellWithIdentifier:bottomID];
        
        if (!bottomCell) {
            
            bottomCell=[[JCBottomViewCell alloc]init];
            
        }
        bottomCell.delegate = self;
        cell = bottomCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{    
    if (indexPath.section == 0) {
        return 400;
    } else if (indexPath.section == 1){
        JCBottomViewCell *cell = (JCBottomViewCell *)[self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight+49;
    }
    return 0;
}

- (void)clickGridBtn:(GridButton *)item{
    NSLog(@"%@",item.gridTitle);
    if ([item.gridTitle isEqualToString:@"更多"]) {
        JCFirstMenuVC *firstMenuVC = [[JCFirstMenuVC alloc]init];
        [self.navigationController pushViewController:firstMenuVC animated:YES];
    }
}

- (void)changeGridView{
    [self.myTableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titleArr = @[@"能耗示意图",@"能耗统计分析"];
    static NSString *HeaderIdentifier = @"header";
    UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderIdentifier];
    CGFloat labelWidth = [self getTextWithWhenDrawWithText:titleArr[section]];
    if( headerView == nil)
    {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderIdentifier];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, labelWidth, 25)];
        titleLabel.tag = 1;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = globalColor;
        UILabel * viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+20, 12.5, KScreenW - (labelWidth+20) - 15, 0.5)];
        viewLabel.backgroundColor = middlegrayColor;
        [headerView.contentView addSubview:viewLabel];
        [headerView.contentView addSubview:titleLabel];
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *label = (UILabel *)[headerView viewWithTag:1];
    label.font = [UIFont systemFontOfSize:15];
    label.text = titleArr[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    CGSize size=[text sizeWithAttributes:attrs];
    return size.width;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.myTableView)
    {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
