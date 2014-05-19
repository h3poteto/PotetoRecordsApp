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
    
    //DB confirm
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    db_path = [dir stringByAppendingPathComponent:@"menu_records.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    
    NSString *sql = @"SELECT * FROM menulogs WHERE parent_id = '-1';";
    [db open];
    history = [db executeQuery:sql];
    menu_list = [NSMutableArray array];
    id_list = [NSMutableArray array];
    date_list = [NSMutableArray array];
    second_menu_list = [NSMutableArray array];
    
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
 
    while ([history next]) {
        NSString *name = [history stringForColumn:@"name"];
        int menu_id = [history intForColumn:@"id"];
        NSString *date_sql = [[NSString alloc] initWithFormat:@"SELECT datetime(date,'localtime') FROM menulogs WHERE id = '%d';", menu_id];
        FMResultSet *date_log = [db executeQuery:date_sql];
        [date_log next];
        NSString *date = [date_log stringForColumnIndex:0];
        [menu_list addObject:name];
        
        // date型変換
        NSDate *datetime = [fmt_datetime dateFromString:date];
        [date_list addObject:[fmt_date stringFromDate:datetime]];
        
        // 子メニューを取得
        NSString *second_menu_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE parent_id = '%d';", menu_id];
        FMResultSet *second_menu_result = [db executeQuery:second_menu_sql];
        [second_menu_result next];
        // 存在しなければwarningが出るけど気にしない，あとでpresent?確認を取って
        NSString *second_menu = [second_menu_result stringForColumn:@"name"];
        if (second_menu){
            [second_menu_list addObject:second_menu];
        }else{
            [second_menu_list addObject:@""];
        }
        
        // id
        [id_list addObject:[NSNumber numberWithInteger:menu_id]];
        
        // close
        [date_log close];
        [second_menu_result close];
    }
    [history close];
    [db close];
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
    return menu_list.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // database 準備
    int menu_index = [[id_list objectAtIndex:indexPath.row] intValue];
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
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@, %@...",[menu_list objectAtIndex:indexPath.row],[second_menu_list objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [date_list objectAtIndex:indexPath.row];
    
    // record削除アクション実装
    
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
        // dbを先に削除
        int delete_target_id = [[id_list objectAtIndex:indexPath.row] intValue];
        NSString *delete_child_sql = [[NSString alloc] initWithFormat:@"DELETE FROM menulogs WHERE parent_id = '%d';", delete_target_id];
        NSString *delete_parent_sql = [[NSString alloc] initWithFormat:@"DELETE FROM menulogs WHERE id = '%d';", delete_target_id];
        FMDatabase *db = [FMDatabase databaseWithPath:db_path];
        
        [db open];
        [db executeUpdate:delete_child_sql];
        [db executeUpdate:delete_parent_sql];
        [db close];
        
        // Delete the row from the data source
        [menu_list removeObjectAtIndex:indexPath.row];
        [id_list removeObjectAtIndex:indexPath.row];
        [date_list removeObjectAtIndex:indexPath.row];
        [second_menu_list removeObjectAtIndex:indexPath.row];
        
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

@end
