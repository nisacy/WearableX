//
//  NSMutableArray+Custom.m
//  XLShop
//
//  Created by Shinsoft on 15/10/19.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import "NSMutableArray+Custom.h"

@implementation NSMutableArray (Custom)

- (NSMutableArray *)mutableDeepCopyOfArray {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (int i = 0; i < [self count]; i++) {
        id oneValue = [self objectAtIndex:i];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopyOfArray)]) {
            oneCopy = [oneValue mutableDeepCopyOfArray];
        }
        else if ([oneValue respondsToSelector:@selector(mutableCopy)]) {
            oneCopy = [oneValue mutableCopy];
        }
        
        if (oneCopy == nil) {
            oneCopy = [oneValue copy];
        }
        [newArray addObject:oneCopy];
    }
    return newArray;
}

@end
