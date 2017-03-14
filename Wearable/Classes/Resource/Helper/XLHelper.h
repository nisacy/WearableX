//
//  XLHelper.h
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/23.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLHelper : NSObject

//根据传递的数据，进行格式化，如果是19.00则转为19，19.10则转为19.1，19.12则为19.12
+ (NSString *)formatDataByStr:(NSString *)data;
+ (NSString *)formatDataByFloat:(float)data;

//数字转中文繁体大写
+ (NSString *)converterNumToCapital:(NSInteger)number;
//数字转中文简体大写
+ (NSString *)converterNumToSimpleCapital:(NSInteger)number;

//获取 GUID
+ (NSString *)getUniqueStrByUUID;

//根据当前 UIView 获取所在的controller
+ (UIViewController *)findViewController:(UIView *)sourceView;

@end
