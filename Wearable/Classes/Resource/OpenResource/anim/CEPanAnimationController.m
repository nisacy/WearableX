//
//  CEPanAnimationController.m
//  TransitionsDemo
//
//  Created by Alvin Zeng on 01/08/2014.
//  Copyright (c) 2014 Alvin Zeng. All rights reserved.
//

#import "CEPanAnimationController.h"
#define k_move -150
#define k_orgin_x kAppWidth

@implementation CEPanAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if (self.isValid) {
        return;
    }
    
    
    self.duration = .38;
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = CGRectMake(self.reverse ? k_move : k_orgin_x, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    UIView *view = [[UIView alloc] initWithFrame:fromView.bounds];
    view.backgroundColor = RGBA(0, 0, 0, self.reverse?0.3:0);
    if (self.reverse) {
        [toView addSubview:view];
        [toView bringSubviewToFront:view];
    } else {
        [fromView addSubview:view];
        [fromView bringSubviewToFront:view];
    }
    
    
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(!self.reverse ? k_move : k_orgin_x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        
        view.backgroundColor = RGBA(0, 0, 0, self.reverse?0:0.3);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
            fromView.frame = CGRectMake(!self.reverse ? k_move : k_orgin_x, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
