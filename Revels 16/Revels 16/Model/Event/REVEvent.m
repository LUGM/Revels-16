//
//  REVEvent.m
//  Revels 16
//
//  Created by Avikant Saini on 2/3/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "REVEvent.h"

@implementation REVEvent

// Insert code here to add functionality to your managed object subclass

- (BOOL)isFavourite {
	return [self.favourite boolValue];
}

- (void)setIsFavourite:(BOOL)isFavourite {
	self.favourite = [NSNumber numberWithBool:isFavourite];
}

- (NSString *)dateString {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"EEE, MMM dd"];
	return [formatter stringFromDate:self.startDate];
}

- (NSString *)timeString {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"hh:mm aa"];
	NSString *timeString = [[NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:self.startDate], [formatter stringFromDate:self.endDate]] uppercaseString];
	return timeString;
}

+ (REVEvent *)createNewEventWithDict:(id)dict inEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	REVEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"REVEvent" inManagedObjectContext:context];
	
	if (dict && [dict isKindOfClass:[NSDictionary class]]) {
		
		@try {
			event.uid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
			event.name = [NSString stringWithFormat:@"%@", dict[@"ename"]];
			event.eid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
			event.detail = [NSString stringWithFormat:@"%@", dict[@"edesc"]];
			event.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"emaxteamsize"]];
			event.categoryName = [NSString stringWithFormat:@"%@", dict[@"cname"]];
			event.catID = [NSString stringWithFormat:@"%@", dict[@"cid"]];
			event.isFavourite = NO;
			event.contactName = [NSString stringWithFormat:@"%@", dict[@"cntctname"]];
			event.contactPhone = [NSString stringWithFormat:@"%@", dict[@"cntctno"]];
			event.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
		}
		@catch (NSException *exception) {
			NSLog(@"Event parsing error: %@", exception.reason);
		}
	
	}
	
	return event;
}

+ (NSMutableArray<REVEvent *> *)getEventsFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSMutableArray <REVEvent*> *events = [NSMutableArray new];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	NSError *error;
	NSArray *fetchedEvents = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	if (data && [data isKindOfClass:[NSArray class]]) {
		for (id dict in data) {
			
			if (dict && [dict isKindOfClass:[NSDictionary class]]) {
			
				NSString *eid, *cid;
				
				@try {
					eid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
					cid = [NSString stringWithFormat:@"%@", dict[@"cid"]];
				}
				@catch (NSException *exception) {
					NSLog(@"Exception: %@", exception.description);
				}
				@finally {
					
					REVEvent *fevent = [[fetchedEvents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eid == %@ AND catID == %@", eid, cid]] firstObject];
					if (fevent != nil) {
						// Update existing...
						printf("Updating : %s\n", [dict[@"eid"] UTF8String]);
						
						@try {
							fevent.name = [NSString stringWithFormat:@"%@", dict[@"ename"]];
							fevent.detail = [NSString stringWithFormat:@"%@", dict[@"edesc"]];
							fevent.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"emaxteamsize"]];
							fevent.categoryName = [NSString stringWithFormat:@"%@", dict[@"cname"]];
							fevent.contactName = [NSString stringWithFormat:@"%@", dict[@"cntctname"]];
							fevent.contactPhone = [NSString stringWithFormat:@"%@", dict[@"cntctno"]];
						}
						@catch (NSException *exception) {
							NSLog(@"Exception: %@", exception.description);
						}
					}
					
					else {
						
						printf("Inserting : %s\n", [dict[@"eid"] UTF8String]);
						
						[REVEvent createNewEventWithDict:dict inEntity:[NSEntityDescription entityForName:@"REVEvent" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
					}
					
				}
				
			}
		}
		if (![context save:&error]) {
			NSLog(@"Error in saving: %@", error.localizedDescription);
		}
	}
	
	events = [[context executeFetchRequest:request error:&error] mutableCopy];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	return events;
}

+ (NSMutableArray <REVEvent *> *)eventsAfterUpdatingScheduleFromJSONData:(id)data inManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSManagedObjectContext *managedObjectContext = [AppDelegate managedObjectContext];
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	
	NSError *error;
	NSMutableArray <REVEvent *> *events = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (error)
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	
	if (data && [data isKindOfClass:[NSArray class]]) {
		
		for (id dict in data) {
			
			NSString *cid = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cid"]];
			NSString *eid = [NSString stringWithFormat:@"%@", [dict objectForKey:@"eid"]];
			
			NSString *day = [NSString stringWithFormat:@"Day %@", [dict objectForKey:@"day"]];
			
			NSArray *filteredArray = [events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eid == %@ AND catID == %@ AND day == %@", eid, cid, day]];
			REVEvent *fevent = [filteredArray firstObject];
			
			if (fevent != nil) {
				
				printf("Updating : %s|%s\n", cid.UTF8String, eid.UTF8String);
				
				fevent.venue = [NSString stringWithFormat:@"%@", dict[@"evenue"]];
				fevent.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
				
				NSDateFormatter *formatter = [NSDateFormatter new];
				[formatter setDateFormat:@"d-M-yy h:mm a"];
				fevent.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"strttime"]]];
				fevent.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"endtime"]]];
				
			}
			else {
				
				filteredArray = [events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eid == %@ AND catID == %@", eid, cid]];
				fevent = [filteredArray firstObject];
				
				if (fevent != nil) {
					
					printf("Inserting : %s|%s\n", cid.UTF8String, eid.UTF8String);
					
					REVEvent *nevent = [REVEvent createNewEventWithDict:dict inEntity:[NSEntityDescription entityForName:@"REVEvent" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
					
					nevent.uid = fevent.uid;
					nevent.name = fevent.name;
					nevent.eid = fevent.eid;
					nevent.detail = fevent.detail;
					nevent.maxTeamNo = fevent.maxTeamNo;
					nevent.categoryName = fevent.categoryName;
					nevent.catID = fevent.catID;
					nevent.isFavourite = NO;
					nevent.contactName = fevent.contactName;
					nevent.contactPhone = fevent.contactPhone;
					
					nevent.venue = [NSString stringWithFormat:@"%@", dict[@"evenue"]];
					nevent.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
					
					NSDateFormatter *formatter = [NSDateFormatter new];
					[formatter setDateFormat:@"d-M-yy h:mm a"];
					nevent.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"strttime"]]];
					nevent.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"endtime"]]];
					
				}
				
			}
		}
		
		if (![managedObjectContext save:&error]) {
			NSLog(@"Error in saving: %@", error.localizedDescription);
		}
	}
	
	[fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
	events = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	return events;
}

@end
