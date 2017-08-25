//
//  AllSoldOrderListViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AllSoldOrderListViewController.h"
#import "UserCenterViewController.h"

#import "UndoSoldOrderForTrendsViewCell.h"
#import "UndoSoldOrderForWeiXinViewCell.h"
#import "UndoSoldOrderForMeetingViewCell.h"
#import "UndoSoldOrderForRewardViewCell.h"

#import "DoneSoldOrderForRewardViewCell.h"
#import "DoneSoldOrderForWeiXinViewCell.h"
#import "DoneSoldOrderForMeetingViewCell.h"

#import <MJRefresh.h>
#import "MyOrderModel.h"

@interface AllSoldOrderListViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

NSString * const kNotification_RefreshSoldOrderList = @"OperateSoldOrderSuccess";

@implementation AllSoldOrderListViewController

#pragma mark -
#pragma mark - 懒加载
- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray new];
    }
    return _modelArray;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

#pragma mark -
#pragma mark - 系统方法
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:kNotification_RefreshSoldOrderList
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"NavItemSelectedNotification"
                                               object:nil];
    
    self.pageNo = 1;
    self.pageSize = 10;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGFLOAT_MIN)];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadNewData)];
    // 设置文字
    [header setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 马上进入刷新状态
    if ([self.type isEqualToString:@""]) {
        [header beginRefreshing];
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 数据接口
- (void)refreshTable:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    if (userInfo) {
        if ([userInfo[@"title"] isEqualToString:self.title]) {
            [self.tableView.mj_header beginRefreshing];
        }
    } else {
         [self.tableView.mj_header beginRefreshing];
    }
}

- (void)loadNewData {
    _pageNo = 1;
    [self getMySoldOrderList];
}

- (void)loadMoreData {
    _pageNo++;
    [self getMySoldOrderList];
}

- (void)loadSuccessWithData:(id)result {
    [SVProgressHUD dismiss];
//    NSLog(@"%@",result);
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dict in result) {
        MyOrderModel *model = [MyOrderModel myOrderModelWithDict:dict];
        [muArray addObject:model];
    }
    self.tableView.mj_footer.hidden = muArray.count < self.pageSize;
    if (self.pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
        self.modelArray = muArray;
        [self.tableView reloadData];
        self.noResultView.hidden = muArray.count;
    } else {
        [self.tableView.mj_footer endRefreshing];
        [self.modelArray addObjectsFromArray:muArray];
        [self.tableView reloadData];
    }
}

- (void)loadFailure {
    [SVProgressHUD dismiss];
    if (self.pageNo == 1) {
        [self.tableView.mj_header endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)getMySoldOrderList {
    [SVProgressHUD showWithStatus:@"加载数据"];
    __weak typeof(self) weakself = self;
    if (_fromSellWeixinPage) {
        [NetworkTool orderListOfSellWeixinWithType:_type pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result){
            [weakself loadSuccessWithData:result];
        } failure:^{
            [weakself loadFailure];
        }];
    } else {
        [NetworkTool getMySoldOrderListWithType:_type pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
            [weakself loadSuccessWithData:result];
        } failure:^{
            [weakself loadFailure];
        }];
    }
}

#pragma mark -
#pragma mark - 操作订单
- (void)operateOrderWithNo:(NSString *)orderNo serviceType:(BOOL)type {
    [NetworkTool refuseOrAcceptServiceWithType:@(type) orderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"订单处理成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshSoldOrderList object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"订单处理失败"];
    }];
}

- (void)deleteOrder:(NSString *)orderNo {
    [NetworkTool deleteOrder:orderNo operator:@"S" success:^{
        [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshSoldOrderList object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
    }];
}

- (void)agreeWithRefundWithOrderNo:(NSString *)orderNo agree:(BOOL)refuseOrAgree {
    [NetworkTool sellerAgreeWithRefundWithOrderNo:orderNo refuse:refuseOrAgree success:^{
        [SVProgressHUD showSuccessWithStatus:@"订单处理成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshSoldOrderList object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"订单处理失败"];
    }];
}


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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.modelArray[indexPath.row];
    NSString *orderNo = model.orderNo;
    __weak typeof(self) weakself = self;
    
    // orderType;       // 1 = 同意退款，2 = 拒绝服务、见面，3 = 正常，4 = 已发货 5 = 拒绝退款
    // orderStatus;     // 1 = 已完成，2 = 进行中 3 = 关闭
    // payStatus;       // 1 = 待支付，2 = 已支付
    // 未处理
    if (((model.orderType == 3 || model.orderType == 1) && model.orderStatus == 2)) {
        if ([orderNo hasPrefix:@"NM"]) {
            UndoSoldOrderForTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForTrendsViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.sendedProductBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo, BOOL refuse) {
                [weakself agreeWithRefundWithOrderNo:orderNo agree:refuse];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"WX"]) {
            UndoSoldOrderForWeiXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForWeiXinViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.operateOrderBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo) {
                [weakself agreeWithRefundWithOrderNo:orderNo agree:YES];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            UndoSoldOrderForRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForRewardViewCell" forIndexPath:indexPath];
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else {
            UndoSoldOrderForMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UndoSoldOrderForMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.operateOrderBlock = ^(NSString *orderNo, BOOL type) {
                [weakself operateOrderWithNo:orderNo serviceType:type];
            };
            cell.agreeWithRefundBlock = ^(NSString *orderNo) {
                [weakself agreeWithRefundWithOrderNo:orderNo agree:YES];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        }
    } else {
        // 已处理
        if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            DoneSoldOrderForRewardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForRewardViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else if ([orderNo hasPrefix:@"WX"]) {
            DoneSoldOrderForWeiXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForWeiXinViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else {
            DoneSoldOrderForMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneSoldOrderForMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo) {
                [weakself deleteOrder:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.modelArray[indexPath.row];
    NSString *orderNo = model.orderNo;
    if (model.orderType == 3 && model.orderStatus == 2) {
        // 未处理
        if ([orderNo hasPrefix:@"WX"]) {
            return 200;
        } else if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            return 174;
        } else {
            return 223;
        }
    } else {
        // 已处理
        if ([orderNo hasPrefix:@"RP"] || [orderNo hasPrefix:@"RE"]) {
            return 174;
        } else if ([orderNo hasPrefix:@"WX"]) {
            return 200;
        } else {
            return 223;
        }
    }
}

@end
