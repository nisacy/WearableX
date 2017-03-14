//
//  XLBaseWebViewController.h
//  SHJLPM
//
//  Created by Shinsoft on 16/12/11.
//  Copyright © 2016年 SHJLPM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBaseViewController.h"

@interface XLBaseWebViewController : XLBaseViewController

@property (nonatomic, strong) id URL;

@property (nonatomic, strong) UIWebView *showWebView;

- (void)showLoading;

- (void)showError:(NSString *)error;

- (void)showContent;

-(void)notice:(NSNotification *) notification;
    
@end
