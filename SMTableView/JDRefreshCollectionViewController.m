//
//  JDRefreshCollectionViewController.m
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/12/21.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "JDRefreshCollectionViewController.h"
#import "UICollectionView+simplify.h"
#import "JDBaseCollectionViewCell.h"

@interface JDRefreshCollectionViewController ()

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation JDRefreshCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.collectionView.enableSimplify = YES;
    //开启下拉刷新功能
    self.collectionView.refreshHeaderable = YES;
    //开启上拉刷新功能
    self.collectionView.refreshFooterable = YES;
    [self.view addSubview:self.collectionView];
    
    
    self.collectionView.collectionViewCellClass = [JDBaseCollectionViewCell class];
    
    self.collectionView.itemsArray = @[@"第一条",@"第二条",@"第3条",@"第4条",@"第5条",@"第6条",@"第7条",@"第8条",@"第9条",@"第10条",@"第11条"].mutableCopy;
    
    // Do any additional setup after loading the view.
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor grayColor];
    }
    return _collectionView;
}


@end
