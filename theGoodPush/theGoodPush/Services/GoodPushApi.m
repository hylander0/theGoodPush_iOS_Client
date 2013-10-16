//
//  GoodPushApi.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "GoodPushApi.h"

@implementation GoodPushApi
{
    id delegate;
    
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
    SBJsonParser *jsonParser;
    NSString *endpointUrl;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        jsonParser = [[SBJsonParser alloc] init];
        //Add endpoint URL here (ie: http://www.yourDomain.com/ApiSvc )
        endpointUrl = @"";
    }
    return self;
}
-(void)setDelegate:(id)aDelegate { delegate = aDelegate; }


-(void)getAllAlerts
{
    HTTPConnection *connHelper = [[HTTPConnection alloc] initWithServiceEndpointUrl:endpointUrl];
    [connHelper setDelegate:self];
    [connHelper processNSConnectionRequest:@"Alerts/GetAllAlerts" Method:@"GET"];
}
-(void)removeAllAlerts
{
    HTTPConnection *connHelper = [[HTTPConnection alloc] initWithServiceEndpointUrl:endpointUrl];
    [connHelper setDelegate:self];
    [connHelper processNSConnectionRequest:@"Alerts/RemoveAllAlerts" Method:@"GET"];
}
-(void)getAllMessages
{
    HTTPConnection *connHelper = [[HTTPConnection alloc] initWithServiceEndpointUrl:endpointUrl];
    [connHelper setDelegate:self];
    [connHelper processNSConnectionRequest:@"Messages/GetAllMessages" Method:@"GET"];
}
-(void)getDeviceSettingWithDeviceToken:(NSString*)token Alias:(NSString*)alias
{
    HTTPConnection *connHelper = [[HTTPConnection alloc] initWithServiceEndpointUrl:endpointUrl];
    [connHelper setDelegate:self];
    NSDictionary *parms = [[NSDictionary alloc] initWithObjectsAndKeys:token, @"deviceToken", alias, @"alias", nil];
    
    [connHelper processNSConnectionRequest:@"Settings/GetDeviceSetting" Method:@"GET"  Parms:parms];
}
-(void)setDeviceSettingWithSetting:(DeviceSetting*)setting
{
    HTTPConnection *connHelper = [[HTTPConnection alloc] initWithServiceEndpointUrl:endpointUrl];
    [connHelper setDelegate:self];

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *httpPoststr = [jsonWriter stringWithObject:setting];
    [connHelper processNSConnectionRequest:@"Settings/SetDeviceSetting"
                                    Method:@"POST"
                                     Parms:nil
                                  PostData:[httpPoststr dataUsingEncoding:NSUTF8StringEncoding]
     ];
    
}


#pragma mark - Connection Handler Delegates

- (void)responseReceivedWithHandler:(HTTPConnection*)handler Response:(NSURLResponse *)response
{
    NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
    NSString *responseCode = CONSTANTS_HTTPCONNECTION_RESPONSE_TYPE_FAILURE;

    if(statusCode == 200)
        responseCode = CONSTANTS_HTTPCONNECTION_RESPONSE_TYPE_SUCCESS;
    
    
    if([handler.action isEqualToString:@"Alerts/RemoveAllAlerts"])
    {
        if([delegate respondsToSelector:@selector(removeAllAlertsWithHandler:ResponseCode:)])
            [delegate removeAllAlertsWithHandler:self ResponseCode:responseCode];

    }
    else if([handler.action isEqualToString:@"Settings/SetDeviceSetting"])
    {
        if([delegate respondsToSelector:@selector(setDeviceSettingWithHandler:IsSuccessful:)])
            [delegate setDeviceSettingWithHandler:self IsSuccessful:(statusCode >= 200 && statusCode < 300)];
    }
}

- (void)dataReceivedWithHandler:(HTTPConnection*)handler Data:(NSData *)data
{
    //NSLog(@"dataReceivedWithHandler data: %@", [NSString stringWithUTF8String: data.bytes]);
    if([handler.action isEqualToString:@"Alerts/GetAllAlerts"])
    {
        NSArray *a = [jsonParser objectWithData:data];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSDictionary *i in a)
        {
            [items addObject:[GoodPushApiMapper mapAlertsDataToModel:i]];
        }
        
        //NSLog(@"GetAllAlerts count: %i", items.count);
        if([delegate respondsToSelector:@selector(getAlertsWithHandler:Alerts:)])
            [delegate getAlertsWithHandler:self Alerts:items];
    }
    else if([handler.action isEqualToString:@"Messages/GetAllMessages"])
    {
        NSArray *a = [jsonParser objectWithData:data];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSDictionary *i in a)
        {
            [items addObject:[GoodPushApiMapper mapMessagesDataToModel:i]];
        }
        
        //NSLog(@"GetAllMessages count: %i", items.count);
        if([delegate respondsToSelector:@selector(getAllMessagesWithHandler:Messages:)])
            [delegate getAllMessagesWithHandler:self Messages:items];
        
    }
    else if([handler.action isEqualToString:@"Settings/GetDeviceSetting"])
    {
        NSDictionary *d = [jsonParser objectWithData:data];
        DeviceSetting *setting = [[DeviceSetting alloc] init];
        setting = [GoodPushApiMapper mapDeviceSettingDataToModel:d];
        
    
        if([delegate respondsToSelector:@selector(getDeviceSettingWithHandler:Setting:)])
            [delegate getDeviceSettingWithHandler:self Setting:setting];
    }
}


@end
