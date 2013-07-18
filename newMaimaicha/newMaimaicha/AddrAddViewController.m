//
//  AddrAddViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-10.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AddrAddViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
@interface AddrAddViewController ()

@end

@implementation AddrAddViewController
@synthesize addrAddTableView = _addrAddTableView;
@synthesize nameField = _nameField;
@synthesize mobileField = _mobileField;
@synthesize provinceField = _provinceField;
@synthesize cityField = _cityField;
@synthesize countyField = _countyField;
@synthesize zpField = _zpField;
@synthesize placeField = _placeField;
@synthesize selectDefButton;
@synthesize picker = _picker;
@synthesize provinceArray;
@synthesize cityArray;
@synthesize countyArray;
@synthesize selectCityId;
@synthesize selectProvinceId;
@synthesize selectCountyId;
@synthesize toolbar = _toolbar;
@synthesize firstResponse;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(submit)];
    [rightBar setTintColor:[UIColor colorWithRed:175/255.0 green:219/255.0 blue:116/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = rightBar;
    [self.view addSubview:self.addrAddTableView];
    self.selectDefButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectDefButton.tag = 0;
    UIButton *selectLabelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectLabelButton.tag = 1;
    [selectLabelButton setTitle:@"设置为默认地址" forState:UIControlStateNormal];
    [selectLabelButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [selectLabelButton setFrame:CGRectMake(55, 300, 120, 30)];
    [self.selectDefButton setFrame:CGRectMake(20, 300, 30, 30)];
    [selectLabelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectLabelButton addTarget:self action:@selector(selectDef:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectDefButton setBackgroundImage:[UIImage imageNamed:@"checkbox_mmc_pressed.png"] forState:UIControlStateNormal];
    [self.selectDefButton addTarget:self action:@selector(selectDef:) forControlEvents:UIControlEventTouchUpInside];
    ISDEFAULT = YES;
    [self.view addSubview:self.selectDefButton];
    [self.view addSubview:selectLabelButton];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.nameField becomeFirstResponder];
            break;
        case 1:
            [self.mobileField becomeFirstResponder];
            break;
        case 2:
            [self.provinceField becomeFirstResponder];
            break;
        case 3:
            [self.cityField becomeFirstResponder];
            break;
        case 4:
            [self.countyField becomeFirstResponder];
            break;
        case 5:
            [self.zpField becomeFirstResponder];
            break;
        case 6:
            [self.placeField becomeFirstResponder];
            break;
        default:
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0)
    {
        [cell.contentView addSubview:self.nameField];
    }else if (indexPath.row == 1){
        [cell.contentView addSubview:self.mobileField];
        
    }else if (indexPath.row == 2){
        [cell.contentView addSubview:self.provinceField];
        
    }else if (indexPath.row == 3){
        [cell.contentView addSubview:self.cityField];
        
    }else if (indexPath.row == 4){
        [cell.contentView addSubview:self.countyField];
        
    }else if (indexPath.row == 5){
        [cell.contentView addSubview:self.zipField];
    }else{
        [cell.contentView addSubview:self.placeField];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)addrAddTableView
{
    if(_addrAddTableView == nil)
    {
        _addrAddTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 300) style:UITableViewStyleGrouped];
        _addrAddTableView.dataSource = self;
        _addrAddTableView.delegate = self;
        _addrAddTableView.backgroundView = nil;
        _addrAddTableView.scrollEnabled = NO;
        [_addrAddTableView setBackgroundColor:[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0]];
        
    }
    return _addrAddTableView;
}

- (UITextField *)nameField
{
    if (_nameField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"收货人:　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _nameField.placeholder = @"请输入姓名";
        _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameField.leftViewMode = UITextFieldViewModeAlways;
        _nameField.font = [UIFont systemFontOfSize:14.0];
        _nameField.leftView = leftLabel;
        _nameField.returnKeyType = UIReturnKeyNext;
        _nameField.inputAccessoryView = self.toolbar;
        _nameField.keyboardType = UIKeyboardTypeDefault;
        _nameField.tag = 1;
        _nameField.delegate = self;
    }
    return _nameField;
}

