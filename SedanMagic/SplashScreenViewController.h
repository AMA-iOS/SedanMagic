//
//  SplashScreenViewController.h
//  SedanMagic
//
//  Created by user on 7/17/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString* const kNotification_AutoLogged;

@interface SplashScreenViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *logoImageView;

@property (nonatomic, strong) IBOutlet UIView *selectView;

@end
