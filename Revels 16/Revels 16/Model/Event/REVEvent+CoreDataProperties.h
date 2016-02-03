//
//  REVEvent+CoreDataProperties.h
//  Revels 16
//
//  Created by Avikant Saini on 2/3/16.
//  Copyright © 2016 LUG. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "REVEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface REVEvent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *eid;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *maxTeamNo;
@property (nullable, nonatomic, retain) NSString *categoryName;
@property (nullable, nonatomic, retain) NSString *catID;
@property (nullable, nonatomic, retain) NSString *venue;
@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSDate *endDate;
@property (nullable, nonatomic, retain) NSString *day;
@property (nullable, nonatomic, retain) NSString *contactName;
@property (nullable, nonatomic, retain) NSString *contactPhone;
@property (nullable, nonatomic, retain) NSNumber *favourite;

@end

NS_ASSUME_NONNULL_END
