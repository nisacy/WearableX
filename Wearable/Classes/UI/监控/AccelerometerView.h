//
//  AccelerometerView.h
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccelerometerView;
@protocol AccelerometerViewDelegate <NSObject>

- (void)accelerometerView:(AccelerometerView *)accelerometerView operateClick:(UIButton *)sender;

@end

@interface AccelerometerView : UIView
@property (weak, nonatomic) IBOutlet UIWebView *showWebView;
@property (weak, nonatomic) IBOutlet UIButton *operateBtn;

@property (nonatomic, strong) NSMutableArray *items;

- (IBAction)operateClick:(UIButton *)sender;

@property (nonatomic, assign) id<AccelerometerViewDelegate> delegate;
@end
