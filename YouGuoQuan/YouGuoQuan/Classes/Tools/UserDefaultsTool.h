//
//  UserDefaultsTool.h
//  YouGuoQuan
//
//  Created by YM on 2017/5/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNotification_LoginSuccess;

@interface UserDefaultsTool : NSObject

+ (void)loginWithData:(NSDictionary *)userLoginData showHUD:(BOOL)show;

+ (void)registerWithData:(NSDictionary *)userRegisterData;

+ (void)saveLoginDataWithData:(NSDictionary *)userLoginData;

+ (void)autoLogin;

@end
