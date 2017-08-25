//
//  PersonCenterViewCell.m
//  YouGuoQuan
//
//  Created by YM on 2017/1/3.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "PersonCenterViewCell.h"
#import "UserBaseInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "TakePhotoHelp.h"
#import "UIImage+Color.h"
#import "PhotoBrowserHelp.h"
#import "LongPressHelp.h"
#import "PhotoWallModel.h"

@interface PersonCenterViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView  *headerBackgroundImageView;   // 头像背景
@property (weak, nonatomic) IBOutlet UIView       *backgroundBlurView;
@property (weak, nonatomic) IBOutlet UIImageView  *headerImageView;             // 头像
@property (weak, nonatomic) IBOutlet UIImageView  *crownImageView;              // 皇冠
@property (weak, nonatomic) IBOutlet UIImageView  *recommandImageView;          // 右下角V
@property (weak, nonatomic) IBOutlet UIImageView  *goldenVipImageView;          // 壕

@property (weak, nonatomic) IBOutlet UILabel      *nickNameLabel;               // 昵称
@property (weak, nonatomic) IBOutlet UIImageView  *sexImageView;                // 性别
@property (weak, nonatomic) IBOutlet UIImageView  *levelImageView;              // 等级
@property (weak, nonatomic) IBOutlet UIImageView  *vipImageView;

@property (weak, nonatomic) IBOutlet UILabel      *indentificationLabel;        // 尤果认证
@property (weak, nonatomic) IBOutlet UILabel      *positiveRateLabel;           // 好评率

@property (weak, nonatomic) IBOutlet UIButton     *concemButton;                // 关注
@property (weak, nonatomic) IBOutlet UIButton     *fansButton;                  // 粉丝
@property (weak, nonatomic) IBOutlet UIButton     *favourButton;                // 赞
@property (weak, nonatomic) IBOutlet UIStackView  *publishStackView;
@property (weak, nonatomic) IBOutlet UIScrollView *photoWallScrollView;         // 照片墙
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipImageViewLeadingConstraint;

@end

@implementation PersonCenterViewCell

- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width * 0.5;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.borderWidth = 2;
    
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapUserHeaderImageView:)];
    [_headerImageView addGestureRecognizer:tapHead];
    
    UITapGestureRecognizer *tapBlur = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapBackgroundImageView:)];
    [_backgroundBlurView addGestureRecognizer:tapBlur];
    
    _stackViewHeightConstraint.constant = 33;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePhotoWallImage:)
                                                 name:kNotification_DeletePhotoWallImage
                                               object:nil];
}

- (void)modifyImage:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSArray *imageArray = userInfo[@"photos"];
    BOOL isCover = [userInfo[@"isCover"] boolValue];
    if (isCover) {
        _headerBackgroundImageView.image = imageArray[0];
    } else {
        NSArray *oldImagesArray = _photoWallScrollView.subviews;
        NSMutableArray *totalImagesArray = [NSMutableArray new];
        [totalImagesArray addObjectsFromArray:oldImagesArray];
        
        NSUInteger photoCount = imageArray.count;
        NSMutableArray *newImageViewArray = [NSMutableArray new];
        for (NSUInteger i = 0; i < photoCount; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = imageArray[i];
            imageView.tag = i;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(popupPhotoBrowser:)];
            [imageView addGestureRecognizer:tap];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(deleteImage:)];
            [imageView addGestureRecognizer:longPress];
            
            [newImageViewArray addObject:imageView];
        }
        [totalImagesArray insertObjects:newImageViewArray atIndexes:[NSIndexSet indexSetWithIndex:1]];
        
        for (UIView *view in self.photoWallScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        CGFloat imageViewH = _photoWallScrollView.frame.size.height;
        for (NSInteger i = 0; i < totalImagesArray.count; i++) {
            UIImageView *imageView = totalImagesArray[i];
            CGFloat imageViewX = imageViewH * i + 8 * (i + 1);
            imageView.frame = CGRectMake(imageViewX, 0, imageViewH, imageViewH);
            [_photoWallScrollView addSubview:imageView];
        }
        _photoWallScrollView.contentSize = CGSizeMake((imageViewH + 8) * photoCount + 8, imageViewH);
    }
}