- (UITextField *)mobileField
{
    if (_mobileField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"手机号:　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _mobileField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _mobileField.placeholder = @"请输入手机号码";
        _mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mobileField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mobileField.leftViewMode = UITextFieldViewModeAlways;
        _mobileField.font = [UIFont systemFontOfSize:14.0];
        _mobileField.leftView = leftLabel;
        _mobileField.returnKeyType = UIReturnKeyNext;
        _mobileField.tag = 2;
        _mobileField.inputAccessoryView = self.toolbar;
        _mobileField.delegate = self;
        _mobileField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _mobileField;
}


- (UITextField *)provinceField
{
    if (_provinceField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"省份:　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _provinceField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _provinceField.placeholder = @"请选择所在省份";
        _provinceField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _provinceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _provinceField.leftViewMode = UITextFieldViewModeAlways;
        _provinceField.font = [UIFont systemFontOfSize:14.0];
        _provinceField.leftView = leftLabel;
        _provinceField.returnKeyType = UIReturnKeyNext;
        _provinceField.tag = 3;
        _provinceField.inputAccessoryView = self.toolbar;
        _provinceField.delegate = self;
    }
    return _provinceField;
}

- (UITextField *)cityField
{
    if (_cityField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"城市:  ";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _cityField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _cityField.placeholder = @"请旋转所在城市";
        _cityField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cityField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _cityField.leftViewMode = UITextFieldViewModeAlways;
        _cityField.font = [UIFont systemFontOfSize:14.0];
        _cityField.leftView = leftLabel;
        _cityField.inputAccessoryView = self.toolbar;
        _cityField.returnKeyType = UIReturnKeyNext;
        _cityField.tag = 4;
        _cityField.delegate = self;
    }
    return _cityField;
}

- (UITextField *)countyField
{
    if (_countyField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"区域:　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _countyField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _countyField.placeholder = @"请选择所在区域";
        _countyField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _countyField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _countyField.leftViewMode = UITextFieldViewModeAlways;
        _countyField.font = [UIFont systemFontOfSize:14.0];
        _countyField.leftView = leftLabel;
        _countyField.returnKeyType = UIReturnKeyNext;
        _countyField.tag = 5;
        _countyField.inputAccessoryView = self.toolbar;
        _countyField.delegate = self;
    }
    return _countyField;
}

- (UITextField *)zipField
{
    if (_zpField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"邮政编码: ";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _zpField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _zpField.placeholder = @"请输邮政编码";
        _zpField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _zpField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _zpField.leftViewMode = UITextFieldViewModeAlways;
        _zpField.font = [UIFont systemFontOfSize:14.0];
        _zpField.leftView = leftLabel;
        _zpField.returnKeyType = UIReturnKeyNext;
        _zpField.keyboardType = UIKeyboardTypeNumberPad;
        _zpField.tag = 6;
        _zpField.inputAccessoryView = self.toolbar;
        _zpField.delegate = self;
    }
    return _zpField;
}

- (UITextField *)placeField
{
    if (_placeField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        leftLabel.text = @"联系地址:  ";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:12.0];
        leftLabel.textAlignment = NSTextAlignmentLeft;
        _placeField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 260, 30)];
        _placeField.placeholder = @"请输入联系地址";
        _placeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _placeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _placeField.leftViewMode = UITextFieldViewModeAlways;
        _placeField.font = [UIFont systemFontOfSize:14.0];
        _placeField.leftView = leftLabel;
        _placeField.returnKeyType = UIReturnKeyDone;
        _placeField.tag = 7;
        _placeField.inputAccessoryView = self.toolbar;
        _placeField.delegate = self;
    }
    return _placeField;
}

