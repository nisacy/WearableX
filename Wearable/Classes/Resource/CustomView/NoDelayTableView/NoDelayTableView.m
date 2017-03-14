//
//  NoDelayTableView.m
//  XLShop
//
//  Created by Shinsoft on 15/12/18.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import "NoDelayTableView.h"

@implementation NoDelayTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [self cancelDelay];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self cancelDelay];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self cancelDelay];
        
    }
    return self;
}

- (void)cancelDelay{
    self.delaysContentTouches = NO;
    
    // iterate over all the UITableView's subviews
    for (id view in self.subviews)
    {
        // looking for a UITableViewWrapperView
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]){
            // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
            if([view isKindOfClass:[UIScrollView class]])
            {
                // turn OFF delaysContentTouches in the hidden subview
                UIScrollView *scroll = (UIScrollView *) view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]])
    {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
