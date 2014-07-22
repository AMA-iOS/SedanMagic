//
//  ServerRequestManager.m
//  SedanMagic
//
//  Created by user on 7/15/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "ServerRequestManager.h"
#import "AFNetworking.h"


#define CONTENT_TYPE_JSON  @"application/json"

// response codes

// User is registered
#define OPERATION_STATUS_CODE_LOGGED_IN (200)

// User is registered
#define OPERATION_STATUS_CODE_REGISTERED (201)

// Authentication error
#define OPERATION_STATUS_CODE_AUTH_ERROR (401)

// User is registered (but not active)
#define OPERATION_STATUS_CODE_USER_NOT_ACTIVE (403)

// The account user was not found
#define OPERATION_STATUS_CODE_USER_NOT_FOUND (404)

// The device is already registered for this user. Trigger auto login
#define OPERATION_STATUS_CODE_ALREADY_REGISTERED (409)

// Server error
#define OPERATION_STATUS_CODE_SERVER_ERROR (500)


@interface ServerRequestManager()


@end



static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}



@implementation ServerRequestManager

@synthesize baseURL = m_baseURL;

+ (ServerRequestManager*)sharedInstance
{
    static dispatch_once_t s_once;
    static ServerRequestManager* s_sharedInstance;
    dispatch_once(&s_once, ^{
        s_sharedInstance = [[self alloc] init];
    });
    return s_sharedInstance;
}


- (id)init
{
    if(self = [super init])
    {
        // add accepted status codes
        NSMutableIndexSet *statusCodesSet = [[NSMutableIndexSet alloc] init];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_LOGGED_IN];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_AUTH_ERROR];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_ALREADY_REGISTERED];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_REGISTERED];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_SERVER_ERROR];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_USER_NOT_ACTIVE];
        [statusCodesSet addIndex:OPERATION_STATUS_CODE_USER_NOT_FOUND];
        
        [AFHTTPRequestOperation addAcceptableStatusCodes:statusCodesSet];
        
        self.defaultHeaders = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}


// set base url
- (void)setBaseURL:(NSString *)baseURL
{
    if(NO == [m_baseURL isEqualToString:baseURL])
    {
        m_baseURL = baseURL;
    }
}



// add auth header
- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password {
	NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    
    [self addDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)]];
}



-(void) addDefaultHeader:(NSString *)headerFieldName value: (NSString *) value
{
    // check and add
    if (headerFieldName && value) {
        [self.defaultHeaders setObject:value forKey:headerFieldName];
    }
}



-(void) request: (NSString*)path
                method:(NSString*)method
                params:(NSDictionary*)params
               success:(RequestSuccessCallback)success
               failure:(RequestFailureCallback)failure
{
    // Create the request.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.baseURL, path]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60.0];
    
    // set request method
    [request setHTTPMethod:method];

    // set default headers
    [request setAllHTTPHeaderFields:self.defaultHeaders];
    
    
    // set params
    if (params)
    {
        if ([method isEqualToString:@"GET"] || [method isEqualToString:@"HEAD"] || [method isEqualToString:@"DELETE"])
        {
            url = [NSURL URLWithString:[[url absoluteString] stringByAppendingFormat:[path rangeOfString:@"?"].location == NSNotFound ? @"?%@" : @"&%@", AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding)]];
            [request setURL:url];
        }
        else
        {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            NSError *error = nil;
            
            
            switch (AFJSONParameterEncoding)//self.parameterEncoding)
            {
                case AFFormURLParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding/*self.stringEncoding*/) dataUsingEncoding:NSUTF8StringEncoding/*self.stringEncoding*/]];
                    break;
                case AFJSONParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:&error]];
                    break;
                case AFPropertyListParameterEncoding:;
                    [request setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
                    [request setHTTPBody:[NSPropertyListSerialization dataWithPropertyList:params format:NSPropertyListXMLFormat_v1_0 options:0 error:&error]];
                    break;
            }
            
            if (error) {
                NSLog(@"%@ %@: %@", [self class], NSStringFromSelector(_cmd), error);
            }
        }
    }
    
    
    // create operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON)
    {
        // get operation response
        NSHTTPURLResponse *resp = operation.response;
        NSLog(@"setCompletionBlockWithSuccess");
        
        NSLog(@"code = %d", [operation.response statusCode]);
        
        
        // switch by status code
        switch ([resp statusCode])
        {
            case OPERATION_STATUS_CODE_LOGGED_IN:
            {
                NSLog(@"OPERATION_STATUS_CODE_LOGGED_IN");
            }
                break;
                
            case OPERATION_STATUS_CODE_AUTH_ERROR:
            {
                NSLog(@"OPERATION_STATUS_CODE_AUTH_ERROR");
            }
                break;
                
            case OPERATION_STATUS_CODE_ALREADY_REGISTERED:
            {
                NSLog(@"OPERATION_STATUS_CODE_ALREADY_REGISTERED");
            }
                break;
                
            case OPERATION_STATUS_CODE_REGISTERED:
            {
                NSLog(@"OPERATION_STATUS_CODE_REGISTERED");
            }
                break;
                
            case OPERATION_STATUS_CODE_SERVER_ERROR:
            {
                NSLog(@"OPERATION_STATUS_CODE_SERVER_ERROR");
            }
                break;
                
            case OPERATION_STATUS_CODE_USER_NOT_ACTIVE:
            {
                NSLog(@"OPERATION_STATUS_CODE_USER_NOT_ACTIVE");
            }
                break;
                
            case OPERATION_STATUS_CODE_USER_NOT_FOUND:
            {
                NSLog(@"OPERATION_STATUS_CODE_USER_NOT_FOUND");
            }
                break;
                
            default:
            {
                NSLog(@"Error. Unexpected status code");
            }
                break;
        }
        
        
        // get headers dictionary
        NSDictionary *allHeaderFields = [resp allHeaderFields];
        
        // check content type and length
        NSString *contentType = [allHeaderFields objectForKey:@"Content-Type"];
        
        // get response data if any
        NSData *responseData = nil;
        NSUInteger dataLength = [[allHeaderFields objectForKey:@"Content-Length"] integerValue];
        if (dataLength)
            responseData = operation.responseData;
        
        // parse type
        if ([contentType rangeOfString:CONTENT_TYPE_JSON].location != NSNotFound && responseData)
        {
            // validate and return
            NSString *dataString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", dataString);
            
            // get dict from data
            NSError* error = nil;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  
                                  options:kNilOptions 
                                  error:&error];
            
            if(nil == error && success)
            {
                success(json);
            }
            
        }
        else
        {
            NSLog(@"string does not contain required contentType");
        }
        
        
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
         NSLog(@"operation failure");
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
}



@end
