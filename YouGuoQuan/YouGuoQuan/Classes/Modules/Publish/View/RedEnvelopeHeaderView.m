//
//  RedEnvelopeHeaderView.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/28.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "RedEnvelopeHeaderView.h"

@interface RedEnvelopeHeaderView () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) UILabel  *placeholder;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@end

@implementation RedEnvelopeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"说点什么吧，这段话会被用作标题哦~";
    placeholder.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    placeholder.textColor = GaryFontColor;
    placeholder.frame = CGRectMake(5, 5, _titleTextView.frame.size.width - 10, 21);
    placeholder.backgroundColor = [UIColor clearColor];
    [self.titleTextView addSubview:placeholder];
    _placeholder = placeholder;
}

#pragma mark - textView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self endEditing:YES];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if (textView.text.length > 0) {
        _placeholder.hidden = YES;
    }
    
    if (textView.text.length > 20) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _placeholder.hidden = NO;
    } else {
        _placeholder.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_setTitle) {
        _setTitle(textView.text);
    }
}

@end