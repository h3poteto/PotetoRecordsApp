//
//  FriendsTableViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/05/30.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "FriendsTableViewController.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // ログイン確認はDidAppearではなく同期ボタンを作成すればいいのでは！
    _friends = [NSMutableArray array];
    _ids = [NSMutableArray array];
    NSDictionary    *params = [[NSDictionary alloc] init];
    
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[WebAPIClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            for ( NSDictionary *json in responseObject ){
                // _friendsに突っ込む
                NSString    *email = [json objectForKey:@"name"];
                [_friends addObject:email];
                [_ids addObject:[json objectForKey:@"id"]];
            }
            [self.tableView reloadData];
        }else{
            _friends = nil;
        }
        [SVProgressHUD dismiss];
    } failure:^(int statusCode, NSString *errorString) {
        if (statusCode == 401) {
            [self.tabBarController setSelectedIndex:0];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:@"Cannot login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [SVProgressHUD dismiss];
    } target_file:@"friends.json"
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
    return _friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    if (_friends.count > 0) {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [_friends objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

//=======================================
//  friendsが選択されたとき
//=======================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int             friend_id = [[_ids objectAtIndex:indexPath.row] intValue];
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:[NSString stringWithFormat:@"%d", friend_id] forKey:@"friend_id"];
    
    // FriendsMenuTableViewに移動
    [self performSegueWithIdentifier:@"selectFriend" sender:self];
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
