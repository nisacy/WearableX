//
//  UserModel.m
//  Hospital
//
//  Created by ShinSoft on 14-3-12.
//  Copyright (c) 2014年 Shinsoft. All rights reserved.
//

#import "UserModel.h"
#import "DataManager.h"
#import <objc/runtime.h>
#define PRINT_OBJ_LOGGING 1


//**************用户登陆************start*****************
@implementation UserModel

static UserModel *userModel;

+ (UserModel *)getInstance
{
    @synchronized(self){
        if (userModel == nil) {
            userModel = [[DataManager getInstance] dataModelOfKey:k_key_UserModel];
            if (userModel == nil) {
                userModel = [[UserModel alloc] init];
            }
        }
        return userModel;
    }
}

-(id)initWithCoder: (NSCoder*)coder
{
    if(self= [super init])
    {
        self.id = [coder decodeObjectForKey:@"id"];//会员ID
        self.mobile = [coder decodeObjectForKey:@"mobile"];//会员手机号码
        self.sex = [coder decodeObjectForKey:@"sex"];//会员性别 F:女性 M:男性
        self.experience = [[coder decodeObjectForKey:@"experience"] intValue];//用户经验值 默认为0
        self.point = [[coder decodeObjectForKey:@"point"] intValue];//用户积点分 默认为0
        self.currency = [coder decodeObjectForKey:@"currency"];//会员当前货币符号 默认为“¥”
        self.cur = [coder decodeObjectForKey:@"cur"];//会员当前货币代码 默认为“CNY”
        self.name = [coder decodeObjectForKey:@"name"];//用户姓名
        self.uname = [coder decodeObjectForKey:@"uname"];//用户会员帐号
        self.password = [coder decodeObjectForKey:@"password"];//用户会员密码
        self.email = [coder decodeObjectForKey:@"email"];//用户邮箱地址
        self.advance = [coder decodeObjectForKey:@"advance"];//会员预存款
        self.levelID = [coder decodeObjectForKey:@"levelID"];//会员等级ID
        self.levelName = [coder decodeObjectForKey:@"levelName"];//会员等级名称
        self.quantityOfOrder = [[coder decodeObjectForKey:@"quantityOfOrder"] intValue];//我的订单数量
        self.quantityOfMessage = [[coder decodeObjectForKey:@"quantityOfMessage"] intValue];//我的消息数量
        self.quantityOfCartItems = [[coder decodeObjectForKey:@"quantityOfCartItems"] intValue];//我的购物车内数量
        
        
        
        self.advance = [coder decodeObjectForKey:@"advance"];//会员预存款
        self.experience = [[coder decodeObjectForKey:@"experience"] intValue];//用户经验值 默认为0
        self.point = [[coder decodeObjectForKey:@"point"] intValue];//用户积点分 默认为0
        self.beShipped = [[coder decodeObjectForKey:@"beShipped"] intValue];//待发货
        self.paddingReceipt = [[coder decodeObjectForKey:@"paddingReceipt"] intValue];//已发货
        self.paddingPayment = [[coder decodeObjectForKey:@"paddingPayment"] intValue];//代付款
        self.quantityCoupon = [[coder decodeObjectForKey:@"quantityCoupon"] intValue];////优惠券数量
        self.headPic = [coder decodeObjectForKey:@"headPic"];//会员预存款
        
        
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.id?self.id:@"" forKey:@"id"];
    [coder encodeObject:self.mobile?self.mobile:@"" forKey:@"mobile"];
    [coder encodeObject:self.sex?self.sex:@"" forKey:@"sex"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.experience] forKey:@"experience"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.point] forKey:@"point"];
    [coder encodeObject:self.currency?self.currency:@"" forKey:@"currency"];
    [coder encodeObject:self.cur?self.cur:@"" forKey:@"cur"];
    [coder encodeObject:self.name?self.name:@"" forKey:@"name"];
    [coder encodeObject:self.uname?self.uname:@"" forKey:@"uname"];
    [coder encodeObject:self.password?self.password:@"" forKey:@"password"];
    [coder encodeObject:self.email?self.email:@"" forKey:@"email"];
    [coder encodeObject:self.advance?self.advance:@"" forKey:@"advance"];
    [coder encodeObject:self.levelID?self.levelID:@"" forKey:@"levelID"];
    [coder encodeObject:self.levelName?self.levelName:@"" forKey:@"levelName"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.quantityOfOrder] forKey:@"quantityOfOrder"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.quantityOfMessage] forKey:@"quantityOfMessage"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.quantityOfCartItems] forKey:@"quantityOfCartItems"];
    
    
    [coder encodeObject:self.advance?self.advance:@"" forKey:@"advance"];
    
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.experience] forKey:@"experience"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.point] forKey:@"point"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.beShipped] forKey:@"beShipped"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.paddingReceipt] forKey:@"paddingReceipt"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.paddingPayment] forKey:@"paddingPayment"];
    [coder encodeObject:[NSString stringWithFormat:@"%d",self.quantityCoupon] forKey:@"quantityCoupon"];
    
    [coder encodeObject:self.headPic?self.headPic:@"" forKey:@"headPic"];
}



+ (NSDictionary *)dictionary:(id)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        id value = nil;
        
        @try {
            NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
            value = [self getObjectInternal:[obj valueForKey:propName]];
            if(value != nil) {
                [dic setObject:value forKey:propName];
            }
        }
        @catch (NSException *exception) {
            [self logError:exception];
        }
        
    }
    return dic;
}


+ (id)getObjectInternal:(id)obj
{
    if(!obj
       || [obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self dictionary:obj];
}

+ (void)logError:(NSException*)exp
{
    #if PRINT_OBJ_LOGGING
    DLog(@"PrintObject Error: %@", exp);
    #endif
}


+ (UserModel *)instanceFromDictionary:(NSDictionary *)aDictionary {
    UserModel *instance = [[UserModel alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self setValuesForKeysWithDictionary:aDictionary];
}

@end



