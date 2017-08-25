//
//  PayTool.m
//  RoomService
//
//  Created by YM on 16/4/27.
//  Copyright © 2016年 SYR. All rights reserved.
//

#import "FuqianlaPayTool.h"
#import "FuqianlaPay.h"

/**
 kCEPayResultSuccess 支付成功
 kCEPayResultFail 支付失败
 kCEPayResultProcessing 支付进行中
 kCEPayResultCancel 支付取消
 kCEPayResultParamError 参量错误
 kCEPayResultUnknow 其他错误
 
 微信支付    kPTWeixinPay
 支付宝支付  kPTAlipay
 */
#define FUQIANLA_APP_ID  @"2y7httSuYAc6UdmYqeewjQ"

@implementation FuqianlaPayTool

+ (void)payWithType:(NSString *)payType dataParam:(NSDictionary *)dataInfo success:(void (^)())success {
    CEPayType payMethod = [payType isEqualToString:@"zfb"] ? kPTAlipay : kPTWeixinPay;
    // 付钱啦入口
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    // 参量设置
    manager.transactionParams = @{@"app_id"     : FUQIANLA_APP_ID,
                                  @"order_no"   : dataInfo[@"payOrderNo"],
                                  @"pmtTp"      : @(payMethod),
                                  @"amount"     : @(0.01),//dataInfo[@"amount"],
                                  @"subject"    : dataInfo[@"orderNo"],
                                  @"body"       : dataInfo[@"desc"],
                                  @"notify_url" : FUQIANLA_APP_URL};
    // 支付结果
    manager.payStatusCallBack = ^(CEPaymentStatus payStatus, NSString *result){
        if (payStatus == kCEPayResultSuccess) {
            [NetworkTool checkOrderStatusOrderNo:dataInfo[@"orderNo"] payment:payType success:^{
                if (success) {
                    success();
                }
            } failure:^(NSError *error) {
                if (error) {
                    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                }
            }];
        }
    };
    // 开始支付
    [manager startPayAction];
}

//    NSString *orderNo = dataInfo[@"orderNo"];
//    NSString *payTarget = nil;
//    if ([orderNo hasPrefix:@"RE"]) {
//        payTarget  = @"tranmoney";
//    } else if ([orderNo hasPrefix:@"NB"]) {
//        payTarget  = @"buynobel";
//    } else if ([orderNo hasPrefix:@"CF"] || [orderNo hasPrefix:@"RP"]) {
//        payTarget  = @"immpay";
//    } else if ([orderNo hasPrefix:@"NM"] || [orderNo hasPrefix:@"WX"] || [orderNo hasPrefix:@"DT"]) {
//        payTarget  = @"midpay";
//    } else {
//        payTarget  = @"fillwallet";
//    }
//    NSString *optional = [NSString stringWithFormat:@"busi:%@;payMethod:%@",payTarget,payType];

//+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//}

@end