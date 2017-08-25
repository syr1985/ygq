//
//  UserCenterVideoViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/6.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kUserCenterCommentSuccessNotification;
extern NSString * const kPlayingVideoNotification;
extern NSString * const kUpdatePlayTimesNotification;
extern NSString * const kFavourSuccessNotification;

@class UserCenterModel;
@interface UserCenterVideoViewCell : UITableViewCell
@property (nonatomic,   copy) void (^commentBlock)(UserCenterModel *userCenterModel);
@property (nonatomic,   copy) void (^actionSheetItemClicked)(NSUInteger buttonIndex, NSString *trendsId, int goodsType, NSIndexPath *indexPath);
@property (nonatomic, strong) UserCenterModel *userCenterModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)releaseWMPlayer;
- (void)stopWMPlayer;
@end
