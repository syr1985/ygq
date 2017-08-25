//
//  AuthorityTool.h
//  YouGuoQuan
//
//  Created by YM on 2017/5/5.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorityTool : NSObject

//+ (void)permissionDeniedTranslateToViewController:(UIViewController *)vc;

+ (void)chatPermissionDeniedFromViewController:(UIViewController *)fromVC returnBlock:(void (^)())handle;

+ (void)publishPermissionDeniedFromViewController:(UIViewController *)fromVC;

+ (void)publishProductPermissionDeniedFromViewController:(UIViewController *)fromVC;

@end
