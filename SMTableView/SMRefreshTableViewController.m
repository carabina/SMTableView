//
//  SMRefreshTableViewController.m
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/12/16.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "SMRefreshTableViewController.h"
#import "UITableView+simplify.h"

@interface SMRefreshTableViewController ()

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation SMRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.enableSimplify = YES;
    //开启下拉刷新功能
    self.tableView.refreshHeaderable = YES;
    //开启上拉刷新功能
    self.tableView.refreshFooterable = YES;
    self.tableView.smDelegate = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.itemsArray = @[@"第一条",@"第二条",@"第3条",@"第4条",@"第5条",@"第6条",@"第7条",@"第8条",@"第9条",@"第10条",@"第11条"].mutableCopy;
    
    self.tableView.singleLineDeleteAction = ^(NSIndexPath *indexPath){
        NSLog(@"%@",indexPath);
    };
    
    //self.tableView.refreshDelegate = self; 可设置委托类
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"haha");

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.backgroundColor = [UIColor redColor];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
