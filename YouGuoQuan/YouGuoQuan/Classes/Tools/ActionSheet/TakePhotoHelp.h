//
//  TakePhotoHelp.h
//  YouGuoQuan
//
//  Created by YM on 2016/11/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerItem;
@interface TakePhotoHelp : NSObject

@property (nonatomic,   copy) void (^selectedPhotosReturnBlock)(BOOL isCover, NSArray<UIImage *> *photos);

@property (nonatomic,   copy) void (^selectedVideosReturnBlock)(UIImage *coverImage, id asset, double time, AVPlayerItem *playerItem);

+ (instancetype)sharedInstance;

- (void)showActionSheetWithTitle:(NSString *)title viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL isCover, NSArray<UIImage *> *photos))result;

- (void)showActionSheetWithTitle:(NSString *)title photosCount:(NSInteger)count viewController:(UIViewController *)vc returnBlock:(void (^)(BOOL isCover, NSArray<UIImage *> *photos))result;

- (void)showActionSheetForSelectVideoWithTitle:(NSString *)title viewController:(UIViewController *)vc returnBlock:(void (^)(UIImage *coverImage, id asset, double time, AVPlayerItem *playerItem))result;

@end
