//
//  JDTableViewSimplifyModel.m
//  JDCore
//
//  Created by 王金东 on 16/1/22.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "JDTableViewSimplifyModel.h"
#import <CTObjectiveCRuntimeAdditions/CTBlockDescription.h>
#import "UITableViewCell+simplify.h"
//#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

#define respondsSel(target,sel)  (target && [target respondsToSelector:sel])
#define isTableView(tableView) ([tableView isKindOfClass:[UITableView class]])


NSString *const JDTableViewKeyTypeForRow = @"typeForRow";
NSString *const JDTableViewLayoutForRow = @"layoutForRow";

@implementation JDTableViewSimplifyModel{
    NSMutableArray *_itemArray;
    BOOL _editable;
    NSString *_deleteConfirmationButtonTitle;
    SingleLineDeleteAction _singleLineDeleteAction;
    MultiLineDeleteAction _multiLineDeleteAction;
    CanEditable _canEditable;
}


- (NSMutableArray *)itemsArray{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)setItemsArray:(NSMutableArray *)itemsArray {
    if(![itemsArray isKindOfClass:[NSArray class]]){
        _itemArray = [NSMutableArray array];
    }else if([itemsArray isMemberOfClass:[NSArray class]]){
        _itemArray = itemsArray.mutableCopy;
    }else{
        _itemArray = itemsArray;
    }
}
- (NSString *)keyOfItemArray {
    if (_keyOfItemArray == nil) {
        _keyOfItemArray =  @"items";
    }
    return _keyOfItemArray;
}
- (NSString *)keyForTitleView {
    if (_keyForTitleView == nil) {
        _keyForTitleView = JDCellKeyForTitleView;
    }
    return _keyForTitleView;
}
- (NSString *)keyForImageView {
    if (_keyForImageView == nil) {
        _keyForImageView = JDCellKeyForImageView;
    }
    return _keyForImageView;
}
- (NSString *)keyForDetailView {
    if (_keyForDetailView == nil) {
        _keyForDetailView = JDCellKeyForDetailView;
    }
    return _keyForDetailView;
}

#pragma mark ----------下面是重写TableView的dataSource-------------------------
// JDTableViewDataSource  返回的是cell  Array的索引位置
- (NSInteger)tableView:(UITableView *)tableView typeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger type = 0;
    if(self.tableViewCellArray != nil){
        if (respondsSel(self.jdDataSource ,@selector(tableView:typeForRowAtIndexPath:))) {
            type = [self.jdDataSource tableView:tableView typeForRowAtIndexPath:indexPath];
        }
        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
        if(self.sectionable){
            id sectionData = self.itemsArray[indexPath.section];
            if([sectionData isKindOfClass:[NSDictionary class]] && [sectionData objectForKey:JDTableViewKeyTypeForRow]){
                type = [sectionData[JDTableViewKeyTypeForRow] integerValue];
            }
        }
        if([dataInfo isKindOfClass:[NSDictionary class]] && [dataInfo objectForKey:JDTableViewKeyTypeForRow]){
            type = [dataInfo[JDTableViewKeyTypeForRow] integerValue];
        }
        if(type >= self.tableViewCellArray.count){//如果得到的type大于数组的长度 则默认等于0位置的type
            type = 0;
        }
    }
    return type;
}

#pragma mark - UITableView DataSource
//分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //自定义
    if(respondsSel(self.jdDataSource,@selector(numberOfSectionsInTableView:))){
        return [self.jdDataSource numberOfSectionsInTableView:tableView];
    }
    if(self.sectionable){//分块 二维数组
        return self.itemsArray.count;
    }
    return 1;
}

//加enableForSearchTableView这个判断 是因为处于查询的时候tableview变了 每组中有几条数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //自定义
    if(respondsSel(self.jdDataSource,@selector(tableView:numberOfRowsInSection:))){
        return [self.jdDataSource tableView:tableView numberOfRowsInSection:section];
    }
    if(self.sectionable && self.itemsArray.count > 0){//分块 二维数组
        id cellInfo = self.itemsArray[section];
        if([cellInfo isKindOfClass:[NSArray class]]){
            return [(NSArray *)cellInfo count];
        }else{
            NSArray *array = [cellInfo valueForKey:self.keyOfItemArray];
            if(array != nil && [array isKindOfClass:[NSArray class]]){
                return  [array count];
            }
        }
        return 0;
    }
    return self.itemsArray.count;
}


