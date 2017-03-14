//
//  STFrontModal.m
//  STModalDemo
//
//  Created by zhenlintie on 15/8/14.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STFrontModal.h"

@interface STModal (STFrontModal)

@property (strong, nonatomic) UIView *containerView;

@end

@interface STFrontModal ()



@end

@implementation STFrontModal

+ (instancetype)sharedFrontModal{
    static STFrontModal *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[STFrontModal alloc] _init];
    });
    return _shared;
}

- (instancetype)_init{
    if (self = [super init]){
        _modal = [STModal new];
        _modal.hideWhenTouchOutside = YES;
        _modal.positionMode = STModelPositionCenterBottom;
        _modal.showAnimation = [self showAnimation];
        _modal.hideAnimation = [self hideAnimation];
    }
    return self;
}

- (instancetype)init{
    return [[self class] sharedFrontModal];
}

+ (void)showView:(UIView *)view animated:(BOOL)animated{
    [[self sharedFrontModal] showView:view animated:animated];
}

+ (void)hide:(BOOL)animated{
    [[self sharedFrontModal] hide:animated];
}

- (void)showView:(UIView *)view animated:(BOOL)animated{
    [_modal showContentView:view animated:animated];
}

- (void)hide:(BOOL)animated{
    [_modal hide:animated];
}

- (st_modal_animation)showAnimation{
    return ^CGFloat(){
        _modal.contentView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(_modal.contentView.frame));
        
        CGFloat d = 0.35;
        [UIView animateWithDuration:d
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _modal.contentView.transform = CGAffineTransformIdentity;
//                             [self keyWindow].transform = CGAffineTransformMakeScale(0.85, 0.85);
                             
                             //设置弹出框下的视图动画
                             [[self keyWindow].layer addAnimation:[self animationGroup:NO andDuration:0.3f] forKey:@"aniStart"];
                         }
                         completion:nil];
        return d;
    };
}

- (st_modal_animation)hideAnimation{
    return ^CGFloat(){
        CGFloat d = 0.35f;
        [UIView animateWithDuration:d
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _modal.contentView.transform = CGAffineTransformMakeTranslation(0.0f, CGRectGetHeight(_modal.contentView.frame)+5);
                             [self keyWindow].transform = CGAffineTransformIdentity;
                             [[self keyWindow].layer addAnimation:[self animationGroup:NO andDuration:0.3f] forKey:@"aniEnd"];
                         }
                         completion:nil];
        return d;
    };
}

- (UIWindow *)keyWindow{
    return [UIApplication sharedApplication].keyWindow;
}




- (CAAnimationGroup*)animationGroup:(BOOL)isBegain andDuration:(CFTimeInterval)duration {
    
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0 / -900;
    t1 = CATransform3DScale(t1, 0.7, 0.7, 1);
    t1 = CATransform3DRotate(t1, 0.0f * M_PI / 180.0f, 1, 0, 0);
    t1 = CATransform3DTranslate(t1, 0, 0, 0);
    
    CATransform3D t3 = CATransform3DIdentity;
    t3.m34 = 1.0 / -6000;
    t3 = CATransform3DScale(t3, 0.95, 0.95, 1);
    t3 = CATransform3DRotate(t3, 10.0f * M_PI / 180.0f, 1, 0, 0);
    t3 = CATransform3DTranslate(t3, 0, 0.5, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    double scale = 0.8;
    
    t2 = CATransform3DTranslate(
                                t2, 0, [[UIScreen mainScreen] bounds].size.height * -0.08, 0);
    t2 = CATransform3DScale(t2, scale, scale, 1);
    
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation3 =
    [CABasicAnimation animationWithKeyPath:@"transform"];
    animation3.toValue = [NSValue valueWithCATransform3D:t3];
    animation3.duration = duration*2;
    animation3.fillMode = kCAFillModeForwards;
    animation3.removedOnCompletion = NO;
    [animation3 setTimingFunction:[CAMediaTimingFunction
                                   functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    
    CABasicAnimation *animation2 =
    [CABasicAnimation animationWithKeyPath:@"transform"];
    //    animation2.toValue = [NSValue
    //    valueWithCATransform3D:(isBegain?t2:CATransform3DIdentity)];
    //    animation2.beginTime = animation.duration;
    animation2.toValue = [NSValue valueWithCATransform3D:(CATransform3DIdentity)];
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration * 3];
    [group setAnimations:isBegain ? @[ animation,animation3 ] : @[ animation2 ]];
    return group;
    
    
}


@end
