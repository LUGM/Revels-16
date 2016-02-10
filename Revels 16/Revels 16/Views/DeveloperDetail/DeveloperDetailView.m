//
//  DeveloperDetailView.m
//  Revels 16
//
//  Created by Avikant Saini on 2/9/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "DeveloperDetailView.h"
#import "UIImage+ImageEffects.h"

@implementation DeveloperDetailView {
	CGPoint lastAnchorPoint;
}

- (void)setPersonName:(NSString *)personName personDetail:(NSString *)personDetail personImage:(UIImage *)personImage {
	
	self.personNameLabel.text = personName;
	self.personDetailLabel.text = personDetail;
	self.personImageView.image = personImage;
	self.backgroundImageView.image = [personImage applyExtraLightEffect];
	
}

- (void)awakeFromNib {
	
	self.alpha = 0.0;
	
	self.layer.cornerRadius = 128.f;
	self.backgroundImageView.layer.cornerRadius = 128.f;
	
	self.frame = CGRectMake(0, 0, 256, 256);
	
	self.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
	
	self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:self.frame].CGPath;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOpacity = 1.f;
	self.layer.shadowRadius = 2.0;
//	self.layer.shadowOffset = CGSizeZero;
	
}

- (void)showInView:(UIView *)superview animatedFromAnchorPoint:(CGPoint)anchorPoint {
	
	self.center = anchorPoint;
	lastAnchorPoint = anchorPoint;
	
	[superview addSubview:self];
	[self layoutIfNeeded];
	
	self.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
	
	[UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.layer.transform = CATransform3DIdentity;
		self.alpha = 1.0;
		self.center = CGPointMake(superview.center.x, superview.center.y + 33);
	} completion:nil];
	
}

- (void)dismissFromView:(UIView *)superview {
	
	self.layer.transform = CATransform3DIdentity;
	self.alpha = 1.0;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.layer.transform = CATransform3DMakeScale(0, 0, 0);
		self.alpha = 0.5;
	} completion:^(BOOL finished) {
//		[self removeFromSuperview];
	}];
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
