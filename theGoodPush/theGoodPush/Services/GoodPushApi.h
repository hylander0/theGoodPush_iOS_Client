//
//  GoodPushApi.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnection.h"
#import "SBJson.h"
#import "GoodPushApiMapper.h"

#import "DeviceSetting.h"

@interface GoodPushApi : NSObject <HTTPConnectionDelegate>
-(void)setDelegate:(id)aDelegate;


-(void)getAllAlerts;
-(void)removeAllAlerts;
-(void)getAllMessages;
-(void)getDeviceSettingWithDeviceToken:(NSString*)token Alias:(NSString*)alias;
-(void)setDeviceSettingWithSetting:(DeviceSetting*)setting;
@end


@interface GoodPushApi(GoodPushApiDelegates)

-(void)getAlertsWithHandler:(GoodPushApi*)handler Alerts:(NSArray*)alerts;
-(void)removeAllAlertsWithHandler:(GoodPushApi*)handler ResponseCode:(NSString*)code;
-(void)getAllMessagesWithHandler:(GoodPushApi*)handler Messages:(NSArray*)msgs;

-(void)getDeviceSettingWithHandler:(GoodPushApi*)handler Setting:(DeviceSetting*)setting;
-(void)setDeviceSettingWithHandler:(GoodPushApi*)handler IsSuccessful:(BOOL)isSuccess;
@end
