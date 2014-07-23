//
//  SecurityOptionsViewController.h
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SecurityOptionsViewController : BaseViewController

// text fields
@property (nonatomic, strong) IBOutlet UITextField *emailField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *confPasswordField;


@end
