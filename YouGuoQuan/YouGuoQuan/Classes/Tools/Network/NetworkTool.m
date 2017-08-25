//
//  NetworkTool.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/15.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NetworkTool.h"
#import "NetWorking.h"
#import "NSString+Random.h"
#import <QiniuSDK.h>
#import "QiniuUploadHelper.h"

@implementation NetworkTool

+ (void)getMyPromotionIncomeInfoSuccess:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"userId"]       = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_MyPromotionIncome parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)cancelOrder:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"orderNo"]      = orderNo;
    
    [NetWorking postSessionWithUrl:Profile_Order_CancelOrder parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)verifyReceiptWithReceipt:(NSString *)receipt orderNo:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"receipt"]     = receipt;
    muDict[@"orderNo"]     = orderNo;
    
    [NetWorking postSessionWithUrl:Profile_IAP_VerifyReceipt parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteImageFromPhotoWallWithImageId:(NSString *)imageId success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"id"]          = imageId;
    muDict[@"imageUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_DelPhotoWallImage parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)refreshPayOrderNoWithOrderNo:(NSString *)orderNo success:(void (^)(id))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]   = orderNo;
    
    [NetWorking postSessionWithUrl:Profile_RefreshPayOrderNo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)orderListOfSellWeixinWithType:(NSString *)dealType pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"dealType"]   = dealType;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"saleUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_SellWX_OrderList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)sellerAgreeWithRefundWithOrderNo:(NSString *)orderNo refuse:(BOOL)refuseOrAgree success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]    = [NSString randomString];
    muDict[@"sign"]          = @"";
    muDict[@"orderNo"]       = orderNo;
    muDict[@"agreeOrRefuse"] = refuseOrAgree ? @"Y" : @"N";
    
    [NetWorking postSessionWithUrl:Profile_SellerAgreeRefund parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)clearSystemMessageSuccess:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]    = [NSString randomString];
    muDict[@"sign"]          = @"";
    muDict[@"userId"]        = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Message_ClearSystemMessage parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)walletWithdrawCashWithMoney:(NSString *)money realName:(NSString *)realName account:(NSString *)relationValue Success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]    = [NSString randomString];
    muDict[@"sign"]          = @"";
    muDict[@"userId"]        = [LoginData sharedLoginData].userId;
    muDict[@"money"]         = money;
    muDict[@"realName"]      = realName;
    muDict[@"relationValue"] = relationValue;
    
    [NetWorking postSessionWithUrl:Profile_WalletWithdrawCash parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMyContriMoneyWithCFId:(NSString *)cfId Success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"cfid"]       = cfId;
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Discovery_GetMyContriMoney parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"money"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getUnreadCommentMessageWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize Success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Message_GetUnreadCommentMsg parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getUnreadFavourMessageWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize Success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Message_GetUnreadFavourMsg parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getUnreadSystemMessageWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize Success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Message_GetUnreadSystemMsg parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getUnreadMessageNumberSuccess:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Message_GetUnreadMsgNumber parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)updateUserLocationInfoWithCity:(NSString *)city latitude:(NSString *)latitude longitude:(NSString *)longitude success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"city"]       = city;
    muDict[@"latitude"]   = latitude;
    muDict[@"longitude"]  = longitude;
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_UpdateUserLocation parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getUserInfoByHuanXinAccountWith:(NSString *)hxid success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]     = [NSString randomString];
    muDict[@"sign"]           = @"";
    muDict[@"hxid"]           = hxid;
    muDict[@"searcherUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Message_GetUserBaseInfo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMyFavoursListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyFavoursList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMyFunsFocusBlackListWithType:(NSNumber *)type pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"type"]       = type;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyFunsFocuses parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)refuseOrAcceptServiceWithType:(NSNumber *)type orderNo:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"type"]       = type;
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Profile_SoldOrder_Refuse parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMySoldOrderListWithType:(NSString *)dealType pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"pageNo"]      = pageNo;
    muDict[@"pagesize"]    = pageSize;
    muDict[@"dealType"]    = dealType;
    muDict[@"saleUserId"]  = [LoginData sharedLoginData].userId;
    
    
    [NetWorking postSessionWithUrl:Profile_GetMySoldOrderList parameters:muDict success:^(id responseObject) {
        //NSLog(@"%@ \n %@",muDict, responseObject);
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)applyForRefundWithOrderId:(NSString *)orderNo success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Profile_Order_ApplyRefund parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)evaluateOrderWithOrderId:(NSString *)orderId goodsId:(NSString *)goodsId content:(NSString *)content stars:(NSNumber *)stars success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderId;// 改用传订单号
    muDict[@"goodsId"]    = goodsId;
    muDict[@"content"]    = content;
    muDict[@"stars"]      = stars;
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_Order_Evaluate parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteOrder:(NSString *)orderNo operator:(NSString *)salerOrBuyer success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"orderNo"]      = orderNo;
    muDict[@"salerOrBuyer"] = salerOrBuyer;
    
    [NetWorking postSessionWithUrl:Profile_Order_Delete parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)addPhotosToPhotosWallWithImageUrl:(NSString *)imageUrl success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    muDict[@"imageUrl"]   = imageUrl;
    
    [NetWorking postSessionWithUrl:Profile_AddPhotosToWall parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMyLevelScoreInfoSuccess:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyLevelScore parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getIncomeOrExpenditureInfoWithType:(NSString *)type detailType:(NSString *)detailType pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize Success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"type"]       = type;
    muDict[@"detailType"] = detailType;
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyIncomeInfo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
    
}

