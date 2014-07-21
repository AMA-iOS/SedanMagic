//
//  LoginViewController.h
//  SedanMagic
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;


@end
