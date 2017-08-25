//
//  PraiseMessageViewController.m
//  YouGuoQuan
//
//  Created by liushuai on 16/12/9.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PraiseMessageViewController.h"
#import "UserCenterViewController.h"
#import "PraiseMessageCell.h"
#import "AlertViewTool.h"
#import <MJRefresh.h>
#import "FavourMessageModel.h"

@interface PraiseMessageViewController ()

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

@implementation PraiseMessageViewController

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewController];
}

- (void)configViewController {
    self.titleString = @"赞";
    
    self.pageNo = 1;
    self.pageSize = 15;
    self.tableView.rowHeight = 56;
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 立即刷新
    [header beginRefreshing];
    // 设置刷新控件
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"上拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    //[footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
    footer.automaticallyRefresh = NO;
    footer.hidden = YES;
    // 设置footer
    self.tableView.mj_footer = footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewData {
    _pageNo = 1;
    [self loadDataFromServer];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool getUnreadFavourMessageWithPageNo:@(_pageNo) pageSize:@(_pageSize) Success:^(id result) {
        NSLog(@"%@",result);
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            FavourMessageModel *model = [FavourMessageModel favourMessageModelWithDict:dict];
            [muArray addObject:model];
        }
        weakself.tableView.mj_footer.hidden = muArray.count < weakself.pageSize;
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
            weakself.modelArray = muArray;
            [weakself.tableView reloadData];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.modelArray addObjectsFromArray:muArray];
            [weakself.tableView reloadData];
        }
    } failure:^{
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -
#pragma mark - 页面跳转
- (void)popToOtherCenter:(NSString *)userId {
    NSString *loginId = [LoginData sharedLoginData].userId;
    if ([userId isEqualToString:loginId]) {
        self.tabBarController.selectedIndex = 3;
    } else {
        UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        UserCenterViewController *userCenterVC = [otherSB instantiateViewControllerWithIdentifier:@"UserCenter"];
        userCenterVC.userId = userId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PraiseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PraiseMessageCell" forIndexPath:indexPath];
    __weak typeof(self) weakself = self;
    cell.tapHeaderImageViewBlock = ^(NSString *userId) {
        [weakself popToOtherCenter:userId];
    };
    cell.favourMessageModel = self.modelArray[indexPath.row];
    return cell;
}

@end
