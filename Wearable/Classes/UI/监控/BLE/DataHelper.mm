//
//  DataHelper.m
//  Wearable
//
//  Created by Shinsoft on 17/2/13.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

+ (DataHelper *)getInstance
{
    static DataHelper *sharedDataHelperInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDataHelperInstance = [[self alloc] init];
    });
    return sharedDataHelperInstance;
}

- (CGFloat)readTempValueFromHexStr:(NSString *)hexStr{
    if (IsNilString(hexStr)) {
        return 0;
    }
    NSString *lowTemp = [hexStr substringToIndex:2];
    NSString *highTemp = [hexStr substringWithRange:NSMakeRange(2, 2)];
    //16进制转10进制
    NSString *lowTemp10 = [NSString stringWithFormat:@"%lu",strtoul([lowTemp UTF8String],0,16)];
    
    NSString * highTemp10 = [NSString stringWithFormat:@"%lu",strtoul([highTemp UTF8String],0,16)];
    
    //转成数字
    NSInteger lowNumber = [lowTemp10 integerValue];
    NSInteger highNumber = [highTemp10 integerValue];
    highNumber = highNumber<<8;
    
    CGFloat allNumber = (lowNumber + highNumber)/100.f;
    
    return roundf(allNumber * 10) / 10;
}

- (CGFloat)readTempValueFromByte:(NSData *)data{
    NSString *hexStr = [self convertDataToHexStr:data];
    return [self readTempValueFromHexStr:hexStr];
}

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


- (NSInteger)highValueFromHexStr:(NSString *)hexStr{
    //16进制转10进制
    NSString * highTemp10 = [NSString stringWithFormat:@"%lu",strtoul([hexStr UTF8String],0,16)];
    
    //转成数字
    NSInteger highNumber = [highTemp10 integerValue];
    highNumber = highNumber<<8;
    return highNumber;
}

- (NSInteger)lowValueFromHexStr:(NSString *)hexStr{
    //16进制转10进制
    NSString *lowTemp10 = [NSString stringWithFormat:@"%lu",strtoul([hexStr UTF8String],0,16)];
    //转成数字
    NSInteger lowNumber = [lowTemp10 integerValue];
    return lowNumber;
}

- (NSMutableArray *)readAcceleroValueFromHexStr:(NSString *)hexStr{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    
    if (IsNilString(hexStr)) {
        [items addObject:@"0"];
        [items addObject:@"0"];
        [items addObject:@"0"];
        return items;
    }
    
    NSString *xLowStr = [hexStr substringToIndex:2];
    NSInteger xLow = [self lowValueFromHexStr:xLowStr];
    NSString *xHighStr = [hexStr substringWithRange:NSMakeRange(2, 2)];
    NSInteger xHigh = [self highValueFromHexStr:xHighStr];
    NSInteger xValue = xLow + xHigh;
//    xValue = [self unsignedToSigned:xValue size:16];
    
    
    [items addObject:[NSString stringWithFormat:@"%ld",xValue]];
    
    
    NSString *yLowStr = [hexStr substringWithRange:NSMakeRange(4, 2)];
    NSInteger yLow = [self lowValueFromHexStr:yLowStr];
    NSString *yHighStr = [hexStr substringWithRange:NSMakeRange(6, 2)];
    NSInteger yHigh = [self highValueFromHexStr:yHighStr];
    NSInteger yValue = yLow + yHigh;
    
//    yValue = [self unsignedToSigned:yValue size:16];
    [items addObject:[NSString stringWithFormat:@"%ld",yValue]];
    
    
    NSString *zLowStr = [hexStr substringWithRange:NSMakeRange(8, 2)];
    NSInteger zLow = [self lowValueFromHexStr:zLowStr];
    NSString *zHighStr = [hexStr substringWithRange:NSMakeRange(10, 2)];
    NSInteger zHigh = [self highValueFromHexStr:zHighStr];
    NSInteger zValue = zLow + zHigh;
    
//    zValue = [self unsignedToSigned:zValue size:16];
    [items addObject:[NSString stringWithFormat:@"%ld",zValue]];
    

    
    
//    NSString *xStr = [hexStr substringToIndex:2];
//    NSString * tempX = [NSString stringWithFormat:@"%lu",strtoul([xStr UTF8String],0,16)];
////    NSInteger xValue = [tempX integerValue];
//    [items addObject:tempX];
//    
//    NSString *yStr = [hexStr substringWithRange:NSMakeRange(2, 2)];
//    NSString * tempY = [NSString stringWithFormat:@"%lu",strtoul([yStr UTF8String],0,16)];
//    //    NSInteger xValue = [tempX integerValue];
//    [items addObject:tempY];
//    
//    NSString *zStr = [hexStr substringWithRange:NSMakeRange(4, 2)];
//    NSString * tempZ = [NSString stringWithFormat:@"%lu",strtoul([zStr UTF8String],0,16)];
//    //    NSInteger xValue = [tempX integerValue];
//    [items addObject:tempZ];
    
    return items;
}