- (void)selectDef:(id)sender
{
    if(ISDEFAULT)
    {
        [self.selectDefButton setBackgroundImage:[UIImage imageNamed:@"checkbox_mmc.png"] forState:UIControlStateNormal];
        ISDEFAULT = NO;
    }else{
        [self.selectDefButton setBackgroundImage:[UIImage imageNamed:@"checkbox_mmc_pressed.png"] forState:UIControlStateNormal];
        ISDEFAULT = YES;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        [self.mobileField becomeFirstResponder];
    }else if (textField.tag ==2){
        [self.provinceField becomeFirstResponder];
    }else if (textField.tag == 3){
        [self.cityField becomeFirstResponder];
    }else if (textField.tag == 4){
        [self.countyField becomeFirstResponder];
    }else if (textField.tag ==5){
        [self.zpField becomeFirstResponder];
    }else if (textField.tag == 6){
        [self.placeField becomeFirstResponder];
    }else{
        [self.placeField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.firstResponse = textField;
    if(textField.tag == 1)
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    if(textField.tag == 2)
    [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    if(textField.tag == 3)
    {
        [self.view setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        self.picker.tag = 1;
        textField.inputView = self.picker;
        if((self.selectProvinceId !=nil)&&(self.provinceArray.count >0))
        {
            for(int i=0 ;i<self.provinceArray.count;i++)
            {
                if([self.selectProvinceId isEqualToString:[[self.provinceArray objectAtIndex:i] objectForKey:@"regionId"]])
                {
                    [self.picker reloadAllComponents];
                    [self.picker selectRow:i inComponent:0 animated:NO];
                }
            }
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:@"regions_getFirstGradeRegions" forKey:@"act"];
            MKNetworkOperation *op = [YMGlobal getOperation:params];
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                [hud hide:YES];
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
                {
                    self.provinceArray = [obj objectForKey:@"result"];
                    [self.picker reloadAllComponents];
                    [self.picker selectRow:0 inComponent:0 animated:NO];
                    self.selectProvinceId = [[self.provinceArray objectAtIndex:0]objectForKey:@"regionId"];
                    textField.text = [[self.provinceArray objectAtIndex:0] objectForKey:@"localName"];
                }
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                [hud hide:YES];
                NSLog(@"%@",error);
            }];
            [ApplicationDelegate.engine enqueueOperation:op];
        }

    }
    if(textField.tag == 4){
        [self.view setFrame:CGRectMake(0, -30, 320, self.view.frame.size.height)];
        if(self.selectProvinceId != nil)
        {
            self.picker.tag = 2;
            textField.inputView = self.picker;
            if((self.selectCityId !=nil)&&(self.cityArray.count >0))
            {
                for(int i=0 ;i<self.cityArray.count;i++)
                {
                    if([self.selectCityId isEqualToString:[[self.cityArray objectAtIndex:i] objectForKey:@"regionId"]])
                    {
                        [self.picker reloadAllComponents];
                        [self.picker selectRow:i inComponent:0 animated:NO];
                    }
                }
            }else{
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setObject:@"regions_getSecondGradeRegions" forKey:@"act"];
                [params setObject:self.selectProvinceId forKey:@"firstRegionId"];
                MKNetworkOperation *op = [YMGlobal getOperation:params];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view.superview animated:NO];
                [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                    [hud hide:YES];
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                    if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
                    {
                        self.cityArray = [obj objectForKey:@"result"];
                        [self.picker reloadAllComponents];
                        [self.picker selectRow:0 inComponent:0 animated:NO];
                        self.selectCityId = [[self.cityArray objectAtIndex:0]objectForKey:@"regionId"];
                        textField.text = [[self.cityArray objectAtIndex:0] objectForKey:@"localName"];
                        
                    }
                } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                    [hud hide:YES];
                    NSLog(@"%@",error);
                }];
                [ApplicationDelegate.engine enqueueOperation:op];
            }

        }else{
            [textField resignFirstResponder];
        }}
        
    if(textField.tag == 5){
        [self.view setFrame:CGRectMake(0, -80, 320, self.view.frame.size.height)];
        if(self.selectCityId != nil)
        {
            self.picker.tag = 3;
            textField.inputView = self.picker;
            if((self.selectCountyId !=nil)&&(self.countyArray.count >0))
            {
                for(int i=0 ;i<self.countyArray.count;i++)
                {
                    if([self.selectCountyId isEqualToString:[[self.countyArray objectAtIndex:i] objectForKey:@"regionId"]])
                    {
                        [self.picker reloadAllComponents];
                        [self.picker selectRow:i inComponent:0 animated:NO];
                    }
                }
            }else{
                NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                [params setObject:@"regions_getThirdGradeRegions" forKey:@"act"];
                [params setObject:self.selectCityId forKey:@"secondRegionId"];
                MKNetworkOperation *op = [YMGlobal getOperation:params];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view.superview animated:NO];
                [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                    [hud hide:YES];
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                    if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
                    {
                        self.countyArray = [obj objectForKey:@"result"];
                        [self.picker reloadAllComponents];
                        [self.picker selectRow:0 inComponent:0 animated:NO];
                        self.selectCountyId = [[self.countyArray objectAtIndex:0]objectForKey:@"regionId"];
                        textField.text = [[self.countyArray objectAtIndex:0] objectForKey:@"localName"];
                    }
                } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                    [hud hide:YES];
                    NSLog(@"%@",error);
                }];
                [ApplicationDelegate.engine enqueueOperation:op];
            }            
        }else{
            [textField resignFirstResponder];
        }
    }
    if(textField.tag ==6)
    [self.view setFrame:CGRectMake(0, -150, 320, self.view.frame.size.height)];
    if(textField.tag ==7)
        [self.view setFrame:CGRectMake(0, -180, 320, self.view.frame.size.height)];
}

