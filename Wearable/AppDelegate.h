//
//  AppDelegate.h
//  Wearable
//
//  Created by Shinsoft on 17/1/26.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@class CEReversibleAnimationController,CEBaseInteractionController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CEReversibleAnimationController *settingsAnimationController;
@property (strong, nonatomic) CEBaseInteractionController *settingsInteractionController;

@end

