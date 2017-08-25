//
//  HomeBannerModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/3.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "HomeBannerModel.h"
#import <MJExtension/MJExtension.h>

@implementation HomeBannerModel

+ (instancetype)homeBannerModelWithDict:(NSDictionary *)dict {
    [HomeBannerModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"bannerId" : @"id"};
    }];
    return [[HomeBannerModel alloc] initSearchReaultModelWithDict:dict];
}

- (instancetype)initSearchReaultModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self =  [HomeBannerModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end