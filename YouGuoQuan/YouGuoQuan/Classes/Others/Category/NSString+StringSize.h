//
//  NSString+StringSize.h
//  YouGuoQuan
//
//  Created by YM on 2016/12/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)

+ (CGFloat)heightWithString:(NSString *)str maxSize:(CGSize)maxSize strFont:(UIFont *)font;

+ (CGFloat)widthWithString:(NSString *)str maxSize:(CGSize)maxSize strFont:(UIFont *)font;

@end
