//
//  Alerts.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Alerts : NSManagedObject

@property (nonatomic, retain) NSDate * alert_dtm;
@property (nonatomic, retain) NSString * alert_id;
@property (nonatomic, retain) NSNumber * alert_importance;
@property (nonatomic, retain) NSString * alert_msg;
@property (nonatomic, retain) NSString * alert_name;
@property (nonatomic, retain) NSString * alert_source;

@end
