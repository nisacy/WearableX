//
//  BaseRequestModel.h
//  IOS FrameWork
//
//  Created by Chino Hu on 13-12-9.
//  Copyright (c) 2013年 Shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject
@property (nonatomic, strong) NSDictionary *header;
@property (nonatomic, copy) NSString *requestMethod;// GET/POST/PUT/DELETE
@property (nonatomic, copy) NSString *url;//请求短连接
@property (nonatomic, copy) NSString *sign;//签名
@property (nonatomic, copy) NSString *session;//用户会话标识

@property (nonatomic, assign) BOOL pageEnabled;//是否开启分页
@property (nonatomic, assign) NSInteger pageIndex;//页码 默认第一页 1
@property (nonatomic, assign) NSInteger pageSize;//每页条数 默认7

@end

@interface BaseResponse : NSObject
@property (nonatomic, assign) BOOL status;//存放状态信息
@property (nonatomic, assign) id result;//返回的结果
@property (nonatomic, copy) NSString *error;//是AFNetworking返回给我们的错误信息(error.localizedDescription 错误信息)
@property (nonatomic, strong) id responseObject;// 是页面返回来的原始信息

@end