//
//  ScreeningModel.h
//  XLShop
//
//  Created by Shinsoft on 15/10/13.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreeningModel : NSObject
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic,strong) NSString *background;//默认背景色
@property (nonatomic, strong) NSString *selectedBackground;//选择背景色
@property (nonatomic, assign) BOOL disableExchange;//不能变色,默认为NO,为 YES 时，则维持之前的选择位置
@property (nonatomic, strong) NSString *normalIcon;//默认图标
@property (nonatomic, strong) NSString *selectedIcon;//选择后图标
@property (nonatomic, strong) NSString *exchangeIcon;//切换的图标
@end
