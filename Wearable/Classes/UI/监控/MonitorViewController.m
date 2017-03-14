//
//  MonitorViewController.m
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "MonitorViewController.h"
#import "RSSIView.h"
#import "TemperatureView.h"
#import "AccelerometerView.h"
#import "TestHelper.h"
#import "MenuItem.h"
#import "AboutViewController.h"
#import "EncryHelper.h"
#import "ECCSecurity.h"

#define channelOnPeropheralView @"peripheralView"

@interface MonitorViewController ()<UIScrollViewDelegate,AccelerometerViewDelegate>{
    UIScrollView *showScrollView;
    RSSIView *rssiView;
    TemperatureView *temperatureView;
    AccelerometerView *accelerometerView;
    
    
    CBCharacteristic *tempCharacteristic;
    CBCharacteristic *acceleroCharacteristic;
    CBCharacteristic *authCharacteristic;
    
    BOOL isStart;
    
    NSInteger indexRecord;
    
    
    
    
    
    NSMutableData *signer_pubkey;
    NSMutableData *signer_sig;
    NSMutableData *device_pubkey;
    NSMutableData *device_sig;
    NSMutableData *sig_tail;
    NSMutableData *signer_sig_tail;
    NSMutableData *device_sig_tail;
    NSMutableData *response_authen;
    
    NSMutableData *challenge0;
    NSMutableData *challenge1;
    
    NSMutableArray *items0,*items1,*items2,*items3,*items4,*items5;
    
    
    BOOL isReceiveFinish;//是否接收数据完毕
    BOOL isCheckFinish;//是否校验完毕
    
    NSInteger receiveNum;//接收有效数据的次数
}

@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNav];
    
    [self initLayoutView];
    
    [self initService];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initObserver];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:K_Text_Key_Left_Menu_Change object:@"2"];
}


- (void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:K_Text_Key_Left_Menu object:nil];
}

- (void)initNav{
    [self addLeftNavigationImageButton:[UIImage imageNamed:@"nav_menu"]];
    [self addRightNavigationTitleButton:@"DISCONNECT"];
}

