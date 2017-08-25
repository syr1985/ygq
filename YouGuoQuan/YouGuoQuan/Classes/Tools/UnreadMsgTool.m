//
//  UnreadMsgTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/7/25.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UnreadMsgTool.h"
#import "EMClient.h"
#import "BaseTabBarController.h"

@interface UnreadMsgTool () <EMChatManagerDelegate>

@end

@implementation UnreadMsgTool

+ (void)getTotalUnreadMessageNumber {
    if ([EMClient sharedClient].isLoggedIn) {
        [NetworkTool getUnreadMessageNumberSuccess:^(id result){
            NSInteger totalMsgCount = 0;
            NSNumber *systemMsgCount    = result[@"messageCount"];
            if (systemMsgCount) {
                totalMsgCount += systemMsgCount.integerValue;
            }
            NSNumber *focusMsgCount     = result[@"focusMeCount"];
            if (focusMsgCount) {
                totalMsgCount += focusMsgCount.integerValue;
            }
            NSNumber *zanMsgCount       = result[@"zanMeCount"];
            if (zanMsgCount) {
                totalMsgCount += zanMsgCount.integerValue;
            }
            NSNumber *commentMsgCount   = result[@"commentMeCount"];
            if (commentMsgCount) {
                totalMsgCount += commentMsgCount.integerValue;
            }
            
            [self getTotalConversationUnreadMessageNumberWithNumber:totalMsgCount];
        } failure:^{
            [self getTotalConversationUnreadMessageNumberWithNumber:0];
        }];
    }
}

+ (void)getTotalConversationUnreadMessageNumberWithNumber:(NSInteger)totalSystemNumber {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    
    __block NSInteger unreadMsgCount = totalSystemNumber;
    [conversations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMConversation *concersation = (EMConversation *)obj;
        unreadMsgCount += [concersation unreadMessagesCount];
    }];
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootVC isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController *tabBarController = (BaseTabBarController *)rootVC;
        if (tabBarController.tabBar) {
            if (tabBarController.tabBar.items.count > 2) {
                UITabBarItem *item = tabBarController.tabBar.items[2];
                NSString *badgeValue = unreadMsgCount == 0 ? nil : [NSString stringWithFormat:@"%zd",unreadMsgCount];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [item setBadgeValue:badgeValue];
                });
            }
        }
    }
}

@end
