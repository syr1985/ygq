//
//  ConcemViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/10.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FocusTrendsViewCell.h"
#import "HomeFocusModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MoreMenuHelp.h"
#import "NSDate+LXExtension.h"
#import "PhotoBrowserHelp.h"
#import "UIImage+Color.h"

@interface FocusTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;

@property (weak, nonatomic) IBOutlet UIImageView *tyrantImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTitleLabel;
@property (weak, nonatomic) IBOutlet UIView  *imageBackgroundView;

@property (weak, nonatomic) IBOutlet UIButton *favourButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageViewLeadingConstraint;

@end

NSString * const kCommentSuccessNotification = @"HomeFocusCommentSuccess";
NSString * const kFavourSuccessNotification = @"kNotification_FavourSuccess";

@implementation FocusTrendsViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = 20;
    _headerImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapHeaderImageView)];
    [_headerImageView addGestureRecognizer:tapHeader];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForComment:)
                                                 name:kCommentSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForFavour:)
                                                 name:kFavourSuccessNotification
                                               object:nil];
}

- (void)setHomeFocusModel:(HomeFocusModel *)homeFocusModel {
    _homeFocusModel = homeFocusModel;
    
    NSString *headImageUrlStr = [NSString compressImageUrlWithUrlString:homeFocusModel.headImg
                                                                  width:_headerImageView.bounds.size.width
                                                                 height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _nickNameLabel.text = homeFocusModel.nickName;
    _crownImageView.hidden = (homeFocusModel.star != 6);
    _auditImageView.hidden = !(homeFocusModel.audit == 1 || homeFocusModel.audit == 3);
    _auditImageView.image = homeFocusModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _tyrantImageView.image = homeFocusModel.star == 5 ? [UIImage imageNamed:@"壕"] : nil;
    _tyrantImageViewWidthConstraint.constant = homeFocusModel.star == 5 ? 39 : 0;
    _sexImageViewLeadingConstraint.constant = homeFocusModel.star == 5 ? 4 : 0;
    
    _sexImageView.image = [UIImage imageNamed:homeFocusModel.sex];
    
    _vipImageView.image = homeFocusModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    _vipImageViewWidthContraint.constant = homeFocusModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = homeFocusModel.isRecommend ? 4 : 0;
    
    _levelImageView.hidden = homeFocusModel.star == 0;
    if (homeFocusModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",homeFocusModel.star]];
    }
    
    NSTimeInterval timeInterval = [homeFocusModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    _publishTimeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    _publishTitleLabel.text = homeFocusModel.instro;
    
    _favourButton.selected = homeFocusModel.praise;
    [_favourButton setTitle:[homeFocusModel.recommendCount stringValue] forState:UIControlStateNormal];
    [_commentButton setTitle:[homeFocusModel.commentCount stringValue] forState:UIControlStateNormal];
    
    if (_imageBackgroundView.subviews.count) {
        for (UIView *view in _imageBackgroundView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    NSUInteger margin = 6;
    CGFloat defaultW = (WIDTH - 24 - 2 * margin) / 3;
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:CGSizeMake(defaultW, defaultW)];
    if (homeFocusModel.imageUrl && homeFocusModel.imageUrl.length) {
        if ([homeFocusModel.imageUrl containsString:@";"]) {
            NSArray *urlArray = [homeFocusModel.imageUrl componentsSeparatedByString:@";"];
            NSUInteger count = urlArray.count;
            NSUInteger col = count == 4 ? 2 : (count > 2 ? 3 : count);
            NSUInteger row = count % 3 == 0 ? (count / 3) : (count / 3 + 1);
    
            for (NSUInteger i = 0; i < row; i++) {
                CGFloat viewY = (defaultW + margin) * i;
                for (NSUInteger j = 0; j < col; j++) {
                    CGFloat viewX = (defaultW + margin) * j;
                    NSUInteger index = i * col + j;
                    if (index < count) {
                        [self createImageViewWithFrame:CGRectMake(viewX, viewY, defaultW, defaultW)
                                              imageUrl:urlArray[index]
                                      placeholderImage:phImage
                                               viewTag:index];
                    }
                }
            }
        } else {
            [self createImageViewWithFrame:CGRectMake(0, 0, 178, 178)
                                  imageUrl:homeFocusModel.imageUrl
                          placeholderImage:phImage
                                   viewTag:0];
        }
    }
}

- (void)createImageViewWithFrame:(CGRect)rect imageUrl:(NSString *)url placeholderImage:(UIImage *)phImage viewTag:(NSInteger)tag {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.tag = tag;
    imageView.frame = rect;
    NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:url
                                                          width:rect.size.width
                                                         height:rect.size.height];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                 placeholderImage:phImage];
    [_imageBackgroundView addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(popupPhotoBrowser:)];
    [imageView addGestureRecognizer:tap];
}

/**
 *  更多菜单
 */
- (IBAction)moreButtonClicked {
    __weak typeof(self) weakself = self;
    if ([_homeFocusModel.userId isEqualToString:[LoginData sharedLoginData].userId]) {
        [MoreMenuHelp showMoreMenuForMineTrendsWithResult:^(NSUInteger index) {
            if (weakself.handleTrendsBlock) {
                weakself.handleTrendsBlock(index, weakself.homeFocusModel.focusId, weakself.row);
            }
        }];
    } else {
        [MoreMenuHelp showMoreMenuForTrends:^(NSUInteger index) {
            if (weakself.actionSheetItemClicked) {
                weakself.actionSheetItemClicked(index, weakself.homeFocusModel.userId, weakself.homeFocusModel.focusId);
            }
        }];
    }
}

/**
 *  点击赞按钮
 */
- (IBAction)favourToOther:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    if (sender.isSelected) {
        // 取消赞
        [NetworkTool cancelFavourWithFeedsID:_homeFocusModel.focusId userID:_homeFocusModel.userId success:^{
            sender.selected = NO;
            NSInteger priseCount = [weakself.homeFocusModel.recommendCount integerValue];
            NSNumber *newPriseCount = @(priseCount - 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_homeFocusModel.focusId,
                                                                         @"praise":@(NO)}];
            
            if (weakself.favourResultBlock) {
                weakself.favourResultBlock(YES);
            }
        }];
    } else {
        // 点赞
        [NetworkTool doFavourWithFeedsID:_homeFocusModel.focusId userId:_homeFocusModel.userId success:^{
            sender.selected = YES;
            NSInteger priseCount = [weakself.homeFocusModel.recommendCount integerValue];
            NSNumber *newPriseCount = @(priseCount + 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_homeFocusModel.focusId,
                                                                         @"praise":@(YES)}];
            
            if (weakself.favourResultBlock) {
                weakself.favourResultBlock(NO);
            }
        }];
    }
}

