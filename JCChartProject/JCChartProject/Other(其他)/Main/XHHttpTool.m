//
//  BSHttpTool.m
//  busale
//
//  Created by 谢琰 on 15/12/22.
//  Copyright © 2015年 busale. All rights reserved.
//

#import "XHHttpTool.h"
#import "AFNetworking.h"
#import "XHConst.h"
#import "MBProgressHUD+MJ.h"

@implementation XHHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
            failure(error);
        }
    }];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params jessionid:(NSString *)jessionid success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jessionid] forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Client-Type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    
    [manager GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
            failure(error);
        }
    }];
}


+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
            failure(error);
        }
    }];
 }
+ (void)post:(NSString *)url params:(NSDictionary *)params jessionid:(NSString *)jessionid success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jessionid] forHTTPHeaderField:@"Cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"Client-Type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
            failure(error);
        }
    }];
}
+ (void)put:(NSString *)url params:(id)params jessionid:(NSString *)jessionid success:(void(^)(id json))success failure:(void(^)(NSError *error)) failure
{
    AFHTTPSessionManager  *manager=[AFHTTPSessionManager  manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json",@"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jessionid] forHTTPHeaderField:@"Cookie"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"Client-Type"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    [manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
      if (success) {
          success(responseObject);
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [MBProgressHUD showError:@"网络连接不稳定，请稍后再试"];
          failure(error);
        }
     }];
}

@end
