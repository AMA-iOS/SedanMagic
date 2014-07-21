//
//  MyInfoViewController.h
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyInfoViewController : BaseViewController <UITextFieldDelegate>


// text fields
@property (nonatomic, strong) IBOutlet UITextField *firstNameField;
@property (nonatomic, strong) IBOutlet UITextField *lastNameField;
@property (nonatomic, strong) IBOutlet UITextField *mobileNumberField;


@end
