//
//  InputViewController.m
//  MenuRecords
//
//  Created by akirafukushima on 2014/05/13.
//  Copyright (c) 2014年 AkiraFukushima. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController{

}

@synthesize recordDate, dateValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================
// load function
//==============================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // DB準備
    LocalDBClient   *client = [[LocalDBClient alloc] init];
    _dbPath = client.dbPath;
    
    
    // prepare scroll view
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    
    _scrollView.bounces = NO;
    _scrollView.contentSize = self.view.bounds.size;
    [self.view addSubview:_scrollView];
    [_scrollView flashScrollIndicators];
    
    
    // キーボード表示時にscrollViewを動かすためにイベント登録
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
    
    // キーボード外のイベント:singleTapイベント登録
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    self.singleTap.delegate = self;
    self.singleTap.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:self.singleTap];
   _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
    // 日付関連
    _saveStr = @"";

    dateValue = [NSDate date];
    NSDateFormatter     *fmt = [[NSDateFormatter alloc] init];
    NSLocale    *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [fmt setLocale:locale];
    [fmt setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [fmt setDateFormat:@"yyyy/MM/dd"];
    NSString    *string_date = [fmt stringFromDate:dateValue];
    
    
    // 日付ラベル描画
    CGRect  date_label_rect = CGRectMake(20, TOP_SPAN, 100, 30);
    UILabel     *date_label = [[UILabel alloc] initWithFrame:date_label_rect];
    date_label.textColor = [UIColor blackColor];
    date_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    date_label.textAlignment = NSTextAlignmentLeft;
    date_label.numberOfLines = 1;
    date_label.text = @"日付";
    [_scrollView addSubview:date_label];
    
    // 日付ボタン描画
    self.recordDate = [[UIButton alloc] initWithFrame:CGRectMake(100, TOP_SPAN, 200, 30)];
    [self.recordDate setTitle:string_date forState:UIControlStateNormal];
    [self.recordDate setFont:[UIFont fontWithName:@"HiraKakuProN-W3" size:14]];
    [self.recordDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.recordDate addTarget:self action:@selector(touchDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.recordDate setBackgroundColor:[UIColor lightGrayColor]];
    [_scrollView addSubview:self.recordDate];
    
    // カラータグ
    // カラータグラベル描画
    CGRect      color_label_rect = CGRectMake(20, TOP_SPAN + FIELD_SPAN, 100, 30);
    UILabel     *color_tag_label = [[UILabel alloc] initWithFrame:color_label_rect];
    color_tag_label.textColor = [UIColor blackColor];
    color_tag_label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    color_tag_label.textAlignment = NSTextAlignmentLeft;
    color_tag_label.text = @"カラータグ";
    [_scrollView addSubview:color_tag_label];
    
    //カラータグボタン描画
    self.colorTagButton = [[UIButton alloc] initWithFrame:CGRectMake(150, TOP_SPAN + FIELD_SPAN, 100, 30)];
    [self.colorTagButton setBackgroundColor:[UIColor blueColor]];
    [self.colorTagButton addTarget:self action:@selector(touchColorTagButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.colorTagButton];
    
    _saveColor = self.colorTagButton.backgroundColor;
    _tagColorbutton = 10;
    
    // 初期状態のメニューtextField生成
    CGRect          rect = CGRectMake(100, TOP_SPAN + FIELD_SPAN * 2, 200, 30);
    UITextField     *customTextField = [[UITextField alloc] initWithFrame:rect];
    
    customTextField.borderStyle = UITextBorderStyleRoundedRect;
    customTextField.textAlignment = NSTextAlignmentLeft;
    customTextField.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    customTextField.placeholder = @"例：ブリの照り焼き";
    customTextField.keyboardType = UIKeyboardTypeDefault;
    customTextField.returnKeyType = UIReturnKeyNext;
    customTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    customTextField.delegate = self;
    [_scrollView addSubview:customTextField];
    
    _textFieldArray = [NSArray arrayWithObjects:customTextField, nil];
    
    // メニューtextFieldのlabel生成
    CGRect  label_rect = CGRectMake(20, TOP_SPAN + FIELD_SPAN * 2, 100, 30);
    UILabel     *label = [[UILabel alloc] initWithFrame:label_rect];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 1;
    label.text = @"メニュー";
    [_scrollView addSubview:label];
    
    // 初期状態のメニューtextFieldの追加ボタン生成
    self.addMenuButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    CGRect      windowSize = [[UIScreen mainScreen] bounds];
    self.addMenuButton.center = CGPointMake(windowSize.size.width / 2.0, 285);
    [self.addMenuButton addTarget:self action:@selector(buttonTupped:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.addMenuButton];
    
    // メニューtextFieldの総数
    _menuIndex = 1;
    
    // submitボタン
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(400, 100, 100, 30)];
    self.submitButton.center = CGPointMake(windowSize.size.width / 2.0, windowSize.size.height - BOTTOM_SPAN);
    [self.submitButton setTitle:@"登録" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.submitButton];
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    return YES;
}


//========================================
//  キーボードが表示されたときに呼び出される
//========================================
- (void)keyboardWillShow:(NSNotification *)notification
{
    // scrollViewで位置調節
    NSDictionary    *userInfo;
    userInfo = [notification userInfo];
    
    CGRect  keyboardFrameEnd = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect  screenBounds = [[UIScreen mainScreen] bounds];
    float   screenHeight = screenBounds.size.height;
    if((_activeField.frame.origin.y + _activeField.frame.size.height)>(screenHeight - keyboardFrameEnd.size.height - 30)){
        [UIView animateWithDuration:0.3
                         animations:^{
                             _scrollView.frame = CGRectMake(0, screenHeight - _activeField.frame.origin.y - _activeField.frame.size.height - keyboardFrameEnd.size.height - 20, _scrollView.frame.size.width,_scrollView.frame.size.height);
                         }];
    }
    
}

//========================================
//  キーボードが隠れたときに呼び出される
//========================================
- (void)keyboardWillHide:(NSNotification *)notification
{
    // 位置調節解除
    [UIView animateWithDuration:0.2
                     animations:^{_scrollView.frame = CGRectMake(0, 0, _scrollView.frame.size.width,_scrollView.frame.size.height);
                     }];
    _activeField = nil;
    return;
    
}

//========================================
//  タップイベント時にキーボードを隠す
//========================================
-(void)onSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.navigationController.view endEditing:YES];
}



