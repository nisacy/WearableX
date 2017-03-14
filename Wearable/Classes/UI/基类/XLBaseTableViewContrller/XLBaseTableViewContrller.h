//
//  XLBaseTableViewContrller.h
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/22.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLBaseViewController.h"

@interface XLBaseTableViewContrller : XLBaseViewController

@property (nonatomic, strong) UITableView * _Nullable tableView;//表单
@property (nonatomic, strong) NSMutableArray * _Nullable items;//数据源
@property (nonatomic, strong) id _Nullable responseResult;//请求结果


/**
 *  是否进入此界面就开始加载数据，默认YES（加载数据）
 */
@property (nonatomic, assign,getter=isLoadData) BOOL loadData;

/**
 *  是否加载本地数据,默认为 NO （不加载本地数据）
 */
@property (nonatomic, assign,getter=isLoadLoacalData) BOOL loadLocalData;

/**
 *  是否加载网络数据,默认为 YES （加载网络数据）
 */
@property (nonatomic, assign,getter=isLoadNetworkData) BOOL loadNetworkData;

/**
 *  手动调请求数据的方法
 */
- (void)obtainData;

/**
 *  是否有刷新需求
 */
@property (nonatomic, assign,getter=isHasRefresh) BOOL hasRefresh;

/**
 *  获取本地数据
 */
@property (nonatomic, strong) NSMutableArray  * _Nullable localItems;

/**
 *  请求参数
 */
- (id _Nullable)requestParameter:(BOOL)isLoadMore;

/**
 *  是否显示指示器
 */
@property (nonatomic, assign,getter=isShowProgress) BOOL showProgress;

/**
 *  返回结果是否是数组，如果是数组就不用再处理
 */
@property (nonatomic,assign,getter=isArrayFromResponse) BOOL arrayFromResponse;

/**
 *  json字符串对应的实体类
 */
@property (nonatomic, assign) Class _Nullable modelType;

/**
 *  是否分组
 */
@property (nonatomic, assign,getter=isGroup) BOOL group;


/**
 *  如果返回的结果不满足数据源，则需要重新组合需要的数组
 */
- (NSArray * _Nullable)reCombineData:(id _Nullable)result;


/**
 *  重新对请求的数据进行处理
 *
 *  @param response response description
 */
- (void)reInitResponse:(BaseResponse * _Nullable)response;
/**
 *  请求数据处理完毕后的处理
 */
- (void)requestDataFinish:(BaseResponse * _Nullable)response;


/**
 *  是否自定义分组的头视图 默认 NO
 */
@property (nonatomic, assign,getter=isCustomHeaderView) BOOL customHeaderView;


/**
 *  头高度，默认30
 */
@property (nonatomic, assign) CGFloat headerHeight;

/**
 *  分组时，对应的组是否展开,默认展开
 *
 *  @param section
 */
- (BOOL)isExpandInSection:(NSInteger)section;

/**
 *  自定义分组的头视图
 *
 *  @param section 分组
 *  @param title  分组的数据
 *
 *  @return
 */
//- (UIView * _Nullable)customeViewForHeaderInSection:(NSInteger)section withData:(id _Nullable)title;

- (UIView * _Nullable)customeViewForHeaderInSection:(NSInteger)section withData:(id _Nullable)title icon:(NSString * _Nullable)iconUrl;


/**
 *  注册 Cell 类
 *
 *  @return
 */
@property (nonatomic, strong) NSArray * _Nullable registerCellClass;
//@property (nonatomic, assign) Class _Nullable registerCellClass;


@property (nonatomic, assign,getter=isAutolayoutRowHeight) BOOL autolayoutRowHeight;

/**
 *  计算不同类型的 Cell 高度
 *
 *  @param tableView
 *  @param indexPath
 *  @param data
 *
 *  @return
 */
- (CGFloat)cellHeightFromTableView:(UITableView * _Nullable)tableView atIndexPath:(NSIndexPath * _Nullable)indexPath withData:(id _Nullable)data;

/**
 *   多 cell 处理，返回不同类型的 Cell
 *
 *  @param tableView
 *  @param indexPath
 *  @param data
 *
 *  @return
 */
- (UITableViewCell * _Nullable)cellFromTableView:(UITableView * _Nullable)tableView atIndexPath:(NSIndexPath * _Nullable)indexPath withData:(id _Nullable)data;

/**
 *  初始化 Cell 相关参数、事件
 */
- (void)configCell:(UITableViewCell * _Nullable)cell atIndexPath:(NSIndexPath * _Nullable)indexPath withData:(id _Nullable)item;

/**
*  选择某行数据
*
*  @param indexPath
*  @param item
*/
- (void)didSelectRowAtIndexPath:(NSIndexPath * _Nullable)indexPath withData:(id _Nullable)item;


- (void)scrollViewDidScroll:(UIScrollView * _Nullable)scrollView;



//*******************表单请求数据为空或者请求失败(数据为空时)的占位处理
//@property (nonatomic, getter=isLoading) BOOL loading;//是否加载中
@property (nonatomic, assign) NSInteger showType;//0:什么也不处理，1:加载中，2：无数据 3：请求数据失败 4:无网络  5：提示
- (NSString * _Nullable)titleForEmptyDataSet:(UIScrollView * _Nullable)scrollView showType:(NSInteger)showType;

- (NSString * _Nullable)descriptionForEmptyDataSet:(UIScrollView * _Nullable)scrollView showType:(NSInteger)showType;

@end
