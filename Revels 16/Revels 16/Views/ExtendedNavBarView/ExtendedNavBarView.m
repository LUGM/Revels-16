/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A UIView subclass that draws a gray hairline along its bottom
  border, similar to a navigation bar.  This view is used as the navigation
  bar extension view in the Extended Navigation Bar example.
 */

#import "ExtendedNavBarView.h"

@implementation ExtendedNavBarView

//| ----------------------------------------------------------------------------
//  Called when the view is about to be displayed.  May be called more than
//  once.
//


- (void)willMoveToWindow:(UIWindow *)newWindow
{
    // Use the layer shadow to draw a one pixel hairline under this view.
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath setLineWidth:1.0];
	[bezierPath moveToPoint:CGPointMake(0, self.bounds.size.height - 1)];
	[bezierPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 1)];
//	[UIColor.whiteColor setFill];
//	[UIColor.blackColor setStroke];
//	[bezierPath stroke];
	
	self.layer.shadowPath = bezierPath.CGPath;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowOpacity = 1.f;
	self.layer.shadowRadius = 1.0f;
	
}


@end
