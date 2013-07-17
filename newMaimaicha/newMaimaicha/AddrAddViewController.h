//
//  AddrAddViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-10.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddrAddViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,
UIPickerViewDelegate>
{
    BOOL ISDEFAULT;
}
@property (strong,nonatomic)UITableView *addrAddTableView;
@property (strong, nonatomic)UITextField *nameField;
@property (strong, nonatomic)UITextField *mobileField;
@property (strong, nonatomic)UITextField *provinceField;
@property (strong, nonatomic)UITextField *cityField;
@property (strong, nonatomic)UITextField *countyField;
@property (strong, nonatomic)UITextField *zpField;
@property (strong, nonatomic)UITextField *placeField;
@property (strong, nonatomic)UIButton *selectDefButton;
@property (strong, nonatomic)UIPickerView *picker;
@property (strong, nonatomic)NSMutableArray *provinceArray;
@property (strong, nonatomic)NSMutableArray *cityArray;
@property (strong, nonatomic)NSMutableArray *countyArray;
@property (strong, nonatomic)NSString *selectCityId;
@property (strong, nonatomic)NSString *selectProvinceId;
@property (strong, nonatomic)NSString *selectCountyId;
@property (strong, nonatomic)UIToolbar *toolbar;
@property (strong, nonatomic)UITextField *firstResponse;
@end
