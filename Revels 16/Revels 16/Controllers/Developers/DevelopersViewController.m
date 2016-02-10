//
//  DevelopersViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/1/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DevelopersViewController.h"
#import "EasterEggViewController.h"
#import "DeveloperDetailView.h"
#import <KWTransition/KWTransition.h>

typedef NS_ENUM(NSUInteger, EasterEggController) {
	EasterEggControllerX,
	EasterEggControllerY,
	EasterEggControllerZ,
};

@interface DevelopersViewController () <DAHexagonalViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;

@end

@implementation DevelopersViewController {
	DeveloperDetailView *devDetailView;
	UITapGestureRecognizer *tapGestureRecognizer;
	
	CMMotionManager *motionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	self.hexagonalView = (DAHexagonalView *)self.view;
	self.hexagonalView.delegate = self;
	
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
	
	devDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DeveloperDetailView" owner:nil options:nil] firstObject];
	
	motionManager = [[CMMotionManager alloc] init];
	motionManager.deviceMotionUpdateInterval = 1.0/20.0;
	
	self.transition = [KWTransition manager];

}

- (void)viewDidAppear:(BOOL)animated {
	
	[self.hexagonalView animatePath];
}

- (void)viewWillDisappear:(BOOL)animated {

	[self.hexagonalView removeAllAnimations];
	
	[motionManager stopAccelerometerUpdates];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DAHexagonalViewDelegate

- (void)hexagonalViewButtonPressedAtIndex:(NSInteger)index {
	
	// Add a developer detail view
	
	if (index == 10)
		NSLog(@"Revels logo pressed");
	
	else if (index == 0) {
		[devDetailView setPersonName:@"Avikant Saini" personDetail:@"iOS Developer\nDu kan om du vil!" personImage:[UIImage imageNamed:@"Avikant"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[1] CGPointValue]];
	}
	
	else if (index == 3) {
		[devDetailView setPersonName:@"Yash Kumar Lal" personDetail:@"iOS Developer\nIngen kan ta ditt valg!" personImage:[UIImage imageNamed:@"Yash"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[5] CGPointValue]];
	}
	
	else if (index == 1) {
		[devDetailView setPersonName:@"Anuraag Baishya" personDetail:@"Android Developer\nBare plante tvil!" personImage:[UIImage imageNamed:@"Anuraag"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[2] CGPointValue]];
	}
	
	else if (index == 2) {
		[devDetailView setPersonName:@"Saketh Kaparthi" personDetail:@"Android Developer\nDet er så mange veier å gå" personImage:[UIImage imageNamed:@"Saketh"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[4] CGPointValue]];
	}
	
	else if (index == 4) {
		[devDetailView setPersonName:@"Kartik Arora" personDetail:@"Category Head\nMange mål som kan nåes om du våger!" personImage:[UIImage imageNamed:@"Kartik"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[0] CGPointValue]];
	}
	
	else if (index == 5) {
		[devDetailView setPersonName:@"Shubham Sorte" personDetail:@"Ultimate Bitcher\nÅ tro på at du har det som skal til" personImage:[UIImage imageNamed:@"Sorte"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[3] CGPointValue]];
	}
	
	[self.view addGestureRecognizer:tapGestureRecognizer];
	
}

- (void)finishedDeveloperAnimations {
	
	[self.hexagonalView drawTopText:@"REVELS'16" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:50.0]}];
	
//	CGFloat bottomTextSize = (SWdith > 360)?22.f:18.f;
//	[self.hexagonalView drawBottomText:@"DAASTAN | Everybody has a Story" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:bottomTextSize]}];
	
	// Start listening to motion
	
	[motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		
		if (fabs(accelerometerData.acceleration.x) > 2) {
//			printf("Acceletation.x = %.3f\n", accelerometerData.acceleration.x);
			[self presentEasterEggController:EasterEggControllerX];
		}
		
		if (fabs(accelerometerData.acceleration.y) > 2) {
//			printf("Acceletation.y = %.3f\n", accelerometerData.acceleration.y);
			[self presentEasterEggController:EasterEggControllerY];
		}
		
		if (fabs(accelerometerData.acceleration.z) > 2) {
//			printf("Acceletation.z = %.3f\n", accelerometerData.acceleration.z);
			[self presentEasterEggController:EasterEggControllerZ];
		}
		
	}];
	
}

- (void)finishedAllAnimationsDoSomethingAwesome {
	// ???
}

#pragma mark - Tap gesture handler

- (void)tapBackground:(UITapGestureRecognizer *)recognizer {
	[devDetailView dismissFromView:self.view];
	[self.view removeGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Navigation

- (void)presentEasterEggController:(EasterEggController)easterEggController {
	
	[motionManager stopAccelerometerUpdates];
	
	EasterEggViewController *eevc = [self.storyboard instantiateViewControllerWithIdentifier:@"EasterEggVC"];
	
	if (easterEggController == EasterEggControllerX) {
		eevc.lugText = @"Linux Users Group X";
		eevc.backgroundColor = [UIColor paleGreenColor];
	}
	else if (easterEggController == EasterEggControllerY) {
		eevc.lugText = @"Linux Users Group Y";
		eevc.backgroundColor = [UIColor palePurpleColor];
	}
	else if (easterEggController == EasterEggControllerZ) {
		eevc.lugText = @"Linux Users Group Z";
		eevc.backgroundColor = [UIColor babyBlueColor];
	}
	
	self.transition.style = KWTransitionStyleUp;
	[eevc setTransitioningDelegate:self];
	
	[self presentViewController:eevc animated:YES completion:nil];
	
}

#pragma mark - View controller animated transistioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																   presentingController:(UIViewController *)presenting
																	   sourceController:(UIViewController *)source {
	self.transition.action = KWTransitionStepPresent;
	return self.transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.transition.action = KWTransitionStepDismiss;
	return self.transition;
}

@end