- (void)setUserBaseInfoModel:(UserBaseInfoModel *)userBaseInfoModel {
    _userBaseInfoModel = userBaseInfoModel;
    
    NSString *headBackImageUrlStr = [NSString cropImageUrlWithUrlString:userBaseInfoModel.coverImgUrl
                                                                  width:_headerBackgroundImageView.bounds.size.width
                                                                 height:_headerBackgroundImageView.bounds.size.height];
    [_headerBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:headBackImageUrlStr]
                                  placeholderImage:[UIImage imageNamed:@"背景封面默认图"]];
    
    NSString *headImageUrlStr = [NSString cropImageUrlWithUrlString:userBaseInfoModel.headImg
                                                              width:_headerImageView.bounds.size.width
                                                             height:_headerImageView.bounds.size.height];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrlStr]
                        placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    
    _crownImageView.hidden = !(userBaseInfoModel.star == 6);
    _goldenVipImageView.hidden = !(userBaseInfoModel.star == 5);
    _recommandImageView.hidden = !(userBaseInfoModel.audit == 1 || userBaseInfoModel.audit == 3);
    _recommandImageView.image  = userBaseInfoModel.audit == 3 ? [UIImage imageNamed:@"列表头像团体认证"] : [UIImage imageNamed:@"头像加V"];
    
    _vipImageViewWidthConstraint.constant = userBaseInfoModel.isRecommend ? 29 : 0;
    _vipImageViewLeadingConstraint.constant = userBaseInfoModel.isRecommend ? 4 : 0;
    _vipImageView.image = userBaseInfoModel.isRecommend ? [UIImage imageNamed:@"VIP"] : nil;
    
    _nickNameLabel.text = userBaseInfoModel.nickName;
    _sexImageView.image = [UIImage imageNamed:userBaseInfoModel.sex];

    _levelImageView.hidden = userBaseInfoModel.star == 0;
    if (userBaseInfoModel.star != 0) {
        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"等级 %d",userBaseInfoModel.star]];
    }

    if ((userBaseInfoModel.audit == 3 || userBaseInfoModel.audit == 1)) {
        NSString *auditResult = [NSString stringWithFormat:@"尤果认证：%@",userBaseInfoModel.auditResult];
        //NSString *rateOfPrise = [NSString stringWithFormat:@"好评率：%@%%",userBaseInfoModel.rateOfPraise];
        _indentificationLabel.text = auditResult;
        //_positiveRateLabel.text = rateOfPrise;
        _stackViewTopConstraint.constant = 8;
    } else {
        _indentificationLabel.text = @"";
        _positiveRateLabel.text = @"";
        _stackViewTopConstraint.constant = 0;
    }
    
    NSString *focusCountStr = [NSString stringWithFormat:@"%@  关注",userBaseInfoModel.focusCount];
    long long focusCount = [userBaseInfoModel.focusCount longLongValue];
    if (focusCount > 99999) {
        focusCountStr = [NSString stringWithFormat:@"%zd万  关注", focusCount / 10000];
    }
    NSString *fansCountStr = [NSString stringWithFormat:@"%@  粉丝",userBaseInfoModel.fansCount];
    long long fansCount = [userBaseInfoModel.fansCount longLongValue];
    if (fansCount > 99999) {
        fansCountStr = [NSString stringWithFormat:@"%zd万  粉丝", fansCount / 10000];
    }
    NSString *zanCountStr = [NSString stringWithFormat:@"%@  赞",userBaseInfoModel.zanCount];
    long long zanCount = [userBaseInfoModel.zanCount longLongValue];
    if (zanCount > 99999) {
        zanCountStr = [NSString stringWithFormat:@"%zd万  赞", zanCount / 10000];
    }
    
    [_concemButton setTitle:focusCountStr forState:UIControlStateNormal];
    [_fansButton setTitle:fansCountStr forState:UIControlStateNormal];
    [_favourButton setTitle:zanCountStr forState:UIControlStateNormal];
}

- (void)setPhotoArray:(NSMutableArray *)photoArray {
    _photoArray = photoArray;
    
    [self updatePhotoWall];
}

