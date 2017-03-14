//
//  AFHTTPSessionManager_Ex.h
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/19.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager ()

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
