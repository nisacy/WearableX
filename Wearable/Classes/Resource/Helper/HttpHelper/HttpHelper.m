//
//  HttpHelper.m
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/17.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import "HttpHelper.h"
#import "EncryptionHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>




@implementation HttpHelper

+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow  finished:(REQUEST_FINISH)finished{
    return [self requestWithPrameters:request withFiles:nil isShowProgress:isShow progressType:ProgressTypeNum progress:nil finished:finished];
}

+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow progressType:(ProgressType)progressType  finished:(REQUEST_FINISH)finished{
    return [self requestWithPrameters:request withFiles:nil isShowProgress:isShow progressType:progressType progress:nil finished:finished];
}

+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow  progress:(REQUEST_PROGRESS)progress  finished:(REQUEST_FINISH)finished{
    return [self requestWithPrameters:request withFiles:nil isShowProgress:isShow progressType:ProgressTypeNum progress:progress finished:finished];
}

+ (NSURLSessionDataTask *)requestWithPrameters:(id)request  withFiles:(NSArray *)files isShowProgress:(BOOL)isShow progressType:(ProgressType)progressType   progress:(REQUEST_PROGRESS)progress finished:(REQUEST_FINISH)finished{
    //是否弹出指示器
    if (isShow) {
        if (progressType == ProgressTypeLoading) {
            [SVProgressHUD showWithStatus:@"Loading"];
        } else {
            [SVProgressHUD showProgress:0.0f status:@"0%"];
        }
        
    }
    
    NSURLSessionDataTask *task;
    
    NSString *kIP = K_IP;
    NSString *kServiceAddress = K_SERVICE_ADDRESS;
    
    //定义HttpManager
    AFHTTPSessionManagerSub *manager = [[AFHTTPSessionManagerSub alloc] initWithBaseURL:[NSURL URLWithString: kIP]];
    
    //timeout设置
    [manager.requestSerializer setTimeoutInterval:Request_TimeoutInterval];
    /* 请求格式
     AFHTTPRequestSerializer            二进制格式
     AFJSONRequestSerializer            JSON
     AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
     */
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //header 设置
    [manager.requestSerializer setValue:kIP forHTTPHeaderField:@"Host"];
    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setValue:@"application/json,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    //    [manager.requestSerializer setValue:@"application/json,text/html,text/json,text/javascript; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    // 设置返回格
    /*
     AFHTTPResponseSerializer           二进制格式
     AFJSONResponseSerializer           JSON
     AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
     AFXMLDocumentResponseSerializer (Mac OS X)
     AFPropertyListResponseSerializer   PList
     AFImageResponseSerializer          Image
     AFCompoundResponseSerializer       组合
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    //    if (![self validateNetwork:manager]) {//校验网络
    //        return manager;
    //    };
    
    BaseResponse *baseResponse = [[BaseResponse alloc] init];
    
    NSString *requestMethod;//默认POST
    NSString *serviceURL;//接口地址
    NSMutableDictionary *requestParameters;//参数
    if ([request isKindOfClass:[NSDictionary class]]) {//如果是字典对象
        requestParameters = [NSMutableDictionary dictionaryWithDictionary:request];
        NSString *requestURL = requestParameters[K_Text_Http_URL];
        serviceURL = [NSString stringWithFormat:@"%@/%@",kServiceAddress,requestURL];
        requestMethod = IsNilString(requestParameters[K_Text_Http_RequestMethod])?REQUEST_POST:requestParameters[K_Text_Http_RequestMethod];
        
        [self initHeaderParameter:requestParameters[K_Text_Http_Header] toManager:manager];
        
        [requestParameters removeObjectForKey:K_Text_Http_URL];
        [requestParameters removeObjectForKey:K_Text_Http_RequestMethod];
        [requestParameters removeObjectForKey:K_Text_Http_Header];
    } else if([request isKindOfClass:[BaseRequest class]]){
        //        requestParameters = [NSMutableDictionary dictionaryWithDictionary:[request dictionaryFromAttributes]];
        requestParameters = [NSMutableDictionary dictionaryWithDictionary:[[request JSONString] mj_JSONObject]];
        NSString *requestURL = requestParameters[K_Text_Http_URL];
        serviceURL = [NSString stringWithFormat:@"%@%@",kServiceAddress,requestURL];
        requestMethod = IsNilString(requestParameters[K_Text_Http_RequestMethod])?REQUEST_POST:requestParameters[K_Text_Http_RequestMethod];
        
        [self initHeaderParameter:requestParameters[K_Text_Http_Header] toManager:manager];
        
        [requestParameters removeObjectForKey:K_Text_Http_URL];
        [requestParameters removeObjectForKey:K_Text_Http_RequestMethod];
        [requestParameters removeObjectForKey:K_Text_Http_Header];
    } else {
        baseResponse.status = NO;
        baseResponse.error = K_Text_Http_ParameterError;
        finished(baseResponse);
        return task;
    }
    
    
    
    
    if (files) {
        
        //        serviceURL = @"http://192.168.52.116:8080/Cumt/person/upload";
        task = [manager POST:serviceURL
                  parameters:requestParameters
   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
       
       for (id file in files) {
           if ([file isKindOfClass:[NSData class]]) {
               [formData appendPartWithFileData:file
                                           name:@"file"
                                       fileName:@"file.png"
                                       mimeType:@"image/jpeg"];
               
           } else if([file isKindOfClass:[NSString class]]){
               [formData appendPartWithFileURL:[NSURL URLWithString:file] name:@"file" fileName:@"file" mimeType:@"image/jpeg" error:nil];
           } else if([file isKindOfClass:[NSURL class]]){
               [formData appendPartWithFileURL:file name:@"file" fileName:@"file" mimeType:@"image/jpeg" error:nil];
           } else if([file isKindOfClass:[ALAsset class]]){
               ALAssetRepresentation *rep = [file defaultRepresentation];
               Byte *buffer = (Byte*)malloc(rep.size);
               NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
               NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
               [formData appendPartWithFileData:data
                                           name:@"file"
                                       fileName:@"file.png"
                                       mimeType:@"image/jpeg"];
           }
           
       }
       
       
   } progress:^(NSProgress * _Nonnull uploadProgress) {
       if (progressType != ProgressTypeLoading) {
           [self publishProgress:uploadProgress isShow:isShow];
       }
       
       if (progress) {
           progress(uploadProgress);
       }
   }  success:^(NSURLSessionDataTask *operation, id responseObject) {
       [self initResponse:baseResponse operation:operation responseObject:responseObject];
       finished(baseResponse);
   } failure:^(NSURLSessionDataTask *operation, NSError *error) {
       [self initResponse:baseResponse operation:operation error:error];
       finished(baseResponse);
   }];
    } else {
        task = [manager requestWithURL:serviceURL HTTPMethod:requestMethod files:files parameters:requestParameters progress:^(NSProgress *uploadProgress) {
            if (progressType != ProgressTypeLoading) {
                [self publishProgress:uploadProgress isShow:isShow];
            }
            if (progress) {
                progress(uploadProgress);
            }
            
        }  success:^(NSURLSessionDataTask *operation, id responseObject) {
            [self initResponse:baseResponse operation:operation responseObject:responseObject];
            finished(baseResponse);
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [self initResponse:baseResponse operation:operation error:error];
            finished(baseResponse);
        }];
    }
    
    return task;
    
}

+ (void)publishProgress:(NSProgress *)uploadProgress isShow:(BOOL)isShow{
    
    if (isShow) {
        float currentProgress = 1.0f * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSString *status = [NSString stringWithFormat:@"%ld%%",(long)(currentProgress*100)];
        
        CGFloat progressNum = 1.0f * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        [SVProgressHUD showProgress: progressNum status:status];
        
        //if (progressNum == 1.0f) {
        //    [SVProgressHUD dismiss];
        //}
    }
    
}


+ (void)initHeaderParameter:(NSDictionary *)headerDict toManager:(AFHTTPSessionManager *)manager{
    
    NSArray *keys = headerDict.allKeys;
    
    if (keys) {
        for (int i=0; i<keys.count; i++) {
            [manager.requestSerializer setValue:headerDict.allValues[i] forHTTPHeaderField:keys[i]];
        }
    }
    
    
    //[manager.requestSerializer setValue:[DataManager getInstance].token forHTTPHeaderField:@"Cookie"];
    
    /*
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:k_key_token];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
     */
}



