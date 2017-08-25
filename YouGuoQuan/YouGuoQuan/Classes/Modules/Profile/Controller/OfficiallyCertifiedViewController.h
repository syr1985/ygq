//
//  OfficiallyCertifiedViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

//#import "BaseTableViewController.h"
#import <UIKit/UIKit.h>

extern NSString *const kNotification_OfficiallyCertifiedSuccess;

@class UserBaseInfoModel;
@interface OfficiallyCertifiedViewController : UITableViewController
@property (nonatomic, strong) UserBaseInfoModel *userBaseInfoModel;
@property (nonatomic, assign) BOOL present;
@end
