//
//  SMRefreshDelegate.m
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/12/16.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "SMRefreshDelegate.h"
#import <MJRefresh/MJRefresh.h>

//给scrollView加个category  实现下拉、上拉刷新 然后在下面的代码调用一下即可
@implementation SMRefreshDelegate

- (void)scrollView:(UIScrollView *)scrollView addHeaderWithTarget:(id)delegate action:(SEL)action {
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:delegate refreshingAction:action];
}
- (void)scrollView:(UIScrollView *)scrollView addFooterWithTarget:(id)delegate action:(SEL)action {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:delegate refreshingAction:action];
}

- (void)removeHeaderFromScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header removeFromSuperview];
}
- (void)removeFooterFromScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer removeFromSuperview];
}

- (void)headerEndRefreshingFromScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_header endRefreshing];
}
- (void)footerEndRefreshingFromScrollView:(UIScrollView *)scrollView {
    [scrollView.mj_footer endRefreshing];
}
@end
