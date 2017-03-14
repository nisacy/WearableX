//
//  XLRefreshHeader.m
//  XLShop
//
//  Created by Shinsoft on 15/12/11.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import "XLRefreshHeader.h"

@interface XLRefreshHeader()

@property (weak, nonatomic) UIImageView *logoView;

@end

@implementation XLRefreshHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)prepare
{
    [super prepare];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_logoView = logoView];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}


- (void)placeSubviews
{
    [super placeSubviews];
    
    
    self.logoView.bounds = CGRectMake(0, 0, self.bounds.size.width,100);
//    self.logoView.backgroundColor = [UIColor greenColor];
    self.logoView.center = CGPointMake(self.mj_w * 0.5, - self.logoView.mj_h + 20);
}


@end
