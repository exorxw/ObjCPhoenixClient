//
//  PhxMessage.h
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/26.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhxUser.h"

FOUNDATION_EXTERN NSString * const PhxMessageTypeText;
FOUNDATION_EXTERN NSString * const PhxMessageTypeImage;
FOUNDATION_EXTERN NSString * const PhxMessageTypeVoice;

typedef NS_ENUM(NSInteger, PhxMessageDispatchType) {
    PhxMessageDispatchTypeIn = 1,
    PhxMessageDispatchTypeOut = 2,
};

@interface PhxMessage : NSObject <YYModel>

@property (nonatomic, assign) PhxMessageDispatchType dispatchType;
@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, assign) NSTimeInterval sendTime; // milesecond
@property (nonatomic, copy) NSString *toUid;
@property (nonatomic, strong) PhxUser *fromUser;

- (NSDictionary *)sendMsgPayload;

@end
