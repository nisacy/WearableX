//
//  HttpHelper.h
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/17.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManagerSub.h"


typedef enum : NSUInteger {
    ProgressTypeLoading,//加载进度指示器
    ProgressTypeNum//百分比
} ProgressType;

@interface HttpHelper : NSObject

/**
 *  网络请求，普通的网络请求，没有进度条回调
 *
 *  @param request  请求参数
 *  @param isShow   是否显示指示器
 *  @param finished 完成回调
 *
 *  @return 返回NSURLSessionDataTask对象，可用于请求的管理
 */
+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow  finished:(REQUEST_FINISH)finished;

+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow progressType:(ProgressType)progressType  finished:(REQUEST_FINISH)finished;

/**
 *  网络请求，普通的网络请求，有进度条回调
 *
 *  @param request  请求参数
 *  @param isShow   是否显示指示器
 *  @param progress 进度回调
 *  @param finished 完成回调
 *
 *  @return 返回NSURLSessionDataTask对象，可用于请求的管理
 */
+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request isShowProgress:(BOOL)isShow  progress:(REQUEST_PROGRESS)progress  finished:(REQUEST_FINISH)finished;

/**
 *  网络请求
 *
 *  @param request  请求数据的对象
 字典或者NSObject
 NSObject:
 BaseRequest：基类，必须包含下面两个属性（字典也必须包含）
 requestMethod:GET/POST/PUT/DELETE，为空时默认POST
 url:网络请求地址，可以是全地址或者部分地址，可以在方法体中进行组合绝对地址
 
 *  @param files    上传文件数组：文件绝对路径的字符数组/NSData数组/
 *  @param finished 返回结果：BaseResponse
         status： YES：成功，NO：失败
         result： 成功结果
         error： 错误信息
 responseObject：返回的原始数据
 */
//- (void)requestWithPrameters:(id)request  withFiles:(NSArray *)files finished:(void(^)(BOOL status, id result, id errMsg))finished;

//+ ( NSURLSessionDataTask * _Nullable )requestWithPrameters:(id _Nullable)request  withFiles:(NSArray * _Nullable)files  isShowProgress:(BOOL)isShow  progress:(REQUEST_PROGRESS)progress  finished:(REQUEST_FINISH)finished;




+ (NSURLSessionDownloadTask * _Nullable)downloadRequestWithParameters:(id _Nullable)request isShowProgress:(BOOL)isShow  progress:(REQUEST_PROGRESS)progress finished:(REQUEST_DOWNLOAD_FINISH)finished;




@end
