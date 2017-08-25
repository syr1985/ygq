//
//  FavorerListViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/22.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FavorerListViewController.h"
#import "OthersFocusViewCell.h"
#import "OthersFocusModel.h"
#import <MJRefresh.h>

@interface FavorerListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const tableViewCellID_OthersFocus = @"OthersFocusViewCell";

@implementation FavorerListViewController

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
    // Do any additional setup after loading the view.
    
    [self configViewController];
    
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //    self.modelArray = nil;
}

#pragma mark -
#pragma mark - 配置控制器
- (void)configViewController {
    self.titleString = @"点赞列表";
    
    self.pageNo = 1;
    self.pageSize = 20;
    
    self.tableView.rowHeight = 56;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    UINib *nib = [UINib nibWithNibName:tableViewCellID_OthersFocus bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:tableViewCellID_OthersFocus];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
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

- (void)loadNewData {
    _pageNo = 1;
    [self loadDataFromServer];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}

- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool getTrendsFavorerListWithPageNo:@(_pageNo) pageSize:@(_pageSize) feedsId:_trendsId success:^(id result) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            OthersFocusModel *model = [OthersFocusModel othersFocusModelWithDict:dict];
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
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OthersFocusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_OthersFocus forIndexPath:indexPath];
    
    // Configure the cell...
    cell.othersFocusModel = self.modelArray[indexPath.row];
    
    return cell;
}

@end