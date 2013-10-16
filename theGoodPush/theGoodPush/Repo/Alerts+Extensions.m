//
//  Alerts+Extensions.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "Alerts+Extensions.h"

@implementation Alerts(Extensions)

#define Repository_ALERTS_ADDED_ALERT @"Repository_ALERTS_ADDED_ALERT"
#define Repository_ALERTS_CLEARED_ALERT @"Repository_ALERTS_CLEARED_ALERT"

#pragma mark - Add Methods
+(Alerts*)  AddAlertWithId:(NSString*)Id
                 alertName:(NSString*)name
                  AlertMsg:(NSString*)msg
           AlertImportance:(NSNumber*)importance
                  AlertDtm:(NSDate*)dtm
                    Source:(NSString*)src

{
    Alerts *retval = (Alerts *)[NSEntityDescription
                            insertNewObjectForEntityForName:@"Alerts"
                                     inManagedObjectContext:[[RepositoryManager sharedInstance] managedObjectContext]
                                        ];
    
    retval.alert_id = Id;
    retval.alert_name = name;
    retval.alert_msg = msg;
    retval.alert_importance = importance;
    retval.alert_dtm = dtm;
    retval.alert_source = src;
    [[NSNotificationCenter defaultCenter] postNotificationName:Repository_ALERTS_ADDED_ALERT
                                                        object:retval];
    return retval;
}
+(Alerts*) SyncAlertAgaintRepoWithItems:(NSString*)Id
                           alertName:(NSString*)name
                            AlertMsg:(NSString*)msg
                     AlertImportance:(NSNumber*)importance
                            AlertDtm:(NSDate*)dtm
                              Source:(NSString*)src
{

    Alerts *itemToAdd = [Alerts GetAlertWithId:Id];
    if(itemToAdd == nil)
    {
        itemToAdd = [Alerts AddAlertWithId:Id alertName:name AlertMsg:msg AlertImportance:importance AlertDtm:dtm Source:src];
    }
    return itemToAdd;
}
+(void) ClearAllAlerts
{
   NSArray *alerts = [[RepositoryManager sharedInstance]
              fetchArrayFromDBWithEntity:@"Alerts"
              forKey:@"alert_dtm"
              withPredicate:nil
              ];
    
    for (Alerts *item in alerts) {
        [[[RepositoryManager sharedInstance] managedObjectContext] deleteObject:item];
    }
    [[RepositoryManager sharedInstance] commitContext];
    [[NSNotificationCenter defaultCenter] postNotificationName:Repository_ALERTS_CLEARED_ALERT
                                                        object:nil];
}
+(Alerts*)GetAlertWithId:(NSString*)Id
{
    Alerts *retval;
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Alerts"
                                                  inManagedObjectContext:[[RepositoryManager sharedInstance] managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(alert_id = %@)", Id];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [[[RepositoryManager sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    
    if ([objects count] != 0)
    {
        retval = [objects objectAtIndex:0];
        //NSLog(@"GetAlertWithId found");
    }
    return retval;

}

+(void)SyncSvcAlertsWithRepo:(NSArray*)alerts
{
    [alerts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        AlertsModel *item = ((AlertsModel*)obj);
        [Alerts SyncAlertAgaintRepoWithItems:[NSString stringWithFormat:@"%d", item.AlertId]
                                   alertName:item.AlertName
                                    AlertMsg:item.AlertMsg
                             AlertImportance:[NSNumber numberWithInt:item.Importance]
                                    AlertDtm:item.AlertDtm
                                      Source:CONSTANTS_ALERT_SOURCE_TYPE_API];
    }];

}
@end
