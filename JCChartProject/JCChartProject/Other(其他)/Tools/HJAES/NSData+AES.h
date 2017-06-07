//
//  NSData+AES.h
//  JCChartProject
//
//  Created by 何键键 on 17/6/6.
//  Copyright © 2017年 JC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

/**
 * Encrypt NSData using AES256 with a given symmetric encryption key.
 * @param key The symmetric encryption key
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;

/**
 * Decrypt NSData using AES256 with a given symmetric encryption key.
 * @param key The symmetric encryption key
 */
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end
