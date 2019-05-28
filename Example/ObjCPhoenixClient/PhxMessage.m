//
//  PhxMessage.m
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/26.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import "PhxMessage.h"
#import "PhxUserManager.h"

NSString * const PhxMessageTypeText = @"text";
NSString * const PhxMessageTypeImage = @"image";
NSString * const PhxMessageTypeVoice = @"voice";

@implementation PhxMessage

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"msgId": @"id",
             @"msgType": @"body.type",
             @"msgContent": @"body.content",
             @"toUid": @"to",
             @"sendTime": @"sent_time",
             @"fromUser": @"from"};
}

- (PhxMessageDispatchType)dispatchType {
    if ([self.toUid isEqualToString:[PhxUserManager currentUser].uid]) {
        return PhxMessageDispatchTypeIn;
    } else {
        return PhxMessageDispatchTypeOut;
    }
}
- (NSDictionary *)sendMsgPayload {
    self.fromUser = [PhxUserManager currentUser];
    NSTimeInterval sendTime = [[NSDate date] timeIntervalSince1970] * 1000;
    self.sendTime = sendTime;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setValue:@(sendTime) forKey:@"sent_time"];
    [dic setValue:self.toUid forKey:@"to"];
    [dic setValue:[self uuid] forKey:@"id"];
    NSDictionary *body = @{@"type": self.msgType, @"content": self.msgContent};
    [dic setValue:body forKey:@"body"];
    return dic.copy;
}

- (NSString *)uuid {
    CFUUIDRef uniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef idString = CFUUIDCreateString(kCFAllocatorDefault, uniqueID);
    NSString *uuId = [((__bridge NSString *)idString) copy];
    CFRelease(uniqueID);
    CFRelease(idString);
    return uuId;
}

@end
