//
//  LocationCell.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/7.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)setCities:(NSArray *)cities {
    _cities = cities;
    self.backgroundColor = BackgroundColor;
    
    NSUInteger row = ceil(cities.count / 3.0);
    NSUInteger col = 3;
    CGFloat marginX = 20;
    CGFloat marginY = 12;
    CGFloat btnW = (WIDTH - marginX * (col + 1)) / col;
    CGFloat btnH = 30;
    
    for (NSUInteger i = 0; i < row; i++) {
        CGFloat btnY = btnH * i + marginY * (i + 1);
        for (NSUInteger j = 0; j <  col; j++) {
            CGFloat btnX = btnW * j + marginX * (j + 1);
            NSUInteger index = i * col + j;
            if (index < cities.count) {
                NSString *city = cities[index];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                btn.layer.cornerRadius = 4;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                [btn setTitle:city forState:UIControlStateNormal];
                [btn setTitleColor:FontColor forState:UIControlStateNormal];
                [btn setBackgroundColor:[UIColor whiteColor]];
                [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
    }
}

- (void)buttonClicked:(UIButton *)button {
    if (self.selectedCityBlock) {
        self.selectedCityBlock(button.titleLabel.text);
    }
    if ([button.titleLabel.text isEqualToString:@"重新定位"]) {
        [button setTitle:@"正在定位..." forState:UIControlStateNormal];
    }
}

@end
