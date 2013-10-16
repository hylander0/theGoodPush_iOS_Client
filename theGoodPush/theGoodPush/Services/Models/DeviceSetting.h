//
//  DeviceSettings.h
//  theGoodPush
//
//  Created by Justin Hyland on 9/24/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceSetting : NSObject
{

}

@property (nonatomic, strong) NSString *DeviceToken;
@property (nonatomic, strong) NSString *Alias;
@property BOOL IsPushEnabled;
@property BOOL IsSoundEnabled;


- (NSDictionary*) proxyForJson;
@end
