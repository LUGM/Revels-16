//
//  REVCategory.m
//  Revels 16
//
//  Created by Avikant Saini on 2/2/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "REVCategory.h"

@implementation REVCategory

- (instancetype)initWithDict:(id)dict {
	
	self = [super init];
	
	if (self) {
		
		if (dict && [dict isKindOfClass:[NSDictionary class]]) {
			
			@try {
				if ([dict valueForKey:@"cname"])
					self.name = [NSString stringWithFormat:@"%@", dict[@"cname"]];
				
				if ([dict valueForKey:@"cdesc"])
					self.detail = [NSString stringWithFormat:@"%@", dict[@"cdesc"]];
				
				if ([dict valueForKey:@"imageName"])
					self.imageName = [NSString stringWithFormat:@"%@", dict[@"imageName"]];
				else
					self.imageName = [NSString stringWithFormat:@"%@", dict[@"cname"]];
				
				if ([dict valueForKey:@"cid"])
					self.uid = [NSString stringWithFormat:@"%@", dict[@"cid"]];
			}
			@catch (NSException *exception) {
				NSLog(@"Category parsing error: %@", exception.reason);
			}
			
		}
	}
	
	return self;
}

+ (NSMutableArray<REVCategory *> *)getArrayFromJSONData:(id)data {
	
	NSMutableArray <REVCategory *> *categories = [NSMutableArray new];
	
	@try {
		if (data && [data isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dict in data) {
				REVCategory *category = [[REVCategory alloc] initWithDict:dict];
				[categories addObject:category];
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"Category parsing error: %@", exception.reason);
	}
	
	// Optional sort
	[categories sortUsingComparator:^NSComparisonResult(REVCategory *obj1, REVCategory *obj2) {
		return [obj1.name compare:obj2.name];
	}];

	return categories;
}

@end
