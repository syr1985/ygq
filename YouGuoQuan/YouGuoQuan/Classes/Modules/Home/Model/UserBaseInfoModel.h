//
//  UserBaseInfoModel.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/3.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 isDelete = "";
 isLock = 0;
 */

@interface UserBaseInfoModel : NSObject
// ---- 主要的 ----//
// 用户ID
@property (nonatomic,   copy) NSString *userId;
// 头像url
@property (nonatomic,   copy) NSString *headImg;
// 昵称
@property (nonatomic,   copy) NSString *nickName;
// 性别
@property (nonatomic,   copy) NSString *sex;
// 城市
@property (nonatomic,   copy) NSString *city;
// 粉丝数
@property (nonatomic,   copy) NSString *fansCount;
// 关注数
@property (nonatomic,   copy) NSString *focusCount;
// 赞数
@property (nonatomic,   copy) NSString *zanCount;
// 好评率
@property (nonatomic,   copy) NSString *rateOfPraise;
// 头像背景图
@property (nonatomic,   copy) NSString *coverImgUrl;
// --- 次要的 ---//
// 认证的图片URL
@property (nonatomic,   copy) NSString *authentiUrl;
// 邮箱
@property (nonatomic,   copy) NSString *email;
// 手机号
@property (nonatomic,   copy) NSString *mobile;
// 密码
@property (nonatomic,   copy) NSString *passwd;
// 照片墙图片数
@property (nonatomic,   copy) NSString *imageCount;
// 身高
@property (nonatomic,   copy) NSString *height;
// 体重
@property (nonatomic,   copy) NSString *weight;
// 星座
@property (nonatomic,   copy) NSString *constellatory;
// 工作
@property (nonatomic,   copy) NSString *work;
// 情感
@property (nonatomic,   copy) NSString *emotion;
// 省份
@property (nonatomic,   copy) NSString *province;
// 尤果认证
@property (nonatomic,   copy) NSString *auditResult;
// 真实姓名
@property (nonatomic,   copy) NSString *realName;
// QQ
@property (nonatomic,   copy) NSString *qq;
// 微信
@property (nonatomic,   copy) NSString *wechat;
// 身份证号
@property (nonatomic,   copy) NSString *zfbAccount;
// 是否认证（vip）-- 0（未认证） 1（已认证） 2（进行中）3(团体认证) 4 团体进行中
@property (nonatomic, assign) int  audit;
// 是否贵族
@property (nonatomic, assign) BOOL isRecommend;
// 是否系统推荐
@property (nonatomic, assign) BOOL tags;
// 等级
@property (nonatomic, assign) int  star;
// 经度
@property (nonatomic, assign) double longitude;
// 纬度
@property (nonatomic, assign) double latitude;

+ (instancetype)userBaseInfoModelWithDict:(NSDictionary *)dict;
- (instancetype)initUserBaseInfoModelWithDict:(NSDictionary *)dict;
@end