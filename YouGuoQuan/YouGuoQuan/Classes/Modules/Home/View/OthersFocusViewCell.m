//
//  OthersConcemViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/2.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "OthersFocusViewCell.h"
#import "OthersFocusModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AlertViewTool.h"

@interface OthersFocusViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tyrantImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *concemButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *certificationLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;

@end

@implementation OthersFocusViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = self.headerImageView.bounds.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    
    _headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapHeaderImageView)];
    [_headerImageView addGestureRecognizer:tap];
}

- (void)tapHeaderImageView {
    if (_tapHeaderImageViewBlock) {
        _tapHeaderImageViewBlock(_othersFocusModel.userId);
    }
}

- (void)setOthersFocusModel:(OthersFocusModel *)othersFocusModel {
    _othersFocusModel = othersFocusModel;
    
    _nickNameLabel.text = othersFocusModel.nickName;
    _crownImageView.hidden = (othersFocusModel.star != 6);
    _auditImageView.hidden = !(othersFocusModel.audit == 1 || othersFocusModel.audit == 3);
    _auditImageView.image = othersFocusModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:othersFocusModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _tyrantImageView.image = othersFocusModel.star == 5 ? [UIImage imageNamed:@"壕"] : nil;
    _tyrantImageViewWidthConstraint.constant = othersFocusModel.star == 5 ? 39 : 0;
    _tyrantImageViewLeadingConstraint.constant = othersFocusModel.star == 5 ? 4 : 0;
    
    _sexImageView.image = [UIImage imageNamed:othersFocusModel.sex];
    
    _vipImageView.image = othersFocusModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    _vipImageViewWidthConstraint.constant = othersFocusModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = othersFocusModel.isRecommend ? 4 : 0;

    _levelImageView.hidden = othersFocusModel.star == 0;
    if (othersFocusModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",othersFocusModel.star]];
    }
    
    if (othersFocusModel.auditResult && othersFocusModel.auditResult.length) {
        _certificationLabelHeightConstraint.constant =  14.5;
        _certificationLabel.text = [NSString stringWithFormat:@"尤果认证：%@",othersFocusModel.auditResult];
    } else {
        _certificationLabelHeightConstraint.constant = 0;
    }
    
    _concemButton.selected = othersFocusModel.isMyFans;
}

- (void)setFocusButtonHidden:(BOOL)isMyFocus {
    _isMyFocus = isMyFocus;
    
    _concemButton.hidden = isMyFocus;
}

- (IBAction)focusButtonClicked:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    if (sender.isSelected) {
        [AlertViewTool showAlertViewWithTitle:nil Message:@"是否取消关注？" cancelTitle:@"取消" sureTitle:@"确定" sureBlock:^{
            // 取消关注
            [NetworkTool doOperationWithType:@"1" userId:weakself.othersFocusModel.userId operationType:@"0" success:^{
                [SVProgressHUD showSuccessWithStatus:@"已取消关注Ta"];
                sender.selected = NO;
                weakself.othersFocusModel.isMyFans = NO;
            }];
        } cancelBlock:nil];
    } else {
        // 关注
        [NetworkTool doOperationWithType:@"1" userId:weakself.othersFocusModel.userId operationType:@"1" success:^{
            [SVProgressHUD showSuccessWithStatus:@"已关注Ta"];
            sender.selected = YES;
            weakself.othersFocusModel.isMyFans = YES;
        }];
    }
}


@end