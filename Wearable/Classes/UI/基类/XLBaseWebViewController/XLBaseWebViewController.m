//
//  XLBaseWebViewController.m
//  SHJLPM
//
//  Created by Shinsoft on 16/12/11.
//  Copyright © 2016年 SHJLPM. All rights reserved.
//

#import "XLBaseWebViewController.h"
#import "NJKWebViewProgressView.h"
#import "UIScrollView+EmptyDataSet.h"


@interface XLBaseWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>{
    
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    UIView *hintView;
    UILabel *hintLabel;
}

@end

@implementation XLBaseWebViewController
@synthesize showWebView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = k_color_gray_90;
    
    showWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:showWebView];
    showWebView.delegate = self;
    showWebView.scalesPageToFit = YES;
    showWebView.allowsInlineMediaPlayback = YES;
    showWebView.scrollView.bounces = NO;
    showWebView.opaque = NO; //不设置这个值 页面背景始终是白色
    showWebView.backgroundColor = [UIColor clearColor];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    showWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, kAppHeight - 51.0f,kAppWidth, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    hintView = [[UIView alloc] initWithFrame:self.view.bounds];
    hintView.backgroundColor = k_color_gray_80;
    UIImageView *hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kAppWidth-140)/2.f, (kAppHeight-250)/2.f, 140, 90)];
    hintImageView.image = [UIImage imageNamed:@"logo_jl"];
    [hintView addSubview:hintImageView];
    
    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, hintImageView.width, 44)];
    setXYWithAboveView(hintLabel, 0, 20, hintImageView);
//    hintLabel.text = @"无网络\n请检查后重试";
//    hintLabel.text = @"网络异常\n请重试";
    hintLabel.text = @"加载中...";
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.font = [UIFont systemFontOfSize:18.f];
    hintLabel.textColor = k_color_white;
    hintLabel.numberOfLines = 0;
    [hintView addSubview:hintLabel];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [hintView addGestureRecognizer:singleTap];
    
    
    [self.view addSubview:hintView];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:_progressView];
    [self.view bringSubviewToFront:_progressView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"SelectIndex" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectIndex" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    if (showWebView.isLoading) {
        return;
    }
    
    if (IsNilString(showWebView.request.URL.absoluteString)) {
        if ([_URL isKindOfClass:[NSString class]]) {
            [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
        } else if([_URL isKindOfClass:[NSURL class]]){
            [showWebView loadRequest:[NSURLRequest requestWithURL:_URL]];
        }
    } else {
        [showWebView reload];
    }
}

    
- (void)setURL:(id)URL{
    _URL = URL;
    if ([URL isKindOfClass:[NSString class]]) {
        [showWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
    } else if([URL isKindOfClass:[NSURL class]]){
        [showWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
}
    
    
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [SVProgressHUD show];
    [self showLoading];
}
    
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [SVProgressHUD dismiss];
    [self showContent];
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    self.reloadBtn.hidden = NO;
//    [SVProgressHUD dismiss];
    [_progressView setProgress:1.0f animated:YES];
    [self showError:error.localizedDescription];
}
    
    
- (IBAction)goToReload:(UIButton *)sender {
//    self.reloadBtn.hidden = YES;
    [showWebView reload];
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
//    if (progress>=0.1) {
//        [self showContent];
//    }
}

- (void)showLoading{
    hintView.hidden = NO;
    hintLabel.text = @"加载中...";
}

- (void)showError:(NSString *)error{
    hintView.hidden = NO;
    hintLabel.text = error;
}

- (void)showContent{
    hintView.hidden = YES;
}


-(void)notice:(NSNotification *) sender{
//    if (self.showWebView.canGoBack) {
//        [self.showWebView goBack];
//    }
    
    NSString *index = sender.object;
    if ([@"0" isEqualToString:index]) {
        self.URL = [NSString stringWithFormat:@"http://www.shjlpm.net?tk=%@",_dataManager.token];
    } else if ([@"1" isEqualToString:index]) {
        self.URL = @"http://www.shjlpm.net/pages/paimai/index.aspx";
    } else if ([@"2" isEqualToString:index]) {
        self.URL = @"http://www.shjlpm.net/pages/mship/index.aspx";
    }
}

@end
