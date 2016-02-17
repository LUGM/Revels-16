//
//  RoundedLabel.m
//  Revels 16
//
//  Created by Avikant Saini on 2/11/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "RoundedLabel.h"

@implementation RoundedLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
	[bezierPath setLineWidth:1.f];
	[self.fillColor setFill];
	[bezierPath fill];
	
	[super drawRect:rect];
	
}


@end
