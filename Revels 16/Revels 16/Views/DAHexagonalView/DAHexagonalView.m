//
//  DAHexagonalView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/5/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "DAHexagonalView.h"
#import "CAAnimation+Blocks.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define ORIGIN self.bounds.origin
#define CENTER CGPointMake(self.center.x, self.center.y + 33)

#define HEXWIDTH (WIDTH - 120)
#define HEXSIDE (HEXWIDTH / sqrt(3))
#define HEXHEIGHT (HEXSIDE * 2)

@implementation DAHexagonalView {

	NSMutableArray <CAShapeLayer *> *shapeLayers;
	
	NSMutableArray <UIBezierPath *> *entryPaths;
	
	NSMutableArray <CABasicAnimation *> *animations;
	
	NSMutableArray <CAKeyframeAnimation *> *imageAnimations;
	NSMutableArray <CALayer *> *imageLayers;
	NSMutableArray <UIBezierPath *> *imagePaths;

}

- (void)layoutSubviews {
	
	CGPoint strpts[4] = {
		CGPointMake(CENTER.x + (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y - 2 * HEXWIDTH),
		CGPointMake(CENTER.x + (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y + 2 * HEXWIDTH),
		CGPointMake(CENTER.x - (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y + 2 * HEXWIDTH),
		CGPointMake(CENTER.x - (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y - 2 * HEXWIDTH)
	};
	
	CGPoint entpts[6] = {
		CGPointMake(CENTER.x - HEXWIDTH/6, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + HEXWIDTH/6, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + (HEXSIDE/sqrt(3)), CENTER.y),
		CGPointMake(CENTER.x + HEXWIDTH/6, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - HEXWIDTH/6, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - (HEXSIDE/sqrt(3)), CENTER.y)
	};
	
	CGPoint hexpts[6] = {
		CGPointMake(CENTER.x, CENTER.y - HEXSIDE),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y - HEXSIDE/2),
		CGPointMake(CENTER.x - HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x, CENTER.y + HEXSIDE),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y + HEXSIDE/2),
		CGPointMake(CENTER.x + HEXWIDTH/2, CENTER.y - HEXSIDE/2)
	};
	
	CGPoint extpts[4] = {
		CGPointMake(2 * hexpts[0].x - hexpts[2].x, 2 * hexpts[0].y - hexpts[2].y),
		CGPointMake(2 * hexpts[3].x - hexpts[1].x, 2 * hexpts[3].y - hexpts[1].y),
		CGPointMake(2 * hexpts[3].x - hexpts[5].x, 2 * hexpts[3].y - hexpts[5].y),
		CGPointMake(2 * hexpts[0].x - hexpts[4].x, 2 * hexpts[0].y - hexpts[4].y),
	};
	
	if (!self.startPoints) {
		self.startPoints = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i)
			[self.startPoints addObject:[NSValue valueWithCGPoint:strpts[i]]];
	}
	
	if (!self.entryPoints) {
		self.entryPoints = [NSMutableArray new];
		for (NSInteger i = 0; i < 6; ++i)
			[self.entryPoints addObject:[NSValue valueWithCGPoint:entpts[i]]];
	}
	
	if (!self.hexPoints) {
		self.hexPoints = [NSMutableArray new];
		for (NSInteger i = 0; i < 6; ++i)
			[self.hexPoints addObject:[NSValue valueWithCGPoint:hexpts[i]]];
	}
	
	if (!self.exitPoints) {
		self.exitPoints = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i)
			[self.exitPoints addObject:[NSValue valueWithCGPoint:extpts[i]]];
	}
	
	if (!entryPaths) {
		
		UIBezierPath *entryPath0 = [UIBezierPath bezierPath];
		[entryPath0 moveToPoint:strpts[0]];
		[entryPath0 addLineToPoint:entpts[3]];
		[entryPath0 addLineToPoint:hexpts[1]];
		[entryPath0 addLineToPoint:hexpts[3]];
//		[entryPath0 addLineToPoint:extpts[1]];

		UIBezierPath *entryPath1 = [UIBezierPath bezierPath];
		[entryPath1 moveToPoint:strpts[1]];
		[entryPath1 addLineToPoint:entpts[1]];
		[entryPath1 addLineToPoint:hexpts[2]];
		[entryPath1 addLineToPoint:hexpts[0]];
//		[entryPath1 addLineToPoint:extpts[0]];
		
		UIBezierPath *entryPath2 = [UIBezierPath bezierPath];
		[entryPath2 moveToPoint:strpts[2]];
		[entryPath2 addLineToPoint:entpts[0]];
		[entryPath2 addLineToPoint:hexpts[4]];
		[entryPath2 addLineToPoint:hexpts[0]];
//		[entryPath2 addLineToPoint:extpts[3]];
		
		UIBezierPath *entryPath3 = [UIBezierPath bezierPath];
		[entryPath3 moveToPoint:strpts[3]];
		[entryPath3 addLineToPoint:entpts[4]];
		[entryPath3 addLineToPoint:hexpts[5]];
		[entryPath3 addLineToPoint:hexpts[3]];
//		[entryPath3 addLineToPoint:extpts[2]];
		
		entryPaths = [NSMutableArray arrayWithObjects:entryPath0, entryPath1, entryPath2, entryPath3, nil];
	}
	
	if (!imagePaths) {
		
		UIBezierPath *imagePath0 = [UIBezierPath bezierPath];
		[imagePath0 moveToPoint:strpts[0]];
		[imagePath0 addLineToPoint:entpts[3]];
		[imagePath0 addLineToPoint:hexpts[1]];
		
		UIBezierPath *imagePath1 = [UIBezierPath bezierPath];
		[imagePath1 moveToPoint:strpts[1]];
		[imagePath1 addLineToPoint:entpts[1]];
		[imagePath1 addLineToPoint:hexpts[2]];
		
		UIBezierPath *imagePath2 = [UIBezierPath bezierPath];
		[imagePath2 moveToPoint:strpts[2]];
		[imagePath2 addLineToPoint:entpts[0]];
		[imagePath2 addLineToPoint:hexpts[4]];
		
		UIBezierPath *imagePath3 = [UIBezierPath bezierPath];
		[imagePath3 moveToPoint:strpts[3]];
		[imagePath3 addLineToPoint:entpts[4]];
		[imagePath3 addLineToPoint:hexpts[5]];
		
		imagePaths = [NSMutableArray arrayWithObjects:imagePath0, imagePath1, imagePath2, imagePath3, nil];
	}
	
}

