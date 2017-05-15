//
//  NSString+Add.h
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Add)


/**
 *  获取给定字符串大小
 */
- (CGSize)sizeWithFont:(UIFont *)font;



/**
 *  判定字符串是否非空
 */
- (BOOL)isEmptyString;



/**
 *  判定字符串是否非空，(若全部为空格，也判定为空字符串，返回YES)
 */
- (BOOL)isEmptyStringNoSpaces;



@end
