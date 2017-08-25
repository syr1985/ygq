//
//  NearbyPersonViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NearbyPersonViewController.h"
#import "UserCenterViewController.h"

#import "NearbyPersonViewCell.h"
#import "UserBaseInfoModel.h"
#import "CityLocation.h"
#import <MJRefresh.h>
#import "MoreMenuHelp.h"

@interface NearbyPersonViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *getLocationFailedView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic,   copy) NSString *sex; // 筛选条件
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

static NSString *const tableViewCellID = @"NearbyPersonViewCell";

@implementation NearbyPersonViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenMenuItemSelect:)
                                                 name:kNotification_ShowScreenMenu
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"NavItemSelectedNotification"
                                               object:nil];
    
    
    __weak typeof(self) weakself = self;
    [CityLocation sharedInstance].getCoordinate = ^(CLLocationCoordinate2D coordinate) {
        weakself.coordinate = coordinate;
        [weakself loadDataFromServer];
        weakself.getLocationFailedView.hidden = YES;
    };
    [CityLocation sharedInstance].locationFailed = ^{
        weakself.getLocationFailedView.hidden = NO;
    };
    
    [self configViewController];
}

- (void)screenMenuItemSelect:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSInteger tabBarIndex = [userInfo[@"tabBarIndex"] integerValue];
    if (tabBarIndex == 1) {
        [MoreMenuHelp showScreenMenuWithResult:^(NSUInteger index) {
            if (index != 0) {
                _pageNo = 1;
                _sex = index == 2 ? @"男" : (index == 3 ? @"女" : @"");
                [self loadDataFromServer];
            }
        }];
    }
}

- (void)refreshTable:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    if (userInfo) {
        if ([userInfo[@"title"] isEqualToString:self.title]) {
            [[CityLocation sharedInstance] startLocation];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:@"NavItemSelectedNotification"
                                                          object:nil];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            // Add code to preserve data stored in the views that might be
            // needed later.
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

#pragma mark -
#pragma mark - 配置控制器
- (void)configViewController {
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.rowHeight = 56;
    self.tableView.backgroundColor = BackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    //[header beginRefreshing];
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
    [[CityLocation sharedInstance] startLocation];
}

- (void)loadMoreData {
    _pageNo++;
    [self loadDataFromServer];
}

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    [SVProgressHUD showWithStatus:@"获取附近的人"];
    NSString *longitude = [NSString stringWithFormat:@"%f",_coordinate.longitude];
    NSString *latitude  = [NSString stringWithFormat:@"%f",_coordinate.latitude];
    __weak typeof(self) weakself = self;
    [NetworkTool getDiscoveryNearbyUsersListWithPageNo:@(_pageNo) pageSize:@(_pageSize) longitude:longitude latitude:latitude sex:_sex success:^(id result) {
        [SVProgressHUD dismiss];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            UserBaseInfoModel *model = [UserBaseInfoModel userBaseInfoModelWithDict:dict];
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
        [SVProgressHUD dismiss];
        if (weakself.pageNo == 1) {
            [weakself.tableView.mj_header endRefreshing];
        } else {
            [weakself.tableView.mj_footer endRefreshing];
        }
    }];
}

- (IBAction)reloadData {
    [self loadNewData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyPersonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.myCoordinate = _coordinate;
    cell.nearbyUserModel = self.modelArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![LoginData sharedLoginData].userId) {
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    
    UserBaseInfoModel *userModel = self.modelArray[indexPath.row];
    NSString *otherId = userModel.userId;
    NSString *loginId = [LoginData sharedLoginData].userId;
    if ([otherId isEqualToString:loginId]) {
        self.tabBarController.selectedIndex = 3;
    } else {
        UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
        UserCenterViewController *userCenterVC = [otherSB instantiateViewControllerWithIdentifier:@"UserCenter"];
        userCenterVC.userId = otherId;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
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