+ (void)getMyWalletInfoSuccess:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyWalletInfo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)officiallyCertifiedWithAuditResult:(NSString *)auditResult verifiCode:(NSString *)verifiCode account:(NSString *)zfbAccount imageUrl:(NSString *)authentiUrl realName:(NSString *)realName mobile:(NSString *)mobile auditType:(NSNumber *)auditType success:(void (^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]       = [NSString randomString];
    muDict[@"sign"]             = @"";
    muDict[@"auditResult"]      = auditResult;
    muDict[@"verifiCode"]       = verifiCode;
    muDict[@"zfbAccount"]       = zfbAccount;
    muDict[@"authentiUrl"]      = authentiUrl;
    muDict[@"realName"]         = realName;
    muDict[@"mobile"]           = mobile;
    muDict[@"auditType"]        = auditType;
    muDict[@"id"]               = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_OfficialCertified parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getVerifyCodeForOfficiallyCertifiedWithPhoneNumber:(NSString *)phone success:(void (^)(id))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"mobile"]     = phone;
    
    [NetWorking postSessionWithUrl:Profile_GetVerifyCode parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"verifiCode"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)submitFeedbackWithSuggestion:(NSString *)tReasons success:(void (^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"tReasons"]   = tReasons;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_SubmitFeedback parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)modifyPersonInfoWithType:(NSString *)mType value:(NSString *)newValue success:(void (^)())success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"mType"]      = mType;
    muDict[@"newValue"]   = newValue;
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_ModifyPersonInfo parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        } 
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMyOrderListWithType:(NSNumber *)orderType pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"type"]       = orderType;
    muDict[@"buyUserId"]  = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Profile_GetMyOrderList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        }
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteWeiXinWithWeixinID:(NSString *)weixinId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = weixinId;
    
    [NetWorking postSessionWithUrl:Profile_WeiXin_Delete parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteRedPacketWithRedPacketID:(NSString *)redPacketId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = redPacketId;
    
    [NetWorking postSessionWithUrl:Profile_RedPacket_Delete parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteProductWithProductID:(NSString *)productId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = productId;
    
    [NetWorking postSessionWithUrl:Profile_Product_Delete parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteTrendsWithTrendsID:(NSString *)trendsId success:(void (^)())success failure:(void(^)())failure  {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = trendsId;
    
    [NetWorking postSessionWithUrl:Profile_Trends_Delete parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)checkOrderStatusOrderNo:(NSString *)orderNo payment:(NSString *)payMethod success:(void (^)())success failure:(void(^)(NSError *error))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    muDict[@"payMethod"]  = payMethod;
    //NSLog(@"%@",muDict);
    [NetWorking postSessionWithUrl:Pay_CheckOrderNo_Nobility parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error);
        }
    } progress:nil];
}

