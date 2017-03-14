//
//  MainViewController.m
//  SHJLPM
//
//  Created by Shinsoft on 16/12/11.
//  Copyright © 2016年 SHJLPM. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"
#import "MenuItem.h"
#import "MainViewCell.h"
#import "MonitorViewController.h"
#import "PeripheralInfo.h"

#define timerLength 15.f

@interface MainViewController ()<MainViewCellDelegate>{
    NSMutableArray *peripheralDataArray;
    BabyBluetooth *baby;
    
    BOOL isScanning;
    UIActivityIndicatorView* activityIndicatorView;//搜索指示器
    NSTimer *timer;//定时器
    
    BOOL isFirstLoad;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isScanning = YES;
    isFirstLoad = YES;
    
    [self initNav];
//    [self initView];
//    [self initData];
    
//    [self initObserver];
    
    
//    [SVProgressHUD showInfoWithStatus:@"准备打开设备"];
    NSLog(@"viewDidLoad");
    peripheralDataArray = [[NSMutableArray alloc]init];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear");
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
//    baby.scanForPeripherals().begin();
//    baby.scanForPeripherals().begin().stop(10);
    
    if (!isFirstLoad) {
        [self addRightNavigationTitleButton:@"STOP SCAN"];
        [self.items removeAllObjects];
        [self.tableView reloadData];
        if (baby) {
            if (activityIndicatorView) {
                [activityIndicatorView startAnimating];
            }
            
            baby.scanForPeripherals().begin();
        }
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:timerLength target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    } else {
        baby.scanForPeripherals().begin();
        isFirstLoad = NO;
    }
    
    
}



#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [SVProgressHUD showInfoWithStatus:@"Start Scanning Equipment"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //最常用的场景是查找某一个前缀开头的设备
        //        if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //            return YES;
        //        }
        //        return NO;
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0 && [peripheralName hasPrefix:@"AVR"]) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}


#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSArray *peripherals = [self.items valueForKey:@"peripheral"];//KVO
    if(![peripherals containsObject:peripheral]) {
//        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
//        [indexPaths addObject:indexPath];
        
//        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
//        [item setValue:peripheral forKey:@"peripheral"];
//        [item setValue:RSSI forKey:@"RSSI"];
//        [item setValue:advertisementData forKey:@"advertisementData"];
        
        PeripheralInfo *peripheralInfo = [[PeripheralInfo alloc] init];
        peripheralInfo.peripheral = peripheral;
        peripheralInfo.RSSI = RSSI;
        peripheralInfo.advertisementData = advertisementData;
        
        
        [self.items addObject:peripheralInfo];
        
        
        [self.tableView reloadData];
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        
        for (int i=0; i<self.items.count; i++) {
            PeripheralInfo *peripheralInfo = [self.items objectAtIndex:i];
            if ([peripheral isEqual:peripheralInfo.peripheral]) {
                [self.items removeObjectAtIndex:i];
            }
        }
        
        PeripheralInfo *peripheralInfo = [[PeripheralInfo alloc] init];
        peripheralInfo.peripheral = peripheral;
        peripheralInfo.RSSI = RSSI;
        peripheralInfo.advertisementData = advertisementData;
        
        
        [self.items addObject:peripheralInfo];
        
        
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initObserver];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Text_Key_Left_Menu_Change object:@"1"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Text_Key_Left_Menu object:nil];
}

- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:K_Text_Key_Left_Menu object:nil];
}

- (void)initNav{
    self.title = @"AVR IoT Nodes";
    [self addLeftNavigationImageButton:[UIImage imageNamed:@"nav_menu"]];
    [self addRightNavigationTitleButton:@"STOP SCAN"];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kAppWidth - 135,27.0,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhite;
    activityIndicatorView.hidesWhenStopped = YES;
    
    [activityIndicatorView startAnimating ];//启动
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:timerLength target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    

    
    [self performSelectorOnMainThread:@selector(reloadActivity) withObject:nil waitUntilDone:NO];
}

