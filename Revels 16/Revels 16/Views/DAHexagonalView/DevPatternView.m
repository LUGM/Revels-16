//
//  DevPatternView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/26/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "DevPatternView.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define ORIGIN self.bounds.origin

#define PATTERN_SIZE 10.f

@implementation DevPatternView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	
	// Pattern
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGSize patSize = CGSizeMake(PATTERN_SIZE, PATTERN_SIZE);
	
	UIGraphicsBeginImageContext(CGSizeMake(patSize.width * 2, patSize.height * 2));
	
	CGPoint pt0 = CGPointMake(0, 0);
	CGPoint pt1 = CGPointMake(2 * PATTERN_SIZE, 0);
	CGPoint pt2 = CGPointMake(2 * PATTERN_SIZE, 2 * PATTERN_SIZE);
	CGPoint pt3 = CGPointMake(0, 2 * PATTERN_SIZE);
	CGPoint ptc = CGPointMake(PATTERN_SIZE, PATTERN_SIZE);
	
	[UIColor.clearColor setStroke];
	
	UIBezierPath *rectPath1 = [UIBezierPath bezierPath];
	[rectPath1 moveToPoint:pt0];
	[rectPath1 addLineToPoint:pt1];
	[rectPath1 addLineToPoint:ptc];
	[rectPath1 closePath];
	[[UIColor colorFromHexString:@"#FFFFEF"] setFill];
	[rectPath1 fill];
	UIBezierPath *rectPath2 = [UIBezierPath bezierPath];
	[rectPath2 moveToPoint:pt1];
	[rectPath2 addLineToPoint:pt2];
	[rectPath2 addLineToPoint:ptc];
	[rectPath2 closePath];
	[[UIColor colorFromHexString:@"#FFEFFF"] setFill];
	[rectPath2 fill];
	UIBezierPath *rectPath3 = [UIBezierPath bezierPath];
	[rectPath3 moveToPoint:pt2];
	[rectPath3 addLineToPoint:pt3];
	[rectPath3 addLineToPoint:ptc];
	[rectPath3 closePath];
	[[UIColor colorFromHexString:@"#EFFFFF"] setFill];
	[rectPath3 fill];
	UIBezierPath *rectPath4 = [UIBezierPath bezierPath];
	[rectPath4 moveToPoint:pt3];
	[rectPath4 addLineToPoint:pt0];
	[rectPath4 addLineToPoint:ptc];
	[rectPath4 closePath];
	[[UIColor colorFromHexString:@"#EFEFEF"] setFill];
	[rectPath4 fill];
	
	CGContextFillRect(context, CGRectMake(0, 0, patSize.width * 2, patSize.height * 2));
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	[[UIColor colorWithPatternImage:image] setFill];
	CGContextFillRect(context, rect);
}


@end
