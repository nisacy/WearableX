//
//  XLBaseTableViewContrller.m
//  MVVMDemo1
//
//  Created by Shinsoft on 16/7/22.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "XLBaseTableViewContrller.h"

#define CellIdentify @"UITableViewCell"

@interface XLBaseTableViewContrller ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    BOOL mIsLoadMore;
    NSString *errorMsg;
}



@end

@implementation XLBaseTableViewContrller

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
    [self initLayout];
    [self initData];
}

- (void)initView{
    //添加tableview
    _tableView = [UITableView new];
    _tableView.backgroundColor = k_color_main_bg;
    [self.view addSubview:_tableView];
    
    //设置相关代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    
    //去掉多余的行
    _tableView.tableHeaderView = [UIView new];
    _tableView.tableFooterView = [UIView new];
    
    if (self.registerCellClass!=nil && self.registerCellClass.count>0) {
        for (int i=0; i<self.registerCellClass.count; i++) {
            Class registerClass = [self.registerCellClass objectAtIndex:i];
            
            [_tableView registerClass:registerClass forCellReuseIdentifier:NSStringFromClass(registerClass)];
        }
    } else {
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentify];
    }
    
    _tableView.cellLayoutMarginsFollowReadableWidth = NO;  
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    //设置刷新
    if (self.hasRefresh) {
        //添加顶部上拉刷新组件
        [_tableView headerGifRefreshing:^{
            [self requestTableData:NO];
        }];
        //添加底部上拉加载更多组件
        [_tableView footerRefreshing:^{
            [self requestTableData:YES];
        }];
    }
    
    
    //表单请求数据为空或者失败(无数据源时)的占位视图
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self.tableView reloadEmptyDataSet];
}

/**
 *  布局约束
 */
- (void)initLayout{
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


/**
 *  数据处理
 */
- (void)initData{
    
    _items = [[NSMutableArray alloc] init];
    
    if(self.loadData && self.loadLocalData){//本地数据
        _items = self.localItems;
//        [_tableView reloadData];
        [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.1f];
        
    } else if (self.loadData && self.loadNetworkData) {//网络数据
        [self obtainData];
    } 
    
    
}

- (void)obtainData{
    [self requestTableData:NO];
}

- (void)reloadTableData{
    [_tableView reloadData];
}

- (BOOL)isLoadData{
    return YES;
}

- (BOOL)isLoadLocalData{
    return NO;
}

- (BOOL)isLoadNetworkData{
    return YES;
}

- (BOOL)isAutolayoutRowHeight{
    return YES;
}

int i=0;
/**
 *  数据请求
 *
 *  @param isLoadMore 是否上拉加载更多
 */
- (void)requestTableData:(BOOL)isLoadMore{
    
    mIsLoadMore = isLoadMore;
    
    BOOL isShowP = [self isShowProgress];
    if (!isShowP) {//当不显示指示器时，显示加载中占位图
        self.showType = 1;//加载中
    }
    
    
    [HttpHelper requestWithPrameters:[self requestParameter:isLoadMore] isShowProgress: isShowP finished:^(BaseResponse * _Nullable response) {
        
        [_tableView endRefreshing];
        
//        if (i == 1 || i==3) {
//            response.status = NO;
//            response.error = @"未知错误，请重试";
//        }
//        i++;
        
        if (response.status) {//成功
            
            [SVProgressHUD dismiss];
            
            
            [self reInitResponse:response];
            
            NSArray *tempItems;
            if ([self isArrayFromResponse]) {//是数组
                tempItems = [[self modelType] mj_objectArrayWithKeyValuesArray:response.result];
            } else {
                _responseResult = [[self modelType] mj_objectWithKeyValues:response.result];
                
                tempItems = [self reCombineData:_responseResult];
            }
            
            
            if (isLoadMore) {//下拉加载更多
                [_items addObjectsFromArray:tempItems];
                
                [self.tableView reloadData];
                
                if (tempItems.count<k_page_size) {//小于 k_page_size 时，说明数据已经加载完毕
                    [self.tableView endRefreshingWithNoMoreData];
                }
                
                if (tempItems.count < k_page_size) {
                    [self.tableView hideFooter];
                } else {
                    [self.tableView showFooter];
                }
            } else {
                _items = [[NSMutableArray alloc] initWithArray:tempItems];
                
                [self.tableView reloadData];
                
                if (_items.count < k_page_size) {
                    [self.tableView hideFooter];
                } else {
                    [self.tableView showFooter];
                }
            }
            
            if (_items == nil || _items.count <= 0) {
                self.showType = 2;
            } else {
                self.showType = 0;
            }
            
            
            
        } else {//失败
            if (_items == nil || _items.count <= 0) {//当数据源为空，请求失败时进行提示
                errorMsg = response.error;
                
                if ([errorMsg isEqualToString:K_Text_Http_NoNetwork]) {//无网络
                    self.showType = 4;
                } else {
                    self.showType = 3;
                }
                [SVProgressHUD dismiss];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",response.error]];
            }
        }
        
        [self requestDataFinish:response];
        
    }];
}

- (void)reInitResponse:(BaseResponse *)response{};

- (void)requestDataFinish:(BaseResponse *)response{};

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = self.group? _items.count : 1;
    return number;
}


