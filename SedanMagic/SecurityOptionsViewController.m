//
//  SecurityOptionsViewController.m
//  SedanMagic
//
//  Created by user on 7/18/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "SecurityOptionsViewController.h"

@interface SecurityOptionsViewController ()

@end

@implementation SecurityOptionsViewController


@synthesize emailField, passwordField, confPasswordField;


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
    [self.emailField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confPasswordField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // set offset for textfields
    self.emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.confPasswordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    
    // set left view mode
    self.emailField.leftViewMode =
    self.passwordField.leftViewMode =
    self.confPasswordField.leftViewMode = UITextFieldViewModeAlways;
}



- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fillDataFields];
}

// next button touched
-(IBAction)nextBtnHandler:(id)sender
{
    // get strings
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    // check if password is equal to confirm pass field
    if (![self.passwordField.text isEqualToString:self.confPasswordField.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please check CONFIRM PASSWORD field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    // validate
    if (email && password)
    {
        // save to registration
        self.regisrationController.email = email;
        self.regisrationController.password = password;
        self.regisrationController.security = TRUE;
        
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


- (void) fillDataFields
{
	if (self.regisrationController.password != nil) {
		self.passwordField.text = self.regisrationController.password;
	}
	if (self.regisrationController.email != nil) {
	self.emailField.text = self.regisrationController.email;
	}
	if (self.regisrationController.password != nil) {
	self.confPasswordField.text = self.regisrationController.password;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return TRUE;
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