//加入右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //自定义
    if(respondsSel(self.jdDataSource , @selector(sectionIndexTitlesForTableView:))){
        return [self.jdDataSource sectionIndexTitlesForTableView:tableView];
    }
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (respondsSel(self.jdDataSource,@selector(tableView:sectionForSectionIndexTitle:atIndex:))) {
        return [self.jdDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //自定义
    if(respondsSel(self.jdDataSource,@selector(tableView:cellForRowAtIndexPath:))){
        return [self.jdDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
    UITableViewCell *cell = nil;
    if([dataInfo isKindOfClass:[NSDictionary class]] && [dataInfo objectForKey:JDTableViewLayoutForRow]){
        cell = dataInfo[JDTableViewLayoutForRow];
    }else{
        //JDLog(@"渲染第%d块，第%d行",indexPath.section,indexPath.row);
        //生成cellid
        NSInteger type = [self tableView:tableView typeForRowAtIndexPath:indexPath];
        NSString *cellID = [_cellID stringByAppendingFormat:@"_%ld",(long)type];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil){
            //给个默认的class
            cell = [[UITableViewCell alloc] initWithStyle:self.tableViewCellStyle reuseIdentifier:cellID];
        }
    }
    NSAssert([cell isKindOfClass:[UITableViewCell class]], @"cell必须是UITableViewCell的子类");
    //把行信息也传递给cell 方便后者使用
    cell.indexPath = indexPath;
    cell.viewController = self.viewController; //传入顶层的 ViewController
    cell.keyForTitleView = self.keyForTitleView;   //传入 健的title
    cell.keyForDetailView = self.keyForDetailView; //传入详情 健的detail
    cell.keyForImageView = self.keyForImageView;   //传入图片健的 image图片
    
    if(respondsSel(self.jdDelegate,@selector(tableView:accessoryTypeForRowWithIndexPath:))){
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        cell.accessoryType = [self.jdDelegate tableView:tableView accessoryTypeForRowWithIndexPath:indexPath];
    #pragma clang diagnostic pop
    }
    cell.tableView = tableView;
    if(self.configureCellBlock){
        self.configureCellBlock(indexPath,dataInfo,cell);
    }else{
        cell.dataInfo = dataInfo; //传入当前数据源
    }
    [cell _saveDataInfo:dataInfo];
    //设置行样式
    [self tableView:tableView cellStyleForRowAtIndexPath:cell];
    return cell;
}


// 可根据行设置行样式  可自定义
- (void)tableView:(UITableView *)tableView cellStyleForRowAtIndexPath:(UITableViewCell *)cell{
    if(respondsSel(self.jdDataSource,@selector(tableView:cellStyleForRowAtIndexPath:))){
        [self.jdDataSource tableView:tableView cellStyleForRowAtIndexPath:cell];
    }
}


//头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(respondsSel(self.jdDataSource,@selector(tableView:titleForHeaderInSection:))){
        return [self.jdDataSource tableView:tableView titleForHeaderInSection:section];
    }else{
        if(self.keyOfHeadTitle.length > 0){
            return self.itemsArray[section][self.keyOfHeadTitle];
        }
    }
    return nil;
}
//脚部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if(respondsSel(self.jdDataSource,@selector(tableView:titleForFooterInSection:))){
        return [self.jdDataSource tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

//获取当前数据，分组与不分组的数据
- (id)dataInfoforCellatTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    if(self.itemsArray.count == 0){
        return nil;
    }
    id dataInfo = nil;
    //设置数据源给tableviewcell
    if(self.sectionable){//分块
        id cellInfo = self.itemsArray[indexPath.section];
        if([cellInfo isKindOfClass:[NSArray class]]){
            dataInfo = cellInfo[indexPath.row];
        }else {
            NSArray *array = [cellInfo valueForKey:self.keyOfItemArray];
            if(array != nil && [array isKindOfClass:[NSArray class]]){
                dataInfo = array[indexPath.row];
            }
        }
    }else{
        dataInfo = self.itemsArray[indexPath.row];
    }
    return dataInfo;
}

