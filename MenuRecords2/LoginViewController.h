//
//  LoginViewController.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/29.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "WebAPIClient.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField  *emailField;
@property (strong, nonatomic) IBOutlet UITextField  *passwordField;
@property (strong, nonatomic) IBOutlet UIButton     *loginButton;

- (IBAction)LoginButtonSubmit:(id)sender;

@end
