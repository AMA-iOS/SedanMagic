//
//  BaseViewController.m
//  SedanMagic
//
//  Created by user on 7/21/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "BaseViewController.h"
#import "SecurityOptionsViewController.h"
#import "FleetInfoViewController.h"
#import "MyInfoViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController


@synthesize topView;
@synthesize headerView;
@synthesize bottomView;
@synthesize footerView;
@synthesize activeView;



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
    
    // init registration controller pointer
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    self.regisrationController = [mainStoryboard instantiateViewControllerWithIdentifier: @"RegistrationViewController"];
    
    // set background
    UIImage *bg = [UIImage imageNamed:@"ama-main-bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
	// animations
    self.activeView.alpha = 0;
    
    self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 100,
                                    self.topView.frame.size.width, self.topView.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y - 300,
                                       self.headerView.frame.size.width, self.headerView.frame.size.height);
    
    self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 200,
                                       self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    
    self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y + 300,
                                       self.footerView.frame.size.width, self.footerView.frame.size.height);
    
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // top
                         self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y + 100,
                                                         self.topView.frame.size.width, self.topView.frame.size.height);
                         // header
                         self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + 300,
                                                            self.headerView.frame.size.width, self.headerView.frame.size.height);
                         
                         
                         self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y - 200,
                                                            self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                         
                         self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y - 300,
                                                            self.footerView.frame.size.width, self.footerView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:1.0
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // show active view
                                              self.activeView.alpha = 1;
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"Done!");
                                          }];
                     }];

}


-(IBAction)backBtnHandler:(id)sender
{
    // animation
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // hide active view
                         self.activeView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:1.0
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // top
                                              self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 100,
                                                                              self.topView.frame.size.width, self.topView.frame.size.height);
                                              // header
                                              self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y - 300,
                                                                                 self.headerView.frame.size.width, self.headerView.frame.size.height);
                                              
                                              
                                              self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 200,
                                                                                 self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                                              
                                              self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y + 300,
                                                                                 self.footerView.frame.size.width, self.footerView.frame.size.height);
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"Done!");
                                              [self.navigationController popViewControllerAnimated:FALSE];
                                          }];
                     }];
}




-(void) registerNext
{
    // check if all information populated
    if (self.regisrationController.myInfo && self.regisrationController.fleetInfo && self.regisrationController.security)
    {
        // create request to server
        NSLog(@"create request to server");
        
        [self.regisrationController registerRequest];
    }
    else
    {
        // animation
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             // hide active view
                             self.activeView.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             
                             // show active area
                             [UIView animateWithDuration:0.5
                                                   delay:1.0
                                                 options: UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  // top
                                                  self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 100,
                                                                                  self.topView.frame.size.width, self.topView.frame.size.height);
                                                  // header
                                                  self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y - 300,
                                                                                     self.headerView.frame.size.width, self.headerView.frame.size.height);
                                                  
                                                  
                                                  self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 200,
                                                                                     self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                                                  
                                                  self.footerView.frame = CGRectMake(self.footerView.frame.origin.x, self.footerView.frame.origin.y + 300,
                                                                                     self.footerView.frame.size.width, self.footerView.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  NSLog(@"Done!");
                                                  //self.regisrationController.denyAnimation = TRUE;
                                                  //[self.navigationController popViewControllerAnimated:FALSE];
                                                  
                                                  [self performSelector:@selector(showNextRegisterScreen) withObject:self afterDelay:0.0];
                                              }];
                         }];
    }
}



-(void) showNextRegisterScreen
{
    NSLog(@"showNextRegisterScreen");
    
    // push screen
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    if (!self.regisrationController.myInfo)
    {
        // show my info
        MyInfoViewController *myInfoViewController = (MyInfoViewController*)[mainStoryboard
                                                                             instantiateViewControllerWithIdentifier: @"MyInfoViewController"];
        myInfoViewController.regisrationController = self.regisrationController;
        
        
        [self.navigationController pushViewController:myInfoViewController animated:FALSE];
    }
    else if (!self.regisrationController.fleetInfo)
    {
        // show fleet info
        FleetInfoViewController *fleetViewController = (FleetInfoViewController*)[mainStoryboard
                                                                                  instantiateViewControllerWithIdentifier: @"FleetInfoViewController"];
        fleetViewController.regisrationController = self.regisrationController;
        
        [self.navigationController pushViewController:fleetViewController animated:FALSE];
    }
    else if (!self.regisrationController.security)
    {
        // show security
        SecurityOptionsViewController *securityViewController = (SecurityOptionsViewController*)[mainStoryboard
                                                                                                 instantiateViewControllerWithIdentifier: @"SecurityOptionsViewController"];
        securityViewController.regisrationController = self.regisrationController;
        
        [self.navigationController pushViewController:securityViewController animated:FALSE];
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
