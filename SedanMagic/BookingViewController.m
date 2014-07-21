//
//  BookingViewController.m
//  SedanMagic
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "BookingViewController.h"
#import "ServerRequestController.h"

@interface BookingViewController ()

@end

@implementation BookingViewController

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
    
    // path
    static NSString* const path = @"reservation/1/1/0/am";
    
    ServerRequestController *requestController = [ServerRequestController sharedInstance];
    [requestController request:path method:@"GET" params:nil success:^(NSDictionary* response)
     {
         NSLog(@"success");
         
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
