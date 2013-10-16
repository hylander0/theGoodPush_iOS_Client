//
//  HTTPConnection.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "HTTPConnection.h"

@implementation HTTPConnection
{
    NSURLConnection *theConnection;
    NSString *action;
    NSMutableData *dataReceived;
    id<HTTPConnectionDelegate> delegate;
    NSString *endpoint;
}

@synthesize action;
-(id)init
{
    @throw [NSException exceptionWithName:@"HTTPConnection"
                                   reason:@"HTTPConnection requires Endpoint Url.  Please use initWithServiceEndpointUrl for init."
                                 userInfo:nil];
    return nil;
}
-(id)initWithServiceEndpointUrl:(NSString*)url
{
    self = [super init];
    if(self)
    {
        endpoint = url;
    }
    return self;
}

-(void)setDelegate:(id<HTTPConnectionDelegate>)aDelegate
{
    delegate = aDelegate;
}
-(NSURLConnection*)processNSConnectionRequest:(NSString *)url
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:url]];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    return theConnection;
}
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod
{
    return [self processNSConnectionRequest:Action Method:HTTPMethod Parms:nil];
}
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod Parms:(NSDictionary*)parms
{
    return [self processNSConnectionRequest:Action Method:HTTPMethod Parms:parms PostData:nil];
}
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod Parms:(NSDictionary*)parms PostData:(NSData*)postData
{
    action = Action;

    NSMutableString *url = [NSMutableString stringWithFormat:@"%@/%@",endpoint, Action];
    
    if(parms != nil)
    {
        [url appendString:@"?"];
        for (NSString* key in parms) {
            id value = [parms objectForKey:key];
            [url appendFormat:@"%@=%@&",key,value];
        }
        [url replaceCharactersInRange:NSMakeRange([url length]-1, 1) withString:@""];
        
        
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[url
                                                                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if(postData != nil)
    {
        [request setHTTPBody:postData];
        [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    }
    [request addValue:@"application/json" forHTTPHeaderField: @"Accept"];
    [request setHTTPMethod:HTTPMethod];
    
    dataReceived = [[NSMutableData alloc] init];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    NSLog(@"NSURLConnection started with action: %@", Action);
    return theConnection;
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [delegate responseReceivedWithHandler:self Response:response];
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    
    switch (statusCode) {
        case 200:
            //TODO: Set model from response
            break;
        default:
        {
        }
            break;
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError Error: %@", error);
    [delegate dataReceivedWithHandler:self Data:nil];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataReceived appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [delegate dataReceivedWithHandler:self Data:dataReceived];
}
@end
