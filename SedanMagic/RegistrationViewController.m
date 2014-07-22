//
//  RegistrationViewController.m
//  SedanMagic
//
//  Created by user on 7/10/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ServerRequestController.h"

#import "ServerRequestManager.h"
#import "FleetInfoViewController.h"
#import "MyInfoViewController.h"
#import "SecurityOptionsViewController.h"

//Response Codes:
/*
 
 201 – User is registered
 401 – Authentication error
 403 - User is registered (but not active)
 404 - The account user was not found
 409 - The device is already registered for this user. Trigger auto login
 500 – Server error
 
 */

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

@synthesize bottomView;
@synthesize topView;
@synthesize middleView;



// registration info
@synthesize providerCode;
@synthesize accountID;
@synthesize vipNumber;
@synthesize firstName;
@synthesize lastName;
@synthesize mobileNumber;
@synthesize email;
@synthesize password;

@synthesize fleetInfo, myInfo, security;

@synthesize denyAnimation;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




-(void) viewWillAppear:(BOOL)animated
{
    if (self.denyAnimation)
    {
        self.denyAnimation = FALSE;
        return;
    }
    
    // animations
    self.middleView.alpha = 0;
    
    self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 300,
                                    self.topView.frame.size.width, self.topView.frame.size.height);
    
    self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 300,
                                       self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // top
                         self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y + 300,
                                                         self.topView.frame.size.width, self.topView.frame.size.height);
                         
                         
                         self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y - 300,
                                                            self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                              // show active view
                                              self.middleView.alpha = 1;
                                          }
                                          completion:^(BOOL finished){
                                              NSLog(@"Done!");
                                          }];
                     }];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set background
    UIImage *bg = [UIImage imageNamed:@"ama-main-bg.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];

    
   

    
    
    // create request controller and set base url
    ServerRequestController *requestController = [ServerRequestController sharedInstance];
    [requestController setBaseURL:@"https://dev-clientapi.sedanmagic.com/"];
   
    /*
    // path
    static NSString* const path = @"registration/1/1/0/am/WebEmulator";
    
    // params
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:1], @"provider_id",
                            @"1", @"provider_account_id",
                            @"0", @"provider_subaccount_id",
                            @"am", @"profile_id",
                            @"alexeym@ikrok.net", @"username",
                            @"qwantiko", @"password",
                            @"alexeym@ikrok.net", @"email_address",
                            @"Alexey", @"first_name",
                            @"Makarov", @"last_name",
                            @"WebEmulator", @"device_token",
                            @"222-222-7777", @"phone_number",
                            @"Emulator", @"platform_name",
                            @"0.2", @"platform_version",
                            nil];
    
*/
    
#if ue
    
    
    [requestController request:path method:@"POST" params:params success:^(NSDictionary* response)
     {
         NSDictionary* resultDict = [response objectForKey:@"Response"];
         NSLog(@"resultDict = %@", resultDict);
         
     } failure:^(NSError *error, NSDictionary* response)
     {
         // check for resp
         if (response)
         {
             NSNumber *codeNumber = [response objectForKey:@"OperationResponseCode"];
             if ([codeNumber intValue] == 409)
             {
                 // start autologin
                 
                 // path
                 static NSString* const path = @"registration/1/1/0/am/WebEmulator";
                 
                 
                 [requestController request:path method:@"GET" params:nil success:^(NSDictionary* response)
                  {
                      NSMutableDictionary *dict = [[NSDictionary dictionaryWithDictionary:response] mutableCopy];
                      [dict removeObjectForKey:@"password"];
                      
                      // parse response
                      NSString *key = [dict objectForKey:@"email_address"];
                      
                      // save required
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      [defaults setObject:dict forKey:key];
                      [defaults synchronize];
                      
                      
                      // get account status
                      static NSString* const path = @"https://dev-clientapi.sedanmagic.com/accountuserstatus/1/1/0/am";
                      
                      
                      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
                      
                      [request setURL:[NSURL URLWithString:path]];
                      
                      [request setHTTPMethod:@"GET"];
                      
                      
                      
                      [request setValue:@"Basic YWxleGV5bUBpa3Jvay5uZXQ6cXdhbnRpa28=" forHTTPHeaderField:@"Authorization"];
                      [request setValue:@"A69A850F-08F3-4984-A50F-3FC374C37877" forHTTPHeaderField:@"Api-Key"];
                      
                      //NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                      
                      // show in the status bar that network activity is starting
                      //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                      //[urlConnection start];
                      
                      /*
                       ********************************
                       */
                      
                      //AFHTTPRequestOperation
                      NSIndexSet *codes = [AFHTTPRequestOperation acceptableStatusCodes];
                      
                      //AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
                      AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                      [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
                          
                          NSHTTPURLResponse *resp = operation.response;
                          NSLog(@"setCompletionBlockWithSuccess");
                          
                          NSDictionary *allHeaderFields = [resp allHeaderFields];
                          
                          NSData *responseData = operation.responseData;
                          /*
                          // process response
                          NSError* error = [weakSelf validateJSONRequestResponse:JSON path:path];
                          if(nil == error && success)
                          {
                              success(JSON);
                          }
                          else if(error && failure)
                          {
                              failure(error, JSON);
                          }
                           */
                          
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                       {
                           NSLog(@"failure");
                           /*
                           NSDictionary *response = nil;
                           NSLog(@"code = %d", [operation.response statusCode]);
                           if (operation.response)
                           {
                               // start autologin
                               response = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[operation.response statusCode]] forKey:@"OperationResponseCode"];
                           }
                           
                           if(failure)
                           {
                               failure(error, response);
                           }
                           */
                           
                           NSLog(@"failure");
                       }];
                      
                      // start operation
                      [operation start];

                      
                      
                  } failure:^(NSError *error, NSDictionary* response)
                  {
                      NSNumber *codeNumber = [response objectForKey:@"OperationResponseCode"];
                      
                      NSLog(@"codeNumber = %d", [codeNumber intValue]);
                      
                      if ([codeNumber intValue] == 403)
                      {
                          NSLog(@"failed, %@", error.description);
                      }
                  }];
             }
         }
         
         NSLog(@"failed, %@", error.description);
     }];
    
#endif
}




