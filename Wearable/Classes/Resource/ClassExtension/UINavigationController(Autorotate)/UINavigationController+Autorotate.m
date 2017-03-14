//
//  UINavigationController+Autorotate.m
//  PMR
//
//  Created by Shinsoft on 16/8/8.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "UINavigationController+Autorotate.h"

@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}




@end
