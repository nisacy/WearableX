//
//  DataManager.h
//  FrameWork-1.0
//
//  Created by shinsoft  on 15-3-27.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <sqlite3.h>
#import "DBHelper.h"


@class REFrostedViewController;
@class ProductCompareMangerController;

#define k_key_UserModel                 @"UserModel"
#define k_key_IsLogin                   @"IsLogin"
#define k_go_login                      @"GO_LOGIN"
#define k_auto_login                    @"Auto_Login"//
#define k_key_token                     @"TOKEN"//
#define k_go_compare                    @"GO_Compare"
#define k_is_tip_update                 @"Tip_Update"//是否已经提示更新

#define k_compare_product               @"Compare_Product"//对比的产品列表

@interface DataManager : NSObject
{
    sqlite3 *db;
}

@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isReLogin;//是否重新登录，重新登录需要初始化首页数据
@property (nonatomic, assign) BOOL isShowNavBg;
@property (nonatomic, strong) UserModel *userModel;;


@property (nonatomic, assign) BOOL isLandscape;

@property (nonatomic, strong) NSString *token;


+ (DataManager *)getInstance;

- (NSString *)filePath:(NSString *)name;
- (NSString *)sandBoxFilePath:(NSString *)fileName;
- (void)saveData:(id)data toKey:(NSString *)key;
- (id)dataOfKey:(NSString *)key;
- (id)dataModelOfKey:(NSString *)key;
- (NSString *)uniqueId;



@end