- (void)rightBarButtonClicked{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)leftBarButtonClicked{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initService{
    //初始化
    self.services = [[NSMutableArray alloc]init];
    [self babyDelegate];
    
    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
    //    [SVProgressHUD showInfoWithStatus:@"Ready to connected devices"];
    [SVProgressHUD showWithStatus:@"Connect..."];
}



//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        //        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"Equipment: %@ -- The connection is successful",peripheral.name]];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@ Connected Successfully",peripheral.name]];
        [SVProgressHUD showWithStatus:@"Authenticating the BLE Node"];
        
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"Equipment: %@ -- The connection fails",peripheral.name]];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"Equipment: %@ -- Disconnect failure",peripheral.name]];
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            ///插入section到tableview
            [weakSelf addPeripheralService:service];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        [weakSelf addCharacteristicsToService:service];
        
        NSLog(@"===service name:%@",weakSelf.services);
        
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置写数据成功的block
    [baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@______",characteristic.UUID, characteristic.value);
        
        
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        
        if (peripheralName.length >0 && [peripheralName hasPrefix:@"AVR"]) {
            return YES;
        }
        return NO;
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}
-(void)loadData{
    [SVProgressHUD showInfoWithStatus:@"Start connecting device"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}


#pragma mark -插入table数据
-(void)addPeripheralService:(CBService *)service{
    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    ServiceInfo *info = [[ServiceInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
}


-(void)addCharacteristicsToService:(CBService *)service{
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        ServiceInfo *info = [self.services objectAtIndex:i];
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect != -1) {
        ServiceInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            
            if ([c.UUID.UUIDString isEqualToString:K_ENVIRONMENT_CHARACTERISTICS]) {//温度计
                tempCharacteristic = c;
                
                //                [self notifiy:c];
            } else if ([c.UUID.UUIDString isEqualToString:K_ACCELERO_POSITIONS_CHARACTERISTICS]) {//加速度
                acceleroCharacteristic = c;
                
                //                [self notifiy:c];
            } else if([c.UUID.UUIDString isEqualToString:K_Authentication_CHARACTERISTICS]){//认证特征
                authCharacteristic = c;
                
                //                 [self writeValue];
                [self notifiy:c];
            }
            
            
            [info.characteristics addObject:c];
            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        ServiceInfo *curInfo =[self.services objectAtIndex:sect];
        NSLog(@"%@",curInfo.characteristics);
        
    }
    
    
}


//写一个值
-(void)writeValue{
    //    int i = 1;
    Byte b = 0X01;
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.currPeripheral writeValue:data forCharacteristic:authCharacteristic type:CBCharacteristicWriteWithResponse];
}

//订阅一个值
-(void)notifiy:(CBCharacteristic *)notifiyCharacteristic{
    
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        [SVProgressHUD showErrorWithStatus:@"peripheral disconnected, please reconnect"];
        return;
    }
    if (notifiyCharacteristic.properties & CBCharacteristicPropertyNotify ||  notifiyCharacteristic.properties & CBCharacteristicPropertyIndicate) {
        
        //        if(notifiyCharacteristic.isNotifying) {
        //            [baby cancelNotify:self.currPeripheral characteristic:notifiyCharacteristic];
        //        }else{
        [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:notifiyCharacteristic];
        [baby notify:self.currPeripheral
      characteristic:notifiyCharacteristic
               block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                   
                   //                NSLog(@"new value %@",characteristics.value);
                   
                   if (characteristics == tempCharacteristic) {
                       temperatureView.temperature = [[DataHelper getInstance] readTempValueFromByte:characteristics.value];
                   } else if(characteristics == acceleroCharacteristic){
                       accelerometerView.items = [[DataHelper getInstance] readAcceleroValueFromByte:characteristics.value];
                   } else if(characteristics == authCharacteristic){
                       NSLog(@"+++++++++++++++++++++++++++++  %ld notify block:%@",indexRecord++, characteristics.value);
                       [self dealAuthValue:characteristics.value];
                   }
                   
               }];
        
        //        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"Do not have permission to nofity"];
        return;
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

- (void)initLayoutView{
    self.title  = @"Node Status";
    
    showScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    showScrollView.backgroundColor = k_color_white;
    showScrollView.delegate = self;
    showScrollView.pagingEnabled = YES;
    showScrollView.bounces=YES;
    showScrollView.pagingEnabled=YES;
    showScrollView.scrollEnabled=YES;
    showScrollView.showsHorizontalScrollIndicator=YES;
    showScrollView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:showScrollView];
    
    showScrollView.contentSize = CGSizeMake(kAppWidth * 3, 0);
    
    
    rssiView = [[RSSIView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, self.view.height)];
    
    [showScrollView addSubview:rssiView];
    
    temperatureView = [[TemperatureView alloc] initWithFrame:CGRectMake(kAppWidth, 0, kAppWidth, self.view.height-64)];
    [showScrollView addSubview:temperatureView];
    
    accelerometerView = [[AccelerometerView alloc] initWithFrame:CGRectMake(kAppWidth * 2, 0, kAppWidth, self.view.height-64)];
    accelerometerView.delegate = self;
    [showScrollView addSubview:accelerometerView];
    
    
    
    [self performSelector:@selector(reload) withObject:nil afterDelay:1.0f];
}

- (void)reload{
    //    [rssiView setProgress:50];
    rssiView.progress = _peripheralInfo.RSSI.intValue + 35;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:K_Text_Key_Left_Menu object:nil];
    
    //    if (rssiView) {
    //        [rssiView removeFromSuperview];
    //        rssiView = nil;
    //    }
    //
    //    if (temperatureView) {
    //        [temperatureView removeFromSuperview];
    //        temperatureView = nil;
    //    }
    //
    //    if (accelerometerView) {
    //        [accelerometerView removeFromSuperview];
    //        accelerometerView = nil;
    //    }
    //
    //    if (showScrollView) {
    //        [showScrollView removeFromSuperview];
    //        showScrollView = nil;
    //    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index=fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
    
    if (index == 0) {//rssi
        if (tempCharacteristic) {
            [baby cancelNotify:self.currPeripheral characteristic:tempCharacteristic];
        }
        if (acceleroCharacteristic) {
            [baby cancelNotify:self.currPeripheral characteristic:acceleroCharacteristic];
        }
        self.title = @"Node Status";
    } else if(index == 1){//温度
        if (acceleroCharacteristic) {
            [baby cancelNotify:self.currPeripheral characteristic:acceleroCharacteristic];
        }
        if (tempCharacteristic) {
            [self notifiy:tempCharacteristic];
        }
        self.title = @"Environment";
    } else if(index == 2){//加速度
        if (tempCharacteristic) {
            [baby cancelNotify:self.currPeripheral characteristic:tempCharacteristic];
        }
        if (acceleroCharacteristic) {
            //            [self notifiy:acceleroCharacteristic];
        }
        self.title = @"Accelerometer";
        
    }
    
}

