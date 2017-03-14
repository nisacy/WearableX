//
//  UIViewController+Autorotate.m
//  PMR
//
//  Created by Shinsoft on 16/8/8.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "UIViewController+Autorotate.h"

@implementation UIViewController (Autorotate)

//重载这三个方法
//- (BOOL)shouldAutorotate{
//    return [self.selectedViewController shouldAutorotate];
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//    return [self.selectedViewController supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//}


// IOS5默认支持竖屏
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//// IOS6默认不开启旋转，如果subclass需要支持屏幕旋转，重写这个方法return YES即可
//- (BOOL)shouldAutorotate {
//    return YES;
//}
//
//// IOS6默认支持竖屏
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}



@end
