//
//  EventsTableViewCell.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "EventsTableViewCell.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height

@implementation EventsTableViewCell {
	UIBezierPath *bezierPath;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect {
	
	if (!bezierPath) {
		bezierPath = [UIBezierPath bezierPath];
		[bezierPath setLineWidth:0.5];
		[bezierPath moveToPoint:CGPointMake(0, HEIGHT - 0.5)];
		[bezierPath addLineToPoint:CGPointMake(WIDTH, HEIGHT - 0.5)];
	}
	[[UIColor darkGrayColor] setStroke];
	[bezierPath stroke];
	
	[super drawRect:rect];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
