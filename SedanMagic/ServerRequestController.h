//
//  ServerController.h
//  SedanMagic
//
//  Created by user on 7/10/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <Foundation/Foundation.h>

// success/failure callbacks
typedef void (^JSONRequestSuccessCallback)(NSDictionary* response);
typedef void (^JSONRequestFailureCallback)(NSError *error, NSDictionary* response);

@interface ServerRequestController : NSObject

// base url
@property (nonatomic, copy) NSString* baseURL;

/// get singleton instance
+ (ServerRequestController*) sharedInstance;

// json url request
- (void)request:(NSString*)path
         method:(NSString*)method
         params:(NSDictionary*)params
        success:(JSONRequestSuccessCallback)success
        failure:(JSONRequestFailureCallback)failure;

@end
