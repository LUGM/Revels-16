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
		
		event.uid = [NSString stringWithFormat:@"%@", dict[@"id"]];
		event.name = [NSString stringWithFormat:@"%@", dict[@"event_name"]];
		event.eid = [NSString stringWithFormat:@"%@", dict[@"event_id"]];
		event.detail = [NSString stringWithFormat:@"%@", dict[@"description"]];
		event.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"event_max_team_number"]];
		event.categoryName = [NSString stringWithFormat:@"%@", dict[@"cat_name"]];
		event.catID = [NSString stringWithFormat:@"%@", dict[@"cat_id"]];
		event.isFavourite = NO;
		event.venue = [NSString stringWithFormat:@"%@", dict[@"venue"]];
		event.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
		event.contactName = [NSString stringWithFormat:@"%@", dict[@"contact_name"]];
		event.contactPhone = [NSString stringWithFormat:@"%@", dict[@"contact_number"]];
		
		NSDateFormatter *formatter = [NSDateFormatter new];
		[formatter setDateFormat:@"d-MMM HH:mm"];
		event.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"start_time"]]];
		event.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"end_time"]]];
	}
	
	return event;
}

+ (NSMutableArray<REVEvent *> *)getEventsFromJSONData:(id)data storeIntoManagedObjectContext:(NSManagedObjectContext *)context {
	
	NSMutableArray <REVEvent*> *events = [NSMutableArray new];
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"REVEvent"];
	[request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]]];
	NSError *error;
	NSArray *fetchedEvents = [context executeFetchRequest:request error:&error];
	if (error) {
		NSLog(@"Error in fetching: %@", error.localizedDescription);
	}
	
	if (data && [data isKindOfClass:[NSArray class]]) {
		for (id dict in data) {
			
			if (dict && [dict isKindOfClass:[NSDictionary class]]) {
			
				NSString *uid = [NSString stringWithFormat:@"%@", dict[@"id"]];
				NSString *name = [NSString stringWithFormat:@"%@", dict[@"event_name"]];
				REVEvent *fevent = [[fetchedEvents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uid == %@ AND name == %@", uid, name]] firstObject];
				if (fevent != nil) {
					// Update existing...
					printf("Updating : %s\n", [dict[@"id"] UTF8String]);
					fevent.uid = [NSString stringWithFormat:@"%@", dict[@"id"]];
					fevent.name = [NSString stringWithFormat:@"%@", dict[@"event_name"]];
					fevent.eid = [NSString stringWithFormat:@"%@", dict[@"event_id"]];
					fevent.detail = [NSString stringWithFormat:@"%@", dict[@"description"]];
					fevent.maxTeamNo = [NSString stringWithFormat:@"%@", dict[@"event_max_team_number"]];
					fevent.categoryName = [NSString stringWithFormat:@"%@", dict[@"cat_name"]];
					fevent.catID = [NSString stringWithFormat:@"%@", dict[@"cat_id"]];
					fevent.venue = [NSString stringWithFormat:@"%@", dict[@"venue"]];
					fevent.day = [NSString stringWithFormat:@"Day %@", dict[@"day"]];
					fevent.contactName = [NSString stringWithFormat:@"%@", dict[@"contact_name"]];
					fevent.contactPhone = [NSString stringWithFormat:@"%@", dict[@"contact_number"]];
					
					NSDateFormatter *formatter = [NSDateFormatter new];
					[formatter setDateFormat:@"d-MMM HH:mm"];
					fevent.startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"start_time"]]];
					fevent.endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dict[@"date"], dict[@"end_time"]]];
				}
				else {
					printf("Inserting : %s\n", [dict[@"id"] UTF8String]);
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

@end