- (UIPickerView *)picker
{
    if(_picker == nil)
    {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, size.height-210, 320, 210)];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
    }
    return _picker;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        if(self.provinceArray.count == 0)
        {
            self.picker.userInteractionEnabled = NO;
        }else{
            self.picker.userInteractionEnabled = YES;
        }
        return self.provinceArray.count;

    }else if (pickerView.tag == 2){
        if(self.cityArray.count == 0)
        {
            self.picker.userInteractionEnabled = NO;
        }else{
             self.picker.userInteractionEnabled = YES;
        }
        return self.cityArray.count;
    }else{
        if(self.countyArray.count == 0)
        {
            self.picker.userInteractionEnabled = NO;
        }else{
            self.picker.userInteractionEnabled = YES;
        }
        return self.countyArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        if(self.provinceArray !=nil)
        return [[self.provinceArray objectAtIndex:row] objectForKey:@"localName"];
        else
            return @"";
    }else if(pickerView.tag == 2){
        if(self.cityArray !=nil)
        return [[self.cityArray objectAtIndex:row] objectForKey:@"localName"];
        else
            return @"";
    }else{
        if(self.countyArray !=nil)
        return [[self.countyArray objectAtIndex:row] objectForKey:@"localName"];
        else
            return @"";
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
       if(self.provinceArray !=nil)
       {
           self.selectProvinceId = [[self.provinceArray objectAtIndex:row]objectForKey:@"regionId"];
           self.provinceField.text = [[self.provinceArray objectAtIndex:row]objectForKey:@"localName"];
       }
    }else if (pickerView.tag == 2){
        if(self.cityArray !=nil)
        {
            self.selectCityId = [[self.cityArray objectAtIndex:row]objectForKey:@"regionId"];
            self.cityField.text = [[self.cityArray objectAtIndex:row]objectForKey:@"localName"];
        }
    }else{
        if(self.countyArray !=nil )
        {
            self.selectCountyId = [[self.countyArray objectAtIndex:row]objectForKey:@"regionId"];
            self.countyField.text = [[self.countyArray objectAtIndex:row]objectForKey:@"localName"];
        }

    }
}