- (BOOL) getVariableWithClass:(Class) myClass varName:(NSString *)name{    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.group) {
        
        if ([self isExpandInSection:section]) {//展开
            return [[_items objectAtIndex:section] items].count;
        } else {
            return 0;
        }
        
        
    } else {
        return _items.count;
    }
    
    
//    return self.group ? [[_items objectAtIndex:section] items].count : _items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.isCustomHeaderView ? nil : (self.group ? ((_items!=nil && _items.count>0) ? [[_items objectAtIndex:section] title] : nil):nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  self.group ? (self.headerHeight==0 ? 30.f:self.headerHeight):0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ( [[_items objectAtIndex:section] respondsToSelector: @selector(setIcon:)] ) {
        return self.isCustomHeaderView ? [self customeViewForHeaderInSection:section withData:[[_items objectAtIndex:section] title] icon:[[_items objectAtIndex:section] icon]]:nil;
    } else {
        return self.isCustomHeaderView ? [self customeViewForHeaderInSection:section withData:[[_items objectAtIndex:section] title] icon:nil]:nil;
    }
    
    
}

#import <UITableView+FDTemplateLayoutCell.h>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.registerCellClass!=nil && self.registerCellClass.count>1) {
        
        //根据获取的数据结合 indexpath 来处理高度
        id data = self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row];
        CGFloat rowHeight = [self cellHeightFromTableView:tableView atIndexPath:indexPath withData:data];
        
        return rowHeight;
        
        
    } else if (self.registerCellClass!=nil && self.registerCellClass.count == 1) {
        
        CGFloat rowHeight;
        if (self.isAutolayoutRowHeight) {
            //根据获取的数据结合 indexpath 来处理高度
            id data = self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row];
            
            DLog(@"section:%ld,Row:%ld",indexPath.section,indexPath.row);
            
            rowHeight = [tableView fd_heightForCellWithIdentifier:NSStringFromClass(self.registerCellClass[0]) cacheByIndexPath:indexPath configuration:^(id cell) {
                // 配置 cell 的数据源，和 "cellForRow" 干的事一致：
                [self configCell:cell atIndexPath:indexPath withData: data];
            }];
        } else {
            CGFloat rowHeight = [self cellHeightFromTableView:tableView atIndexPath:indexPath withData:nil];
            
            return rowHeight;
        }
        
        
        
        return rowHeight+1.0f;
    } else {
        
        return [tableView fd_heightForCellWithIdentifier:CellIdentify cacheByIndexPath:indexPath configuration:^(id cell) {
            // 配置 cell 的数据源，和 "cellForRow" 干的事一致：
            [self configCell:cell atIndexPath:indexPath withData: self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row]];
        }];
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.registerCellClass!=nil && self.registerCellClass.count>1) {
        
        //根据获取的数据结合 indexpath，来设置对应的 Cell
        id data = self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row];
        
        return [self cellFromTableView:tableView atIndexPath:indexPath withData:data];
    } else  if (self.registerCellClass!=nil && self.registerCellClass.count == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.registerCellClass[0])];
        
        [self configCell:cell atIndexPath:indexPath withData: self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row]];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
        }
        [self configCell:cell atIndexPath:indexPath withData: self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row]];
        return cell;
    }
    
    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self didSelectRowAtIndexPath:indexPath withData:self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row]];
}


/**
 *  是否有刷新需求
 *
 *  @return 默认 NO
 */
- (BOOL)isHasRefresh{
    return NO;
}

/**
 *  请求参数
 *
 *  @param isLoadMore  是否上拉加载更多
 *
 *  @return 默认返回一个空的请求对象
 */
- (id)requestParameter:(BOOL)isLoadMore{
    return [[BaseRequest alloc] init];
}

/**
 *  是否显示指示器
 *
 *  @return 默认返回 NO
 */
- (BOOL)isShowProgress{
    return NO;
}

/**
 *  返回结果是否是数组，如果是数组就不用再处理
 *
 *  @return 默认 YES
 */
- (BOOL)isArrayFromResponse{
    return YES;
}

/**
 *  json字符串对应的实体类
 *
 *  @return
 */
- (Class)modelType{
    return [NSObject class];
}

/**
 *  如果返回的结果不满足数据源，则需要重新组合需要的数组
 *
 *  @param result 请求结果对象
 *
 *  @return 返回临时数组
 */
