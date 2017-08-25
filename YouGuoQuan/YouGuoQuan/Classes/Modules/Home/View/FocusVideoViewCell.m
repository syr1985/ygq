//
//  FocusVideoViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "FocusVideoViewCell.h"
#import "HomeFocusModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MoreMenuHelp.h"
#import "WMPlayer.h"
#import <Masonry.h>
#import "NSDate+LXExtension.h"
#import "PhotoBrowserHelp.h"
#import "UIImage+Color.h"

NSString * const kPlayingVideoNotification = @"kPlayingVideoNotification_Stop";
NSString * const kUpdatePlayTimesNotification = @"kUpdatePlayTimesNotification";

@interface FocusVideoViewCell () <WMPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;

@property (weak, nonatomic) IBOutlet UIImageView *tyrantImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoCoverImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIView   *videoBackgroundView;

@property (weak, nonatomic) IBOutlet UIButton *favourButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *playTimesButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) WMPlayer *wmPlayer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tyrantImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexImageViewLeadingConstraint;
@end

@implementation FocusVideoViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopWMPlayer];
}

//- (WMPlayer *)wmPlayer {
//    if (!_wmPlayer) {
//        _wmPlayer = [[WMPlayer alloc] init];
//        _wmPlayer.delegate = self;
//        _wmPlayer.isFullscreen = NO;
//        _wmPlayer.closeBtnStyle = CloseBtnStyleClose;
//        _wmPlayer.URLString = _homeFocusModel.videoUrl;
//        _wmPlayer.titleLabel.text = _homeFocusModel.instro;
//        [_wmPlayer hiddenControlView];
//        
//        [_videoBackgroundView addSubview:_wmPlayer];
//        [_videoBackgroundView bringSubviewToFront:_playButton.superview];
//        __weak typeof(self) weakself = self;
//        [_wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakself.videoBackgroundView);
//            make.left.equalTo(weakself.videoBackgroundView);
//            make.right.equalTo(weakself.videoBackgroundView);
//            make.bottom.equalTo(weakself.videoBackgroundView);
//        }];
//    }
//    return _wmPlayer;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = 20;
    _headerImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapHeader = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderImageView)];
    [_headerImageView addGestureRecognizer:tapHeader];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popupPhotoBrowser:)];
//    [_videoBackgroundView addGestureRecognizer:tap];
    
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateModelDataForComment:)
                                                 name:kCommentSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlayingVideo:)
                                                 name:kPlayingVideoNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePlayTimes:)
                                                 name:kUpdatePlayTimesNotification
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
    
    _publishTitleLabel.text = homeFocusModel.instro;
    
    NSTimeInterval timeInterval = [homeFocusModel.createTime doubleValue];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeInterval / 1000];
    LXDateItem *item = [[NSDate date] lx_timeIntervalSinceDate:createDate];
    _publishTimeLabel.text = [NSString stringWithFormat:@"%@前",item.description];
    
    UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                     size:_videoCoverImageView.frame.size];
    NSString *coverImageUrlStr = [NSString cropImageUrlWithUrlString:homeFocusModel.videoEvelope
                                                               width:_videoCoverImageView.bounds.size.width
                                                              height:_videoCoverImageView.bounds.size.height];
    [_videoCoverImageView sd_setImageWithURL:[NSURL URLWithString:coverImageUrlStr]
                            placeholderImage:phImage];
    
    _favourButton.selected = homeFocusModel.praise;
    [_favourButton setTitle:[homeFocusModel.recommendCount stringValue] forState:UIControlStateNormal];
    [_commentButton setTitle:[homeFocusModel.commentCount stringValue] forState:UIControlStateNormal];
    [_playTimesButton setTitle:[homeFocusModel.playTimes stringValue] forState:UIControlStateNormal];
    
    if (!_wmPlayer) {
        _wmPlayer = [[WMPlayer alloc] init];
        _wmPlayer.delegate = self;
        _wmPlayer.isFullscreen = NO;
        _wmPlayer.closeBtnStyle = CloseBtnStyleClose;
        _wmPlayer.URLString = _homeFocusModel.videoUrl;
        _wmPlayer.titleLabel.text = _homeFocusModel.instro;
        [_wmPlayer hiddenControlView];
        
        [_videoBackgroundView addSubview:_wmPlayer];
        [_videoBackgroundView bringSubviewToFront:_playButton.superview];
        __weak typeof(self) weakself = self;
        [_wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.videoBackgroundView);
            make.left.equalTo(weakself.videoBackgroundView);
            make.right.equalTo(weakself.videoBackgroundView);
            make.bottom.equalTo(weakself.videoBackgroundView);
        }];
    }
}

/**
 *  释放WMPlayer
 */
- (void)releaseWMPlayer {
    if (self.wmPlayer.state == WMPlayerStatePlaying) {
        [self.wmPlayer pause];
    }
    
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer removeFromSuperview];
    
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.wmPlayer.autoDismissTimer invalidate];
    self.wmPlayer.autoDismissTimer = nil;
    
    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
    self.wmPlayer = nil;
}

- (void)stopWMPlayer {
    if (self.wmPlayer.state == WMPlayerStatePlaying) {
        [self.wmPlayer pause];
    }
}

- (void)stopPlayingVideo:(NSNotification *)noti {
    NSDictionary *infoDict = noti.userInfo;
    if (![infoDict[@"feedsId"] isEqualToString:self.homeFocusModel.focusId]) {
        [self stopWMPlayer];
    }
}

