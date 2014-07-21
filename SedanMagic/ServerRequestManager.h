//
//  ServerRequestManager.h
//  SedanMagic
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import <Foundation/Foundation.h>


// success/failure callbacks
typedef void (^RequestSuccessCallback)(NSDictionary* response);
typedef void (^RequestFailureCallback)(NSError *error, NSDictionary* response);


@interface ServerRequestManager : NSObject


// base url
@property (nonatomic, copy) NSString* baseURL;

@property (readwrite, nonatomic, strong) NSMutableDictionary *defaultHeaders;

// singleton instance
+ (ServerRequestManager*)sharedInstance;


//  set auth default header
- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;

-(void) addDefaultHeader:(NSString *)headerFieldName value: (NSString *) value;


// request to server
-(void) request: (NSString*)path
         method:(NSString*)method
         params:(NSDictionary*)params
        success:(RequestSuccessCallback)success
        failure:(RequestFailureCallback)failure;



@end
