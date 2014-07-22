//
//  BaseViewController.h
//  SedanMagic
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationViewController.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) RegistrationViewController *regisrationController;

// animation views
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIView *activeView;



-(void) registerNext;



@end
