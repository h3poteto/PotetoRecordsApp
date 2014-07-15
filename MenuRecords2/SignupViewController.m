//
//  SignupViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/07/11.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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
    
    CGRect          windowSize = [[UIScreen mainScreen] bounds];
    
    // name テキストフィールド
    CGRect  name_rect = CGRectMake(20, 100, 250, 30);
    self.nameField = [[UITextField alloc] initWithFrame:name_rect];
    self.nameField.center = CGPointMake(windowSize.size.width / 2.0, 100);
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.textAlignment = NSTextAlignmentLeft;
    self.nameField.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    self.nameField.placeholder = @"name";
    self.nameField.keyboardType = UIKeyboardTypeDefault;
    self.nameField.returnKeyType = UIReturnKeyNext;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.delegate = self;
    self.nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.nameField];
    
    // email テキストフィールド
    CGRect  email_rect = CGRectMake(20, 150, 250, 30);
    self.emailField = [[UITextField alloc] initWithFrame:email_rect];
    self.emailField.center = CGPointMake(windowSize.size.width / 2.0, 150);
    
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
    [self.view addSubview:self.emailField];
    
    // password テキストフィールド
    CGRect  password_rect = CGRectMake(20, 200, 250, 30);
    self.passwordField = [[UITextField alloc] initWithFrame:password_rect];
    self.passwordField.center = CGPointMake(windowSize.size.width / 2.0, 200);
    
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
    [self.view addSubview:self.passwordField];
    
    // submitボタン
    self.signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 270, 100, 30)];
    self.signUpButton.center = CGPointMake(windowSize.size.width / 2.0, 270);
    [self.signUpButton setTitle:@"登録" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.signUpButton addTarget:self action:@selector(SignupButtonSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpButton];

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

- (IBAction)SignupButtonSubmit:(id)sender
{
    NSString            *name = self.nameField.text;
    NSString            *email = self.emailField.text;
    NSString            *password = self.passwordField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [params setObject:name forKey:@"name"];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [[WebAPIClient sharedClient] postParametersWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"Created"];
    } failuer:^(int statusCode, NSString *errorString) {
        [SVProgressHUD showErrorWithStatus:@"Can not created"];
    } target_file:@"users.json" parameters:params];
}

@end
