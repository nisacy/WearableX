//
//  XLNavigationController.m
//  CustomTabBar
//
//  Created by Shinsoft on 15/7/8.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import "XLBaseNavigationViewController.h"
#import "UINavgationBar+DropShadow.h"


// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


#define k_nav_title_color RGBCOLOR(255,255,255)


@interface XLBaseNavigationViewController ()

@end

@implementation XLBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    [self setupNavBarTheme];
    
    // 2.设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置导航栏按钮主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
    if (!iOS7) {
        [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
    
    // 设置按钮文字属性--图片的颜色不能更改
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = iOS7 ? [UIColor orangeColor] : [UIColor whiteColor];
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:iOS7 ? 14 : 12];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    if (!iOS7) {
        [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    //设置系统自带的按钮字体颜色
    navBar.tintColor = [UIColor whiteColor];
    //设置导航栏不透明，默认 YES 为半透明
    navBar.translucent = YES;
    //设置导航栏背景色
    //1、颜色
    [navBar setBarTintColor:k_color_nav_bg];
    //2、图片，导航栏的高度从ios6的44 points(88 pixels)变为了ios7的64 points(128 pixels)
//    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    //设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = k_nav_title_color;//标题颜色
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];//标题字体大小
    [navBar setTitleTextAttributes:textAttrs];
    
    
    
//    [navBar dropShadowWithOffset:CGSizeMake(0, 3) radius:1.0f color:[UIColor darkGrayColor] opacity:1.0f];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
//- (BOOL)hidesBottomBarWhenPushed {
//    return [self.navigationController.visibleViewController isEqual:self];
//}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //再此添加不能右划返回页面
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (viewController.class == NSClassFromString(@"MyOrderDetailViewController"))
        {
            self.interactivePopGestureRecognizer.enabled = NO;
        } else {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}


- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *temps = [super popToRootViewControllerAnimated:animated];
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarVC resetView];
    return temps;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSArray *temps = [super popToViewController:viewController animated:animated];
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarVC resetView];
    return temps;
}

@end
