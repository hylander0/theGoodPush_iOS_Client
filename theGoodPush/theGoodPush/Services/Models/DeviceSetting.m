//
//  DeviceSettings.m
//  theGoodPush
//
//  Created by Justin Hyland on 9/24/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "DeviceSetting.h"

@implementation DeviceSetting

- (NSDictionary*) proxyForJson {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:self.DeviceToken, @"DeviceToken",
            self.Alias, @"Alias",
            [NSNumber numberWithBool:self.IsPushEnabled], @"IsPushEnabled",
            [NSNumber numberWithBool:self.IsSoundEnabled], @"IsSoundEnabled",
            nil];
    
}
@end
