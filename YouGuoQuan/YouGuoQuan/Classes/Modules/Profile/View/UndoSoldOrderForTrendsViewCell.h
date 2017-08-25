//
//  UndoSoldOrderForTrendsViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/19.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface UndoSoldOrderForTrendsViewCell : UITableViewCell
@property (nonatomic,   copy) void (^sendedProductBlock)(NSString *orderNo, BOOL type);
@property (nonatomic,   copy) void (^agreeWithRefundBlock)(NSString *orderNo, BOOL refuse);
@property (nonatomic,   copy) void (^tapViewBolck)(NSString *userId);
@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
