//
//  WaitingForPayMeetingViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/9.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "RefundingForPayMeetingViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"

@interface RefundingForPayMeetingViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetingAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation RefundingForPayMeetingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    
    self.bottomView.layer.shadowColor = RGBA(0, 0, 0, 1).CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 1);
    self.bottomView.layer.shadowOpacity = 0.1;
    
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
    
    _contentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"购买订单-约见-%@", orderModel.goodsName]];
    _contentTitleLabel.text = [NSString stringWithFormat:@"约见-%@", orderModel.goodsName];
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币", orderModel.price];
    
    _meetingDateLabel.text = [NSString stringWithFormat:@"日期：%@", orderModel.dateTimeInfo];
    _meetingAddressLabel.text = [NSString stringWithFormat:@"地址：%@", orderModel.dateAddress];
    
    
    double createTime = [orderModel.createTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}

// 恢复订单的操作去掉了
- (IBAction)resumeOrderButtonClicked:(id)sender {
    
}

- (IBAction)deleteOrderButtonClicked:(id)sender {
    if (_deleteOrderBlock) {
        _deleteOrderBlock(_orderModel.orderNo);
    }
}

@end
