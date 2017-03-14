//
//  DataHelper.h
//  Wearable
//
//  Created by Shinsoft on 17/2/13.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (DataHelper *)getInstance;


- (CGFloat)readTempValueFromHexStr:(NSString *)hexStr;
- (CGFloat)readTempValueFromByte:(NSData *)data;

- (NSMutableArray *)readAcceleroValueFromHexStr:(NSString *)hexStr;
- (NSMutableArray *)readAcceleroValueFromByte:(NSData *)data;

@end
