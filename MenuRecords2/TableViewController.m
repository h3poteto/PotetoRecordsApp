//
//  TableViewController.m
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    // メニューにeditを表示
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // DB準備
    LocalDBClient   *client = [[LocalDBClient alloc] init];
    _dbPath = client.dbPath;
    FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
    
    NSString *sql = @"SELECT * FROM menulogs WHERE parent_id = '-1' AND sync != '-1' ORDER BY datetime(date,'localtime') DESC;";
    [db open];
    _history = [db executeQuery:sql];
    _menuList = [NSMutableArray array];
    _idList = [NSMutableArray array];
    _dateList = [NSMutableArray array];
    _secondMenuList = [NSMutableArray array];
    
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
    
    while ([_history next]) {
        NSString *name = [_history stringForColumn:@"name"];
        int menu_id = [_history intForColumn:@"id"];
        NSString *date_sql = [[NSString alloc] initWithFormat:@"SELECT datetime(date,'localtime') FROM menulogs WHERE id = '%d';", menu_id];
        FMResultSet *date_log = [db executeQuery:date_sql];
        [date_log next];
        NSString *date = [date_log stringForColumnIndex:0];
        [_menuList addObject:name];
        
        // date型変換
        NSDate *datetime = [fmt_datetime dateFromString:date];
        [_dateList addObject:[fmt_date stringFromDate:datetime]];
        
        // 子メニューを取得
        NSString *second_menu_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE parent_id = '%d';", menu_id];
        FMResultSet *second_menu_result = [db executeQuery:second_menu_sql];
        
        if ([second_menu_result next]){
            NSString *second_menu = [second_menu_result stringForColumn:@"name"];
            if (second_menu){
                [_secondMenuList addObject:second_menu];
            }else{
                [_secondMenuList addObject:@""];
            }
        }else{
            [_secondMenuList addObject:@""];
        }
        
        // id
        [_idList addObject:[NSNumber numberWithInteger:menu_id]];
        
        // close
        [date_log close];
        [second_menu_result close];
    }
    [_history close];
    [db close];
    
    // table 更新
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _menuList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // database 準備
    int menu_index = [[_idList objectAtIndex:indexPath.row] intValue];
    // ShowMenuViewControllerに移動するため，menu_indexをNSUserDefaultsに格納
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d", menu_index] forKey:@"menuIndex"];
    
    
    // ShowMenuViewController移動
    [self performSegueWithIdentifier:@"selectRow" sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@, %@...",[_menuList objectAtIndex:indexPath.row],[_secondMenuList objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [_dateList objectAtIndex:indexPath.row];
    
    
    return cell;
}

//=====================================
// table view editのアクションを有効化
//=====================================
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

//======================================
// Deleteを押した際のアクション
//======================================
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int delete_target_id = [[_idList objectAtIndex:indexPath.row] intValue];
        
        // sqliteのsyncフラグ更新
        NSString *update_child_sql = [[NSString alloc] initWithFormat:@"UPDATE menulogs SET sync = -1 WHERE parent_id = '%d';", delete_target_id];
        NSString *update_parent_sql = [[NSString alloc] initWithFormat:@"UPDATE menulogs SET sync = -1 WHERE id = '%d';", delete_target_id];
        FMDatabase *db = [FMDatabase databaseWithPath:_dbPath];
        
        [db open];
        [db executeUpdate:update_child_sql];
        [db executeUpdate:update_parent_sql];
        [db close];
        
        // Delete the row from the data source
        [_menuList removeObjectAtIndex:indexPath.row];
        [_idList removeObjectAtIndex:indexPath.row];
        [_dateList removeObjectAtIndex:indexPath.row];
        [_secondMenuList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//====================================
//  Menuを同期
//====================================
- (IBAction)syncButton:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    FMDatabase  *db = [FMDatabase databaseWithPath:_dbPath];
    FMResultSet *still_sync;
    FMResultSet *still_sync_child;
    NSString    *parent_sql = @"SELECT id, name, color_tag, datetime(date,'localtime'), original_id FROM menulogs WHERE parent_id = '-1' AND     sync = 0";
    
    // datetime format
    NSDateFormatter *fmt_datetime = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [fmt_datetime setLocale:locale];
    [fmt_datetime setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [fmt_datetime setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    // WebAPIClientの呼び出し
    NSUserDefaults  *user_defaults = [NSUserDefaults standardUserDefaults];
    NSString        *email = [user_defaults valueForKeyPath:@"email"];
    NSString        *password = [user_defaults valueForKeyPath:@"password"];
    
    [[WebAPIClient sharedClient] setEmail:email password:password];
    
    // ローカルDB each
    [db open];
    still_sync = [db executeQuery:parent_sql];
    
    while ([still_sync next]) {
        NSString    *name = [still_sync stringForColumn:@"name"];
        int         parent_id = [still_sync intForColumn:@"id"];
        NSString    *color_tag = [still_sync stringForColumn:@"color_tag"];
        NSString     *datetime = [still_sync stringForColumnIndex:3];
        int         original_id = [still_sync intForColumn:@"original_id"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:color_tag forKey:@"menurecord[color_tag]"];
        [params setObject:datetime forKey:@"menurecord[date]"];
        [params setObject:[NSString stringWithFormat:@"%d", original_id] forKey:@"menurecord[original_id]"];
        NSString    *children_sql = [[NSString alloc] initWithFormat:@"SELECT name FROM menulogs WHERE parent_id = %d", parent_id];
        still_sync_child = [db executeQuery:children_sql];
        [params setObject:name forKey:@"menurecord[name][0]"];
        int     count = 1;
        while ( [still_sync_child next] ) {
            [params setObject:[still_sync_child stringForColumn:@"name"] forKey:[NSString stringWithFormat:@"menurecord[name][%d]",count]];
            count++;
        }
        [[WebAPIClient sharedClient] postParametersWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // sync = 1
            NSString    *update_sql = [[NSString alloc] initWithFormat:@"UPDATE menulogs SET sync=1 WHERE id=%d OR parent_id=%d", parent_id, parent_id];
            [db open];
            [db executeUpdate:update_sql];
            [db close];
        } failuer:^(int statusCode, NSString *errorString) {
            // sync = 0
        } target_file:@"menurecords.json" parameters:params];
    }
    
    [db close];
    
    
    // delete処理
    NSString    *delete_target_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE sync = -1"];
    FMResultSet *delete_target;
    
    [db open];
    delete_target = [db executeQuery:delete_target_sql];
    while ( [delete_target next] ){
        int     original_id = [delete_target intForColumn:@"original_id"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[NSString stringWithFormat:@"%d", original_id] forKey:@"original_id"];
        [[WebAPIClient sharedClient] postParametersWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString    *delete_sql = [[NSString alloc] initWithFormat:@"DELETE FROM menulogs WHERE original_id = %d", original_id];
            [db open];
            [db executeUpdate:delete_sql];
            [db close];
        } failuer:^(int statusCode, NSString *errorString) {
            // still sync = -1
        } target_file:@"menurecords/delete.json" parameters:params];
    }
    [db close];
    
    [SVProgressHUD dismiss];
}
@end