// register to server
-(void) registerRequest
{
    // check if all information populated
    if (myInfo && fleetInfo && security)
    {
        // get server request manager instance
        ServerRequestManager *requestManager = [ServerRequestManager sharedInstance];
        
        // path
        static NSString* const path = @"registration/1/1/0/am/WebEmulator";
        
        // params
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.providerCode, @"provider_id",
                                self.accountID, @"provider_account_id",
                                @"0", @"provider_subaccount_id",
                                self.vipNumber, @"profile_id",
                                self.email, @"username",
                                self.password, @"password",
                                self.email, @"email_address",
                                self.firstName, @"first_name",
                                self.lastName, @"last_name",
                                @"WebEmulator", @"device_token",
                                self.mobileNumber, @"phone_number",
                                @"Emulator", @"platform_name",
                                @"0.2", @"platform_version",
                                nil];
        
        [requestManager request:path method:@"POST" params:params success:^(NSDictionary* response)
         {
             NSDictionary* resultDict = [response objectForKey:@"Response"];
             NSLog(@"resultDict = %@", resultDict);
             
         } failure:^(NSError *error, NSDictionary* response)
         {
             NSLog(@"failure");
         }];
    }
    else
    {
        // error
    }
}





-(IBAction)fleetInfoBtnHandler:(id)sender
{
    // show required animation
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // show active view
                         self.middleView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // top
                                              self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 300,
                                                                              self.topView.frame.size.width, self.topView.frame.size.height);
                                              
                                              
                                              self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 300,
                                                                                 self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              // push fleet info screen
                                              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                              
                                              FleetInfoViewController *fleetViewController = (FleetInfoViewController*)[mainStoryboard
                                                                                                                        instantiateViewControllerWithIdentifier: @"FleetInfoViewController"];
                                              fleetViewController.regisrationController = self;
                                              
                                              [self.navigationController pushViewController:fleetViewController animated:FALSE];
                                          }];
                     }];
}



-(IBAction)myInfoBtnHandler:(id)sender
{
    // show required animation
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // show active view
                         self.middleView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // top
                                              self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 300,
                                                                              self.topView.frame.size.width, self.topView.frame.size.height);
                                              
                                              
                                              self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 300,
                                                                                 self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              // push fleet info screen
                                              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                              
                                              MyInfoViewController *myInfoViewController = (MyInfoViewController*)[mainStoryboard
                                                                                                                        instantiateViewControllerWithIdentifier: @"MyInfoViewController"];
                                              myInfoViewController.regisrationController = self;
                                              
                                              
                                              [self.navigationController pushViewController:myInfoViewController animated:FALSE];
                                          }];
                     }];
}




-(IBAction)securityBtnHandler:(id)sender
{
    // show required animation
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // show active view
                         self.middleView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         
                         // show active area
                         [UIView animateWithDuration:0.5
                                               delay:0.5
                                             options: UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              // top
                                              self.topView.frame = CGRectMake(self.topView.frame.origin.x, self.topView.frame.origin.y - 300,
                                                                              self.topView.frame.size.width, self.topView.frame.size.height);
                                              
                                              
                                              self.bottomView.frame = CGRectMake(self.bottomView.frame.origin.x, self.bottomView.frame.origin.y + 300,
                                                                                 self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              // push security info screen
                                              UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                              
                                              SecurityOptionsViewController *securityViewController = (SecurityOptionsViewController*)[mainStoryboard
                                                                                                                   instantiateViewControllerWithIdentifier: @"SecurityOptionsViewController"];
                                              
                                              securityViewController.regisrationController = self;
                                              
                                              
                                              [self.navigationController pushViewController:securityViewController animated:FALSE];
                                          }];
                     }];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    NSLog(@"response %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", dataString);
    
    if ([dataString isEqualToString:@"true"])
    {
        // subscribe for push-notifications
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults valueForKey:@"token"];
        
        if (!token)
        {
            token = @"emulatorTestToken";
        }
        
        // path
        static NSString* const path = @"https://dev-clientapi.sedanmagic.com/pushnotification/1/1/0/am/WebEmulator";
        
        NSData *postData = [token dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        
        [request setHTTPMethod:@"PUT"];
        
        [request setValue:@"Basic YWxleGV5bUBpa3Jvay5uZXQ6cXdhbnRpa28=" forHTTPHeaderField:@"Authorization"];
        [request setValue:@"A69A850F-08F3-4984-A50F-3FC374C37877" forHTTPHeaderField:@"Api-Key"];
        
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"text/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [conn start];
        
        // go to booking screen
        [self performSegueWithIdentifier:@"RegistrationToBooking" sender:nil];
    }
    else
    {
        // show required message to user
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // show required message to user
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
