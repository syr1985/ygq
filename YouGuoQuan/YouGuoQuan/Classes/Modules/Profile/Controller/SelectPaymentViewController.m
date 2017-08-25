//
//  SelectPaymentViewController.m
//  YouGuoQuan
//
//  Created by YM on 2017/7/14.
//  Copyright © 2017年 NT. All rights reserved.
//

#import "SelectPaymentViewController.h"

@interface SelectPaymentViewController ()

@end

@implementation SelectPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapZhifubaoAction:(id)sender {
    if (self.selectPaymentBlock) {
        self.selectPaymentBlock(@"zfb");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapWeixinAction:(id)sender {
    if (self.selectPaymentBlock) {
        self.selectPaymentBlock(@"wx");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapCancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
