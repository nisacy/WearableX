//
//  UINavgationBar+DropShadow.m
//  PMR
//
//  Created by Shinsoft on 16/8/8.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "UINavgationBar+DropShadow.h"

@implementation UINavigationBar (DropShadow)

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.clipsToBounds = NO;
}

@end
