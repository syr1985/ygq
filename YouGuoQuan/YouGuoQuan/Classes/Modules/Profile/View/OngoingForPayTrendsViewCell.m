//
//  WaitingForPayTrendsViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "OngoingForPayTrendsViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"
#import "AlertViewTool.h"

@interface OngoingForPayTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *surePayButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyRefundButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation OngoingForPayTrendsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES; // 导致离屏渲染
    
    _bottomView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    _bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    _bottomView.layer.shadowOpacity = 0.1;
    
    self.contentView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowOpacity = 0.1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.headerView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    UIView *tapView = tap.view;
    CGPoint tapPoint = [tap locationInView:tapView];
    CGFloat maxX = CGRectGetMaxX(self.arrowImageView.frame);
    if (tapPoint.x < maxX) {
        if (self.tapViewBolck) {
            self.tapViewBolck(_orderModel.saleUserId);
        }
    }
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _titleLabel.text = orderModel.saleNickName;
    
    // RP(红包照片)NM(普通商品)WX(购买微信)CF(众筹)RB(红包)RE(打赏)
    NSString *orderNo = orderModel.orderNo;
    if ([orderNo hasPrefix:@"WX"]) {
        _contentImageView.image = [UIImage imageNamed:@"购买订单-购买微信"];
        _contentTitleLabel.text = @"微信";
    } else {
        UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                         size:_contentImageView.frame.size];
        NSString *contentImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.imageUrl
                                                                         width:_contentImageView.bounds.size.width
                                                                        height:_contentImageView.bounds.size.height];
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImageUrlStr]
                             placeholderImage:phImage];
        _contentTitleLabel.text = orderModel.goodsName;
    }
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
    
    self.surePayButtonWidthConstraint.constant = orderModel.orderType != 4 ? 0 : 84;
    self.applyRefundButtonWidthConstraint.constant = orderModel.orderType != 4 ? 0 : 84;
    
    double createTime = [orderModel.createTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}

- (IBAction)sureToPayment {
    if (_surePayBlock) {
        _surePayBlock(_orderModel.orderNo);
    }
}

- (IBAction)applyForRefund {
    [AlertViewTool showAlertViewWithTitle:nil Message:@"确定申请退款吗？" cancelTitle:@"取消" sureTitle:@"确认" sureBlock:^{
        if (_applyForRefundBlock) {
            _applyForRefundBlock(_orderModel.orderNo);
        }
    } cancelBlock:nil];
}

@end
