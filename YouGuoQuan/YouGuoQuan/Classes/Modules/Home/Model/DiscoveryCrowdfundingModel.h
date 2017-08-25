//
//  DiscoveryCrowdfundingModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryCrowdfundingModel : NSObject
@property (nonatomic,   copy) NSString *crowdfundingId;
@property (nonatomic,   copy) NSString *createTime;
@property (nonatomic,   copy) NSString *updateTime;
// 详情图
@property (nonatomic,   copy) NSString *bannerImageUrl;
// 封面图
@property (nonatomic,   copy) NSString *coverImgUrl;
// 标题
@property (nonatomic,   copy) NSString *cTitle;
// 众筹截止时间
@property (nonatomic,   copy) NSString *cfTimeEnd;
// 活动描述
@property (nonatomic,   copy) NSString *descs;
// 奖项
@property (nonatomic,   copy) NSString *prizeDescs;
// 活动开始时间
@property (nonatomic,   copy) NSString *timeStart;
// 活动结束时间
@property (nonatomic,   copy) NSString *timeEnd;
// 主办范围
@property (nonatomic,   copy) NSString *cOrganizer;
// 模特
@property (nonatomic,   copy) NSString *modle;
//
@property (nonatomic, assign) BOOL isDelete;
// 目前参加总人数
@property (nonatomic, assign) NSUInteger joinPeople;

+ (instancetype)discoveryCrowdfundingModelWithDict:(NSDictionary *)dict;
- (instancetype)initDiscoveryCrowdfundingModelWithDict:(NSDictionary *)dict;
@end
