//
//  DAHexagonalView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/5/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "DAHexagonalView.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define ORIGIN self.bounds.origin
#define CENTER CGPointMake(self.center.x, self.center.y + 33)

#define HEXWIDTH (WIDTH - 120)
#define HEXSIDE (HEXWIDTH / 1.732)
#define HEXHEIGHT (HEXSIDE * 2)

@implementation DAHexagonalView {
	CAShapeLayer *shapeLayerTriangleOne;
	CAShapeLayer *shapeLayerTriangleTwo;
}

- (void)awakeFromNib {
	if (!shapeLayerTriangleOne) {
		shapeLayerTriangleOne = [CAShapeLayer layer];
		shapeLayerTriangleOne.frame = self.bounds;
		shapeLayerTriangleOne.strokeColor = [[UIColor darkGrayColor] CGColor];
		shapeLayerTriangleOne.lineWidth = 1;
		shapeLayerTriangleOne.fillColor = [[UIColor clearColor] CGColor];
		[self.layer addSublayer:shapeLayerTriangleOne];
	}
	if (!shapeLayerTriangleTwo) {
		shapeLayerTriangleTwo = [CAShapeLayer layer];
		shapeLayerTriangleTwo.frame = self.bounds;
		shapeLayerTriangleTwo.strokeColor = [[UIColor darkGrayColor] CGColor];
		shapeLayerTriangleTwo.lineWidth = 1;
		shapeLayerTriangleTwo.fillColor = [[UIColor clearColor] CGColor];
		[self.layer addSublayer:shapeLayerTriangleTwo];
	}
}

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	CGPoint entryPoints[6] = {
		CGPointMake(CENTER.x - HEXWIDTH/6, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + HEXWIDTH/6, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + (HEXSIDE/sqrt(3)), CENTER.y),
		CGPointMake(CENTER.x + HEXWIDTH/6, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - HEXWIDTH/6, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - (HEXSIDE/sqrt(3)), CENTER.y),
	};
	
	for (NSInteger i = 0; i < 6; ++i) {
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:entryPoints[i] radius:4.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
		[UIColor.lightGrayColor setFill];
		[UIColor.darkGrayColor setStroke];
		[circlePath fill];
		[circlePath stroke];
	}
	
	CGPoint hexPoints[6] = {
		CGPointMake(CENTER.x, CENTER.y - HEXSIDE),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x, CENTER.y + HEXSIDE),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y - HEXSIDE/2)
	};
	
	UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
	[bezierPath1 setLineWidth:1.f];
	[bezierPath1 moveToPoint:hexPoints[2]];
	[bezierPath1 addLineToPoint:hexPoints[0]];
	[bezierPath1 addLineToPoint:hexPoints[4]];
	[bezierPath1 closePath];
	
	[UIColor.darkGrayColor setStroke];
//	[bezierPath1 stroke];
	
	UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
	[bezierPath2 moveToPoint:hexPoints[1]];
	[bezierPath2 addLineToPoint:hexPoints[3]];
	[bezierPath2 addLineToPoint:hexPoints[5]];
	[bezierPath2 closePath];
	
	[UIColor.darkGrayColor setStroke];
//	[bezierPath2 stroke];
	
	[GLOBAL_BACK_COLOR setFill];
	
	for (NSInteger i = 0; i < 6; ++i) {
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:hexPoints[i] radius:32.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
		[UIColor.lightGrayColor setStroke];
		[circlePath fill];
		[circlePath stroke];
	}
	
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CENTER radius:48.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
	[circlePath fill];
	[circlePath stroke];

	
}

- (void)animatePath {
	
	CGPoint hexPoints[6] = {
		CGPointMake(CENTER.x, CENTER.y - HEXSIDE),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x, CENTER.y + HEXSIDE),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y - HEXSIDE/2)
	};
	
	UIBezierPath *bezierPath1 = [UIBezierPath bezierPath];
	[bezierPath1 setLineWidth:1.f];
	[bezierPath1 moveToPoint:hexPoints[2]];
	[bezierPath1 addLineToPoint:hexPoints[0]];
	[bezierPath1 addLineToPoint:hexPoints[4]];
	[bezierPath1 closePath];
	
	UIBezierPath *bezierPath2 = [UIBezierPath bezierPath];
	[bezierPath2 moveToPoint:hexPoints[5]];
	[bezierPath2 addLineToPoint:hexPoints[3]];
	[bezierPath2 addLineToPoint:hexPoints[1]];
	[bezierPath2 closePath];
	
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.duration = 2.5f;
	pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	pathAnimation.repeatCount = 10;
	pathAnimation.autoreverses = YES;
	
	CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation2.duration = 2.5f;
	pathAnimation2.fromValue = [NSNumber numberWithFloat:0.0f];
	pathAnimation2.toValue = [NSNumber numberWithFloat:1.0f];
	pathAnimation2.repeatCount = 10;
	pathAnimation2.autoreverses = YES;
	
	shapeLayerTriangleOne.path = bezierPath1.CGPath;
	[shapeLayerTriangleOne addAnimation:pathAnimation forKey:@"strokeEnd"];
	
	shapeLayerTriangleTwo.path = bezierPath2.CGPath;
	[shapeLayerTriangleTwo addAnimation:pathAnimation2 forKey:@"strokeEnd"];
	
	
}

@end
