//
//  AFN_Download_Tool.h
//  CocoaPodsDemo
//
//  Created by 黄刚 on 2017/4/20.
//  Copyright © 2017年 HuangGang'sMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void (^DownloadProgress)(CGFloat progress,CGFloat total,CGFloat current);
typedef void (^CompletionState)(BOOL state,NSString *message,NSString *filePath);

@interface AFN_Download_Tool : NSObject

+(NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url andFileName:(NSString *)filename andFileType:(NSString *)fileType downloadProgress:(DownloadProgress)pregress downloadCompletion:(CompletionState)completion;

+(void)pause:(NSURLSessionDownloadTask *)task;
+(void)start:(NSURLSessionDownloadTask *)task;

@end
