//
//  DAHexagonalView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/5/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "DAHexagonalView.h"
#import "CAAnimation+Blocks.h"
#import <CoreText/CoreText.h>

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height
#define ORIGIN self.bounds.origin

#define PATTERN_SIZE 10.f

//#define CENTER CGPointMake(self.center.x, self.center.y + 33)

//#define HEXWIDTH (WIDTH - 120)
//#define HEXSIDE (HEXWIDTH / sqrt(3))
//#define HEXHEIGHT (HEXSIDE * 2)

@implementation DAHexagonalView {

	NSMutableArray <CAShapeLayer *> *shapeLayers;
	
	NSMutableArray <UIBezierPath *> *entryPaths;
	
	NSMutableArray <CABasicAnimation *> *animations;
	
	NSMutableArray <CAKeyframeAnimation *> *imageAnimations;
	NSMutableArray <CALayer *> *imageLayers;
	NSMutableArray <UIBezierPath *> *imagePaths;
	
	CALayer *topTextLayer, *bottomTextLayer;

	BOOL drawsHex;
	
	CGPoint CENTER;
	CGFloat HEXWIDTH, HEXSIDE, HEXHEIGHT;
}

#pragma mark -

- (void)layoutSubviews {
	
	if (WIDTH < 360) {
		CENTER = CGPointMake(self.center.x, self.center.y + 60);
		HEXWIDTH = WIDTH - 80;
	}
	else {
		CENTER = CGPointMake(self.center.x, self.center.y + 33);
		HEXWIDTH = WIDTH - 120;
	}
	
	HEXSIDE = (HEXWIDTH / sqrt(3));
	HEXHEIGHT = (HEXSIDE * 2);
	
	self.actualCenter = CENTER;
	
	CGPoint strpts[4] = {
		CGPointMake(CENTER.x + (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y - 2 * HEXWIDTH),
		CGPointMake(CENTER.x + (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y + 2 * HEXWIDTH),
		CGPointMake(CENTER.x - (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y + 2 * HEXWIDTH),
		CGPointMake(CENTER.x - (2 * sqrt(3) * HEXWIDTH)/3, CENTER.y - 2 * HEXWIDTH)
	};
	
	CGPoint strpts2[4] = {
		CGPointMake(0.8 * strpts[0].x, 0.8 * strpts[0].y),
		CGPointMake(0.8 * strpts[1].x, 0.8 * strpts[1].y),
		CGPointMake(0.8 * strpts[2].x, 0.8 * strpts[2].y),
		CGPointMake(0.8 * strpts[3].x, 0.8 * strpts[3].y)
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
		[imagePath0 moveToPoint:strpts2[0]];
		[imagePath0 addLineToPoint:entpts[3]];
		[imagePath0 addLineToPoint:hexpts[1]];
		
		UIBezierPath *imagePath1 = [UIBezierPath bezierPath];
		[imagePath1 moveToPoint:strpts2[1]];
		[imagePath1 addLineToPoint:entpts[1]];
		[imagePath1 addLineToPoint:hexpts[2]];
		
		UIBezierPath *imagePath2 = [UIBezierPath bezierPath];
		[imagePath2 moveToPoint:strpts2[2]];
		[imagePath2 addLineToPoint:entpts[0]];
		[imagePath2 addLineToPoint:hexpts[4]];
		
		UIBezierPath *imagePath3 = [UIBezierPath bezierPath];
		[imagePath3 moveToPoint:strpts2[3]];
		[imagePath3 addLineToPoint:entpts[4]];
		[imagePath3 addLineToPoint:hexpts[5]];
		
		imagePaths = [NSMutableArray arrayWithObjects:imagePath0, imagePath1, imagePath2, imagePath3, nil];
	}
	
	if (!topTextLayer) {
		topTextLayer = [CALayer layer];
		topTextLayer.frame = CGRectMake(0, 44, WIDTH, [self.hexPoints[0] CGPointValue].y - 44 - 10);
		[self.layer addSublayer:topTextLayer];
	}
	
	if (!bottomTextLayer) {
		bottomTextLayer = [CALayer layer];
		bottomTextLayer.frame = CGRectMake(0, [self.hexPoints[3] CGPointValue].y + 20, WIDTH, HEIGHT - [self.hexPoints[3] CGPointValue].y - 20);
		[self.layer addSublayer:bottomTextLayer];
	}
	
}

- (void)awakeFromNib {
	
	drawsHex = NO;
	
	if (WIDTH < 360) {
		CENTER = CGPointMake(self.center.x, self.center.y + 60);
		HEXWIDTH = WIDTH - 80;
	}
	else {
		CENTER = CGPointMake(self.center.x, self.center.y + 33);
		HEXWIDTH = WIDTH - 120;
	}
	
	HEXSIDE = (HEXWIDTH / sqrt(3));
	HEXHEIGHT = (HEXSIDE * 2);
	
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

#pragma mark -

- (void)drawRect:(CGRect)rect {
	
	[super drawRect:rect];
	
	// Pattern
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGSize patSize = CGSizeMake(PATTERN_SIZE, PATTERN_SIZE);
	
	UIGraphicsBeginImageContext(CGSizeMake(patSize.width * 2, patSize.height * 2));

	CGPoint pt0 = CGPointMake(0, 0);
	CGPoint pt1 = CGPointMake(2 * PATTERN_SIZE, 0);
	CGPoint pt2 = CGPointMake(2 * PATTERN_SIZE, 2 * PATTERN_SIZE);
	CGPoint pt3 = CGPointMake(0, 2 * PATTERN_SIZE);
	CGPoint ptc = CGPointMake(PATTERN_SIZE, PATTERN_SIZE);
	
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
	
	// Main drawing
	
	if (drawsHex) {
		[[UIColor oliveColor] setStroke];
		UIBezierPath *hexPath1 = [UIBezierPath bezierPath];
		[hexPath1 setLineWidth:0.5f];
		[hexPath1 moveToPoint:[self.hexPoints[0] CGPointValue]];
		[hexPath1 addLineToPoint:[self.hexPoints[2] CGPointValue]];
		[hexPath1 addLineToPoint:[self.hexPoints[4] CGPointValue]];
		[hexPath1 addLineToPoint:[self.hexPoints[0] CGPointValue]];
		[hexPath1 stroke];
		
		[[UIColor pastelBlueColor] setStroke];
		UIBezierPath *hexPath2 = [UIBezierPath bezierPath];
		[hexPath2 setLineWidth:0.5f];
		[hexPath2 moveToPoint:[self.hexPoints[3] CGPointValue]];
		[hexPath2 addLineToPoint:[self.hexPoints[1] CGPointValue]];
		[hexPath2 addLineToPoint:[self.hexPoints[5] CGPointValue]];
		[hexPath2 addLineToPoint:[self.hexPoints[3] CGPointValue]];
		[hexPath2 stroke];
	}
	
	[[UIColor antiqueWhiteColor] setFill];
	[UIColor.lightGrayColor setStroke];
	
	CGFloat bigCircleRadius = (WIDTH > 360.f)?60.f:48.f;
	
	UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CENTER radius:bigCircleRadius startAngle:0.f endAngle:2 * M_PI clockwise:YES];
	[circlePath fill];
	[circlePath stroke];

	if (WIDTH > 360) {
		[UIColor.darkGrayColor setStroke];
		for (NSInteger i = 0; i < 6; ++i) {
			[[UIColor honeydewColor] setFill];
			UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:[self.entryPoints[i] CGPointValue] radius:4.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
			[circlePath fill];
			[circlePath stroke];
		}
	}

	[UIColor.lightGrayColor setStroke];
	
	for (NSInteger i = 0; i < 6; ++i) {
		[[UIColor babyBlueColor] setFill];
		UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:[self.hexPoints[i] CGPointValue] radius:32.f startAngle:0.f endAngle:2 * M_PI clockwise:YES];
		[circlePath fill];
		[circlePath stroke];
	}
	
}

#pragma mark - Animate paths and views

- (void)animatePath {
	
	if (!animations) {
		animations = [NSMutableArray new];
		for (NSInteger i = 0; i < 4; ++i) {
			CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
			pathAnimation.duration = 3.5f;
			pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
			pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
			pathAnimation.autoreverses = YES;
			pathAnimation.removedOnCompletion = NO;
			pathAnimation.fillMode = kCAFillModeForwards;
			pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
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
			pathAnimation.duration = 2.3f;
			pathAnimation.removedOnCompletion = YES;
			pathAnimation.path = imagePaths[i].CGPath;
			pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
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
	
	UIButton *buttonK = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
	[buttonK setBackgroundImage:[UIImage imageNamed:@"Kartik"] forState:UIControlStateNormal];
	[buttonK setFrame:CGRectMake(0, 0, 64, 64)];
	[buttonK setCenter:[self.hexPoints[0] CGPointValue]];
	[buttonK setTag:4];
	[buttonK addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[buttonK setEnabled:NO];
	[self addSubview:buttonK];
	
	UIButton *buttonS = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
	[buttonS setBackgroundImage:[UIImage imageNamed:@"Sorte"] forState:UIControlStateNormal];
	[buttonS setCenter:[self.hexPoints[3] CGPointValue]];
	[buttonS setTag:5];
	[buttonS addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[buttonS setEnabled:NO];
	[self addSubview:buttonS];
	
	buttonK.transform = CGAffineTransformMakeScale(0, 0);
	buttonK.alpha = 0.0;
	
	buttonS.transform = CGAffineTransformMakeScale(0, 0);
	buttonS.alpha = 0.0;
	
	UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonC setBackgroundImage:[UIImage imageNamed:@"RevelsCircle"] forState:UIControlStateNormal];
	[buttonC setFrame:CGRectMake(0, 0, 120, 120)];
	[buttonC setCenter:CENTER];
	[buttonC setTag:10];
	[buttonC addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[buttonC setEnabled:NO];
	[self addSubview:buttonC];
	
	buttonC.transform = CGAffineTransformMakeScale(0, 0);
	buttonC.alpha = 0.0;

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		drawsHex = YES;
		[self setNeedsDisplay];
		[buttonK setEnabled:YES];
		[buttonS setEnabled:YES];
		[buttonC setEnabled:YES];
	});
	
	[UIView animateWithDuration:0.8 delay:3.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		buttonK.transform = CGAffineTransformIdentity;
		buttonK.alpha = 1.0;
		buttonS.transform = CGAffineTransformIdentity;
		buttonS.alpha = 1.0;
	} completion:^(BOOL finished) {
		if ([self.delegate respondsToSelector:@selector(finishedDeveloperAnimations)])
			[self.delegate finishedDeveloperAnimations];
		[UIView animateWithDuration:0.8 delay:1.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.6 options:UIViewAnimationOptionCurveEaseOut animations:^{
			buttonC.transform = CGAffineTransformIdentity;
			buttonC.alpha = 1.0;
		} completion:^(BOOL finished) {
			if ([self.delegate respondsToSelector:@selector(finishedAllAnimationsDoSomethingAwesome)])
				[self.delegate finishedAllAnimationsDoSomethingAwesome];
		}];
	}];
	
}

#pragma mark - Remove all animations and subviews

- (void)removeAllAnimations {
	
	drawsHex = NO;
	[self setNeedsDisplay];
	
	NSArray *subviews = self.subviews;
	for (NSInteger i = 0; i < subviews.count; ++i) {
		[subviews[i] removeFromSuperview];
	}
	
	NSArray *sublayers = self.layer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i) {
		[sublayers[i] removeAllAnimations];
	}
	
	sublayers = topTextLayer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i)
		[sublayers[i] removeFromSuperlayer];
	
	sublayers = bottomTextLayer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i)
		[sublayers[i] removeFromSuperlayer];
}