#pragma mark ---------------------我是分割线------------------------------
- (void)deselect:(UITableView *)tableView{
     [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
#pragma mark ----------下面是重写TableView的delegate-------------------------
//选中cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.clearsSelectionDelay){
        [self performSelector:@selector(deselect:) withObject:tableView afterDelay:0.5f];
    }
    //自定义
    if(self.didSelectCellBlock){
        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
        self.didSelectCellBlock(indexPath,dataInfo);
    }else if(respondsSel(self.jdDelegate,@selector(tableView:didSelectRowAtIndexPath:))){
        return [self.jdDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            id block = dataInfo[JDCellKeySelectedBlock];
            if(block != nil){
                // allocating a block description
                CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:block];
                // getting a method signature for this block
                NSMethodSignature *methodSignature = blockDescription.blockSignature;
                NSInteger cout = methodSignature.numberOfArguments;
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                [invocation setTarget:[block copy]];
                //NSArray *arguments = @[indexPath,tableView,dataInfo];
                for (NSInteger i = 1; i < cout; i++) {
                    const char *type = [methodSignature getArgumentTypeAtIndex:i];
                    NSString *typeName = [NSString stringWithUTF8String:type];
                    void *arg = &dataInfo;
                    if([typeName isEqualToString:@"@\"NSIndexPath\""]){
                        arg = &indexPath;
                    }else if([typeName isEqualToString:@"@\"UITableView\""]){
                        arg = &tableView;
                    }
                    [invocation setArgument:arg atIndex:i];
                }
                [invocation invoke];
            }
        }
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.autoLayout) {
//        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
//        NSInteger type = [self tableView:tableView typeForRowAtIndexPath:indexPath];
//        if([dataInfo isKindOfClass:[NSDictionary class]] && [dataInfo objectForKey:JDTableViewKeyTypeForRow]){
//            type = [dataInfo[JDTableViewKeyTypeForRow] integerValue];
//        }
//        NSString *cellID = [_cellID stringByAppendingFormat:@"_%ld",(long)type];
//        __weak JDTableViewSimplifyModel *weakSelf = self;
//        return [tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
//            cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//            cell.indexPath = indexPath;
//            cell.keyForTitleView = weakSelf.keyForTitleView;
//            cell.keyForDetailView = weakSelf.keyForDetailView;
//            cell.keyForImageView = weakSelf.keyForImageView;
//            cell.dataInfo = dataInfo;
//        }];
        return  -1.0f;
    }
    //JDLog(@"计算第%d块，第%d行行高",indexPath.section,indexPath.row);
    if(self.cellHeightBlock){
        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
        self.cellHeightBlock(indexPath,dataInfo);
    }else if(respondsSel(self.jdDelegate,@selector(tableView:heightForRowAtIndexPath:))){
        return [self.jdDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        //将计算高度的方法交给cell来处理
        //生成cellid
        id dataInfo = [self dataInfoforCellatTableView:tableView IndexPath:indexPath];
        UITableViewCell *cell = nil;
        if([dataInfo isKindOfClass:[NSDictionary class]] && [dataInfo objectForKey:JDTableViewLayoutForRow]){
            cell = dataInfo[JDTableViewLayoutForRow];
        }else{
            //JDLog(@"渲染第%d块，第%d行",indexPath.section,indexPath.row);
            //生成cellid
            NSInteger type = [self tableView:tableView typeForRowAtIndexPath:indexPath];
            if([dataInfo isKindOfClass:[NSDictionary class]] && [dataInfo objectForKey:JDTableViewKeyTypeForRow]){
                type = [dataInfo[JDTableViewKeyTypeForRow] integerValue];
            }
            NSString *cellID = [_cellID stringByAppendingFormat:@"_%ld",(long)type];
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        }
        if(cell != nil){
            cell.indexPath = indexPath;
            cell.keyForTitleView = self.keyForTitleView;
            cell.keyForDetailView = self.keyForDetailView;
            cell.keyForImageView = self.keyForImageView;
            //给cell的dataInfo赋值,并计算高度
            return [cell tableView:tableView cellInfo:dataInfo];
        }
    }
    return 44.0f;
}

