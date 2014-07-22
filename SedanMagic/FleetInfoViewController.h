//
//  FleetInfoViewController.h
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

@interface FleetInfoViewController : BaseViewController <UITextFieldDelegate>


 // text fields
 @property (nonatomic, strong) IBOutlet UITextField *providerCodeField;
 @property (nonatomic, strong) IBOutlet UITextField *accountIDField;
 @property (nonatomic, strong) IBOutlet UITextField *vipNumberField;


@end
