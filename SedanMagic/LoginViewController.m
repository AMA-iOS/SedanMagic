//
//  LoginViewController.m
//  SedanMagic
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerRequestManager.h"
#import "SplashScreenViewController.h"


#define ALERT_SUCCESS (100)
#define ALERT_FAILURE (101)

@interface LoginViewController ()
{
	BOOL isChecked;
	IBOutlet UIButton *loginCheckBox;
}

@end




@implementation LoginViewController

@synthesize emailField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



+ (void) autoLogin
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *email = [defaults valueForKey:@"email_address"];
	if (email)
    {
		NSDictionary *dict = [defaults valueForKey:email];
		NSString *password = [dict objectForKey:@"password"];
		
		// path
        static NSString* const path = @"registration/1/1/0/am/WebEmulator";
        
        ServerRequestManager *requestManager = [ServerRequestManager sharedInstance];\
        
        // get basic auth
        
        
        // add as default header
        [requestManager setAuthorizationHeaderWithUsername:email password:password];
        
        [requestManager request:path method:@"GET" params:nil success:^(NSDictionary* response)
         {
             // send notification
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AutoLogged object:nil];
             
         } failure:^(NSError *error, NSDictionary* response)
         {
             NSLog(@"LOGIN FAIL");
             // send notification
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AutoLoggedFail object:nil];
         }];
	}
    else
    {
        // send notification
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_AutoLoggedFail object:nil];
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set background for textfields
    [self.emailField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // set offset for textfields
    self.emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    
    // set left view mode
    self.emailField.leftViewMode =
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *loginFlagNum = [defaults valueForKey:@"autologin"];
    
    NSString *email = [defaults valueForKey:@"email_address"];
    self.emailField.text = email;
	
	isChecked = [loginFlagNum boolValue];
	
	if (!isChecked) {
		[loginCheckBox setImage:[UIImage imageNamed:@"ama-checkbox-unchecked.png"] forState:UIControlStateNormal];
	}else{
		[loginCheckBox setImage:[UIImage imageNamed:@"ama-checkbox-checked.png"] forState:UIControlStateNormal];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)emailRegEx:(NSString *)string {
	
	// lowercase the email for proper validation
	string = [string lowercaseString];
	
	// regex for email validation
	NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
	NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
	BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
	
	return myStringMatchesRegEx;
	
}


-(void)validateEmail {
    if (![self emailRegEx:self.emailField.text]) {
        [self.emailField becomeFirstResponder];
        self.emailField.layer.borderWidth = 1.0;
        self.emailField.layer.borderColor = [UIColor redColor].CGColor;
    }
    else {
        self.emailField.layer.borderWidth = 0.0;
    }
}

-(IBAction)autoLoginButtonHandler:(id)sender
{
	if (isChecked) {
		[loginCheckBox setImage:[UIImage imageNamed:@"ama-checkbox-unchecked.png"] forState:UIControlStateNormal];
	}else{
		[loginCheckBox setImage:[UIImage imageNamed:@"ama-checkbox-checked.png"] forState:UIControlStateNormal];
	}
	isChecked = !isChecked;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isChecked] forKey:@"autologin"];
    [defaults synchronize];
}

-(BOOL)passwordValidation
{
    NSString *password = self.passwordField.text;
    
    if ([password length] < 6 ||
        [password length] > 16)
    {
        [self.passwordField becomeFirstResponder];
        self.passwordField.layer.borderWidth = 1.0;
        self.passwordField.layer.borderColor = [UIColor redColor].CGColor;
        
        return NO;
    }
    
    NSRange rang;
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
    if (!rang.length) {
        return NO;
    }
    
    // set border to normal state
    self.passwordField.layer.borderWidth = 0.0;
    
    return YES;
}



-(IBAction)loginBtnHandler:(id)sender
{
    // get info
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
	[self doLogin:email pass:password];
}



-(void) doLogin: (NSString *) email pass: (NSString *)password
{
	// send request
    
    // path
    static NSString* const path = @"registration/1/1/0/am/WebEmulator";
    
    ServerRequestManager *requestManager = [ServerRequestManager sharedInstance];\
    
    // get basic auth
    
    
    // add as default header
    [requestManager setAuthorizationHeaderWithUsername:email password:password];
    
    [requestManager request:path method:@"GET" params:nil success:^(NSDictionary* response)
     {
		 
         NSMutableDictionary *dict = [[NSDictionary dictionaryWithDictionary:response] mutableCopy];
         [dict removeObjectForKey:@"password"];
		 //
         
         // parse response
         NSString *key = [dict objectForKey:@"email_address"];
         
         // save required
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		 [defaults setObject:key forKey:@"email_address"];
         [defaults setObject:dict forKey:key];
         [defaults synchronize];
         
         // show message
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logged in" message:@"Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         alert.tag = ALERT_SUCCESS;
         [alert show];
         
     } failure:^(NSError *error, NSDictionary* response)
     {
         NSLog(@"LOGIN FAIL");
     }];
}


#pragma mark --
#pragma mark TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [super textFieldShouldReturn:textField];
    
    //[textField resignFirstResponder];
    
    if (textField == self.emailField)
    {
        [self validateEmail];
    }
    else if (textField == self.passwordField)
    {
        [self passwordValidation];
    }
    
    return TRUE;
}


#pragma mark --
#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // switch by alert tag
    switch (alertView.tag)
    {
        case ALERT_SUCCESS:
        {
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSMutableDictionary *dict = [[defaults objectForKey:self.emailField.text] mutableCopy];
			[dict setObject:self.passwordField.text forKey:@"password"];
			[defaults setObject:dict forKey:self.emailField.text];
			[defaults synchronize];
			
            // push view controller without animatiuon
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            
            UIViewController *bookingViewController = [mainStoryboard                                                                                  instantiateViewControllerWithIdentifier: @"BookingViewController"];
            
            
            [self.navigationController pushViewController:bookingViewController animated:FALSE];
        }
            break;
            
        case ALERT_FAILURE:
        {
            NSLog(@"FAIL");
        }
            break;
            
        default:
            break;
    }
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