- (void)awakeFromNib {
	
	if (!self.images) {
		self.images = [@[[UIImage imageNamed:@"Avikant"],
						 [UIImage imageNamed:@"Anuraag"],
						 [UIImage imageNamed:@"Saketh"],
						 [UIImage imageNamed:@"Yash"]
						 ] mutableCopy];
	}
	
	if (!shapeLayers) {
		shapeLayers = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i) {
			CAShapeLayer *layer = [CAShapeLayer layer];
			layer.frame = self.bounds;
			layer.strokeColor = [[UIColor darkGrayColor] CGColor];
			layer.lineWidth = 1;
			layer.fillColor = [[UIColor clearColor] CGColor];
			[self.layer addSublayer:layer];
			[shapeLayers addObject:layer];
		}
	}
	
	if (!imageLayers) {
		imageLayers = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i) {
			UIImage *movingImage = self.images[i];
			CALayer *movingLayer = [CALayer layer];
			movingLayer.contents = (id)movingImage.CGImage;
			movingLayer.frame = CGRectMake(0.0f, 0.0f, movingImage.size.width, movingImage.size.height);
			[self.layer addSublayer:movingLayer];
			[imageLayers addObject:movingLayer];
		}
	}

}

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	[GLOBAL_BACK_COLOR setFill];
	[UIColor.lightGrayColor setStroke];
	
	CGFloat bigCircleRadius = (WIDTH > 360.f)?60.f:48.f;
	
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CENTER radius:bigCircleRadius startAngle:0.f endAngle:2 * M_PI clockwise:YES];
	[circlePath fill];
	[circlePath stroke];

	[UIColor.lightGrayColor setFill];
	[UIColor.darkGrayColor setStroke];
	
//	for (NSInteger i = 0; i < 6; ++i) {
//		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:[self.entryPoints[i] CGPointValue] radius:4.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
//		[circlePath fill];
//		[circlePath stroke];
//	}
	
	[GLOBAL_BACK_COLOR setFill];
	[UIColor.lightGrayColor setStroke];
	
	for (NSInteger i = 0; i < 6; ++i) {
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:[self.hexPoints[i] CGPointValue] radius:32.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
		[circlePath fill];
		[circlePath stroke];
	}
	
}

