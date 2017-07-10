//
//  ViewController.m
//  tableivewSimplifyDemo
//
//  Created by 王金东 on 15/7/29.
//  Copyright (c) 2015年 王金东. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+simplify.h"
#import "SMBaseTableViewCellStyle.h"
#import "User.h"
#import "SMRefreshTableViewController.h"
#import "SMRefreshCollectionViewController.h"
#import "SMRefreshManager.h"
#import "SMRefreshDelegate.h"

@interface ViewController ()<SMTableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *secondTableView;
@property (nonatomic,strong) UITableView *thirdTableView;
@property (nonatomic,strong) UITableView *forthTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
    
    self.secondTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.secondTableView];
    
    self.thirdTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.thirdTableView];
    
    self.forthTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.forthTableView];
    
    //实现刷新功能  可全局设置
    [[SMRefreshManager shareInstance] registerRefreshView:[[SMRefreshDelegate alloc] init]];
    
    __weak UIViewController *weakSelf = self;
    
    //第一种
    self.tableView.itemsArray = @[@"第一条",@"第二条",@"第3条",@"第4条",@"第5条",@"第6条",@"第7条",@"第8条",@"第9条",@"第10条",@"第11条"].mutableCopy;
    
    //第二种 可支持自定义model
    self.secondTableView.keyForTitleView = @"title";
    self.secondTableView.itemsArray = @[
                                        @{
                                            @"title" : @"刷新tableView",
                                            SMCellKeySelectedBlock : ^(NSIndexPath *indexPath){
                                                [weakSelf.navigationController pushViewController:[[SMRefreshTableViewController alloc] init] animated:YES];
                                                NSLog(@"选中第%ld行",indexPath.row);
                                            },
                                            },
                                        @{
                                            @"title" : @"刷新collectionView",
                                            SMCellKeySelectedBlock : ^(NSIndexPath *indexPath){
                                                [weakSelf.navigationController pushViewController:[[SMRefreshCollectionViewController alloc] init] animated:YES];
                                                NSLog(@"选中第%ld行",indexPath.row);
                                            },
                                            },
                                        @{
                                            @"title" : @"第仨"
                                            }
                                        ].mutableCopy;
    
    //第三种 支持数组 可支持自定义model
    self.thirdTableView.keyOfHeadTitle = @"title";
    //可以不配置 有默认值
    self.thirdTableView.keyForTitleView = @"title";
    self.thirdTableView.keyForDetailView = @"detail";
    self.thirdTableView.keyOfItemArray = @"items";
    
    self.thirdTableView.sectionable = YES;
    self.thirdTableView.tableViewCellClass = [SMBaseTableViewCellStyleValue1 class];
    self.thirdTableView.itemsArray = @[
                                       @{
                                           @"title" : @"人",
                                           @"items" : @[
                                                   @{
                                                       @"title" : @"美女",
                                                       @"detail" : @"很漂亮"
                                                       },
                                                   @{
                                                       @"title" : @"帅哥",
                                                       @"detail" : @"大长腿"
                                                       }
                                                   ]
                                           },
                                       @{
                                           @"title" : @"第二",
                                           @"items" : @[
                                                   @{
                                                       @"title" : @"美女",
                                                       @"detail" : @"很漂亮"
                                                       },
                                                   @{
                                                       @"title" : @"帅哥",
                                                       @"detail" : @"大长腿"
                                                       }
                                                   ]
                                           },
                                       @{
                                           @"title" : @"第仨",
                                           @"items" : @[
                                                   @{
                                                       @"title" : @"美女",
                                                       @"detail" : @"很漂亮"
                                                       },
                                                   @{
                                                       @"title" : @"帅哥",
                                                       @"detail" : @"大长腿"
                                                       }
                                                   ]
                                           }
                                       ].mutableCopy;
    
    
    
    //第四种 支持数组 自定义model group样式 cell自定义(model只要key对应上即可，跟字典一样的)
    self.forthTableView.keyOfHeadTitle = @"title";
    self.forthTableView.autoLayout = YES;
    self.forthTableView.sectionable = YES;
    self.forthTableView.smDataSource = self;
    self.forthTableView.tableViewCellArray = @[
                                               [UINib nibWithNibName:@"TableViewDemoCell" bundle:nil],
                                               [SMBaseTableViewCellStyleValue1 class]
                                               ];
    self.forthTableView.itemsArray = @[
                                       @{
                                           @"title" : @"人",
                                           @"items" : @[
                                                   [User user:@"张三1" sex:@"男"],
                                                   [User user:@"张三2" sex:@"男"]
                                                   ]
                                           },
                                       @{
                                           @"title" : @"第二",
                                           @"items" : @[
                                                   @{
                                                       @"title" : @"美女",
                                                       @"detail" : @"很漂亮",
                                                       SMCellKeySelectedBlock : ^(NSIndexPath *indexPath){
                                                           [weakSelf.navigationController pushViewController:[[SMRefreshTableViewController alloc] init] animated:YES];
                                                           NSLog(@"选中第%ld行",indexPath.row);
                                                       },
                                                       SMTableViewKeyTypeForRow : @(1)//等同于下面的typeForRowAtIndexPath委托方法
                                                       },
                                                   @{
                                                       @"title" : @"美女",
                                                       @"detail" : @"很漂亮",
                                                       SMTableViewKeyTypeForRow : @(1)//等同于下面的typeForRowAtIndexPath委托方法
                                                       }
                                                   ]
                                           },
                                       @{
                                           @"title" : @"第仨",
                                           @"items" : @[
                                                   [User user:@"张三5" sex:@"女"],
                                                   [User user:@"张三6" sex:@"男"]
                                                   ]
                                           }
                                       ].mutableCopy;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView typeForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row %2 == 0) {
//        return 1;
//    }
//    return 0;
//}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2-5, self.view.frame.size.height/2-5)];
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.enableSimplify = YES;
    }
    return _tableView;
}

- (UITableView *)secondTableView {
    if (_secondTableView == nil) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+5, 0, self.view.frame.size.width/2-5, self.view.frame.size.height/2-5)];
        _secondTableView.backgroundColor = [UIColor blueColor];
        _secondTableView.enableSimplify = YES;
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView {
    if (_thirdTableView == nil) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2+5, self.view.frame.size.width/2-5, self.view.frame.size.height/2-5)];
        _thirdTableView.backgroundColor = [UIColor blueColor];
        _thirdTableView.enableSimplify = YES;
    }
    return _thirdTableView;
}

- (UITableView *)forthTableView {
    if (_forthTableView == nil) {
        _forthTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+5, self.view.frame.size.height/2+5, self.view.frame.size.width/2-5, self.view.frame.size.height/2-5) style:UITableViewStyleGrouped];
        _forthTableView.backgroundColor = [UIColor orangeColor];
        _forthTableView.enableSimplify = YES;
    }
    return _forthTableView;
}
@end
