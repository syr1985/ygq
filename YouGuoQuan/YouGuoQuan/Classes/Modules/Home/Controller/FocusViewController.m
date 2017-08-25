//
//  FocusViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/5.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FocusViewController.h"
#import "ReportViewController.h"
#import "UserCenterViewController.h"
#import "TrendsDetailViewController.h"
#import "LookPhotosViewController.h"

#import "FocusTrendsViewCell.h"
#import "FocusVideoViewCell.h"
#import "FocusRedEnvelopeViewCell.h"

#import "AlertViewTool.h"
#import "HomeFocusModel.h"
#import <Masonry.h>
#import <MJRefresh.h>

@interface FocusViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) BOOL scrollUpNotification;
@property (nonatomic, assign) BOOL scrollDownNotification;
@property (nonatomic, assign) BOOL presentLoginUI;
@end

static NSString * const tableViewCellID_trends   = @"FocusTrendsViewCell";
static NSString * const tableViewCellID_video    = @"FocusVideoViewCell";
static NSString * const tableViewCellID_envelope = @"FocusRedEnvelopeViewCell";

@implementation FocusViewController

#pragma mark -
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        __weak typeof(self) weakself = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.view.mas_top);
            make.left.equalTo(weakself.view.mas_left);
            make.right.equalTo(weakself.view.mas_right);
            make.bottom.equalTo(weakself.view.mas_bottom);
        }];
    }
    return _tableView;
}

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
                                             selector:@selector(loginSuccessReloadData:)
                                                 name:kNotification_LoginSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteTrendsSuccess:)
                                                 name:kNotification_DeleteTrendsSuccess
                                               object:nil];
    
    [self configViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([LoginData sharedLoginData].userId) {
        if (!self.modelArray.count) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)loginSuccessReloadData:(NSNotification *)noti {
    BOOL isChangeAccount = [noti.userInfo[@"ChangeAccount"] boolValue];
    if (isChangeAccount) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)didEnterBackground {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayingVideoNotification
                                                        object:nil
                                                      userInfo:@{@"feedsId":@""}];
    
}

- (void)deleteTrendsSuccess:(NSNotification *)noti {
    NSString *trendsId = noti.userInfo[@"trendsId"];
    __weak typeof(self) weakself = self;
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeFocusModel *model = (HomeFocusModel *)obj;
        if ([model.focusId isEqualToString:trendsId]) {
            [weakself updateLocalData:idx];
            *stop = YES;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s",__func__);
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
    self.pageSize = 5;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.tableView.backgroundColor = NavBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    UINib *nib_trends = [UINib nibWithNibName:tableViewCellID_trends bundle:nil];
    [self.tableView registerNib:nib_trends forCellReuseIdentifier:tableViewCellID_trends];
    
    UINib *nib_video  = [UINib nibWithNibName:tableViewCellID_video bundle:nil];
    [self.tableView registerNib:nib_video forCellReuseIdentifier:tableViewCellID_video];
    
    UINib *nib_envelope = [UINib nibWithNibName:tableViewCellID_envelope bundle:nil];
    [self.tableView registerNib:nib_envelope forCellReuseIdentifier:tableViewCellID_envelope];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 设置刷新控件
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreData)];
    // 设置文字
    [footer setTitle:@"上拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"到底了" forState:MJRefreshStateNoMoreData];
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

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    [NetworkTool getHomeFocusListWithPageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            HomeFocusModel *model = [HomeFocusModel homeFocusModelWithDict:dict];
            [muArray addObject:model];
        }
        if (weakself.pageNo == 1) {
            weakself.modelArray = muArray;
            [weakself.tableView reloadData];
            [weakself.tableView.mj_header endRefreshing];
            weakself.tableView.mj_footer.hidden = muArray.count == 0;
            if (muArray.count < weakself.pageSize) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakself.tableView.mj_footer resetNoMoreData];
            }
        } else {
            [weakself.modelArray addObjectsFromArray:muArray];
            [weakself.tableView reloadData];
            if (muArray.count < weakself.pageSize) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakself.tableView.mj_footer endRefreshing];
            }
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
#pragma mark - 更多按钮点击底部弹出ActionSheet
- (void)moreButtonClicked:(NSUInteger)buttonIndex userId:(NSString *)userId aboutID:(NSString *)aboutId {
    if (buttonIndex == 2) {
        // 拉黑警告
        [AlertViewTool showAlertViewWithTitle:nil Message:@"拉黑对方后，对方将无法与您聊天，您也无法查看对方动态，是否继续？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
            // 拉黑操作
            [NetworkTool doOperationWithType:@"3" userId:userId operationType:@"1" success:^{
                [SVProgressHUD showSuccessWithStatus:@"已将对方拉黑"];
            }];
        } cancelBlock:nil];
    } else if (buttonIndex == 1) {
        // 举报操作
        UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
        ReportViewController *reportVC = [discoverySB instantiateViewControllerWithIdentifier:@"Report"];
        reportVC.aboutId = aboutId;
        reportVC.reportType = ReportType_Trends;
        reportVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.tabBarController presentViewController:reportVC animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - 置顶动态、删除动态
- (void)handleMyTrendsWithIndex:(NSUInteger)index trendsID:(NSString *)trendsId modelIndex:(NSInteger)row {
    __weak typeof(self) weakself = self;
    if (index == 1) {
        [NetworkTool deleteTrendsWithTrendsID:trendsId success:^{
            [SVProgressHUD showSuccessWithStatus:@"删除动态成功"];
            [weakself updateLocalData:row];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"删除动态失败"];
        }];
    }
}