+ (void)payForNobilityWithOrderNo:(NSString *)orderNo paymth:(NSString *)paymth success:(void (^)())success failure:(void(^)(NSError *error, NSString *msg))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    muDict[@"paymth"]     = paymth;
    
    [NetWorking postSessionWithUrl:Pay_Imediately_Nobility parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error, msg);
        }
    } progress:nil];
}


+ (void)createBuyNobilityOrderWithOrderNo:(NSString *)orderNo money:(NSNumber *)money payMethod:(NSString *)payMethod month:(NSNumber *)nobleType success:(void (^)(id result, id payOrderNo))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"money"]      = money;
    muDict[@"buyUserId"]  = [LoginData sharedLoginData].userId;
    muDict[@"orderNo"]    = orderNo;
    muDict[@"nobleType"]  = nobleType;
    muDict[@"payMethod"]  = payMethod;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Nobility parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)createRechargeOrderWithOrderNo:(NSString *)orderNo money:(NSString *)money payMethod:(NSString *)payMethod success:(void (^)(id result, id payOrderNo))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"money"]      = money;
    muDict[@"buyerId"]    = [LoginData sharedLoginData].userId;
    muDict[@"orderNo"]    = orderNo;
    muDict[@"payMethod"]  = payMethod;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Recharge parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)createDateOrderWithOrderNo:(NSString *)orderNo serviceName:(NSString *)serviceName payMethod:(NSString *)payMethod salerId:(NSString *)salerId price:(NSString *)price dateTimeInfo:(NSString *)dateTimeInfo dateAddress:(NSString *)dateAddress success:(void (^)(id result, id payOrderNo))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"serviceName"]  = serviceName;
    muDict[@"price"]        = price;
    muDict[@"payMethod"]    = payMethod;
    muDict[@"buyerId"]      = [LoginData sharedLoginData].userId;
    muDict[@"salerId"]      = salerId;
    muDict[@"orderNo"]      = orderNo;
    muDict[@"dateTimeInfo"] = dateTimeInfo;
    muDict[@"dateAddress"]  = dateAddress;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Date parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)generateOrderNoWithGoodsType:(NSString *)goodsType success:(void (^)(id result))success failure:(void (^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"goodsType"]  = goodsType;
    
    [NetWorking postSessionWithUrl:Pay_GenerateOrder_OrderNo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)payForRewardWithOrderNo:(NSString *)orderNo success:(void (^)())success failure:(void(^)(NSError *error, NSString *msg))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_ToUserDirectly_Reward parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error, msg);
        }
    } progress:nil];
}

