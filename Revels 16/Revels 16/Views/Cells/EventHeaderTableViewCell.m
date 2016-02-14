//
//  EventHeaderTableViewCell.m
//  Revels 16
//
//  Created by Avikant Saini on 2/8/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "EventHeaderTableViewCell.h"

@implementation EventHeaderTableViewCell {
	UIBezierPath *shadowPath;
//	CALayer *shadowLayer;
}

- (void)awakeFromNib {
    // Initialization code
	
//	if (!shadowPath) {
//		shadowPath = [UIBezierPath bezierPath];
//		[shadowPath setLineWidth:2.f];
//		[shadowPath moveToPoint:CGPointMake(0, self.bounds.size.height - 2)];
//		[shadowPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 2)];
//	}
//	
//	if (!shadowLayer) {
//		shadowLayer = [CALayer layer];
//		shadowLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
//		shadowLayer.shadowPath = shadowPath.CGPath;
//		shadowLayer.shadowOpacity = 0.75f;
//		shadowLayer.shadowColor = [UIColor darkGrayColor].CGColor;
//		shadowLayer.shadowRadius = 2.f;
//		shadowLayer.shadowOffset = CGSizeZero;
//	}
//	
//	[self.layer addSublayer:shadowLayer];
	
}

- (void)drawRect:(CGRect)rect {
	
	if (!shadowPath) {
		shadowPath = [UIBezierPath bezierPath];
		[shadowPath setLineWidth:1.f];
		[shadowPath moveToPoint:CGPointMake(0, self.bounds.size.height - 0.5)];
		[shadowPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 0.5)];
	}
	
	[UIColor.lightGrayColor setStroke];
	[shadowPath stroke];
	
	[super drawRect:rect];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
