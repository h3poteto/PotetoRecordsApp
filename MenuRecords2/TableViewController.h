//
//  TableViewController.h
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>{
    NSString *db_path;
    FMResultSet *history;
    NSMutableArray *menu_list;
    NSMutableArray *id_list;
    NSMutableArray *date_list;
    NSMutableArray *second_menu_list;
}

@end
