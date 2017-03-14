//
//  ScreeningView.h
//  XLShop
//
//  Created by Shinsoft on 15/10/13.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreeningModel.h"


@class ScreeningView;
@protocol ScreeningViewDelegate <NSObject>

- (void)screeningView:(ScreeningView *)screeningView didSelectIndex:(NSInteger)index isAsc:(BOOL)isAsc;

@end

@interface ScreeningView : UIView

@property (nonatomic, strong) NSArray *screenings;

@property (nonatomic, assign) id<ScreeningViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame items:(NSArray *)screenings;
- (void)resetView;

@end
