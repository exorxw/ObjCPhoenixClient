//
//  PhxUser.m
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/26.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import "PhxUser.h"

@implementation PhxUser

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"avatar": @"avatar_url", @"userId": @"id"};
}

@end
