//
//  SMTableViewSimplifyModel.h
//  SMCore
//
//  Created by 王金东 on 16/1/22.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SMTableViewDelegate.h"
#import "SMTableViewDataSource.h"

extern NSString *const SMTableViewKeyTypeForRow;
extern NSString *const SMTableViewLayoutForRow;
static NSString *const _cellID = @"baseCellID";

typedef void    (^DidSelectCellBlock)(NSIndexPath *indexPath, id dataInfo) ;
typedef CGFloat (^CellHeightBlock)(NSIndexPath *indexPath, id dataInfo) ;
typedef void    (^TableViewCellConfigureBlock)(NSIndexPath *indexPath, id dataInfo, UITableViewCell *cell) ;

@interface SMTableViewSimplifyModel : NSObject <UITableViewDelegate,UITableViewDataSource>


/**
 *@brief 取消系统默认的delegate和datasource 用下面的来实现自定义
 **/
@property (nonatomic, weak) id<SMTableViewDelegate> smDelegate;
@property (nonatomic, weak) id<SMTableViewDataSource> smDataSource;

/**
 * 通过block对tableview进行配置
 **/
@property (nonatomic, copy) DidSelectCellBlock didSelectCellBlock;
@property (nonatomic, copy) CellHeightBlock cellHeightBlock;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
/**
 *@brief cel的类名或xib'名称组成的数组
 **/
@property (nonatomic, copy) NSArray  *tableViewCellArray;

/**
 *@brief 数据源
 */
@property (nonatomic, strong) NSMutableArray *itemsArray;


/**
 *@brief 是否分块
 **/
@property (nonatomic, assign) BOOL sectionable;

/**
 *@brief 如果itemsArray里面是NSDictionary 则第二级的数组按照keyOfItemArray来取
 * 默认是items
 **/

@property (nonatomic, copy) NSString *keyOfItemArray;


/**
 *@brief 用取head'title得key
 **/

@property (nonatomic, copy) NSString *keyOfHeadTitle;

/**
 *@brief 设置默认三个控件取值的key
 *@brief 设置imageView 取值的key
 **/
@property (nonatomic, copy) NSString *keyForImageView;

/**
 *@brief 设置textLabel 取值的key
 **/
@property (nonatomic, copy) NSString *keyForTitleView;

/**
 *@brief 设置detailLabel 取值的key
 **/
@property (nonatomic, copy) NSString *keyForDetailView;


//是否支持自动布局 默认不支持
@property (nonatomic, assign) BOOL autoLayout;

/**
 *@brief 延迟一会取消选中状态
 **/
@property(nonatomic) BOOL clearsSelectionDelay;


/**
 *@brief  TableView右边的IndexTitles数据源
 **/
@property (nonatomic, copy) NSArray *sectionIndexTitles;

/**
 *@brief 设置第一个section的的head高度
 **/
@property (nonatomic, assign) CGFloat firstSectionHeaderHeight;

/**
 *@brief 不传cell类型时，可通过设置cell的style来初始化cell
 **/
@property (nonatomic, assign) UITableViewCellStyle tableViewCellStyle;

/**
 *@brief controler
 **/
@property (nonatomic, weak) UIViewController *viewController;


@end




#pragma mark edit
/*********************************************************************/


typedef void(^SingleLineDeleteAction) (NSIndexPath *indexPath);
typedef void(^MultiLineDeleteAction) (NSArray *indexPaths);
typedef BOOL(^CanEditable) (NSIndexPath *indexPath);
@interface SMTableViewSimplifyModel (editable)

@property (nonatomic, assign) BOOL editable;

@property (nonatomic, assign) CanEditable canEditable;

//删除按钮在标题
@property (nonatomic, copy) NSString *deleteConfirmationButtonTitle;

/**
 *@brief 开启多行删除block
 **/
@property(nonatomic,assign) MultiLineDeleteAction multiLineDeleteAction;

/**
 *@brief 设置删除的block后就可以开启编辑部模式
 **/
@property(nonatomic,assign) SingleLineDeleteAction singleLineDeleteAction;

@end