- (void)timerFired{
    [self addRightNavigationTitleButton:@"START SCAN"];
    if (activityIndicatorView) {
        [activityIndicatorView stopAnimating];
    }
    if (baby) {
        [baby cancelScan];
    }
    isScanning = !isScanning;
}

- (void)reloadActivity{
    [self.view.window addSubview:activityIndicatorView];
}

- (void)rightBarButtonClicked{
    if (isScanning) {
        [self addRightNavigationTitleButton:@"START SCAN"];
        if (activityIndicatorView) {
            [activityIndicatorView stopAnimating];
        }
        if (baby) {
            [baby cancelScan];
        }
        [timer invalidate];
    } else {
        [self addRightNavigationTitleButton:@"STOP SCAN"];
        [self.items removeAllObjects];
        [self.tableView reloadData];
        
        
        if (baby) {
            if (activityIndicatorView) {
                [activityIndicatorView startAnimating];
            }
            
            baby.scanForPeripherals().begin();
        }
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:timerLength target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    
    }
    
    isScanning = !isScanning;
    
    
//    NSData *tempDta1 = [self convertHexStrToData:@"0303ca68a830ff7ff27a3da0509c64ab439e"];
//    NSData *data0 = [tempDta1 subdataWithRange:NSMakeRange(0, 1)];
//    NSString *hexStr = [self convertDataToHexStr:data0];
//    NSInteger hexInt = hexStr.integerValue;
}


- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}


- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

- (void)leftBarButtonClicked{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    [self addRightNavigationTitleButton:@"START SCAN"];
    if (activityIndicatorView) {
        [activityIndicatorView stopAnimating];
    }
    if (baby) {
        [baby cancelScan];
    }
    [timer invalidate];
}


-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender.userInfo[@"index"]);
    
    MenuItem *item = sender.object;
    NSInteger index = item.index;
    if (index == 2) {
        [self goToNextController:[[AboutViewController alloc] init]];
    }
    
    
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
//    NSMutableArray *items = [[NSMutableArray alloc] init];
    
//    MenuItem *item0 = [[MenuItem alloc] init];
//    item0.name = @"Wearables";
//    item0.index = 0;
//    
//    [items addObject:item0];
//    
//    MenuItem *item1 = [[MenuItem alloc] init];
//    item1.name = @"Settings";
//    item1.index = 1;
//    
//    [items addObject:item1];
//    
//    MenuItem *item2 = [[MenuItem alloc] init];
//    item2.name = @"About";
//    item2.index = 2;
//    
//    [items addObject:item2];
    if (!peripheralDataArray) {
        peripheralDataArray = [[NSMutableArray alloc] init];
    }
    
    
    return peripheralDataArray;
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
    return [PeripheralInfo class];
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
    return [NSArray arrayWithObjects:[MainViewCell class], nil];
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
    return 100.f;
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
- (void)configCell:(MainViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(PeripheralInfo *)item{
    
    cell.index = indexPath.row;
    cell.peripheralInfo = item;
//    cell.textLabel.text = item.name;
    cell.delegate = self;
    
}


/**
 *  选择某行数据
 *
 *  @param indexPath
 *  @param item
 */
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withData:(PeripheralInfo *)item{
//    [baby cancelScan];
//    [self goToNextController:[[MonitorViewController alloc] init]];
    
    
    //停止扫描
//    [baby cancelScan];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self connectEvent:item];
    
}


- (void)connectEvent:(PeripheralInfo *)item{
    [self timerFired];
    
    MonitorViewController *vc = [[MonitorViewController alloc]init];
    CBPeripheral *peripheral = item.peripheral;
    vc.currPeripheral = peripheral;
    vc.peripheralInfo = item;
    vc->baby = self->baby;
    [self goToNextController:vc];
    
}

- (void)mainViewCell:(MainViewCell *)mainViewCell goToConnect:(UIButton *)sender withData:(PeripheralInfo *)item{
    [self connectEvent:item];
}


@end
