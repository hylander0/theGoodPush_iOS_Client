//
//  GoodPushApiMapper.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "GoodPushApiMapper.h"

@implementation GoodPushApiMapper

+(AlertsModel*)mapAlertsDataToModel:(NSDictionary*)data
{
    //2013-08-27T00:00:00
    AlertsModel *retval = [[AlertsModel alloc] init];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    if([data objectForKey:@"Id"] != (id)[NSNull null])
        retval.AlertId = [[data objectForKey:@"Id"] intValue];
    if([data objectForKey:@"Name"] != (id)[NSNull null])
        retval.AlertName = [data objectForKey:@"Name"];
    if([data objectForKey:@"Msg"] != (id)[NSNull null])
        retval.AlertMsg = [data objectForKey:@"Msg"];
    if([data objectForKey:@"Dtm"] != (id)[NSNull null])
        retval.AlertDtm = [f dateFromString:[data objectForKey:@"Dtm"]];
    if([data objectForKey:@"Importance"] != (id)[NSNull null])
        retval.Importance = [[data objectForKey:@"Importance"] intValue];
    return retval;
}
+(MessagesModel*)mapMessagesDataToModel:(NSDictionary*)data
{
    MessagesModel *retval = [[MessagesModel alloc] init];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    if([data objectForKey:@"Id"] != (id)[NSNull null])
        retval.Id = [[data objectForKey:@"Id"] intValue];
    if([data objectForKey:@"Name"] != (id)[NSNull null])
        retval.Name = [data objectForKey:@"Name"];
    if([data objectForKey:@"Msg"] != (id)[NSNull null])
        retval.Msg = [data objectForKey:@"Msg"];
    if([data objectForKey:@"Dtm"] != (id)[NSNull null])
        retval.Dtm = [f dateFromString:[data objectForKey:@"Dtm"]];
    
    return retval;
}
+(DeviceSetting*)mapDeviceSettingDataToModel:(NSDictionary*)data
{
    DeviceSetting *retval = [[DeviceSetting alloc] init];
    
    
    if([data objectForKey:@"DeviceToken"] != (id)[NSNull null])
        retval.DeviceToken = [data objectForKey:@"DeviceToken"];
    if([data objectForKey:@"Alias"] != (id)[NSNull null])
        retval.Alias = [data objectForKey:@"Alias"];
    if([data objectForKey:@"IsPushEnabled"] != (id)[NSNull null])
        retval.IsPushEnabled = [[data objectForKey:@"IsPushEnabled"] boolValue];
    if([data objectForKey:@"IsSoundEnabled"] != (id)[NSNull null])
        retval.IsSoundEnabled = [[data objectForKey:@"IsSoundEnabled"] boolValue];
    
    return retval;

}
@end
