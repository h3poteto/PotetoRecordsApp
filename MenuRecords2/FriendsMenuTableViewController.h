//
//  FriendsMenuTableViewController.h
//  MenuRecords2
//
//  Created by akirafukushima on 2014/06/05.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "WebAPIClient.h"

@interface FriendsMenuTableViewController : UITableViewController
{
    NSMutableArray  *_jsonMenu;
    NSMutableArray  *_firstMenu;
}

@end
