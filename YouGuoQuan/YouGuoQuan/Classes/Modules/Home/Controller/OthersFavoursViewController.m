//
//  OthersFavoursViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "OthersFavoursViewController.h"
#import "ReportViewController.h"
#import "UserCenterViewController.h"
#import "TrendsDetailViewController.h"
#import "LookPhotosViewController.h"

#import "FocusTrendsViewCell.h"
#import "FocusVideoViewCell.h"
#import "FocusRedEnvelopeViewCell.h"

#import "AlertViewTool.h"
#import "HomeFocusModel.h"
#import <MJRefresh.h>

@interface OthersFavoursViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@end

static NSString * const tableViewCellID_trends   = @"FocusTrendsViewCell";
static NSString * const tableViewCellID_video    = @"FocusVideoViewCell";
static NSString * const tableViewCellID_envelope = @"FocusRedEnvelopeViewCell";

@implementation OthersFavoursViewController

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleString = [_userId isEqualToString:[LoginData sharedLoginData].userId] ? @"我赞过的" :@"Ta赞过的";
    
    UILabel *warningLabel = [self.noResultView viewWithTag:1];
    warningLabel.text = [_userId isEqualToString:[LoginData sharedLoginData].userId] ? @"您还没有赞过" :@"Ta还没有赞过任何内容哦";
    
    [self configViewController];
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
            self.tableView = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

#pragma mark -
#pragma mark - 配置控制器
- (void)configViewController {
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
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

- (void)loadDataSuccess:(NSArray *)dataArray {
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in dataArray) {
        HomeFocusModel *model = [HomeFocusModel homeFocusModelWithDict:dict];
        [muArray addObject:model];
    }
    
    self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
    if (_pageNo == 1) {
        [_tableView.mj_header endRefreshing];
        _modelArray = muArray;
        [_tableView reloadData];
    } else {
        [_tableView.mj_footer endRefreshing];
        [_modelArray addObjectsFromArray:muArray];
        [_tableView reloadData];
    }
    _noResultView.hidden = _modelArray.count;
}

- (void)loadDataFailure {
    if (_pageNo == 1) {
        [_tableView.mj_header endRefreshing];
    } else {
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark -
#pragma mark - 从服务器加载数据
- (void)loadDataFromServer {
    __weak typeof(self) weakself = self;
    if ([_userId isEqualToString:[LoginData sharedLoginData].userId]) {
        [NetworkTool getMyFavoursListWithPageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
            [weakself loadDataSuccess:result];
        } failure:^{
            [weakself loadDataFailure];
        }];
    } else {
        [NetworkTool getOtherFavoursWithPageNo:@(_pageNo) pageSize:@(_pageSize) userID:_userId success:^(id result) {
            [weakself loadDataSuccess:result];
        } failure:^{
            [weakself loadDataFailure];
        }];
    }
}

#pragma mark -
#pragma mark - 更多菜单
- (void)moreButtonClicked:(NSUInteger)buttonIndex toUser:(NSString *)userId {
    if (buttonIndex == 1) {
        // 拉黑警告
        [AlertViewTool showAlertViewWithTitle:nil Message:@"拉黑对方后，对方将无法与您聊天，您也无法查看对方动态，是否继续？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
            // 拉黑操作
            [NetworkTool doOperationWithType:@"3" userId:userId operationType:@"1" success:^{
                [SVProgressHUD showSuccessWithStatus:@"已将对方拉黑"];
            }];
        } cancelBlock:nil];
    } else if (buttonIndex == 2) {
        // 举报操作
        UIStoryboard *discoverySB = [UIStoryboard storyboardWithName:@"Discovery" bundle:nil];
        ReportViewController *reportVC = [discoverySB instantiateViewControllerWithIdentifier:@"Report"];
        reportVC.aboutId = userId;
        reportVC.reportType = ReportType_Person;
        reportVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:reportVC animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - 跳转到详情页
- (void)popToDetailViewController:(HomeFocusModel *)model {
    UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
    TrendsDetailViewController *trendsDetailVC = [focusSB instantiateViewControllerWithIdentifier:@"TrendsDetailVC"];
    trendsDetailVC.hidesBottomBarWhenPushed = YES;
    trendsDetailVC.homeFocusModel = model;
    [self.navigationController pushViewController:trendsDetailVC animated:YES];
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
    buyRedPacketVC.headImg  = headImg;
    buyRedPacketVC.nickName = nickName;
    buyRedPacketVC.price    = price;
    buyRedPacketVC.goodsId  = goodsId;
    buyRedPacketVC.feedsId  = feedsId;
    buyRedPacketVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:buyRedPacketVC animated:YES completion:nil];
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
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *facusId) {
            [weakself moreButtonClicked:index toUser:userId];
        };
        cell.homeFocusModel = model;
        return cell;
    } else if (model.feedsType == 2) {
        FocusVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_video forIndexPath:indexPath];
        cell.tapHeaderView = ^(NSString *userId) {
            [weakself popToUserCenterViewController:userId];
        };
        cell.commentBlock = ^(HomeFocusModel *model) {
            [weakself popToDetailViewController:model];
        };
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *facusId) {
            [weakself moreButtonClicked:index toUser:userId];
        };
        cell.homeFocusModel = model;
        return cell;
    } else if (model.feedsType == 4) {
        FocusRedEnvelopeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID_envelope forIndexPath:indexPath];
        cell.tapHeaderView = ^(NSString *userId) {
            [weakself popToUserCenterViewController:userId];
        };
        cell.commentBlock = ^(HomeFocusModel *model) {
            [weakself popToDetailViewController:model];
        };
        cell.actionSheetItemClicked = ^(NSUInteger index, NSString *userId, NSString *facusId) {
            [weakself moreButtonClicked:index toUser:userId];
        };
        cell.buyRedPacketBlock =  ^(NSInteger price, NSString *goodsId, NSString *feedsId, NSString *headImg, NSString *nickName) {
            [weakself popToBuyPacketViewController:price goodsID:goodsId feedsID:feedsId headImg:headImg nickName:nickName];
        };
        cell.homeFocusModel = model;
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
    HomeFocusModel *model = self.modelArray[indexPath.row];
    [self popToDetailViewController:model];
}

@end
