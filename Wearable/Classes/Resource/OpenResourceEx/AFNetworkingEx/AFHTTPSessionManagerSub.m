//
//  AFHTTPSessionManagerSub.m
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/19.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "AFHTTPSessionManagerSub.h"

@implementation AFHTTPSessionManagerSub

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString
                                HTTPMethod:(NSString *)httpMethod
                                     files:(NSArray *)files
                                parameters:(id)parameters
                                progress:(void (^)(NSProgress *uploadProgress))progress
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    NSURLSessionDataTask *task = [self dataTaskWithHTTPMethod:httpMethod
                                               URLString:URLString
                                               parameters:parameters
                                               uploadProgress:^(NSProgress *uploadProgress) {
                                                   progress(uploadProgress);
                                               } downloadProgress:^(NSProgress *downloadProgress) {
                                                   progress(downloadProgress);
                                               } success:^(NSURLSessionDataTask *task, id responseObject) {
                                                   success(task,responseObject);
                                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   failure(task,error);
                                               }];
    
    [task resume];
    
    return task;
}

@end
