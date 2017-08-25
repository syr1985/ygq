//
//  NewPasswordViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/12.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *theNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureResetButton;

@end

@implementation NewPasswordViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self confirmViewController];
}

- (void)confirmViewController {
    self.title = @"重置密码";
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.tintColor = FontColor;
    self.navigationController.navigationBar.barTintColor = NavBackgroundColor;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FontColor,NSForegroundColorAttributeName,nil]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回-黑"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popViewController)];
    leftItem.imageInsets = UIEdgeInsetsMake(0, -6, 0, 0);
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 36)];
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"新密码";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = FontColor;
    label1.frame = CGRectMake(10, 0, 60, 36);
    [leftView1 addSubview:label1];
    
    _theNewPasswordTextField.leftView = leftView1;
    _theNewPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _theNewPasswordTextField.layer.borderWidth = 1;
    _theNewPasswordTextField.layer.cornerRadius = 5;
    _theNewPasswordTextField.layer.borderColor = TextFieldBorderColor.CGColor;
    
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 36)];
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"确认密码";
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = FontColor;
    label2.frame = CGRectMake(10, 0, 60, 36);
    [leftView2 addSubview:label2];
    
    _confirmPasswordTextField.leftView = leftView2;
    _confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _confirmPasswordTextField.layer.borderWidth = 1;
    _confirmPasswordTextField.layer.cornerRadius = 5;
    _confirmPasswordTextField.layer.borderColor = TextFieldBorderColor.CGColor;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  调取重置密码接口
 */
- (IBAction)resetPasswordButtonClicked {
    __weak typeof(self) weakself = self;
    [NetworkTool resetPasswordWithPhone:_telephoneNumber Password:_theNewPasswordTextField.text Result:^{
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(HUD_SHOW_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    BOOL enable = [_theNewPasswordTextField.text isEqualToString:_confirmPasswordTextField.text] &&
    (_theNewPasswordTextField.text.length > 5 && _theNewPasswordTextField.text.length < 17);
    self.sureResetButton.enabled = enable;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = nil;
    if (string.length) {
        newText = [textField.text stringByAppendingString:string];
    } else {
        newText = [textField.text substringToIndex:textField.text.length - 1];
    }
    BOOL enable = NO;
    if ([textField isEqual:_theNewPasswordTextField]) {
        enable = [newText isEqualToString:_confirmPasswordTextField.text] && (newText.length > 5 && newText.length < 17);
    } else {
        enable = [newText isEqualToString:_theNewPasswordTextField.text] && (newText.length > 5 && newText.length < 17);
    }
    self.sureResetButton.enabled = enable;
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.sureResetButton.enabled = NO;
    return YES;
}

@end