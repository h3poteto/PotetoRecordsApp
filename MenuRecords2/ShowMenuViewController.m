//
//  ShowMenuViewController.m
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/18.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "ShowMenuViewController.h"

@interface ShowMenuViewController ()

@end

@implementation ShowMenuViewController

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
    
    // prepare scroll view
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    
    scrollView.bounces = NO;
    scrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:scrollView];
    [scrollView flashScrollIndicators];

    // database準備
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    db_path = [dir stringByAppendingPathComponent:@"menu_records.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    
    // datetime関連準備
    // datetime用format
    NSDateFormatter *fmt_datetime = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [fmt_datetime setLocale:locale];
    [fmt_datetime setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [fmt_datetime setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    // date用format
    NSDateFormatter *fmt_date = [[NSDateFormatter alloc] init];
    [fmt_date setLocale:locale];
    [fmt_date setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [fmt_date setDateFormat:@"yyyy/MM/dd"];
    
    
    // menu_indexを受け取る
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int menu_index = [[ud valueForKey:@"menuIndex"] intValue];
    
    // db操作開始
    
    [db open];
    
    //-----------------------------
    // 日付表示
    //-----------------------------
    
    // caption
    CGRect date_caption_rect = CGRectMake(20, 90, 100, 30);
    UILabel *date_caption_label = [[UILabel alloc] initWithFrame:date_caption_rect];
    date_caption_label.textColor = [UIColor blackColor];
    date_caption_label.font = [UIFont fontWithName:@"Helvetica" size:13];
    date_caption_label.textAlignment = NSTextAlignmentLeft;
    date_caption_label.numberOfLines = 1;
    date_caption_label.text = @"日付";
    [scrollView addSubview:date_caption_label];
    
    
    // 日時
    NSString *date_sql = [[NSString alloc] initWithFormat:@"SELECT datetime(date,'localtime') FROM menulogs WHERE id = '%d';", menu_index];
    FMResultSet *date_log = [db executeQuery:date_sql];
    [date_log next];
    NSString *date = [date_log stringForColumnIndex:0];
    // date型変換
    NSDate *datetime = [fmt_datetime dateFromString:date];
    
    CGRect date_rect = CGRectMake(100, 90, 200, 30);
    UILabel *date_label = [[UILabel alloc] initWithFrame:date_rect];
    date_label.backgroundColor = [UIColor lightGrayColor];
    date_label.textColor = [UIColor blackColor];
    date_label.font = [UIFont fontWithName:@"Helvetica" size:14];
    date_label.textAlignment = NSTextAlignmentCenter;
    date_label.numberOfLines = 1;
    date_label.text = [fmt_date stringFromDate:datetime];
    
    [scrollView addSubview:date_label];
    
    
    
    //---------------------------------
    // 親メニューの表示
    //---------------------------------
    
    // メニューcaption
    CGRect menu_caption_rect = CGRectMake(20, 150, 100, 30);
    UILabel *menu_caption_label = [[UILabel alloc] initWithFrame:menu_caption_rect];
    menu_caption_label.textColor = [UIColor blackColor];
    menu_caption_label.font = [UIFont fontWithName:@"Helvetica" size:13];
    menu_caption_label.textAlignment = NSTextAlignmentLeft;
    menu_caption_label.numberOfLines = 1;
    menu_caption_label.text = @"メニュー";
    [scrollView addSubview:menu_caption_label];
    
    // メニュー表示
    NSString *parent_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE id = '%d';", menu_index];
    FMResultSet *parent = [db executeQuery:parent_sql];
    [parent next];
    
    CGRect menu_rect = CGRectMake(100, 150, 200, 30);
    UILabel *menu_label = [[UILabel alloc] initWithFrame:menu_rect];
    menu_label.backgroundColor = [UIColor lightGrayColor];
    menu_label.textColor = [UIColor blackColor];
    menu_label.font = [UIFont fontWithName:@"Helvetica" size:14];
    menu_label.textAlignment = NSTextAlignmentCenter;
    menu_label.text = [parent stringForColumn:@"name"];
    [scrollView addSubview:menu_label];
    
    //---------------------------------
    // 子メニューの表示
    //---------------------------------
    NSString *children_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE parent_id = '%d';", menu_index];
    FMResultSet *children = [db executeQuery:children_sql];
    
    int child_index = 1;
    while ([children next]) {
        if (child_index * 60 + 250 > scrollView.contentSize.height) {
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, child_index * 60 + 250);
        }
        CGRect child_menu_rect = CGRectMake(100, child_index * 60 + 150, 200, 30);
        UILabel *child_menu_label = [[UILabel alloc] initWithFrame:child_menu_rect];
        child_menu_label.backgroundColor = [UIColor lightGrayColor];
        child_menu_label.textColor = [UIColor blackColor];
        child_menu_label.font = [UIFont fontWithName:@"Helvetica" size:14];
        child_menu_label.textAlignment = NSTextAlignmentCenter;
        child_menu_label.text = [children stringForColumn:@"name"];
        [scrollView addSubview:child_menu_label];
        child_index++;
    }
    [db close];

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

@end
