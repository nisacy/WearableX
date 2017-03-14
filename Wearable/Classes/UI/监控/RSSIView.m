//
//  RSSIView.m
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "RSSIView.h"
#import "CircleView.h"

@interface RSSIView (){
    CGFloat centerX;//圆中心点 X 坐标
    CGFloat centerY;//圆中心点 Y 坐标
    CGFloat outerRadius;////圆半径
    
    NSInteger mSafeMin;
    NSInteger mSafeMax;
    NSInteger decreaseRadius;
    NSInteger mMidMin;
    NSInteger mMidMax;
    NSInteger mDangerMin;
    NSInteger mDangerMax;
    
    
    UIImageView *deviceImageView;
}

@end

@implementation RSSIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RSSIView" owner:self options:nil] lastObject];
    if(self) {
        [self initLayoutView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RSSIView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        [self initLayoutView];
    }
    return self;
}


- (void)initLayoutView{
    self.backgroundColor = k_color_yellow;
    
    
    
    CircleView *circleView = [[CircleView alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    [self addSubview:circleView];
    circleView.isFillColor = YES;
    
    
    centerX = kAppWidth / 2;
    centerY = kAppHeight-44.f - 20.f;
    outerRadius = (float) (centerX / 2.5);
    
    
    mSafeMin = 30;
    mSafeMax = 60;
    mMidMin = 60;
    mMidMax = 80;
    mDangerMin = 80;
    mDangerMax = 100;
    
    
    
    
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [UIImage imageNamed:@"beacon_bg"];
    [self addSubview:bgImageView];
    //最近的圆环
    CircleView *circleView0 = [[CircleView alloc] initWithFrame:[self rectByRadius:outerRadius]];
    circleView0.isFillColor = YES;
    [self addSubview:circleView0];
    
    //1圆环
    CircleView *circleView1 = [[CircleView alloc] initWithFrame:[self rectByRadius:outerRadius*2]];
    [self addSubview:circleView1];
    
    //2圆环
    CircleView *circleView2 = [[CircleView alloc] initWithFrame:[self rectByRadius:outerRadius*4]];
    [self addSubview:circleView2];
    
    //3圆环
    CircleView *circleView3 = [[CircleView alloc] initWithFrame:[self rectByRadius:outerRadius*6]];
    [self addSubview:circleView3];
    
    //4圆环
    CircleView *circleView4 = [[CircleView alloc] initWithFrame:[self rectByRadius:outerRadius*8]];
    [self addSubview:circleView4];
    
    //画手机设备图标
    NSInteger width = 22;
    NSInteger height = 36;
    CGRect rect = CGRectMake((kAppWidth - width)/2.f, kAppHeight-44.f - height - 20.f, width, height);
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:rect];
    phoneImageView.image = [UIImage imageNamed:@"phone_icon"];
    [self addSubview:phoneImageView];
    
    //画蓝牙设备图标
    NSInteger width1 = 48;
    NSInteger height1 = 49;
    CGRect rect1 = CGRectMake((kAppWidth - width1)/2.f, kAppHeight-64.f - height1 - decreaseRadius, width1, height1);
    deviceImageView = [[UIImageView alloc] initWithFrame:rect1];
    deviceImageView.image = [UIImage imageNamed:@"wearable_device"];
    [self addSubview:deviceImageView];
    

}

- (CGRect)rectByRadius:(CGFloat)radius{
    CGRect rect = CGRectZero;
    rect.origin.x = kAppWidth/2.0f - radius;
    rect.origin.y = kAppHeight - 64 - radius;
    rect.size.width = radius*2;
    rect.size.height = radius*2;
    
    return rect;
}

- (void)setRange:(NSInteger)safeMin safeMax:(NSInteger)safeMax  midMin:(NSInteger)midMin midMax:(NSInteger)midMax dangerMin:(NSInteger)dangerMin dangerMax:(NSInteger)dangerMax {
    mSafeMin = safeMin;
    mSafeMax = safeMax;
    mMidMin = midMin;
    mMidMax = midMax;
    mDangerMin = dangerMin;
    mDangerMax = dangerMax;
}

- (void)setProgress:(int)progress {
    //  invalidate();
    _progress = progress;
    int region;
    int pors = 0;
    //int pors = (int) outerRadius / 4;
    
    
    if (progress <= mSafeMin) {
        pors = (int) ( outerRadius );
        region = pors / ( mSafeMin);
        int i = abs(progress);
        region = region * i;
        //region = (int)outerRadius;
    } else if (progress > mSafeMin && progress <= mSafeMax) {
        pors = (int) ( outerRadius*2 - outerRadius );
        region = pors / (mSafeMax - mSafeMin);
        int i = abs(mSafeMin - progress);
        region = region * i + (int)outerRadius;
    } else if (progress > mMidMin && progress <= mMidMax) {
        pors = (int) ( outerRadius*4 - outerRadius*2 );
        // region = ((pors * 2) - pors) / (mMidMax - mMidMin);
        region = pors/ (mMidMax - mMidMin);
        int i = abs(mMidMin - progress);
        region = (region * i) + (int) outerRadius*2 ;
    } else if (progress > mDangerMin && progress <= mDangerMax) {
        pors = (int) ( outerRadius*6 - outerRadius*4 );
        // region = ((int) outerRadius - (pors * 2)) / (mDangerMax - mDangerMin);
        region = pors/ (mDangerMax - mDangerMin);
        int i = abs(mDangerMin - progress);
        region = (region * i) + (int)outerRadius*4;
    } else if(progress > mDangerMax && progress <= 120) {
        pors = (int) ( centerY - 10 - outerRadius*6 );
        // region = ((int) outerRadius - (pors * 2)) / (mDangerMax - mDangerMin);
        region = pors/ (120 - mDangerMax);
        int i = abs(mDangerMax - progress);
        region = (region * i) + (int)(outerRadius*6);
    }else{
        region = (int)centerY - 10;
    }
    decreaseRadius = region;
//    [self setNeedsDisplay];
    
    
    NSInteger height1 = 49;
    CGRect rect = deviceImageView.frame;
    rect.origin.y = kAppHeight-64.f - height1 - decreaseRadius;
    deviceImageView.frame = rect;
}



//- (void)drawRect:(CGRect)rect{
//    //An opaque type that represents a Quartz 2D drawing environment.
//    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
////    /*背景图*/
//    [self drawBGImage:context];
//    //绘制填充半圆（第一个范围）
//    [self drawFillCircle:context];
//    //绘制手机图标
//    [self drawPhoneImage:context];
//    
//    //第二个范围
//    [self drawCircle:context withMultiple:2];
//    //第三个范围
//    [self drawCircle:context withMultiple:4];
//    //第四个范围
//    [self drawCircle:context withMultiple:6];
//    //第五个范围
//    [self drawCircle:context withMultiple:8];
//    
//    //绘制设备相对位置
//    [self drawDeviceImage:context];
//}
//
//
//#pragma mark 绘制图片
//- (void)drawBGImage:(CGContextRef)context{
//    UIImage *image = [UIImage imageNamed:@"beacon_bg"];
//    [image drawInRect:self.bounds];//在坐标中画出图片
//    //    [image drawAtPoint:CGPointMake(100, 340)];//保持图片大小在point点开始画图片，可以把注释去掉看看
//    //CGContextDrawImage(context, CGRectMake(100, 340, 20, 20), image.CGImage);//使用这个使图片上下颠倒了，参考
//}
//
//- (void)drawPhoneImage:(CGContextRef)context{
//    UIImage *image = [UIImage imageNamed:@"phone_icon"];
//    NSInteger width = 22;
//    NSInteger height = 36;
//    [image drawInRect:CGRectMake((kAppWidth - width)/2.f, kAppHeight-44.f - height - 20.f, width, height)];//在坐标中画出图片
//    //    [image drawAtPoint:CGPointMake(100, 340)];//保持图片大小在point点开始画图片，可以把注释去掉看看
////    CGContextDrawImage(context, CGRectMake(100, 340, 20, 20), image.CGImage);//使用这个使图片上下颠倒了，参考
//}
//
//- (void)drawDeviceImage:(CGContextRef)context{
//    UIImage *image = [UIImage imageNamed:@"wearable_device"];
//    NSInteger width = 48;
//    NSInteger height = 49;
//    [image drawInRect:CGRectMake((kAppWidth - width)/2.f, kAppHeight-64.f - height - decreaseRadius, width, height)];//在坐标中画出图片
//    //    [image drawAtPoint:CGPointMake(100, 340)];//保持图片大小在point点开始画图片，可以把注释去掉看看
////    CGContextDrawImage(context, CGRectMake(100, 340, 20, 20), image.CGImage);//使用这个使图片上下颠倒了，参考
//}
//
//
//#pragma mark 绘制圆弧
//- (void)drawArc:(CGContextRef)context
//{
//    //1.获取上下文- 当前绘图的设备
//    //    CGContextRef *context = UIGraphicsGetCurrentContext();
//    //设置路径
//    /*
//     CGContextRef c:上下文
//     CGFloat x ：x，y圆弧所在圆的中心点坐标
//     CGFloat y ：x，y圆弧所在圆的中心点坐标
//     CGFloat radius ：所在圆的半径
//     CGFloat startAngle ： 圆弧的开始的角度  单位是弧度  0对应的是最右侧的点；
//     CGFloat endAngle  ： 圆弧的结束角度
//     int clockwise ： 顺时针（0） 或者 逆时针(1)
//     */
//    CGContextAddArc(context, kAppWidth/2.0f, kAppHeight-44.0f, 100, -0, M_PI, 1);
//    
//    CGContextSetRGBStrokeColor(context, 150, 150, 150, 1);
//    //绘制圆弧
//    CGContextDrawPath(context, kCGPathStroke);
//    
//}
//
//- (void)drawCircle:(CGContextRef)context withMultiple:(NSInteger)multiple{
//    //边框圆
//    CGContextSetRGBStrokeColor(context,218/255.f,219/255.f,223/255.f,1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 2.0);//线的宽度
//    CGContextAddArc(context,  centerX, centerY, outerRadius * multiple, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//    
//    
//    CGContextSetRGBStrokeColor(context,1.f,1.f,1.f,1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 2.0);//线的宽度
//    CGContextAddArc(context, centerX, centerY, outerRadius * multiple -2, 0, 2*M_PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//}
//
//- (void)drawFillCircle:(CGContextRef)context{
//    //画大圆并填充颜
//    UIColor*aColor = [UIColor colorWithRed:206/255.f green:233/255.f blue:254/255.f alpha:1];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextSetRGBStrokeColor(context, 50, 50, 50, 1);
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddArc(context, centerX, centerY, outerRadius, 0, 2*M_PI, 0); //添加一个圆
//    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
//}

@end
