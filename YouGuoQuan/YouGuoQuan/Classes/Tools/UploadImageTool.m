//
//  UploadImageTool.m
//  YouGuoQuan
//
//  Created by YM on 2017/8/18.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "UploadImageTool.h"
#import "QiniuUploadHelper.h"
#import <AFNetworking.h>
#import "NSString+Random.h"
#import "HBRSAHandler.h"
#import "UIImage+Color.h"

@implementation UploadImageTool

static NSString * const private_key_string = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMt94JwYhkzqiFbWoJSC6P6uY8SGTPi36xKa/rDeBoVLShCyleYR3L6xCgTTHbzLqC5RvtqWl3g6hHq/JyVLNav308urZth3NBwGZMB/zwVHOqfAFIgCTPW/L6H0UoremQrgCAQV+qcQrlawG1fZY+4V1DQxIqqXzjNSKxal4kgNAgMBAAECgYAoZ70yoXgBS8x4mbNW6cuDznLG8ffUpwhJMHeD/QIEc5eoSx2Sildvkc2weY79Dt89G0QvORmoaM4nZU9Li2yDdr48HsIeXPhSz+gNM/nRaUf6YWu1UdFKcSgcHwQHotqFhNhGUzJKigpqI+eOmigF8ZD7yoId18rrM2XVF9zTgQJBAP/OB2nqSbQZRyji0DgT77RStPez8nICXEU9WRsTPCS6h5jYzjbndQWXYNKNLWwgPrTD1k71sifpeQq591ndeG0CQQDLpaEPxOQ87IbCqDgp2P+tHzwxcnO8bL8AwIvzExIT3k8KPh5zoW8PsamWnywu7d7+uMv7R562RGVTj0BGN4ohAkEAkrvDIu1Cs+1gFULtv40oDd73cbMmGmHiPdFwAIjrEgJxb6rFt1bTmI55+q0C5igk8Bn6H7buJ9jUFuQPz9urjQJBAIiQuPKnOdu1TiXJw2gk0kiZkrciJoTsdCYf+Xn3hv717RFUWP13+8+Nd8m/UlTiRdGRwZDwFXnrYfvoK9Uqt6ECQQDmRgjHIU1rZUTYK0UnQqWH4wzRgh2xrHdInHLFt4AxM2/k3FS/Aq+ne8/+mzZvJGk5KZWKg2JopxkRGSqdzNof";

//static NSString * const public_key_string = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLfeCcGIZM6ohW1qCUguj+rmPEhkz4t+sSmv6w3gaFS0oQspXmEdy+sQoE0x28y6guUb7alpd4OoR6vyclSzWr99PLq2bYdzQcBmTAf88FRzqnwBSIAkz1vy+h9FKK3pkK4AgEFfqnEK5WsBtX2WPuFdQ0MSKql84zUisWpeJIDQIDAQAB";

