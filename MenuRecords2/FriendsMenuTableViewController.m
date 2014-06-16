//
//  FriendsMenuTableViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/06/05.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "FriendsMenuTableViewController.h"

@interface FriendsMenuTableViewController ()

@end

@implementation FriendsMenuTableViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _jsonMenu = [NSMutableArray array];
    _firstMenu = [NSMutableArray array];
    
    // friend_idを受け取る
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    int             friend_id = [[ud valueForKey:@"friend_id"] intValue];
    NSString        *target_url = [NSString stringWithFormat:@"%@/%d.json",@"friends",friend_id];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    
    NSDictionary    *params = [[NSDictionary alloc] init];
    [[WebAPIClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 配列に突っ込む
        _jsonMenu = responseObject;
        for ( NSDictionary *json in responseObject) {
            [_firstMenu addObject:[json objectForKey:@"name"]];
        }
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(int statusCode, NSString *errorString) {
        if (statusCode == 401) {
            [self.tabBarController setSelectedIndex:0];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:@"Cannot login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } target_file:target_url
     parameters:params];
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
    return _firstMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    if (_firstMenu.count > 0) {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [_firstMenu objectAtIndex:indexPath.row]];
        NSDictionary    *date_json = [_jsonMenu objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@", [date_json objectForKey:@"date"]];
    }
    
    return cell;
}

//=======================================
//  menuが選択されたとき
//=======================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary    *menu_json = [_jsonMenu objectAtIndex:indexPath.row];
    int             menu_id = [[menu_json objectForKey:@"id"] intValue];
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d", menu_id] forKey:@"menu_id"];
    
    [self performSegueWithIdentifier:@"selectMenu" sender:self];
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
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
