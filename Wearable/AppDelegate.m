//
//  AppDelegate.m
//  Wearable
//
//  Created by Shinsoft on 17/1/26.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XLBaseNavigationViewController.h"
#import "MMDrawerController.h"
#import "MainViewController.h"
#import "LeftViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIColor *bgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [SVProgressHUD setBackgroundColor:bgColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //在此初始化动画设置
    //present 动画
    NSString *className = @"CEPanAnimationController";
    id transitionInstance = [[NSClassFromString(className) alloc] init];
    AppDelegateAccessor.settingsAnimationController = transitionInstance;
    
    //手势
    NSString *pClassName = @"CEHorizontalSwipeInteractionController";
    id pTransitionInstance = [[NSClassFromString(pClassName) alloc] init];
    AppDelegateAccessor.settingsInteractionController = pTransitionInstance;

    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    XLBaseNavigationViewController *mainNav = [[XLBaseNavigationViewController alloc] initWithRootViewController:mainViewController];
    
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
//    XLBaseNavigationViewController *leftNav = [[XLBaseNavigationViewController alloc] initWithRootViewController:leftViewController];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:mainNav
                             leftDrawerViewController:leftViewController
                             rightDrawerViewController:nil];
    [drawerController setShowsShadow:YES];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumRightDrawerWidth:200.0];
    drawerController.maximumLeftDrawerWidth = kAppWidth - 150
    ;
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    
    self.window.rootViewController = drawerController;
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
