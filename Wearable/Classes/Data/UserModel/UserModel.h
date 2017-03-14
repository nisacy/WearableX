//
//  UserModel.h
//  Hospital
//
//  Created by ShinSoft on 14-3-12.
//  Copyright (c) 2014年 Shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//**************用户基本信息************start*****************
@interface UserModel : NSObject

@property (nonatomic, strong) NSString *id;//会员ID
@property (nonatomic, strong) NSString *mobile;//会员手机号码
@property (nonatomic, strong) NSString *sex;//会员性别 F:女性 M:男性

@property (nonatomic, strong) NSString *currency;//会员当前货币符号 默认为“¥”
@property (nonatomic, strong) NSString *cur;//会员当前货币代码 默认为“CNY”
@property (nonatomic, strong) NSString *name;//用户姓名
@property (nonatomic, strong) NSString *uname;//用户会员帐号
@property (nonatomic, strong) NSString *password;//用户会员密码
@property (nonatomic, strong) NSString *email;//用户邮箱地址

@property (nonatomic, strong) NSString *levelID;//会员等级ID
@property (nonatomic, strong) NSString *levelName;//会员等级名称
@property (nonatomic, assign) int quantityOfOrder;//我的订单数量
@property (nonatomic, assign) int quantityOfMessage;//我的消息数量
@property (nonatomic, assign) int quantityOfCartItems;//我的购物车内数量

@property (nonatomic, strong) NSString *advance;//会员预存款
@property (nonatomic, assign) int experience;//用户经验值 默认为0
@property (nonatomic, assign) int point;//用户积点分 默认为0
@property (nonatomic, assign) int beShipped;//待发货
@property (nonatomic, assign) int paddingReceipt;//已发货
@property (nonatomic, assign) int paddingPayment;//代付款
@property (nonatomic, assign) int quantityCoupon;//优惠券数量

@property (nonatomic, assign) int num;//商品收藏数量

@property (nonatomic, strong) NSString *headPic;

@property (nonatomic, strong) NSString *logoUrl;

+ (UserModel *)getInstance;

+ (NSDictionary *)dictionary:(id)obj;
+ (UserModel *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end


