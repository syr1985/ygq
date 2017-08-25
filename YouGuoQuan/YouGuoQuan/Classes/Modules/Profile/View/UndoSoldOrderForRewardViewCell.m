//
//  UndoSoldOrderForRewardViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/3/7.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UndoSoldOrderForRewardViewCell.h"
#import <UIImageView+WebCache.h>
#import "MyOrderModel.h"
#import "UIImage+Color.h"

@interface UndoSoldOrderForRewardViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@end

@implementation UndoSoldOrderForRewardViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
            self.tapViewBolck(_orderModel.buyUserId);
        }
    }
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    _orderModel = orderModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:orderModel.buyUserHeadImg
                                                                  width:self.headerImageView.bounds.size.width
                                                                 height:self.headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    _titleLabel.text = orderModel.buyUserNickName;
    
    if ([orderModel.orderNo hasPrefix:@"RE"]) {
        //_titleLabel.text = [NSString stringWithFormat:@"%@", orderModel.buyUserNickName];
        _contentImageView.image = [UIImage imageNamed:@"我的订单-打赏"];
        _contentTitleLabel.text = @"打赏";
    } else if ([orderModel.orderNo hasPrefix:@"RP"]) {
        //_titleLabel.text = [NSString stringWithFormat:@"%@", orderModel.buyUserNickName];
        _contentImageView.image = [UIImage imageNamed:@"红包照片-发布状态"];
        _contentTitleLabel.text = @"红包照片";
    }
    
    _contentPriceLabel.text = [NSString stringWithFormat:@"%@ u币",orderModel.price];
    
    double createTime = [orderModel.createTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
}


@end
