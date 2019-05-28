//
//  PhxUserManager.h
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/27.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhxUser.h"

@interface PhxUserManager : NSObject

+ (instancetype)sharedManager;
+ (PhxUser *)currentUser;

@end
