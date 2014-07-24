//
//  SplashScreenViewController.m
//  SedanMagic
//
//  Created by user on 7/17/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SplashScreenViewController.h"
#import "RegistrationViewController.h"
#import "LoginViewController.h"


NSString* const kNotification_AutoLogged=@"AutoLogged";
NSString* const kNotification_AutoLoggedFail=@"AutoLoggedFail";




@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

@synthesize logoImageView, selectView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLogged) name:kNotification_AutoLogged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autoLoggedFail) name:kNotification_AutoLoggedFail object:nil];
    
    // hide select view
    self.selectView.alpha = 0;
    
    // set background
    UIImage *bg = [UIImage imageNamed:@"ama-main-bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    
    // animations
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.logoImageView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         // check if autologin required
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSNumber *autologinFlagNum = [defaults valueForKey:@"autologin"];
                         if ([autologinFlagNum boolValue])
                         {
                             // call autologin
                             [LoginViewController autoLogin];
                         }
                         else
                         {
                             [self performSelector:@selector(showSelect) withObject:nil afterDelay:0.0];
                         }
                     }];
}



-(void) autoLogged
{
    NSLog(@"autoLogged");
    
    
    // show required screen
    // push view controller without animatiuon
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    UIViewController *bookingViewController = [mainStoryboard                                                                                  instantiateViewControllerWithIdentifier: @"BookingViewController"];
    
    [self.navigationController pushViewController:bookingViewController animated:FALSE];
}



-(void) autoLoggedFail
{
    NSLog(@"autoLogged");
    
    [self performSelector:@selector(showSelect) withObject:nil afterDelay:0.0];
    
    // show required message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Autologin error" message:@"Please log in manually"
                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
}


// show selection view with buttons
-(void) showSelect
{
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectView.alpha = 1;
                     }
                     completion:^(BOOL finished){

                     }];
}




-(IBAction)showRegistrationBtnHandler:(id)sender
{
    // hide selection view
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         // push to registration
                         // push view controller without animatiuon
                         UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                         
                         RegistrationViewController *regViewController = (RegistrationViewController*)[mainStoryboard
                                                                                                       instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
                         
                         
                         [self.navigationController pushViewController:regViewController animated:FALSE];
                     }];
}



-(IBAction)showLoginBtnHandler:(id)sender
{
    // hide selection view
    [UIView animateWithDuration:0.5
                          delay:1.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         // push to registration
                         // push view controller without animatiuon
                         UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                         
                         LoginViewController *loginViewController = (LoginViewController*)[mainStoryboard
                                                                                                       instantiateViewControllerWithIdentifier: @"LoginViewController"];
                         
                         
                         [self.navigationController pushViewController:loginViewController animated:FALSE];
                     }];
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
