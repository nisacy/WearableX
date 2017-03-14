//
//  UITableView+MJRefreshEx.m
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/19.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import "UIScrollView+MJRefreshEx.h"

@implementation UIScrollView (MJRefreshEx)

- (void)headerRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
}

- (void)footerRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        refreshingBlock();
    }];
}


- (void)headerRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)footerRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}


- (void)headerGifRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    self.mj_header = [XLRefreshHeader headerWithRefreshingBlock:^{
        refreshingBlock();
    }];
    
}

- (void)footerGifRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        refreshingBlock();
    }];
}

- (void)headerGifRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.mj_header = [XLRefreshHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)footerGifRefreshingTarget:(id)target refreshingAction:(SEL)action{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}


- (void)beginRefreshing;{
    [self.mj_header beginRefreshing];
    [self.mj_footer beginRefreshing];
}

- (void)beginHeaderRefreshing{
    [self.mj_header beginRefreshing];
}

- (void)beginFooterRefreshing{
    [self.mj_footer beginRefreshing];
}


- (void)endRefreshing{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)endHeaderRefreshing{
    [self.mj_header endRefreshing];
}
- (void)endFooterRefreshing{
    [self.mj_footer endRefreshing];
}

- (void)endRefreshingWithNoMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData{
    [self.mj_footer resetNoMoreData];
}

- (void)hideFooter{
    self.mj_footer.hidden = YES;
}
- (void)showFooter{
    self.mj_footer.hidden = NO;
}

- (BOOL)isFooterRefresh{
    return self.mj_footer.isRefreshing;
}

@end