+ (void)createRewardOrderWithUserID:(NSString *)toUserId money:(NSString *)money payMethod:(NSString *)payMethod rType:(NSString *)rType memo:(NSString *)memo orderNo:(NSString *)orderNo success:(void (^)(id result, id payOrderNo))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"memo"]       = memo;
    muDict[@"rType"]      = rType;
    muDict[@"money"]      = money;
    muDict[@"payMethod"]  = payMethod;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    muDict[@"toUserId"]   = toUserId;
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Reward parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)createRedPacketOrderWithGoodsId:(NSString *)goodsId feedsId:(NSString *)feedsId payMethod:(NSString *)payMethod phone:(NSString *)phone orderNo:(NSString *)orderNo success:(void (^)(id result, id payOrderNo))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"goodsId"]    = goodsId;
    muDict[@"feedsId"]    = feedsId;
    muDict[@"payMethod"]  = payMethod;
    muDict[@"buyerId"]    = [LoginData sharedLoginData].userId;
    muDict[@"buyerPhone"] = phone;
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_RedPacket parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)createWeiXinOrderWithSalerId:(NSString *)salerId payMethod:(NSString *)payMethod orderNo:(NSString *)orderNo weixin:(NSString *)account success:(void (^)(id result, id payOrderNo))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"salerId"]    = salerId;
    muDict[@"buyerId"]    = [LoginData sharedLoginData].userId;
    muDict[@"payMethod"]  = payMethod;
    muDict[@"orderNo"]    = orderNo;
    muDict[@"buyerDesc"]  = account;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_WeiXin parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)payforCrowdfundingWithOrderNo:(NSString *)orderNo success:(void (^)())success failure:(void(^)(NSError *error, NSString *msg))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_Imediately_Crowdfunding parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error, msg);
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)createCrowdfundingOrderWithCfId:(NSString *)cfid payMethod:(NSString *)payMethod money:(NSString *)money phone:(NSString *)phone email:(NSString *)email orderNo:(NSString *)orderNo success:(void (^)(id result, id payOrderNo))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"cfid"]       = cfid;
    muDict[@"payMethod"]  = payMethod;
    muDict[@"buyerId"]    = [LoginData sharedLoginData].userId;
    muDict[@"buyerPhone"] = phone;
    muDict[@"buyerEmail"] = email;
    muDict[@"money"]      = money;
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Crowdfunding parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)payForConfirmOrderWithOrderNo:(NSString *)orderNo success:(void (^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_ForConfirmOrder_Trends parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)payForTrendsToUserDirectlyWithOrderNo:(NSString *)orderNo success:(void (^)())success failure:(void(^)(NSError *error, NSString *msg))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_ToUserDirectly_Trends parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error, msg);
        }
    } progress:nil];
}


+ (void)payForTrendsToMiddleAccountWithOrderNo:(NSString *)orderNo success:(void (^)())success failure:(void(^)(NSError *error, NSString *msg))failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_ToMiddleAccount_Trends parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure(error, msg);
        }
    } progress:nil];
}

