//
//  smCollectionViewSimplifyModel.m
//  smCore
//
//  Created by 王金东 on 16/1/22.
//  Copyright © 2016年 王金东. All rights reserved.
//

#import "SMCollectionViewSimplifyModel.h"
#import "UICollectionViewCell+simplify.h"

#define collectionCellId @"collectionCellId"

#define c_respondsSel(target,sel)  (target && [target respondsToSelector:sel])
#define isCollectionView(collectionView) ([collectionView isKindOfClass:[UICollectionView class]])

@implementation SMCollectionViewSimplifyModel {
    NSMutableArray *_itemArray;
}

- (NSMutableArray *)itemsArray{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)setItemsArray:(NSMutableArray *)itemsArray {
    if([itemsArray isMemberOfClass:[NSArray class]]){
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

#pragma mark -----------------------我是分隔线---------------------
#pragma mark -------------------------数据源---------------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.sectionable) {
        return self.itemsArray.count;
    }
    return 1;
}
//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(c_respondsSel(self.smDataSource,@selector(collectionView:numberOfItemsInSection:))){
        return [self.smDataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    if(self.sectionable && self.itemsArray.count > 0){//分块 二维数组
        id cellInfo = self.itemsArray[section];
        if([cellInfo isKindOfClass:[NSArray class]]){
            return [(NSArray *)cellInfo count];
        }else if([cellInfo isKindOfClass:[NSDictionary class]]){
            NSArray *array = cellInfo[self.keyOfItemArray];
            if(array != nil && [array isKindOfClass:[NSArray class]]){
                return  [array count];
            }
        }
        return 0;
    }
    NSInteger count = self.itemsArray.count;
    return count;
}


//获取当前数据，分组与不分组的数据
- (id)dataInfoforCellatCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    if(self.itemsArray.count == 0){
        return nil;
    }
    id dataInfo = nil;
    //设置数据源给tableviewcell
    if(self.sectionable){//分块
        id cellInfo = self.itemsArray[indexPath.section];
        if([cellInfo isKindOfClass:[NSArray class]]){
            dataInfo = cellInfo[indexPath.row];
        }else if([cellInfo isKindOfClass:[NSDictionary class]]){
            NSArray *array = cellInfo[self.keyOfItemArray];
            if(array != nil && [array isKindOfClass:[NSArray class]]){
                dataInfo = array[indexPath.row];
            }
        }
    }else{
        dataInfo = self.itemsArray[indexPath.row];
    }
    return dataInfo;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (c_respondsSel(self.smDataSource,@selector(collectionView:cellForItemAtIndexPath:))) {
        return [self.smDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellId forIndexPath:indexPath];
    
    NSAssert([cell isKindOfClass:[UICollectionViewCell class]], @"cell必须是UICollectionViewCell的子类");
    cell.viewController = self.viewController;
    cell.dataInfo = [self dataInfoforCellatCollectionView:collectionView indexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (c_respondsSel(self.smDataSource ,@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:))) {
        return [self.smDataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:sizeForItemAtIndexPath:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    return flowLayout.itemSize;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:insetForSectionAtIndex:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    return flowLayout.sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    return flowLayout.minimumLineSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    return flowLayout.minimumInteritemSpacing;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:referenceSizeForHeaderInSection:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:layout:referenceSizeForFooterInSection:))) {
        return [self.smDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    return CGSizeZero;
}

- (void)scrollViewDidEndDragging:(UICollectionView *)collectionView willDecelerate:(BOOL)decelerate{
    if(c_respondsSel(self.smDelegate,@selector(scrollViewDidEndDragging:willDecelerate:))){
        [self.smDelegate scrollViewDidEndDragging:collectionView willDecelerate:decelerate];
    }
}
- (void)scrollViewDidScroll:(UICollectionView *)collectionView {
    if(c_respondsSel(self.smDelegate,@selector(scrollViewDidScroll:))){
        [self.smDelegate scrollViewDidScroll:collectionView];
    }
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (c_respondsSel(self.smDelegate,@selector(collectionView:didSelectItemAtIndexPath:))) {
        [self.smDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}


@end