//========================================
//  return が押されたときにキーボードを隠す
//  textField : Editしていたtextfield
//========================================
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.navigationController.view endEditing:YES];
    return YES;
}


//=====================================
//  登録ボタンが押された際のイベント
//=====================================
- (void)submit:(id)sender {
    NSInteger parent_id = -1;
    
    NSDateFormatter     *fmt = [[NSDateFormatter alloc] init];
    NSLocale            *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [fmt setLocale:locale];
    [fmt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    [fmt setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [fmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString    *string_date = [fmt stringFromDate:dateValue];
    
    FMDatabase  *db = [FMDatabase databaseWithPath:_dbPath];
    
    // カラータグ
    CGFloat tag_red;
    CGFloat tag_green;
    CGFloat tag_blue;
    CGFloat tag_alpha;
    [self.colorTagButton.backgroundColor getRed:&tag_red green:&tag_green blue:&tag_blue alpha:&tag_alpha];
    NSString *string_hex = [NSString stringWithFormat:@"%.2X%.2X%.2X", (int)(tag_red * 255), (int)(tag_green * 255), (int)(tag_blue * 255)];
    
    // sync
    _sync = 0;
    
    // original_id
    int     original_id;
    FMResultSet *check_result;
    
    // 存在チェック
    [db open];
    do{
        original_id = arc4random();
        NSString    *original_check_sql = [[NSString alloc] initWithFormat:@"SELECT * FROM menulogs WHERE original_id = %d", original_id];
        check_result = [db executeQuery:original_check_sql];
    }while ( [check_result next] );
    [db close];
    
    // ローカルDBに保存
    [db open];

    //index
    int     index = 0;
    for ( UITextField *textField in _textFieldArray ){
        NSString *insert_sql = [[NSString alloc] initWithFormat: @"INSERT INTO menulogs (parent_id, name, color_tag, original_id, date, sync) VALUES ('%ld','%@', '%@', '%d',julianday('%@'),'%d');", (long)parent_id, textField.text, string_hex, original_id, string_date, _sync];
        [db executeUpdate:insert_sql];
        if (index == 0) {
            parent_id = (NSInteger)[db lastInsertRowId];
        }
        index++;
    }
    [db close];
    
    // 戻る
    [self.navigationController popViewControllerAnimated:YES];
}


//=============================================
//  日時のボタンが押された際に，DatePickerを立ち上げる
//=============================================
- (void)touchDate:(id)sender {
    _saveStr = recordDate.currentTitle;
    
    // UIActionView setting
    _basicSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:nil];
    [_basicSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    // UIDatePicker
    CGRect          pickerFrame = CGRectMake(0, 44, 0, 0);
    UIDatePicker    *viewDatePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [viewDatePicker setDatePickerMode:UIDatePickerModeDate];
    
    NSDateFormatter     *inputDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale            *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [inputDateFormatter setLocale:locale];
    [inputDateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString    *inputDateString = _saveStr;
    NSDate      *inputDate = [inputDateFormatter dateFromString:inputDateString];
    [viewDatePicker setDate:inputDate];
    
    // UIDatePicker の値が変化した際
    [viewDatePicker addTarget:self action:@selector(getSelectedTime) forControlEvents:UIControlEventValueChanged];
    
    // UIDatePicker をActionViewに埋め込む
    [_basicSheet addSubview:viewDatePicker];
    
    // UIActionView はモーダルなので，抜け出しボタンを追加
    UIToolbar   *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _basicSheet.bounds.size.width, 44)];
    [controlToolBar setBarStyle:UIBarStyleBlack];
    [controlToolBar sizeToFit];
    
    UIBarButtonItem     *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem     *setButton_1 = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSet)];
    UIBarButtonItem     *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:spacer, setButton_1, cancelButton, nil] animated:NO];

    [_basicSheet addSubview:controlToolBar];
    
    // show UIActionView
    [_basicSheet showInView:self.view];
    [_basicSheet setBounds:CGRectMake(0, 0, 320, 520)];
}

