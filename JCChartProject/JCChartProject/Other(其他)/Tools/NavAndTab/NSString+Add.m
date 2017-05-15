//
//  NSString+Add.m
//  navDemo
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 maxzhang. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)


- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:nil].size;
}



- (BOOL)isEmptyString
{
    if ([self isKindOfClass:[NSNull class]] || !self || [self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}



- (BOOL)isEmptyStringNoSpaces
{
    if ([self isKindOfClass:[NSNull class]] || !self || [self isEqualToString:@""]) {
        return YES;
    }
    else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}



@end