#pragma mark -
#pragma mark - 更新本地数据
- (void)updateLocalData:(NSInteger )row {
    [self.modelArray removeObjectAtIndex:row];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark -
#pragma mark - 跳转到详情页
- (void)popToDetailViewController:(HomeFocusModel *)model {
    if (model.feedsType == 3) {
//        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
//        ProductDetailViewController *productDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
//        productDetailVC.homeFocusModel = model;
//        [self presentViewController:productDetailVC animated:YES completion:nil];
    } else {
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        TrendsDetailViewController *trendsDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"TrendsDetailVC"];
        trendsDetailVC.hidesBottomBarWhenPushed = YES;
        trendsDetailVC.homeFocusModel = [model copy];
        [self.navigationController pushViewController:trendsDetailVC animated:YES];
    }
}

#pragma mark -
#pragma mark - 跳转到TA人中心
- (void)popToUserCenterViewController:(NSString *)userId {
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

#pragma mark -
#pragma mark - 跳转到购买红包页
- (void)popToBuyPacketViewController:(NSInteger)price goodsID:(NSString *)goodsId feedsID:(NSString *)feedsId headImg:(NSString *)headImg nickName:(NSString *)nickName {
    UIStoryboard *otherSB = [UIStoryboard storyboardWithName:@"Other" bundle:nil];
    LookPhotosViewController *buyRedPacketVC = [otherSB instantiateViewControllerWithIdentifier:@"BuyRedEnvelope"];
    buyRedPacketVC.headImg = headImg;
    buyRedPacketVC.nickName = nickName;
    buyRedPacketVC.price = price;
    buyRedPacketVC.goodsId = goodsId;
    buyRedPacketVC.feedsId = feedsId;
    buyRedPacketVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.tabBarController presentViewController:buyRedPacketVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFocusModel *model = self.modelArray[indexPath.row];
    __weak typeof(self) weakself = self;
    if (model.feedsType == 1) {
        FocusTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_trends forIndexPath:indexPath];
        cell.tapHeaderView = ^(NSString *userId) {
            [weakself popToUserCenterViewController:userId];
        };
        cell.commentBlock = ^(HomeFocusModel *model) {
            [weakself popToDetailViewController:model];
        };
        cell.handleTrendsBlock = ^(NSUInteger index, NSString *focusId, NSInteger row) {
            [weakself handleMyTrendsWithIndex:index trendsID:focusId modelIndex:row];
        };
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *focusId) {
            [weakself moreButtonClicked:index userId:userId aboutID:focusId];
        };
        cell.homeFocusModel = model;
        cell.row = indexPath.row;
        return cell;
    } else if (model.feedsType == 2) {
        FocusVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_video forIndexPath:indexPath];
        cell.tapHeaderView = ^(NSString *userId) {
            [weakself popToUserCenterViewController:userId];
        };
        cell.commentBlock = ^(HomeFocusModel *model) {
            [weakself popToDetailViewController:model];
        };
        cell.handleTrendsBlock = ^(NSUInteger index, NSString *focusId, NSInteger row) {
            [weakself handleMyTrendsWithIndex:index trendsID:focusId modelIndex:row];
        };
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *focusId) {
            [weakself moreButtonClicked:index userId:userId aboutID:focusId];
        };
        cell.homeFocusModel = model;
        cell.row = indexPath.row;
        return cell;
    } else if (model.feedsType == 4) {
        FocusRedEnvelopeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_envelope forIndexPath:indexPath];
        cell.tapHeaderView = ^(NSString *userId) {
            [weakself popToUserCenterViewController:userId];
        };
        cell.commentBlock = ^(HomeFocusModel *model) {
            [weakself popToDetailViewController:model];
        };
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *focusId) {
            [weakself moreButtonClicked:index userId:userId aboutID:focusId];
        };
        cell.buyRedPacketBlock =  ^(NSInteger price, NSString *goodsId, NSString *feedsId, NSString *headImg, NSString *nickName) {
            [weakself popToBuyPacketViewController:price goodsID:goodsId feedsID:feedsId headImg:headImg nickName:nickName];
        };
        cell.handleTrendsBlock = ^(NSUInteger index, NSString *focusId, NSInteger row) {
            [weakself handleMyTrendsWithIndex:index trendsID:focusId modelIndex:row];
        };
        cell.homeFocusModel = model;
        cell.row = indexPath.row;
        return cell;
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeFocusModel *model = self.modelArray[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[FocusVideoViewCell class]]) {
        FocusVideoViewCell *videoCell = (FocusVideoViewCell *)cell;
        [videoCell releaseWMPlayer];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳详情页
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[FocusVideoViewCell class]]) {
        FocusVideoViewCell *videoCell = (FocusVideoViewCell *)cell;
        [videoCell stopWMPlayer];
    }
    HomeFocusModel *model = self.modelArray[indexPath.row];
    [self popToDetailViewController:model];
}

@end
