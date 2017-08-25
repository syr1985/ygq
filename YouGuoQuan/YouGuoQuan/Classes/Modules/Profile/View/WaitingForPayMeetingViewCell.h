//
//  WaitingForPayMeetingViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface WaitingForPayMeetingViewCell : UITableViewCell
@property (nonatomic,   copy) void (^goonPayBolck)(NSString *orderNo, NSNumber *price, NSString *goodsId, NSString *buyerEmail, NSString *buyerPhone);
@property (nonatomic,   copy) void (^cancelOrderBlock)(NSString *orderNo);
@property (nonatomic,   copy) void (^tapViewBolck)(NSString *userId);
@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
