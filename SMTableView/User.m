//
//  User.m
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/7/29.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)user:(NSString *)name sex:(NSString *)sex {
    User *user = [[User alloc] init];
    user.name = name;
    user.sex = sex;
    return user;
}
@end
