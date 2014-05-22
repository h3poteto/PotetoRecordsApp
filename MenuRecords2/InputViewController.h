//
//  InputViewController.h
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//
#define TOP_SPAN    90
#define FIELD_SPAN  60
#define BOTTOM_SPAN 80
#define ACVIEW_PADDING  30
#define ACVIEW_HEIGHT   320
#define ACVIEW_TOP      70
#define COLOR_HEIGHT    30

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"

@interface InputViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>{
    NSString        *db_path;
    UIActionSheet   *basicSheet;
    UIActionSheet   *colorSheet;
    UIScrollView    *scrollView;
    NSInteger       menu_index;
    NSArray         *textField_array;
    NSString        *saveStr; //　一時保保管
    UIColor         *saveColor; // 一時保管
    NSInteger       tagColorbutton;
}
@property (weak, nonatomic) IBOutlet UIButton   *recordDate;
@property (strong, nonatomic) NSDate            *date_value; // date_value設定値
@property (weak, nonatomic) IBOutlet UIButton   *addMenuButton;
@property (weak, nonatomic) IBOutlet UIButton   *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *colorTagButton;


- (void)Submit:(id)sender;
- (void)touchDate:(id)sender;
- (void)getSelectedTime;
- (void)dismissSet;
- (void)cancelSet;
- (void)button_Tupped:(id)sender;
- (void)touchColorTagButton:(id)sender;
- (void)colorSet;
- (void)colorCancelSet;
- (void)touchColor:(UIButton *)button;

@end
