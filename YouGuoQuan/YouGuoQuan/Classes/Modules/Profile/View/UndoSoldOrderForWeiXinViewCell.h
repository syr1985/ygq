//
//  UndoSoldOrderForWeixinViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface UndoSoldOrderForWeiXinViewCell : UITableViewCell
@property (nonatomic,   copy) void (^operateOrderBlock)(NSString *orderNo, BOOL type);
@property (nonatomic,   copy) void (^agreeWithRefundBlock)(NSString *orderNo);
@property (nonatomic,   copy) void (^tapViewBolck)(NSString *userId);
@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
