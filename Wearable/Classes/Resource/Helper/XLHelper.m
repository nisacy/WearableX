//
//  XLHelper.m
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/23.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import "XLHelper.h"

@implementation XLHelper



//根据传递的数据，进行格式化，如果是19.00则转为19，19.10则转为19.1，19.12则为19.12
+ (NSString *)formatDataByStr:(NSString *)data{
    if (IsNilString(data)) {
        return @"0";
    }
    
    NSString *result;
    NSString *resultStr;
    if ([data isKindOfClass:[NSNumber class]]) {//数字类
        resultStr = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",data] floatValue]];
    } else if ([data isKindOfClass:[NSString class]]) {//字符串类
        resultStr = data;
    }
    
    if ([resultStr containsString:@"."]) {
        NSArray *items = [resultStr componentsSeparatedByString:@"."];
        NSString *item1 = items[0];
        NSString *item2 = items[1];
        
        if (item2.length==2) {
            if ([@"0" isEqualToString:[item2 substringFromIndex:1]]) {//小数点第二位数据位0
                item2 = [item2 substringToIndex:1];
                
                if ([@"0" isEqualToString:[item2 substringFromIndex:0]]) {//小数点第一位数据位0
                    item2 = @"";
                }
            }
        } else {
            if ([@"0" isEqualToString:[item2 substringFromIndex:0]]) {//小数点后数据位0
                item2 = @"";
            } else {
                item2 = [item2 substringToIndex:1]; //小数点第二位数据位0
            }
        }
        
        
        if (IsNilString(item2)) {
            result = [NSString stringWithFormat:@"%@",item1];
        } else {
            result = [NSString stringWithFormat:@"%@.%@",item1,item2];
        }
        
    } else {
        result = resultStr;
    }
    
    return result;
}

+ (NSString *)formatDataByFloat:(float)price{
    NSString *result;
    NSString *resultStr;
    resultStr = [NSString stringWithFormat:@"%.2f",price];
    
    if ([resultStr containsString:@"."]) {
        NSArray *items = [resultStr componentsSeparatedByString:@"."];
        NSString *item1 = items[0];
        NSString *item2 = items[1];
        
        if ([@"0" isEqualToString:[item2 substringFromIndex:1]]) {//小数点第二位数据位0
            item2 = [item2 substringToIndex:1];
            
            if ([@"0" isEqualToString:[item2 substringFromIndex:0]]) {//小数点第一位数据位0
                item2 = @"";
            }
        } else {
            if ([@"0" isEqualToString:[item2 substringFromIndex:0]]) {//小数点后数据位0
                item2 = @"";
            }
            //            else {//小数点第二位数据位0
            //                item2 = [item2 substringToIndex:1];
            //            }
        }
        
        if (IsNilString(item2)) {
            result = [NSString stringWithFormat:@"%@",item1];
        } else {
            result = [NSString stringWithFormat:@"%@.%@",item1,item2];
        }
        
    } else {
        result = resultStr;
    }
    
    return result;
}





