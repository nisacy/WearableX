//
//  AFHTTPSessionManagerSub.h
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/19.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager_Ex.h"

@interface AFHTTPSessionManagerSub : AFHTTPSessionManager


/**
 *  自定义，为了兼容各个不同的请求方式
 *
 *  @param NSURLSessionDataTask
 *
 *  @return return value description
 */
- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString
                                HTTPMethod:(NSString *)httpMethod
                                     files:(NSArray *)files
                                parameters:(id)parameters
                                  progress:(void (^)(NSProgress *uploadProgress))progress
                                   success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                   failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
