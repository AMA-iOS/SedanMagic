//
//  RegistrationViewController.h
//  SedanMagic
//
//  Created by user on 7/10/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AFNetworking.h"

@interface RegistrationViewController : UIViewController 


@property (nonatomic, strong) IBOutlet UIView *bottomView;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UIView *middleView;

// fleet info
@property (nonatomic, retain) NSString *providerCode;
@property (nonatomic, retain) NSString *accountID;
@property (nonatomic, retain) NSString *vipNumber;
@property (nonatomic, assign) BOOL fleetInfo;


// my info
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *mobileNumber;
@property (nonatomic, assign) BOOL myInfo;


// security
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) BOOL security;


// animation flag
@property (nonatomic, assign) BOOL denyAnimation;

-(void) registerRequest;

@end
