/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */


#import <UIKit/UIKit.h>
#import <JKCountDownButton.h>

extern CGFloat const EaseMessageCellPadding;

extern NSString *const EaseMessageCellIdentifierSendText;
extern NSString *const EaseMessageCellIdentifierSendLocation;
extern NSString *const EaseMessageCellIdentifierSendVoice;
extern NSString *const EaseMessageCellIdentifierSendVideo;
extern NSString *const EaseMessageCellIdentifierSendImage;
extern NSString *const EaseMessageCellIdentifierSendFile;

extern NSString *const EaseMessageCellIdentifierRecvText;
extern NSString *const EaseMessageCellIdentifierRecvLocation;
extern NSString *const EaseMessageCellIdentifierRecvVoice;
extern NSString *const EaseMessageCellIdentifierRecvVideo;
extern NSString *const EaseMessageCellIdentifierRecvImage;
extern NSString *const EaseMessageCellIdentifierRecvFile;

@interface EaseBubbleView : UIView
{
    UIEdgeInsets _margin;
    CGFloat _fileIconSize;
}

@property (nonatomic) BOOL isSender;

@property (nonatomic, readonly) UIEdgeInsets margin;

@property (strong, nonatomic) NSMutableArray *marginConstraints;

@property (strong, nonatomic) UIImageView *backgroundImageView;

//text views
@property (strong, nonatomic) UILabel *textLabel;

//image views
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic,   copy) NSString *imageUrl;

//location views
@property (strong, nonatomic) UIImageView *locationImageView;
@property (nonatomic, strong) UIView  *textBackView;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *detailLocationLabel;

//voice views
@property (strong, nonatomic) UIImageView *voiceImageView;
@property (strong, nonatomic) UILabel *voiceDurationLabel;
@property (strong, nonatomic) UIImageView *isReadView;

//video views
@property (strong, nonatomic) UIImageView *videoImageView;
@property (strong, nonatomic) UIImageView *videoTagView;

//file views
@property (strong, nonatomic) UIImageView *fileIconView;
@property (strong, nonatomic) UILabel *fileNameLabel;
@property (strong, nonatomic) UILabel *fileSizeLabel;

//snap views
@property (strong, nonatomic) UIView *snapBackView;
@property (strong, nonatomic) UIImageView *snapImageView;
@property (strong, nonatomic) UILabel *snapLabel;
@property (nonatomic, strong) JKCountDownButton *countDownButton;

@property (nonatomic,   copy) void (^deleteMessageBolck)();
@property (nonatomic,   copy) void (^sendMessageReadBolck)();

- (instancetype)initWithMargin:(UIEdgeInsets)margin
                      isSender:(BOOL)isSender;

@end