//
//  MainViewCell.m
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:nil options:nil];
        self = [nibArray lastObject];
        
        [self initLayoutView];
    }
    return self;
}

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MainViewCell" owner:self options:nil] lastObject];
    if(self) {
        
    }
    return self;
}

- (void)initLayoutView{
    self.rssiLabel.textColor = RGBCOLOR(71, 159, 153);
    [self.connectBtn setBackgroundColor:RGBCOLOR(71, 159, 153)];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.connectBtn.layer.masksToBounds = YES;
    self.connectBtn.layer.cornerRadius = 12;
}

- (void)setPeripheralInfo:(PeripheralInfo *)peripheralInfo{
    _peripheralInfo = peripheralInfo;
    
    CBPeripheral *peripheral = peripheralInfo.peripheral;
    NSDictionary *advertisementData = peripheralInfo.advertisementData;
    NSNumber *RSSI = peripheralInfo.RSSI;
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
    NSString *peripheralName;
    if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
        peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
        peripheralName = peripheral.name;
    }else{
        peripheralName = [peripheral.identifier UUIDString];
    }
    
    self.nameLabel.text = peripheralName;
//    @property (weak, nonatomic) IBOutlet UILabel *macLabel;
    _rssiImageView.image = [UIImage imageNamed:[self imageNameByRSSI:RSSI]];
    _rssiLabel.text = [NSString stringWithFormat:@"%@dBm",RSSI];
}

- (IBAction)goToConnect:(UIButton *)sender {
    [self.delegate mainViewCell:self goToConnect:sender withData:_peripheralInfo];
}

- (NSString *)imageNameByRSSI:(NSNumber*)rssi{
    NSInteger strength = rssi.integerValue;
    
    if (strength == 127) {     // value of 127 reserved for RSSI not available
        return @"no_signal";
    } else if (strength <= -84) {
        return [self rssiNameByIndex:_index rssi:1];
    } else if (strength <= -72) {
        return [self rssiNameByIndex:_index rssi:2];
    } else if (strength <= -60) {
        return [self rssiNameByIndex:_index rssi:3];
    } else if (strength <= -48) {
        return [self rssiNameByIndex:_index rssi:4];
    } else {
        return [self rssiNameByIndex:_index rssi:5];
    }
}

- (NSString *)rssiNameByIndex:(NSInteger)index rssi:(NSInteger)rssiIndex{
    
    NSString *rssiName;
    switch (index%6) {
        case 0:
            rssiName = [NSString stringWithFormat:@"green_0%ld",rssiIndex];
            break;
        case 1:
            rssiName = [NSString stringWithFormat:@"yellow_0%ld",rssiIndex];
            break;
        case 2:
            rssiName = [NSString stringWithFormat:@"red_0%ld",rssiIndex];
            break;
        case 3:
            rssiName = [NSString stringWithFormat:@"light_green_0%ld",rssiIndex];
            break;
        case 4:
            rssiName = [NSString stringWithFormat:@"violet_0%ld",rssiIndex];
            break;
        case 5:
            rssiName = [NSString stringWithFormat:@"blue_0%ld",rssiIndex];
            break;
            
        default:
            rssiName = [NSString stringWithFormat:@"green_0%ld",rssiIndex];
            break;
    }
    return rssiName;
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    _iconImageView.image = [UIImage imageNamed:[self imageNameByIndex:index]];
    _rssiLabel.textColor = [self textColorByIndex:index];
    _connectBtn.backgroundColor = [self textColorByIndex:index];
}


- (UIColor *)textColorByIndex:(NSInteger)index{
    UIColor *color;
    switch (index%6) {
        case 0:
            color = RGBCOLOR(74, 153, 154);
            break;
        case 1:
            color = RGBCOLOR(238, 184, 67);
            break;
        case 2:
            color = RGBCOLOR(220, 77, 65);
            break;
        case 3:
            color = RGBCOLOR(137, 185, 84);
            break;
        case 4:
            color = RGBCOLOR(100, 93, 163);
            break;
        case 5:
            color = RGBCOLOR(86, 180, 228);
            break;
            
        default:
            color = RGBCOLOR(74, 153, 154);
            break;
    }
    return color;
}

- (NSString *)imageNameByIndex:(NSInteger)index{
    NSString *imageName;
    switch (index%6) {
        case 0:
            imageName = @"w01";
            break;
        case 1:
            imageName = @"w02";
            break;
        case 2:
            imageName = @"w03";
            break;
        case 3:
            imageName = @"w04";
            break;
        case 4:
            imageName = @"w05";
            break;
        case 5:
            imageName = @"w06";
            break;
            
        default:
            imageName = @"w01";
            break;
    }
    return imageName;
}

@end
