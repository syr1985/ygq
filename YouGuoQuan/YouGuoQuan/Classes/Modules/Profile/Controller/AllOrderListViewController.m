//
//  PersonOrderListViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "AllOrderListViewController.h"
#import "SelectPaymentViewController.h"
#import "UserCenterViewController.h"

#import "WaitingForPayTrendsViewCell.h"
#import "WaitingForPayMeetingViewCell.h"
#import "OngoingForPayTrendsViewCell.h"
#import "OngoingForPayMeetingViewCell.h"
#import "CompletedForPayTrendsViewCell.h"
#import "CompletedForPayMeetingViewCell.h"
#import "RefundingForPayTrendsViewCell.h"
#import "RefundingForPayMeetingViewCell.h"

#import <MJRefresh.h>
#import "PayTool.h"
#import "MyOrderModel.h"
#import "IAPurchaseTool.h"
#import "AlertViewTool.h"
#import "FuqianlaPayTool.h"

NSString * const kNotification_RefreshOrderList = @"OperateOrderSuccess";

@interface AllOrderListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AllOrderListViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:kNotification_RefreshOrderList
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
    if (self.type == OrderType_All) {
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
    [self getMyOrderList];
}

- (void)loadMoreData {
    _pageNo++;
    [self getMyOrderList];
}

- (void)getMyOrderList {
    
    __weak typeof(self) weakself = self;
    [NetworkTool getMyOrderListWithType:@(_type) pageNo:@(_pageNo) pageSize:@(_pageSize) success:^(id result) {
        [weakself loadSuccessWithData:result];
    } failure:^{
        [weakself loadFailure];
    }];
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

#pragma mark - 订单操作
#pragma mark - 取消订单
- (void)cancelOrder:(NSString *)orderNo {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"您是否取消该订单？" cancelTitle:@"放弃" sureTitle:@"确定" sureBlock:^{
        [NetworkTool cancelOrder:orderNo success:^{
            [SVProgressHUD showSuccessWithStatus:@"取消订单成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"取消订单失败"];
        }];
    } cancelBlock:nil];
}

#pragma mark - 删除订单
- (void)deleteOrder:(NSString *)orderNo {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"您是否删除该订单？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
        [NetworkTool deleteOrder:orderNo operator:@"B" success:^{// 这边@“B”代表啥意思看接口参数说明-buy
            [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"删除订单失败"];
        }];
    } cancelBlock:nil];
}

#pragma mark - 确认支付
- (void)surePay:(NSString *)orderNo {
    [NetworkTool payForConfirmOrderWithOrderNo:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"确认支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"确认支付失败"];
    }];
}
#pragma mark - 申请退款
- (void)applyForRefund:(NSString *)orderNo {
    [NetworkTool applyForRefundWithOrderId:orderNo success:^{
        [SVProgressHUD showSuccessWithStatus:@"申请退款成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"申请退款失败"];
    }];
}
#pragma mark - 继续支付
- (void)goonPay:(NSString *)orderNo price:(NSNumber *)price goodsId:(NSString *)goodsId email:(NSString *)email phone:(NSString *)phone {
    if ([orderNo hasPrefix:@"NM"]) {
        __weak typeof(self) weakself = self;
        UIStoryboard *focusSB = [UIStoryboard storyboardWithName:@"Focus" bundle:nil];
        SelectPaymentViewController *selectPaymentVC = [focusSB instantiateViewControllerWithIdentifier:@"SelectPaymentVC"];
        selectPaymentVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        selectPaymentVC.selectPaymentBlock = ^(NSString *payment) {
            [NetworkTool createOrderWithGoodsId:goodsId
                                        feedsId:@""
                                      payMethod:payment
                                          phone:phone
                                          email:email
                                           desc:@""
                                        orderNo:orderNo
                                        success:^(id result, id payOrderNo) {
                                            [weakself payByWalletWithOrderNo:result payOrderNo:payOrderNo payment:payment price:price];
                                        } failure:^{
                                            [SVProgressHUD showErrorWithStatus:@"创建订单失败"];
                                        }];
        };
        [self presentViewController:selectPaymentVC animated:YES completion:nil];
    } else {
       [self payByWalletWithOrderNo:orderNo];
    }
}

- (void)payByWalletWithOrderNo:(NSString *)orderNo payOrderNo:(NSString *)payOrderNo payment:(NSString *)paytype price:(NSNumber *)price {
    NSInteger priceRMB = price.integerValue / 10;
    NSDictionary *payInfo = @{@"orderNo":orderNo,
                              @"payOrderNo":payOrderNo,
                              @"payType":paytype,
                              @"amount":@(priceRMB),
                              @"desc":@"购买商品"};
    [FuqianlaPayTool payWithType:paytype dataParam:payInfo success:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
    }];
}

