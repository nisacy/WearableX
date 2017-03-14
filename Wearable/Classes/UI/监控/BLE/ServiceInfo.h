//
//  ServiceInfo.h
//  Wearable
//
//  Created by Shinsoft on 17/2/11.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ServiceInfo : NSObject

@property (nonatomic,strong) CBUUID *serviceUUID;
@property (nonatomic,strong) NSMutableArray *characteristics;

@end
