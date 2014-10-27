//
//  TLCoreDataStack.h
//  ToDoList
//
//  Created by Taylor Ledingham on 2014-10-25.
//  Copyright (c) 2014 Taylor Ledingham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TLCoreDataStack : NSObject

+(instancetype)defaultStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
