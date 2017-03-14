//
//  TemperatureView.m
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "TemperatureView.h"

@interface TemperatureView (){
    NSTimer *timer;
}

@end

@implementation TemperatureView
@synthesize showWebView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TemperatureView" owner:self options:nil] lastObject];
    if(self) {
        [self initLayoutView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TemperatureView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        [self initLayoutView];
    }
    return self;
}


- (void)initLayoutView{
//    self.backgroundColor = k_color_red;
    _showView.backgroundColor = k_color_nav_bg;
    
    showWebView.scalesPageToFit = YES;
    showWebView.allowsInlineMediaPlayback = YES;
    showWebView.scrollView.bounces = NO;
    showWebView.opaque = NO; //不设置这个值 页面背景始终是白色
    showWebView.backgroundColor = [UIColor clearColor];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"temperature" ofType:@"html"];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [showWebView loadRequest:request];
    
    
    
//    timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    //每1秒运行一次function方法。
}


- (void)refresh{
    [showWebView stringByEvaluatingJavaScriptFromString:@"refreshData(200);"];
}


- (void)setTemperature:(CGFloat)temperature{
    _temperature = temperature;
    
    _temperatureLabel.text = [NSString stringWithFormat:@"%.1f ℃",temperature];
    
    [showWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"refreshData(%.1f);",_temperature]];
}

@end