+ (void)createOrderWithGoodsId:(NSString *)goodsId feedsId:(NSString *)feedsId payMethod:(NSString *)payMethod phone:(NSString *)phone email:(NSString *)email desc:(NSString *)desc orderNo:(NSString *)orderNo success:(void (^)(id result, id payOrderNo))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"goodsId"]    = goodsId;
    muDict[@"feedsId"]    = feedsId;
    muDict[@"payMethod"]  = payMethod;
    muDict[@"buyerId"]    = [LoginData sharedLoginData].userId;
    muDict[@"buyerPhone"] = phone;
    muDict[@"buyerEmail"] = email;
    muDict[@"buyerDesc"]  = desc;
    muDict[@"orderNo"]    = orderNo;
    
    [NetWorking postSessionWithUrl:Pay_CreateOrder_Trends parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"orderNo"], responseObject[@"payOrderNo"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getDiscoveryParticipatenListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize cfID:(NSString *)cfId  success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"cfid"]       = cfId;
    
    [NetWorking postSessionWithUrl:Discovery_ParticipatenList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getDiscoveryNearbyUsersListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize longitude:(NSString *)longitude latitude:(NSString *)latitude sex:(NSString *)sex success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"longitude"]  = longitude;
    muDict[@"latitude"]   = latitude;
    muDict[@"sex"]        = sex;
    
    if ([LoginData sharedLoginData].userId) {
        muDict[@"id"]     = [LoginData sharedLoginData].userId;
    }
    
    [NetWorking postSessionWithUrl:Discovery_NearbyUsersList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getDiscoveryCrowdfundingListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Discovery_CrowdfundingList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getDiscoveryVideosListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Discovery_VideosList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getDiscoveryTrendsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize sex:(NSString *)sex success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId ? [LoginData sharedLoginData].userId : @"";
    muDict[@"sex"]        = sex;
    //NSLog(@"%@",muDict);
    [NetWorking postSessionWithUrl:Discovery_TrendsList parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}


+ (void)getTrendsFavorerListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize feedsId:(NSString *)feedsId success:(void (^)(id result))success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"feedsId"]    = feedsId;
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Detail_GetFavorers parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)deleteCommentWithFeedsID:(NSString *)feedsId commentID:(NSString *)commentId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"feedsId"]    = feedsId;
    muDict[@"id"]         = commentId;
    
    [NetWorking postSessionWithUrl:Detail_DeleteComment parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getTotalCommentCountWithTrendsID:(NSString *)trendsId success:(void (^)(id result))success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = trendsId;
    
    [NetWorking postSessionWithUrl:Detail_CommentTotalCount parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"count"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getTrendsDetailWithTreendsID:(NSString *)trendsId success:(void (^)(id result))success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = trendsId;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Detail_Trends parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getGoodsCommentListWithPageNO:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize trendsId:(NSString *)trendsId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"id"]         = trendsId;
    
    [NetWorking postSessionWithUrl:Detail_GetGoodsComments parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getCommentListWithPageNO:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize trendsId:(NSString *)trendsId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"id"]         = trendsId;
    
    [NetWorking postSessionWithUrl:Detail_GetComments parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getProductDetailWithProductID:(NSString *)productId success:(void (^)(id result))success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"id"]         = productId;
    
    [NetWorking postSessionWithUrl:Detail_Product parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getOtherFavoursWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize userID:(NSString *)toUserId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    muDict[@"toUserId"]   = toUserId;
    
    [NetWorking postSessionWithUrl:Others_GetOtherFavours parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getOtherContributerWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize userID:(NSString *)userId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"userId"]     = userId;
    
    [NetWorking postSessionWithUrl:Others_GetContributers parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getOtherTrendsWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize userID:(NSString *)userId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"userId"]     = userId;
    muDict[@"myUserId"]   = [LoginData sharedLoginData].userId;
    //NSLog(@"%@",muDict);
    [NetWorking postSessionWithUrl:Others_GetTrends parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)doCommentWithContent:(NSString *)commentContent toUser:(NSString *)aboutUserId toComment:(NSString *)aboutCommentId  toProduct:(NSString *)aboutId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]       = [NSString randomString];
    muDict[@"sign"]             = @"";
    muDict[@"commentContent"]   = commentContent;
    muDict[@"aboutUserId"]      = aboutUserId;
    muDict[@"aboutCommentId"]   = aboutCommentId;
    muDict[@"aboutId"]          = aboutId;
    muDict[@"fromUserNickName"] = [LoginData sharedLoginData].nickName;
    muDict[@"fromUserId"]       = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Detail_DoComment parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)doFavourWithFeedsID:(NSString *)feedsId userId:(NSString *)toUserId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"feedsId"]     = feedsId;
    muDict[@"toUserId"]    = toUserId;
    muDict[@"fromUserId"]  = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Detail_DoFavour parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)cancelFavourWithFeedsID:(NSString *)feedsId userID:(NSString *)toUserId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"feedsId"]     = feedsId;
    muDict[@"toUserId"]    = toUserId;
    muDict[@"fromUserId"]  = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Detail_CancelFavour parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)updatePlayTimesWithVideoTrendsID:(NSString *)trendsID success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"id"]          = trendsID;
    
    [NetWorking postSessionWithUrl:Detail_UpdatePlayTimes parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getOthersFunsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize userID:(NSString *)searchedId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"pageNo"]      = pageNo;
    muDict[@"pagesize"]    = pageSize;
    muDict[@"searcherid"]  = [LoginData sharedLoginData].userId;
    muDict[@"searchedid"]  = searchedId;
    
    [NetWorking postSessionWithUrl:Others_GetOthersFuns parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getOthersFocusListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize userID:(NSString *)searchedId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"pageNo"]      = pageNo;
    muDict[@"pagesize"]    = pageSize;
    muDict[@"searcherid"]  = [LoginData sharedLoginData].userId;
    muDict[@"searchedid"]  = searchedId;
    
    [NetWorking postSessionWithUrl:Others_GetOthersFocus parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)doOperationWithType:(NSString *)relType userId:(NSString *)toUserId operationType:(NSString *)type success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"relType"]    = relType;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    muDict[@"toUserId"]   = toUserId;
    muDict[@"type"]       = type;
    
    [NetWorking postSessionWithUrl:Detail_DoOperation parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            if ([relType isEqualToString:@"1"]) {
                [SVProgressHUD showErrorWithStatus:@"关注Ta失败"];
            } else if ([relType isEqualToString:@"2"]) {
                [SVProgressHUD showErrorWithStatus:@"赞Ta失败"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"拉黑Ta失败"];
            }
        }
    } progress:nil];
}

