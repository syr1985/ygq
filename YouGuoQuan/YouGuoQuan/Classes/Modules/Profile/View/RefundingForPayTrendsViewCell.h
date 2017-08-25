//
//  WaitingForPayTrendsViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface RefundingForPayTrendsViewCell : UITableViewCell
@property (nonatomic,   copy) void (^deleteOrderBlock)(NSString *orderNo);
@property (nonatomic,   copy) void (^tapViewBolck)(NSString *userId);
@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
