//
//  UICollectionView+simplify.m
//  SNCore
//
//  Created by 王金东 on 15/12/18.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "UICollectionView+simplify.h"
#import <objc/runtime.h>
#import "SMRefreshManager.h"

#define collectionCellId @"collectionCellId"

//刷新委托类
static const void *cViewKeyForRefreshDelegate = &cViewKeyForRefreshDelegate;
//头部刷新
static const void *cViewKeyForHeaderRefresh = &cViewKeyForHeaderRefresh;
//底部刷新
static const void *cViewKeyForFooterRefresh = &cViewKeyForFooterRefresh;
//cell
static const void *cViewKeyForTableViewCell = &cViewKeyForTableViewCell;

static const void *cViewKeyForEnableSimplify = &cViewKeyForEnableSimplify;
static const void *cViewKeyForModel = &cViewKeyForModel;


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation UICollectionView (simplify)
#pragma clang diagnostic pop


#pragma mark -----------------------------set方法----------------------------------
- (void)setEnableSimplify:(BOOL)enableSimplify {
    objc_setAssociatedObject(self, cViewKeyForEnableSimplify, @(enableSimplify), OBJC_ASSOCIATION_ASSIGN);
    if (enableSimplify) {
        self.dataSource = self.simplifyModel;
        self.delegate = self.simplifyModel;
    }
}
- (BOOL)enableSimplify {
    return  [objc_getAssociatedObject(self, cViewKeyForEnableSimplify) boolValue];
}
- (void)setSimplifyModel:(SMCollectionViewSimplifyModel *)simplifyModel {
    objc_setAssociatedObject(self, cViewKeyForModel, simplifyModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SMCollectionViewSimplifyModel *)simplifyModel {
    SMCollectionViewSimplifyModel *model =  objc_getAssociatedObject(self, cViewKeyForModel);
    if (model == nil) {
        model = [[SMCollectionViewSimplifyModel alloc] init];
        self.simplifyModel = model;
    }
    return model;
}

//委托
- (void)setSmDelegate:(id<SMCollectionViewDelegate>)smDelegate{
    self.simplifyModel.smDelegate = smDelegate;
}
- (id<SMCollectionViewDelegate>)smDelegate {
    return  self.simplifyModel.smDelegate;
}
- (void)setSmDataSource:(id<SMCollectionViewDataSource>)smDataSource{
    self.simplifyModel.smDataSource = smDataSource;
}
- (id<SMCollectionViewDataSource>)smDataSource {
    return  self.simplifyModel.smDataSource;
}


- (NSMutableArray *)itemsArray{
    return self.simplifyModel.itemsArray;
}
- (void)setItemsArray:(NSMutableArray *)itemsArray {
    self.simplifyModel.itemsArray = itemsArray;
}

//二级数组里第二级数组的key
- (void)setKeyOfItemArray:(NSString *)keyOfItemArray{
    self.simplifyModel.keyOfItemArray = keyOfItemArray;
}
- (NSString *)keyOfItemArray {
   return self.simplifyModel.keyOfItemArray;
}

//是否分块
- (void)setSectionable:(BOOL)sectionable {
    self.simplifyModel.sectionable = sectionable;
}
- (BOOL)sectionable {
    return  self.simplifyModel.sectionable;
}

//baseviewcontroller
- (void)setViewController:(UIViewController *)viewController  {
    self.simplifyModel.viewController = viewController;
}
- (UIViewController *)viewController {
    return  self.simplifyModel.viewController;
}

- (void)setCollectionViewCellClass:(id)collectionViewCellClass{
    if(collectionViewCellClass != nil){
         objc_setAssociatedObject(self, cViewKeyForTableViewCell, collectionViewCellClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if([collectionViewCellClass isKindOfClass:[UINib class]]){
            [self registerNib:collectionViewCellClass forCellWithReuseIdentifier:collectionCellId];
        }else{
            [self registerClass:collectionViewCellClass forCellWithReuseIdentifier:collectionCellId];
        }
    }
}
- (id)collectionViewCellClass {
     return objc_getAssociatedObject(self, cViewKeyForTableViewCell);
}
@end




#pragma mark ------------------------------------我是分割线------------------------------
#pragma mark ------------------------------------下面是拓展的功能-------------------------
#pragma mark 刷新功能
@implementation UICollectionView (refreshable)

- (void)setRefreshDelegate:(id<SMCollectionViewRefreshDelegate>)refreshDelegate{
    objc_setAssociatedObject(self, cViewKeyForRefreshDelegate, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
    self.refreshFooterable = self.refreshFooterable;
    self.refreshHeaderable = self.refreshHeaderable;
}

- (id<SMCollectionViewRefreshDelegate>)refreshDelegate{
    id<SMCollectionViewRefreshDelegate> delegate = objc_getAssociatedObject(self, cViewKeyForRefreshDelegate);
    if (delegate == nil) {
        return self;
    }
    return delegate;
}

//设置下拉刷新
- (void)setRefreshHeaderable:(BOOL)refreshHeaderable{
    objc_setAssociatedObject(self, cViewKeyForHeaderRefresh, @(refreshHeaderable), OBJC_ASSOCIATION_ASSIGN);
    if(refreshHeaderable){
        // 下拉刷新
        // 下拉刷新
        [[SMRefreshManager shareInstance] scrollView:self addHeaderWithTarget:self.refreshDelegate action:@selector(headerRereshing)];
    }else{
        [[SMRefreshManager shareInstance] removeHeaderFromScrollView:self];
    }
}
- (BOOL)refreshHeaderable{
    return [objc_getAssociatedObject(self, cViewKeyForHeaderRefresh) boolValue];
}
- (BOOL)refreshFooterable{
    return [objc_getAssociatedObject(self, cViewKeyForFooterRefresh) boolValue];
}
//设置上啦加载
- (void)setRefreshFooterable:(BOOL)refreshFooterable{
     objc_setAssociatedObject(self, cViewKeyForFooterRefresh, @(refreshFooterable), OBJC_ASSOCIATION_ASSIGN);
    if(refreshFooterable){
        // 上拉加载更多
        [[SMRefreshManager shareInstance] scrollView:self addFooterWithTarget:self.refreshDelegate action:@selector(footerRereshing)];
    }else{
        [[SMRefreshManager shareInstance] removeFooterFromScrollView:self];
    }
}
/**
 **开始刷新数据
 **/
- (void)headerRereshing{
    [self didLoaded:SMRefreshCollectionViewHeader];
}

/**
 **开始加载数据
 **/
- (void)footerRereshing{
    [self didLoaded:SMRefreshCollectionViewFooter];
}
//加载完调用 子类调用
- (void)didLoaded:(SMRefreshCollectionViewType)type{
    // 刷新表格
    [self reloadData];
    if(type == SMRefreshCollectionViewHeader){
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [[SMRefreshManager shareInstance] headerEndRefreshingFromScrollView:self];
    }else{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [[SMRefreshManager shareInstance] footerEndRefreshingFromScrollView:self];
    }}


@end