//+ (void)uploadImages:(NSMutableArray<NSDictionary *> *)images orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *dataArray, NSArray *urlArray))failure {
//    NSMutableArray *imagesDataArray = [images mutableCopy];
//    NSMutableArray *urlArray = [NSMutableArray array];
//    __block NSUInteger currentIndex = 0;
//    
//    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
//    __weak typeof(QiniuUploadHelper *) weakHelper = uploadHelper;
//    
//    __block void (^uploadImage)() = ^{
//        NSDictionary *infoDict = imagesDataArray[currentIndex];
//        NSString *url = infoDict[@"url"];
//        if (url.length) {
//            [urlArray addObject:url];
//            weakHelper.pornFailureBlock();// 这边借用block,此block原来也是用于七牛云鉴黄的处理，
//        }
//        UIImage *image = infoDict[@"image"];
//        NSData *imageData = nil;
//        if (orignal) {
//            imageData = UIImageJPEGRepresentation(image,1);
//        } else {
//            imageData = UIImageJPEGRepresentation(image,0.75);
//        }
//        if (imageData) {
//            [NetworkTool uploadImage:imageData
//                            progress:nil
//                             success:weakHelper.singleSuccessBlock
//                             failure:weakHelper.singleFailureBlock];
//        }
//    };
//    
//    weakHelper.pornFailureBlock = ^{
//        currentIndex++;
//        if (currentIndex == imagesDataArray.count - 1) {
//            // 全部上传完成
//            [self pornImageWithUrls:urlArray success:^{
//                if (success) {
//                    success(urlArray);
//                }
//            } failure:^(NSArray *sexImageUrlArray) {
//                if (failure) {
//                    failure(imagesDataArray, sexImageUrlArray);
//                }
//            }];
//            return;
//        } else if (currentIndex < imagesDataArray.count - 1) {
//            uploadImage();
//        }
//    };
//    
//    weakHelper.singleFailureBlock = ^{
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传第%zd张图片失败",currentIndex + 1]];
//        weakHelper.pornFailureBlock();
//        return;
//    };
//    
//    weakHelper.singleSuccessBlock = ^(NSString *url) {
//        [urlArray addObject:url];
//        
//        NSDictionary *infoDict = imagesDataArray[currentIndex];
//        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
//        [muDict setValue:url forKey:@"url"];
//        [imagesDataArray replaceObjectAtIndex:currentIndex withObject:muDict];
//        
//        weakHelper.pornFailureBlock();
//    };
//
//    uploadImage();
//}
//
//+ (void)pornImageWithUrls:(NSArray *)imageUrlArray success:(void (^)())success failure:(void (^)(NSArray *sexImageUrlArray))failure {
//    NSDate *nowDate = [NSDate date];
//    NSNumber *timestamp = [NSNumber numberWithDouble:(nowDate.timeIntervalSince1970 * 1000)];
//    NSString *randomStr = [NSString randomString];
//    NSString *beSignStr = [NSString stringWithFormat:@"%@,%@,%@",TuPu_Secret_ID,timestamp,randomStr];
//    
//    HBRSAHandler* handler = [HBRSAHandler new];
//    [handler importKeyWithType:KeyTypePrivate andkeyString:private_key_string];
////    [handler importKeyWithType:KeyTypePublic andkeyString:public_key_string];
//
//    NSString *signedStr = [handler signString:beSignStr];
////    NSLog(@"%@",[NSString stringWithFormat:@"签名后：%@",signedStr]);
////    if ([handler verifyString:beSignStr withSign:signedStr]) {
////        NSLog(@"验证签名成功");
////    } else {
////        NSLog(@"验证签名失败");
////    }
//    
//    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
//    muDict[@"image"]     = imageUrlArray;
//    muDict[@"nonce"]     = randomStr;
//    muDict[@"signature"] = signedStr;
//    muDict[@"timestamp"] = timestamp;
//
//    NSString * const pornUrl = [NSString stringWithFormat:@"http://api.open.tuputech.com/v3/recognition/%@",TuPu_Secret_ID];
//    // 1.创建AFN管理者
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:pornUrl parameters:muDict progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"response: %@",responseObject);
//        NSDictionary *dataDict = [responseObject objectForKey:TuPu_Task_ID];
//        if ([dataDict[@"code"] integerValue] == 0) {// 请求成功
//            NSMutableArray *sexArray = [NSMutableArray array];
//            NSArray *fileList = dataDict[@"fileList"];
//            for (NSDictionary *dict in fileList) {
//                if ([dict[@"label"] intValue] == 0 && [dict[@"rate"] floatValue] > 97.9) {
//                    [sexArray addObject:dict[@"name"]];
//                }
//            }
//            if (sexArray.count) {
//                if (failure) {
//                    failure([sexArray copy]);
//                }
//            } else {
//                if (success) {
//                    success();
//                }
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error: %@",error.localizedDescription);
//        if (failure) {
//            failure(nil);
//        }
//    }];
//}

