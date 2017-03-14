
//  QHBasicViewController.m
//  helloworld
//
//  Created by chen on 14/6/30.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "XLBaseViewController.h"
#import "XLBaseNavigationViewController.h"
#import "MainViewController.h"

#define kSecondsToShow  3.5
#define kShowAnimationDuration  0.2
#define kHideAnimationDuration  0.2

@interface XLBaseViewController ()
{
    
}

@end

@implementation XLBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseView];
}



//**************************************************************************

- (void)initBaseView{
    self.view.backgroundColor = k_color_main_bg;
    
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage" forHTTPHeaderField:@"AppName"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    
    if(kIOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        //把状态栏的颜色改为白色：在info.plist中添加一个字段：view controller -base status bar 设置为NO
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    
    if(self.navigationController.viewControllers.count>1){
//        [self addLeftNavigationImageButton:[UIImage imageNamed:@"nav_back"]];
    }
    
    
    
    if (kIOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    _dataManager = [DataManager getInstance];
    
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    _context = _appDelegate.managedObjectContext;
    
    [self initToolBar];
    
    //单击 view 事件
    [self initViewTapEvent];
    
}


- (void)go{
    
}


- (void)initViewTapEvent{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapClick:(UITapGestureRecognizer *)sender{
    DLog(@"tapClick");
}

- (void)showActivityIndicator{
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake((kScreenWidth - 30) / 2, kScreenHeight / 2, 30, 30);
    }
    [indicator startAnimating];
    [self.window addSubview:indicator];
}

- (void)hideActivityIndicator{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [[self navigationController] setNavigationBarHidden:YES];
    //UMeng统计开始
    //[MobClick beginLogPageView:@"PageOne"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [[self navigationController] setNavigationBarHidden:YES];
    //UMeng统计开始
    //[MobClick beginLogPageView:@"PageOne"];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //UMeng统计结束
    //[MobClick endLogPageView:@"PageOne"];
    
    if (indicator) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
    
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
    
}


- (void)initToolBar{
    //上下选择工具栏
    if (!keyboardToolbar) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        //        keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *previousBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"上一行", @"")
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(previousField:)];
        
        UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"下一行", @"")
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(nextField:)];
        
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil
                                                                                      action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"")
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[NSArray arrayWithObjects:spaceBarItem, spaceBarItem, spaceBarItem, doneBarItem, nil]];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            //iOS 5
            [keyboardToolbar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg"] forToolbarPosition:0 barMetrics:0];
        } else {
            //iOS 4
            [keyboardToolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_bg"]] atIndex:0];
        }
    }
}

#pragma mark -ToolBar
- (void)previousField:(id)sender{
    
}

- (void)nextField:(id)sender{
}

- (void)resignKeyboard:(id)sender{
    //    [self.view endEditing:YES];
}



- (void)viewDidLayoutSubviews
{
    
}

- (UIWindow *)window
{
    return [[UIApplication sharedApplication] keyWindow];
}


- (void)showAlertView:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)showAlertView:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)showAlertView:(NSString *)title Message:(NSString *)message Tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = tag;
    [alert show];
}

