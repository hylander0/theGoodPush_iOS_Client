//
//  RepositoryManager.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface RepositoryManager : NSObject
+ (id)sharedInstance;

- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate;
- (id)insertAndGetNewObjectForEntityForName:(NSString *)entityName;


-(BOOL)commitContext;
-(void)rollbackContext;
-(void)deleteManagedObjectFromContext:(NSManagedObject*)managedObject;

@end
