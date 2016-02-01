//
//  CrossButton.m
//  GRID
//
//  Created by Avikant Saini on 10/16/15.
//  Copyright © 2015 avikantz. All rights reserved.
//

#import "CrossButton.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation CrossButton

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	CGFloat distance = self.crossThickness/sqrt(2);
	
	CGPoint borderPoints[4] = {CGPointZero, CGPointMake(WIDTH, 0), CGPointMake(WIDTH, HEIGHT), CGPointMake(0, HEIGHT)};
	
	CGPoint edgePoints[4][2] = {
		{CGPointMake(distance, 0), CGPointMake(WIDTH - distance, 0)},
		{CGPointMake(WIDTH, distance), CGPointMake(WIDTH, HEIGHT - distance)},
		{CGPointMake(WIDTH - distance, HEIGHT), CGPointMake(distance, HEIGHT)},
		{CGPointMake(0, HEIGHT - distance), CGPointMake(0, distance)}};

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, self.frame);
	
	UIBezierPath *leftCross = [UIBezierPath bezierPath];
	[leftCross moveToPoint:edgePoints[0][0]];
	[leftCross addLineToPoint:edgePoints[1][1]];
	if (self.pointyEdges)
		[leftCross addLineToPoint:borderPoints[2]];
	[leftCross addLineToPoint:edgePoints[2][0]];
	[leftCross addLineToPoint:edgePoints[3][1]];
	if (self.pointyEdges)
		[leftCross addLineToPoint:borderPoints[0]];
	[leftCross closePath];
	[self.fillColor setFill];
	[leftCross fill];
	
	UIBezierPath *rightCross = [UIBezierPath bezierPath];
	[rightCross moveToPoint:edgePoints[0][1]];
	if (self.pointyEdges)
		[rightCross addLineToPoint:borderPoints[1]];
	[rightCross addLineToPoint:edgePoints[1][0]];
	[rightCross addLineToPoint:edgePoints[2][1]];
	if (self.pointyEdges)
		[rightCross addLineToPoint:borderPoints[3]];
	[rightCross addLineToPoint:edgePoints[3][0]];
	[rightCross closePath];
	[self.fillColor setFill];
	[rightCross fill];
	
}


@end
