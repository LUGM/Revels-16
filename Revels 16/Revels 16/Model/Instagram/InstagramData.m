//
//  InstagramData.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "InstagramData.h"

@implementation InstagramData

- (instancetype)initWithData:(id)data {
	
	self = [super init];
	
	if (self) {
		
		if (data && [data isKindOfClass:[NSDictionary class]]) {
			
			self.type = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"type"]];
			
			self.instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"link"]]];
			
			self.filterName = [data valueForKeyPath:@"filter"];
			
			NSArray *tagArray = [data valueForKey:@"tags"];
			self.tags = [tagArray componentsJoinedByString:@" | "];
			
			self.commentsCount = 0;
			if ([data valueForKey:@"comments"])
				self.commentsCount = [[data valueForKeyPath:@"comments.count"] integerValue];
			
			self.likesCount = 0;
			if ([data valueForKey:@"likes"])
				self.likesCount = [[data valueForKeyPath:@"likes.count"] integerValue];
			
			if ([data valueForKey:@"images"]) {
				if ([data valueForKeyPath:@"images.thumbnail.url"])
					self.thumbnailURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.thumbnail.url"]]];
				if ([data valueForKeyPath:@"images.low_resolution.url"])
					self.lowResURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.low_resolution.url"]]];
				if ([data valueForKeyPath:@"images.standard_resolution.url"])
					self.highResURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"images.standard_resolution.url"]]];
			}
			
			if ([data valueForKey:@"caption"])
				self.captionText = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"caption.text"]];
			
			if ([data valueForKey:@"user"]) {
				self.username = [NSString stringWithFormat:@"%@", [data valueForKeyPath:@"user.username"]];
				self.userProfileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [data valueForKeyPath:@"user.profile_picture"]]];
			}
			
		}
		
	}
	
	return self;
}


+ (NSMutableArray *)getArrayFromJSONData:(id)data {
	
	NSMutableArray *array = [NSMutableArray new];
	
	for (NSDictionary *dict in data) {
		InstagramData *igdata = [[InstagramData alloc] initWithData:dict];
		[array addObject:igdata];
	}
	
	return array;
}

@end
