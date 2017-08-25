//
//  PersonOrderViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/4.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PersonOrderViewController.h"
#import "SCNavTabBarController.h"
#import "AllOrderListViewController.h"

@interface PersonOrderViewController ()

@end

@implementation PersonOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleString = @"购买订单";
    
    UIStoryboard *orderSB = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    AllOrderListViewController *allOrderVC = [orderSB instantiateViewControllerWithIdentifier:@"AllOrderListVC"];
    allOrderVC.type = OrderType_All;
    allOrderVC.title = @"全部";
    
    AllOrderListViewController *readyPayVC = [orderSB instantiateViewControllerWithIdentifier:@"AllOrderListVC"];
    readyPayVC.type = OrderType_Waiting;
    readyPayVC.title = @"待支付";
    
    AllOrderListViewController *orderingVC = [orderSB instantiateViewControllerWithIdentifier:@"AllOrderListVC"];
    orderingVC.type = OrderType_Ongoing;
    orderingVC.title = @"进行中";
    
    AllOrderListViewController *orderEndVC = [orderSB instantiateViewControllerWithIdentifier:@"AllOrderListVC"];
    orderEndVC.type = OrderType_Completed;
    orderEndVC.title = @"已完成";
    
    AllOrderListViewController *rollBackVC = [orderSB instantiateViewControllerWithIdentifier:@"AllOrderListVC"];
    rollBackVC.type = OrderType_Refunding;
    rollBackVC.title = @"退款中";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[allOrderVC, readyPayVC, orderingVC, orderEndVC, rollBackVC];
    navTabBarController.navTabBarColor     = [UIColor whiteColor];
    navTabBarController.navTabBarLineColor = [UIColor whiteColor];
    navTabBarController.titleFont = [UIFont systemFontOfSize:14];
    navTabBarController.navType = NavType_Order;
    navTabBarController.showSpaceLine = YES;
    [navTabBarController addParentController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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