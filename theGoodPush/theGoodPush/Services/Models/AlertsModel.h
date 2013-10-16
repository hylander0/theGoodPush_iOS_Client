//
//  AlertsModel.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertsModel : NSObject

@property NSInteger AlertId;
@property (nonatomic, strong) NSString *AlertName;
@property (nonatomic, strong) NSString *AlertMsg;
@property (nonatomic, strong) NSDate *AlertDtm;
@property NSInteger Importance;

@end
