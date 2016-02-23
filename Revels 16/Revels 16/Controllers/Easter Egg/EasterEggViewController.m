//
//  EasterEggViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/10/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "EasterEggViewController.h"
#import "AboutBackgroundView.h"
#import "UnderlinedLabel.h"
#import "DynamicLabel.h"

@interface EasterEggViewController ()

@property (weak, nonatomic) IBOutlet UnderlinedLabel *goBackLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lugImageView;

@property (weak, nonatomic) IBOutlet DynamicLabel *lugLabel;
@property (weak, nonatomic) IBOutlet UILabel *manipalLabel;

@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;

@property (weak, nonatomic) IBOutlet UIButton *githubButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *browserButton;


@end

@implementation EasterEggViewController {
	UISwipeGestureRecognizer *swipeGesture;
	UITapGestureRecognizer *tapGesture;
	
	NSArray *quotes;
	
	Reachability *reachability;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	quotes = [NSArray arrayWithObjects:
			  @"Computers are like air conditioners\nthey stop working when you open Windows.",
			  @"Microsoft is not the answer,\nMicrosoft is the question\nNO is the answer.",
			  @"Unix is user friendly.\nIt’s just selective about who its friends are.",
			  @"In a world without fences and walls,\nwho needs Gates and Windows?",
			  @"Avoid the Gates of Hell\nUse Linux.",
			  @"Those who don't understand Linux are doomed to reinvent it, poorly.",
			  @"It's a bird.. It's a plane.. No, it's KernelMan\nFaster than a speeding bullet, to your rescue.\nDoing new kernel versions in under 5 seconds flat!",
			  @"If Bill Gates is the Devil then\nLinus Torvalds must be the Messiah.",
			  @"Linux: the choice of a GNU generation.",
			  @"One OS to rule them all, One OS to find them.\nOne OS to call them all, And in salvation bind them.\nIn the bright land of Linux,\nWhere the hackers play.",
			  @"The Linux philosophy is 'laugh in the face of danger'.\nOops. Wrong one. 'Do it yourself'. That's it.",
			  @"Linux is a cancer that attaches itself in an\nintellectual property sense to everything it touches.",
			  @"My name is Linus, and I am your God.",
			  @"In real open source, you have the right to control your own destiny.",
			  nil];
	
	if (self.backgroundColor)
		self.view.backgroundColor = self.backgroundColor;
	
	if (self.centerImage)
		self.lugImageView.image = self.centerImage;
	
	if (!self.lugText) {
		self.lugText = @"L Li Lin Linu Linux Linux Linux U Us Use User Users Users Users G Gr Gro Grou Group Group Group M Ma Man Mani Manip Manipa Manipal Manipal Manipal";
	}
	self.lugLabel.text = self.lugText;
	
	if (!self.manipalText)
		self.manipalText = @"LUG Manipal";
	self.manipalLabel.text = self.manipalText;
	
	if (self.quote)
		self.quoteLabel.text = self.quote;
	else
		self.quoteLabel.text = [quotes objectAtIndex:arc4random_uniform((int)quotes.count)];
	
	swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:swipeGesture];
	
	if (self.ptype == PresentationTypeYZ) {
		tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		tapGesture.numberOfTapsRequired = 3;
		tapGesture.numberOfTouchesRequired = 3;
		[self.view addGestureRecognizer:tapGesture];
		[(AboutBackgroundView *)self.view jiggleBackground];
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateLUG];
		[self animateLabels];
	});
	
}

- (void)animateLabels {
	self.lugLabel.text = self.lugText;
	self.goBackLabel.text = @"Swipe down to go back";
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateLabels];
	});
}

- (void)animateLUG {
	[UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		self.lugImageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
		self.lugImageView.alpha = 0.9;
		if (self.ptype == PresentationTypeZX) {
			self.githubButton.transform = CGAffineTransformMakeTranslation(8, 0);
			self.facebookButton.transform = CGAffineTransformMakeTranslation(0, 8);
			self.browserButton.transform = CGAffineTransformMakeTranslation(-8, 0);
		}
		if (self.ptype == PresentationTypeXY) {
			self.githubButton.transform = CGAffineTransformMakeTranslation(-8, 0);
			self.facebookButton.transform = CGAffineTransformMakeTranslation(0, -8);
			self.browserButton.transform = CGAffineTransformMakeTranslation(8, 0);
		}
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
			self.lugImageView.transform = CGAffineTransformIdentity;
			self.lugImageView.alpha = 1.f;
			if (self.ptype == PresentationTypeXY || self.ptype == PresentationTypeZX) {
				self.githubButton.transform = CGAffineTransformIdentity;
				self.facebookButton.transform = CGAffineTransformIdentity;
				self.browserButton.transform = CGAffineTransformIdentity;
			}
		} completion:^(BOOL finished) {
			[self animateLUG];
		}];
	}];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
	[self openURLWithString:@"http://www.youtube.com/watch?v=gHi5VTnr9cg"];
}

#pragma mark - Social

- (void)openURLWithString:(NSString *)URLString {
	reachability = [Reachability reachabilityForInternetConnection];
	if (reachability.isReachable) {
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URLString]])
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
	else {
		SVHUD_FAILURE(@"No connection!");
	}
}

- (IBAction)githubAction:(id)sender {
	[self openURLWithString:@"https://github.com/LUGM"];
}

- (IBAction)facebookAction:(id)sender {
	[self openURLWithString:@"https://www.facebook.com/LUGManipal/"];
}

- (IBAction)websiteAction:(id)sender {
	[self openURLWithString:@"http://www.lugmanipal.org"];
}

@end
