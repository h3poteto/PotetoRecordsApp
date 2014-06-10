//
//  ShowFriendsMenuViewController.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/06/10.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#define TOP_SPAN    90
#define FIELD_SPAN  60

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "WebAPIClient.h"

@interface ShowFriendsMenuViewController : UIViewController
{
    UIScrollView    *_scrollView;
}

- (void)showMenuView:(NSMutableArray *)json;

@end
