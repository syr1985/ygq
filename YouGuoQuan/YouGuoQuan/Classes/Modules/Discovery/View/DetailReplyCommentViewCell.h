//
//  VideoReplyCommentViewCell.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/30.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCommentModel;
@interface DetailReplyCommentViewCell : UITableViewCell
@property (nonatomic,   copy) void (^tapCommentBlock)(DetailCommentModel *model);
@property (nonatomic,   copy) void (^longPressCommentBlock)(DetailCommentModel *model);
@property (nonatomic,   copy) void (^tapHeadImageViewBlock)(NSString *userId);
@property (nonatomic, strong) DetailCommentModel *detailCommentModel;
@end
