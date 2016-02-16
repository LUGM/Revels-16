//
//  REVResult.m
//  Revels 16
//
//  Created by Avikant Saini on 2/16/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "REVResult.h"

@implementation REVResult

- (instancetype)initWithData:(id)data {
	
	self = [super init];
	
	if (self) {
		
		if (data && [data isKindOfClass:[NSDictionary class]]) {
			
			@try {
				self.eventName = [NSString stringWithFormat:@"%@", data[@"eventName"]];
				
				self.categoryName = [NSString stringWithFormat:@"%@", data[@"categoryName"]];
				
				self.resultText = [NSString stringWithFormat:@"%@", data[@"result"]];
			}
			@catch (NSException *exception) {
				NSLog(@"Result parsing exception: %@", exception.reason);
			}
			@finally {
				
			}
			
		}
		
	}
	
	return  self;
}

+ (NSMutableArray<REVResult *> *)getResultsFromJSONData:(id)data {
	
	NSMutableArray *results = [NSMutableArray new];
	
	if (data && [data isKindOfClass:[NSArray class]]) {
	
		for (id dict in data) {
			
			REVResult *result = [[REVResult alloc] initWithData:dict];
			
			[results addObject:result];
			
		}
			
	}
	
	return results;
	
}

+ (NSMutableArray *)getCatResultsFromResults:(NSArray<REVResult *> *)results {
	
	NSMutableArray *catResults = [NSMutableArray new];
	
	if (results.count > 0) {
	
		NSArray *filteredResults = [results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"categoryName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"eventName" ascending:YES]]];
	
		REVResult *cresult = [filteredResults firstObject];
		NSMutableArray *carray = [NSMutableArray new];
		
		for (NSInteger i = 0; i < filteredResults.count; ++i) {
			
			REVResult *result = [filteredResults objectAtIndex:i];
			
			if ([result.categoryName isEqualToString:cresult.categoryName]) {
				[carray addObject:result];
			}
			else {
				[catResults addObject:carray];
				carray = [NSMutableArray arrayWithObject:result];
				cresult = result;
			}
			
		}
		
		[catResults addObject:carray];
		
	}
	
	return catResults;
	
}

@end
