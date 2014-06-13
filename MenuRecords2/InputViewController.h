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
#import "WebAPIClient.h"

@interface InputViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>{
    NSString        *_dbPath;
    UIActionSheet   *_basicSheet;
    UIActionSheet   *_colorSheet;
    UIScrollView    *_scrollView;
    NSInteger       _menuIndex;
    NSArray         *_textFieldArray;
    NSString        *_saveStr; //　一時保保管
    UIColor         *_saveColor; // 一時保管
    NSInteger       _tagColorbutton;
    int             _sync;
}
@property (strong, nonatomic) IBOutlet UIButton   *recordDate;
@property (strong, nonatomic) NSDate            *dateValue; // date_value設定値
@property (strong, nonatomic) IBOutlet UIButton   *addMenuButton;
@property (strong, nonatomic) IBOutlet UIButton   *submitButton;
@property (strong, nonatomic) IBOutlet UIButton *colorTagButton;


- (void)submit:(id)sender;
- (void)touchDate:(id)sender;
- (void)getSelectedTime;
- (void)dismissSet;
- (void)cancelSet;
- (void)buttonTupped:(id)sender;
- (void)touchColorTagButton:(id)sender;
- (void)colorSet;
- (void)colorCancelSet;
- (void)touchColor:(UIButton *)button;

@end
