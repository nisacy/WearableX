//
//  UITableView+MJRefreshEx.h
//  XLProjectDemo
//
//  Created by Shinsoft on 15/6/19.
//  Copyright (c) 2015年 Shinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "XLRefreshHeader.h"

@interface UIScrollView (MJRefreshEx)

/**
 *  普通的下拉刷新和上拉加载更多
 *
 *  @param refreshingBlock 
 */
- (void)headerRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock;
- (void)footerRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock;
- (void)headerRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)footerRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  GIF动画的下拉刷新和上拉加载更多
 *
 *  @param refreshingBlock
 */
- (void)headerGifRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock;
- (void)footerGifRefreshing:(MJRefreshComponentRefreshingBlock)refreshingBlock;
- (void)headerGifRefreshingTarget:(id)target refreshingAction:(SEL)action;
- (void)footerGifRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 *  开始所有刷新
 */
- (void)beginRefreshing;
/**
 *  下拉开始刷新
 */
- (void)beginHeaderRefreshing;
/**
 *  上拉开始刷新
 */
- (void)beginFooterRefreshing;

/**
 *  结束所有刷新
 */
- (void)endRefreshing;

/**
 *  结束顶部刷新
 */
- (void)endHeaderRefreshing;
/**
 *  结束底部刷新
 */
- (void)endFooterRefreshing;
/**
 *  结束底部刷新并显示无更多数据提示
 */
- (void)endRefreshingWithNoMoreData;
/**
 *  重置底部显示，隐藏无更多数据提示
 */
- (void)resetNoMoreData;

/**
 *  隐藏当前的上拉刷新控件
 */
- (void)hideFooter;
/**
 *  显示当前的上拉刷新控件
 */
- (void)showFooter;

@property (nonatomic, assign) BOOL isFooterRefresh;//是否执行的是上拉加载更多刷新

@end
