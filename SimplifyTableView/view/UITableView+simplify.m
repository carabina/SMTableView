//
//  UITableView+simplify.m
//  SMCore
//
//  Created by 王金东 on 15/7/28.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "UITableView+simplify.h"
#import "UITableViewCell+simplify.h"
#import <objc/runtime.h>
#import "SMRefreshManager.h"

#pragma mark  ----属性
//indexPath
static const void *tableViewKeyForIndexPath = &tableViewKeyForIndexPath;
//tableview
//static const void *tableViewKeyForTableView = &tableViewKeyForTableView;
//单个cell 可是nib也可是class
static const void *tableViewKeyForTableViewCell = &tableViewKeyForTableViewCell;

//category
static const void *tableViewKeyForRefreshDelegate = &tableViewKeyForRefreshDelegate;
static const void *tableViewKeyForHeaderRefresh = &tableViewKeyForHeaderRefresh;
static const void *tableViewKeyForFooterRefresh = &tableViewKeyForFooterRefresh;

static const void *tableViewKeyForEnableSimplify = &tableViewKeyForEnableSimplify;
static const void *tableViewKeyForModel = &tableViewKeyForModel;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation UITableView (simplify)
#pragma clang diagnostic pop

#pragma mark -----------------------------set方法----------------------------------
- (void)setSimplifyModel:(SMTableViewSimplifyModel *)simplifyModel {
    objc_setAssociatedObject(self, tableViewKeyForModel, simplifyModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (SMTableViewSimplifyModel *)simplifyModel {
      SMTableViewSimplifyModel *model =  objc_getAssociatedObject(self, tableViewKeyForModel);
    if (model == nil) {
        model = [[SMTableViewSimplifyModel alloc] init];
        self.simplifyModel = model;
    }
    return model;
}
- (void)setEnableSimplify:(BOOL)enableSimplify {
    objc_setAssociatedObject(self, tableViewKeyForEnableSimplify, @(enableSimplify), OBJC_ASSOCIATION_ASSIGN);
    if (enableSimplify) {
        self.dataSource = self.simplifyModel;
        self.delegate = self.simplifyModel;
    }
}
- (BOOL)enableSimplify {
     return  [objc_getAssociatedObject(self, tableViewKeyForEnableSimplify) boolValue];
}
//委托
- (void)setSmDelegate:(id<SMTableViewDelegate>)smDelegate{
    self.simplifyModel.smDelegate = smDelegate;
}
- (id<SMTableViewDelegate>)smDelegate {
    return  self.simplifyModel.smDelegate;
}
- (void)setSmDataSource:(id<SMTableViewDataSource>)smDataSource{
    self.simplifyModel.smDataSource = smDataSource;
}
- (id<SMTableViewDataSource>)smDataSource {
    return  self.simplifyModel.smDataSource;
}
- (void)setDidSelectCellBlock:(DidSelectCellBlock)didSelectCellBlock {
    self.simplifyModel.didSelectCellBlock = didSelectCellBlock;
}
- (DidSelectCellBlock)didSelectCellBlock {
    return self.simplifyModel.didSelectCellBlock;
}
- (void)setCellHeightBlock:(CellHeightBlock)cellHeightBlock {
    self.simplifyModel.cellHeightBlock = cellHeightBlock;
}
- (CellHeightBlock)cellHeightBlock {
    return self.simplifyModel.cellHeightBlock;
}
- (void)setConfigureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    self.simplifyModel.configureCellBlock = configureCellBlock;
}
- (TableViewCellConfigureBlock)configureCellBlock {
    return self.simplifyModel.configureCellBlock;
}

//默认cell中title的key
- (void)setKeyForTitleView:(NSString *)keyForTitleView {
    self.simplifyModel.keyForTitleView = keyForTitleView;
}
- (NSString *)keyForTitleView {
    return self.simplifyModel.keyForTitleView;
}
//默认cell中image的key
- (void)setKeyForImageView:(NSString *)keyForImageView{
    self.simplifyModel.keyForImageView = keyForImageView;
}
- (NSString *)keyForImageView {
    return self.simplifyModel.keyForImageView;
}
//默认cell中detail的key
- (void)setKeyForDetailView:(NSString *)keyForDetailView{
    self.simplifyModel.keyForDetailView = keyForDetailView;
}
- (NSString *)keyForDetailView {
    return self.simplifyModel.keyForDetailView;
}

//分组的标题key
- (void)setKeyOfHeadTitle:(NSString *)keyOfHeadTitle {
    self.simplifyModel.keyOfHeadTitle = keyOfHeadTitle;
}
- (NSString *)keyOfHeadTitle {
    return  self.simplifyModel.keyOfHeadTitle;
}

//二级数组里第二级数组的key
- (void)setKeyOfItemArray:(NSString *)keyOfItemArray{
    self.simplifyModel.keyOfItemArray = keyOfItemArray;
}
- (NSString *)keyOfItemArray {
    return self.simplifyModel.keyOfItemArray;
}

//baseviewcontroller
- (void)setViewController:(UIViewController *)viewController  {
    self.simplifyModel.viewController = viewController;
}
- (UIViewController *)viewController {
    return  self.simplifyModel.viewController;
}
//tableview的类型
- (void)setTableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle {
    self.simplifyModel.tableViewCellStyle = tableViewCellStyle;
}
- (UITableViewCellStyle)tableViewCellStyle {
    return  self.simplifyModel.tableViewCellStyle;
}

//第一块的head高
- (void)setFirstSectionHeaderHeight:(CGFloat)firstSectionHeaderHeight {
    self.simplifyModel.firstSectionHeaderHeight = firstSectionHeaderHeight;
}
- (CGFloat)firstSectionHeaderHeight {
    return  self.simplifyModel.firstSectionHeaderHeight;
}
//右侧索引的数组
- (void)setSectionIndexTitles:(NSArray *)sectionIndexTitles {
    self.simplifyModel.sectionIndexTitles = sectionIndexTitles;
}
- (NSArray *)sectionIndexTitles {
    return  self.simplifyModel.sectionIndexTitles;
}
//开启延迟取消选中的背景
- (void)setClearsSelectionDelay:(BOOL)clearsSelectionDelay {
    self.simplifyModel.clearsSelectionDelay = clearsSelectionDelay;
}
- (BOOL)clearsSelectionDelay {
    return  self.simplifyModel.clearsSelectionDelay;
}
//是否分块
- (void)setSectionable:(BOOL)sectionable {
    self.simplifyModel.sectionable = sectionable;
}
- (BOOL)sectionable {
    return self.simplifyModel.sectionable;
}

#pragma mark 注册cell
//注册 单个tableviewCell
- (void)setTableViewCellClass:(id)tableViewCellClass{
    if(tableViewCellClass != nil){
        objc_setAssociatedObject(self, tableViewKeyForTableViewCell, tableViewCellClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        //生成cellid
        NSString *cellID = [_cellID stringByAppendingString:@"_0"];
        if([tableViewCellClass isKindOfClass:[UINib class]]){
            [self registerNib:tableViewCellClass forCellReuseIdentifier:cellID];
        }else{
            [self registerClass:tableViewCellClass forCellReuseIdentifier:cellID];
        }
    }
}
- (id)tableViewCellClass {
    return objc_getAssociatedObject(self, tableViewKeyForTableViewCell);
}

//注册 多个tableviewCell 传入是数组
- (void)setTableViewCellArray:(NSArray *)tableViewCellArray{
    if(tableViewCellArray != nil){
        self.simplifyModel.tableViewCellArray = tableViewCellArray;
        for (NSInteger i = 0; i< tableViewCellArray.count; i++) {
            id cell = tableViewCellArray[i];
            //生成cellid
            NSString *cellID = [_cellID stringByAppendingFormat:@"_%ld",(long)i];
            if([cell isKindOfClass:[UINib class]]){
                [self registerNib:cell forCellReuseIdentifier:cellID];
            }else{
                [self registerClass:cell forCellReuseIdentifier:cellID];
            }
        }
    }
}
- (NSArray *)tableViewCellArray {
    return self.simplifyModel.tableViewCellArray;
}

#pragma mark 构造数据集合  数据源
- (void)setItemsArray:(NSMutableArray *)itemsArray{
    self.simplifyModel.itemsArray = itemsArray;
    if (self.enableSimplify) {
        self.dataSource = self.simplifyModel;
        self.delegate = self.simplifyModel;
    }else {
#ifdef DEBUG
        NSLog(@"enableSimplify:请开启enableSimplify功能，不然不允许使用itemsArray");
#endif
    }
}

- (NSMutableArray *)itemsArray{
    if (self.enableSimplify) {
        self.dataSource = self.simplifyModel;
        self.delegate = self.simplifyModel;
    }else {
#ifdef DEBUG
        NSLog(@"enableSimplify:请开启enableSimplify功能，不然不允许使用itemsArray");
#endif
    }
    return self.simplifyModel.itemsArray;
}

- (void)setAutoLayout:(BOOL)autoLayout{
    self.simplifyModel.autoLayout = autoLayout;
}
- (BOOL)autoLayout {
    return self.simplifyModel.autoLayout;
}


@end
#pragma mark ------------------------------------我是分割线------------------------------
#pragma mark ------------------------------------下面是拓展的功能-------------------------
#pragma mark 刷新功能
@implementation UITableView (refreshable)

- (void)setRefreshDelegate:(id<SMTableViewRefreshDelegate>)refreshDelegate{
    objc_setAssociatedObject(self, tableViewKeyForRefreshDelegate, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
    self.refreshFooterable = self.refreshFooterable;
    self.refreshHeaderable = self.refreshHeaderable;
}

- (id<SMTableViewRefreshDelegate>)refreshDelegate{
    id<SMTableViewRefreshDelegate> delegate = objc_getAssociatedObject(self, tableViewKeyForRefreshDelegate);
    if (delegate == nil) {
        return self;
    }
    return delegate;
}

//设置下拉刷新
- (void)setRefreshHeaderable:(BOOL)refreshHeaderable{
    objc_setAssociatedObject(self, tableViewKeyForHeaderRefresh, @(refreshHeaderable), OBJC_ASSOCIATION_ASSIGN);
    if(refreshHeaderable){
        // 下拉刷新
        [[SMRefreshManager shareInstance] scrollView:self addHeaderWithTarget:self.refreshDelegate action:@selector(headerRereshing)];
    }else{
        [[SMRefreshManager shareInstance] removeHeaderFromScrollView:self];
    }
}
- (BOOL)refreshHeaderable{
    return [objc_getAssociatedObject(self, tableViewKeyForHeaderRefresh) boolValue];
}
- (BOOL)refreshFooterable{
    return [objc_getAssociatedObject(self, tableViewKeyForFooterRefresh) boolValue];
}
//设置上啦加载
- (void)setRefreshFooterable:(BOOL)refreshFooterable{
     objc_setAssociatedObject(self, tableViewKeyForFooterRefresh, @(refreshFooterable), OBJC_ASSOCIATION_ASSIGN);
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
    [self didLoaded:SMRefreshTableViewHeader];
}

/**
 **开始加载数据
 **/
- (void)footerRereshing{
    [self didLoaded:SMRefreshTableViewFooter];
}
//加载完调用 子类调用
- (void)didLoaded:(SMRefreshTableViewType)type{
    if(type == SMRefreshTableViewHeader){
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [[SMRefreshManager shareInstance] headerEndRefreshingFromScrollView:self];
    }else{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [[SMRefreshManager shareInstance] footerEndRefreshingFromScrollView:self];
    }
}

@end




#pragma mark 编辑能力
@implementation UITableView (editable)

- (BOOL)editable{
    return self.simplifyModel.editable;
}
- (void)setEditable:(BOOL)editable {
    self.simplifyModel.editable = editable;
}
- (void)setSingleLineDeleteAction:(SingleLineDeleteAction)singleLineDeleteAction{
    self.simplifyModel.singleLineDeleteAction = singleLineDeleteAction;
}
- (SingleLineDeleteAction)singleLineDeleteAction{
    return self.simplifyModel.singleLineDeleteAction;
}

- (void)setMultiLineDeleteAction:(MultiLineDeleteAction)multiLineDeleteAction{
    self.simplifyModel.multiLineDeleteAction = multiLineDeleteAction;
}
- (MultiLineDeleteAction)multiLineDeleteAction{
    return self.simplifyModel.multiLineDeleteAction;
}
- (void)setCanEditable:(CanEditable)canEditable {
    self.simplifyModel.canEditable = canEditable;
}
- (CanEditable)canEditable{
    return self.simplifyModel.canEditable;
}
- (void)setDeleteConfirmationButtonTitle:(NSString *)deleteConfirmationButtonTitle {
    self.simplifyModel.deleteConfirmationButtonTitle = deleteConfirmationButtonTitle;
}
- (NSString *)deleteConfirmationButtonTitle {
    return self.simplifyModel.deleteConfirmationButtonTitle;
}

@end