- (void)accelerometerView:(AccelerometerView *)accelerometerView operateClick:(UIButton *)sender{
    isStart = !isStart;
    if (isStart) {
        [sender setTitle:@"STOP" forState:UIControlStateNormal];
        if (acceleroCharacteristic) {
            [self notifiy:acceleroCharacteristic];
        }
    } else {
        [sender setTitle:@"START" forState:UIControlStateNormal];
        if (acceleroCharacteristic) {
            [baby cancelNotify:self.currPeripheral characteristic:acceleroCharacteristic];
        }
    }
}


- (void)dealAuthValue:(NSData *)data{
    [self initAuthData];
    
    
    if (data.length>0) {
        NSData *data0 = [data subdataWithRange:NSMakeRange(0, 1)];
        NSString *hexStr0 = [self convertDataToHexStr:data0];
        NSInteger hexInt0 = hexStr0.integerValue;
        
        NSData *data1 = [data subdataWithRange:NSMakeRange(1, 1)];
        NSString *hexStr1 = [self convertDataToHexStr:data1];
        NSInteger hexInt1 = hexStr1.integerValue;
        
        if (hexInt0 == 1) {
            if ([items0[hexInt1] length]==0 && data.length>0) {
                [items0 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                receiveNum++;
            }
        } else if (hexInt0 == 2) {
            if ([items1[hexInt1] length]==0 && data.length>0) {
                [items1 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                receiveNum++;
            }
        } else if (hexInt0 == 3) {
            if ([items2[hexInt1] length]==0 && data.length>0) {
                [items2 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                receiveNum++;
            }
        } else if (hexInt0 == 4) {
            if ([items3[hexInt1] length]==0 && data.length>0) {
                [items3 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                receiveNum++;
            }
        } else if (hexInt0 == 5) {
            if ([items4[hexInt1] length]==0 && data.length>0) {
                [items4 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                //                items4[0] = [data subdataWithRange:NSMakeRange(2, 16)];
                
                NSLog(@"XXXXXXXXXXXXXXXXXXXXXXX:%@-----%@",data,items4);
                receiveNum++;
            }
            
            
        }  else if (hexInt0 == 7) {
            if (receiveNum >= 17 &&  [items5[hexInt1] length]==0 && data.length>0) {
                [items5 replaceObjectAtIndex:hexInt1 withObject:[data subdataWithRange:NSMakeRange(2, 16)]];
                receiveNum++;
            }
        }
        
        
        if (receiveNum == 17) {//接收数据完毕后，初始化数据，发送数据
            if (!isReceiveFinish) {
                //************获取重组证书的相关数据*********************
                signer_pubkey = [self mutableData:signer_pubkey withArray:items0];
                signer_sig = [self mutableData:signer_sig withArray:items1];
                device_pubkey = [self mutableData:device_pubkey withArray:items2];
                device_sig = [self mutableData:device_sig withArray:items3];
                sig_tail = [self mutableData:sig_tail withArray:items4];
                
                //拆分 Certificate Infomation
                NSMutableData *signer_compcert = [[NSMutableData alloc] init];
                NSMutableData *device_compcert = [[NSMutableData alloc] init];
                
                [signer_compcert appendData:signer_sig];
                [signer_compcert appendData:[sig_tail subdataWithRange:NSMakeRange(0, 8)]];
                
                [device_compcert appendData:device_sig];
                [device_compcert appendData:[sig_tail subdataWithRange:NSMakeRange(8, 8)]];
                
                
                //*******重组证书*****************
                ECCSecurity * eccsecurity = [[ECCSecurity alloc]init];
                atcacert_def_t signer_cert_def;
                atcacert_def_t device_cert_def;
                NSMutableData *root_pubkey = [self convertHexStrToData:ROOT_PUBLIC_KEY_HEXSTR];
                [eccsecurity init_signer_cert_def:&signer_cert_def device_cert_def:&device_cert_def];
                [eccsecurity reconstruct_cert_with_certdef:signer_cert_def ca_pk:root_pubkey compert:signer_compcert pk:signer_pubkey fullcert:signer_cert];
                [eccsecurity reconstruct_cert_with_certdef:device_cert_def ca_pk:signer_pubkey compert:device_compcert pk:device_pubkey fullcert:device_cert];
                
                for(int i= 0; i<475;i++){
                    NSLog(@"%x",signer_cert[i]);
                }
                
                [ECCSecurity x509Verify:[self convertHexStrToData:ROOT_CERT_HEXSTR] signer_cert:[NSData dataWithBytes:signer_cert length:475] device_cert:[NSData dataWithBytes:device_cert length:424]];
                
                //*********发送32位字节数据  获取64位数据进行验签***********
                NSString *hexStr0 = @"0600ff000000000000000000000000000000";
                NSString *hexStr1 = @"060100000000000000000000000000ff0000";
                
                challenge0 = [self convertHexStrToData:hexStr0];
                challenge1 = [self convertHexStrToData:hexStr1];
                
                //发送第一个的值
                [self.currPeripheral writeValue:challenge0 forCharacteristic:authCharacteristic type:CBCharacteristicWriteWithResponse];
                //发送第二个值
                [self.currPeripheral writeValue:challenge1 forCharacteristic:authCharacteristic type:CBCharacteristicWriteWithResponse];
                
                isReceiveFinish = YES;
            }
        }
        
        
        if (receiveNum == 21) {//接收验签数据完毕
            //接收到值
            if (!isCheckFinish) {
                response_authen = [self mutableData:response_authen withArray:items5];
                
                //***********验签********************
                NSData *plainData = [self convertHexStrToData:@"ff00000000000000000000000000000000000000000000000000000000ff0000"];
                
                [ECCSecurity x509Verify:[NSData dataWithBytes:device_cert length:424] chanllengeData:plainData responseData:response_authen];
//                SecKeyRef secKeyRef = [EncryHelper getPublicKeyReference:[EncryHelper data]];
                //                BOOL result = [EncryHelper PKCSVerifyBytesSHA256withRSA:plainData signature:response_authen publicKey:secKeyRef];
                
                [SVProgressHUD showSuccessWithStatus:@"Authenticated Success"];
                isCheckFinish = YES;
            }
            
            [baby cancelNotify:self.currPeripheral characteristic:authCharacteristic];
        }
        
        
    }
    
    
    
    
    
    
    
    
}

- (NSMutableData *)mutableData:(NSMutableData *)data withArray:(NSMutableArray *)items{
    for (int i=0; i<items.count; i++) {
        [data appendData:items[i]];
    }
    return data;
}

- (void)initAuthData{
    if (!signer_pubkey) {
        signer_pubkey = [[NSMutableData alloc] init];
    }
    
    if (!signer_sig) {
        signer_sig = [[NSMutableData alloc] init];
    }
    if (!device_pubkey) {
        device_pubkey = [[NSMutableData alloc] init];
    }
    if (!device_sig) {
        device_sig = [[NSMutableData alloc] init];
    }
    if (!sig_tail) {
        sig_tail = [[NSMutableData alloc] init];
    }
    if (!signer_sig_tail) {
        signer_sig_tail = [[NSMutableData alloc] init];
    }
    if (!device_sig_tail) {
        device_sig_tail = [[NSMutableData alloc] init];
    }
    if (!response_authen) {
        response_authen = [[NSMutableData alloc] init];
    }
    if (!challenge0) {
        challenge0 = [[NSMutableData alloc] init];
    }
    if (!challenge1) {
        challenge1 = [[NSMutableData alloc] init];
    }
    
    
    
    if (!items0) {
        items0 = [NSMutableArray arrayWithObjects:[NSData new],[NSData new],[NSData new],[NSData new], nil];
    }
    if (!items1) {
        items1 = [NSMutableArray arrayWithObjects:[NSData new],[NSData new],[NSData new],[NSData new], nil];
    }
    if (!items2) {
        items2 = [NSMutableArray arrayWithObjects:[NSData new],[NSData new],[NSData new],[NSData new], nil];
    }
    if (!items3) {
        items3 = [NSMutableArray arrayWithObjects:[NSData new],[NSData new],[NSData new],[NSData new], nil];
    }
    if (!items4) {
        items4 = [NSMutableArray arrayWithObjects:[NSData new], nil];
    }
    
    if (!items5) {
        items5 = [NSMutableArray arrayWithObjects:[NSData new],[NSData new],[NSData new],[NSData new], nil];
    }
}

- (NSMutableData *)convertHexStrToData:(NSString *)str {
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


-(void)notice:(NSNotification *)sender{
    NSLog(@"%@",sender.userInfo[@"index"]);
    
    MenuItem *item = sender.object;
    NSInteger index = item.index;
    if (index == 2) {
        [self goToNextController:[[AboutViewController alloc] init]];
    }
    
    
}

@end
