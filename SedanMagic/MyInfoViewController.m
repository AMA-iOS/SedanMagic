//
//  MyInfoViewController.m
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController


@synthesize firstNameField, lastNameField, mobileNumberField;



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
    [self.firstNameField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.lastNameField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.mobileNumberField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // set offset for textfields
    self.firstNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.lastNameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.mobileNumberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    
    // set left view mode
    self.firstNameField.leftViewMode =
    self.lastNameField.leftViewMode =
    self.mobileNumberField.leftViewMode = UITextFieldViewModeAlways;
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fillDataFields];
}


- (void) fillDataFields
{
	if (self.regisrationController.firstName != nil)
    {
		self.firstNameField.text = self.regisrationController.firstName;
	}
    
	if (self.regisrationController.lastName != nil)
    {
		self.lastNameField.text = self.regisrationController.lastName;
	}
    
	if (self.regisrationController.mobileNumber != nil)
    {
		self.mobileNumberField.text = self.regisrationController.mobileNumber;
	}
}


// next button touched
-(IBAction)nextBtnHandler:(id)sender
{
    // get strings
    NSString *firstName = self.firstNameField.text;
    NSString *lastName = self.lastNameField.text;
    NSString *mobileNumber = self.mobileNumberField.text;
    
    // validate
    if (firstName && lastName && mobileNumber)
    {
        // save to registration
        self.regisrationController.firstName = firstName;
        self.regisrationController.lastName = lastName;
        self.regisrationController.mobileNumber = mobileNumber;
        self.regisrationController.myInfo = TRUE;
        
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
