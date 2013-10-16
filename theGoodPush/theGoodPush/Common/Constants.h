//
//  Constants.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
extern NSString * const CONSTANTS_ALERT_SOURCE_TYPE_API;
extern NSString * const CONSTANTS_ALERT_SOURCE_TYPE_NOTIFICATION;

extern NSString * const CONSTANTS_HTTPCONNECTION_RESPONSE_TYPE_SUCCESS;
extern NSString * const CONSTANTS_HTTPCONNECTION_RESPONSE_TYPE_FAILURE;

extern NSString * const CONSTANTS_NOTIFICATION_NAME_DID_RECEIVE_REMOTE_NOTIFICATION;

extern BOOL const CONSTANTS_IS_URBAN_AIRSHIP_IN_USE;
@end
