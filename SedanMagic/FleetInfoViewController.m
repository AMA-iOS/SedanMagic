//
//  FleetInfoViewController.m
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "FleetInfoViewController.h"

@interface FleetInfoViewController ()

@end

@implementation FleetInfoViewController


@synthesize providerCodeField, accountIDField, vipNumberField;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set background
    UIImage *bg = [UIImage imageNamed:@"ama-main-bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    
    
    // set background for textfields
    [self.providerCodeField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.accountIDField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.vipNumberField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // set offset for textfields
    self.providerCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.accountIDField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.vipNumberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    
    // set left view mode
    self.providerCodeField.leftViewMode =
    self.accountIDField.leftViewMode =
    self.vipNumberField.leftViewMode = UITextFieldViewModeAlways;
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fillDataFields];
}

- (void) fillDataFields
{
	if (self.regisrationController.providerCode != nil) {
		self.providerCodeField.text = self.regisrationController.providerCode;
	}
	if (self.regisrationController.accountID != nil) {
		self.accountIDField.text = self.regisrationController.accountID;
	}
	if (self.regisrationController.vipNumber != nil) {
		self.vipNumberField.text = self.regisrationController.vipNumber;
	}
}

// next button touched
-(IBAction)nextBtnHandler:(id)sender
{
    // get strings
    NSString *providerCode = self.providerCodeField.text;
    NSString *accountID = self.accountIDField.text;
    NSString *vipNumber = self.vipNumberField.text;
    
    // validate
    if (providerCode && accountID && vipNumber)
    {
        // save to registration
        self.regisrationController.providerCode = providerCode;
        self.regisrationController.accountID = accountID;
        self.regisrationController.vipNumber = vipNumber;
        self.regisrationController.fleetInfo = TRUE;
        
        // call registration controller
        [self registerNext];
    }
    else
    {
        // show alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please check data fields"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