+ (void)initResponse:(BaseResponse *)baseResponse operation:(NSURLSessionDataTask *)operation responseObject:(id)responseObject{
    //默认
    baseResponse.status = YES;
    baseResponse.result = responseObject;
    baseResponse.responseObject = responseObject;//原始数据
    
    //实际，返回的数据结构需要进行规范，例如{"status" : "0", // 0成功，1失败。"result" : {},"message" : ""}
    //故也要再次判断成功失败的情况
    id statusResult = responseObject[K_Text_Http_Status];
    
    BOOL status;
    if ([statusResult isKindOfClass:[NSNumber class]]) {
        status = ![statusResult boolValue];
    } else {
        status = [statusResult isEqual:K_Text_Http_SuccessMark];
    }
    
    baseResponse.status = status;
    if (status) {
        baseResponse.result = responseObject[K_Text_Http_Result];
    } else {
        baseResponse.error = responseObject[K_Text_Http_ErrorMsg];
    }
    
    //初始化 token
    /*
     NSDictionary *mDict = [operation.response dictionaryFromAttributes];
     if (mDict) {
     NSDictionary *headerDict = [mDict objectForKey:@"allHeaderFields"];
     NSString *cookie = headerDict?[headerDict objectForKey:@"Set-Cookie"] : nil;
     if (cookie && [cookie containsString:@".METROPMR"]) {
     NSArray *items = [cookie componentsSeparatedByString:@";"];
     for (int i=0; i<items.count; i++) {
     NSString *item = items[i];
     if ([item containsString:@".METROPMR"]) {
     cookie = item;
     }
     }
     } else {
     cookie = nil;
     }
     [DataManager getInstance].token = cookie;
     [[DataManager getInstance] saveData:cookie toKey:k_key_token];
     }
     */
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",K_IP]]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:k_key_token];
}