- (NSInteger)unsignedToSigned:(NSInteger)unsignedInt size:(NSInteger)size {
    if ((unsignedInt & (1 << (size-1))) != 0) {
        unsignedInt = -1 * ((1 << (size-1)) - (unsignedInt & ((1 << (size-1)) - 1)));
    }
    return unsignedInt/1000;
}

- (NSMutableArray *)readAcceleroValueFromByte:(NSData *)data{
    NSString *hexStr = [self convertDataToHexStr:data];
//    return [self readAcceleroValueFromHexStr:hexStr];
    
    return [self readAcceleroValuesFromHexStr:hexStr];
}

- (NSMutableArray *)readAcceleroValuesFromHexStr:(NSString *)hexStr{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    
    if (IsNilString(hexStr)) {
        [items addObject:@"0"];
        [items addObject:@"0"];
        [items addObject:@"0"];
        return items;
    }
    
    
    
    
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
    
    [items addObject:xDecimalStr];
    
    NSString *yDecimalStr;
    if ([yBinaryStr hasPrefix:@"0"]) {
        yDecimalStr = [self toDecimalSystemWithBinarySystem:yBinaryStr];
    } else {
        yDecimalStr = [self toNegativeDecimalSystemWithBinarySystem:yBinaryStr];
    }
    [items addObject:yDecimalStr];
    
    NSString *zDecimalStr;
    if ([zBinaryStr hasPrefix:@"0"]) {
        zDecimalStr = [self toDecimalSystemWithBinarySystem:zBinaryStr];
    } else {
        zDecimalStr = [self toNegativeDecimalSystemWithBinarySystem:zBinaryStr];
    }
    [items addObject:zDecimalStr];
    
    return items;
}


- (NSString *)toNegativeDecimalSystemWithBinarySystem:(NSString *)binary{
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

- (NSString *)addNumResult:(NSString *)binary{
    
    DLog(@"%@",binary);
    
    binary = [self replaceBinary:binary withIndex:1];
    
    DLog(@"%@",binary);
    
    return binary;
}

int iii = 1;
- (NSString *)replaceBinary:(NSString *)binary withIndex:(NSInteger)index{
    NSInteger length = binary.length;
    NSString *lastItem = [binary substringWithRange:NSMakeRange(length-index, 1)];
    if ([lastItem isEqualToString:@"0"]) {
        lastItem = @"1";
        binary = [binary stringByReplacingCharactersInRange:NSMakeRange(length-index, 1) withString:lastItem];
        
        return binary;
    } else {
        lastItem = @"0";
        binary = [binary stringByReplacingCharactersInRange:NSMakeRange(length-index, 1) withString:lastItem];
        iii++;
        if ( iii<=binary.length) {
            return [self replaceBinary:binary withIndex: iii];
        }
        return binary;
    }
    
    
}


//  二进制转十进制
- (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%.2f",ll/1000.f];
    
    return result;
}

//十六进制转二进制
- (NSString *)getBinaryByhex:(NSString *)hex
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

@end
