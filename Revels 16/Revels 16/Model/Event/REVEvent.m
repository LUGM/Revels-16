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
		
		event.uid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
		event.name = [NSString stringWithFormat:@"%@", dict[@"ename"]];
		event.eid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
		event.detail = [NSString stringWithFormat:@"%@", dict[@"edesc"]];
		event.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"emaxteamsize"]];
		event.categoryName = [NSString stringWithFormat:@"%@", dict[@"cname"]];
		event.catID = [NSString stringWithFormat:@"%@", dict[@"cid"]];
		event.isFavourite = NO;
//		event.venue = [NSString stringWithFormat:@"%@", dict[@"venue"]];
//		event.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
		event.contactName = [NSString stringWithFormat:@"%@", dict[@"cntctname"]];
		event.contactPhone = [NSString stringWithFormat:@"%@", dict[@"cntctno"]];
		
//		NSDateFormatter *formatter = [NSDateFormatter new];
//		[formatter setDateFormat:@"d-MMM HH:mm"];
//		event.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"start_time"]]];
//		event.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"end_time"]]];
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
			
				NSString *eid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
				NSString *cid = [NSString stringWithFormat:@"%@", dict[@"cid"]];
				REVEvent *fevent = [[fetchedEvents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eid == %@ AND catID == %@", eid, cid]] firstObject];
				if (fevent != nil) {
					// Update existing...
					printf("Updating : %s\n", [dict[@"eid"] UTF8String]);
					fevent.uid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
					fevent.name = [NSString stringWithFormat:@"%@", dict[@"ename"]];
					fevent.eid = [NSString stringWithFormat:@"%@", dict[@"eid"]];
					fevent.detail = [NSString stringWithFormat:@"%@", dict[@"edesc"]];
					fevent.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"emaxteamsize"]];
					fevent.categoryName = [NSString stringWithFormat:@"%@", dict[@"cname"]];
					fevent.catID = [NSString stringWithFormat:@"%@", dict[@"cid"]];
//					fevent.venue = [NSString stringWithFormat:@"%@", dict[@"venue"]];
//					fevent.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
					fevent.contactName = [NSString stringWithFormat:@"%@", dict[@"cntctname"]];
					fevent.contactPhone = [NSString stringWithFormat:@"%@", dict[@"cntctno"]];
					
//					NSDateFormatter *formatter = [NSDateFormatter new];
//					[formatter setDateFormat:@"d-MMM HH:mm"];
//					fevent.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"start_time"]]];
//					fevent.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"end_time"]]];
				}
				else {
					printf("Inserting : %s\n", [dict[@"eid"] UTF8String]);
					[REVEvent createNewEventWithDict:dict inEntity:[NSEntityDescription entityForName:@"REVEvent" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
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
			
			NSArray *filteredArray = [events filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"eid == %@ AND catID == %@", eid, cid]];
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
