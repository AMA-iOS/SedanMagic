//
//  ServerController.m
//  SedanMagic
//
//  Created by user on 7/10/14.
//  Copyright (c) 2014 RideCharge. All rights reserved.
//

#import "ServerRequestController.h"
#import "AFNetworking.h"
#import "AFHTTPClient.h"
//#import "AFJSONRequestOperation.h"


@interface ServerRequestController ()
@property (nonatomic, strong) AFHTTPClient* jsonHttpClient;
@end



@implementation ServerRequestController


@synthesize baseURL = m_baseURL;


+ (ServerRequestController*)sharedInstance
{
    static dispatch_once_t s_once;
    static ServerRequestController* s_sharedInstance;
    dispatch_once(&s_once, ^{
        s_sharedInstance = [[self alloc] init];
    });
    return s_sharedInstance;
}

- (void)createAFNetworkingClients
{
    // create json client
    self.jsonHttpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:m_baseURL]];
    [self.jsonHttpClient setParameterEncoding:AFJSONParameterEncoding];
    [self.jsonHttpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // AuthorizationHeader
    [self.jsonHttpClient setAuthorizationHeaderWithUsername:@"alexeym@ikrok.net" password:@"qwantiko"];
    
    
    // Api-Key:A69A850F-08F3-4984-A50F-3FC374C37877
    [self.jsonHttpClient setDefaultHeader:@"Api-Key" value:@"A69A850F-08F3-4984-A50F-3FC374C37877"];
    
    
}

- (void)destroyAFNetworkingClients
{
    self.jsonHttpClient = nil;
}

- (id)init
{
    if(self = [super init])
    {
    }
    return self;
}

- (void)dealloc
{
    [self destroyAFNetworkingClients];
}


- (void)setBaseURL:(NSString *)baseURL
{
    if(NO == [m_baseURL isEqualToString:baseURL])
    {
        m_baseURL = baseURL;
        [self createAFNetworkingClients];
    }
}

- (NSError*)validateJSONRequestResponse:(id)JSON path:(NSString*)path
{
    NSDictionary* responseDict  = (NSDictionary*)JSON;
    
    // check it
    if([responseDict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:@"invalid response type" forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:path code:1 userInfo:details];
}




- (void)request:(NSString*)path
         method:(NSString*)method
         params:(NSDictionary*)params
        success:(JSONRequestSuccessCallback)success
        failure:(JSONRequestFailureCallback)failure
{
    [self request:path method:method params:params success:success failure:failure bufferOperation:YES];
}

- (void)request:(NSString*)path
         method:(NSString*)method
         params:(NSDictionary*)params
        success:(JSONRequestSuccessCallback)success
        failure:(JSONRequestFailureCallback)failure
bufferOperation:(BOOL)bufferOperation
{
    if(path && method)
    {
        __weak __typeof(self) weakSelf = self;
        NSMutableURLRequest *request = [self.jsonHttpClient requestWithMethod:method path:[NSString stringWithFormat:@"%@%@", self.baseURL, path] parameters:params];
        AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
            
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
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
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
            
        }];
        
        // start operation
        [operation start];
    }
}


@end