#pragma mark - Button actions

- (void)imageButtonPressed:(id)sender {
	if ([self.delegate respondsToSelector:@selector(hexagonalViewButtonPressedAtIndex:)]) {
		[self.delegate hexagonalViewButtonPressedAtIndex:[sender tag]];
	}
}

#pragma mark - Text drawing

- (void)drawTopText:(NSString *)text withAttributes:(NSDictionary *)attributes {
	
	[topTextLayer removeAllAnimations];
	
	NSArray *sublayers = topTextLayer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i)
		[sublayers[i] removeAllAnimations];
	
	UIBezierPath *path = [self bezierPathForText:text andAttributes:attributes];
						  
	CAShapeLayer *pathLayer = [CAShapeLayer layer];
	pathLayer.frame = topTextLayer.bounds;
	pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
	pathLayer.geometryFlipped = YES;
	pathLayer.path = path.CGPath;
	pathLayer.fillColor = nil;
	pathLayer.strokeColor = [[UIColor blackColor] CGColor];
	pathLayer.lineWidth = 0.8f;
	pathLayer.lineJoin = kCALineJoinBevel;
	
	[pathLayer removeAllAnimations];
	
	[topTextLayer addSublayer:pathLayer];
	
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.duration = 3.5f;
	pathAnimation.fromValue = @0.f;
	pathAnimation.toValue = @1.f;
	pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

	[pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
	
	/*
	
	CAShapeLayer *featherPathLayer = [CAShapeLayer layer];
	featherPathLayer.fillColor = nil;
	featherPathLayer.strokeColor = nil;
	featherPathLayer.contents = (id)[UIImage imageNamed:@"feather"].CGImage;
	featherPathLayer.path = path.CGPath;
	featherPathLayer.geometryFlipped = YES;
	featherPathLayer.bounds = featherPathLayer.frame = CGRectMake(30, 30, 30, 30);
	featherPathLayer.anchorPoint = CGPointMake(-1, -1);
	
	[featherPathLayer removeAllAnimations];
	
	[topTextLayer addSublayer:featherPathLayer];
	
	CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	penAnimation.duration = 6.0;
	penAnimation.path = featherPathLayer.path;
	penAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[penAnimation setCompletion:^(BOOL finished) {
		[featherPathLayer removeFromSuperlayer];
	}];
	[featherPathLayer addAnimation:penAnimation forKey:@"penAnimation"];
	 
	 */
	
}

