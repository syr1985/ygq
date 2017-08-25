//
//  SelectPaymentViewController.h
//  YouGuoQuan
//
//  Created by YM on 2017/7/14.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPaymentViewController : UIViewController
@property (nonatomic,   copy) void (^selectPaymentBlock)(NSString *payment);
@end
