//
//  MainViewCell.h
//  Wearable
//
//  Created by Shinsoft on 17/2/1.
//  Copyright © 2017年 wearable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeripheralInfo.h"

@class MainViewCell;
@protocol MainViewCellDelegate <NSObject>

- (void)mainViewCell:(MainViewCell *)mainViewCell goToConnect:(UIButton *)sender withData:(PeripheralInfo *)item;

@end

@interface MainViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rssiImageView;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (nonatomic, strong) PeripheralInfo *peripheralInfo;
@property (nonatomic, assign) NSInteger index;

- (IBAction)goToConnect:(UIButton *)sender;


@property (nonatomic, assign) id<MainViewCellDelegate> delegate;
@end
