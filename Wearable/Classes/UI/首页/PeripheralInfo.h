//
//  PeripheralInfo.h
//  Wearable
//
//  Created by Shinsoft on 17/2/9.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralInfo : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSDictionary *advertisementData;

@end
