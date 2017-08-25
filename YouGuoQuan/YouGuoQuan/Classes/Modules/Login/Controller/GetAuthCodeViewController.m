//
//  GetAuthCodeViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/12.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "GetAuthCodeViewController.h"
#import "InputAuthCodeViewController.h"

@interface GetAuthCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation GetAuthCodeViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self confirmViewController];
}

- (void)confirmViewController {
    self.title = @"获取验证码";
    
    self.navigationController.navigationBarHidden = NO;
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
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 36)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"+86";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = FontColor;
    label.frame = CGRectMake(10, 0, 36, 36);
    
    [leftView addSubview:label];
    
    _telephoneTextField.leftView = leftView;
    _telephoneTextField.leftViewMode = UITextFieldViewModeAlways;
    _telephoneTextField.layer.borderWidth = 1;
    _telephoneTextField.layer.cornerRadius = 5;
    _telephoneTextField.layer.borderColor = TextFieldBorderColor.CGColor;
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = nil;
    if (string.length) {
        newText = [textField.text stringByAppendingString:string];
    } else {
        newText = [textField.text substringToIndex:textField.text.length - 1];
    }
    
    self.getCodeBtn.enabled = [HelperUtil checkTelNumber:newText];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    InputAuthCodeViewController *inputVC = segue.destinationViewController;
    inputVC.telephoneNumber = _telephoneTextField.text;
}

@end