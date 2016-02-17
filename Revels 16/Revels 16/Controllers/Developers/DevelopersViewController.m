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
	EasterEggControllerX = 1,
	EasterEggControllerY = 2,
	EasterEggControllerZ = 3,
	EasterEggControllerF = 4,
};

typedef struct EasterEggPosition {
	EasterEggController pos1;
	EasterEggController pos2;
} EasterEggPos_t;

@interface DevelopersViewController () <DAHexagonalViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;

@end

@implementation DevelopersViewController {
	DeveloperDetailView *devDetailView;
	UITapGestureRecognizer *tapGestureRecognizer;
	
	CMMotionManager *motionManager;
	
	EasterEggPos_t eePos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
//	self.hexagonalView = (DAHexagonalView *)self.view;
	
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
	
	devDetailView = [[[NSBundle mainBundle] loadNibNamed:@"DeveloperDetailView" owner:nil options:nil] firstObject];
	
	motionManager = [[CMMotionManager alloc] init];
	motionManager.deviceMotionUpdateInterval = 1.0/20.0;
	
	self.transition = [KWTransition manager];
	
	eePos.pos1 = 0;
	eePos.pos2 = 0;

}

- (void)viewDidAppear:(BOOL)animated {
	
	self.hexagonalView.delegate = self;
	
	[self.hexagonalView animatePath];
	
}

- (void)viewWillDisappear:(BOOL)animated {

	[self.hexagonalView removeAllAnimations];
	
	[motionManager stopAccelerometerUpdates];
	
	self.hexagonalView.delegate = nil;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DAHexagonalViewDelegate

- (void)hexagonalViewButtonPressedAtIndex:(NSInteger)index {
	
	// Add a developer detail view
	
	devDetailView.actualCenter = self.hexagonalView.actualCenter;
	
	if (index == 10)
		NSLog(@"Revels logo pressed");
	
	else if (index == 0) {
		[devDetailView setPersonName:@"Avikant Saini" personDetail:@"iOS Developer\nIf I wanted a warm fuzzy feeling,\nI’d antialias my graphics!" personImage:[UIImage imageNamed:@"Avikant"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[1] CGPointValue]];
	}
	
	else if (index == 3) {
		[devDetailView setPersonName:@"Yash Kumar Lal" personDetail:@"iOS Developer\nWalking Contradiction." personImage:[UIImage imageNamed:@"Yash"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[5] CGPointValue]];
	}
	
	else if (index == 1) {
		[devDetailView setPersonName:@"Anuraag Baishya" personDetail:@"Android Developer\nStudent by day.\nDeveloper by night." personImage:[UIImage imageNamed:@"Anuraag"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[2] CGPointValue]];
	}
	
	else if (index == 2) {
		[devDetailView setPersonName:@"Saketh Kaparthi" personDetail:@"Android Developer\nPenguins love cold,\nthey won't survive the sun." personImage:[UIImage imageNamed:@"Saketh"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[4] CGPointValue]];
	}
	
	else if (index == 4) {
		[devDetailView setPersonName:@"Kartik Arora" personDetail:@"Category Head\nBugs come in through open Windows." personImage:[UIImage imageNamed:@"Kartik"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[0] CGPointValue]];
	}
	
	else if (index == 5) {
		[devDetailView setPersonName:@"Shubham Sorte" personDetail:@"Coordinator\nMac users swear by their Mac,\nPC users swear at their PC" personImage:[UIImage imageNamed:@"Sorte"]];
		[devDetailView showInView:self.view animatedFromAnchorPoint:[self.hexagonalView.hexPoints[3] CGPointValue]];
	}
	
	[self.view addGestureRecognizer:tapGestureRecognizer];
	
}

- (void)finishedDeveloperAnimations {
	
	[self.hexagonalView drawTopText:@"REVELS'16" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:50.0]}];
	
//	CGFloat bottomTextSize = (SWdith > 360)?22.f:18.f;
//	[self.hexagonalView drawBottomText:@"DAASTAN | Everybody has a Story" withAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Futura-Medium" size:bottomTextSize]}];
	
	// Start listening to motion
	
	eePos.pos1 = 0;
	eePos.pos2 = 0;
	
	[motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		
		if (fabs(accelerometerData.acceleration.x) > 2) {
//			printf("Acceletation.x = %.3f\n", accelerometerData.acceleration.x);
//			[self presentEasterEggController:EasterEggControllerX];
			if (eePos.pos1 == EasterEggControllerZ) {
				eePos.pos2 = EasterEggControllerX;
				[self presentEasterEggController:EasterEggControllerX];
			}
			else
				eePos.pos1 = EasterEggControllerX;
		}
		
		if (fabs(accelerometerData.acceleration.y) > 2) {
//			printf("Acceletation.y = %.3f\n", accelerometerData.acceleration.y);
//			[self presentEasterEggController:EasterEggControllerY];
			if (eePos.pos1 == EasterEggControllerX) {
				eePos.pos2 = EasterEggControllerY;
				[self presentEasterEggController:EasterEggControllerY];
			}
			else
				eePos.pos1 = EasterEggControllerY;
		}
		
		if (fabs(accelerometerData.acceleration.z) > 2) {
//			printf("Acceletation.z = %.3f\n", accelerometerData.acceleration.z);
//			[self presentEasterEggController:EasterEggControllerZ];
			if (eePos.pos1 == EasterEggControllerY) {
				eePos.pos2 = EasterEggControllerZ;
				[self presentEasterEggController:EasterEggControllerZ];
			}
			else
				eePos.pos1 = EasterEggControllerZ;
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

/*
#pragma mark - Force touch

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	if (touch.force > 2) {
		[self presentEasterEggController:EasterEggControllerF];
	}
	
}
 */

#pragma mark - Navigation

- (void)presentEasterEggController:(EasterEggController)easterEggController {
	
	[motionManager stopAccelerometerUpdates];
	
	EasterEggViewController *eevc = [self.storyboard instantiateViewControllerWithIdentifier:@"EasterEggVC"];
	
	if (easterEggController == EasterEggControllerX) {
		eevc.lugText = @"Linux Users Group";
		eevc.backgroundColor = [UIColor paleGreenColor];
		eevc.ptype = PresentationTypeXY;
	}
	else if (easterEggController == EasterEggControllerY) {
		eevc.lugText = @"Linux Users Group";
		eevc.backgroundColor = [UIColor palePurpleColor];
		eevc.ptype = PresentationTypeYZ;
	}
	else if (easterEggController == EasterEggControllerZ) {
		eevc.lugText = @"Linux Users Group";
		eevc.backgroundColor = [UIColor babyBlueColor];
		eevc.ptype = PresentationTypeZX;
	}
	else if (easterEggController == EasterEggControllerF) {
		eevc.lugText = @"Linux Users Group";
		eevc.backgroundColor = [UIColor lightCreamColor];
	}
	
	self.transition.style = KWTransitionStyleUp;
	[eevc setTransitioningDelegate:self];
	
	[self presentViewController:eevc animated:YES completion:nil];
	
}

- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
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
