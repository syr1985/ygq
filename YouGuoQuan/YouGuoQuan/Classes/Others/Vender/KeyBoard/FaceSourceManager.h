//
//  FaceSourceManager.h
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceSubjectModel.h"

@class ChatToolBarItem;
@interface FaceSourceManager : NSObject

+ (NSArray *)loadFaceSource;

+ (NSArray<ChatToolBarItem *> *)loadToolBarItems;

@end