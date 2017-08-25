//
//  RechargeRecordViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/4/20.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RechargeRecordViewCell.h"
#import "MyConsumeModel.h"

@interface RechargeRecordViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *recordContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftNameLabelHeightConstraint;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation RechargeRecordViewCell

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMyConsumeModel:(MyConsumeModel *)myConsumeModel {
    _myConsumeModel = myConsumeModel;
    
    self.giftNameLabelHeightConstraint.constant = 14;
    
    NSString *orderNo = myConsumeModel.orderNo;
    NSString *content = @"";
    NSString *sign = @"-";
    if (_income) {
        sign = @"+";
        if ([orderNo hasPrefix:@"NM"]) {
            content = [NSString stringWithFormat:@"商品销售-%@",myConsumeModel.buyerNickName];
            self.giftNameLabel.text = myConsumeModel.goodsName;
        } else if ([orderNo hasPrefix:@"RP"]) {
            content = [NSString stringWithFormat:@"红包照片-%@",myConsumeModel.buyerNickName];
            self.giftNameLabel.text = [NSString stringWithFormat:@"收到礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"RE"]) {
            content = [NSString stringWithFormat:@"打赏-%@",myConsumeModel.buyerNickName];
            self.giftNameLabel.text = [NSString stringWithFormat:@"收到礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"DT"]) {
            content = [NSString stringWithFormat:@"约见-%@",myConsumeModel.buyerNickName];
            self.giftNameLabel.text = myConsumeModel.goodsName;
        } else if ([orderNo hasPrefix:@"WX"]) {
            content = [NSString stringWithFormat:@"微信私聊-%@",myConsumeModel.buyerNickName];
            self.giftNameLabel.text = [NSString stringWithFormat:@"收到礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"WD"]) {
            content = @"提现";
            sign = @"-";
            self.giftNameLabelHeightConstraint.constant = 0;
        } else if ([orderNo hasPrefix:@"PR"]) {
            content = @"推广收入";
            self.giftNameLabel.text = @"推广分成";
        }
    } else {
        if ([orderNo hasPrefix:@"NM"]) {
            if ([myConsumeModel.sellerId isEqualToString:@"midSellerSystemBack"]) {
                content = [NSString stringWithFormat:@"商品退款-%@",myConsumeModel.sellerNickName];
                sign = @"+";
            } else {
                content = [NSString stringWithFormat:@"商品购买-%@",myConsumeModel.sellerNickName];
            }
            self.giftNameLabel.text = myConsumeModel.goodsName;
        } else if ([orderNo hasPrefix:@"RP"]) {
            content = [NSString stringWithFormat:@"红包照片-%@",myConsumeModel.sellerNickName];
            self.giftNameLabel.text = [NSString stringWithFormat:@"购买礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"RE"]) {
            content = [NSString stringWithFormat:@"打赏-%@",myConsumeModel.sellerNickName];
            self.giftNameLabel.text = [NSString stringWithFormat:@"购买礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"DT"]) {//暂去掉
            content = [NSString stringWithFormat:@"约见-%@",myConsumeModel.sellerNickName];
            self.giftNameLabel.text = myConsumeModel.goodsName;
        } else if ([orderNo hasPrefix:@"WX"]) {
            if ([myConsumeModel.sellerId isEqualToString:@"midSellerSystemBack"]) {
                content = [NSString stringWithFormat:@"微信私聊退款-%@",myConsumeModel.sellerNickName];
                sign = @"+";
            } else {
                content = [NSString stringWithFormat:@"微信私聊-%@",myConsumeModel.sellerNickName];
            }
            self.giftNameLabel.text = [NSString stringWithFormat:@"购买礼物 %@",[self getGiftName]];
        } else if ([orderNo hasPrefix:@"CF"]) {//暂去掉
            content = [NSString stringWithFormat:@"众筹 %@",myConsumeModel.goodsName];
        } else if ([orderNo hasPrefix:@"FW"]) {
            content = @"充值";
            sign = @"+";
            self.giftNameLabelHeightConstraint.constant = 0;
        } else {
            content = @"会员";
            self.giftNameLabel.text = @"购买尤果会员";
        }
    }
    self.recordContentLabel.text = content;
    self.recordPriceLabel.text = [NSString stringWithFormat:@"%@%@ u币",sign,myConsumeModel.goodsPrice];
    self.recordPriceLabel.textColor = [sign hasPrefix:@"+"] ? GreenColor : FontColor;
    
    NSTimeInterval timeInterval = [myConsumeModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    self.recordDateLabel.text = [self.dateFormatter stringFromDate:createDate];
}

- (NSString *)getGiftName {
    NSInteger price = [_myConsumeModel.goodsPrice integerValue];
    NSString *giftName = @"";
    NSString *orderNo = _myConsumeModel.orderNo;
    if ([orderNo hasPrefix:@"RP"]) {
        switch (price) {
            case 10:
                giftName = @"爱心";
                break;
            case 30:
                giftName = @"棒棒糖";
                break;
            case 60:
                giftName = @"玫瑰花";
                break;
            case 80:
                giftName = @"冰淇淋";
                break;
        }
    } else if ([orderNo hasPrefix:@"RE"]) {
        switch (price) {
            case 80:
                giftName = @"冰淇淋";
                break;
            case 299:
                giftName = @"巧克力";
                break;
            case 666:
                giftName = @"蛋糕";
                break;
            case 1314:
                giftName = @"香水";
                break;
            case 2999:
                giftName = @"水晶鞋";
                break;
            case 5200:
                giftName = @"耳坠";
                break;
            case 9999:
                giftName = @"钻戒";
                break;
            case 19999:
                giftName = @"跑车";
                break;
            case 29999:
                giftName = @"游艇";
                break;
        }
    } else if ([orderNo hasPrefix:@"WX"]) {
        switch (price) {
            case 999:
                giftName = @"口红";
                break;
            case 1314:
                giftName = @"香水";
                break;
            case 5200:
                giftName = @"耳坠";
                break;
            case 6666:
                giftName = @"项链";
                break;
            case 8888:
                giftName = @"手镯";
                break;
            case 9999:
                giftName = @"钻戒";
                break;
            case 19999:
                giftName = @"跑车";
                break;
            case 29999:
                giftName = @"游艇";
                break;
            case 59999:
                giftName = @"别墅";
                break;
        }
    }
    return giftName;
}

@end