//头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(respondsSel(self.jdDelegate,@selector(tableView:heightForHeaderInSection:))){
        return [self.jdDelegate tableView:tableView heightForHeaderInSection:section];
    }else if(respondsSel(self.jdDataSource,@selector(tableView:titleForHeaderInSection:))){
        NSString *title = [self.jdDataSource tableView:tableView titleForHeaderInSection:section];
        if(title != nil){
            return -1.0f;
        }
    }else{
        if(self.keyOfHeadTitle.length > 0){
            return -1.0f;
        }
    }
    if(section == 0){
        return self.firstSectionHeaderHeight;
    }
    return -1.0f;
}
//脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(respondsSel(self.jdDelegate,@selector(tableView:heightForFooterInSection:))){
        return [self.jdDelegate tableView:tableView heightForFooterInSection:section];
    }else if(respondsSel(self.jdDataSource,@selector(tableView:titleForFooterInSection:))){
        NSString *title = [self.jdDataSource tableView:tableView titleForFooterInSection:section];
        if(title != nil){
            return -1.0f;
        }
    }
    return -1.0f;
}
//组的头 view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(respondsSel(self.jdDelegate,@selector(tableView:viewForHeaderInSection:))){
        return [self.jdDelegate tableView:tableView viewForHeaderInSection:section];
    }else if(respondsSel(self.jdDataSource,@selector(tableView:titleForHeaderInSection:))){
        //如果设置了 title，则不重写head
        return nil;
    }else{//如果不自定义headview并且也没设置title，则给个透明的headview 不然设置了firstSectionHeaderHeight后第一块headview会出现被挡住的效果
        if(self.keyOfHeadTitle == nil){
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, self.firstSectionHeaderHeight)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(respondsSel(self.jdDelegate,@selector(tableView:viewForFooterInSection:))){
      return [self.jdDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}


// Display customization
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(respondsSel(self.jdDelegate,@selector(tableView:willDisplayCell:forRowAtIndexPath:))){
        return [self.jdDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    if(respondsSel(self.jdDelegate ,@selector(tableView:willDisplayHeaderView:forSection:))){
        return [self.jdDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    if(respondsSel(self.jdDelegate,@selector(tableView:willDisplayFooterView:forSection:))){
        return [self.jdDelegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0) {
    if(respondsSel(self.jdDelegate,@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:))){
        return [self.jdDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    if(respondsSel(self.jdDelegate,@selector(tableView:didEndDisplayingHeaderView:forSection:))){
        return [self.jdDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    if(respondsSel(self.jdDelegate,@selector(tableView:didEndDisplayingFooterView:forSection:))){
        return [self.jdDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

#pragma mark  scrollview delegate

- (void)scrollViewDidScroll:(UITableView *)tableView{
    if(isTableView(tableView) && respondsSel(self.jdDelegate,@selector(scrollViewDidScroll:))){
        [self.jdDelegate scrollViewDidScroll:tableView];
    }
}

- (void)scrollViewWillBeginDragging:(UITableView *)tableView {
    if(isTableView(tableView) && respondsSel(self.jdDelegate,@selector(scrollViewWillBeginDragging:))){
        [self.jdDelegate scrollViewWillBeginDragging:tableView];
    }
}
- (void)scrollViewWillEndDragging:(UITableView *)tableView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    if(isTableView(tableView) && respondsSel(self.jdDelegate,@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:))){
        [self.jdDelegate scrollViewWillEndDragging:tableView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UITableView *)tableView willDecelerate:(BOOL)decelerate {
    if(isTableView(tableView) && respondsSel(self.jdDelegate ,@selector(scrollViewDidEndDragging:willDecelerate:))){
        [self.jdDelegate scrollViewDidEndDragging:tableView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UITableView *)tableView {
    if(isTableView(tableView) && respondsSel(self.jdDelegate ,@selector(scrollViewWillBeginDecelerating:))){
        [self.jdDelegate scrollViewWillBeginDecelerating:tableView];
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView{
    if(isTableView(tableView) && respondsSel(self.jdDelegate ,@selector(scrollViewDidEndDecelerating:))){
        [self.jdDelegate scrollViewDidEndDecelerating:tableView];
    }
}

@end



#pragma mark 编辑能力
@implementation JDTableViewSimplifyModel (editable)

- (BOOL)editable{
    return _editable;
}
- (void)setEditable:(BOOL)editable {
    _editable = editable;
}
- (void)setSingleLineDeleteAction:(SingleLineDeleteAction)singleLineDeleteAction{
    _singleLineDeleteAction = singleLineDeleteAction;
    if(singleLineDeleteAction != nil){
        self.editable = YES;
    }else{
        self.editable = NO;
    }
}
- (SingleLineDeleteAction)singleLineDeleteAction{
    return _singleLineDeleteAction;
}

- (void)setMultiLineDeleteAction:(MultiLineDeleteAction)multiLineDeleteAction{
    _multiLineDeleteAction = multiLineDeleteAction;
    if(multiLineDeleteAction != nil){
        self.editable = YES;
    }else{
        self.editable = NO;
    }
}
- (MultiLineDeleteAction)multiLineDeleteAction{
    return _multiLineDeleteAction;
}
- (void)setCanEditable:(CanEditable)canEditable {
    _canEditable = canEditable;
}
- (CanEditable)canEditable{
    return _canEditable;
}
- (void)setDeleteConfirmationButtonTitle:(NSString *)deleteConfirmationButtonTitle {
    _deleteConfirmationButtonTitle = deleteConfirmationButtonTitle;
}
- (NSString *)deleteConfirmationButtonTitle {
    return _deleteConfirmationButtonTitle;
}

#pragma mark 编辑模式

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.canEditable) {
        return self.canEditable(indexPath);
    }
    return self.editable;
}

//编缉按扭样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.multiLineDeleteAction != nil){
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.deleteConfirmationButtonTitle != nil){
        return self.deleteConfirmationButtonTitle;
    }
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.singleLineDeleteAction(indexPath);
    }
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end