- (void)updatePhotoWall {
    for (UIView *view in self.photoWallScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    NSUInteger photoCount = _photoArray.count;
    CGFloat imageViewH = _photoWallScrollView.frame.size.height;
    
    for (NSUInteger i = 0; i < photoCount; i++) {
        id obj = _photoArray[i];
        CGFloat imageViewX = imageViewH * i + 8 * (i + 1);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(imageViewX, 0, imageViewH, imageViewH);
        
        if ([obj isKindOfClass:[PhotoWallModel class]]) {
            PhotoWallModel *model = (PhotoWallModel *)obj;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(popupPhotoBrowser:)];
            [imageView addGestureRecognizer:tap];
            
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                    action:@selector(deleteImage:)];
            [imageView addGestureRecognizer:longPress];
            
            UIImage *phImage = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:0 alpha:0.1]
                                                             size:imageView.frame.size];
            NSString *imageUrlStr = [NSString cropImageUrlWithUrlString:model.imageUrl
                                                                  width:imageViewH
                                                                 height:imageViewH];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                         placeholderImage:phImage];
        } else {
            imageView.image = [UIImage imageNamed:obj];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(openPhotoAlbum)];
            [imageView addGestureRecognizer:tap];
        }
        [_photoWallScrollView addSubview:imageView];
    }
    _photoWallScrollView.contentSize = CGSizeMake((imageViewH + 8) * photoCount + 8, imageViewH);
}

#pragma mark - 删除照片墙图片
- (void)deleteImage:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        __weak typeof(self) weakself = self;
        [LongPressHelp showMenuForLongPressImageWithReturnBlock:^(NSUInteger index) {
            if (index == 1) {
                [weakself deletePhotoWallImageWithIndex:sender.view.tag];
            }
        }];
    }
}

- (void)deletePhotoWallImage:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSInteger index = [userInfo[@"imageIndex"] integerValue];
    [self deletePhotoWallImageWithIndex:index];
    //NSLog(@"%@",userInfo);
}

- (void)deletePhotoWallImageWithIndex:(NSInteger)index {
    if (index < self.photoArray.count && index > 0) {
        __weak typeof(self) weakself = self;
        PhotoWallModel *model = self.photoArray[index];
        [NetworkTool deleteImageFromPhotoWallWithImageId:model.imageId success:^{
            __strong typeof(self) strongself = weakself;
            [SVProgressHUD showSuccessWithStatus:@"删除图片成功"];
            [strongself.photoArray removeObjectAtIndex:index];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongself updatePhotoWall];
            });
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"删除图片失败"];
        }];
    }
}

#pragma mark - 打开图片浏览器
- (void)popupPhotoBrowser:(UITapGestureRecognizer *)sender {
    UIImageView *tapView = (UIImageView *)sender.view;
    if (_photoArray.count > 1) {
        NSRange range = {1, _photoArray.count - 1};
        NSArray *modelArray = [_photoArray subarrayWithRange:range];
        NSMutableArray *urlArray = [NSMutableArray array];
        for (PhotoWallModel *model in modelArray) {
            [urlArray addObject:model.imageUrl];
        }
        [PhotoBrowserHelp openPhotoBrowserWithImages:urlArray sourceImageView:tapView canDeleteImage:YES];
    }
}

#pragma mark - 点击头像查看个人信息
- (void)tapUserHeaderImageView:(id)sender {
    if (_tapHeaderImageViewBlock) {
        _tapHeaderImageViewBlock();
    }
}

#pragma mark - 修改背景图片
- (void)tapBackgroundImageView:(UITapGestureRecognizer *)sender {
    if (_tapBackgroundImageViewBlock) {
        _tapBackgroundImageViewBlock();
    }
}

#pragma mark - 他人关注
- (IBAction)lookOthersConcems {
    if (_concemButtonClickedBlock) {
        _concemButtonClickedBlock();
    }
}

#pragma mark - 他人粉丝
- (IBAction)lookOthersFuns {
    if (_funsButtonClickedBlock) {
        _funsButtonClickedBlock();
    }
}

#pragma mark - 他赞过的
- (IBAction)lookOthersFavours {
    if (_favourButtonClickedBlock) {
        _favourButtonClickedBlock();
    }
}

#pragma mark - 添加照片墙图片
- (void)openPhotoAlbum {
    if (_selectPhotoBlock) {
        _selectPhotoBlock();
    }
}

#pragma mark - 出售微信
#pragma mark - 原来是发布微信，17-8-18改为图文动态了，方法名及block名懒得改了
- (IBAction)sellWeiXinButtonClicked:(id)sender {
    if (_publishBlock) {
        _publishBlock(@"PublishTrends");
    }
}

#pragma mark - 发布红包
- (IBAction)publishRedpacketButtonClicked:(id)sender {
    if (_publishBlock) {
        _publishBlock(@"PublishRedEnvelope");
    }
}

@end