//=======================================
//  選択された日時でdata_valueを上書き
//=======================================
- (void)getSelectedTime{
    NSArray     *listOfView = [_basicSheet subviews];
    for (UIView *subView in listOfView){
        if ([subView isKindOfClass:[UIDatePicker class]]){
            dateValue = [(UIDatePicker *)subView date];
        }
    }
    
    NSDateFormatter     *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy/MM/dd"];
    [self.recordDate setTitle:[fmt stringFromDate:dateValue] forState:UIControlStateNormal];
}

//==============================================
//  選択された日時を設定したので，ActionViewを閉じる
//==============================================
- (void)dismissSet{
    [_basicSheet dismissWithClickedButtonIndex:0 animated:YES];
}
//=========================================
// キャンセルされた際に，日時設定をもとに戻す
//=========================================
- (void)cancelSet{
    NSDateFormatter     *inputDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale            *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    [inputDateFormatter setLocale:locale];
    [inputDateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [inputDateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString    *inputDateStr = _saveStr;
    NSDate      *inputDate = [inputDateFormatter dateFromString:inputDateStr];
    dateValue = inputDate;
    
    [self.recordDate setTitle:_saveStr forState:UIControlStateNormal];
    [_basicSheet dismissWithClickedButtonIndex:0 animated:YES];
}

//======================================
//  カラータグボタンが押された際の動作
//======================================
- (void)touchColorTagButton:(id)sender {
    // UIActionView setting
    _colorSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:nil];
    [_colorSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    // set delegate
    _colorSheet.delegate = self;
    
    // カラーを定義
    UIColor     *color_array[2][5] = {
        {[UIColor blueColor], [UIColor orangeColor], [UIColor blackColor], [UIColor greenColor],[UIColor redColor]},
        {[UIColor cyanColor], [UIColor magentaColor], [UIColor whiteColor], [UIColor yellowColor], [UIColor brownColor]}};
    
    // 各種カラーボタン設定
    double  color_array_col_size = sizeof(color_array[0]) / sizeof(color_array[0][0]);
    double  color_array_row_size = sizeof(color_array) / sizeof(color_array[0]);
    int     divide_width = ([[UIScreen mainScreen] bounds].size.width - ACVIEW_PADDING * 2 ) / color_array_col_size ;
    int     divide_width_padding = divide_width * 0.1;
    
    for (int row = 0; row < color_array_row_size; row++) {
        for (int col = 0; col < color_array_col_size; col++) {
            CGRect  button_rect = CGRectMake(ACVIEW_PADDING + divide_width * col + divide_width_padding, ACVIEW_TOP + row * 2 * COLOR_HEIGHT, divide_width * 0.8, COLOR_HEIGHT);
            UIButton    *button = [[UIButton alloc] initWithFrame:button_rect];
            [[button layer] setCornerRadius: 5];
            [button setClipsToBounds:YES];
            [button setBackgroundColor:color_array[row][col]];
            [button addTarget:self action:@selector(touchColor:) forControlEvents:UIControlEventTouchUpInside];
            
            // 枠線表示
            if (_saveColor == color_array[row][col]) {
                [[button layer] setBorderColor:[[UIColor cyanColor] CGColor]];
                [[button layer] setBorderWidth:2.0];
                button.tag = _tagColorbutton;
            }
            
            [_colorSheet addSubview:button];
        }
    }
    
    
    // 設定ボタン
    UIToolbar   *colorToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _colorSheet.bounds.size.width, 44)];
    [colorToolBar setBarStyle:UIBarStyleBlack];
    [colorToolBar sizeToFit];
    
    UIBarButtonItem     *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem     *colorSetButton = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStyleDone target:self action:@selector(colorSet)];
    UIBarButtonItem     *colorCancelButton = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(colorCancelSet)];
    [colorToolBar setItems:[NSArray arrayWithObjects:spacer, colorSetButton, colorCancelButton, nil]];
    
    [_colorSheet addSubview:colorToolBar];

    
    [_colorSheet showInView:self.view];
    [_colorSheet setBounds:CGRectMake(0, 0, 320, 320)];
}

