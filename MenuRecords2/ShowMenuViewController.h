//
//  ShowMenuViewController.h
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/18.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#define TOP_SPAN    90
#define FIELD_SPAN  60

#import <UIKit/UIKit.h>
#import "LocalDBClient.h"

@interface ShowMenuViewController : UIViewController{
    NSString *_dbPath;
    UIScrollView *_scrollView;
}

@end
