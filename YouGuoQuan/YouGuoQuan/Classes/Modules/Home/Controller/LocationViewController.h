//
//  LocationViewController.h
//  RoomService
//
//  Created by YM on 16/1/16.
//  Copyright © 2016年 SYR. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController

@property (copy, nonatomic) void (^cityBlock)(NSString *city);
@end
