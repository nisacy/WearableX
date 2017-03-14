//
//  TemperatureView.h
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureView : UIView

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIWebView *showWebView;

@property (nonatomic, assign) CGFloat temperature;

@end
