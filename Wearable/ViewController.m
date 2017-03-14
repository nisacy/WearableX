//
//  ViewController.m
//  Wearable
//
//  Created by Shinsoft on 17/1/26.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100,44)];
    [button setTitle:@"Test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onclick{
    NextViewController *controller = [[NextViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