+ (void)getOtherPhotosWithUserID:(NSString *)userId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"id"]          = userId;
    
    [NetWorking postSessionWithUrl:Others_GetUserPhotos parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getHomeFocusListWithPageNo:(NSNumber *)pagetNO pageSize:(NSNumber *)pageSize success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"pageNo"]      = pagetNO;
    muDict[@"pagesize"]    = pageSize;
    muDict[@"fromUserId"]  = [LoginData sharedLoginData].userId;
    
    [NetWorking postSessionWithUrl:Home_GetFocusTrends parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)reportOthersWithType:(NSNumber *)type reason:(NSString *)tReasons aboutID:(NSString *)aboutId success:(void (^)())success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"tReasons"]   = tReasons;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId;
    muDict[@"aboutId"]    = aboutId;
    muDict[@"type"]       = type;
    
    [NetWorking postSessionWithUrl:Others_Reporting parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"举报失败"];
        }
    } progress:nil];
}

+ (void)getOthersInfoWithUserId:(NSString *)userId success:(void (^)(id result))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = userId;
    muDict[@"searcherId"] = [LoginData sharedLoginData].userId;
    //NSLog(@"%@",muDict);
    [NetWorking postSessionWithUrl:Others_UserBaseInfo parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        }
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getMsgAuthCode:(NSString *)phoneNumber RetsetPassword:(BOOL)reset Result:(void (^)(NSString *code))returnResult {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"mobile"]       = phoneNumber;
    muDict[@"isResetPass"]  = @"";
    
    [NetWorking postSessionWithUrl:Login_GetAuthCode parameters:muDict success:^(id responseObject) {
        if (returnResult) {
            NSString *authCode = [responseObject objectForKey:@"verifiCode"];
            returnResult(authCode);
        }
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送"];
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)registerWithPhone:(NSString *)phoneNum Password:(NSString *)password NickName:(NSString *)nickName Sex:(NSString *)sex City:(NSString *)city success:(void (^)(id result))success failed:(void (^)())fail {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"mobile"]     = phoneNum;
    muDict[@"passwd"]     = password;
    muDict[@"nickName"]   = nickName;
    muDict[@"sex"]        = sex;
    muDict[@"city"]       = city;
    
    [NetWorking postSessionWithUrl:Login_Register parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)resetPasswordWithPhone:(NSString *)phoneNumber Password:(NSString *)newPassword Result:(void (^)())returnResult {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"mobile"]       = phoneNumber;
    muDict[@"passwd"]       = newPassword;
    
    [NetWorking postSessionWithUrl:Login_ResetPwd parameters:muDict success:^(id responseObject) {
        if (returnResult) {
            returnResult();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)loginWithPhone:(NSString *)phoneNumber Password:(NSString *)password Success:(void (^)(id result))success {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"mobile"]     = phoneNumber;
    muDict[@"passwd"]     = password;
    muDict[@"loginFrom"]  = @"ios";
    
    [NetWorking postSessionWithUrl:Login_UserLogin parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

// 废弃 - 用直接上传七牛云的接口
+ (void)uploadImagesToServer:(NSDictionary *)imagesDict success:(void (^)(id result))success {
    [NetWorking postSessionWithUrl:Publish_UploadImages parameters:nil images:imagesDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"picurl"]);
        }
    } fail:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:^(NSProgress *uploadProgress) {
        
    }];
}

