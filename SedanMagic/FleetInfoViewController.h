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
 
// // animation views
// @property (nonatomic, strong) IBOutlet UIView *topView;
// @property (nonatomic, strong) IBOutlet UIView *headerView;
// @property (nonatomic, strong) IBOutlet UIView *bottomView;
// @property (nonatomic, strong) IBOutlet UIView *footerView;
// @property (nonatomic, strong) IBOutlet UIView *activeView;


@end
