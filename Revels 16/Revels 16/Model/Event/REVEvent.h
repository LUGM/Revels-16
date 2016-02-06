//
//  REVEvent.h
//  Revels 16
//
//  Created by Avikant Saini on 2/3/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface REVEvent : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic, readwrite) BOOL isFavourite;

@property (nonatomic, readonly) NSString *dateString;
@property (nonatomic, readonly) NSString *timeString;

+ (REVEvent *)createNewEventWithDict:(id)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray <REVEvent *> *)getEventsFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (NSMutableArray <REVEvent *> *)eventsAfterUpdatingScheduleFromJSONData:(id)data inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "REVEvent+CoreDataProperties.h"