- (NSArray *)reCombineData:(id)result{
    return [NSArray new];
}

/**
 *  是否分组
 *
 *  @return  默认返回 NO
 */
- (BOOL)isGroup{
    return NO;
}


/**
 *  注册 Cell 类
 *
 *  @return
 */
- (NSArray *)registerCellClass{
    return [NSArray arrayWithObjects:[UITableViewCell class], nil];
}

//- (Class)registerCellClass{
//    return [UITableViewCell class];
//}

/**
 *  是否自定义分组的头视图
 */
- (BOOL)isCustomHeaderView{
    return NO;
}

- (BOOL)isExpandInSection:(NSInteger)section{
    return YES;
}

/**
 *  自定义分组的头视图
 *
 *  @param section 分组
 *  @param title  分组的数据
 *
 *  @return
 */
- (UIView *)customeViewForHeaderInSection:(NSInteger)section withData:(id)title icon:(NSString *)iconUrl{
    return nil;
}


/**
 *  计算不同类型的 Cell 高度
 *
 *  @param tableView
 *  @param indexPath
 *  @param data
 *
 *  @return
 */
- (CGFloat)cellHeightFromTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withData:(id)data{
    return 44.0f;
}

/**
 *   多 cell 处理，返回不同类型的 Cell
 *
 *  @param tableView
 *  @param indexPath
 *  @param data
 *
 *  @return
 */
- (UITableViewCell *)cellFromTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withData:(id)data{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify];
    }
    
    [self configCell:cell atIndexPath:indexPath withData: self.group ? [[[_items objectAtIndex:indexPath.section] items] objectAtIndex:indexPath.row] : [_items objectAtIndex:indexPath.row]];
    return cell;
}

/**
 *  初始化 Cell 相关参数、事件
 *
 *  @param cell
 *  @param indexPath
 *  @param item
 */
- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(id)item{
    
}

/**
 *  选择某行数据
 *
 *  @param indexPath
 *  @param item
 */
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(id)item{
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    else {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


- (void)setShowType:(NSInteger)showType
{
    if (_showType == showType) {
        return;
    }
    
    _showType = showType;
    
    [self.tableView reloadEmptyDataSet];
}

#pragma mark - DZNEmptyDataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *tempTitle;
    switch (_showType) {
        case 0:
            tempTitle = @"";
            break;
        case 1:
            tempTitle = @"";
            break;
        case 2:
             tempTitle = @"";
            break;
        case 3:
            tempTitle = @"";
            break;
        case 4:
            tempTitle = @"";
            break;
            
        default:
            break;
    }
    
    NSString *title = [self titleForEmptyDataSet:scrollView showType:_showType];
    if (!title) {
        title = tempTitle;
    }
    
    return title ? [[NSAttributedString alloc] initWithString:title] : nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *tempTitle;
    switch (_showType) {
        case 0:
            tempTitle = @"";
            break;
        case 1:
            tempTitle = @"加载中";
            break;
        case 2:
            tempTitle = @"无数据";
            break;
        case 3:
            tempTitle = errorMsg ? errorMsg : @"请求失败，请重试";
            break;
        case 4:
            tempTitle = @"无网络";
            break;
        case 5:
            tempTitle = @"请输入查询条件";
            break;
            
        default:
            break;
    }
    
    NSString *title = [self descriptionForEmptyDataSet:scrollView showType:_showType];
    if (!title) {
        title = tempTitle;
    }
    
    return title ? [[NSAttributedString alloc] initWithString:title] : nil;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    //1:加载中，2：无数据 3：请求数据失败 4:无网络 5：提示
    if (_showType == 0) {
        return [UIImage new];
    } else if (_showType == 1) {//加载中
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    } else if(_showType == 2) {//无数据
        return [UIImage imageNamed:@"default_hint_no_data"];
    } else if(_showType == 3) {//请求失败
        return [UIImage imageNamed:@"default_hint_error"];
    }  else if(_showType == 4) {//无网络
        return [UIImage imageNamed:@"default_hint_no_network"];
    }  else {
        NSString *imageName = [NSString stringWithFormat:@"default_img"];
        return [UIImage imageNamed:imageName];
    }
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}


//
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIColor  whiteColor];
}


- (NSString *)titleForEmptyDataSet:(UIScrollView *)scrollView showType:(NSInteger)showType {
    return nil;
}

- (NSString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView showType:(NSInteger)showType {
    return nil;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return _showType>0 ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return (_showType == 3 ||  _showType == 4) ? YES : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return _showType == 1 ? YES : NO;//只有加载时动画
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.showType = 1;
    //重新请求数据
    [self requestTableData:mIsLoadMore];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.showType = 1;
    
    //重新请求数据
    [self requestTableData:mIsLoadMore];
}


@end
