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

static NSString *topID=@"JCTopChartCell";
static NSString *bottomID=@"JCBottomViewCell";

@interface JCHomeVC ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation JCHomeVC

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCTopChartCell" bundle:nil] forCellReuseIdentifier:topID];
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCBottomViewCell" bundle:nil] forCellReuseIdentifier:bottomID];
}


#pragma mark - tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1){
        return 4;
    }
    return 0;
    
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
        if (indexPath.row == 0) {
            bottomCell.bottomProgress.progress = 1;
        } else if (indexPath.row == 1) {
            bottomCell.bottomProgress.progress = 0.4;
            bottomCell.bottomProgress.progressTintColor = LBColor(71, 204, 255);
            bottomCell.bottomTitle.text = @"电能耗值";
            bottomCell.bottomValue.text = @"4000.0";
        } else if (indexPath.row == 2) {
            bottomCell.bottomProgress.progress = 0.5;
            bottomCell.bottomProgress.progressTintColor = LBColor(253, 203, 76);
            bottomCell.bottomTitle.text = @"水能耗值";
            bottomCell.bottomValue.text = @"5000.0";
        } else if (indexPath.row == 3) {
            bottomCell.bottomProgress.progress = 0.1;
            bottomCell.bottomProgress.progressTintColor = LBColor(214, 205, 153);
            bottomCell.bottomTitle.text = @"气能耗值";
            bottomCell.bottomValue.text = @"1000.0";
        }
        
        
        cell = bottomCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section == 0) {
        return 400;
    } else if (indexPath.section == 1){
        return 60;
    }
    return 0;
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

@end