//获取七牛的token
+ (void)getQiniuUploadToken:(void(^)(NSString *token, NSString *baseUrl))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    
    [NetWorking postSessionWithUrl:Publish_GetQiniuToken parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"token"], responseObject[@"urlprefix"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

//上传单张图片到七牛
+ (void)uploadImage:(NSData *)imageData progress:(QNUpProgressHandler)progress success:(void(^)(NSString *url))success failure:(void(^)())failure {
    [NetworkTool getQiniuUploadToken:^(NSString *token, NSString *baseUrl) {
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [NSString randomStringWithLength:16]];
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:progress
                                                            params:nil
                                                          checkCrc:NO
                                                cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [uploadManager putData:imageData
                           key:fileName
                         token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          if (info.statusCode == 200 && resp) {
                              NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, resp[@"key"]];
                              if(success) {
                                  success(url);
                              }
                          } else {
                              if(failure) {
                                  failure();
                              }
                          }
                      } option:opt];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"获取七牛token失败"];
    }];
}

//上传多张图片到七牛
+ (void)uploadImages:(NSArray *)imageDataArray progress:(void(^)(CGFloat percent))progress success:(void(^)(NSArray *urlArray))success failure:(void(^)())failure {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSUInteger imageDataArrayCount = [imageDataArray count];
    
    if (imageDataArrayCount == 0) {
        return;
    }
    
    __block CGFloat totalProgress = 0.0f;
    
    __block CGFloat partProgress = 1.0f / imageDataArrayCount;
    
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    weakHelper.singleFailureBlock = ^{
        failure();
        return;
    };
    
    weakHelper.singleSuccessBlock = ^(NSString *url) {
        [array addObject:url];
        
        totalProgress += partProgress;
        
        if (progress) {
            progress(totalProgress);
        }
        
        currentIndex++;
        
        if (currentIndex == imageDataArrayCount) {
            success([array copy]);
            return;
        } else if (currentIndex < imageDataArrayCount) {
            [NetworkTool uploadImage:imageDataArray[currentIndex]
                            progress:nil
                             success:weakHelper.singleSuccessBlock
                             failure:weakHelper.singleFailureBlock];
        }
    };
    
    [NetworkTool uploadImage:imageDataArray[currentIndex]
                    progress:nil
                     success:weakHelper.singleSuccessBlock
                     failure:weakHelper.singleFailureBlock];
}

+ (void)uploadVideoPHAssetToQiniu:(PHAsset *)asset progress:(QNUpProgressHandler)progress success:(void(^)(NSString *videoUrl))success failure:(void(^)())failure {
    [NetworkTool getQiniuUploadToken:^(NSString *token, NSString *baseUrl) {
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:progress
                                                            params:nil
                                                          checkCrc:NO
                                                cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        [uploadManager putPHAsset:asset
                              key:nil
                            token:token
                         complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                             if (info.statusCode == 200 && resp) {
                                 NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, resp[@"key"]];
                                 if(success) {
                                     success(url);
                                 }
                             } else {
                                 if(failure) {
                                     failure();
                                 }
                             }
                         } option:opt];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"获取七牛token失败"];
    }];
}

// 调七牛的鉴黄
+ (void)pornImageOrVideoWithURL:(NSString *)url success:(void(^)(id responseObject))success failure:(void(^)())failure {
    [NetWorking getSessionWithUrl:url parameters:nil success:^(id responseObject) {
        if (success) {
            success([responseObject[@"fileList"] firstObject]);
        }
    } fail:^(NSError *error, NSString *msg) {
        //NSLog(@"%@",error.localizedDescription);
    } progress:nil];
}

+ (void)pornImageOrVideoWithURLs:(NSArray *)urlArray success:(void(^)(id responseObject))success failure:(void(^)())failure {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSUInteger urlArrayCount = [urlArray count];
    
    if (urlArrayCount == 0) {
        return;
    }
    
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    weakHelper.pornFailureBlock = ^{
        failure();
        return;
    };
    
    weakHelper.pornSuccessBlock = ^(NSDictionary *result) {
        [array addObject:result];
        currentIndex++;
        if (currentIndex == urlArrayCount) {
            success([array copy]);
            return;
        } else if (currentIndex < urlArrayCount) {
            [NetworkTool pornImageOrVideoWithURL:urlArray[currentIndex]
                                         success:weakHelper.pornSuccessBlock
                                         failure:weakHelper.pornFailureBlock];
        }
    };
    
    [NetworkTool pornImageOrVideoWithURL:urlArray[currentIndex]
                                 success:weakHelper.pornSuccessBlock
                                 failure:weakHelper.pornFailureBlock];
}

