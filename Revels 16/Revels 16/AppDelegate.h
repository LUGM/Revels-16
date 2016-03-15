//
//  AppDelegate.h
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 LUGM. All rights reserved.
//

// To get help with the project contact iOS developers Avikant (avikantsainidbz@gmail.com) or Yash (yklal95@gmail.com).

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (NSManagedObjectContext *)managedObjectContext;

@end