#pragma mark - 继续支付--零钱钱包方式
- (void)payByWalletWithOrderNo:(NSString *)orderNo {
    if ([orderNo hasPrefix:@"CF"]) {
        [NetworkTool payforCrowdfundingWithOrderNo:orderNo success:^{
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^(NSError *error, NSString *msg){
            [self payFailureByWalletWithOrderNo:orderNo error:error message:msg];
        }];
    } else if ([orderNo hasPrefix:@"RE"]) {
        [NetworkTool payForRewardWithOrderNo:orderNo success:^{
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^(NSError *error, NSString *msg){
            [self payFailureByWalletWithOrderNo:orderNo error:error message:msg];
        }];
    } else if ([orderNo hasPrefix:@"RP"]) {
        [NetworkTool payForTrendsToUserDirectlyWithOrderNo:orderNo success:^{
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^(NSError *error, NSString *msg){
            [self payFailureByWalletWithOrderNo:orderNo error:error message:msg];
        }];
    } else {
        [NetworkTool payForTrendsToMiddleAccountWithOrderNo:orderNo success:^{
            if ([orderNo hasPrefix:@"DT"]) {
                [SVProgressHUD showSuccessWithStatus:@"您的约见请求已送出，请耐心等待"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshOrderList object:nil];
        } failure:^(NSError *error, NSString *msg){
            [self payFailureByWalletWithOrderNo:orderNo error:error message:msg];
        }];
    }
}
#pragma mark - 继续支付--失败处理--余额不足等
- (void)payFailureByWalletWithOrderNo:(NSString *)orderNo error:(NSError *)error message:(NSString *)msg {
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    } else if ([msg isEqualToString:@"金额不足"]) {
        [PayTool payFailureTranslateToRechargeVC:self rechargeSuccess:^{
            [self payByWalletWithOrderNo:orderNo];
        } rechargeFailure:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
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

#pragma mark - Table view
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakself = self;
    MyOrderModel *model = self.modelArray[indexPath.section];
    // RP(红包照片)NM(普通商品)WX(购买微信)CF(众筹)RB(红包)RE(打赏)
    BOOL isTrends = ![model.orderNo hasPrefix:@"DT"];
    // goodsDetailType 1待付款 2购买进行中 3退款进行中 4购买成功 5 退款成功 6 交易关闭
    
    int goodsDetailType = model.goodsDetailType;
    if (goodsDetailType == 3) {
        // 退款中
        if (isTrends) {
            RefundingForPayTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundingForPayTrendsViewCell" forIndexPath:indexPath];
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
            RefundingForPayMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RefundingForPayMeetingViewCell" forIndexPath:indexPath];
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
    } else if (goodsDetailType == 2) {
        // 已支付
        if (isTrends) {
            OngoingForPayTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OngoingForPayTrendsViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.surePayBlock = ^(NSString *orderNo) {
                [AlertViewTool showAlertViewWithTitle:nil Message:@"是否同意付款？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                    [weakself surePay:orderNo];
                } cancelBlock:nil];
            };
            cell.applyForRefundBlock = ^(NSString *orderNo) {
                [weakself applyForRefund:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else {
            OngoingForPayMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OngoingForPayMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.surePayBlock = ^(NSString *orderNo) {
                [AlertViewTool showAlertViewWithTitle:nil Message:@"是否同意付款？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                    [weakself surePay:orderNo];
                } cancelBlock:nil];
            };
            cell.applyForRefundBlock = ^(NSString *orderNo) {
                [weakself applyForRefund:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        }
    } else if (goodsDetailType == 1) {
        // 待支付
        if (isTrends) {
            WaitingForPayTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaitingForPayTrendsViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.cancelOrderBlock = ^(NSString *orderNo){
                [weakself cancelOrder:orderNo];
            };
            cell.goonPayBolck = ^(NSString *orderNo, NSNumber *price, NSString *goodsId, NSString *buyerEmail, NSString *buyerPhone) {
                [weakself goonPay:orderNo price:price goodsId:goodsId email:buyerEmail phone:buyerPhone];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else {
            WaitingForPayMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WaitingForPayMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.cancelOrderBlock = ^(NSString *orderNo){
                [weakself cancelOrder:orderNo];
            };
            cell.goonPayBolck = ^(NSString *orderNo, NSNumber *price, NSString *goodsId, NSString *buyerEmail, NSString *buyerPhone) {
                [weakself goonPay:orderNo price:price goodsId:goodsId email:buyerEmail phone:buyerPhone];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        }
    } else  {//if (goodsDetailType == 4)
        if (isTrends) {
            CompletedForPayTrendsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedForPayTrendsViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo){
                [weakself deleteOrder:orderNo];
            };
            cell.tapViewBolck = ^(NSString *userId){
                [weakself popToUserCenterViewController:userId];
            };
            cell.dateFormatter = self.dateFormatter;
            cell.orderModel = model;
            return cell;
        } else {
            CompletedForPayMeetingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompletedForPayMeetingViewCell" forIndexPath:indexPath];
            // Configure the cell...
            cell.deleteOrderBlock = ^(NSString *orderNo){
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
    MyOrderModel *model = self.modelArray[indexPath.section];
    if ([model.orderNo hasPrefix:@"DT"]) {
        return 223;
    } else {
        return 174;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.modelArray.count - 1) {
        return 0;
    } else {
       return 12;
    }
}

@end