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

- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	if (!colors)
		colors = [UIColor revelsColors];
	
	[super drawRect:rect];
	
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGSize patSize = CGSizeMake(PATTERN_SIZE, PATTERN_SIZE);
//	
//	UIGraphicsBeginImageContext(CGSizeMake(WIDTH, HEIGHT));
	
	CGPoint pts[4][6];
	
	for (NSInteger i = 0; i < 6; ++i)
		pts[0][i] = CGPointMake(i * WIDTH/5.f, 0);
	
	for (NSInteger i = 0; i < 6; ++i) {
		if (!self.skewedBackground)
			pts[1][i] = CGPointMake(WIDTH, i * HEIGHT/5.f);
		else
			pts[1][i] = CGPointMake(WIDTH, 0 * HEIGHT/5.f);
	}
	
	for (NSInteger i = 0; i < 6; ++i)
		pts[2][i] = CGPointMake((5 - i) * WIDTH/5.f, HEIGHT);
	
	for (NSInteger i = 0; i < 6; ++i) {
		if (!self.skewedBackground)
			pts[3][i] = CGPointMake(0, (5 - i) * HEIGHT/5.f);
		else
			pts[3][i] = CGPointMake(0, (5 - 0) * HEIGHT/5.f);
	}
	
	NSMutableArray *paths = [NSMutableArray new];
	
	for (NSInteger i = 0; i < 2; ++i) {
		for (NSInteger j = 0; j < 5; ++j) {
			UIBezierPath *path = [UIBezierPath bezierPath];
			[path moveToPoint:pts[i][j]];
			[path addLineToPoint:pts[i][j + 1]];
			[path addLineToPoint:pts[3 - i][4 - j]];
			[path addLineToPoint:pts[3 - i][5 - j]];
			[path closePath];
			[paths addObject:path];
		}
	}
	
	for (NSInteger i = 0; i < paths.count; i++) {
		[colors[i % colors.count] setFill];
		[paths[i] fill];
	}
	
//	CGContextFillRect(context, CGRectMake(0, 0, patSize.width, patSize.height));
//	
//	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//
//	[[UIColor colorWithPatternImage:image] setFill];
//	CGContextFillRect(context, rect);
	
}


@end
