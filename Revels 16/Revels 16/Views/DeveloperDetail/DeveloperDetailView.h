//
//  DeveloperDetailView.h
//  Revels 16
//
//  Created by Avikant Saini on 2/9/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeveloperDetailView : UIView

//@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personDetailLabel;

@property (nonatomic) CGPoint actualCenter;

- (void)setPersonName:(NSString *)personName personDetail:(NSString *)personDetail personImage:(UIImage *)personImage;

- (void)showInView:(UIView *)superview animatedFromAnchorPoint:(CGPoint)anchorPoint;
- (void)dismissFromView:(UIView *)superview;

@end