+ (void)pornImageWithImages:(NSArray<NSDictionary *> *)imageArray orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *newImageArray, NSArray *sexImageArray))failure {
    NSDate *nowDate = [NSDate date];
    NSNumber *timestamp = [NSNumber numberWithDouble:(nowDate.timeIntervalSince1970 * 1000)];
    NSString *randomStr = [NSString randomString];
    NSString *beSignStr = [NSString stringWithFormat:@"%@,%@,%@",TuPu_Secret_ID,timestamp,randomStr];
    
    HBRSAHandler *handler = [HBRSAHandler new];
    [handler importKeyWithType:KeyTypePrivate andkeyString:private_key_string];
    NSString *signedStr = [handler signString:beSignStr];
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    //muDict[@"image"]     = imageArray;
    muDict[@"nonce"]     = randomStr;
    muDict[@"signature"] = signedStr;
    muDict[@"timestamp"] = timestamp;
    
    NSString * const pornUrl = [NSString stringWithFormat:@"http://api2.open.tuputech.com/v3/recognition/%@",TuPu_Secret_ID];
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.Post请求
    [manager POST:pornUrl parameters:muDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *dict in imageArray) {
            //  要上传的图片
            UIImage *image = [dict objectForKey:@"image"];
            //  压缩图片
            CGSize targetSize = CGSizeZero;
            if (image.size.width > image.size.height) {
                targetSize = CGSizeMake(256 / image.size.height * image.size.width, 256);
            } else {
                targetSize = CGSizeMake(256, 256 / image.size.width * image.size.height);
            }
            UIImage *scaleImage = [image imageCompressForSize:image targetSize:targetSize];
            
//            int  perMBBytes = 1024*1024;
//            CGImageRef cgimage = scaleImage.CGImage;
//            size_t bpp = CGImageGetBitsPerPixel(cgimage);
//            size_t bpc = CGImageGetBitsPerComponent(cgimage);
//            size_t bytes_per_pixel = bpp / bpc;
//            long lPixelsPerMB = perMBBytes / bytes_per_pixel;
//            long totalPixel = CGImageGetWidth(scaleImage.CGImage) * CGImageGetHeight(scaleImage.CGImage);
//            long totalFileMB = totalPixel / lPixelsPerMB;
//            NSLog(@"%ld",totalFileMB);
            
            //  得到图片data
            NSData *data = UIImageJPEGRepresentation(scaleImage, 1.0);
            //  图片名
            NSString *fileName = [dict objectForKey:@"name"];
            //  插入表单
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response: %@",responseObject);
        NSString *jsonString = responseObject[@"json"];
        NSData *jsonData = nil;
        if ([jsonString isKindOfClass:[NSString class]]) {
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        }
        NSDictionary *dic = nil;
        NSError *err;
        if (jsonData) {
            dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:&err];
        }
        
        if (dic && [dic[@"code"] integerValue] == 0) {// 请求成功
            NSDictionary *dataDict = dic[TuPu_Task_ID];
            NSMutableArray *sexArray = [NSMutableArray array];
            NSArray *fileList = dataDict[@"fileList"];
            for (NSDictionary *dict in fileList) {
                if ([dict[@"label"] intValue] == 0 && [dict[@"rate"] floatValue] > 0.9) {
                    [sexArray addObject:dict[@"name"]];
                }
            }
            if (sexArray.count) {
                if (failure) {
                    failure(nil, [sexArray copy]);
                }
            } else {
                [self uploadImages:imageArray orignal:orignal success:^(NSArray *urlArray) {
                    if (success) {
                        success([urlArray copy]);
                    }
                } failure:^(NSMutableArray<NSDictionary *> *dataArray) {
                    if (failure) {
                        failure(dataArray, nil);
                    }
                }];
            }
        } else {
            if (failure) {
                failure(nil, nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@",error.localizedDescription);
        if (failure) {
            failure(nil, nil);
        }
    }];
}

+ (void)uploadImages:(NSArray<NSDictionary *> *)images orignal:(BOOL)orignal success:(void (^)(NSArray *urlArray))success failure:(void (^)(NSMutableArray<NSDictionary *> *dataArray))failure {
    NSMutableArray *imagesDataArray = [NSMutableArray arrayWithArray:images];
    NSMutableArray *urlArray = [NSMutableArray array];
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(QiniuUploadHelper *) weakHelper = uploadHelper;
    
    __block void (^uploadImage)() = ^{
        NSDictionary *infoDict = imagesDataArray[currentIndex];
        NSString *url = infoDict[@"url"];
        if (url.length) {
            [urlArray addObject:url];
            weakHelper.pornFailureBlock();// 这边借用block,此block原来也是用于七牛云鉴黄的处理，
        }
        UIImage *image = infoDict[@"image"];
        NSData *imageData = nil;
        if (orignal) {
            imageData = UIImageJPEGRepresentation(image,1);
        } else {
            imageData = UIImageJPEGRepresentation(image,0.75);
        }
        if (imageData) {
            [NetworkTool uploadImage:imageData
                            progress:nil
                             success:weakHelper.singleSuccessBlock
                             failure:weakHelper.singleFailureBlock];
        }
    };
    
    weakHelper.pornFailureBlock = ^{
        currentIndex++;
        if (currentIndex == imagesDataArray.count) {
            // 全部上传完成
            if (urlArray.count == imagesDataArray.count) {
                if (success) {
                    success(urlArray);
                }
            } else {
                if (failure) {
                    failure(imagesDataArray);
                }
            }
        } else {
            uploadImage();
        }
    };
    
    weakHelper.singleFailureBlock = ^{
        weakHelper.pornFailureBlock();
        return;
    };
    
    weakHelper.singleSuccessBlock = ^(NSString *url) {
        [urlArray addObject:url];
        
        NSDictionary *infoDict = imagesDataArray[currentIndex];
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
        [muDict setValue:url forKey:@"url"];
        [imagesDataArray replaceObjectAtIndex:currentIndex withObject:muDict];
        
        weakHelper.pornFailureBlock();
    };
    
    uploadImage();
}

+ (void)pornVideoWithImages:(NSArray<NSDictionary *> *)imageArray success:(void (^)())success failure:(void (^)(NSArray *sexImageArray))failure {
    NSDate *nowDate = [NSDate date];
    NSNumber *timestamp = [NSNumber numberWithDouble:(nowDate.timeIntervalSince1970 * 1000)];
    NSString *randomStr = [NSString randomString];
    NSString *beSignStr = [NSString stringWithFormat:@"%@,%@,%@",TuPu_Secret_ID,timestamp,randomStr];
    
    HBRSAHandler *handler = [HBRSAHandler new];
    [handler importKeyWithType:KeyTypePrivate andkeyString:private_key_string];
    NSString *signedStr = [handler signString:beSignStr];
    
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    //muDict[@"image"]     = imageArray;
    muDict[@"nonce"]     = randomStr;
    muDict[@"signature"] = signedStr;
    muDict[@"timestamp"] = timestamp;
    
    NSString * const pornUrl = [NSString stringWithFormat:@"http://api.open.tuputech.com/v3/recognition/%@",TuPu_Secret_ID];
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.Post请求
    [manager POST:pornUrl parameters:muDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *dict in imageArray) {
            //  要上传的图片
            UIImage *image = [dict objectForKey:@"image"];
            //  压缩图片
            CGSize targetSize = CGSizeZero;
            if (image.size.width > image.size.height) {
                targetSize = CGSizeMake(256 / image.size.height * image.size.width, 256);
            } else {
                targetSize = CGSizeMake(256, 256 / image.size.width * image.size.height);
            }
            UIImage *scaleImage = [image imageCompressForSize:image targetSize:targetSize];
            
//            int  perMBBytes = 1024*1024;
//            CGImageRef cgimage = scaleImage.CGImage;
//            size_t bpp = CGImageGetBitsPerPixel(cgimage);
//            size_t bpc = CGImageGetBitsPerComponent(cgimage);
//            size_t bytes_per_pixel = bpp / bpc;
//            long lPixelsPerMB  = perMBBytes / bytes_per_pixel;
//            long totalPixel = CGImageGetWidth(scaleImage.CGImage) * CGImageGetHeight(scaleImage.CGImage);
//            long totalFileMB = totalPixel / lPixelsPerMB;
//            NSLog(@"%ld",totalFileMB);
            
            //  得到图片的data
            NSData *data = UIImageJPEGRepresentation(scaleImage, 1.0);
            //  图片名
            NSString *fileName = [dict objectForKey:@"name"];
            //  插入表单
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response: %@",responseObject);
        NSString *jsonString = responseObject[@"json"];
        NSData *jsonData = nil;
        if ([jsonString isKindOfClass:[NSString class]]) {
            jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        }
        NSDictionary *dic = nil;
        NSError *err;
        if (jsonData) {
            dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:NSJSONReadingMutableContainers
                                                    error:&err];
        }
        if (dic && [dic[@"code"] integerValue] == 0) {// 请求成功
            NSDictionary *dataDict = dic[TuPu_Task_ID];
            NSMutableArray *sexArray = [NSMutableArray array];
            NSArray *fileList = dataDict[@"fileList"];
            for (NSDictionary *dict in fileList) {
                if ([dict[@"label"] intValue] == 0 && [dict[@"rate"] floatValue] > 0.9) {
                    [sexArray addObject:dict[@"name"]];
                }
            }
            if (sexArray.count) {
                if (failure) {
                    failure([sexArray copy]);
                }
            } else {
                if (success) {
                    success();
                }
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@",error.localizedDescription);
        if (failure) {
            failure(nil);
        }
    }];
}

@end