- (void)animatePath {
	
	if (!animations) {
		animations = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i) {
			CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
			pathAnimation.duration = 5.f;
			pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
			pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
			pathAnimation.autoreverses = YES;
			pathAnimation.removedOnCompletion = NO;
			pathAnimation.fillMode = kCAFillModeForwards;
			pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
			[animations addObject:pathAnimation];
		}
	}
	
	for (NSInteger i = 0; i < 4; ++i) {
		shapeLayers[i].path = entryPaths[i].CGPath;
		[shapeLayers[i] addAnimation:animations[i] forKey:@"strokeEnd"];
	}
	
	
	if (!imageAnimations) {
		imageAnimations = [NSMutableArray new];
		for (NSInteger  i = 0; i < 4; ++i) {
			CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			pathAnimation.duration = 3.8f;
			pathAnimation.removedOnCompletion = YES;
			pathAnimation.path = imagePaths[i].CGPath;
			pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
			[pathAnimation setCompletion:^(BOOL finished) {
				UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
				[button setBackgroundImage:self.images[i] forState:UIControlStateNormal];
				[button setFrame:CGRectMake(0, 0, 64, 64)];
				[button setCenter:imagePaths[i].currentPoint];
				[button setTag:i];
				[button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:button];
//				[imageLayers[i] removeFromSuperlayer];
			}];
			[imageAnimations addObject:pathAnimation];
		}
	}
	
	for (NSInteger i = 0; i < 4; ++i) {
//		imageAnimations[i].path = imagePaths[i].CGPath;
		[imageLayers[i] addAnimation:imageAnimations[i] forKey:@"movingAnimation"];
	}
	
	UIButton *buttonK = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonK setBackgroundImage:[UIImage imageNamed:@"Kartik"] forState:UIControlStateNormal];
	[buttonK setFrame:CGRectMake(0, 0, 64, 64)];
	[buttonK setCenter:[self.hexPoints[3] CGPointValue]];
	[buttonK setTag:4];
	[buttonK addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:buttonK];
	
	UIButton *buttonS = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonS setBackgroundImage:[UIImage imageNamed:@"Sorte"] forState:UIControlStateNormal];
	[buttonS setFrame:CGRectMake(0, 0, 64, 64)];
	[buttonS setCenter:[self.hexPoints[0] CGPointValue]];
	[buttonS setTag:5];
	[buttonS addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:buttonS];
	
	buttonK.transform = CGAffineTransformMakeScale(0, 0);
	buttonK.alpha = 0.0;
	
	buttonS.transform = CGAffineTransformMakeScale(0, 0);
	buttonS.alpha = 0.0;
	
	UIButton *buttonLUGM = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonLUGM setBackgroundImage:[UIImage imageNamed:@"RevelsCircle"] forState:UIControlStateNormal];
	[buttonLUGM setFrame:CGRectMake(0, 0, 120, 120)];
	[buttonLUGM setCenter:CENTER];
	[buttonLUGM setTag:10];
	[buttonLUGM addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:buttonLUGM];
	
	buttonLUGM.transform = CGAffineTransformMakeScale(0, 0);
	buttonLUGM.alpha = 0.0;
	
	[UIView animateWithDuration:1.2 delay:4.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
		buttonK.transform = CGAffineTransformIdentity;
		buttonK.alpha = 1.0;
		buttonS.transform = CGAffineTransformIdentity;
		buttonS.alpha = 1.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.2 delay:1.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
			buttonLUGM.transform = CGAffineTransformIdentity;
			buttonLUGM.alpha = 1.0;
		} completion:^(BOOL finished) {
			if ([self.delegate respondsToSelector:@selector(finishedAllAnimationsDoSomethingAwesome)])
				[self.delegate finishedAllAnimationsDoSomethingAwesome];
		}];
	}];
	
}

- (void)removeAllAnimations {
	NSArray *subviews = self.subviews;
	for (NSInteger i = 0; i < subviews.count; ++i) {
		[subviews[i] removeFromSuperview];
	}
	NSArray *sublayers = self.layer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i) {
		[sublayers[i] removeAllAnimations];
	}
}

- (void)imageButtonPressed:(id)sender {
//	NSLog(@"Button pressed: %li", [sender tag]);
	if ([self.delegate respondsToSelector:@selector(hexagonalViewButtonPressedAtIndex:)]) {
		[self.delegate hexagonalViewButtonPressedAtIndex:[sender tag]];
	}
}

#pragma mark - CAAnimationDelegate


@end
