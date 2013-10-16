//
//  GoodPushApiMapper.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertsModel.h"
#import "MessagesModel.h"
#import "DeviceSetting.h"

@interface GoodPushApiMapper : NSObject

+(AlertsModel*)mapAlertsDataToModel:(NSDictionary*)data;
+(MessagesModel*)mapMessagesDataToModel:(NSDictionary*)data;
+(DeviceSetting*)mapDeviceSettingDataToModel:(NSDictionary*)data;
@end
