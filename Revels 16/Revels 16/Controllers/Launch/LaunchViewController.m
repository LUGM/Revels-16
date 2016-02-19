//
//  LaunchViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/19/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "LaunchViewController.h"
#import <KWTransition/KWTransition.h>

@interface LaunchViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mainQuillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *miniQuillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *revelsImageView;

@property (strong, nonatomic) KWTransition *transition;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.miniQuillImageView.alpha = 0.0;
	self.revelsImageView.alpha = 0.0;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateLogo];
	});
	
	self.transition = [KWTransition manager];
	
}

- (void)animateLogo {
	
	[UIView animateWithDuration:0.8 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.mainQuillImageView.frame = self.miniQuillImageView.frame;
	} completion:^(BOOL finished) {
		
	}];
	
	[UIView animateWithDuration:0.7 delay:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.mainQuillImageView.alpha = 0.0;
		self.revelsImageView.alpha = 1.0;
	} completion:^(BOOL finished) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self loadTabBarController];
		});
	}];
	
}

- (void)loadTabBarController {
	
	UITabBarController *tabBarC = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//	self.view.window.rootViewController = tabBarC;
	
	self.transition.style = KWTransitionStylePushUp;
	
	[tabBarC setTransitioningDelegate:self];
	
	[self presentViewController:tabBarC animated:YES completion:nil];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
