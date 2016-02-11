//
//  EventInfoView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/11/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "EventInfoView.h"

@implementation EventInfoView {
	REVEvent *evnt;
}

/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	[super drawRect:rect];
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	size_t gradLocationsNum = 2;
	CGFloat gradLocations[2] = {0.0f, 1.0f};
	CGFloat gradColors[8] = {0.7f, 0.8f, 0.6f, 0.2f, 0.2f, 0.0f, 0.0f, 0.5f};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
	CGColorSpaceRelease(colorSpace);
	
	CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
	float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
	
	CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
}
*/

- (void)awakeFromNib {
	
	self.bounds = CGRectMake(0, 0, SWdith - 32, SWdith - 32);
	self.contentView.frame = self.bounds;
	
}

- (void)fillUsingEvent:(REVEvent *)event {
	evnt = event;
	self.eventNameLabel.text = event.name.uppercaseString;
	self.eventDetailsTextView.text = event.detail;
	self.eventDetailsTextView.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14.f];
	self.eventDetailsTextView.textAlignment = NSTextAlignmentJustified;
	self.eventDateTimeLabel.text = [NSString stringWithFormat:@"%@ | %@", event.dateString, event.timeString];
	self.contactNameLabel.text = event.contactName;
}

- (IBAction)timeAction:(id)sender {
	
}

- (IBAction)phoneAction:(id)sender {
	NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", evnt.contactPhone]];
	[[UIApplication sharedApplication] openURL:phoneURL];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self dismiss];
}

- (void)showInView:(UIView *)superview {
	
	[superview addSubview:self];
	
	self.bounds = CGRectMake(0, 0, SWdith - 32, SWdith - 32);
	self.contentView.frame = self.bounds;
	self.center = superview.center;
	
	self.alpha = 0.0;
	
	CATransform3D transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
	transform = CATransform3DTranslate(transform, 0, superview.bounds.size.height/1.5, 0);
	
	self.layer.transform = transform;
//	self.layer.cornerRadius = 12.f;
	
	[UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.layer.transform = CATransform3DIdentity;
		self.alpha = 1.0;
	} completion:nil];
	
}

- (void)dismiss {
	
	[UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(0.8, 0.8, 0.8), 0, -400, 0);
		self.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
	
}

@end
