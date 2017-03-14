//
//  ViewHelper.h
//  DDS
//
//  Created by ShinSoft on 13-12-3.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewHelper : NSObject

+ (UIDatePicker *)didDatePicker:(UIDatePickerMode)datePickerMode;

//定制订单状态菜单按钮样式
+ (UIButton *)customOrderStatusButton:(NSString *)title;

//更新控件字体颜色
+ (void)updateView:(UIView *)view fontColor:(UIColor *)color;
+ (void)updateView:(UIView *)view fontColor:(UIColor *)color tag:(NSInteger)tag;

//判断控件是否存在
+ (BOOL)view:(UIView *)targetView isExistInView:(UIView *)view;

//模糊效果
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
