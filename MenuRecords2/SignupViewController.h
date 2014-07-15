//
//  SignupViewController.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/07/11.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "WebAPIClient.h"

@interface SignupViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField  *emailField;
@property (strong, nonatomic) IBOutlet UITextField  *passwordField;
@property (strong, nonatomic) IBOutlet UITextField  *nameField;
@property (strong, nonatomic) IBOutlet UIButton     *signUpButton;

- (IBAction)SignupButtonSubmit:(id)sender;
@end
