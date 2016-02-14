//
//  MoreViewController.m
//  Revels 16
//
//  Created by Avikant Saini on 2/14/16.
//  Copyright © 2016 LUG. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCollectionViewCell.h"
#import <KWTransition/KWTransition.h>

@interface MoreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) KWTransition *transition;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *revelsLogoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewSpacingConstraint;



@end

@implementation MoreViewController {
	NSArray *items;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	items = @[
			  @{
				  @"title": @"About",
				  @"image": @"aboutIcon"
				  },
			  @{
				  @"title": @"Register",
				  @"image": @"registerIcon"
				  },
			  @{
				  @"title": @"Favourites",
				  @"image": @"favouritesIcon"
				  },
			  @{
				  @"title": @"Developers",
				  @"image": @"developersIcon"
				  }
			  ];
	
	self.transition = [KWTransition manager];
	
	if (SHeight < 600) {
		[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
		self.navigationController.navigationBar.shadowImage = [UIImage new];
		self.navigationController.navigationBar.translucent = YES;
		self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
		self.navigationController.view.backgroundColor = [UIColor clearColor];
		self.revelsLogoTopConstraint.constant = -36;
		self.collectionViewBottomConstraint.constant = 8;
		self.collectionViewSpacingConstraint.constant = 0;
		self.collectionViewLeadingConstraint.constant = 22;
		self.collectionViewTrailingConstraint.constant = 22;
		if (SHeight < 500) {
			self.revelsLogoTopConstraint.constant = -48;
			self.collectionViewSpacingConstraint.constant = -36;
			self.collectionViewBottomConstraint.constant = -12;
		}
	}
	else {
		self.revelsLogoTopConstraint.constant = 20;
		self.collectionViewLeadingConstraint.constant = 32;
		self.collectionViewTrailingConstraint.constant = 32;
		self.collectionViewBottomConstraint.constant = 8;
		self.collectionViewSpacingConstraint.constant = 8;
	}
	
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	MoreCollectionViewCell *cell = (MoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"moreCell" forIndexPath:indexPath];
	
	cell.imageView.image = [UIImage imageNamed:[items[indexPath.row] objectForKey:@"image"]];
	cell.textLabel.text = [items[indexPath.row] objectForKey:@"title"];
	
	return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	
	cell.alpha = 0.0;
	cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
	
	[UIView animateWithDuration:0.3 delay:(indexPath.row * 0.3) options:UIViewAnimationOptionCurveEaseOut animations:^{
		cell.alpha = 1.0;
		cell.layer.transform = CATransform3DIdentity;
	} completion:nil];
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	UINavigationController *navc = [self.storyboard instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"%@VCNav", [items[indexPath.row] objectForKey:@"title"]]];
	
	self.transition.style = KWTransitionStyleFadeBackOver;
	
	[navc setTransitioningDelegate:self];
	
	[self.navigationController presentViewController:navc animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (SWdith < 360.f)
		return CGSizeMake(100, 120);
	else {
		if (SHeight > 700)
			return CGSizeMake(136, 160);
		return CGSizeMake(120, 150);
	}
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