- (UIToolbar  *)toolbar
{
    if(_toolbar == nil)
    {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *lastButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleBordered target:self action:@selector(getLastTextField)];
        UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleBordered target:self action:@selector(getNextTextField)];
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style: UIBarButtonItemStyleBordered target:self action:@selector(keyboardDown:)];
        NSArray *array = [NSArray arrayWithObjects:lastButtonItem, nextButtonItem, spaceButtonItem, hiddenButtonItem, nil];
        [_toolbar setItems:array];
    }
    return _toolbar;
}


-(void)getNextTextField
{
    switch (firstResponse.tag) {
        case 1:
            [self.firstResponse resignFirstResponder];
            [self.mobileField becomeFirstResponder];
            break;
        case 2:
            [self.firstResponse resignFirstResponder];
            [self.provinceField becomeFirstResponder];
            break;
        case 3:
            [self.firstResponse resignFirstResponder];
            [self.cityField becomeFirstResponder];
            break;
        case 4:
            [self.firstResponse resignFirstResponder];
            [self.countyField becomeFirstResponder];
            break;
        case 5:
            [self.firstResponse resignFirstResponder];
            [self.zpField becomeFirstResponder];
            break;
        case 6:
            [self.firstResponse resignFirstResponder];
            [self.placeField becomeFirstResponder];
            break;
        default:
            break;
    }
}

-(void)getLastTextField
{
    switch (firstResponse.tag) {
        case 2:
            [self.firstResponse resignFirstResponder];
            [self.nameField becomeFirstResponder];
            break;
        case 3:
            [self.firstResponse resignFirstResponder];
            [self.mobileField becomeFirstResponder];
            break;
        case 4:
            [self.firstResponse resignFirstResponder];
            [self.provinceField becomeFirstResponder];
            break;
        case 5:
            [self.firstResponse resignFirstResponder];
            [self.cityField becomeFirstResponder];
            break;
        case 6:
            [self.firstResponse resignFirstResponder];
            [self.countyField becomeFirstResponder];
            break;
        case 7:
            [self.firstResponse resignFirstResponder];
            [self.zpField becomeFirstResponder];
            break;
        default:
            break;
    }
}

- (void)keyboardDown:(id)sender
{
    if(self.firstResponse != nil)
    {
        [self.firstResponse resignFirstResponder];
    }
}

- (void)submit
{
    UIAlertView *alert;
    if([self.nameField.text isEqualToString:@""])
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                         message:@"请填写收货人"
                                        delegate:self
                               cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.mobileField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请填写手机号码"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.provinceField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请选择省份"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.cityField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请选择城市"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.countyField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请旋转区域"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.zpField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请填写邮政编码"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.placeField.text isEqualToString:@""]){
        alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"请填写详细联系地址"
                                         delegate:self
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if([UserModel checkLogin]){
            UserModel *user = [UserModel getUserModel];
            NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
            [param setObject:user.userId forKey:@"userId"];
            [param setObject:@"addr_addAddrs" forKey:@"act"];
            NSString *mainLand = [NSString stringWithFormat:@"mainland:%@/%@/%@:%@",self.provinceField.text,self.cityField.text,self.countyField.text,self.selectCountyId];
            [param setObject:mainLand forKey:@"area"];
            NSString *addr = [NSString stringWithFormat:@"%@%@%@%@",self.provinceField.text,self.cityField.text,self.countyField.text,self.placeField.text];
            [param setObject:addr forKey:@"addr"];
            [param setObject:self.zpField.text forKey:@"zip"];
            [param setObject:self.mobileField.text forKey:@"mobile"];
            [param setObject:self.nameField.text forKey:@"name"];
            if(ISDEFAULT){
                [param setObject:@"1" forKey:@"default"];
            }
            MKNetworkOperation *op = [YMGlobal getOperation:param];
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [ApplicationDelegate.engine enqueueOperation:op];
        }
    }



}
@end
