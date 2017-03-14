//
//  STFrontModal.h
//  STModalDemo
//
//  Created by zhenlintie on 15/8/14.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STModal.h"

@interface STFrontModal : NSObject
@property (strong, nonatomic) STModal *modal;
+ (instancetype)sharedFrontModal;
+ (void)showView:(UIView *)view animated:(BOOL)animated;
+ (void)hide:(BOOL)animated;

@end
