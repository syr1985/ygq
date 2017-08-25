//
//  PublishTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/8/18.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PublishTool.h"
#import "AuthorityTool.h"
#import "RechargeViewController.h"

@implementation PublishTool

+ (void)presentViewControllerWithIdentifier:(NSString *)vcId presenting:(UIViewController *)presentingVC {
    if ([vcId isEqualToString:@"RechargeVC"]) {
        UIStoryboard *walletSB = [UIStoryboard storyboardWithName:@"Wallet" bundle:nil];
        RechargeViewController *rechargeVC = [walletSB instantiateViewControllerWithIdentifier:vcId];
        rechargeVC.present = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rechargeVC];
        [presentingVC presentViewController:nav animated:YES completion:nil];
    } else {
        if ([self canPublishWithID:vcId]) {
            UIStoryboard *publishSB = [UIStoryboard storyboardWithName:@"Publish" bundle:nil];
            UINavigationController *publishVC = [publishSB instantiateViewControllerWithIdentifier:vcId];
            [presentingVC presentViewController:publishVC animated:YES completion:nil];
        } else {
            if ([vcId isEqualToString:@"PublishProduct"]) {
                [AuthorityTool publishProductPermissionDeniedFromViewController:presentingVC];
            } else {
                [AuthorityTool publishPermissionDeniedFromViewController:presentingVC];
            }
        }
    }
}

+ (BOOL)canPublishWithID:(NSString *)vcId {
    if ([vcId isEqualToString:@"PublishRedEnvelope"]) {
        return  [LoginData sharedLoginData].star > 3 ||
                [LoginData sharedLoginData].audit == 1 ||
                [LoginData sharedLoginData].audit == 3;
    } else {
        return  [LoginData sharedLoginData].star > 2 ||
        [LoginData sharedLoginData].isRecommend ||
        [LoginData sharedLoginData].audit == 1 ||
        [LoginData sharedLoginData].audit == 3;
    }
}

@end
