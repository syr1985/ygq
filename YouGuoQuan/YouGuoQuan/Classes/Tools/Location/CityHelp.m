//
//  CityHelp.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/8.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "CityHelp.h"

@implementation CityHelp

+ (void)updateCitiesForLocation:(NSString *)city {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //取得目标文件路径
    NSString *citiesDocPath = [docPath stringByAppendingPathComponent:@"YGQ_CITIES.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    //如果目标文件不存在说明是App第一次运行,需要将相关可修改数据文件拷贝至目标路径.
    if (![fm fileExistsAtPath:citiesDocPath]) {
        NSError *error = nil;
        //取得源文件路径
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        if (![fm copyItemAtPath:srcPath toPath:citiesDocPath error:&error]) {
            
        }
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:citiesDocPath];
    if (![city isEqualToString:@"重新定位"]) {
        NSArray *lastUseCities = [dictionary objectForKey:@"最近"];
        NSMutableArray *muArray = [NSMutableArray arrayWithArray:lastUseCities];
        if (![lastUseCities containsObject:city]) {
            [muArray addObject:city];
            [dictionary setValue:muArray forKey:@"最近"];
        }
    }
    
    [dictionary setValue:@[city] forKey:@"定位"];
    [dictionary writeToFile:citiesDocPath atomically:YES];
}

+ (void)updateCitiesForSelection:(NSString *)city {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //取得目标文件路径
    NSString *citiesDocPath = [docPath stringByAppendingPathComponent:@"YGQ_CITIES.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    //如果目标文件不存在说明是App第一次运行,需要将相关可修改数据文件拷贝至目标路径.
    if (![fm fileExistsAtPath:citiesDocPath]) {
        NSError *error = nil;
        //取得源文件路径
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"];
        if (![fm copyItemAtPath:srcPath toPath:citiesDocPath error:&error]) {
            
        }
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:citiesDocPath];
    NSArray *lastUseCities = [dictionary objectForKey:@"最近"];
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:lastUseCities];
    if (![lastUseCities containsObject:city]) {
        [muArray addObject:city];
        [dictionary setValue:muArray forKey:@"最近"];
        [dictionary writeToFile:citiesDocPath atomically:YES];
    }
}

@end