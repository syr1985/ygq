//
//  UploadImageTool.h
//  YouGuoQuan
//
//  Created by YM on 2017/8/18.
//  Copyright © 2017年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageTool : NSObject

//+ (void)uploadImages:(NSMutableArray<NSDictionary *> *)images orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *dataArray, NSArray *urlArray))failure;
//
//+ (void)pornImageWithUrls:(NSArray *)imageUrlArray success:(void (^)())success failure:(void (^)(NSArray *sexImageUrlArray))failure;

// ---上面是先上传七牛云，再鉴黄，下面相反----
+ (void)pornImageWithImages:(NSArray<NSDictionary *> *)imageArray orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *newImageArray, NSArray *sexImageArray))failure;

+ (void)uploadImages:(NSArray<NSDictionary *> *)images orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *dataArray))failure;

+ (void)pornVideoWithImages:(NSArray<NSDictionary *> *)imageArray success:(void (^)())success failure:(void (^)(NSArray *sexImageArray))failure;

@end
