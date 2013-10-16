//
//  RepositoryManager.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "RepositoryManager.h"
@interface RepositoryManager()
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@end

@implementation RepositoryManager
//@synthesize applicationDocumentsDirectory, managedObjectModel, persistentStoreCoordinator;

static RepositoryManager *sharedInstance = nil;
+ (RepositoryManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[RepositoryManager alloc] init];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Database.sqlite"]];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        NSLog(@"An error occured in the persistentStoreCoordinator Method: %@", error);
    }
    
    return persistentStoreCoordinator;
}
-(BOOL)commitContext
{
	NSError *error = nil;
	if (![[self managedObjectContext] save:&error]) {
		// Save failed
		NSLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
		return NO;
	}
	return YES;
}

-(void)rollbackContext
{
	NSManagedObjectContext *moc = [self managedObjectContext];
	[moc rollback];
}
-(void)deleteManagedObjectFromContext:(NSManagedObject*)managedObject
{
	[[self managedObjectContext] deleteObject:managedObject];
}
- (id)insertAndGetNewObjectForEntityForName:(NSString *)entityName
{
    return [NSEntityDescription
            insertNewObjectForEntityForName:entityName
            inManagedObjectContext:[self managedObjectContext]];
    
}
#pragma mark - Fetch Methods
- (NSMutableArray*)fetchArrayFromDBWithEntity:(NSString*)entityName forKey:(NSString*)keyName withPredicate:(NSPredicate*)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:keyName ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    if (predicate != nil)
        [request setPredicate:predicate];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"%@", error);
    }
    return mutableFetchResults;
}

#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}
@end
