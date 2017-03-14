//
//  FieldMapping.h
//  Hospital
//
//  Created by Chino Hu on 13-12-16.
//  Copyright (c) 2013年 Shinsoft. All rights reserved.
//

#ifndef XL_FieldMapping_h
#define XL_FieldMapping_h

/**
 *  定义字符串常量
    命名规则为：
    K_Text_模块名_子模块名_实际字段名
    字段命名采用驼峰表示(首字母大写)
 */

//网络相关参数
#define K_Text_Http_URL                                         @"url"//网络相对地址
#define K_Text_Http_RequestMethod                               @"requestMethod"//请求方法 POST/GET...
#define K_Text_Http_Header                                      @"header" // 头信息
#define K_Text_Http_ParameterError                              @"传递的参数格式不正确"//传递的参数格式错误
#define K_Text_Http_RquestException                             @"请求异常"//请求结果异常
#define K_Text_Http_NoNetwork                                   @"网络未连接"

#define K_Text_Http_Status                                      @"Status"//网络请求状态，根据返回的结果调整
#define K_Text_Http_Result                                      @"Data"//网络请求状态，根据返回的结果调整
#define K_Text_Http_ErrorMsg                                    @"Error"//网络请求状态，根据返回的结果调整
#define K_Text_Http_SuccessMark                                 0//请求成功标志，也是根据返回的结果调整


//全局
#define KText_AlertView_Title                                    @"温馨提示"
#define KText_AlertView_Cancel                                   @"取消"
#define KText_AlertView_Confirm                                  @"确认"


#define K_Text_Key_Left_Menu                                    @"Left_Menu"

#define K_Text_Key_Left_Menu_Change                             @"Left_Menu_Change"

#endif
