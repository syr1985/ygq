//
//  AllSoldOrderListViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "BaseViewController.h"

//typedef NS_ENUM(NSInteger, SoldOrderType) {
//    SoldOrderType_Done = 1,
//    SoldOrderType_Undo,
//    SoldOrderType_All
//};

@interface AllSoldOrderListViewController : BaseViewController
@property (nonatomic,   copy) NSString *type;
@property (nonatomic, assign) BOOL fromSellWeixinPage;
@end
