//
//  AFN_Download_Tool.m
//  CocoaPodsDemo
//
//  Created by 黄刚 on 2017/4/20.
//  Copyright © 2017年 HuangGang'sMac. All rights reserved.
//

#import "AFN_Download_Tool.h"

@implementation AFN_Download_Tool


+(NSURLSessionDownloadTask *)downloadFileWithUrl:(NSString *)url andFileName:(NSString *)filename andFileType:(NSString *)fileType downloadProgress:(DownloadProgress)pregress downloadCompletion:(CompletionState)completion
{
    //1.设置请求
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
//    2.初始化
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
//    3.开始下载
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:requst
                       progress:^(NSProgress * _Nonnull downloadProgress) {
                           pregress(1.0 *downloadProgress.completedUnitCount/downloadProgress.totalUnitCount,1.0 *downloadProgress.totalUnitCount,1.0 *downloadProgress.completedUnitCount);
                    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//                           返回一个NSURL，文件路径
//                        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//                        path = [path stringByAppendingString:[NSString stringWithFormat:@"%@.%@",filename,fileType]];
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/downloadFile",[paths objectAtIndex:0]];
//                        NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/downloadFile",NSHomeDirectory()];
                        BOOL isDir = NO;
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
                        if ( !(isDir == YES && existed == YES) )
                        {
                            [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        NSLog(@"imageDir:%@",imageDir);
                        imageDir = [imageDir stringByAppendingString:[NSString stringWithFormat:@"%@.%@",filename,fileType]];
                        
                        return [NSURL fileURLWithPath:imageDir];//转化为文件路径
                       } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//                           若是下载的是压缩包，可以在这里进行解压
                           NSLog(@"文件路径---%@",filePath);
                           NSString *message = nil;
//                           下载成功
                           if (error == nil) {
                               completion(YES,@"下载完成",[filePath path]);
                           }else{//下载失败
                               if (error.code == -1005)
                               {
                                   message = @"网络异常";

                                   NSLog(@"网络异常");
                               }else if (error.code == - 1001)
                               {
                                   message = @"请求超时";

                               }else
                               {
                                   message = @"未知错误";

                               }
                           
                               completion(NO,message,nil);
                           }
                       }];
    
    return task;
}

+ (void)pause:(NSURLSessionDownloadTask *)task
{
    [task suspend];
}

+ (void)start:(NSURLSessionDownloadTask *)task
{
    [task resume];
}
@end