- (void)drawBottomText:(NSString *)text withAttributes:(NSDictionary *)attributes {
	
	[bottomTextLayer removeAllAnimations];
	
	NSArray *sublayers = bottomTextLayer.sublayers;
	for (NSInteger i = 0; i < sublayers.count; ++i)
		[sublayers[i] removeAllAnimations];
	
	UIBezierPath *path = [self bezierPathForText:text andAttributes:attributes];
	
	CAShapeLayer *pathLayer = [CAShapeLayer layer];
	pathLayer.frame = bottomTextLayer.bounds;
	pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
	pathLayer.geometryFlipped = YES;
	pathLayer.path = path.CGPath;
	pathLayer.fillColor = nil;
	pathLayer.strokeColor = [[UIColor blackColor] CGColor];
	pathLayer.lineWidth = 0.4f;
	pathLayer.lineJoin = kCALineJoinRound;
	
	[pathLayer removeAllAnimations];
	
	[bottomTextLayer addSublayer:pathLayer];
	
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.duration = 3.5f;
	pathAnimation.fromValue = @0.f;
	pathAnimation.toValue = @1.f;
	pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	[pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

#pragma mark - Bezier path for text

- (UIBezierPath *)bezierPathForText:(NSString *)text andAttributes:(NSDictionary *)attributes {
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	
	CGMutablePathRef letters = CGPathCreateMutable();
	
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
	
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
	
	for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {

		CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
		CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), NSFontAttributeName);
		
		for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
			
			CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
			CGGlyph glyph;
			CGPoint position;
			CTRunGetGlyphs(run, thisGlyphRange, &glyph);
			CTRunGetPositions(run, thisGlyphRange, &position);
			
			{
				CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
				CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
				CGPathAddPath(letters, &t, letter);
				CGPathRelease(letter);
			}
		}
	}
	
	CFRelease(line);
	
	[path moveToPoint:CGPointZero];
	[path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
	
	CGPathRelease(letters);
	
	return path;
}


@end
