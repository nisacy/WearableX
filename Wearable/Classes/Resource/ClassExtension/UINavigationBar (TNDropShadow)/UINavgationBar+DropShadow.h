//
//  UINavgationBar+DropShadow.h
//  PMR
//
//  Created by Shinsoft on 16/8/8.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//



@interface UINavigationBar (DropShadow)

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;

@end
