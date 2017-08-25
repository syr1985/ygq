//
//  NSString+AttributedText.m
//  YouGuoQuan
//
//  Created by YM on 2016/12/20.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NSString+AttributedText.h"

@implementation NSString (AttributedText)

+ (NSAttributedString *)attributedStringWithString:(NSString *)str font:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    if (font) {
        // 设置字体和设置字体的范围
        [attrStr addAttribute:NSFontAttributeName
                        value:font
                        range:range];
    }
    
    // 添加文字颜色
    //    [attrStr addAttribute:NSForegroundColorAttributeName
    //                    value:[UIColor whiteColor]
    //                    range:NSMakeRange(0,str.length - 1)];
    
    //        // 添加文字背景颜色
    //        [attrStr addAttribute:NSBackgroundColorAttributeName
    //                        value:[UIColor orangeColor]
    //                        range:NSMakeRange(17, 7)];
    //        // 添加下划线
    //        [attrStr addAttribute:NSUnderlineStyleAttributeName
    //                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
    //                        range:NSMakeRange(8, 7)];
    return attrStr;
}

+ (NSAttributedString *)attributedStringWithString:(NSString *)str color:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    // 添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:range];
    
    return attrStr;
}

@end