+ (void)publishProduct:(NSString *)goodsName price:(NSNumber *)goodsPrice cover:(NSString *)coverUrl image:(NSString *)imagesUrl intro:(NSString *)goodsIntro success:(void(^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"userId"]      = [LoginData sharedLoginData].userId;
    muDict[@"price"]       = goodsPrice;
    muDict[@"imageUrl"]    = coverUrl;
    muDict[@"goodsName"]   = goodsName;
    muDict[@"goodsLink"]   = imagesUrl;
    muDict[@"goodsInstro"] = goodsIntro ? goodsIntro : @"";
    muDict[@"isReal"]      = @"0";
    
    [NetWorking postSessionWithUrl:Publish_PublishProduct parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)publishRedEnvelope:(NSNumber *)goodsPrice image:(NSString *)imagesUrl intro:(NSString *)goodsTitle success:(void(^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]  = [NSString randomString];
    muDict[@"sign"]        = @"";
    muDict[@"userId"]      = [LoginData sharedLoginData].userId;
    muDict[@"price"]       = goodsPrice;
    muDict[@"goodsLink"]   = imagesUrl;
    muDict[@"goodsInstro"] = goodsTitle;
    
    [NetWorking postSessionWithUrl:Publish_PublishRedpacket parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)publishTrends:(NSString *)imagesUrl intro:(NSString *)goodsIntro video:(NSString *)videoUrl cover:(NSString *)videoCoverUrl trendsType:(NSString *)feedsType duration:(NSString *)duration success:(void(^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"]   = [NSString randomString];
    muDict[@"sign"]         = @"";
    muDict[@"userId"]       = [LoginData sharedLoginData].userId;
    muDict[@"instro"]       = goodsIntro;
    muDict[@"imageUrl"]     = imagesUrl;
    muDict[@"videoUrl"]     = videoUrl;
    muDict[@"videoEvelope"] = videoCoverUrl;
    muDict[@"feedsType"]    = feedsType;
    muDict[@"duration"]     = duration;
    
    [NetWorking postSessionWithUrl:Publish_PublishTrends parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)sellWeixin:(NSNumber *)price weixinID:(NSString *)wxId success:(void(^)())success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"userId"]     = [LoginData sharedLoginData].userId;
    muDict[@"price"]      = price;
    muDict[@"wxId"]       = wxId;
    
    [NetWorking postSessionWithUrl:Publish_SellWeiXin parameters:muDict success:^(id responseObject) {
        if (success) {
            success();
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getHotSearchWords:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void(^)(NSArray *hotWords))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Home_HotSearchWords parameters:muDict success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        NSMutableArray *muArray = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            [muArray addObject:dict[@"name"]];
        }
        
        if (success) {
            success(muArray);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)searchWithContent:(NSString *)content pageNO:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void(^)(NSArray *searchResult))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    muDict[@"fromUserId"] = [LoginData sharedLoginData].userId ? [LoginData sharedLoginData].userId : @"";
    muDict[@"nickName"]   = content;
    
    [NetWorking postSessionWithUrl:Home_SearchUsers parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getBannerListWithPageNo:(NSString *)pageNo pageSize:(NSString *)pageSize success:(void(^)(NSArray *dataArray))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Home_GetBanners parameters:muDict success:^(id responseObject) {
        if (success) {
            success(responseObject[@"list"]);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

+ (void)getHomeListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void(^)(NSArray *dataArray))success failure:(void(^)())failure {
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    muDict[@"requestseq"] = [NSString randomString];
    muDict[@"sign"]       = @"";
    muDict[@"pageNo"]     = pageNo;
    muDict[@"pagesize"]   = pageSize;
    
    [NetWorking postSessionWithUrl:Home_GetResoures parameters:muDict success:^(id responseObject) {
        NSArray *dataArray = responseObject[@"list"];
        if (success) {
            success(dataArray);
        }
    } fail:^(NSError *error, NSString *msg) {
        if (failure) {
            failure();
        } else if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
    } progress:nil];
}

@end