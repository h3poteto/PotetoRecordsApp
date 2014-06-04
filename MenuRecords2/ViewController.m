//
//  ViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/19.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults  *user_defaults = [NSUserDefaults standardUserDefaults];
    NSString        *email = [user_defaults valueForKeyPath:@"email"];
    NSString        *password = [user_defaults valueForKeyPath:@"password"];
    
    if (email && password) {
        [[WebAPIClient sharedClient] setEmail:email password:password];
        [[WebAPIClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        } failure:^(int statusCode, NSString *errorString) {
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
