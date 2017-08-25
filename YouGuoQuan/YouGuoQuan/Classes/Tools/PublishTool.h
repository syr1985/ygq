//
//  PublishTool.h
//  YouGuoQuan
//
//  Created by YM on 2017/8/18.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishTool : NSObject
+ (void)presentViewControllerWithIdentifier:(NSString *)vcId presenting:(UIViewController *)presentingVC;
+ (BOOL)canPublishWithID:(NSString *)vcId;
@end
