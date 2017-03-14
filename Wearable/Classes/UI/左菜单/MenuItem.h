//
//  MenuItem.h
//  Wearable
//
//  Created by Shinsoft on 17/1/28.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSString *default_icon;
@property (nonatomic, strong) NSString *active_icon;


@end
