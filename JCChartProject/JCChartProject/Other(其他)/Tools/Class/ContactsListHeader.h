//
//  ContactsListHeader.h
//  QQProject
//
//  Created by Lester on 16/9/8.
//  Copyright © 2016年 Lester-iOS开发:98787555. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsGroupModel.h"

@protocol ContactsListHeaderDelegate <NSObject>

@optional
/** 点击头视图事件*/
- (void)didSelectTableViewHeaderFooterView:(NSInteger)index;

@end

@interface ContactsListHeader : UITableViewHeaderFooterView
/** 代理*/
@property (nonatomic, assign) id<ContactsListHeaderDelegate> delegate;
/** 设置model*/
@property (strong, nonatomic) ContactsGroupModel *groupModel;

/** 初始化方法*/
+ (instancetype)headerView:(UITableView *)tableView;

/** 箭头*/
@property (strong, nonatomic) UIButton *arrowButton;

//- (void)setGroupModel:()
@end
