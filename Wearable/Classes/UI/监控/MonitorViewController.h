//
//  MonitorViewController.h
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "XLBaseViewController.h"

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "ServiceInfo.h"
#import "SVProgressHUD.h"
#import "PeripheralInfo.h"

@interface MonitorViewController : XLBaseViewController{
@public
    BabyBluetooth *baby;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic, strong) PeripheralInfo *peripheralInfo;

@end
