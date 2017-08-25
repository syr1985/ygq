//
//  DiscoveryCrowdfundingModel.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/26.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "DiscoveryCrowdfundingModel.h"
#import <MJExtension.h>

@implementation DiscoveryCrowdfundingModel

+ (instancetype)discoveryCrowdfundingModelWithDict:(NSDictionary *)dict {
    [DiscoveryCrowdfundingModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"crowdfundingId" : @"id"};
    }];
    return [[DiscoveryCrowdfundingModel alloc] initDiscoveryCrowdfundingModelWithDict:dict];
}

- (instancetype)initDiscoveryCrowdfundingModelWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self = [DiscoveryCrowdfundingModel mj_objectWithKeyValues:dict];
    }
    return self;
}

@end
