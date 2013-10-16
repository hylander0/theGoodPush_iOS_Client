//
//  Alerts+Extensions.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RepositoryManager.h"
#import "Alerts.h"
#import "AlertsModel.h"
#import "Constants.h"

@interface Alerts(Extensions)


+(Alerts*)  AddAlertWithId:(NSString*)Id
                 alertName:(NSString*)name
                  AlertMsg:(NSString*)msg
           AlertImportance:(NSNumber*)importance
                  AlertDtm:(NSDate*)dtm
                    Source:(NSString*)src;
//+(Alerts*) SyncAlertAgaintRepoWithItems:(NSString*)Id
//                              alertName:(NSString*)name
//                               AlertMsg:(NSString*)msg
//                        AlertImportance:(NSNumber*)importance
//                               AlertDtm:(NSDate*)dtm
//                                 Source:(NSString*)src;

+(void) ClearAllAlerts;
+(Alerts*)GetAlertWithId:(NSString*)Id;
+(void)SyncSvcAlertsWithRepo:(NSArray*)alerts;

@end
