//
//  QHBasicViewController.h
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SVProgressHUD.h"
#import "NSObject+AutoDescription.h"
#import "DataManager.h"
#import "AppDelegate.h"
//#import "ALAlertBanner.h"
//#import "ALAlertBannerManager.h"
#import "CommonMethod.h"
//#import "UIButton+MultiClick.h"
#import "UIViewController+MMDrawerController.h"


@interface XLBaseViewController : UIViewController<UIAlertViewDelegate>
{
    DataManager *_dataManager;
    
    AppDelegate *_appDelegate;
    NSManagedObjectContext  *_context;
    UIActivityIndicatorView *indicator;//加载指示器
    
    UIToolbar *keyboardToolbar;
}

//**********************************************************************

@property (strong, nonatomic) UIWindow *window;

- (void)showAlertView:(NSString *)message;
- (void)showAlertView:(NSString *)title Message:(NSString *)message;
- (void)showAlertView:(NSString *)title Message:(NSString *)message Tag:(NSInteger)tag;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

- (void)addLeftNavigationTitleButton:(NSString *)title;
- (void)addLeftNavigationImageButton:(UIImage *)image;
- (void)addLeftNavigationImageButton:(UIImage *)image width:(NSInteger)width;
- (void)addLeftNavigationButton:(UIBarButtonSystemItem)style;
- (void)addRightNavigationButton:(UIBarButtonSystemItem)style;
- (void)addRightNavigationTitleButton:(NSString *)title;
- (void)addRightNavigationImageButton:(UIImage *)image;
- (void)addRightNavigationInfoButton;
- (void)addRightNavigationBarButton:(UIButton *)button;


- (void)rightBarButtonClicked;
- (void)leftBarButtonClicked;
- (void)tapClick:(UITapGestureRecognizer *)sender;

- (void)goToNextController:(UIViewController *)viewController;//导航到下一个controller

//消息提示
- (void)showSuccessWithStatus:(NSString *)subTitle;//成功提示
- (void)showErrorWithStatus:(NSString *)subTitle;//错误提示
- (void)showWarningWithStatus:(NSString *)subTitle;//警告提示
- (void)showNotifyWithStatus:(NSString *)subTitle;//通知提示

- (void)showZWarningWithStatus:(NSString *)subTitle;//警告提示


- (void)presentLoginVC;

//- (void)floatCompareView:(FloatCompareView *)floatView tapClick:(UITapGestureRecognizer *)sender;

@end
