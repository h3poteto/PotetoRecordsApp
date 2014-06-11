//
//  ShowFriendsMenuViewController.m
//  MenuRecords2
//
//  Created by akirafukushima on 2014/06/10.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "ShowFriendsMenuViewController.h"

@interface ShowFriendsMenuViewController ()

@end

@implementation ShowFriendsMenuViewController

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
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.bounces = NO;
    _scrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:_scrollView];
    [_scrollView flashScrollIndicators];
    
    // menu_idを受け取る
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    NSString        *menu_id = [ud valueForKey:@"menu_id"];
    NSString        *friend_id = [ud valueForKey:@"friend_id"];
    NSString        *url = [[NSString alloc] initWithFormat:@"friends/%@/show_menu.json", friend_id];
    
    NSDictionary    *params = @{@"menu_id" : menu_id};
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[WebAPIClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self showMenuView:(NSMutableArray *)responseObject];
        
        [SVProgressHUD dismiss];
    } failure:^(int statusCode, NSString *errorString) {
        if (statusCode == 401) {
            [self.tabBarController setSelectedIndex:0];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:@"Cannot login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } target_file:url parameters:params];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================
//  Menuを表示
//====================================
- (void)showMenuView:(NSMutableArray *)json
{
    //-----------------------------
    // 日付表示
    //-----------------------------
    
    // caption
    CGRect  date_caption_rect = CGRectMake(20, TOP_SPAN, 100, 30);
    UILabel *date_caption_label = [[UILabel alloc] initWithFrame:date_caption_rect];
    date_caption_label.textColor = [UIColor blackColor];
    date_caption_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    date_caption_label.textAlignment = NSTextAlignmentLeft;
    date_caption_label.numberOfLines = 1;
    date_caption_label.text = @"日付";
    [_scrollView addSubview:date_caption_label];
    
    
    // 日時
    // date型変換
    NSDictionary    *first_menu = [json objectAtIndex:0];
    NSString        *date_string = [first_menu objectForKey:@"created_at"];
    
    CGRect          date_rect = CGRectMake(100, TOP_SPAN, 200, 30);
    UILabel         *date_label = [[UILabel alloc] initWithFrame:date_rect];
    date_label.backgroundColor = [UIColor lightGrayColor];
    date_label.textColor = [UIColor blackColor];
    date_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    date_label.textAlignment = NSTextAlignmentCenter;
    date_label.numberOfLines = 1;
    date_label.text = date_string;
    
    [_scrollView addSubview:date_label];
    
    //---------------------------------
    //  カラータグの表示
    //---------------------------------
    // ラベル
    CGRect  color_tag_caption_rect = CGRectMake(20, TOP_SPAN + FIELD_SPAN, 100, 30);
    UILabel *color_tag_caption_label = [[UILabel alloc] initWithFrame:color_tag_caption_rect];
    color_tag_caption_label.textColor = [UIColor blackColor];
    color_tag_caption_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    color_tag_caption_label.textAlignment = NSTextAlignmentLeft;
    color_tag_caption_label.numberOfLines = 1;
    color_tag_caption_label.text = @"カラータグ";
    [_scrollView addSubview:color_tag_caption_label];
    
    // カラータグ
    NSString    *hex_color = [first_menu objectForKey:@"color_tag"];
    NSString    *red_hex = [hex_color substringWithRange:(NSRange){0,2}];
    NSString    *green_hex = [hex_color substringWithRange:(NSRange){2,2}];
    NSString    *blue_hex = [hex_color substringWithRange:(NSRange){4,2}];
    NSScanner   *red_scan = [NSScanner scannerWithString:red_hex];
    NSScanner   *green_scan = [NSScanner scannerWithString:green_hex];
    NSScanner   *blue_scan = [NSScanner scannerWithString:blue_hex];
    
    unsigned int    red_int;
    unsigned int    green_int;
    unsigned int    blue_int;
    [red_scan scanHexInt:&red_int];
    [green_scan scanHexInt:&green_int];
    [blue_scan scanHexInt:&blue_int];
    
    UIColor     *color = [[UIColor alloc] initWithRed:(CGFloat)(red_int / 255.0) green:(CGFloat)(green_int / 255.0) blue:(CGFloat)(blue_int / 255.0) alpha:1.0];
    
    CGRect      color_tag_rect = CGRectMake(100, TOP_SPAN + FIELD_SPAN, 200, 30);
    UILabel     *color_tag_label = [[UILabel alloc] initWithFrame:color_tag_rect];
    color_tag_label.backgroundColor = color;
    [_scrollView addSubview:color_tag_label];
    
    
    //---------------------------------
    // 親メニューの表示
    //---------------------------------
    
    // メニューcaption
    CGRect      menu_caption_rect = CGRectMake(20, TOP_SPAN + FIELD_SPAN * 2, 100, 30);
    UILabel     *menu_caption_label = [[UILabel alloc] initWithFrame:menu_caption_rect];
    menu_caption_label.textColor = [UIColor blackColor];
    menu_caption_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    menu_caption_label.textAlignment = NSTextAlignmentLeft;
    menu_caption_label.numberOfLines = 1;
    menu_caption_label.text = @"メニュー";
    [_scrollView addSubview:menu_caption_label];
    
    // メニュー表示
//    
//    CGRect      menu_rect = CGRectMake(100, TOP_SPAN + FIELD_SPAN * 2, 200, 30);
//    UILabel     *menu_label = [[UILabel alloc] initWithFrame:menu_rect];
//    menu_label.backgroundColor = [UIColor lightGrayColor];
//    menu_label.textColor = [UIColor blackColor];
//    menu_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
//    menu_label.textAlignment = NSTextAlignmentCenter;
//    menu_label.text = [first_menu objectForKey:@"name"];
//    [_scrollView addSubview:menu_label];
    
    //---------------------------------
    // 子メニューの表示
    //---------------------------------
    
    int     child_index = 2;
    for ( NSDictionary *menu in json ) {
        if (child_index * FIELD_SPAN + 250 > _scrollView.contentSize.height) {
            _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, child_index * FIELD_SPAN + 250);
        }
        CGRect  child_menu_rect = CGRectMake(100, child_index * FIELD_SPAN + TOP_SPAN, 200, 30);
        UILabel *child_menu_label = [[UILabel alloc] initWithFrame:child_menu_rect];
        child_menu_label.backgroundColor = [UIColor lightGrayColor];
        child_menu_label.textColor = [UIColor blackColor];
        child_menu_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
        child_menu_label.textAlignment = NSTextAlignmentCenter;
        child_menu_label.text = [menu objectForKey:@"name"];
        [_scrollView addSubview:child_menu_label];
        child_index++;
    }
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
