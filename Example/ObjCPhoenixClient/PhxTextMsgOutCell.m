//
//  PhxTextMsgOutCell.m
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/26.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import "PhxTextMsgOutCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhxTextMsgOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configMsgCell:(PhxMessage *)msg {
    [self.avatarIcon sd_setImageWithURL:[NSURL URLWithString:msg.fromUser.avatar]];
    self.msgLabel.text = msg.msgContent;
    self.nameLabel.text = msg.fromUser.name;
    
    NSTimeInterval interval = msg.sendTime / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
}

@end
