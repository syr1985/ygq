//
//  PersonalInfoViewController.m
//  YouGuoQuan
//
//  Created by YM on 2016/11/14.
//  Copyright © 2016年 NT. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "LocationViewController.h"
#import "CityLocation.h"
#import "AlertViewTool.h"
#import "UserDefaultsTool.h"
#import <Masonry.h>

@interface PersonalInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputUserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *selectCurrentCityTextField;
@property (weak, nonatomic) IBOutlet UIView *sexBackView;
@property (weak, nonatomic) IBOutlet UIView *cityBackView;
@property (weak, nonatomic) IBOutlet UIButton *registerOverButton;
@property (nonatomic,   copy) NSString *sex;
@property (nonatomic,   copy) NSString *city;
@end

@implementation PersonalInfoViewController

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self confirmViewController];
}

// 设置UI
- (void)confirmViewController {
    self.title = @"3/3创建个人资料";
    
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
    
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 8, 5, 0);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 36)];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"用户名";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = FontColor;
    [leftView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftView).with.insets(padding);
    }];
    
    _inputUserNameTextField.leftView = leftView;
    _inputUserNameTextField.leftViewMode = UITextFieldViewModeAlways;
    _inputUserNameTextField.layer.borderWidth = 1;
    _inputUserNameTextField.layer.cornerRadius = 5;
    _inputUserNameTextField.layer.borderColor = TextFieldBorderColor.CGColor;
    
    _sexBackView.layer.borderWidth = 1;
    _sexBackView.layer.cornerRadius = 5;
    _sexBackView.layer.borderColor = TextFieldBorderColor.CGColor;
    
    _cityBackView.layer.borderWidth = 1;
    _cityBackView.layer.cornerRadius = 5;
    _cityBackView.layer.borderColor = TextFieldBorderColor.CGColor;
    
    
    // 获取定位城市
    NSString *locationCity = [[CityLocation sharedInstance] getLocationCity];
    if (!locationCity) {
        __weak typeof(self) weakself = self;
        [CityLocation sharedInstance].locationSuccess = ^(NSString *city) {
            if (city) {
                weakself.city = city;
                weakself.selectCurrentCityTextField.text = city;
            }
        };
        [[CityLocation sharedInstance] startLocation];
    } else {
        self.city = locationCity;
        self.selectCurrentCityTextField.text = locationCity;
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

// 选择当前城市
- (IBAction)selectCurrentCity {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    LocationViewController *locationVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    locationVC.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakself = self;
    locationVC.cityBlock = ^(NSString *city) {
        if (city) {
            weakself.city = city;
            weakself.selectCurrentCityTextField.text = city;
            
            if (weakself.sex && weakself.inputUserNameTextField.text.length) {
                weakself.registerOverButton.enabled = YES;
            }
        }
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

// 勾选性别
- (IBAction)selectSex:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    
    sender.selected = YES;
    _sex = sender.tag == 1 ? @"男" : @"女";
    
    UIView *contentView = sender.superview;
    UIButton *btn = [contentView viewWithTag:(sender.tag == 1 ? 2 : 1)];
    btn.selected = NO;
    
    if (_inputUserNameTextField.text.length && _selectCurrentCityTextField.text.length) {
        _registerOverButton.enabled = YES;
    }
}

// 调注册接口
- (IBAction)registerButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (![HelperUtil checkUserName:_inputUserNameTextField.text]) {
        [SVProgressHUD showInfoWithStatus:@"昵称包含非法字符"];
        return;
    }
    
    [UserDefaultsTool registerWithData:@{@"phone"    : _telephoneNumber,
                                         @"password" : _password,
                                         @"name"     : _inputUserNameTextField.text,
                                         @"sex"      : _sex,
                                         @"city"     : _city}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_sex && _selectCurrentCityTextField.text.length) {
        _registerOverButton.enabled = YES;
    }
}

@end
