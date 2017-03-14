//
//  CircleView.m
//  Wearable
//
//  Created by Shinsoft on 17/2/16.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "CircleView.h"
#import "UIView+KGViewExtend.h"

#define k_space 2

@interface CircleView (){
    CAShapeLayer *outLayer,*inLayer;
}

@end

@implementation CircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self initLayoutView];
    }
    return self;
}

- (void)initLayoutView{
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f) radius:self.frame.size.width/2.f startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    // 创建一个shapeLayer
    outLayer = [CAShapeLayer layer];
    outLayer.frame         = self.bounds;                // 与showView的frame一致
    outLayer.strokeColor   = RGBCOLOR(218.f,219.f,223.f).CGColor;   // 边缘线的颜色
    outLayer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    outLayer.lineCap       = kCALineCapRound;               // 边缘线的类型
    outLayer.path          = path.CGPath;                    // 从贝塞尔曲线获取到形状
    outLayer.lineWidth     = 2.0f;
    
    outLayer.strokeStart = 0.0f;
    outLayer.strokeEnd = 1.0f;
    // 将layer添加进图层
    [self.layer addSublayer:outLayer];
    
    
    
    // 贝塞尔曲线(创建一个圆)
    UIBezierPath *inPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2.f, self.frame.size.width/2.f) radius:(self.frame.size.width-2*k_space)/2.f startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    // 创建一个shapeLayer
    inLayer = [CAShapeLayer layer];
    inLayer.frame         = self.bounds;                // 与showView的frame一致
    inLayer.strokeColor   = [UIColor whiteColor].CGColor;   // 边缘线的颜色
    inLayer.fillColor     = [UIColor clearColor].CGColor;   // 闭环填充的颜色
    inLayer.lineCap       = kCALineCapRound;               // 边缘线的类型
    inLayer.path          = inPath.CGPath;                    // 从贝塞尔曲线获取到形状
    inLayer.lineWidth     = 2.0f;
    
    inLayer.strokeStart = 0.0f;
    inLayer.strokeEnd = 1.0f;
    // 将layer添加进图层
    [self.layer addSublayer:inLayer];
}

- (void)setIsFillColor:(BOOL)isFillColor{
    _isFillColor = isFillColor;
    
    UIColor*fillColor = [UIColor colorWithRed:206/255.f green:233/255.f blue:254/255.f alpha:1];
    inLayer.fillColor     = fillColor.CGColor;   // 闭环填充的颜色
}


@end
