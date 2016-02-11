//
//  CrossButton.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "CrossButton.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation CrossButton {
	UIBezierPath *beizerPath;
}

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	CGFloat distance = self.crossThickness/sqrt(2);
	
	CGPoint borderPoints[4] = {CGPointZero, CGPointMake(WIDTH, 0), CGPointMake(WIDTH, HEIGHT), CGPointMake(0, HEIGHT)};
	
	CGPoint edgePoints[4][2] = {
		{CGPointMake(distance, 0), CGPointMake(WIDTH - distance, 0)},
		{CGPointMake(WIDTH, distance), CGPointMake(WIDTH, HEIGHT - distance)},
		{CGPointMake(WIDTH - distance, HEIGHT), CGPointMake(distance, HEIGHT)},
		{CGPointMake(0, HEIGHT - distance), CGPointMake(0, distance)}};
	
	CGPoint centerPoints[4] = {
		CGPointMake(WIDTH/2, HEIGHT/2 - distance),
		CGPointMake(WIDTH/2 + distance, HEIGHT/2),
		CGPointMake(WIDTH/2, HEIGHT/2 + distance),
		CGPointMake(WIDTH/2 - distance, HEIGHT/2)
	};

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, self.frame);
	
	if (!beizerPath) {
		beizerPath = [UIBezierPath bezierPath];
		[beizerPath moveToPoint:edgePoints[0][0]];
		[beizerPath addLineToPoint:centerPoints[0]];
		[beizerPath addLineToPoint:edgePoints[0][1]];
		if (self.pointyEdges)
			[beizerPath addLineToPoint:borderPoints[1]];
		[beizerPath addLineToPoint:edgePoints[1][0]];
		[beizerPath addLineToPoint:centerPoints[1]];
		[beizerPath addLineToPoint:edgePoints[1][1]];
		if (self.pointyEdges)
			[beizerPath addLineToPoint:borderPoints[2]];
		[beizerPath addLineToPoint:edgePoints[2][0]];
		[beizerPath addLineToPoint:centerPoints[2]];
		[beizerPath addLineToPoint:edgePoints[2][1]];
		if (self.pointyEdges)
			[beizerPath addLineToPoint:borderPoints[3]];
		[beizerPath addLineToPoint:edgePoints[3][0]];
		[beizerPath addLineToPoint:centerPoints[3]];
		[beizerPath addLineToPoint:edgePoints[3][1]];
		if (self.pointyEdges)
			[beizerPath addLineToPoint:borderPoints[0]];
		[beizerPath closePath];
	}
	
	[self.fillColor setFill];
	[beizerPath fill];
	
	self.layer.shadowPath = beizerPath.CGPath;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowOpacity = 1.f;
	self.layer.shadowRadius = 2.5f;
}


@end
