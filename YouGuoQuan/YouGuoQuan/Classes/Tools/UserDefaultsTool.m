//
//  UserDefaultsTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/5/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UserDefaultsTool.h"
#import "AlertViewTool.h"

@implementation UserDefaultsTool

+ (void)loginWithData:(NSDictionary *)userLoginData showHUD:(BOOL)show {
    if (show) {
        [SVProgressHUD showWithStatus:@"登录中"];
    }
    [NetworkTool loginWithPhone:userLoginData[@"phone"] Password:userLoginData[@"password"] Success:^(id result) {
        NSLog(@"%@",result);
        [SVProgressHUD dismiss];
        
        [LoginData loginDataWithDict:result];
        
        BOOL isChangeAccount = NO;
        NSDictionary *oldInfoDict = [SCUserDefault objectForKey:KEY_USER_ACCOUNT];
        if (!oldInfoDict || ![oldInfoDict[@"phone"] isEqualToString:userLoginData[@"phone"]]) {
            isChangeAccount = YES;
        }
        
        [self saveLoginDataWithData:userLoginData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_LoginSuccess
                                                            object:nil
                                                          userInfo:@{@"ChangeAccount":@(isChangeAccount)}];
    }];

}

+ (void)registerWithData:(NSDictionary *)userRegisterData {
    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:@"注册中..."];
    [NetworkTool registerWithPhone:userRegisterData[@"phone"] Password:userRegisterData[@"password"] NickName:userRegisterData[@"name"] Sex:userRegisterData[@"sex"] City:userRegisterData[@"city"] success:^(id result){
        [SVProgressHUD dismiss];
        
        NSDictionary *loginData = @{@"phone":userRegisterData[@"phone"],@"password":userRegisterData[@"password"]};
        NSString *returnCode = [result objectForKey:@"result"];
        if ([returnCode isEqualToString:@"004"]) {
            [AlertViewTool showAlertViewWithTitle:nil Message:@"该手机号已注册尤果圈账号，是否使用新密码登录？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
                [NetworkTool resetPasswordWithPhone:userRegisterData[@"phone"] Password:userRegisterData[@"password"] Result:^{
                    [weakself loginWithData:loginData showHUD:YES];
                }];
                [MobClick event:@"UserRegister"];
            } cancelBlock:nil];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [weakself loginWithData:loginData showHUD:NO];
        }
    } failed:^{
        [SVProgressHUD dismiss];
    }];
}

+ (void)saveLoginDataWithData:(NSDictionary *)userLoginData {
    [SCUserDefault setObject:userLoginData forKey:KEY_USER_ACCOUNT];
    [SCUserDefault synchronize];
}

+ (void)autoLogin {
    NSDictionary *loginInfo = [SCUserDefault objectForKey:KEY_USER_ACCOUNT];
    if (loginInfo) {
        [self loginWithData:loginInfo showHUD:NO];
    }
}

@end
