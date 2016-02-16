//
//  AboutBackgroundView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/16/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "AboutBackgroundView.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define ORIGIN self.bounds.origin

#define PATTERN_SIZE WIDTH

@implementation AboutBackgroundView {
	NSArray <UIColor *> *colors;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	// Pattern
	
	if (!colors)
		colors = [UIColor revelsColors];
	
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGSize patSize = CGSizeMake(PATTERN_SIZE, PATTERN_SIZE);
	
	UIGraphicsBeginImageContext(CGSizeMake(patSize.width, patSize.height));
	
//	for (NSInteger i = 0; i < 3; i++) {
//		UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, PATTERN_SIZE * (i / 5.f), PATTERN_SIZE, PATTERN_SIZE * (1.f / colors.count))];
//		[colors[i] setFill];
//		[rectPath fill];
//	}
	
	for (NSInteger i = 0; i < colors.count; i++) {
		UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:CGRectMake(PATTERN_SIZE * (i / 5.f), 0, PATTERN_SIZE * (1.f / colors.count), PATTERN_SIZE)];
		[colors[i] setFill];
		[rectPath fill];
	}
	
	CGContextFillRect(context, CGRectMake(0, 0, patSize.width, patSize.height));
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[[UIColor colorWithPatternImage:image] setFill];
	CGContextFillRect(context, rect);
	
}


@end
