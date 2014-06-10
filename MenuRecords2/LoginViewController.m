//
//  LoginViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/29.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // key chainに保存されているならとってきて保持
    CGRect          windowSize = [[UIScreen mainScreen] bounds];
    NSUserDefaults  *user_defaults = [NSUserDefaults standardUserDefaults];
    NSString        *email = [user_defaults valueForKey:@"email"];
    NSString        *password = [user_defaults valueForKey:@"password"];
    
    // email テキストフィールド
    CGRect  email_rect = CGRectMake(20, 100, 250, 30);
    self.emailField = [[UITextField alloc] initWithFrame:email_rect];
    self.emailField.center = CGPointMake(windowSize.size.width / 2.0, 100);
    
    self.emailField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailField.textAlignment = NSTextAlignmentLeft;
    self.emailField.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    self.emailField.placeholder = @"mail address";
    self.emailField.keyboardType = UIKeyboardTypeDefault;
    self.emailField.returnKeyType = UIReturnKeyNext;
    self.emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.emailField.delegate = self;
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    if (email) {
        self.emailField.text = email;
    }
    [self.view addSubview:self.emailField];
    
    // password テキストフィールド
    CGRect  password_rect = CGRectMake(20, 180, 250, 30);
    self.passwordField = [[UITextField alloc] initWithFrame:password_rect];
    self.passwordField.center = CGPointMake(windowSize.size.width / 2.0, 150);
    
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.textAlignment = NSTextAlignmentLeft;
    self.passwordField.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    self.passwordField.placeholder = @"password";
    self.passwordField.keyboardType = UIKeyboardTypeDefault;
    self.passwordField.returnKeyType = UIReturnKeyNext;
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.delegate = self;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordField.secureTextEntry = YES;
    if (password) {
        self.passwordField.text = password;
    }
    [self.view addSubview:self.passwordField];
    
    // submitボタン
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 260, 100, 30)];
    self.loginButton.center = CGPointMake(windowSize.size.width / 2.0, 230);
    [self.loginButton setTitle:@"ログイン" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.loginButton addTarget:self action:@selector(LoginButtonSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginButtonSubmit:(id)sender {
    
    NSString    *email = self.emailField.text;
    NSString    *password = self.passwordField.text;
    NSDictionary    *params = [[NSDictionary alloc] init];
    
    [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
    [[WebAPIClient sharedClient] setEmail:email password:password];
    [[WebAPIClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
        [SVProgressHUD showSuccessWithStatus:@"Saved"];
    } failure:^(int statusCode, NSString *errorString) {
        [SVProgressHUD showErrorWithStatus:@"Cannot Login"];
    } target_file:@"friends.json"
     parameters:params];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
}
@end
