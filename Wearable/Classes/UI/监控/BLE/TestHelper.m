//
//  TestHelper.m
//  Wearable
//
//  Created by Shinsoft on 17/2/22.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "TestHelper.h"

@interface TestHelper ()

@end

@implementation TestHelper

+ (void)test{
    
    NSString *hexStr = @"c00280fd40fe";
    NSString *xHexStr = [NSString stringWithFormat:@"%@%@",[hexStr substringWithRange:NSMakeRange(2, 2)],[hexStr substringWithRange:NSMakeRange(0, 2)]];
    NSString *yHexStr = [NSString stringWithFormat:@"%@%@",[hexStr substringWithRange:NSMakeRange(6, 2)],[hexStr substringWithRange:NSMakeRange(4, 2)]];
    NSString *zHexStr = [NSString stringWithFormat:@"%@%@",[hexStr substringWithRange:NSMakeRange(10, 2)],[hexStr substringWithRange:NSMakeRange(8, 2)]];
    
    NSString *xBinaryStr = [self getBinaryByhex:xHexStr];
    NSString *yBinaryStr = [self getBinaryByhex:yHexStr];
    NSString *zBinaryStr = [self getBinaryByhex:zHexStr];
    
    NSString *xDecimalStr;
    if ([xBinaryStr hasPrefix:@"0"]) {
        xDecimalStr = [self toDecimalSystemWithBinarySystem:xBinaryStr];
    } else {
        xDecimalStr = [self toNegativeDecimalSystemWithBinarySystem:xBinaryStr];
    }
    
    NSString *yDecimalStr;
    if ([yBinaryStr hasPrefix:@"0"]) {
        yDecimalStr = [self toDecimalSystemWithBinarySystem:yBinaryStr];
    } else {
        yDecimalStr = [self toNegativeDecimalSystemWithBinarySystem:yBinaryStr];
    }
    
    NSString *zDecimalStr;
    if ([zBinaryStr hasPrefix:@"0"]) {
        zDecimalStr = [self toDecimalSystemWithBinarySystem:zBinaryStr];
    } else {
        zDecimalStr = [self toNegativeDecimalSystemWithBinarySystem:zBinaryStr];
    }
    
    
    NSMutableData *xData = [self convertHexStrToData:xHexStr];
    NSMutableData *yData = [self convertHexStrToData:yHexStr];
    NSMutableData *zData = [self convertHexStrToData:zHexStr];
    
    Byte *xByte = (Byte *)[xData bytes];
    Byte *yByte = (Byte *)[yData bytes];
    Byte *zByte = (Byte *)[zData bytes];
    
    for(int i=0;i<[xData length];i++){
        DLog(@"%hhu",xByte[i]);
    }
    
}

+ (NSString *)toNegativeDecimalSystemWithBinarySystem:(NSString *)binary{
    //取反
    binary = [binary stringByReplacingOccurrencesOfString:@"0" withString:@"x"];
    binary = [binary stringByReplacingOccurrencesOfString:@"1" withString:@"0"];
    binary = [binary stringByReplacingOccurrencesOfString:@"x" withString:@"1"];
    
    //低位加1
    binary = [self addNumResult:binary];
    //二进制转十进制
    NSString *xDecimalStr = [self toDecimalSystemWithBinarySystem:binary];
    
    return [NSString stringWithFormat:@"-%@",xDecimalStr];
}

+ (NSString *)addNumResult:(NSString *)binary{
    
    DLog(@"%@",binary);
    
    binary = [self replaceBinary:binary withIndex:1];
    
    DLog(@"%@",binary);
    
    return binary;
}

int ii = 1;
+ (NSString *)replaceBinary:(NSString *)binary withIndex:(NSInteger)index{
    NSInteger length = binary.length;
    NSString *lastItem = [binary substringWithRange:NSMakeRange(length-index, 1)];
    if ([lastItem isEqualToString:@"0"]) {
        lastItem = @"1";
        binary = [binary stringByReplacingCharactersInRange:NSMakeRange(length-index, 1) withString:lastItem];
        
        return binary;
    } else {
        lastItem = @"0";
        binary = [binary stringByReplacingCharactersInRange:NSMakeRange(length-index, 1) withString:lastItem];
         ii++;
        if ( ii<=binary.length) {
            return [self replaceBinary:binary withIndex: ii];
        }
        return binary;
    }
    
    
}


//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}

//十六进制转二进制
+(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic = [[NSMutableDictionary alloc] init];
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSMutableString *binaryString=[[NSMutableString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]);
        
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    //NSLog(@"转化后的二进制为:%@",binaryString);
    
    return binaryString;
    
}

+ (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

@end
