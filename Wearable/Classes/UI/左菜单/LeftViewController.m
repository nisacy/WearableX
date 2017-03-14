//
//  LeftViewController.m
//  Wearable
//
//  Created by Shinsoft on 17/1/28.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "LeftViewController.h"
#import "MenuItem.h"

@interface LeftViewController (){
    NSInteger selectRow;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.hidden = YES;
    
    
    [self initLayoutView];
    
    [self initObserver];
}

- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:K_Text_Key_Left_Menu_Change object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender.userInfo[@"index"]);
    
    NSString *index = sender.object;
    if ([@"1" isEqualToString:index]) {
        if (self.items.count>2) {
            selectRow = 0;
            [self.items removeObjectAtIndex:1];
            [self.tableView reloadData];
        }
    } else {
        if (self.items.count<3) {
            selectRow = 0;
            MenuItem *item1 = [[MenuItem alloc] init];
            item1.name = @"Settings";
            item1.index = 1;
            item1.default_icon = @"settings_icon";
            item1.active_icon = @"settings_active_icon";
            
            [self.items insertObject:item1 atIndex:1];
            
            [self.tableView reloadData];
        }
        
    }
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onClick{
//    [self goToNextController:[[LoginViewController alloc] init]];
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"index", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Text_Key_Left_Menu object:dict];
}








- (void)initLayoutView{
    //添加菜单
    [self addRightNavigationImageButton:[UIImage imageNamed:@"nav_setting"]];
    
    self.view.backgroundColor = k_color_nav_bg;
    //添加表头
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth-150, (kAppWidth-150)*5/8 + 30)];
    headerView.backgroundColor = k_color_gray_90;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 55, kAppWidth-150 - 30 - 80, (kAppWidth-150 - 30 - 80)*5/8)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:@"atmel_logo"];
    
    
    [headerView addSubview:imageView];
    
    self.tableView.tableHeaderView = headerView;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/**
 *  是否加载本地数据
 *
 *  @return  YES
 */
- (BOOL)isLoadLoacalData{
    return YES;
}

/**
 *  如果加载本地数据，需要返回本地的数据
 *
 *  @return
 */
- (NSMutableArray *)localItems{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    MenuItem *item0 = [[MenuItem alloc] init];
    item0.name = @"AVR IoT Nodes";
    item0.index = 0;
    item0.default_icon = @"node_icon";
    item0.active_icon = @"node_active_icon";
    
    [items addObject:item0];
    
//    MenuItem *item1 = [[MenuItem alloc] init];
//    item1.name = @"Settings";
//    item1.index = 1;
//    item1.default_icon = @"settings_icon";
//    item1.active_icon = @"settings_active_icon";
//    
//    [items addObject:item1];
    
    MenuItem *item2 = [[MenuItem alloc] init];
    item2.name = @"About";
    item2.index = 2;
    item2.default_icon = @"about_icon";
    item2.active_icon = @"about_active_icon";
    
    [items addObject:item2];
    
    return items;
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
 *  @return  默认返回一个空对象
 */
- (id)requestParameter:(BOOL)isLoadMore{
    BaseRequest *baseRequest = [[BaseRequest alloc] init];
    baseRequest.requestMethod = REQUEST_GET;
    return baseRequest;
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
 *  返回json字符串对应的实体类
 *
 *  @return
 */
- (Class)modelType{
    return [MenuItem class];
}

/**
 *  如果返回的结果不满足数据源，则需要重新组合需要的数组
 *
 *  @param result 请求结果对象
 *
 *  @return 返回临时数组
 */
//- (NSArray *)reCombineData:(MainModel *)result{
//    //判断是否分组
//    if (self.group) {//是分组的话，组合成 GroupModel 数组
//        NSMutableArray *groups = [[NSMutableArray alloc] init];
//
//        for (int i=0; i<result.list.count; i++) {
//            ImageType *imageType = [result.list objectAtIndex:i];
//
//            GroupModel *groupModel = [[GroupModel alloc] init];
//            groupModel.title = imageType.name;
//            groupModel.items = imageType.list;
//
//            [groups addObject:groupModel];
//        }
//
//        return groups;
//
//    } else {
//        return result.list;
//    }
//
//}


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



/**
 *  是否自定义分组的头视图
 */
- (BOOL)isCustomHeaderView{
    return NO;
}

/**
 *  自定义分组的头视图
 *
 *  @param section 分组
 *  @param title  分组的数据
 *
 *  @return
 */
- (UIView *)customeViewForHeaderInSection:(NSInteger)section withData:(id)title  icon:(NSString *)iconUrl{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    return label;
}

- (BOOL)isAutolayoutRowHeight{
    return NO;
}

/**
 *  计算不同类型的 Cell 高度 默认高度44.0f
 *
 *  @param tableView
 *  @param indexPath
 *  @param data
 *
 *  @return
 */
- (CGFloat)cellHeightFromTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withData:(id)data{
    return 60.f;
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
    
    return [super cellFromTableView:tableView atIndexPath:indexPath withData:data];
}

/**
 *  初始化 Cell 相关参数、事件
 *
 *  @param cell
 *  @param indexPath
 *  @param item
 */
- (void)configCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(MenuItem *)item{
    if (selectRow==indexPath.row) {
        cell.imageView.image = [UIImage imageNamed: item.active_icon];
        cell.textLabel.textColor = RGBCOLOR(51, 119, 188);
    } else {
        cell.imageView.image = [UIImage imageNamed:item.default_icon];
        cell.textLabel.textColor = RGBCOLOR(88, 88, 91);
    }
    
    cell.textLabel.text = item.name;
}


/**
 *  选择某行数据
 *
 *  @param indexPath
 *  @param item
 */
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(MenuItem *)item{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    selectRow = indexPath.row;
    [self.tableView reloadData];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Text_Key_Left_Menu object:item];
}

@end
