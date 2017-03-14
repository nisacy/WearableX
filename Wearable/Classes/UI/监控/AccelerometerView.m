//
//  AccelerometerView.m
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "AccelerometerView.h"

@interface AccelerometerView (){
    NSTimer *timer;
}

@end

@implementation AccelerometerView
@synthesize showWebView;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AccelerometerView" owner:self options:nil] lastObject];
    if(self) {
        [self initLayoutView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AccelerometerView" owner:self options:nil] lastObject];
    if (self) {
        // Initialization code
        self.frame = frame;
        
        [self initLayoutView];
    }
    return self;
}


- (void)initLayoutView{
    self.backgroundColor = k_color_white;
    
    _operateBtn.frame = CGRectMake(60, kAppHeight - 50 - 64, 64, 32);
    showWebView.frame = CGRectMake(60, 0, kAppWidth - 60, kAppHeight - 200);
    showWebView.scalesPageToFit = YES;
    showWebView.allowsInlineMediaPlayback = YES;
    showWebView.scrollView.bounces = NO;
    showWebView.opaque = NO; //不设置这个值 页面背景始终是白色
    showWebView.backgroundColor = [UIColor clearColor];
//    showWebView.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"accelerometer" ofType:@"html"];
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [showWebView loadRequest:request];
    
    
    
//    timer =  [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    //每1秒运行一次function方法。
}

- (void)refresh{
    [showWebView stringByEvaluatingJavaScriptFromString:@"refreshData();"];
}

- (void)setItems:(NSMutableArray *)items{
    _items = items;
    [showWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"refreshData(%@,%@,%@);",items[0],items[1],items[2]]];
}

- (IBAction)operateClick:(UIButton *)sender {
    [self.delegate accelerometerView:self operateClick:sender];
}
@end
