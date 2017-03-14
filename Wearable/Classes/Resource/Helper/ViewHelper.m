//
//  ViewHelper.m
//  DDS
//
//  Created by ShinSoft on 13-12-3.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import "ViewHelper.h"
#import <Accelerate/Accelerate.h>

@implementation ViewHelper

+ (UIDatePicker *)didDatePicker:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//    [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    if (!datePickerMode) {
        datePickerMode = UIDatePickerModeDate;
    }
    datePicker.datePickerMode = datePickerMode;
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSDate *selectedDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate  options:0];
    [datePicker setDate:selectedDate animated:NO];
//    [datePicker setMaximumDate:currentDate];
    return datePicker;
}

//定制订单状态菜单按钮样式
+ (UIButton *)customOrderStatusButton:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 27);
    
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [button setTitleColor:k_color_gray_30 forState:UIControlStateNormal];
    [button setTitleColor:k_color_red_40 forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"order_status_bg"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"order_status_selected_bg"] forState:UIControlStateHighlighted];
    
    
    if ([title isEqualToString:@"联系客服"]) {
        [button setImage:[UIImage imageNamed:@"tool_msg"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tool_msg_selected"] forState:UIControlStateHighlighted];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, -4, 0.0, 0.0)];
    }
    return button;
}

//更新控件字体颜色
+ (void)updateView:(UIView *)view fontColor:(UIColor *)color{
    for (int i = 0; i< view.subviews.count; i++) {
        UIView *tempView = [view.subviews objectAtIndex:i];
        if (!tempView.subviews || tempView.subviews.count<=0) {//没有子类
            [self resetView:tempView fontColor:color];
        } else {
            [self updateView:tempView fontColor:color];
        }
    }
}

+ (void)updateView:(UIView *)view fontColor:(UIColor *)color tag:(NSInteger)tag{
    for (int i = 0; i< view.subviews.count; i++) {
        UIView *tempView = [view.subviews objectAtIndex:i];
        if ((!tempView.subviews || tempView.subviews.count<=0) && tempView.tag == tag) {//没有子类
            [self resetView:tempView fontColor:color];
        } else {
            [self updateView:tempView fontColor:color tag:tag];
        }
    }
}


+ (void)resetView:(UIView *)view fontColor:(UIColor *)color{
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel *)view).textColor = color;
    } else if([view isKindOfClass:[UITextField class]]){
        ((UITextField *)view).textColor = color;
    } else if([view isKindOfClass:[UITextView class]]){
        ((UITextView *)view).textColor = color;
    }
}


+ (BOOL)view:(UIView *)targetView isExistInView:(UIView *)view{
    BOOL isExist;
    for (int i=0; i<view.subviews.count; i++) {
        UIView *subView = [view.subviews objectAtIndex:i];
        if ([subView isKindOfClass:targetView.class]) {
            isExist = YES;
            break;
        }
    }
    
    return isExist;
}

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        DLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
