//
//  TableViewController.h
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "FMDatabase.h"
#import "WebAPIClient.h"

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    NSString *_dbPath;
    FMResultSet *_history;
    NSMutableArray *_menuList;
    NSMutableArray *_idList;
    NSMutableArray *_dateList;
    NSMutableArray *_secondMenuList;
}
- (IBAction)syncButton:(id)sender;

@end