/**
 *  评论
 */
- (IBAction)messageToOther:(UIButton *)sender {
    if (_commentBlock) {
        _commentBlock(_homeFocusModel);
    }
}

/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    UIImageView *tapView = (UIImageView *)sender.view;
    if (_homeFocusModel.imageUrl && _homeFocusModel.imageUrl.length) {
        NSArray *urlArray;
        if ([_homeFocusModel.imageUrl containsString:@";"]) {
            urlArray = [_homeFocusModel.imageUrl componentsSeparatedByString:@";"];
        } else {
            urlArray = @[_homeFocusModel.imageUrl];
        }
        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray sourceImageView:tapView];
    }
}

/**
 *  点击头像进TA人主页
 */
- (void)tapHeaderImageView {
    if (_tapHeaderView) {
        _tapHeaderView(_homeFocusModel.userId);
    }
}

#pragma mark -
#pragma mark - 评论后更新模型数据
- (void)updateModelDataForComment:(NSNotification *)noti {
    NSNumber *content = noti.userInfo[@"NewCommentTimes"];
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_homeFocusModel.focusId isEqualToString:focusId]) {
        _homeFocusModel.commentCount = content;
        [_commentButton setTitle:[content stringValue] forState:UIControlStateNormal];
    }
}

- (void)updateModelDataForFavour:(NSNotification *)noti {
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_homeFocusModel.focusId isEqualToString:focusId]) {
        NSNumber *content = noti.userInfo[@"NewFavourCount"];
        NSNumber *praise  = noti.userInfo[@"praise"];
        _homeFocusModel.recommendCount = content;
        [_favourButton setTitle:[content stringValue] forState:UIControlStateNormal];
        _homeFocusModel.praise = [praise boolValue];
        _favourButton.selected = [praise boolValue];
    }
}

@end