+ (void)initResponse:(BaseResponse *)baseResponse operation:(NSURLSessionDataTask *)operation error:(NSError *)error{
    
    baseResponse.status = NO;
    baseResponse.error =  error ? error.localizedDescription : K_Text_Http_RquestException;
    
    if ([error code] == NSURLErrorNotConnectedToInternet) {
        baseResponse.error = K_Text_Http_NoNetwork;
    }
}


+ (BOOL)validateNetwork:(AFHTTPSessionManagerSub *)manager {
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    return true;
}


+ (NSURLSessionDownloadTask * _Nullable)downloadRequestWithParameters:(id _Nullable)request isShowProgress:(BOOL)isShow  progress:(REQUEST_PROGRESS)progress finished:(REQUEST_DOWNLOAD_FINISH)finished{
    //是否弹出指示器
    if (isShow) {
        [SVProgressHUD showProgress:0.0f status:@"0%"];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //timeout设置
    [manager.requestSerializer setTimeoutInterval:Request_TimeoutInterval];
    /* 请求格式
     AFHTTPRequestSerializer            二进制格式
     AFJSONRequestSerializer            JSON
     AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
     */
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //header 设置
    [manager.requestSerializer setValue:K_IP forHTTPHeaderField:@"Host"];
    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    [manager.requestSerializer setValue:@"application/json,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    //    [manager.requestSerializer setValue:@"application/json,text/html,text/json,text/javascript; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    // 设置返回格
    /*
     AFHTTPResponseSerializer           二进制格式
     AFJSONResponseSerializer           JSON
     AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
     AFXMLDocumentResponseSerializer (Mac OS X)
     AFPropertyListResponseSerializer   PList
     AFImageResponseSerializer          Image
     AFCompoundResponseSerializer       组合
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    //    if (![self validateNetwork:manager]) {//校验网络
    //        return manager;
    //    };
    
    
    NSURLSessionDownloadTask *task;
    
    BaseResponse *baseResponse = [[BaseResponse alloc] init];
    
    NSString *requestMethod;//默认POST
    NSString *serviceURL;//接口地址
    NSMutableDictionary *requestParameters;//参数
    if ([request isKindOfClass:[NSDictionary class]]) {//如果是字典对象
        requestParameters = [NSMutableDictionary dictionaryWithDictionary:request];
        NSString *requestURL = requestParameters[K_Text_Http_URL];
        serviceURL = [NSString stringWithFormat:@"%@/%@",K_SERVICE_ADDRESS,requestURL];
        requestMethod = IsNilString(requestParameters[K_Text_Http_RequestMethod])?REQUEST_POST:requestParameters[K_Text_Http_RequestMethod];
        
        [self initHeaderParameter:requestParameters[K_Text_Http_Header] toManager:manager];
        
        [requestParameters removeObjectForKey:K_Text_Http_URL];
        [requestParameters removeObjectForKey:K_Text_Http_RequestMethod];
        [requestParameters removeObjectForKey:K_Text_Http_Header];
    } else if([request isKindOfClass:[BaseRequest class]]){
        //        requestParameters = [NSMutableDictionary dictionaryWithDictionary:[request dictionaryFromAttributes]];
        requestParameters = [NSMutableDictionary dictionaryWithDictionary:[[request JSONString] mj_JSONObject]];
        NSString *requestURL = requestParameters[K_Text_Http_URL];
        serviceURL = [NSString stringWithFormat:@"%@%@",K_SERVICE_ADDRESS,requestURL];
        requestMethod = IsNilString(requestParameters[K_Text_Http_RequestMethod])?REQUEST_POST:requestParameters[K_Text_Http_RequestMethod];
        
        [self initHeaderParameter:requestParameters[K_Text_Http_Header] toManager:manager];
        
        [requestParameters removeObjectForKey:K_Text_Http_URL];
        [requestParameters removeObjectForKey:K_Text_Http_RequestMethod];
        [requestParameters removeObjectForKey:K_Text_Http_Header];
    }
    
    
    NSURL *url = [NSURL URLWithString:serviceURL];
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:url];
    
    // 下载任务
    task = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        [self publishProgress:downloadProgress isShow:isShow];
        progress(downloadProgress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
        NSArray *paths = [serviceURL componentsSeparatedByString:@"."];
        //根据文件后缀名获取路径
        NSString *filePath = [FileHelper getFilePathByFileSuffixInDocumentDirectory:paths.lastObject];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        finished(response,filePath,error);
    }];
    
    // 开始启动任务
    [task resume];
    
    return task;
}







@end
