//
//  UndoSoldOrderForRewardViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2017/3/7.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyOrderModel;
@interface UndoSoldOrderForRewardViewCell : UITableViewCell
@property (nonatomic,   copy) void (^tapViewBolck)(NSString *userId);
@property (nonatomic, strong) MyOrderModel *orderModel;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
