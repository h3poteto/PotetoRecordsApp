//
//  InputViewController.h
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface InputViewController : UIViewController <UITextFieldDelegate>{
    NSString *db_path;
    UIActionSheet *basicSheet;
    UIScrollView *scrollView;
    NSInteger menu_index;
    NSArray *textField_array;
}
@property (strong, nonatomic) IBOutlet UIButton *recordDate;
@property (strong, nonatomic) NSDate *date_value;
@property (strong, nonatomic) IBOutlet UIButton *addMenuButton;
@property (strong, nonatomic) IBOutlet UIButton *submitButton; // 要create
- (void)Submit:(id)sender;  // actionに変更し動的呼び出し
- (void)touchDate:(id)sender;
- (void)getSelectedTime;
- (void)dismissSet;
- (void)cancelSet;
- (void)button_Tupped:(id)sender;



@end
