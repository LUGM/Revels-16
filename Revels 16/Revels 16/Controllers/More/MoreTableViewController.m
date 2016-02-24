//
//  MoreTableViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/24/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "MoreTableViewController.h"
#import "RegisterWebViewController.h"
#import <KWTransition/KWTransition.h>
#import "AboutBackgroundView.h"

@interface MoreTableViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;

@property (nonatomic, strong) UIView *navBarBackgroundView;
@property (nonatomic, strong) UIView *tabBarBackgroundView;

@end

@implementation MoreTableViewController {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.transition = [KWTransition manager];
	
//	AboutBackgroundView *abv = [[AboutBackgroundView alloc] init];
//	abv.skewedBackground = YES;
//	self.tableView.backgroundView = abv;
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
	self.navigationController.view.backgroundColor = [UIColor clearColor];
	
	/*
	self.tabBarController.tabBar.barTintColor = [UIColor clearColor];
	self.tabBarController.tabBar.backgroundColor = [UIColor clearColor];
	self.tabBarController.tabBar.backgroundImage = [UIImage new];
	self.tabBarController.tabBar.shadowImage = [UIImage new];
	*/
	
	if (!self.navBarBackgroundView) {
		
		CGRect barRect = CGRectMake(0.0f, 0.0f, SWdith, 78.0f);
		
		self.navBarBackgroundView = [self.navigationController.view resizableSnapshotViewFromRect:barRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
		
		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		NSArray *colors = [NSArray arrayWithObjects:
						   (id)[[UIColor colorWithWhite:0.8 alpha:0] CGColor],
						   (id)[[UIColor colorWithWhite:1.0 alpha:1] CGColor],
						   nil];
		[gradientLayer setColors:colors];
		[gradientLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
		[gradientLayer setEndPoint:CGPointMake(0.0f, 0.7f)];
		[gradientLayer setFrame:[self.navBarBackgroundView bounds]];
		
		[[self.navBarBackgroundView layer] setMask:gradientLayer];
		[self.navigationController.view addSubview:self.navBarBackgroundView];
	}
	
	/*
	
	if (!self.tabBarBackgroundView) {
		
		CGRect barRect = CGRectMake(0.0f, SHeight - 56.f, SWdith, 56.0f);
		
		self.tabBarBackgroundView = [self.tabBarController.view resizableSnapshotViewFromRect:barRect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
		
		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
		NSArray *colors = [NSArray arrayWithObjects:
						   (id)[[UIColor colorWithWhite:0.8 alpha:0] CGColor],
						   (id)[[UIColor colorWithWhite:1.0 alpha:1] CGColor],
						   nil];
		[gradientLayer setColors:colors];
		[gradientLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
		[gradientLayer setEndPoint:CGPointMake(0.0f, 0.3f)];
		[gradientLayer setFrame:[self.tabBarBackgroundView bounds]];
		
		[self.tabBarBackgroundView setFrame:barRect];
		
		[[self.tabBarBackgroundView layer] setMask:gradientLayer];
		[self.navigationController.view addSubview:self.tabBarBackgroundView];
	}
	 
	 */
	
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	
	self.tabBarController.tabBar.barTintColor = nil;
	self.tabBarController.tabBar.backgroundColor = nil;
	self.tabBarController.tabBar.backgroundImage = nil;
	self.tabBarController.tabBar.shadowImage = nil;
	
}
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// Animate cells
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UINavigationController *navc;
	
	if (indexPath.section == 1) {
		
		// Register shit
		
		navc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVCNav"];
		
		RegisterWebViewController *rwvc = [navc.viewControllers firstObject];
		
		if (indexPath.row == 0) {
			rwvc.passedTitle = @"Register for Proshow";
			rwvc.passedURL = [NSURL URLWithString:@"http://proshow.mitportals.in"];
		}
		else if (indexPath.row == 1) {
			rwvc.passedTitle = @"Register for Revels'16";
			rwvc.passedURL = [NSURL URLWithString:@"http://register.mitportals.in/"];
		}
		
	}
	
	else if (indexPath.section == 2) {
		
		// About Revels
		
		navc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutVCNav"];
		
	}
	
	else if (indexPath.section == 3) {
		
		// Notifications
		
		navc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationsVCNav"];
		
	}
	
	else if (indexPath.section == 4) {
		
		// Favourites
		
		navc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavouritesVCNav"];
		
	}
	
	else if (indexPath.section == 5) {
		
		// Developers
		
		navc = [self.storyboard instantiateViewControllerWithIdentifier:@"DevelopersVCNav"];
		
	}
	
	self.transition.style = KWTransitionStyleFadeBackOver;
	
	[navc setTransitioningDelegate:self];
	
	[self.navigationController presentViewController:navc animated:YES completion:nil];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
