//
//  UserCenterTrendsViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "UserCenterTrendsViewCell.h"
#import "UserCenterModel.h"
#import "PhotoBrowserHelp.h"
#import "MoreMenuHelp.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Color.h"

@interface UserCenterTrendsViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *favourButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@end

NSString * const kUserCenterCommentSuccessNotification = @"UserCenterCommentSuccess";

@implementation UserCenterTrendsViewCell

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForComment:)
                                                 name:kUserCenterCommentSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForFavour:)
                                                 name:kFavourSuccessNotification
                                               object:nil];
}

- (void)setUserCenterModel:(UserCenterModel *)userCenterModel {
    _userCenterModel = userCenterModel;
    
    _titleLabel.text = userCenterModel.instro;
    //_moreButton.hidden = ![userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId];
    _favourButton.selected = userCenterModel.praise;
    [_favourButton setTitle:[userCenterModel.recommendCount stringValue] forState:UIControlStateNormal];
    [_commentButton setTitle:[userCenterModel.commentCount stringValue] forState:UIControlStateNormal];
    
    if (_imageBackgroundView.subviews.count) {
        for (UIView *view in _imageBackgroundView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    NSUInteger margin = 6;
    CGFloat defaultW = (WIDTH - 24 - 2 * margin) / 3;
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:CGSizeMake(defaultW, defaultW)];
    if (userCenterModel.imageUrl && userCenterModel.imageUrl.length) {
        if ([userCenterModel.imageUrl containsString:@";"]) {
            NSArray *urlArray = [userCenterModel.imageUrl componentsSeparatedByString:@";"];
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
                                  imageUrl:userCenterModel.imageUrl
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
 *  点击赞按钮
 */
- (IBAction)favourToOther:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    if (sender.isSelected) {
        // 取消赞
        [NetworkTool cancelFavourWithFeedsID:_userCenterModel.trendsId userID:_userCenterModel.userId success:^{
            sender.selected = NO;
            NSInteger priseCount = [weakself.userCenterModel.recommendCount integerValue];
            //NSString *newPriseCount = [NSString stringWithFormat:@"%zd",priseCount - 1];
            NSNumber *newPriseCount = @(priseCount - 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_userCenterModel.trendsId,
                                                                         @"praise":@(NO)}];
        }];
    } else {
        // 点赞
        [NetworkTool doFavourWithFeedsID:_userCenterModel.trendsId userId:_userCenterModel.userId success:^{
            sender.selected = YES;
            NSInteger priseCount = [weakself.userCenterModel.recommendCount integerValue];
            //NSString *newPriseCount = [NSString stringWithFormat:@"%zd",priseCount + 1];
            NSNumber *newPriseCount = @(priseCount + 1);
            [[NSNotificationCenter defaultCenter] postNotificationName:kFavourSuccessNotification
                                                                object:nil
                                                              userInfo:@{@"NewFavourCount":newPriseCount,
                                                                         @"CurrentFocusID":_userCenterModel.trendsId,
                                                                         @"praise":@(YES)}];
        }];
    }
}

/**
 *  评论
 */
- (IBAction)messageToOther:(UIButton *)sender {
    if (_commentBlock) {
        _commentBlock(_userCenterModel);
    }
}

/**
 *  更多按钮点击
 */
- (IBAction)moreButtonClicked:(id)sender {
    __weak typeof(self) weakself = self;
    if ([_userCenterModel.userId isEqualToString:[LoginData sharedLoginData].userId]) {
        [MoreMenuHelp showMoreMenuForMineTrendsWithResult:^(NSUInteger buttonIndex) {
            if (weakself.actionSheetItemClicked) {
                weakself.actionSheetItemClicked(buttonIndex, weakself.userCenterModel.trendsId, weakself.userCenterModel.feedsType, weakself.indexPath);
            }
        }];
    } else {
        [MoreMenuHelp showMoreMenuForTrends:^(NSUInteger index) {
            if (weakself.actionSheetItemClicked) {
                weakself.actionSheetItemClicked(index, weakself.userCenterModel.trendsId, weakself.userCenterModel.feedsType, weakself.indexPath);
            }
        }];
    }
}


/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    UIImageView *tapView = (UIImageView *)sender.view;
    if (_userCenterModel.imageUrl && _userCenterModel.imageUrl.length) {
        NSArray *urlArray;
        if ([_userCenterModel.imageUrl containsString:@";"]) {
            urlArray = [_userCenterModel.imageUrl componentsSeparatedByString:@";"];
        } else {
            urlArray = @[_userCenterModel.imageUrl];
        }
        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray sourceImageView:tapView];
    }
}

#pragma mark -
#pragma mark - 评论后更新模型数据
- (void)updateModelDataForComment:(NSNotification *)noti {
    NSNumber *content = noti.userInfo[@"NewCommentTimes"];
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_userCenterModel.trendsId isEqualToString:focusId]) {
        _userCenterModel.commentCount = content;
        [_commentButton setTitle:[content stringValue] forState:UIControlStateNormal];
    }
}

- (void)updateModelDataForFavour:(NSNotification *)noti {
    NSString *focusId = noti.userInfo[@"CurrentFocusID"];
    if ([_userCenterModel.trendsId isEqualToString:focusId]) {
        NSNumber *content = noti.userInfo[@"NewFavourCount"];
        NSNumber *praise  = noti.userInfo[@"praise"];
        _userCenterModel.recommendCount = content;
        [_favourButton setTitle:[content stringValue] forState:UIControlStateNormal];
        _userCenterModel.praise = [praise boolValue];
        _favourButton.selected = [praise boolValue];
    }
}

@end
