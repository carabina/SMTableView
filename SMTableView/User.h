//
//  User.h
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/7/29.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *name;

+ (instancetype)user:(NSString *)name sex:(NSString *)sex;

@end
