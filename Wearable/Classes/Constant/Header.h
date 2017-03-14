//
//  Header.h
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/19.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#ifndef Header_h
#define Header_h


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//********系统常量类*************
#import "ColorMapping.h"//颜色定义
#import "Constants.h"   //APP 常量
#import "FieldMapping.h"  //字符串定义
#import "ImageNameMapping.h" //图片定义
#import "RequestDefine.h" //网络请求相关定义
#import "SystemDefine.h"  //系统参数定义
#import "UtilsDefine.h"   //相关方法类定义
#import "XLSingleton.h"   //单例定义
#import "GattAttributes.h"
#import "DataHelper.h"


//************类扩展***********************
#import "UIView+KGViewExtend.h" //获取 UIView 的宽、高等基本坐标参数
#import "UIScrollView+MJRefreshEx.h"//再封装请求
#import "XLRefreshHeader.h"//自定义下拉刷新动画
#import "UIImageView+Ex.h"//再封装SDWimageview

#import "UINavigationBar_TNDropShadow.h"

//***********相关帮助类********************
#import "DateHelper.h"
#import "HttpHelper.h"
#import "XLHelper.h"
#import "ViewHelper.h"
#import "ValidateHelper.h"
#import "FileHelper.h"
#import "CommonMethod.h"

//************Model类*********************
#import "UserModel.h"  // 用户信息
#import "BaseRequest.h" //网络请求基类
#import "DataManager.h" //用于管理全局数据

//**********引用库**********************
#import "AFNetworking.h"//网络请求
#import "JSONKit.h"//dictionary 与 json 字符串间转换
#import "UIImageView+Ex.h"//扩展 SDWImageView
#import "SVProgressHUD.h"//加载指示器
#import "MJRefresh.h" //下拉刷新、上拉加载更多
#import "MJExtension.h" //json 与 model 转换
#import "Masonry.h"//代码约束布局
#import "UITableView+FDTemplateLayoutCell.h"//自动计算Cell行高
//#import "REFrostedViewController.h"
#import "UIScrollView+EmptyDataSet.h"//请求数据处理
#import "UIFloatLabelTextField.h"//文本
#import "SAMKeychain.h"//保存关键信息
#import "UIScrollView+EmptyDataSet.h"//表单为空或者请求失败占位视图

#import "UMMobClick/MobClick.h"//友盟统计

#import "NJKWebViewProgress.h"//网页进度条

#endif /* Header_h */