- (void)touchColor:(UIButton *)button{
    UIColor *select_color = button.backgroundColor;
    
    // 他ボタンの選択解除
    UIButton *selected_color_button = (UIButton *)[_colorSheet viewWithTag:_tagColorbutton];
    selected_color_button.tag = 0;
    [[selected_color_button layer] setBorderWidth:0];
    
    // ボタンを選択状態にする
    [[button layer] setBorderColor:[[UIColor cyanColor] CGColor]];
    [[button layer] setBorderWidth:2.0];
    button.tag = _tagColorbutton;
    
    [self.colorTagButton setBackgroundColor:select_color];
}

- (void)colorSet{
    _saveColor = self.colorTagButton.backgroundColor;
    [_colorSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

- (void)colorCancelSet{
    [self.colorTagButton setBackgroundColor:_saveColor];
    [_colorSheet dismissWithClickedButtonIndex:0 animated:YES];
    
}

//======================================
// メニューのカラムを追加する
//======================================
- (void)buttonTupped:(id)sender {
   
    // textField 生成
    CGRect  rect = CGRectMake(100, _menuIndex * FIELD_SPAN + TOP_SPAN + FIELD_SPAN * 2, 200, 30);
    UITextField     *customTextField = [[UITextField alloc] initWithFrame:rect];

    customTextField.borderStyle = UITextBorderStyleRoundedRect;
    customTextField.textAlignment = NSTextAlignmentLeft;
    customTextField.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    customTextField.keyboardType = UIKeyboardTypeDefault;
    customTextField.returnKeyType = UIReturnKeyNext;
    customTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    customTextField.delegate = self;
    [_scrollView addSubview:customTextField];
    _textFieldArray = [_textFieldArray arrayByAddingObject:customTextField];
    _menuIndex++;
    
    // ボタンの位置調節
    CGRect  windowSize = [[UIScreen mainScreen] bounds];
    [self.addMenuButton setCenter:CGPointMake(windowSize.size.width / 2.0, _menuIndex * FIELD_SPAN + TOP_SPAN + FIELD_SPAN * 2 + 15)];
    
    // scroll view 幅調節
    if (_menuIndex * FIELD_SPAN + TOP_SPAN + FIELD_SPAN * 2 + 15 + 100 + BOTTOM_SPAN > self.view.bounds.size.height) {
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, _menuIndex * FIELD_SPAN + TOP_SPAN + FIELD_SPAN * 2 + 15 + BOTTOM_SPAN + 100);
        [self.submitButton setCenter:CGPointMake(windowSize.size.width / 2.0, _scrollView.contentSize.height - BOTTOM_SPAN)];
    }
}

@end
