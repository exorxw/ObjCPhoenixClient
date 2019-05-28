//
//  PhxUserManager.m
//  ObjCPhoenixClient_Example
//
//  Created by renxinwei on 2018/11/27.
//  Copyright © 2018年 362922604@qq.com. All rights reserved.
//

#import "PhxUserManager.h"

@interface PhxUserManager ()
@property (nonatomic, strong) PhxUser *user;
@end

@implementation PhxUserManager

+ (instancetype)sharedManager {
    static PhxUserManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PhxUserManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.user = [PhxUser new];
        self.user.avatar = @"https://gss3.bdstatic.com/-Po3dSag_xI4khGkpoWK1HF6hhy/baike/awhcrop%3D200%2C200/sign=5ad88b125dfbb2fb226105413d255099/c83d70cf3bc79f3dfbea677fb2a1cd11728b2971.jpg";
        self.user.userId = @"996";
        self.user.name = @"任新伟";
        self.user.uid = @"OWNER_66";
    }
    return self;
}

+ (PhxUser *)currentUser {
    return [PhxUserManager sharedManager].user;
}

@end
