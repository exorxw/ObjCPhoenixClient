//
//  PhxTextMsgOutCell.h
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/26.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhxMessage.h"

@interface PhxTextMsgOutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

- (void)configMsgCell:(PhxMessage *)msg;

@end