//转换中文大写数字
+ (NSString *)converterNumToCapital:(NSInteger)number{
    NSString *capitalResult = @"";
    
    NSString *num = [NSString stringWithFormat:@"%ld",number];
    NSString *topstr=[num stringByReplacingOccurrencesOfString:@"," withString:@""];//过滤逗号
    NSInteger numl=[topstr length];//确定长度
    NSString *cache;//缓存
    if ((numl==2||numl==6)&&[topstr hasPrefix:@"1"] ){//十位或者万位为一时候
        cache=@"拾";
        for (NSInteger i=1; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }else{//其他
        cache=@"";
        for (NSInteger i=0; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bit:topstr thenum:i]];
        }
    }//转换完大写
    //    NSLog(@"cache:%@",cache);
    capitalResult=@"";
    cache=[cache substringWithRange:NSMakeRange(0, [cache length])];
    for (NSInteger i=[cache length]; i>0; i--) {//擦屁股，如果尾部为0就擦除
        if ([cache hasSuffix:@"零"]) {
            cache=[cache substringWithRange:NSMakeRange(0, i-1)];
        }else{
            continue;
        }
    }
    //    NSLog(@"cache2:%@",cache);
    for (NSInteger i=[cache length]; i>0; i--) {//重复零，删零
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if (!([a isEqualToString:b]&&[a isEqualToString:@"零"])) {
            capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    cache=capitalResult;
    capitalResult=@"";
    //    NSLog(@"cache3:%@",cache);
    for (NSInteger i=[cache length]; i>0; i--) {//去掉 “零万” 和 “亿万”
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if ([a isEqualToString:@"万"]&&[b isEqualToString:@"零"]) {
            NSString *c=[cache substringWithRange:NSMakeRange(i-3, 1)];
            if ([c isEqualToString:@"亿"]){
                capitalResult =[NSString stringWithFormat:@"%@%@",c,capitalResult];
                cache=[cache substringWithRange:NSMakeRange(0, i-3)];
                i=i-2;
            }else{
                capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
                cache=[cache substringWithRange:NSMakeRange(0, i-2)];
                i--;
            }
        }else{
            capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    
    
    //    if ([capitalResult isEqualToString:@"元"]) {
    //        capitalResult=@"零元";
    //    }
    
    //
    //    if (bottom1!=nil ) {
    //        if (bottom2!=nil && ![bottom2 isEqualToString:@"0"]) {
    //            amount.text=[NSString stringWithFormat:@"%@%@角%@分",amount.text,[self NumtoCN:bottom1 site:0],[self NumtoCN:bottom2 site:0]];
    //        }else{
    //            if (![bottom1 isEqualToString:@"0"]) {
    //                amount.text=[NSString stringWithFormat:@"%@%@角",amount.text,[self NumtoCN:bottom1 site:0]];
    //            }
    //        }
    //    }
    DLog(@"%@",capitalResult);
    return capitalResult;
}

+ (NSString*)NumtoCN:(NSString*)string site:(NSInteger)site{//阿拉伯数字转中文大写
    
    if ([string isEqualToString:@"0"]) {
        if (site==5) {
            return @"万零";
        }else{
            return @"零";
        }
    }else if ([string isEqualToString:@"1"]) {
        string=@"壹";
    }else if ([string isEqualToString:@"2"]) {
        string=@"贰";
    }else if ([string isEqualToString:@"3"]) {
        string=@"叁";
    }else if ([string isEqualToString:@"4"]) {
        string=@"肆";
    }else if ([string isEqualToString:@"5"]) {
        string=@"伍";
    }else if ([string isEqualToString:@"6"]) {
        string=@"陆";
    }else if ([string isEqualToString:@"7"]) {
        string=@"柒";
    }else if ([string isEqualToString:@"8"]) {
        string=@"捌";
    }else if ([string isEqualToString:@"9"]) {
        string=@"玖";
    }
    
    
    switch (site) {
        case 1:
            return [NSString stringWithFormat:@"%@",string];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@万",string];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@拾",string];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@佰",string];
            break;
        case 8:
            return [NSString stringWithFormat:@"%@仟",string];
            break;
        case 9:
            return [NSString stringWithFormat:@"%@亿",string];
            break;
        default:
            return string;
            break;
    }
}


+ (NSString*)bit:(NSString*)string thenum:(NSInteger)num{//取位转大写
    NSInteger site=[string length]-num;
    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    //    NSLog(@"传入字符串%@，总长度%d,传入位%d",string,[string length],num);
    string=[string substringWithRange:NSMakeRange(num,1)];
    string=[self NumtoCN:string site:site];
    //    NSLog(@"转换后:%@",string);
    return string;
    
}



+ (NSString *)converterNumToSimpleCapital:(NSInteger)number{
    NSString *capitalResult = @"";
    
    NSString *num = [NSString stringWithFormat:@"%ld",number];
    NSString *topstr=[num stringByReplacingOccurrencesOfString:@"," withString:@""];//过滤逗号
    NSInteger numl=[topstr length];//确定长度
    NSString *cache;//缓存
    if ((numl==2||numl==6)&&[topstr hasPrefix:@"1"] ){//十位或者万位为一时候
        cache=@"十";
        for (NSInteger i=1; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bitSimple:topstr thenum:i]];
        }
    }else{//其他
        cache=@"";
        for (NSInteger i=0; i<numl; i++) {
            cache=[NSString stringWithFormat:@"%@%@",cache,[self bitSimple:topstr thenum:i]];
        }
    }//转换完大写
    //    NSLog(@"cache:%@",cache);
    capitalResult=@"";
    cache=[cache substringWithRange:NSMakeRange(0, [cache length])];
    for (NSInteger i=[cache length]; i>0; i--) {//擦屁股，如果尾部为0就擦除
        if ([cache hasSuffix:@"零"]) {
            cache=[cache substringWithRange:NSMakeRange(0, i-1)];
        }else{
            continue;
        }
    }
    //    NSLog(@"cache2:%@",cache);
    for (NSInteger i=[cache length]; i>0; i--) {//重复零，删零
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if (!([a isEqualToString:b]&&[a isEqualToString:@"零"])) {
            capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    cache=capitalResult;
    capitalResult=@"";
    //    NSLog(@"cache3:%@",cache);
    for (NSInteger i=[cache length]; i>0; i--) {//去掉 “零万” 和 “亿万”
        NSString *a=[cache substringWithRange:NSMakeRange(i-1, 1)];
        NSString *b=[cache substringWithRange:NSMakeRange(i-2, 1)];
        if ([a isEqualToString:@"万"]&&[b isEqualToString:@"零"]) {
            NSString *c=[cache substringWithRange:NSMakeRange(i-3, 1)];
            if ([c isEqualToString:@"亿"]){
                capitalResult =[NSString stringWithFormat:@"%@%@",c,capitalResult];
                cache=[cache substringWithRange:NSMakeRange(0, i-3)];
                i=i-2;
            }else{
                capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
                cache=[cache substringWithRange:NSMakeRange(0, i-2)];
                i--;
            }
        }else{
            capitalResult = [NSString stringWithFormat:@"%@%@",a,capitalResult];
        }
        cache=[cache substringWithRange:NSMakeRange(0, i-1)];
    }
    
    DLog(@"%@",capitalResult);
    return capitalResult;
}

+ (NSString*)NumtoSimpleCN:(NSString*)string site:(NSInteger)site{//阿拉伯数字转中文大写
    
    if ([string isEqualToString:@"0"]) {
        if (site==5) {
            return @"万零";
        }else{
            return @"零";
        }
    }else if ([string isEqualToString:@"1"]) {
        string=@"一";
    }else if ([string isEqualToString:@"2"]) {
        string=@"二";
    }else if ([string isEqualToString:@"3"]) {
        string=@"三";
    }else if ([string isEqualToString:@"4"]) {
        string=@"四";
    }else if ([string isEqualToString:@"5"]) {
        string=@"五";
    }else if ([string isEqualToString:@"6"]) {
        string=@"六";
    }else if ([string isEqualToString:@"7"]) {
        string=@"七";
    }else if ([string isEqualToString:@"8"]) {
        string=@"八";
    }else if ([string isEqualToString:@"9"]) {
        string=@"九";
    }
    
    
    switch (site) {
        case 1:
            return [NSString stringWithFormat:@"%@",string];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@十",string];
            break;
        case 3:
            return [NSString stringWithFormat:@"%@百",string];
            break;
        case 4:
            return [NSString stringWithFormat:@"%@千",string];
            break;
        case 5:
            return [NSString stringWithFormat:@"%@万",string];
            break;
        case 6:
            return [NSString stringWithFormat:@"%@十",string];
            break;
        case 7:
            return [NSString stringWithFormat:@"%@百",string];
            break;
        case 8:
            return [NSString stringWithFormat:@"%@千",string];
            break;
        case 9:
            return [NSString stringWithFormat:@"%@亿",string];
            break;
        default:
            return string;
            break;
    }
}


+ (NSString*)bitSimple:(NSString*)string thenum:(NSInteger)num{//取位转大写
    NSInteger site=[string length]-num;
    string=[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    //    NSLog(@"传入字符串%@，总长度%d,传入位%d",string,[string length],num);
    string=[string substringWithRange:NSMakeRange(num,1)];
    string=[self NumtoSimpleCN:string site:site];
    //    NSLog(@"转换后:%@",string);
    return string;
    
}

+ (NSString *)getUniqueStrByUUID{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    return uuidString ;
}


+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}


@end
