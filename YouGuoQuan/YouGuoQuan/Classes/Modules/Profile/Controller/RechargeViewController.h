//
//  RechargeViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/1/6.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeViewController : BaseViewController
@property (nonatomic,   copy) void (^successBlock)();
@property (nonatomic,   copy) void (^failureBlock)();
@property (nonatomic, assign) BOOL present;
@end