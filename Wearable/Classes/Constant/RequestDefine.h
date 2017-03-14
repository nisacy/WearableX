//
//  RequestDefine.h
//  Hospital
//
//  Created by ShinSoft on 14-3-10.
//  Copyright (c) 2014年 Shinsoft. All rights reserved.
//

#ifndef XL_RequestDefine_h
#define XL_RequestDefine_h

/**
 *  定义网络请求相关常量
 命名规则为：Request_Method_方法名
 字段命名采用驼峰表示(首字母大写)
 */


//***************网络请求*************************************
#define Request_TimeoutInterval  60.0f //请求超时

//***************相关参数*************************************
#define REQUEST_FINISH void (^ _Nullable)(BaseResponse * _Nullable response)
//typedef void (^ _Nullable Progress)(NSProgress * _Nullable progress);
#define REQUEST_PROGRESS void (^ _Nullable)(NSProgress * _Nullable progress)// 上传或者下载进度Block
#define REQUEST_DOWNLOAD_FINISH void (^ _Nullable)(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)
#define isTest  YES
#define REQUEST_GET     @"GET"
#define REQUEST_POST    @"POST"
#define REQUEST_PUT     @"PUT"
#define REQUEST_DELETE  @"DELETE"
#define REQUEST_TOKEN   @"7a60e9b5f9fa5cce122b78d9d6640d60"

#define k_page_size 20//每次获取数据

#define isTestHJ  0 //1:测试环境  0：正式环境

#if isTestHJ

#define K_IP                    @"www.shjlpm.net" //测试环境
#define K_SERVICE_ADDRESS       [NSString stringWithFormat:@"http://%@%@",K_IP,@"/api/app/"]//
#else

#define K_IP                    @"www.shjlpm.net"//正式环境
#define K_SERVICE_ADDRESS       [NSString stringWithFormat:@"http://%@%@",K_IP,@"/api/app/"]//
#endif

//****************请求地址*******************************************

#define Request_Method_Login                       @"cup"


#endif
