//
//  UICollectionView+simplify.h
//  SMCore
//
//  Created by 王金东 on 15/12/18.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCollectionViewDelegate.h"
#import "SMCollectionViewDataSource.h"
#import "SMCollectionViewSimplifyModel.h"


typedef NS_ENUM(NSInteger, SMRefreshCollectionViewType) {
    SMRefreshCollectionViewHeader,//head类型
    SMRefreshCollectionViewFooter,
};


@interface UICollectionView (simplify)

@property (nonatomic, assign) BOOL enableSimplify;

@property (nonatomic, strong, readonly) SMCollectionViewSimplifyModel *simplifyModel;

/**
 *@brief 取消系统默认的delegate和datasource 用下面的来实现自定义
 **/
@property (nonatomic, weak) id<SMCollectionViewDelegate> smDelegate;

@property (nonatomic, weak) id<SMCollectionViewDataSource> smDataSource;

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
@protocol SMCollectionViewRefreshDelegate <NSObject>

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

@interface UICollectionView (refreshable)<SMCollectionViewRefreshDelegate>

@property (nonatomic, assign) BOOL refreshHeaderable;
@property (nonatomic, assign) BOOL refreshFooterable;

@property (nonatomic, weak) id<SMCollectionViewRefreshDelegate> refreshDelegate;

/**
 *@brief 加载完毕后调用该方法结束加载状态
 **/
- (void)didLoaded:(SMRefreshCollectionViewType)type;


@end