- (void)updatePlayTimes:(NSNotification *)noti {
    NSDictionary *infoDict = noti.userInfo;
    if ([infoDict[@"feedsId"] isEqualToString:_homeFocusModel.focusId]) {
        [self updateLocalPlayTimes];
    }
}

- (void)updateLocalPlayTimes {
    NSUInteger playTimes = [_homeFocusModel.playTimes integerValue] ;
    NSString *newplayTimes = [NSString stringWithFormat:@"%zd",playTimes + 1];
    _homeFocusModel.playTimes = @(playTimes + 1);//newplayTimes;
    [_playTimesButton setTitle:newplayTimes forState:UIControlStateNormal];
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
 *  更多按钮点击
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
 *  播放按钮
 */
- (IBAction)startPlayVideo:(UIButton *)sender {
    // 判断当前网络
    self.wmPlayer.URLString = self.homeFocusModel.videoUrl;
    //_wmPlayer.placeholderImage = _videoCoverImageView.image;
    [self.videoBackgroundView bringSubviewToFront:self.wmPlayer];
    [self.wmPlayer play];
    
    // 增加播放次数
    [NetworkTool updatePlayTimesWithVideoTrendsID:_homeFocusModel.focusId success:^{
        if (self.isTrendsDetail) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePlayTimesNotification
                                                                object:nil
                                                              userInfo:@{@"feedsId":self.homeFocusModel.focusId}];
        } else {
            [self updateLocalPlayTimes];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayingVideoNotification
                                                        object:nil
                                                      userInfo:@{@"feedsId":self.homeFocusModel.focusId}];
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
#pragma mark - WMPlayerDelegate
- (void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn {
    if (wmplayer.state == WMPlayerStatePlaying) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPlayingVideoNotification
                                                            object:nil
                                                          userInfo:@{@"feedsId":_homeFocusModel.focusId}];
    }
}
// 点击关闭按钮
- (void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn {
    if (wmplayer.isFullscreen) {
        [_videoBackgroundView addSubview:self.wmPlayer];
        [self toOrientation:UIInterfaceOrientationPortrait];
        wmplayer.isFullscreen = NO;
        wmplayer.closeBtnStyle = CloseBtnStyleClose;
    }
}

// 点击全屏按钮
- (void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn {
    [self.wmPlayer removeFromSuperview];
    if (self.wmPlayer.isFullscreen) {//全屏
        [_videoBackgroundView addSubview:self.wmPlayer];
        [self toOrientation:UIInterfaceOrientationPortrait];
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.closeBtnStyle = CloseBtnStyleClose;
    } else {//非全屏
        [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.closeBtnStyle = CloseBtnStylePop;
    }
}

// 结束播放
- (void)wmplayerFinishedPlay:(WMPlayer *)wmplayer {
    // 恢复视频视图
    [self toOrientation:UIInterfaceOrientationPortrait];
    [_videoBackgroundView bringSubviewToFront:_playButton.superview];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification {
    if (!self.wmPlayer || !self.wmPlayer.superview || self.wmPlayer.state != WMPlayerStatePlaying) {
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait: {
            if (self.wmPlayer.isFullscreen) {
                [self.wmPlayer removeFromSuperview];
                [_videoBackgroundView addSubview:self.wmPlayer];
                [self toOrientation:UIInterfaceOrientationPortrait];
                self.wmPlayer.isFullscreen = NO;
                self.wmPlayer.closeBtnStyle = CloseBtnStyleClose;
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            if (!self.wmPlayer.isFullscreen) {
                [self.wmPlayer removeFromSuperview];
                [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.wmPlayer.isFullscreen = YES;
                self.wmPlayer.closeBtnStyle = CloseBtnStylePop;
            }
        }
            break;
        default:
            break;
    }
    //[self setNeedsStatusBarAppearanceUpdate];
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
- (void)toOrientation:(UIInterfaceOrientation)orientation {
    //根据要旋转的方向,使用Masonry重新修改限制
    __weak typeof(self) weakself = self;
    if (orientation == UIInterfaceOrientationPortrait) {
        [_wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.videoBackgroundView);
            make.left.equalTo(weakself.videoBackgroundView);
            make.center.equalTo(weakself.videoBackgroundView);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.wmPlayer.transform = CGAffineTransformIdentity;
        }];
    } else {
        //获取到当前状态条的方向
        
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        //这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            CGSize size = self.wmPlayer.currentItem.presentationSize;
            if (size.width < size.height) {// 竖屏拍的
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.center.equalTo([UIApplication sharedApplication].keyWindow);
                }];
                
                [UIView animateWithDuration:0.25 animations:^{
                    weakself.wmPlayer.transform = CGAffineTransformIdentity;//[WMPlayer getCurrentDeviceOrientation];
                }];
            } else {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.center.equalTo([UIApplication sharedApplication].keyWindow);
                }];
                
                [UIView animateWithDuration:0.25 animations:^{
                    weakself.wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
                }];
            }
        }
    }
}

/**
 *  打开图片浏览器
 */
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    if (_homeFocusModel.videoEvelope && _homeFocusModel.videoEvelope.length) {
        NSArray *urlArray;
        if ([_homeFocusModel.videoEvelope containsString:@";"]) {
            urlArray = [_homeFocusModel.videoEvelope componentsSeparatedByString:@";"];
        } else {
            urlArray = @[_homeFocusModel.videoEvelope];
        }
        UIImageView *tapView = (UIImageView *)sender.view;
        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray sourceImageView:tapView];
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