/**
 *  弹出框代理
 *
 *  @param alertView
 *  @param buttonIndex 0：确认退出，1：取消
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}


- (void)addLeftNavigationTitleButton:(NSString *)title
{
    UIBarButtonItem *leftButton = [self barButtonItem:title action:@selector(leftBarButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)addLeftNavigationImageButton:(UIImage *)image{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;//自定义返回按钮后，右滑返回失效；
    //    self.navigationItem.backBarButtonItem = leftButton;
    [button addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLeftNavigationImageButton:(UIImage *)image width:(NSInteger)width{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (width > 0?width : 30), 44)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButton;//自定义返回按钮后，右滑返回失效；
    //    self.navigationItem.backBarButtonItem = leftButton;
    [button addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLeftNavigationButton:(UIBarButtonSystemItem)style
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:self action:@selector(leftBarButtonClicked)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)addRightNavigationButton:(UIBarButtonSystemItem)style
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style target:self action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addRightNavigationTitleButton:(NSString *)title
{
    UIBarButtonItem *rightButton = [self barButtonItem:title action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addRightNavigationInfoButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRightNavigationImageButton:(UIImage *)image
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:image forState:UIControlStateNormal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addRightNavigationBarButton:(UIButton *)button{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = leftButton;
    [button addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (UIBarButtonItem *)barButtonItem:(NSString *)title action:(SEL)clicked
{
    float bWidth = [CommonMethod getLabelWidth:title WithFont:[UIFont boldSystemFontOfSize:15.0] withHeight:30];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bWidth, 30)];
//    button.cs_acceptEventInterval = 1.5f;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [button setTitleColor:k_color_white forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:clicked forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightBarButtonClicked { }
- (void)leftBarButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToNextController:(UIViewController *)viewController
{
//    [self.navigationController pushViewController:viewController animation:UIViewControllerTransitAnimationMoveIn fromLocation:UIViewControllerTransitFromRight];
    
    [self.navigationController pushViewController:viewController animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (kIOS7) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}


- (void)showAlertBannerInView:(UIButton *)button {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBannerPosition position = (ALAlertBannerPosition)button.tag;
//    ALAlertBannerStyle randomStyle = (ALAlertBannerStyle)(arc4random_uniform(4));
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.view style:randomStyle position:position title:@"温馨提示" subtitle:@"" tappedBlock:^(ALAlertBanner *alertBanner) {
//        NSLog(@"tapped!");
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
}

- (void)showSuccessWithStatus:(NSString *)subTitle {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:_appDelegate.window style:ALAlertBannerStyleSuccess position:ALAlertBannerPositionUnderNavBar title:subTitle subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
    
    [SVProgressHUD showSuccessWithStatus:subTitle];
}

- (void)showErrorWithStatus:(id)subTitle {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:_appDelegate.window style:ALAlertBannerStyleFailure position:ALAlertBannerPositionUnderNavBar title:subTitle subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
    
    if ([subTitle isKindOfClass:[NSNull class]]) {
        [SVProgressHUD showErrorWithStatus:@"请求异常"];
    } else {
        [SVProgressHUD showErrorWithStatus:subTitle];
    }
    
}

- (void)showWarningWithStatus:(NSString *)subTitle {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:_appDelegate.window style:ALAlertBannerStyleWarning position:ALAlertBannerPositionUnderNavBar title:subTitle subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
    
    [SVProgressHUD showInfoWithStatus:subTitle];
}

- (void)showNotifyWithStatus:(NSString *)subTitle {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:_appDelegate.window style:ALAlertBannerStyleNotify position:ALAlertBannerPositionUnderNavBar title:subTitle subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
    
    [SVProgressHUD showInfoWithStatus:subTitle];
}



//显示在状态栏下
- (void)showZWarningWithStatus:(NSString *)subTitle {
//    [[ALAlertBannerManager sharedManager] hideAllAlertBanners];
//    
//    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:_appDelegate.window style:ALAlertBannerStyleWarning position:ALAlertBannerPositionTop title:subTitle subtitle:nil tappedBlock:^(ALAlertBanner *alertBanner) {
//        [alertBanner hide];
//    }];
//    banner.secondsToShow = kSecondsToShow;
//    banner.showAnimationDuration = kShowAnimationDuration;
//    banner.hideAnimationDuration = kHideAnimationDuration;
//    [banner show];
}

- (void)presentLoginVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_go_login object:self userInfo:nil];
}

- (void)presentCompare
{
    [[NSNotificationCenter defaultCenter] postNotificationName:k_go_compare object:self userInfo:nil];
}



//*****************处理旋转屏幕*******************
// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations {
    
    return isPhone? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscape;
}
// 一开始的屏幕旋转方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return isPhone ? UIInterfaceOrientationPortrait : UIInterfaceOrientationLandscapeLeft;
}







@end
