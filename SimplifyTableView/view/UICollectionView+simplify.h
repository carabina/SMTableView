//
//  UICollectionView+simplify.h
//  JDCore
//
//  Created by 王金东 on 15/12/18.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDCollectionViewDelegate.h"
#import "JDCollectionViewDataSource.h"
#import "JDCollectionViewSimplifyModel.h"


typedef NS_ENUM(NSInteger, JDBaseRefreshCollectionViewType) {
    JDBaseRefreshCollectionViewHeader,//head类型
    JDBaseRefreshCollectionViewFooter,
};


@interface UICollectionView (simplify)

@property (nonatomic, assign) BOOL enableSimplify;

@property (nonatomic, strong, readonly) JDCollectionViewSimplifyModel *simplifyModel;

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
 *  @brief cell的类名
 **/
@property (nonatomic, assign) id collectionViewCellClass;


/**
 *@brief 如果itemsArray里面是NSDictionary 则第二级的数组按照keyOfItemArray来取
 * 默认是items
 **/

@property (nonatomic, copy) NSString *keyOfItemArray;


@end



#pragma mark 刷新协议
@protocol JDBaseCollectionViewRefreshDelegate <NSObject>

@optional
/**
 *@brief 开始刷新数据
 **/
- (void)headerRereshing;

/**
 *@brief 开始加载数据
 **/
- (void)footerRereshing;

@end


/**
 *@brief  是否开启刷新功能 默认开启
 **/

@interface UICollectionView (refreshable)<JDBaseCollectionViewRefreshDelegate>

@property (nonatomic, assign) BOOL refreshHeaderable;
@property (nonatomic, assign) BOOL refreshFooterable;

@property (nonatomic, weak) id<JDBaseCollectionViewRefreshDelegate> refreshDelegate;

/**
 *@brief 加载完毕后调用该方法结束加载状态
 **/
- (void)didLoaded:(JDBaseRefreshCollectionViewType)type;


@end
