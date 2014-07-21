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
