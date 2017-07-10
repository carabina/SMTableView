//
//  JDCollectionViewSimplifyModel.h
//  JDCore
//
//  Created by 王金东 on 16/1/22.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JDCollectionViewDelegate.h"
#import "JDCollectionViewDataSource.h"

@interface JDCollectionViewSimplifyModel : NSObject <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/**
 *@brief 取消系统默认的delegate和datasource 用下面的来实现自定义
 **/
@property (nonatomic, weak) id<JDCollectionViewDelegate> jdDelegate;
@property (nonatomic, weak) id<JDCollectionViewDataSource> jdDataSource;

/**
 *@brief controler
 **/
@property (nonatomic, weak) UIViewController *viewController;

/**
 *@brief 是否分块
 **/
@property (nonatomic, assign) BOOL sectionable;

/**
 *  @brief 数据源
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;


/**
 *@brief 如果itemsArray里面是NSDictionary 则第二级的数组按照keyOfItemArray来取
 * 默认是items
 **/

@property (nonatomic, copy) NSString *keyOfItemArray;


@end
