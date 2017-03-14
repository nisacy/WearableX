//
//  DataManager.m
//  FrameWork-1.0
//
//  Created by qinhu  on 13-3-27.
//  Copyright (c) 2013年 shinsoft . All rights reserved.
//

#import "DataManager.h"
#import "NSObject+AutoDescription.h"

#define kUserInfo   @"UserInfo"

@implementation DataManager

static DataManager *dataManager;

+ (DataManager *)getInstance
{
    @synchronized(self){
        if (dataManager == nil) {
            dataManager = [[DataManager alloc] init];
        }
        return dataManager;
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        UserModel *info = [self dataModelOfKey:k_key_UserModel];
        if (info == nil) {
            info = [[UserModel alloc] init];
        }
        self.userModel = info;
        
        self.token = [self dataOfKey:k_key_token];
        
    }
    return self;
}

//- (void)setScreeningInfos:(NSMutableArray *)screeningInfos{
//    self.screeningInfos = screeningInfos;
//}

- (NSString *)filePath:(NSString *)name
{
    return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}

- (NSString *)sandBoxFilePath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)saveData:(id)data toKey:(NSString *)key
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary
    if ([data isKindOfClass:[NSData class]] || [data isKindOfClass:[NSString class]] ||[data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSDate class]] ||[data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {//基本数据类型
        [defaults setObject:data forKey:key];
    } else {
//        [defaults setObject:data forKey:key];
        NSData *defaultData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [defaults setObject:defaultData forKey:key];
    }
    [defaults synchronize];
}

- (id)dataOfKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (id)dataModelOfKey:(NSString *)key{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if ([data length]<=0) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (NSString *)uniqueId
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    return uuidString;
}



- (BOOL)isLogin{
    BOOL isLogin = NO;
    NSString *isLog = [self dataOfKey:k_key_IsLogin];
    if ([isLog isEqualToString:@"1"]) {
        isLogin = YES;
    }
    return isLogin;
}

- (NSString *)token{
    _token = [self dataOfKey:k_key_token];
    return _token;
}


@end
