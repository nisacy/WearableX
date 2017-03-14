//
//  ServiceInfo.m
//  Wearable
//
//  Created by Shinsoft on 17/2/11.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "ServiceInfo.h"

@implementation ServiceInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        _characteristics = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
